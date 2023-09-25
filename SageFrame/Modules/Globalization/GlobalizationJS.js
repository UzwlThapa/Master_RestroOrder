
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Globalization/'
             }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0;
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "GlobalizationMenuService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0


            },
            InitialSetup: function () {
               eventFunction.Getlanguage();
            },


            init: function () {

                eventFunction.InitialSetup();
                eventFunction.GetMenuForGlobalization();
                $("#selLanguage").on('change', function () {
                    eventFunction.GetMenuForGlobalization();
                });

                $('#btnSave').on('click', function () {
                    eventFunction.SaveGlobalizedmenu();
                })

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
                        eventFunction.DropDownlanguage(data.d);
                        break;
                    case 1:
                        eventFunction.BindItemForGlobalize(data.d);
                        break;
                    case 2:
                        jAlert("Menu Saved Sucessfully");
                        break;

                }
            },
            ajaxFailure: function () {

            },



            Getlanguage: function () {
                eventFunction.config.method = "getLanguage";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetMenuForGlobalization: function () {
                var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                eventFunction.config.method = "getMenuForGlobalization";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ languageid: languageid });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SaveGlobalizedmenu: function () {
        
                var languageid = $("#selLanguage").val() == null ? 0 : $("#selLanguage").val();
                var Globalizedmenu = new Array();
                $.each($('#tableForMenu>tbody>tr'), function (index, row) {

                    var obj = new Object();
                    obj.ItemID = $(row).find('.itemid').text();
                    obj.LanguageID = $("#selLanguage").val();
                    obj.Text = $(row).find('.text').val();
                    Globalizedmenu.push(obj);

                });

                jConfirm('Do you want to send request?', 'Confirm!', function (confirm) {
                    if (confirm) {
                        eventFunction.config.method = "saveLanguageMenu";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ languageid: languageid, LanguageMenu: Globalizedmenu });
                        eventFunction.config.ajaxCallMode = 2;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            DropDownlanguage: function (result) {
                datas = JSON.parse(result);
                if (!datas) return;
                $("#selLanguage").html('');
                if (datas.length > 0) {
                    var htmls = '';
                   // htmls = "<option value='0' disabled selected>-All-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.LanguageID + "'>" + value.CultureName + "</option>";
                    });

                    $("#selLanguage").html(htmls);
                }

            },


            BindItemForGlobalize: function (data) {
                $("#divForGlobalMenu").html('');
                datas = JSON.parse(data);
                var htmls = "";
                htmls += "<table id='tableForMenu' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Item Name </th><th> Name </th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {

                        htmls += "<tr>";
                        htmls += "<td class='itemid' style='display:none;'>" + value.ITId+ "</td>";
                        htmls += "<td class='itemname' >" + value.ITName + "</td>";
                        htmls += "<td><input type='text' class='sfInputbox text' style='width:150px' value='"+ value.LanguageMenuText +"'/></td>";
                        htmls += "</tr>"
                    });

                } else {
                    htmls += "<tr>";
                    htmls += "<td Colspan=6 style='text-align:center;'> N0 Data Available</td>";
                    htmls += "</tr>"

                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#divForGlobalMenu').html(htmls);

                $(".text").dblclick(function () {
                    $(this).val('');
                });

            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
         
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);