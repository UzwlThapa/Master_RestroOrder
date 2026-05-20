function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#reportDisplay').html();
    $('#printedDate').hide();
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
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/BillsReport/',
             }, p);
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "BillsReportService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },

            init: function () {
                eventFunction.GetProviderList();
                $("#reportDisplay").hide();

                $("#btnView").on('click', function() {
                    $('.report-view').show();
                    var view = $("#viewOption").val();
                    if (view == 0) {
                        eventFunction.GetAllProviderReport();
                    }
                    else if (view == 1) {
                        eventFunction.GetDayProviderReport();
                    }
                    else if (view == 2) {
                        eventFunction.GetSummaryProviderReport();
                    }
                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                          
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
   
                    let file = new Blob([$('#reportDisplay').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ProvidersReport_" + $('#startDate').val() + '-' + $("#endDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#reportDisplay"), 0, 0, options, function () {
                        pdf.save('ProvidersReport_' + $('#startDate').val() + '-' + $("#endDate").val() + '.pdf');
                    });
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
                    failure: eventFunction.ajaxFailure
                });
            },

            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        eventFunction.BindProviderList(data.d);
                        
                        break;
                    case 2:
                        eventFunction.BindAllProviderReport(data.d);
                        break;
                    case 3:
                        eventFunction.BindDayProviderReport(data.d);
                        break;
                    case 4:
                        eventFunction.BindSummaryProviderReport(data.d);
                        break;
                   
                };
            },

            ajaxFailure: function (error) {
                console.debug(error);
            },

            GetProviderList: function () {
                eventFunction.config.method = "GetProviderList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindProviderList: function (result) {
                provider = JSON.parse(result);
                var htmls = "";
                $('#providerOption').html(htmls);
                htmls += '<option value="0"> All </option>';
                $.each(provider, function (index, value) {
                    htmls += '<option value="' + value.ProviderID + '">' + value.ProviderName + '</option>';
                });
                $('#providerOption').html(htmls);
            },

            GetAllProviderReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#endDate").val() + " " + 23 + ":" + 59;
                var payOption = $("#payOption").val();
                var providerOption = $("#providerOption").val();
                eventFunction.config.method = "getAllProvidersReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({startDate: startDate, endDate: endDate, paymentMode: payOption, provider: providerOption})
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindAllProviderReport: function (result) {
                
                var totalReceivedAmt = 0;
                $("#reportDisplay").show();
                $("#reportDisplay").html('');
                allList = JSON.parse(result);
                    var htmls = '';
                    htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                    htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                    htmls += '<p style="margin:0;text-align:center;">Providers Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#endDate').val() + '</p>';
                    htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;"">Printed On : <label id="lblPrintedOn"></label></p></div>';
                    htmls += "<table id='allSalesReport' cellspacing='0' class='reportsprint' style='border:none;width:100%;border-collapse:collapse;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th>";
                    htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'>Provider Name</th>";
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Received Medium</th>";
                    htmls += "<th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Received Amount</th>";
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Mode</th>";
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Cheque / Transaction No</th>"
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    if (allList.length > 0) {
                    $.each(allList, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td class='b' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.billDate.split(' ')[0] + "</td>";
                        htmls += "<td class='f' style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ProviderName + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.TransactionNo + "</td>";
                        htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.payAmount.toFixed(2) + "</td>";
                        var payment = "";
                        if (value.paymentID == 2) {
                            payment = "CHEQUE";
                        }
                        else if (value.paymentID == 3) {
                            payment = "SWAP";
                        }
                        else if (value.paymentID == 5) {
                            payment = "ESEWA";
                        }
                        else if (value.paymentID == 6) {
                            payment = "FONEPAY";
                        }
                        htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + payment + "</td>";
                        htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.billNo + "</td>"
                        htmls += '</tr>';

                        totalReceivedAmt += value.payAmount;
                    });

                    htmls += "<tr>";
                    htmls += "<td colspan='3' style='text-align:right;border:1px solid #575757;padding:2px;'><strong>Total :</strong></td>";
                    htmls += "<td colspan='1' style='text-align:right;border:1px solid #575757;padding:2px;'><strong>Rs. " + totalReceivedAmt.toFixed(2) + "</strong></td>";
                    htmls += "<td colspan='2' style='text-align:center;'></td>";
                    htmls += '</tr>';
                    } else {
                        htmls += "<tr>";
                        htmls += "<td colspan='7' style='text-align:center;'> No Data </td>";
                        htmls += '</tr>';
                    }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $("#reportDisplay").html(htmls);
           
            },

            GetDayProviderReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#endDate").val() + " " + 23 + ":" + 59;
                var payOption = $("#payOption").val();
                var providerOption = $("#providerOption").val();
                eventFunction.config.method = "getDayProvidersReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, paymentMode: payOption, provider: providerOption })
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindDayProviderReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');

                daylist = JSON.parse(result);
                var htmls = '';
                var tblTotalSales = 0;
                var tblRecAmt = 0;
                    htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                    htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                    htmls += '<p style="margin:0;text-align:center;">Providers Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#endDate').val() + '</p>';
                    htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                    htmls += "<table id='daySalesReport' cellspacing='0' class='reportsprint' style='border:none;width:80%;border-collapse:collapse;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th>";
                    htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'>Provider Name</th>";
                    htmls += "<th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Received Amount</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    if (daylist.length > 0) {
                    $.each(daylist, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td class='b' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.billDate.split(' ')[0] + "</td>";
                        htmls += "<td class='f' style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ProviderName + "</td>";
                        htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.payAmount.toFixed(2) + "</td>";
                        htmls += '</tr>';
                        tblRecAmt += value.payAmount;
                    });
                    } else {
                        htmls += "<tr>";
                        htmls += "<td colspan='8' style='text-align:center;'> No Data </td>";
                        htmls += '</tr>';
                    }
                    htmls += "</tbody>";
                    htmls += "<tfoot>";
                    htmls += "<tr>";
                    htmls += '<tr><th colspan=2 style="text-align:center;">Total:</th>';
                    htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblRecAmt.toFixed(2) + '</th>';
                    htmls += '</tr>';
                    htmls += "</tfoot>";
                    htmls += "</table>";

                    $("#reportDisplay").html(htmls);
                
            
            },

            GetSummaryProviderReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#endDate").val() + " " + 23 + ":" + 59;
                var payOption = $("#payOption").val();
                var providerOption = $("#providerOption").val();
                eventFunction.config.method = "getSummaryProvidersReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, paymentMode: payOption, provider: providerOption })
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindSummaryProviderReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');

                summarylist = JSON.parse(result);
                var htmls = '';
                var tblTotalSales = 0;
                var tblDiscount = 0;
                var tblService = 0;
                var tblVAT = 0;
                var tblNetAmnt = 0;
                var tblRecAmt = 0;
                  htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                  htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                  htmls += '<p style="margin:0;text-align:center;">Providers Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#endDate').val() + '</p>';
                  htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                    htmls += "<table id='summarySalesReport' cellspacing='0' class='reportsprint' style='border:none;width:70%;border-collapse:collapse;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'>Provider Name</th>";
                    htmls += "<th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Received Amount</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    if (summarylist.length > 0) {
                    $.each(summarylist, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td class='f' style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ProviderName + "</td>";
                        htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.payAmount.toFixed(2) + "</td>";
                        htmls += '</tr>';
                        tblRecAmt += value.payAmount;
                    });
                    } else {
                        htmls += "<tr>";
                        htmls += "<td colspan='2' style='text-align:center;'> No Data </td>";
                        htmls += '</tr>';
                    }
                    htmls += "</tbody>";
                    htmls += "<tfoot>";
                    htmls += "<tr>";
                    htmls += '<tr><th style="text-align:center;">Total:</th>';
                    htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblRecAmt.toFixed(2) + '</th>';
                    htmls += '</tr>';
                    htmls += "</tfoot>";
                    htmls += "</table>";
                    $("#reportDisplay").html(htmls);
               
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
