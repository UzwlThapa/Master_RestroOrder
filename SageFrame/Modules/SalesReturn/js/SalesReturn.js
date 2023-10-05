
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
                ModulePath: '/Modules/SalesReturn/',
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
                baseURL: p.ModulePath + "SalesReturn.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.GetUserName();
                $("#DailyReport").on("click", ".btnCancelBill", function () {
                    salesId = $(this).attr('id');
                    $('#hdnPinFor').val('CancelBill');
                    InitializePin();
              

                });

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
                                        "Return Bill": function () {
                                            var myStr = $("#txtCancelWithReason").val();
                                            var newStr = myStr.replace(/  +/g, ' ');
                                            if (newStr.length <= 4) {
                                                jAlert('Please Insert Valid Cancel Reason.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                            }
                                            else {
                                                var reason = $("#txtCancelWithReason").val();
                                                eventFunction.config.method = "SalesReturnWithReason";
                                                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                                eventFunction.config.data = JSON2.stringify({ id: ids, userName: userName, reason: reason, date: nepaliDate, restoreOrder: false });
                                                eventFunction.config.data = eventFunction.config.data;
                                                eventFunction.config.ajaxCallMode = 6;
                                                alert(ids + " " + userName + " " + reason);
                                                eventFunction.ajaxCall(eventFunction.config);
                                                $(this).dialog('close');
                                                eventFunction.GetBill(ids);
                                                $('#btnPrints').click();
                                            }
                                        },
                                        Cancel: function () {
                                            $(this).dialog('close');
                                        }
                                    }
                                });
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



                $("#StartEndReportView").on('click', function () {
                    eventFunction.StartEndDateByReport();
                    $('.report-view').show();
                    $('#txtSearch').on('keyup', function () {
                        eventFunction.BindSalesDaily();
                    });
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
                        jAlert('Saved Reason successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("#StartEndReportView").click();
                        //location.reload();
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
                        //eventFunction.bindBillBody(data.d);
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

            },

            GetUserName: function () {
                var loggername = SageFrameUserName;
                eventFunction.config.method = "GetRolesByUsername";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ username: loggername });
                eventFunction.config.ajaxCallMode = 19;
                eventFunction.ajaxCall(eventFunction.config);
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


            

            //Sales Return Get Bill Details
            StartEndDateByReport: function () {
                var startDate = $("#startDate").val();
                var StartHour = $("#StartHour").val();
                var StartMin = $("#StartMin").val();
                var Sdate = startDate + " " + StartHour + ":" + StartMin
                var EndDate = $("#EndDate").val();
                var EndHour = $("#EndHour").val();
                var EndMin = $("#EndMin").val();
                var EDate = EndDate + " " + EndHour + ":" + EndMin
                var BillNo = $("#txtBillNo").val();
                eventFunction.config.method = "getSalesReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: Sdate, endDate: EDate, billNo: BillNo });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            


            BindSalesDaily: function () {
                $("#DailyReport").show();
                $("#DailyReport").html('');
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

                dailyList = salesReport;

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
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Taxable Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>VAT</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Net Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Received Amnt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Sur/Def</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;' class='sort_disable tdcenter' >Action</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                var PAX = 0;
                var Su = 0;
                var to = 0;
                var Ba = 0;
                var Se = 0;
                var Va = 0;
                var Taxable = 0;
                var Ne = 0;
                var Ra = 0;
                var SD = 0;
                var count = 1;
                var roomTable = "";
                //var smID = "";
                if (dailyList.length > 0) {
                    $.each(dailyList, function (index, value) {
                        
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
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.BasicAmount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.ServiceCharge.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + (value.NetAmount - value.Vat).toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Vat.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.NetAmount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.ReceivedAmount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.SurplusDeficit.toFixed(2) + "</td>";

                             htmls += '<td class="tdcenter">'
                            htmls += '<label id = "' + value.salesMasterId + "_" + value.SPMID + "_" + value.Status + "_" + value.SalesType + '" class="icon-preview btnViewBill" /> ';

                            htmls += '<td class="tdcenter">';

                            var roles = userRole.split(',');
                        if (roles.includes("Super User") || roles.includes("Void Bill")) {
                                if (value.IsArchived != 1) {
                                    htmls += '<label id="' + value.salesMasterId + '" class="icon-close btnCancelBill"/>';
                                }
                            }
                            htmls += '</td>';
                            count++;
                            PAX += value.GuestNo;
                            Su += value.SubTotal;
                            to += value.totaldiscount;
                            Ba += value.BasicAmount;
                            Se += value.ServiceCharge;
                            Va += value.Vat;
                            Taxable += (value.NetAmount - value.Vat);
                            Ne += value.NetAmount;
                            Ra += value.ReceivedAmount;
                            SD += value.SurplusDeficit;
                            TotalAmount = TotalAmount + value.NetAmount;
                            htmls += "</tr>"
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
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Taxable.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Va.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ne.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ra.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + SD.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' colspan=2></th>";
                htmls += "</tr>"
                htmls += "</tfoot>"
                TotalAmount = 0;
                htmls += "</table>";
                
                $('#DailyReport').html(htmls);





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