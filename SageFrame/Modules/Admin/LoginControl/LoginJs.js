(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Admin/LoginControl/',
                 CompanyName: '',
                 Pan: ''

             }, p);
        var v = 0;
        var pinMatch = false;
        var userName = "";
        var password = "";
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "LoginWs.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {

            },
            init: function () {
                eventFunction.GetCompanyInfo();
                eventFunction.GetAllUserRoles();
                eventFunction.GetPinSettings();
                $("#HyperLink1").on("click", function () {
                    $("#PINbox").val("");
                    $('#PINcode').css('display','block');
                    $('p.login-userr, p.login-pass, .forget-pass, .cssClassPin, .sfButtonwrapper').css('display','none');
                    $('.cssClasstext').css('display','block');
                });

              
                $("#HyperLink2").on("click", function () {

                    $('p.login-userr, p.login-pass, .forget-pass, .cssClassPin, .sfButtonwrapper').css('display','block');
                    $('#PINcode').css('display','none');
                    $('.cssClasstext').css('display','none');


                });
                $('#pinpad').on('click', '.PINbutton', function () {
                    var v = $("#PINbox").val();
                    $("#PINbox").val(v + $(this).val());
                    var pin = $("#PINbox").val();
                    if (pin.length == 4) {
                        eventFunction.CheckPinCodeMatch(pin);
                        if (pinMatch) {
                            //alert("Hello world!");
                            $('#PINcode').css('display','none');
                            
                            $("#LoginButton").click();
                        }
                        else {
                            jAlert('pin not matched', 'Error!!', function () { $.alerts.dialogClass = null; $("#PINbox").focus(); });
                            //$('#popup_ok').focus();
                            $("#PINbox").val("");
                        }
                    }
                });

    

                $('body').on('keyup', function (e) {
                    var key = e.keyCode || e.which;
             
                    if (key >= 48 && key <= 57) {
                        var pin = $("#PINbox").val();
                        if (pin.length == 0)
                        {
                            pin = key - 48;
                           
                            $("#PINbox").val(pin);
                        }
                        if (pin.length == 4) {
                            eventFunction.CheckPinCodeMatch(pin);
                            if (pinMatch) {
                                //alert("Hello world!");
                                $('#PINcode').css('display', 'none');

                                $("#LoginButton").click();
                            }
                            else {
                                jAlert('pin not matched', 'Error!!', function () { $.alerts.dialogClass = null; $("#PINbox").focus(); });
                                $("#PINbox").val("");

                            }
                        };
                    }
                    else if(key >= 96 && key <= 105){
                        var pin = $("#PINbox").val();
                        if (pin.length == 0) {
                            pin = key - 96;

                            $("#PINbox").val(pin);
                        }
                        if (pin.length == 4) {
                            eventFunction.CheckPinCodeMatch(pin);
                            if (pinMatch) {
                                //alert("Hello world!");
                                $('#PINcode').css('display', 'none');

                                $("#LoginButton").click();
                            }
                            else {
                                jAlert('pin not matched', 'Error!!', function () { $.alerts.dialogClass = null; $("#PINbox").focus(); });
                                $("#PINbox").val("");

                            }
                        };
                    }
                    //$("#PINbox").focus();
                });

                
       
           
                $('#pinpad').on('click', '.clearpin', function () {
                    $("#PINbox").val("");
                });
                $('#pinpad').on('click', '.del', function () {
                    var v = $("#PINbox").val();
                    var newStr = v.substring(0, v.length - 1);
                    $("#PINbox").val(newStr);
                });
            },
            GetCompanyInfo: function () {
                eventFunction.config.method = "GetCompanyInfo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetAllUserRoles: function () {
                eventFunction.config.method = "GetAllUserRoles";
                eventFunction.config.url = SageFrameHostURL + "/Services/RestroWebService.asmx/" + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetPinSettings: function () {
                eventFunction.config.method = "GetPinSettings";
                eventFunction.config.url = SageFrameHostURL + "/Services/RestroWebService.asmx/" + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },
            CheckPinCodeMatch: function (PinCode) {
                eventFunction.config.method = "CheckPinCodeMatch";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    PinCode: PinCode
                });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: eventFunction.config.type,
                    contentType: eventFunction.config.contentType,
                    async: eventFunction.config.async,
                    cache: eventFunction.config.cache,
                    url: eventFunction.config.url,
                    data: eventFunction.config.data,
                    dataType: eventFunction.config.dataType,
                    success: eventFunction.ajaxSuccess,
                    error: eventFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 0:
                        window.localStorage.setItem("companyInfo", JSON.stringify(data.d));
                        break;
                    case 1:
                        
                        var result = data.d;
                        if (result.length > 0) {
                            pinMatch = true;
                            userName = result[0].userName;
                            password = result[0].password;
                            $("#HiddenField1").val(password);
                            $("#UserName").val(userName);
                            $("#Password").val(password);
                            //alert($("#HiddenField1").val());
                        }
                        else {
                            pinMatch = false;
                        }
                        break;
                    case 2:
                        window.localStorage.setItem("userRoles", data.d);
                        break;
                    case 3:
                        window.localStorage.setItem("rolePinSettings", data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);