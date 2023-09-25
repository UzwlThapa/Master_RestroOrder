(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ChartOfAccount/VoucherType/webService/'
             }, p);
        var selectedIndex = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsVoucherType.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                VoucherTypeID: 0,
                VoucherTypeUpdate: 0
            },
            InitialSetup: function () {
                eventFunction.getVoucherTypeList();
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnCancel").click(function () {
                    $("#txtVoucherName").val("");
                    $("#txtPrefix").val("");
                    $(".MainForm").hide();
                    $("#btnAdd").show();
                    $("#divForVoucherTypeList").show();
                   // eventFunction.Reset();
                });

                $("#btnSave").click(function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid)
                        eventFunction.saveVoucherType();
                });
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
                        eventFunction.bindVoucherTypeList(data.d);
                        break;
                    case 1:
                        eventFunction.Reset();
                        jAlert('Saved Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        break;
                    case 2:
                        eventFunction.Reset();
                        jAlert('Deleted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        break;
                    case 3:
                        eventFunction.Reset();
                        jAlert('Updated Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            saveVoucherType: function () {
                var voucher = {
                    VoucherTypeID: eventFunction.config.VoucherTypeID,
                    VoucherName: $("#txtVoucherName").val(),
                    Prefix: $("#txtPrefix").val(),
                    AddedBy: SageFrameUserName,
                }
                eventFunction.config.method = "saveVoucherType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ voucher: voucher });
                if (eventFunction.config.VoucherTypeUpdate == 1)
                    eventFunction.config.ajaxCallMode = 3;
                else
                    eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getVoucherTypeList: function () {
                eventFunction.config.method = "getVoucherTypeList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindVoucherTypeList: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                var sn = 1;
                htmls += '<table class="sfGridwrapper tableForlist"><thead><tr><th class="sfEdit">S.N.</th><th>VoucherName</th><th class="sfEdit tdcenter">Edit</th><th class="sfDelete tdcenter">Delete</th></tr></thead><tbody>'
                $.each(data, function (index, value) {
                    var voucherid = value.VoucherTypeID;
                    htmls += '<tr><td>' + sn + '</td>';
                    htmls += '<td>' + value.VoucherName + ' ( ' + value.Prefix + ' )</td>';
                    if (voucherid == 2 || voucherid == 3 || voucherid == 16 || voucherid == 25)
                    {
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                    }
                    else {
                        htmls += '<td class="tdcenter"><label id="' + value.VoucherTypeID + '+' + value.VoucherName + '+' + value.Prefix + '" class="edit icon-edit" value="Edit"></label></td>'
                        htmls += '<td class="tdcenter"><label id="' + value.VoucherTypeID + '" class="delete icon-delete" value="Delete"></label></td></tr>';
                    }

                    sn++;
                });
                htmls += '</tbody></table>';
                $("#divForVoucherTypeList").html(htmls);
                $(".tableForlist").dataTable({
                    "scrollCollapse": true,
                    "jQueryUI": true,
                    "bAutoWidth": false
                });

                $(".tableForlist").on('click', '.delete', function () {
                        var datas = $(this).attr('id');
                        var username = SageFrameUserName;
                        jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                            if (confirmed) {

                                eventFunction.config.method = "deleteVoucherTypeByID";
                                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                eventFunction.config.data = JSON2.stringify({ VoucherTypeID: datas, username: username });
                                eventFunction.config.ajaxCallMode = 2;
                                eventFunction.ajaxCall(eventFunction.config);
                            }
                        });
                });
                $(".tableForlist").on('click', '.edit', function () {
                   // if (confirm("Edit! Are You Sure?"))
                    {
                        var datas = $(this).attr('id');
                        //var row = $(this).parents('tr');
                        //var data = row.find('td:eq(1)').text()
                        var word = datas.split("+");
                        $("#txtVoucherName").val(word[1]);
                        $("#txtPrefix").val(word[2]);
                        eventFunction.config.VoucherTypeID = word[0];
                        eventFunction.config.VoucherTypeUpdate = 1;
                        window.scrollTo(0, 0);

                        $("#btnSave").text("Update");
                        $(".MainForm").show();
                        $("#btnAdd").hide();
                        $("#divForVoucherTypeList").hide();
                    }
                });
            },
            Reset: function () {
                //window.location.reload();
                eventFunction.InitialSetup();
                $("#txtVoucherName").val("");
                $("#txtPrefix").val("");
                $(".MainForm").hide();
                $("#btnAdd").show();
                $("#divForVoucherTypeList").show();
                eventFunction.config.VoucherTypeID = 0;
                eventFunction.config.VoucherTypeUpdate = 0;
                $("#btnSave").text("Save");
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        VoucherName: {
                            required: true,
                        },
                        Prefix: {
                            required: true,
                        }
                    },
                    messages: {
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