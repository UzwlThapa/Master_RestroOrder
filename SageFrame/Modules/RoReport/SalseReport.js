
var IncludeBillCancel = false;
var IncludeSalesReturn = false;


function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#DailyReport').clone();
    contents.find('tr th:nth-child(14), tr td:nth-child(14)').remove();
    $('#printedDate').hide();
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    frameDoc.document.write('<html><head><title></title>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents.get(0).innerHTML);
    frameDoc.document.write('</body>');
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
}
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/RoReport/',
                CompanyName: '',
                Pan: ''

            }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0;
        var IsPaid = false;
        var d = 0;
        var inWord = "";
        var logoInfo = "";
        var body = "";
        var checks = [];
        var companyNames = "";
        var terms = 0;
        var netAmount = 0;
        var totalamount = 0;
        var salesReport = [];
        var salesId = 0;
        var userRole = "";
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "SalesReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.GetUserName();
                eventFunction.GetOrderType();
                $("#DailyReport").on("click", ".btnCancelBill", function () {
                    $('#hdnPinFor').val('CancelBill');
                    InitializePin();
                    salesId = $(this).attr('id');
                });

                $("#DailyReport").on("click", ".btnEditCustomer", function () {
                    $('#hdnPinFor').val('EditBill');
                    InitializePin();
                    salesId = $(this).attr('id').split('_')[0];

                });

                $("#selSalesReturn").on('click', function (){
                    var c = $(this).is(':checked');
                    if (c) {
                        IncludeSalesReturn = true;
                    } else {
                        IncludeSalesReturn = false;
                    }
                    $("#StartEndReportView").trigger('click');
                })

                $("#selBillCancel").on('click', function () {
                    var c = $(this).is(':checked');
                    if (c) {
                        IncludeBillCancel = true;
                    } else {
                        IncludeBillCancel = false;
                    }
                    $("#StartEndReportView").trigger('click');
                })

                
                

                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'CancelBill') {
                            $("#txtCancelWithReason").val("");
                            var ids = salesId;
                            var userName = $('#hdnPinBy').val();
                            var nepaliDate = formatDate();
                            $('.CancelWithReason').dialog(
                                {
                                    'title': 'Give Reasons',
                                    'dialogClass': 'giveReason',
                                    "resize": "auto",
                                    width: 350,
                                    modal: true,
                                    buttons: {
                                        "Bill Cancel": function () {
                                            var myStr = $("#txtCancelWithReason").val();
                                            var newStr = myStr.replace(/  +/g, ' ');
                                            if (newStr.length <= 4) {
                                                jAlert('Please Insert Valid Cancel Reason.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                            } else {
                                                var reason = $("#txtCancelWithReason").val();
                                                eventFunction.config.method = "CancelBill";
                                                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                                eventFunction.config.data = JSON2.stringify({ id: ids, userName: userName, reason: reason, date: nepaliDate, restoreOrder: true });
                                                eventFunction.config.data = eventFunction.config.data;
                                                eventFunction.config.ajaxCallMode = 6;
                                                eventFunction.ajaxCall(eventFunction.config);
                                                $(this).dialog('close');
                                                //eventFunction.GetBill(ids);
                                                //$('#btnPrints').click();
                                            }
                                        },
                                        
                                        Cancel: function () {
                                            $(this).dialog('close');
                                        }
                                    }
                                });
                        }
                        if (pinFor == 'EditBill') {
                            eventFunction.EditCustomer(salesId);
                        }
                    }
                });

                PinCodeSetup();
                NumCodeSetup();

                $("#btnPay").unbind('click').on("click", function () {
                    //var checkValid = companyProf.ValidationForm();
                    if ($("#selPayMode").val() != "" && $("#selPayMode").val() != null) {
                        if ($('#selPayMode').val() == 1) {
                            if (parseInt($('#hdnCusID').val() > 0)) {
                                eventFunction.UpdateTotalCashPaid();
                            }
                            eventFunction.UpdateSalesPayMode();
                        }
                        if ($('#selPayMode').val() == 2) {
                            if ($('#txtCheqNo').val() != null && $('#txtCheqNo').val() != "") {
                                if (parseInt($('#hdnCusID').val() > 0)) {
                                    eventFunction.UpdateTotalCashPaid();
                                }
                                eventFunction.UpdateSalesPayMode();
                            } else {
                                jAlert('Empty Cheque No.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                            }
                        }
                        if ($('#selPayMode').val() == 3) {
                            if ($('#txtTransNo').val() != null && $('#txtTransNo').val() != "") {
                                if (parseInt($('#hdnCusID').val() > 0)) {
                                    eventFunction.UpdateTotalCashPaid();
                                }
                                eventFunction.UpdateSalesPayMode();
                            } else {
                                jAlert('Empty Transaction No.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                            }
                        }
                    } else {
                        //companyProf.SaveAmount();
                        jAlert('Select Payment Mode.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });
                $('#membeshipformlist').on('dialogclose', function () {
                    $("#selPayMode").val(1).change();
                });
                $('#membeshipformlist2').on('dialogclose', function () {
                    $("#selPayMode").val(1).change();
                });

                $("#btnviewreport").on('click', function () {
                    d = -1;
                    eventFunction.SalesRecord();
                });
                $("#btnviewreportR").on('click', function () {
                    d = 1;
                    eventFunction.SalesRecord();
                });
                $("#DailyReport").on("click", ".btnViewBill", function () {

                    var ids = $(this).attr('id').split("_");
                    if (ids[3] == "") {
                        eventFunction.GetBill(ids[0]);
                    } else {
                        eventFunction.GetCakeBill(ids[0], ids[3]);
                    }

                    IsPaid = (parseInt(ids[1]) > 0 ? true : false);
                    if (!IsPaid && ids[2] != 1)
                        $('#btnPayBill').show();
                    else
                        $('#btnPayBill').hide();
                    $('#InvoiceType').html('INVOICE');

                });



                $(".DatePick").datepicker({
                    dateFormat: "yy-mm-dd"
                }).datepicker("setDate", "0");



                $("#txtMonthlyDate").datepicker({
                    dateFormat: 'yy-m',
                });

                $(".hide").hide();

                for (i = new Date().getFullYear(); i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }


                for (var i = 0; i < 60; i++) {
                    $('.Min').append($('<option/>').val(i).html(i));
                }
                for (var i = 0; i < 24; i++) {
                    $('.Hour').append($('<option/>').val(i).html(i));
                }

                for (i = new Date().getFullYear(); i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }


                $("#EndHour").val(23);
                $("#EndMin").val(59);

            },
            init: function () {

                eventFunction.InitialSetup();
                //----------------------------------------Master----------------
                $("#btnSaleByBillNo").click(function () {
                    var startBillNo = $("#startBillNo").val();
                    var EndBillNo = $("#EndBillNo").val();
                    if (EndBillNo < startBillNo) {
                        jAlert('End Bill should be Greater than Start Bill.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        $("#startBillNo").val("");
                        $("#EndBillNo").val("");
                    } else {
                        eventFunction.SaleReportByBillNo();
                    }
                });

                //$("#EndBillNo").keyup(function (event) {
                //    var startBillNo = $("#EndBillNo").val();
                //    var EndBillNo = $("#EndBillNo").val();
                //    var totalsum = TotalAmount;
                //    if (EndBillNo < startBillNo) {
                //        $("#EndBillNo").val("");
                //    }
                //})


                $("#StartEndReportView").on('click', function () {
                    eventFunction.StartEndDateByReport();
                    $('.report-view').show();
                    $('#txtSearch').on('keyup', function () {
                        eventFunction.BindSalesDaily();
                    });
                });

                $("#Waiter").on('click', function () {

                    if (waiter == 0) {
                        waiter = 1;
                    }
                    else {
                        waiter = 0;
                    }
                });
                $("#table").on('click', function () {

                    if (table == 0) {
                        table = 1;
                    }
                    else {
                        table = 0;
                    }
                });
                $("#room").on('click', function () {

                    if (room == 0) {
                        room = 1;
                    }
                    else {
                        room = 0;
                    }


                });
                $("#ReportingDays").on('change', function () {
                    var values = $('#ReportingDays :selected').val();
                    if (values == 1) {
                        $(".todate").hide();
                        $("#btnView").show();
                        $("#btnViewWeekly").hide();
                        $(".span2").hide();
                        $("#btnViewYearly").hide();
                        $("#btnViewMonthly").hide();
                        $(".hide").show();
                        $("#txtStartDate").show();
                        $("#txtStartDate").val("");
                        $("#txtToDate").hide();
                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);
                        $("#btnViewRange").hide();
                        //location.reload();
                    }
                    else if (values == 2) {
                        $(".todate").show();
                        $("#btnView").hide();
                        $("#btnViewWeekly").show();
                        $("#btnViewMonthly").hide();
                        $(".span2").hide();
                        $("#btnViewYearly").hide();
                        $(".hide").show();
                        $("#txtToDate").hide();
                        $("#txtStartDate").show();
                        $("#btnViewRange").hide();

                        $("#txtStartDate").val("");
                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);

                    }
                    else if (values == 3) {
                        $("#txtStartDate").hide();
                        $("#btnViewWeekly").hide();
                        $(".span2").show();
                        $("#btnViewMonthly").show();
                        $("#btnView").hide();
                        $("#txtToDate").hide();
                        $("#btnViewYearly").hide();
                        $(".hide").show();
                        $("#btnViewRange").hide();

                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);
                    }
                    else if (values == 4) {

                        $("#btnViewMonthly").hide();
                        $("#month").hide();
                        $("#txtStartDate").hide();
                        $("#btnViewWeekly").hide();
                        $("#btnView").hide();
                        $("#txtToDate").hide();
                        $("#btnViewYearly").show();
                        $(".hide").show();
                        $("#seit").show();
                        $("#btnViewRange").hide();
                        //$("select option[value*='Sold Out']").prop('disabled', true); disabled
                        //$("#seit").html("");
                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);
                    }
                    else if (values == 5) {
                        $("#txtStartDate").show();
                        $("#btnViewRange").show();
                        $("#txtToDate").show();
                        $("#month").hide();
                        $("#seit").hide();
                        $("#btnViewYearly").hide();
                        $("#btnView").hide();
                        $("#btnViewMonthly").hide();
                        $("#btnViewWeekly").hide();

                        $(".hide").show();

                    }


                });
                //----------------------------------------Daily----------------
                $("#btnView").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        if (waiter == 0 && room == 0 && table == 0) {

                            eventFunction.GetDailyReport();

                            $(".e").hide();
                            $(".table").hide();
                            $(".d").hide();
                            $(".room").hide();
                            $(".waiter").hide();
                            $(".c").hide();
                            //$("#btnView").hide();
                            //$("#btnViewWeekly").show();
                        }
                        else if (waiter == 1 && room == 0 && table == 0) {
                            eventFunction.GetDailyReport();
                            $(".e").hide();
                            $(".table").hide();
                            $(".d").hide();
                            $(".room").hide();
                        }
                        else if (waiter == 0 && room == 1 && table == 0) {
                            eventFunction.GetDailyReport();
                            $(".waiter").hide();
                            $(".c").hide();
                            $(".e").hide();
                            $(".table").hide();
                        }
                        else if (waiter == 0 && room == 0 && table == 1) {
                            eventFunction.GetDailyReport();
                            $(".c").hide();
                            $(".d").hide();
                            $(".room").hide();
                            $(".waiter").hide();
                        }

                        else if (waiter == 1 && room == 1 && table == 0) {
                            eventFunction.GetDailyReport();
                            $(".e").hide();
                            $(".table").hide();

                        }
                        else if (waiter == 1 && room == 0 && table == 1) {
                            eventFunction.GetDailyReport();
                            $(".d").hide();
                            $(".room").hide();

                        }
                        else if (waiter == 0 && room == 1 && table == 1) {
                            eventFunction.GetDailyReport();
                            $(".waiter").hide();
                            $(".c").hide();

                        }
                        else if (waiter == 1 && room == 1 && table == 1) {
                            eventFunction.GetDailyReport();
                        }
                    }
                });
                //----------------------------------------Wekly----------------
                $("#btnViewWeekly").on('click', function () {
                    if (waiter == 0 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                        //$("#btnView").hide();
                        //$("#btnViewWeekly").show();
                    }
                    else if (waiter == 1 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    else if (waiter == 0 && room == 1 && table == 0) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".waiter").hide();
                        $(".c").hide();
                        $(".e").hide();
                        $(".table").hide();
                    }
                    else if (waiter == 0 && room == 0 && table == 1) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".c").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                    }

                    else if (waiter == 1 && room == 1 && table == 0) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".e").hide();
                        $(".table").hide();

                    }
                    else if (waiter == 1 && room == 0 && table == 1) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".d").hide();
                        $(".room").hide();

                    }
                    else if (waiter == 0 && room == 1 && table == 1) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".waiter").hide();
                        $(".c").hide();

                    }
                    else if (waiter == 1 && room == 1 && table == 1) {
                        eventFunction.GetDailyReportByWeekly();
                    }
                });
                //----------------------------------------Monthly----------------
                $("#btnViewMonthly").on('click', function () {
                    if (waiter == 0 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (waiter == 1 && room == 0 && table == 0) {

                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    else if (waiter == 0 && room == 1 && table == 0) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".waiter").hide();
                        $(".c").hide();
                        $(".e").hide();
                        $(".table").hide();
                    }
                    else if (waiter == 0 && room == 0 && table == 1) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".c").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                    }

                    else if (waiter == 1 && room == 1 && table == 0) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();

                    }
                    else if (waiter == 1 && room == 0 && table == 1) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".d").hide();
                        $(".room").hide();

                    }
                    else if (waiter == 0 && room == 1 && table == 1) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".waiter").hide();
                        $(".c").hide();

                    }
                    else if (waiter == 1 && room == 1 && table == 1) {
                        eventFunction.GetDailyReportByMonthly();
                    }
                });

                //----------------------------------------Yearly----------------

                $("#btnViewYearly").on('click', function () {
                    if (waiter == 0 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (waiter == 1 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    else if (waiter == 0 && room == 1 && table == 0) {
                        eventFunction.GetDailyReportByYearly();
                        $(".waiter").hide();
                        $(".c").hide();
                        $(".e").hide();
                        $(".table").hide();
                    }
                    else if (waiter == 0 && room == 0 && table == 1) {
                        eventFunction.GetDailyReportByYearly();
                        $(".c").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                    }

                    else if (waiter == 1 && room == 1 && table == 0) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();

                    }
                    else if (waiter == 1 && room == 0 && table == 1) {
                        eventFunction.GetDailyReportByYearly();
                        $(".d").hide();
                        $(".room").hide();

                    }
                    else if (waiter == 0 && room == 1 && table == 1) {
                        eventFunction.GetDailyReportByYearly();
                        $(".waiter").hide();
                        $(".c").hide();

                    }
                    else if (waiter == 1 && room == 1 && table == 1) {
                        eventFunction.GetDailyReportByYearly();
                    }
                });
                //------------------------------------
                $("#btnViewRange").on('click', function () {
                    if (waiter == 0 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                });
                //--------------------------Export To PDF----------------

                var doc = new jsPDF();
                var specialElementHandlers = {
                    '#editor': function (element, renderer) {
                        return true;
                    }
                };

                $('#exportToPDF').click(function () {
                    doc.fromHTML($('#DailyReport').html(), 15, 15, {
                        'width': 170,
                        'elementHandlers': specialElementHandlers
                    });
                    doc.save('sample-file.pdf');
                    location.reload();
                });


                //--------------------------Print PDF----------------

                $('#btnPrint').on('click', function () {
                    Print();
                });

                //--------------------------Export To EXCEL----------------

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var contents = $('#DailyReport').clone();
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').remove();
                    let file = new Blob([contents.get(0).innerHTML], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "SalesReport_" + $('#startDate').val() + '_' + $("#EndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    var contents = $('#DailyReport');
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').hide();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML(contents, 0, 0, options, function () {
                        pdf.save('SalesReport_' + $('#startDate').val() + '_' + $("#EndDate").val() + '.pdf');
                    });
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').show();
                    $('#printedDate').hide();

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
                        break;
                    case 1:
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 2:
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 3:
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 4:
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 5:
                        eventFunction.bindSumDaily(data);
                        break;
                    case 6:
                        jAlert('Bill Cancelled successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("#StartEndReportView").click();
                        break;
                    case 7:
                        salesReport = JSON.parse(data.d);
                        eventFunction.BindSalesDaily();
                        break;
                    case 8:
                        eventFunction.BindSalesRecord(data);
                        break;
                    case 9:
                        break;
                    case 10:
                        break;
                    case 11:
                        terms = [];
                        terms = data.d;
                        break;
                    case 12:
                        inWord = "";
                        inWord = data.d;
                        break;
                    case 13:
                        $('#printno').show();
                        eventFunction.print();
                        $('#BillingView').dialog('close');
                        break;
                    case 14:
                        eventFunction.BindProviderList(data.d)
                        break;
                    case 15:
                        eventFunction.Bindmembership(data);
                        break;
                    case 16:
                        eventFunction.Bindmember(data);
                        break;
                    case 17:
                        eventFunction.UpdateSalesPayMode();
                        break;
                    case 18:
                        //alert("Bill Paid");
                        location.reload();
                        //
                        return false;
                        break;
                    case 19:
                        var role = data.d;
                        userRole = role.Roles;
                        break;
                    case 20:
                        eventFunction.BindGetOrderType(data.d);
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

            GetUserName: function () {
                var loggername = SageFrameUserName;
                eventFunction.config.method = "GetRolesByUsername";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ username: loggername });
                eventFunction.config.ajaxCallMode = 19;
                eventFunction.ajaxCall(eventFunction.config);
            },

            UpdateTotalCashPaid: function () {
                //var MembershipID = id;
                var MemberInfo = {};
                MemberInfo.MembershipID = membersid;
                MemberInfo.UptoNowPaid = $('#hdfBillAmount').val();
                eventFunction.config.method = "SaveTotalCashPaid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ MemberInfo: MemberInfo });
                eventFunction.ajaxCall(eventFunction.config);
            },

            UpdateSalesPayMode: function () {
                //var MembershipID = id;
                var salesPayment = {};
                salesPayment.salesMasterId = $('#hdfSalesMasterId').val();
                salesPayment.SPMID = $('#selPayMode').val();
                salesPayment.ChequeNo = ($('#selPayMode').val() == 2 ? $('#txtCheqNo').val() : "");
                salesPayment.TransactionNo = ($('#selPayMode').val() == 3 ? $('#txtTransNo').val() : "");
                salesPayment.ProviderID = (($('#selPayMode').val() == 3 || $('#selPayMode').val() == 2) ? $('#selProv').val() : "");
                salesPayment.TenderAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtTenderAmount').val() == "" ? 0 : $('#txtTenderAmount').val())) : 0);
                salesPayment.ReturnAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtReturnAmount').val() == "" ? 0 : $('#txtReturnAmount').val())) : 0);

                salesPayment.CusID = CustID;
                salesPayment.Customer = CustName;
                salesPayment.Address = CustAddress;
                salesPayment.PAN = CustPAN;
                eventFunction.config.method = "UpdateSalesPayMode";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ salesPayment: salesPayment });
                eventFunction.config.ajaxCallMode = 18;
                eventFunction.ajaxCall(eventFunction.config);
            },
            UpdateCustomerName: function (id) {
                var MembersID = id;
                var MemberInfo = {};

                MemberInfo.MembershipID = MembersID;
                MemberInfo.RemainingBalance = parseFloat($('#txtCalRemainingAmount').val() == "" ? 0 : $('#txtCalRemainingAmount').val());
                MemberInfo.PayAmount = parseFloat($('#txtCalPaidAmount').val() == "" ? 0 : $('#txtCalPaidAmount').val());
                //MemberInfo.RemainingBalance = $('#txtCalRemainingAmount').val();
                //MemberInfo.PayAmount = $('#txtCalPaidAmount').val();
                MemberInfo.AddedBy = SageFrameUserName;
                eventFunction.config.method = "SaveCustomerAmount";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ MemberInfo: MemberInfo });
                //if (companyProf.config.MemberIDUpdate == 1)
                {
                    eventFunction.config.ajaxCallMode = 17;

                    //} else {
                    //companyProf.config.ajaxCallMode = 1;

                    $("#membeshipformlist2").hide();
                }

                eventFunction.ajaxCall(eventFunction.config);

            },
            GetCusOnChange: function (id) {
                //var id = parseInt(item.id.split("_")[1])
                //$("#" + id + "_").remove();

                var membersid = id;

                eventFunction.config.method = "GetCusOnChange";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ MembershipID: membersid });
                eventFunction.config.ajaxCallMode = 16;

                eventFunction.ajaxCall(eventFunction.config);
            },
            GetCustomeronChange: function () {
                var customer = 1;
                eventFunction.config.method = "getsdatass";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ customer: customer });
                eventFunction.config.ajaxCallMode = 15;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetProviderList: function () {
                eventFunction.config.method = "GetProviderList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //eventFunction.config.data = JSON2.stringify({ startDate: Sdate, endDate: EDate, CustomerName: CustomerName });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetOrderType: function () {
                eventFunction.config.method = "GetOrderType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 20;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindGetOrderType: function (data) {
                var result = JSON.parse(data);
                var htmls = "";
                $('#selOrderType').html(htmls);
                htmls += '<option value="0">All</option>';
                $.each(result, function (index, value) {
                    htmls += '<option value="' + value.OrderTypeID + '">' + value.OrderType + '</option>';
                });
                $('#selOrderType').html(htmls);

            },

            BindProviderList: function (data) {
                var htmls = "";
                $('#selProv').html(htmls);
                $.each(data, function (index, value) {
                    htmls += '<option value="' + value.ProviderID + '">' + value.ProviderName + '</option>';
                });
                $('#selProv').html(htmls);

            },
            GetBill: function (salesMasterId) {
                getBill(salesMasterId);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg',
                });

                $('#btnPrints').unbind('click').on('click', function () {
                    $('#divPrintedOn').text(formatAMPM());
                    eventFunction.config.method = "savePrintCount";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName, SalesType: ''
                    });
                    eventFunction.config.ajaxCallMode = 13;
                    eventFunction.ajaxCall(eventFunction.config);
                });
                $("#btnPayBill").unbind('click').on("click", function () {
                    $("#selPayMode").val(1);
                    $("#hdfSalesMasterId").val(parseInt($('#hdfSMID').val()));
                    totalamount = parseFloat($("#hdfBasicAmount").val());
                    CustID = parseInt($('#hdfCusID').val());
                    CustName = $('#hdfCusName').val();
                    CustAddress = $('#hdfAddress').val();
                    CustPAN = $('#hdfPAN').val();
                    payment(parseInt($('#hdfSMID').val()));

                });
            },

            GetCakeBill: function (SalesMasterID, SalesType) {

                getSalesReport_CakeBill(SalesMasterID, SalesType);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg',
                });
                $('#btnPrints').unbind('click').on('click', function () {
                    $('#divPrintedOn').text(formatAMPM());
                    eventFunction.config.method = "savePrintCount";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName, SalesType: SalesType
                    });
                    eventFunction.config.ajaxCallMode = 13;
                    eventFunction.ajaxCall(eventFunction.config);
                });
                $("#btnPayBill").unbind('click').on("click", function () {
                    $("#selPayMode").val(1);
                    $("#hdfSalesMasterId").val(parseInt($('#hdfSMID').val()));
                    totalamount = parseFloat($("#hdfBasicAmount").val());
                    CustID = parseInt($('#hdfCusID').val());
                    CustName = $('#hdfCusName').val();
                    CustAddress = $('#hdfAddress').val();
                    CustPAN = $('#hdfPAN').val();
                    payment(parseInt($('#hdfSMID').val()));

                });
            },


            SaleReportByBillNo: function () {
                startBillNo = $("#startBillNo").val();
                EndBillNo = $("#EndBillNo").val();
                eventFunction.config.method = "SaleReportByBillNo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startBillNo: startBillNo, endBillNo: EndBillNo, Status: $('#sltStatus').val() });
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);

            },
            SalesRecord: function () {
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtEndDate").val();
                eventFunction.config.method = "MaterializedReportView";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ StartDate: StartDate, EndDate: EndDate, Valid: d });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },


            GetDailyReport: function () {
                var todaydate = $("#txtStartDate").val();

                eventFunction.config.method = "getdailyReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dateTime: todaydate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByWeekly: function () {
                var todaydate = $("#txtStartDate").val();
                eventFunction.config.method = "getdailyReportByWeekly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dateTime: todaydate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByMonthly: function () {
                var year = $("#seit").val();
                var month = $("#month").val();
                eventFunction.config.method = "getdailyReportByMonthly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, month: month });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByYearly: function () {
                var year = $("#seit").val();
                eventFunction.config.method = "getdailyReportByYearly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },
            StartEndDateByReport: function () {
                var startDate = $("#startDate").val();
                var StartHour = $("#StartHour").val();
                var StartMin = $("#StartMin").val();
                var Sdate = startDate + " " + StartHour + ":" + StartMin
                var EndDate = $("#EndDate").val();
                var EndHour = $("#EndHour").val();
                var EndMin = $("#EndMin").val();
                var EDate = EndDate + " " + EndHour + ":" + EndMin
                var PaymentMode = $("#sltPayMode").val();
                var OrdertypeID = $("#selOrderType").val();
                var CustName = $("#txtCustName").val();
                eventFunction.config.method = "getSalesReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: Sdate, endDate: EDate, PaymentMode: PaymentMode, Status: $('#sltStatus').val(), OrdertypeID: OrdertypeID, CustName: CustName });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindSalesRecord: function (data) {
                $("#displayreports").html('');
                var datas = data.d;
                var salesTitle = '';
                if (d == 0 || d == -1) {
                    salesTitle = 'Sales Register';
                }
                if (d == 1) {
                    salesTitle = 'Sales Return Register';
                }
                var htmls = "<table class='pur-static-tbl1'><tr><td colspan='2'> " + p.CompanyName + "</td></tr><tr><td colspan='2'>" + salesTitle + "</td></tr><tr><td>PAN No.   : " + p.Pan + "</td></tr><tr><td style='text-align:right;font-size:15px;'>Date   : From : " + $("#txtStartDate").val() + " To : " + $("#txtEndDate").val() + "</td></tr></table>";
                htmls += "<table id='unittableSecond' class='sfGridwrapper display pur-static-tbl' cellspacing='0'>";
                htmls += "<thead>";
                htmls += "<tr>";
                htmls += "<th colspan='4' style='text-align:center;border-bottom:1px solid rgb(234, 140, 45);'>Invoice</th>";
                htmls += "<th colspan='3'></th>";

                if (d == 0 || d == -1) {
                    htmls += "<th colspan='2' style='text-align:center;border-bottom:1px solid rgb(234, 140, 45);'>Taxable Sales	</th>";
                } else {
                    htmls += "<th colspan='2' style='text-align:center;border-bottom:1px solid rgb(234, 140, 45);'>Taxable Sales	</th><th></th>";
                }
                htmls += "</tr>";
                htmls += "<tr>";
                if (d == 0 || d == -1) {
                    htmls += "<th>Date</th><th>Invoice No</th><th>Purchase Name</th><th>Purchase PAN</th><th>Total Sales</th><th>Tax Exempted Sales</th><th>Zero Rated Sales(Export)</th><th>Value<t/th><th>Tax</th>";
                }
                else {
                    htmls += "<th>Date</th><th>Invoice No</th><th>Purchase Name</th><th>Purchase PAN</th><th>Total Sales</th><th>Tax Exempted Sales</th><th>Zero Rated Sales(Export)</th><th>Value<t/th><th>Tax</th><th>Remarks</th>";
                }
                htmls += "</tr>";
                htmls += "</thead>";
                htmls += "<tbody>";
                if (datas.length > 0) {
                    var A = 0;
                    var Ta = 0;
                    var Taa = 0;
                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.UnitID + "_>";
                        htmls += "<td>" + value.Bill_Date.split(' ')[0] + "</td>";
                        htmls += "<td>" + value.Bill_No + "</td>";
                        htmls += "<td>" + value.Customer_Name + "</td>";
                        htmls += "<td>" + value.Customer_PAN + "</td>";
                        if (value.TaxableAmount > 0) {
                            htmls += '<td>' + Math.abs(value.TaxableAmount.toFixed(2)) + '</td>';
                        }
                        else {
                            htmls += '<td>' + 0 + '</td>';
                        }
                        if (value.TaxableAmount > 0) {
                            htmls += '<td>' + Math.abs(value.TaxableAmount.toFixed(2)) + '</td>';
                        }
                        else {
                            htmls += '<td>' + 0 + '</td>';
                        }
                        //htmls += "<td class='r'>" + "" + "</td>";
                        htmls += "<td class='r'>" + "" + "</td>";
                        if (value.TaxableAmount > 0) {
                            htmls += '<td>' + Math.abs(value.TaxableAmount.toFixed(2)) + '</td>';
                        }
                        else {
                            htmls += '<td>' + 0 + '</td>';
                        }
                        if (value.Tax_Amount > 0) {
                            htmls += '<td>' + Math.abs(value.Tax_Amount.toFixed(2)) + '</td>';
                        }
                        else {
                            htmls += '<td>' + 0 + '</td>';
                        }
                        var res = value.Reasons == undefined ? '' : value.Reasons;
                        if (d == 0 || d == -1) {
                        } else {

                            htmls += "<td>" + res + "</td>";
                        }
                        htmls += "</tr>";
                        if (value.TaxableAmount > 0) {
                            A += value.TaxableAmount;
                        }
                        if (value.TaxableAmount > 0) {
                            Ta += value.TaxableAmount;
                        }
                        if (value.Tax_Amount > 0) {
                            Taa += value.Tax_Amount;
                        }
                    });
                    htmls += "<tfoot><tr><td colspan='4'>Total</td><td>" + A.toFixed(2) + "</td><td></td><td></td><td>" + Ta.toFixed(2) + "</td><td>" + Taa.toFixed(2) + "</td></tr></tfoot>";
                }
                else {
                    htmls += "<tr class='tableItem' >";
                    htmls += "<td>No Data Found</td><tr>";
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#displayreports').html(htmls);
                $('#Exports').show();

            },


            BindSalesDaily: function () {
                $("#DailyReport").show();
                $("#DailyReport").html('');
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));


                if (!IncludeBillCancel && IncludeSalesReturn) {
                    dailyList = salesReport.filter(x => x.BillCancelled == false);
                } else if (!IncludeSalesReturn && IncludeBillCancel) {
                    dailyList = salesReport.filter(x => x.IsArchived == false);
                } else if (!IncludeSalesReturn && !IncludeBillCancel) {
                    dailyList = salesReport.filter(x => x.IsArchived == false && x.BillCancelled == false);
                }else {
                    dailyList = salesReport;
                }

                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Sales Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#EndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';

                htmls += "<table id='salseReport' class='reportsprint report_L' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"

                //htmls += "<th style='width:100px;'>SN</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th>";
                //htmls+="<th>Time</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Bill No.</th>";
                //htmls+="<th class='waiter'>Waiter</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;' class='room'>No. of Pax</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;' class='room'>Room/Table</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Mode</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Total</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Discount</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Basic Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Serv Chrg</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Non Taxable Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Taxable Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>VAT</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Net Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Received Amnt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Sur/Def</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;' class='sort_disable tdcenter' >Action (Bill)</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                var PAX = 0;
                var Su = 0;
                var to = 0;
                var Ba = 0;
                var Se = 0;
                var Va = 0;
                var NonTaxable = 0;
                var Taxable = 0;
                var Ne = 0;
                var Ra = 0;
                var SD = 0;
                var count = 1;
                var roomTable = "";
                //var smID = "";
                if (dailyList.length > 0) {
                    $.each(dailyList, function (index, value) {
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.billNo.toLowerCase().includes(search) || value.restroRoom.toLowerCase().includes(search) || value.restrotableTitle.toLowerCase().includes(search) || search == '') {
                            htmls += "<tr>";
                            //htmls += "<td class='a'>" + count + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class='b'>" + value.BillDate.split(' ')[0] + "</td>";
                            //htmls += "<td class='b' style='width:80px;'>" + value.BillDate.split(' ')[1] + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.billNo + "</td>";
                            //htmls += "<td class='c'>" + value.Waiter + "</td>";
                            if (value.restrotableTitle == "" || value.restrotableTitle == null) {
                                roomTable = value.restroRoom;
                            } else if (value.restrotableTitle != "" || value.restrotableTitle != null) {
                                roomTable = value.restroRoom + "/" + value.restrotableTitle;
                            }

                            htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.GuestNo + "</td>";
                            htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + roomTable + "</td>";
                            htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.PaymentModes + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.SubTotal.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.totaldiscount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + (value.SubTotal - value.totaldiscount).toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.ServiceCharge.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.NonTaxable.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + (value.BasicAmount).toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Vat.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.NetAmount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.ReceivedAmount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.SurplusDeficit.toFixed(2) + "</td>";

                            htmls += '<td class="tdcenter"><label id="' + value.salesMasterId + "_" + value.SPMID + "_" + value.Status + "_" + value.SalesType + '" class="icon-preview btnViewBill" />';

                            htmls += '<td class="tdcenter">';
                            
                            var roles = userRole.split(',');
                            if (roles.includes("Super User") || roles.includes("Void Bill")) {
                                if (value.EditBill && value.BillCancelled != 1 && value.IsArchived != 1) {
                                    htmls += '<label id="' + value.salesMasterId + "_" + value.SPMID + "_" + value.Status + "_" + value.SalesType + '" class="icon-edit btnEditCustomer" style="margin-right: 5px;" />';
                                }
                                if (value.BillCancelled != 1 && value.Status != 1 && value.IsArchived != 1) {
                                    htmls += '<label id="' + value.salesMasterId + '" class="icon-close btnCancelBill"/>';
                                }
                            }
                            htmls += '</td>';
                            count++;
                            PAX += value.GuestNo;
                            Su += value.SubTotal;
                            to += value.totaldiscount;
                            Ba += value.SubTotal - value.totaldiscount;
                            Se += value.ServiceCharge;
                            Va += value.Vat;
                            NonTaxable += value.NonTaxable;
                            Taxable += (value.BasicAmount);
                            Ne += value.NetAmount;
                            Ra += value.ReceivedAmount;
                            SD += value.SurplusDeficit;
                            TotalAmount = TotalAmount + value.NetAmount;
                            htmls += "</tr>"
                        }
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='14' style='text-align:center;'> No Data </td>";
                    htmls += '</tr></tbody>';
                }
                htmls += "<tfoot>"
                htmls += "<tr>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='f' colspan='2' style='text-align:right;'>Total </th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;' class=''>" + PAX + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'></th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'></th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Su.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + to.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ba.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Se.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + NonTaxable.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Taxable.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Va.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ne.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ra.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + SD.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' colspan=2></th>";
                htmls += "</tr>"
                htmls += "</tfoot>"
                TotalAmount = 0;
                // htmls += "</tbody>";
                htmls += "</table>";




                $('#DailyReport').html(htmls);

                //$("#DailyReport").on("click", ".btnEditCustomer", function () {
                //    var smID = $(this).attr('id').split('_')[0];
                //    eventFunction.EditCustomer(smID);

                //})





            },
            GetCustomeronCheck: function () {
                var customer = 1;
                var baseUrl = SageFrameHostURL + "/Modules/CakeBilling/services/CakeBillingWebService.asmx/";
                $.ajax({
                    type: "POST",
                    async: false,
                    cache: false,
                    url: baseUrl + "GetCustomerDatas",
                    data: JSON2.stringify({ customer: customer }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        $("#membeshipformlist").show();
                        $("#membeshipformlist").html('');
                        var datas = JSON.parse(data.d);
                        if (datas.length > 0) {
                            var htmls = "<table id='customertable' class='sfGridwrapper display' cellspacing='0'>"
                            htmls += "<thead>"
                            htmls += "<tr>"
                            htmls += "<th> Name </th><th>PAN</th><th> Address </th><th> ContactNo.</th><th> Discount(%) </th><th>Paid</th>";
                            htmls += "</tr>"
                            htmls += "</thead>"
                            htmls += "<tbody>"

                            $.each(datas, function (index, value) {

                                htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "'>";
                                htmls += "<td>" + value.Name + "</td>";
                                htmls += "<td>" + value.PAN + "</td>";
                                htmls += "<td>" + value.Addresss + "</td>";
                                // htmls += "<td>" + value.Occupation + "</td>";
                                // htmls += "<td>" + value.Company + "</td>";
                                htmls += "<td>" + value.TelMobile + "</td>";
                                htmls += "<td>" + value.discount + "</td>";
                                htmls += "<td>" + "<img src='/images/completed.png' class='selectCust' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                                htmls += "</tr>"

                            });
                            htmls += "</tbody>";
                            htmls += "</table>";
                            $('#membeshipformlist').html(htmls);
                            $('#customertable').DataTable(
                                {

                                    "jQueryUI": true,

                                });

                            $("#membeshipformlist").dialog({
                                'title': 'Customer',
                                width: 800,
                                modal: true,
                                resizable: true,
                                position: ['center', 'center']
                            });


                        } else {
                            $('#membeshipformlist').html('No data');

                        }
                        $(".dataTables_scrollBody").css('height', '100%');

                        //  $("#membeshipformlist").on('click', '.selectCust', function (event) {
                        $("#membeshipformlist").on('click', '#customertable tr', function (event) {
                            var dataAttribute = $(this).attr('id');
                            var ids = dataAttribute.split('_');

                            $("#custId").val(ids[1]);
                            //$("#txtCustomerName").val(ids[2] + " " + ids[3]);
                            //$("#txtPanNumber").val(ids[4]);
                            $("#txtCustomerName").prop('disabled', true);


                            $("#txtCustomerNameP").val(ids[2] + " " + ids[3]);
                            $('#txtPAN').val(ids[4]);
                            $("#txtCustomerNameP").prop('disabled', true);
                            $("#membeshipformlist").dialog('close');

                        });
                    },
                    failure: function (response) {
                        jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                    }
                });
            },


            EditCustomer: function (smID) {
                var salesMasterID = smID.split('_')[0];
                var TAmount = 0.00;
                var html = "";
                var billInfo = "";
                html += '<input type="hidden" id="custId" name="custId" value="">';
                html += '<div id="payment">';
                $.ajax({
                    type: "POST",
                    async: false,
                    cache: false,
                    url: SageFrameHostURL + "/Services/OrderWebservice.asmx/GetPaymentModesAndProviders",
                    data: JSON.stringify({ salesMasterId: salesMasterID }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        var result = JSON.parse(data.d);
                        var cardProviders = result.providers;
                        var paymentModes = result.paymentModes;
                        //var billInfo = result.billInfo;
                        billInfo = result.billInfo;
                        TAmount = billInfo.TotalAmount;

                        $('#divEditCustomer').find('#payment').html('');

                        /* html += '<div id="divNamePhone" style="display:"><span style="text-align:left; display:inline-block;">Customer name<span style="color:red;">*</span>: <input type="text" id="txtCustName" class="sfInputbox" value="' + custName + '" /></span><span style="float:right; display:inline-block;">Phone<span style="color:red;">*</span>: <input type="text" id="txtPhoneNumber" class="txtNum sfInputbox" value="' + phoneNumber + '" /></span></div>';*/
                        html += '<div class="unpaidbill_ttl" style="display:flex;justify-content:space-between;"><h4>Total Amount : Rs.' + billInfo.TotalAmount + '</h4>';
                        html += '<h4 id="surplusDeficit" style="text-align:right;">Surplus/Deficit : Rs.<span id="txtsurplus">0</span></h4></div>';
                        html += '<table id="tblPayment" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';
                        $.each(paymentModes, function (index, mode) {
                            html += '<tr>';
                            html += '<td><input type="checkbox" class="pmntCheck" id="chkBox_' + mode.PaymentModeID + '" ' + (mode.PaymentModeID == 1 ? 'checked' : '') + ' /><label for="chkBox_' + mode.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + mode.PaymentMode + ' : </label></td>';
                            html += '<td></td>';
                            html += '<td>';
                            if (mode.PaymentModeID == 1) {
                                //html += 'Tender Amount <input type="text" id="txtTenderAmount" class="pmt txtNum sfInputbox" value="' + billInfo.TotalAmount + '" />';
                                html += '</td>';
                                html += '<td>'
                                // html += 'Return Amount < input type = "text" id = "txtReturnAmount" class="pmt txtNum sfInputbox" value = "0" />'
                                html += '</td >';
                                html += '<td>Pay Amount <input type="text" onkeypress="return IntegerAndDecimal(this, event);" class="pmt sfInputbox txtPayAmount"  value="' + billInfo.TotalAmount + '"/></td>';
                            } else if (mode.PaymentModeID == 4) {
                                html += '<input type="hidden" id="hdfCusID" class="sfInputbox" value="' + billInfo.CustomerID + '" />';
                                html += '<input type="hidden" id="hdfAddress" class="sfInputbox" />';
                                html += 'Customer <input type="text" disabled id="txtCustomerNameP" class="sfInputbox"/>';
                                html += '</td>';
                                html += '<td>PAN <input type="textbox" disabled id="txtPAN" class="sfInputbox"/></td>';
                                html += '<td>Pay Amount <input type="text" onkeypress="return IntegerAndDecimal(this, event);" class="pmt sfInputbox txtPayAmount" /></td>';

                            }

                            else {
                                html += 'Provider<select class="sfInputbox selPaymentMode">';
                                $.each(cardProviders, function (index, provider) {
                                    html += '<option value="' + provider.ProviderID + '">' + provider.ProviderName + '</option>';
                                });
                                html += '</select>';
                                html += '</td>';
                                html += '<td># <input type="text" class="pmt sfInputbox txtTransaction" placeholder="' + (mode.PaymentModeID == 2 ? 'Cheque No.' : 'Transaction No.') + '" /></td>';
                                html += '<td>Pay Amount <input type="text" onkeypress="return IntegerAndDecimal(this, event);" class="pmt sfInputbox txtPayAmount" /></td>';
                            }

                            html += '</tr>';
                        });
                        html += '</table>';

                    },
                    failure: function (response) {
                        jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                    }
                });
                html += '</div>';
                html += '<div class="txtRem" >Remarks:<span class="sf-error">*</span> <textarea class="sfInputbox txtRemarks"></textarea></div></br>';
                html += '<button type="button" class="sfBtn restro-btn" id="updateBill" data-smid=' + smID + '>Update</button>';

                $('#divEditCustomer').show();
                $('#divEditCustomer').html(html);
                $('#divEditCustomer').dialog({
                    'title': 'Edit Bill',
                    width: '570',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg',
                });

                $('#divEditCustomer').on('click', '#updateBill', function () {
                    var smID = $(this).data('smid');

                    var _rMar = $('#divEditCustomer').find('.txtRemarks');
                    if (_rMar == '' || _rMar.val().length < 5) {
                        jAlert('Please give valid reason for update bill !!!', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        var paidAmount = 0.00
                        $('#divEditCustomer').find('.txtPayAmount ').each(function () {
                            paidAmount += parseFloat($(this).val() == "" ? 0.00 : $(this).val());
                        });
                        console.log('paidAmount ' + paidAmount + '  TotalAmount  ' + TAmount);
                        if (paidAmount < TAmount) {
                            jAlert('Total amount is greater than paid amount. !!!', "Alert!!", function () { $.alerts.dialogClass = null; });
                        }
                        else {

                            if (parseFloat($('#txtsurplus').html()) != 0) {

                                jAlert('There is Surplus/Deficit of Rs.' + parseFloat($('#txtsurplus').html()) + '. Must settled Surplus/Deficit to zero (0) before update the bill.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            }
                            else {

                                var salesPaymentList = new Array();

                                //if ($('#chkPayMentMode').is(':checked')) {
                                    $('#divEditCustomer').find('.pmntCheck').each(function () {
                                        if ($(this).is(':checked')) {
                                            var row = $(this).closest('tr');
                                            var spmid = $(this).attr('id').split('_')[1];

                                            var salesPayment = new Object();
                                            salesPayment.salesMasterId = smID;
                                            salesPayment.SPMID = spmid;
                                            salesPayment.ChequeNo = (spmid == 2 ? $(row).find('.txtTransaction').val() : '');
                                            salesPayment.TransactionNo = (spmid == 3 || spmid == 5 || spmid == 6 ? $(row).find('.txtTransaction').val() : '');
                                            salesPayment.ProviderID = (spmid == 2 || spmid == 3 || spmid == 5 || spmid == 6 ? $(row).find('.selPaymentMode').val() : '');
                                            salesPayment.CusID = ($.trim($('#custId').val()) == "" ? 0 : parseInt($('#custId').val()));
                                            salesPayment.Customer = $('#txtCustomerNameP').val();
                                            salesPayment.Address = "";
                                            salesPayment.PAN = $('#txtPAN').val();
                                            salesPayment.PayAmount = $(row).find('.txtPayAmount').val();
                                            salesPayment.Remarks = $('.txtRemarks').val();
                                            salesPayment.BillAmount = TAmount;
                                            salesPaymentList.push(salesPayment);
                                        }
                                    });

                                $.ajax({
                                    type: "POST",
                                    async: false,
                                    cache: false,
                                    url: eventFunction.config.baseURL + "ChangePayMode",
                                    data: JSON2.stringify({ SalesPayment: salesPaymentList, }),
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (data) {
                                        jAlert('Bill Successfully Paid.', 'Information!!', function () {
                                            location.reload(); 
                                        });
                                        $(".ui-dialog-content").dialog("close");

                                    },
                                    failure: function (response) {
                                        jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                                    }
                                });
                            }
                        }

                    }
                });


                // Validate  Form 

                $('.txtPayAmount').on('change', function () {
                    totalPayAmnt = 0.00;
                    $('.txtPayAmount').each(function () {
                        if ($(this).closest('tr').find('.pmntCheck').is(':checked')) {
                            totalPayAmnt += parseFloat($(this).val());
                        }
                    })
                    $('#txtsurplus').html((totalPayAmnt - billInfo.TotalAmount).toFixed(2));
                    if (totalPayAmnt > billInfo.TotalAmount) {
                        document.getElementById("surplusDeficit").setAttribute("style", "color:green !important");
                    } else if (totalPayAmnt < billInfo.TotalAmount) {
                        document.getElementById("surplusDeficit").setAttribute("style", "color:red !important");
                    } else {
                        document.getElementById("surplusDeficit").setAttribute("style", "color:black !important");
                    }
                });


                $('.pmntCheck').on('change', function () {
                    ////$(this).closest('tr').find('.txtPayAmount').val(Math.abs(parseFloat($('#txtsurplus').text())));
                    ////$('.txtPayAmount').change()
                    //if ($(this).attr('id').split('_')[1] == "4" && $(this).is(':checked') && billInfo.CustomerID < 1) {
                    //    $(this).prop('checked', false);
                    //    GetCustomeronChange(billInfo.CustomerID, this);
                    //}
                    //else if ($(this).attr('id').split('_')[1] == "4" && $(this).is(':checked') && billInfo.CustomerID > 1) {
                    //    $(".txtRem").show();
                    //}
                    //else {
                    //    $(".txtRem").hide();
                    //}
                    if ($(this).is(':checked') && $(this).attr('id').split('_')[1] == "4") {
                        //alert(1);
                        eventFunction.GetCustomeronCheck();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            resizable: true,
                            position: ['center', 'center']
                        });
                    } else {
                       // alert(2);
                        $("#hdfCusID").val('');
                        $("#txtCustomerNameP").val('');
                        $("#txtPAN").val('');
                    }

                    if (!$(this).is(':checked')) {
                        $(this).closest('tr').find('.txtPayAmount').val(0);
                        $('.txtPayAmount').change();
                        if ($(this).attr('id').split('_')[1] == "4" && parseInt($("#hdfCusID").val()) != billInfo.CustomerID) {
                            $("#hdfCusID").val('');
                            $("#txtCustomerNameP").val('');
                            $("#txtPAN").val('');
                            //$("#hdfAddress").val('');
                            //$(".txtRemarks").val('');
                            //$(".txtRem").hide();

                        }
                    } else {
                        var surplusDef = parseFloat($('#txtsurplus').html());
                        if (surplusDef < 0) {
                            //if ($(this).attr('id').split('_')[1] == "1") {
                            //    $("#txtTenderAmount").val(Math.abs(surplusDef));
                            //    $("#txtReturnAmount").val('0');
                            //}
                            $(this).closest('tr').find('.txtPayAmount').val(Math.abs(surplusDef));
                            $('.txtPayAmount').change();
                        }
                        //else {
                        //    if ($(this).attr('id').split('_')[1] == "1") {
                        //        $("#txtTenderAmount").val('0');
                        //        $("#txtReturnAmount").val('0');
                        //    }
                        //}
                    }
                });

            },

            print: function () {
                var contents = $('#customer-bill').html();
                var frame1 = document.createElement('iframe');
                frame1.name = "frame1";
                document.body.appendChild(frame1);
                var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
                frameDoc.document.open();
                frameDoc.document.write('<html><head><title></title>');
                frameDoc.document.write('</head><body>');
                frameDoc.document.write(contents);
                frameDoc.document.write('</body>');
                frameDoc.document.close();
                setTimeout(function () {
                    window.frames["frame1"].focus();
                    window.frames["frame1"].print();
                    document.body.removeChild(frame1);
                }, 500);
            },
            Bindmembership: function (data) {
                $("#membeshipformlist").dialog({
                    'title': 'Customer',
                    width: 800,
                    modal: true,
                    resizable: true,
                });

                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th><th>Paid</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.Occupation + "</td>";
                        htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        htmls += "<td>" + "<img src='/images/completed.png' class='BrandDelete' style='width:30px' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                        // htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                        {
                            "scrollY": false,
                            "scrollCollapse": false,
                            "bJQueryUI": true,

                        });

                } else {
                    $('#membeshipformlist').html('No data');

                }

                $(".dataTables_scrollBody").css('height', '100%');
                $("#membeshipformlist").on('click', '.BrandDelete', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    var rows = $(this).closest('tr');
                    CustID = id;
                    CustName = rows.find('td:eq(0)').text();
                    CustAddress = rows.find('td:eq(2)').text();
                    CustPAN = rows.find('td:eq(1)').text();

                    //$("#chkCus").prop("checked", true);

                    //totamount = $("#bindtotalamount").val();
                    eventFunction.GetCusOnChange(id);

                });

            },
            Bindmember: function (data) {
                $("#membeshipformlist2").show();
                $("#membeshipformlist2").html('');

                var datas = data.d;

                if (datas.length > 0) {
                    var htmls = "<table id='MemberTable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th style='width:200px'> Address </th><th> Phone </th><th> Card Number </th><th> Remaining Balance </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:200px'>" + value.Address + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td>" + value.CardNumber + "</td>";
                        htmls += "<td>" + value.RemainingBalance + "</td>";

                        //  htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        // htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        htmls += "<tr>"
                        //var sum = (parseFloat(value.RemainingBalance) + parseFloat(totamount)).toFixed(2);
                        var sum = parseFloat(totalamount).toFixed(2);

                        //htmls += "<td>" + value.RemainingBalance + "</td>";
                        htmls += "<table style='display:block;margin-top:10px;background:#e6e6e6;'>"
                        htmls += "<tr>"
                        htmls += "<td style='font-weight:bold;font-size:17px;text-align:center;'>Balance</td>"
                        htmls += "<td style='text-align:center;'><input type='textbox' disable value='" + sum + " ' placeholder='Total Amt' class='sfInputbox total' id='txtCalTotalAmount' style='width:120px;' readonly='readonly'/></td>";
                        htmls += "<td style='text-align:center;'><input type='textbox' placeholder='Paid Amt' class='sfInputbox total' id='txtCalPaidAmount' name='PaidAmount'  style='width:120px;'/></td>";
                        htmls += "<td style='text-align:center;'><input type='textbox' placeholder='" + sum + "' class='sfInputbox total' id='txtCalRemainingAmount' style='width:120px;' readonly='readonly' value='" + sum + "'/></td>";

                        htmls += "<td style='text-align:center;'>" + "<input class='sfBtn restro-btn updatemember' type='button'  id=_" + value.MembershipID + " value='Pay the Bill'  /></td>";
                        htmls += "</tr>"
                        htmls += "</table>"


                    });

                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#membeshipformlist2').html(htmls);
                    //$('#MemberTable').DataTable(
                    //     {
                    //         "scrollY": false,
                    //         "scrollCollapse": false,
                    //         "jQueryUI": true,

                    //     });

                } else {
                    $('#membeshipformlist2').html('No data');

                }
                $("#membeshipformlist2").dialog({
                    'title': 'Customer Balance',
                    width: 800,
                    modal: true,
                    resizable: true,
                });

                $("#membeshipformlist2").on('keyup', '#txtCalPaidAmount', function (event) {

                    var TotalAmount = parseFloat($("#txtCalTotalAmount").val());

                    var paidamount = parseFloat($("#txtCalPaidAmount").val());


                    var totalsum = TotalAmount;
                    if (paidamount > 0 && paidamount <= TotalAmount) {
                        totalsum = TotalAmount - paidamount
                    } else {
                        $("#txtCalPaidAmount").val("");
                    }


                    $("#txtCalRemainingAmount").val(totalsum.toFixed(2));
                });
                $("#membeshipformlist2").unbind('click').on('click', '.updatemember', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    eventFunction.UpdateCustomerName(ids[1]);


                });

                $(".dataTables_scrollBody").css('height', '100%');

            },
            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#textUnit').val('');
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        textUnit: {
                            required: true,
                        },

                    },
                    messages: {
                        textUnit: {
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