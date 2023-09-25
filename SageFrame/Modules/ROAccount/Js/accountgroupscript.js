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
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ROAccountGroup.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                AccountGroupId: 0,
                AccountGroupupdate: 0


            },
            InitialSetup: function () {

                $("#AccountGroupTable").hide();
                $("#AccountGroupButton").hide();
                eventFunction.GetAccountGroup();

            },
            init: function () {

                eventFunction.InitialSetup();

                $("#AddAccountGroup").on('click', function () {
                    $("#AccountGroupTable").show(1000);
                    $("#AccountGroupButton").show(1000);
                    $("#AddAccountGroup").hide(1000);

                });
                $("#btnAccountGroupCancel").on('click', function () {
                    $("#AccountGroupTable").hide(1000);
                    $("#AccountGroupButton").hide(1000);
                    $("#AddAccountGroup").show(1000);
                    eventFunction.ResetAll();
                });
                $("#btnAccountGroupSave").on('click', function () {

                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.AccountGroupSave();
                        eventFunction.GetAccountGroup();
                        $("#AccountGroupTable").hide(1000);
                        $("#AccountGroupButton").hide(1000);
                        $("#AddAccountGroup").show(1000);
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
                        eventFunction.ResetAll();

                        break;
                    case 2:
                        jAlert('Updated Successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();

                        break;
                    case 3:
                        jAlert('Delete Successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        var id = eventFunction.config.ID;
                        $("#" + id + "_").remove();
                        break;
                    case 4:
                        eventFunction.BindAccountGroup(data);
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

            AccountGroupSave: function () {
                var AccountGroupInf = {};

                AccountGroupInf.AccountId = eventFunction.config.AccountGroupId;
                AccountGroupInf.AccountCode = $('#txtCode').val();
                AccountGroupInf.AccountName = $('#txtName').val();
                
                AccountGroupInf.Type = parseInt($('#ddlType').val());
                AccountGroupInf.Schedule = $('#txtSchedule').val();
                eventFunction.config.method = "AccountGroupSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ AccountGroupInf: AccountGroupInf });

                if (eventFunction.config.AccountGroupupdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ID = 0;
                eventFunction.config.AccountGroupupdate = 0;
            },
            GetAccountGroup: function () {
                eventFunction.config.method = "GetAccountGroupfromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteAccountGroup: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var AccountGroupID = id;
                eventFunction.config.method = "AccountGroupDelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ AccountGroupID: AccountGroupID });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>


            BindAccountGroup: function (data) {
                $("#accountgroupdata").show();
                $("#accountgroupdata").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='accountgrouptable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Code</th><th>Name</th><th>Type</th><th>Schedule</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.AccountGroupID + "_>";
                        htmls += "<td>" + value.AccountName + "</td>";
                        htmls += "<td>" + value.AccountCode + "</td>";
                        htmls += "<td>" + value.Schedule + "</td>";
                        htmls += "<td>" + value.Type + "</td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='AccountGroupEdit'  type='button'  id='" + value.AccountGroupID + "_" + value.AccountName + "_" + value.AccountCode + "_" + value.Schedule + "_" + value.type + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='AccountGroupDelete' type='button'  id=_" + value.AccountGroupID + " value='Delete' /></td></tr>";
                        htmls += "</tr>"

                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#accountgroupdata').html(htmls);
                    $('#accountgrouptable').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });

                } else {
                    $('#accountgroupdata').html('No data');
                }
                $(".AccountGroupEdit").on('click', function () {
                    $("#AccountGroupTable").show();
                    $("#AccountGroupButton").show();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    eventFunction.config.AccountGroupId = words[0];
                    $("#txtCode").val(words[1]);
                    $("#txtName").val(words[1]);
                    $("#txtSchedule").val(words[1]);
                    $("#txtType").val(words[1]);
                    eventFunction.config.AccountGroupupdate = 1;

                });
                $(".AccountGroupDelete").on('click', function () {
                    eventFunction.DeleteAccountGroup(this);
                    eventFunction.ResetAll();
                });

            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //AccountGroup
                $('#textAccountGroup').val('');
                eventFunction.config.ID = 0;
                eventFunction.config.AccountGroupupdate = 1;
                $("#AccountGroupTable").hide();
                $("#AccountGroupButton").hide();
                eventFunction.GetAccountGroup();
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        txtCode: {
                            required: true,
                        },

                    },
                    messages: {
                        textAccountGroup: {
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