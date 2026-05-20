(function ($) {
    var tabs = $("#tabs").tabs();
     {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROUSER/'
             }, p);
        var v = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 
                dataType: 'json',
                baseURL: p.ModulePath + "ROLoginWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MenuId: 0,
                Menuupdate: 0


            },
            InitialSetup: function () {

                //$("#MenuTable").hide();
                //$("#MenuButton").hide();
                //eventFunction.GetMenu();
                eventFunction.Login();
            },
            init: function () {
                //var jsonfile = 'Modules/ROUSER/RestrUser.Json';
                //var jsonText = jQuery.parseJSON(jsonfile);
                //var UserClass = {};

                //UserClass.userName = jsonText.username;
                //UserClass.password = jsonText.password;
                //$('#results').html('Plugin name: ' + json.name + '<br />Author: ' + json.author.name);
                eventFunction.InitialSetup();
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
                        break;
                    case 1:
                        jAlert('Inserted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });

                        break;
                    case 2:
                        jAlert('Updated successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        location.reload();
                        break;
                    case 3:
                        jAlert('Delete successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        var id = eventFunction.config.ID;
                        $("#" + id + "_").remove();
                        break;
                    case 4:
                        jAlert('Loggedin successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        //eventFunction.BindMenu(data);

                        break;
                        

                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            Login: function () {
                eventFunction.config.method = "CheckLogin";

                var jsonfile = 'Modules/ROUSER/RestrUser.Json';
                var jsonText = jQuery.parseJSON(jsonfile);
                var UserInf = {};

                UserInf.userName = jsonText.username;
                UserInf.password = jsonText.password;
                eventFunction.config.method = "LoginUser";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ UserInf: UserInf });
                //if (eventFunction.config.Menuupdate == 1) {
                //    eventFunction.config.ajaxCallMode = 2;
                //} else {
                //    eventFunction.config.ajaxCallMode = 1;
                //}
                eventFunction.ajaxCall(eventFunction.config);

            },
        };
        eventFunction.init();
    };
    //$.fn.companyProfEDIT = function (p) {
    //    $.companyProfcreate(p);
    //};
})(jQuery);
