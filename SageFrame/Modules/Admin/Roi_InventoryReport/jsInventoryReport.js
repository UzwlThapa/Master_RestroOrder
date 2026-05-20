
function print() {
    var contents = $('#ViewReport').html();
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
}

function prints() {
    $('#printedDate').show();
    $('#reportDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#DailyReport').clone();
    contents.find('tr th:nth-child(9), tr td:nth-child(9)').remove();
    $('#printedDate').hide();
    $('#reportDate').hide();
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
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Admin/Roi_InventoryReport/'
             }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var Amount = 0;
        var VAT = 0;
        var VATAmount = 0;
        var IsVat = false;
        var VatItemTotal = 0;
        var NonVatItemTotal = 0;
        var TotalDiscount = 0;
        var ExtraDiscount = 0;
        var TaxAmount = 0;
        var TotalAmount = 0;
        var PuNoArray = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsInventoryReport.asmx/",
            
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.GetPurchaseNo();
                eventFunction.getmemberForVender();

                $("#txtMonthlyDate").datepicker({
                    dateFormat: 'yy-m',
                });
                $(".hide").hide();
                for (i = new Date().getFullYear() ; i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnViewByPurchaseNo").click(function () {
                    var puNo = $("#txtPurchaseNo").val();
                    eventFunction.getPurchaseReportByPuNo(puNo);
                });
              
                $("#ReportingDays").on('change', function () {
                    var values = parseInt($('#ReportingDays').val());
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
                  
                    eventFunction.GetPurchaseReport();
                    $(".report-view").show();
                    
                });


            
                //----------------------------------------Wekly----------------
                $("#btnViewWeekly").on('click', function () {
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (reportnumber == 1) {
                        eventFunction.GetDailyReportByWeekly
                        $(".byNo").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (reportnumber == 2) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    //else if (reportnumber == 3)
                    {
                        eventFunction.GetDailyReportByWeekly();
                        //$(".waiter").hide();
                        //$(".c").hide();
                        //$(".e").hide();
                        //$(".table").hide();
                    }
                });
                //----------------------------------------Monthly----------------
                $("#btnViewMonthly").on('click', function () {
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (reportnumber == 1) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (reportnumber == 2) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    //else if (reportnumber == 3)
                    {
                        eventFunction.GetDailyReportByMonthly();
                        //$(".waiter").hide();
                        //$(".c").hide();
                        //$(".e").hide();
                        //$(".table").hide();
                    }
                });
                //----------------------------------------Yearly----------------
                $("#btnViewYearly").on('click', function () {
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (reportnumber == 1) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (reportnumber == 2) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    //else if (reportnumber == 3)
                    {
                        eventFunction.GetDailyReportByYearly();
                        //$(".waiter").hide();
                        //$(".c").hide();
                        //$(".e").hide();
                        //$(".table").hide();
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
           

            $("#btnExport").click(function (e) {
                $('#printedDate').show();
                $('#reportDate').show();
                var dNow = new Date();
                $('#lblPrintedOn').html(dNow);
                $('#printedDate').hide();
                var contents = $('#DailyReport').clone();
                contents.find('tr th:nth-child(9), tr td:nth-child(9)').remove();
                let file = new Blob([contents.get(0).innerHTML], { type: "application/vnd.ms-excel" });
                let url = URL.createObjectURL(file);
                let a = $("<a />", {
                    href: url,
                    download: "Purchase_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                }).appendTo("body").get(0).click();
                e.preventDefault();
                $('#printedDate').hide();
                $('#reportDate').hide();
            });
                $('#btnPrint').on('click', function () {
                    prints();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    var contents = $('#DailyReport');
                    contents.find('tr th:nth-child(9), tr td:nth-child(9)').hide();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#DailyReport"), 0, 0, options, function () {
                        pdf.save('Purchase_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    contents.find('tr th:nth-child(9), tr td:nth-child(9)').show();
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });
            },

            GetPurchaseNo: function () {
                eventFunction.config.method = "getPurchaseNoForReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindPurchaseDetails: function (result) {
                var datas = JSON.parse(result);
                if (datas.length > 0) {
                    var htmls = '';
                    $.each(datas, function (index, v) {
                        PuNoArray.push(v.PuNo);
                    });
                    $("#txtPurchaseNo").autocomplete({
                        source: PuNoArray,
                        focus: function (event, ui) {
                            // prevent autocomplete from updating the textbox
                            event.preventDefault();
                            // manually update the textbox
                            $(this).val(ui.item.label);
                        },
                    });
                }
            },

            getPurchaseReportByPuNo: function (puNo) {
                eventFunction.config.method = "getPurchaseReportByPuNo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ puNo: puNo });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },


            getmemberForVender: function () {
                var customer = 0;
                eventFunction.config.method = "getsdatass";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ customer: customer });
                eventFunction.config.ajaxCallMode = 4;
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
                        eventFunction.BindSalesDaily(data);
                        break;
                    case 1:
                        eventFunction.BindAdjustmentReport(data.d);
                        break;
                    case 2:
                        eventFunction.BindDaily(data);
                        break;
                    case 3:
                        eventFunction.BindPurchaseDetails(data.d);
                        break;
                    case 4:
                        eventFunction.BindVendor(data.d);
                        break;
                    case 5:
                        eventFunction.BindPurchaseReport(data.d);
                        break;
                    case 6:
                        eventFunction.BindPurchaseDetailsReport(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },

            GetPurchaseReport: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                var vendorid = $("#ddlVendorList").val() == null ? 0 : $("#ddlVendorList").val();
                var puNo = $("#txtPurchaseNo").val();

                eventFunction.config.method = "getPurchaseReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startdate , endDate: enddate , vendorId: vendorid, puNo: puNo});
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByWeekly: function () {
                var todaydate = $("#txtStartDate").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReportByWeekly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dateTime: todaydate, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = (reportNumber == 4 ? 0 : 1);
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByMonthly: function () {
                var year = $("#seit").val();
                var month = $("#month").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReportByMonthly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, month: month, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = (reportNumber == 4 ? 0 : 1);
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByYearly: function () {
                var year = $("#seit").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReportByYearly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = (reportNumber == 4 ? 0 : 1);
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPurchaseDetailsbypurchaseID: function (purchasemainID) {
                eventFunction.config.method = "GetGoodsRecieveFromPurchaseID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    purchasemainID: purchasemainID
                });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindVendor: function (data) {
 
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "";
                    htmls += "<option value='0' selected > All </option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.MembershipID + "'>" + value.Fname + "</option>";
                    });

                    $("#ddlVendorList").html(htmls);
                }
            },

            BindPurchaseReport: function (data) {
                $("#DailyReport").show();
                $("#DailyReport").html();
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var datas = JSON.parse(data);
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Purchase Report <p style="text-align:center;margin:0;">From : ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val())  + '   To : ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='tableForPurchaseReport' class='reportsprint' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>PurchaseNo.</th><th>Purchase Date</th><th>Vender</th><th>Address</th><th>Amount(Rs.)</th><th>fiscal Year</th><th>PostedBy</th><th>PostedOn</th><th>View</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                 htmls += "<tbody>"
               
                
                if (datas.length > 0) {
                    var count = 1;
                    $.each(datas, function (index, value) {
                       
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.PuNo + "</td>";
                        htmls += "<td>" + value.BillDate + "</td>";
                        htmls += "<td>" + value.VenderName + "</td>";
                        htmls += "<td>" + value.Address + "</td>";
                        if (value.IsVat) {
                            Amount = value.Amount + (value.Amount * 0.13);
                            htmls += "<td>" + Amount.toFixed(2) + "</td>";
                            TotalAmount = TotalAmount + Amount;
                        }
                        else {
                            htmls += "<td>" + value.Amount.toFixed(2) + "</td>";
                            TotalAmount = TotalAmount + value.Amount;
                        }
                      
                        htmls += "<td>" + value.fyName + "</td>";
                        htmls += "<td>" + value.PostedBy + "</td>";
                        var posted = value.PostedOn.split(" ");
                        htmls += "<td>" + value.PostedOn + "</td>";
                        htmls += "<td><img src='/images/view.png' class='PurchaseView preview-icon' type='button'  id=" + value.PurchaseMainID + " value='View'  /></td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<tr>";
                    htmls += "<td colspan='5' class='tot-rig'>Total Amount :</td>";
                    htmls += "<td> Rs. " + (TotalAmount).toFixed(2) + "</td>";
                    htmls += "<td colspan='4'></td>";
                    htmls += "</tr>";
                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                    // jAlert('No data Available', 'Information!!', function () { $.alerts.dialogClass = null; });
                }
          
                    
             
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);
                   
                

                $(".PurchaseView").on('click', function () {
                    var PoNO = $(this).attr('id');
                    //window.open('/Modules/RoiPurchase/Purchase-Order.aspx?ID=' + PoNO, '_blank');
                    eventFunction.GetPurchaseDetailsbypurchaseID(parseInt(PoNO));
                    $('#PurchaseViewReport').dialog({
                        'title': 'Purchase order',
                        width: '400',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top']
                    });
                });
            },

            BindPurchaseDetailsReport: function (data) {
                $("#PurchaseViewReport").html();
                var datas = JSON.parse(data);
                var companyInfo = datas.companyInfo;
                var purchaseMain = datas.goodsMain;
                var htmls = '';
                var date = purchaseMain[0].InvoiceDate.split("T");
                htmls += '<input type="button" id="btnPrints" value="Print" class="sfBtn restro-btn">';

                htmls += '<div id="ViewDetailsReport" style="margin-top:10px;">';
                htmls += "<table style='width:100%;border:1px solid;padding-bottom:5px;padding-right:5px;margin:0;'>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align:center;padding-top:10px;padding-bottom:10px;border-bottom:1px solid;'><b id='InvoiceType'>INVOICE</b></td></tr>";
                htmls += "<tr><td rowspan='4' colspan='1' style='font-size:22px;font-weight:bold;border-right:1px solid;border-bottom:1px solid;text-align:center;'> Purchase Order </td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:16px;font-weight:bold;border-bottom:1px solid;'>" + companyInfo[0].Name + "</td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:12px;border-bottom:1px solid;'>" + companyInfo[0].Address + "</td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:12px;border-bottom:1px solid;'>" + companyInfo[0].PhoneNo + "</td></tr>";

                htmls += "<tr><td style='font-size:11px;text-align:left;'> InvoiceNo : " + purchaseMain[0].InvoiceNo + "</td>";
                htmls += "<td style='font-size:11px;text-align:right;'> Date : " + date[0] + "</td></tr>";
                htmls += "<tr><td style='font-size:11px;text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>";
                htmls += "<td style='font-size:11px;text-align:right;'> Payment Mode : " + purchaseMain[0].PayMode + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Seller's Name. : " + purchaseMain[0].Fname + "</td>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Address. : " + purchaseMain[0].Address + "</td>";
                htmls += "</tr></table>";

                htmls += "<table id='tableForPurchaseDetailsReport' class='sfGridwrapper display' cellspacing='0' style='width:100%;text-align:left;border:1px solid;border-top:none;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:5%;'>SN</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:45%;'>ItemName</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Quantity</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Rate</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:20%;'>Total</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:12%;'>Disc</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                var count = 1;
                $.each(purchaseMain, function (index, value) {
                    htmls += "<tbody style='border-bottom:1px solid;'>"
                    htmls += "<tr>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:5%;'>" + count + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:45%;'>" + (value.IsVat ? '' : '*') + "" + value.ITName + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.Quentity + ' ' + value.Symbol + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.UnitRate + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:15%;'>" + value.Total + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.Discount + "</td>";

                    if (value.IsVat == true) {
                        VatItemTotal += parseFloat(value.Total) ;
                        VAT += parseFloat(value.Total) - parseFloat(value.Discount);
                    } else {
                        NonVatItemTotal += parseFloat(value.Total);
                    }
                    TotalDiscount += parseFloat(value.Discount);
                    htmls += "</tr>"
                    count++;
                });
                ExtraDiscount = parseFloat(purchaseMain[0].ExtraDiscount);
                TaxAmount = VAT * 0.13;
                TotalAmount = (VatItemTotal + NonVatItemTotal + TaxAmount) - (TotalDiscount + ExtraDiscount);
                htmls += "</tbody>";
                htmls += "<tfoot>"
                htmls += "<tr><td rowspan='7' colspan='3' style='font-size:12px;border-top:1px solid;border-right:1px solid;'>In Words Rs. " + convertNumberToWords(TotalAmount) + " only.</td></tr>"
                htmls += "<tr>"

                htmls += "<td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Taxable Total</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + VatItemTotal.toFixed(2) + "</td></tr>";
                htmls += "<td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Nontaxable Total</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + NonVatItemTotal.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Total Discount </td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalDiscount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Extra Discount </td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + ExtraDiscount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>13 % VAT</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TaxAmount.toFixed(2) + "</td></tr>";
                // htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>13 % VAT </td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + VAT.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Net Amount</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalAmount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='7' style='font-size:12px;border-top:1px solid;text-align:left;padding-top:5px;'>Note:- (*) Sign Before Product Name is Non Taxable Items.</td></tr>"
                htmls += "</tr><tr><td colspan='7' ><div style='width:100px;text-align:center;border-top:1px solid;float:right;'>Signature</div></td></tr>"
                htmls += "</tfoot>"
                TotalAmount = 0;
                VAT = 0;
                VatItemTotal = 0;
                NonVatItemTotal = 0;
                TotalDiscount = 0;
                ExtraDiscount = 0;
                TaxAmount = 0;

                htmls += "</table>";
                htmls += "</div>";
                $('#PurchaseViewReport').html(htmls);

                $("#btnPrints").click(function () {
                    print();
                });

            },

            BindSalesDaily: function (data) {
         
                $("#DailyReport").show();
                $("#DailyReport").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var PuNo = "";
                    var VenderName = "";
                    var Address = "";
                    $.each(datas, function (index, value) {
                        PuNo = value.PuNo;
                        VenderName = value.VenderName;
                        Address = value.Address;
                    });

                    var htmls = "<table id='salseReport' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
               
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th class='byNo'>PurchaseNo.</th><th class='byNo'>Vender</th><th class='byNo'>Address</th><th>Item Name</th><th>Qty</th><th>Unit</th><th>Rate(Rs.)</th><th>VAT(Rs.)</th><th>Amount(Rs.)</th><th>fiscal Year</th><th>PostedBy</th><th>PostedOn</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td class='byNo'>" + value.PuNo + "</td>";
                        htmls += "<td class='byNo'>" + value.VenderName + "</td>";
                        htmls += "<td class='byNo'>" + value.Address + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td class='b'>" + value.Qnty + "</td>";
                        htmls += "<td>" + value.UnitName + "</td>";
                        htmls += "<td>" + value.UnitRate + "</td>";
                        //TotalAmount += (value.Qnty * value.UnitRate);
                        if (value.IsVat) {
                            htmls += "<td>" + ((value.Qnty * value.UnitRate) * 0.13).toFixed(2) + "</td>";
                            TotalAmount = TotalAmount + (value.Qnty * value.UnitRate) * 0.13;
                            htmls += "<td class='d'>" + (parseFloat(value.Qnty * value.UnitRate) +( parseFloat(value.Qnty * value.UnitRate) * 0.13)).toFixed(2) + "</td>";
                        }
                        else {
                            htmls += "<td>0</td>";
                            TotalAmount = TotalAmount + (value.Qnty * value.UnitRate);
                            htmls += "<td class='d'>" + (parseFloat(value.Qnty * value.UnitRate)).toFixed(2) + "</td>";
                        }
                        htmls += "<td class='byNo'>" + value.fyName + "</td>";
                        htmls += "<td>" + value.PostedBy + "</td>";
                        var posted = value.PostedOn.split(" ");
                        htmls += "<td >" + posted[0] + " " + posted[1] + " " + posted[2] + "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<tfoot>"
                
                    {
                        htmls += "<tr>";
                        htmls += "<th colspan='10' class='tot-rig'>Total Amount : Rs. " + (TotalAmount).toFixed(2) + "</th>";
                        htmls += "<th colspan='3'></th>";
                        htmls += "</tr>"
                    }
                    htmls += "</tfoot>"
                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;
               
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);

                    $('#salseReport').DataTable({
                        "jQueryUI" : true,

                        dom: 'Bfrtip',
                        autoWidth: true,
                        ordering: true,
                        scrollX: true,
                        ordering: false,

                        buttons: [

                            'print', 'excel', 'pdf'
                        ]
                    });
                } else {
                    $('#DailyReport').html("No Data Available");
                }
            },

            BindAdjustmentReport: function (data) {
                $("#DailyReport").show();
                $("#DailyReport").html('');
            
                datas = JSON.parse(data);
                var htmls = "<table id='salseReport' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"

                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>AdjustmentNo.</th><th>Item Name</th><th>Qty</th><th>Unit</th><th>Adjustment Type</th><th>Store</th><th>fiscal Year</th><th>PostedBy</th><th>PostedOn</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                if (datas.length > 0) {

                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.AMNo + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td class='b'>" + value.Qnty + "</td>";
                        htmls += "<td>" + value.UnitName + "</td>";
                        htmls += "<td>" + value.AdjustmentTypeName + "</td>";
                        htmls += "<td>" + value.StName + "</td>";
                        htmls += "<td >" + value.fyName + "</td>";
                        htmls += "<td>" + value.PostedBy + "</td>";
                        var posted = value.PostedOn.split(" ");
                        htmls += "<td >" + posted[0] + "</td>";
                        htmls += "</tr>"
                        count++;
                        //TotalAmount = TotalAmount + (value.Quentity * value.UnitRate);
                    });
                 
                    TotalAmount = 0;
                } else {
                    $('#DailyReport').html('No data');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);

                    $('#salseReport').DataTable({
                         "jQueryUI" : true,
                          autoWidth: true,
                          ordering: false,
                        dom: 'Bfrtip',

                        buttons: [

                            'print', 'excel', 'pdf'
                        ],
                         scrollX: true,
                    });
                
            },

            BindDaily: function (data) {
                var billt = parseInt($('#HiddenField1').val());
                var CheckTerm = "";
                $("#DailyReport").show();
                $("#DailyReport").html('');
                var datas = data.d;
                var htmls = "<table id='salseReport' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Date</th><th>Time</th><th>Bill No.</th><th>Waiter</th>";
                if (billt == 2) {
                    htmls += "<th>Vat</th><th>Vat Amount</th>";
                    CheckTerm = "VAT";
                } else if (billt == 3) {
                    htmls += "<th>Service Charge</th><th>Service Amount</th>";
                    CheckTerm = "Service Charge";
                }

                htmls += "<th>Amount</th><th></th>";
                htmls += "</tr>"
                htmls += "</thead>"
                if (datas.length > 0) {
                  
                    htmls += "<tbody>"
                    var count = 1;
                    var previousitem = 0;
                    $.each(datas, function (index, value) {
                        var p = value.BillTerm;

                        if (p == CheckTerm && value.BilingID != 1) {
                            htmls += "<tr>";
                            htmls += "<td class='a'>" + count + "</td>";
                            htmls += "<td class='b'>" + value.BillDate.split(' ')[0] + "</td>";
                            htmls += "<td class='b'>" + value.BillDate.split(' ')[1] + "</td>";
                            htmls += "<td>" + value.billNo + "</td>";
                            htmls += "<td>" + value.Waiter + "</td>";
                            htmls += "<td >" + value.BillTerm + "</td>";
                            htmls += "<td >Rs. " + value.Amount + "</td>";
                            htmls += "<td class='f'>Rs. " + value.NetAmount + "</td>";
                            htmls += '<td><input type="button" id="' + value.OrderMasterId + '" class="btnViewBill sfBtn" value="View Bill"/></td>';
                            htmls += "</tr>"
                            count++;
                            TotalAmount = TotalAmount + value.NetAmount;
                            previousitem = value.billNo;
                        }
                    });
                    htmls += "<thead class='Sales-total_amount'>"
                    htmls += "<tr>";
                    htmls += "<th colspan='3' class='a' style='text-align:right;'>" + "Total Amount :" + "</th>";
                    htmls += "<th class='f'>Rs. " + TotalAmount.toFixed(2) + "</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"

                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;
                } else {
                    $('#DailyReport').html('No data');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);

                    $('#salseReport').DataTable({
                         "jQueryUI" : true,
                          autoWidth: true,
                        dom: 'Bfrtip',

                        buttons: [

                            'print', 'excel', 'pdf'
                        ],
                         scrollX: true,
                         ordering: false,
                    });

                    $("#salseReport").on("click", ".btnViewBill", function () {
                        var ids = $(this).attr('id');
                        window.open('/CustomerBill.aspx?MID=' + ids, '_blank');
                    });
              
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
