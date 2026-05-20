var userRoles = JSON.parse(localStorage.getItem("userRoles"));
var pinSettings = JSON.parse(localStorage.getItem("rolePinSettings"));
var numpin = JSON.parse(localStorage.getItem("numpin"));
var disablePin = false;
var obj;
var value;
function checkUserPinSetting() {
    loop1:
    for (var i = 0; i < userRoles.length; i++) {
        if (userRoles[i].UserName == SageFrameUserName) {
            var roles = userRoles[i].Roles.split(',');
            loop2:
                for (var j = 0; j < roles.length; j++) {
                    loop3:
                        for (var k = 0; k < pinSettings.length; k++) {
                            if (roles[j] == pinSettings[k].Roles) {
                                if (pinSettings[k].DisablePin) {
                                    disablePin = true;
                                    break loop1;
                                }
                                break loop3;
                            }
                        }
                }
            break loop1;
            }
    }
}
function PinCodeSetup() {
    checkUserPinSetting();
    $('#pinpad').on('click', '.PINbutton', function () {
        pinfor = $('#hdnPinFor').val();
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
        }
        else if (key >= 96 && key <= 105) {
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
        //document.getElementById('PINbox').value = "";
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
                //pinMatch = true;
                //username = result;
            } else {
                $('#hdnPinMatch').val('false');
                $('#hdnPinBy').val('');
                //jAlert('pin not matched', "Alert!!", function () { $.alerts.dialogClass = null; });
                $("#PINbox").val("");
                $("#PINbox").focus();
                $("#pinError").show();
            }
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
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
            // autoOpen : false,
            width: 200,
             modal: true,
             dialogClass : 'numpadd',
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

//function input(e) {
//    var txtKotDiscount = document.getElementById("txtKotDiscount");
//    txtKotDiscount.value = txtKotDiscount.value + e.value;
//}

//function delet() {
//    var txtKotDiscount = document.getElementById("txtKotDiscount");
//    txtKotDiscount.value = txtKotDiscount.value.substr(0, txtKotDiscount.value.length - 1);
//}

