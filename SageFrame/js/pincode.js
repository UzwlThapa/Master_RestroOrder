var userRoles = JSON.parse(localStorage.getItem("userRoles"));
var pinSettings = JSON.parse(localStorage.getItem("rolePinSettings"));
var numpin = JSON.parse(localStorage.getItem("numpin"));
var disablePin = false;   // default stays fail-closed: PIN dialog shows unless proven unnecessary
var obj;
var value;

var PIN_SETTINGS_MAX_RETRIES = 7;
var PIN_SETTINGS_RETRY_DELAY_MS = 400;

function resolvePinRoleMatch(roles, pinConfig) {
    // Returns true if this role should have PIN disabled, false otherwise.
    // Never throws — malformed entries are skipped, not fatal.
    if (!roles || !pinConfig) return false;

    for (var j = 0; j < roles.length; j++) {
        for (var k = 0; k < pinConfig.length; k++) {
            if (!pinConfig[k]) continue;
            if (roles[j] == pinConfig[k].Roles) {
                if (pinConfig[k].DisablePin) return true;
                break; // matched this role's pin-setting row, but PIN stays required
            }
        }
    }
    return false;
}

function checkUserPinSetting(attempt) {
    attempt = attempt || 1;

    // Re-read fresh each attempt in case another script (e.g. GetPinSettings)
    // populated localStorage after this file first loaded.
    var currentRoles = JSON.parse(localStorage.getItem("userRoles"));
    var currentPinSettings = JSON.parse(localStorage.getItem("rolePinSettings"));

    if (!currentRoles || !currentPinSettings) {
        console.warn('PIN settings not available yet (attempt ' + attempt + '/' + PIN_SETTINGS_MAX_RETRIES + ')');
        if (attempt < PIN_SETTINGS_MAX_RETRIES) {
            setTimeout(function () { checkUserPinSetting(attempt + 1); }, PIN_SETTINGS_RETRY_DELAY_MS);
        } else {
            console.warn('PIN settings still unavailable after retries — defaulting to PIN required.');
            disablePin = false; // explicit: fail closed, no silent bypass
        }
        return;
    }

    // Keep module-level vars in sync for any other code that reads them directly.
    userRoles = currentRoles;
    pinSettings = currentPinSettings;

    var userEntry = null;
    for (var i = 0; i < currentRoles.length; i++) {
        if (currentRoles[i] && currentRoles[i].UserName == SageFrameUserName) {
            userEntry = currentRoles[i];
            break;
        }
    }

    if (!userEntry) {
        disablePin = false; // user not found in role list — fail closed, not a silent skip
        return;
    }

    var roles = userEntry.Roles ? userEntry.Roles.split(',') : [];
    disablePin = resolvePinRoleMatch(roles, currentPinSettings);
}

function PinCodeSetup() {
    checkUserPinSetting();
    $('#pinpad').on('click', '.PINbutton', function () {
        var pinfor = $('#hdnPinFor').val();
        var v = $("#PINbox").val();
        $("#PINbox").val(v + $(this).val());
        var pin = $("#PINbox").val();
        if (pin.length == 4) {
            CheckPinCodeMatch(pin);
        } else {
            $("#PINbox").focus();
        }
    });

    $('#PINbox').on('keyup', function (e) {
        var key = e.keyCode || e.which;
        var pin = $("#PINbox").val();
        if (key >= 48 && key <= 57) {
            if (pin.length == 0) {
                pin = key - 48;
                $("#PINbox").val(pin);
            }
        } else if (key >= 96 && key <= 105) {
            if (pin.length == 0) {
                pin = key - 96;
                $("#PINbox").val(pin);
            }
        }
        if (pin.length == 4) {
            CheckPinCodeMatch(pin);
        } else {
            $("#PINbox").focus();
        }
    });

    $('#pinpad').on('click', '.clearpin', function () {
        $("#PINbox").val("");
        $("#PINbox").focus();
    });
    $('#pinpad').on('click', '.del', function () {
        var v = $("#PINbox").val();
        var newStr = v.substring(0, v.length - 1);
        $("#PINbox").val(newStr);
        $("#PINbox").focus();
    });
}

function InitializePin() {
    $("#pinError").hide();
    if (disablePin) {
        $('#hdnPinMatch').val('true');
        $('#hdnPinBy').val(SageFrameUserName);
        $('#hdnPinMatch').change();
    } else {
        $("#PINbox").val("");
        $('#PINcode').dialog({
            'title': 'Enter PIN Code',
            width: 250,
            modal: true,
            position: ['center', 'center'],
        });
    }
}

function CheckPinCodeMatch(pin) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebService.asmx/CheckPinCodeMatch",
        data: JSON.stringify({ PinCode: pin, username: SageFrameUserName }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            if (result != null) {
                $('#PINcode').dialog('destroy');
                $('#hdnPinMatch').val('true');
                $('#hdnPinBy').val(result);
                $('#hdnPinMatch').change();
            } else {
                $('#hdnPinMatch').val('false');
                $('#hdnPinBy').val('');
                $("#PINbox").val("");
                $("#PINbox").focus();
                $("#pinError").show();
            }
        },
        error: function (xhr, status, err) {
            console.error('CheckPinCodeMatch failed:', status, err, xhr.responseText);
            jAlert("Sorry, an error occurred. Contact support.", "Error!!");
            $("#PINbox").val("");
            $("#pinError").show();
        }
    });
}

function InitializeNumPin(object, valv) {
    obj = object;
    value = valv;
    var pin = numpin;
    if (pin == true) {
        $('#nummpad').dialog({
            'title': 'Enter Number',
            width: 200,
            modal: true,
            dialogClass: 'numpadd',
            position: ['center', 'center'],
        });
        $("#numbox").val('');
    }
}

function NumCodeSetup() {
    $('#nummpad').on('click', '.PINbutton', function () {
        var v = $("#numbox").val();
        $("#numbox").val(v + $(this).val());
        var pin = $("#numbox").val();
    });

    $('#nummpad').on('click', '.Okaypin', function () {
        $(obj).val($("#numbox").val());
        $(obj).keypress();
        $(obj).keyup();
        $(obj).change();

        $("#numbox").val("");
        $('#nummpad').dialog('close');
    });

    $('#numbox').on('keyup', function (e) {
        if (e.keyCode == 13) {
            $(obj).val($("#numbox").val());
            $(obj).keypress();
            $(obj).keyup();
            $(obj).change();

            $("#numbox").val("");
            $('#nummpad').dialog('close');
        }
    });

    $('#nummpad').on('click', '.del', function () {
        var v = $("#numbox").val();
        var newStr = v.substring(0, v.length - 1);
        $("#numbox").val(newStr);
        $("#numbox").focus();
    });
}