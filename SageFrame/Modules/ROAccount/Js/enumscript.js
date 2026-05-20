(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROAccount/'
             }, p);
        var v = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ROEnumWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                EnumId: 0,
                Enumupdate: 0


            },
            InitialSetup: function () {

                $("#EnumTable").hide();
                $("#EnumButton").hide();
                eventFunction.GetEnum();

            },
            init: function () {

                eventFunction.InitialSetup();

                $("#AddEnum").on('click', function () {
                    $("#EnumTable").show(1000);
                    $("#EnumButton").show(1000);
                    $("#AddEnum").hide(1000);

                });
                $("#btnEnumCancel").on('click', function () {
                    $("#EnumTable").hide(1000);
                    $("#EnumButton").hide(1000);
                    $("#AddEnum").show(1000);
                    eventFunction.ResetAll();
                });
                $("#btnEnumSave").on('click', function () {

                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.EnumSave();
                        eventFunction.GetEnum();
                        $("#EnumTable").hide(1000);
                        $("#EnumButton").hide(1000);
                        $("#AddEnum").show(1000);
                        eventFunction.ResetAll();
                    }
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
                        break;
                    case 1:
                        jAlert('Inserted Successfully', "Information!!", function () { $.alerts.dialogClass = null; });

                        break;
                    case 2:
                        jAlert('Updated Successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        location.reload();
                        break;
                    case 3:
                        jAlert('Delete Successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        var id = eventFunction.config.ID;
                        $("#" + id + "_").remove();
                        break;
                    case 4:
                        eventFunction.BindEnum(data);
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

            EnumSave: function () {
                var EnumInf = {};

                EnumInf.EnumID = eventFunction.config.EnumId;
                EnumInf.EnumName = $('#textEnum').val();
                eventFunction.config.method = "EnumSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ EnumInf: EnumInf });

                if (eventFunction.config.Enumupdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.Enumupdate = 0;
            },
            GetEnum: function () {
                eventFunction.config.method = "GetEnumfromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteEnum: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var EnumID = id;
                eventFunction.config.method = "EnumDelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ EnumID: EnumID });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>


            BindEnum: function (data) {
                $("#enumdata").show();
                $("#enumdata").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='enumtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Enum</th><th>Enum</th><th>Enum</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.EnumID + "_>";
                        htmls += "<td>" + value.EnumName + "</td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='EnumEdit'  type='button'  id='" + value.EnumID + "_" + value.EnumName + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='EnumDelete' type='button'  id=_" + value.EnumID + " value='Delete' /></td></tr>";
                        htmls += "</tr>"

                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#enumdata').html(htmls);
                    $('#enumtable').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });

                } else {
                    $('#enumdata').html('No data');
                }
                $(".EnumEdit").on('click', function () {
                    $("#EnumTable").show();
                    $("#EnumButton").show();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    eventFunction.config.EnumId = words[0];
                    $("#textEnum").val(words[1]);
                    eventFunction.config.Enumupdate = 1;

                });
                $(".EnumDelete").on('click', function () {
                    eventFunction.DeleteEnum(this);
                    eventFunction.ResetAll();
                });

            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Enum
                $('#textEnum').val('');
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        textEnum: {
                            required: true,
                        },

                    },
                    messages: {
                        textEnum: {
                            number: '*'
                        },
                    },
                });
                if (v.form()) {
                    return true;
                }
                else
                    return false;
            },


        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
