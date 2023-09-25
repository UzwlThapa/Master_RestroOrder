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
                 ModulePath: '/Modules/RoReport/',
                 CompanyName: '',
                 Pan: ''

             }, p);
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
            init: function () {
                eventFunction.GetCostCenter();
                eventFunction.GetCategoryName();
                $("#btnView").on('click', function () {
                    var viewID = $("#selectViewBy").val();
                    if (viewID == 1) {
                        eventFunction.GetDailyItemSalesReport();
                    }
                    else if (viewID == 2) {
                        eventFunction.GetSummaryItemSalesReport();
                    }
                    $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#reportDisplay').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ItemSalesReport_" + $('#startDate').val() + '_' + $("#EndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.setFontSize(20);
                    pdf.setFont("times");
                    pdf.setFontType("bold");
                    pdf.setTextColor(255, 0, 0);
                    pdf.internal.scaleFactor = 2.25;
                    pdf.addHTML($("#reportDisplay"), 0, 0, options, function () {
                        pdf.save('ItemSalesReport_' + $('#startDate').val() + '_' + $("#EndDate").val() + '.pdf');
                    });

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
                        eventFunction.BindDailyItemSalesReport(data.d);
                        break;
                    case 2:
                        eventFunction.BindSummaryItemSalesReport(data.d);
                        break;
                    case 3:
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 4:
                        eventFunction.BindCategoryName(data.d);
                        break;
                };
            },
            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },


            GetCategoryName: function () {
             
                var categorylevel = 0;
                eventFunction.config.method = "GetCategoryHirerchy";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ categorylevel: categorylevel })
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetDailyItemSalesReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#EndDate").val() + " " + 23 + ":" + 59;
                var costCenterID = $("#selectFilterBy").val();
                var pitid = $("#ddlCategory").val();
                eventFunction.config.method = "getDailyItemSalesReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, costCenterID: costCenterID, pitid: pitid })
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetSummaryItemSalesReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#EndDate").val() + " " + 23 + ":" + 59;
                var costCenterID = $("#selectFilterBy").val();
                var pitid = $("#ddlCategory").val();
                eventFunction.config.method = "getSummaryItemSalesReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, costCenterID: costCenterID, pitid: pitid })
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            ajaxFailure: function (error) {
                console.debug(error);
            },

            BindCostCenter: function (result) {

                costlist = JSON.parse(result);
                $('#selectFilterBy').html("");
                var htmls = "";

                htmls += "<option value='0' selected>--ALL--</option>";
                $.each(costlist, function (index, item) {
                    htmls += "<option value='" + item.CostCenterID + "'>" + item.CostCenterName + "</option>";
                });
                $('#selectFilterBy').html(htmls);
            },

            BindCategoryName: function (result) {

                datas = JSON.parse(result);
                $("#ddlCategory").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='0' selected>-All-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });
                    $("#ddlCategory").html(htmls);
                }

            },
            BindDailyItemSalesReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                summarylist = JSON.parse(result);
                var htmls = '';
                var ttlQnty = 0;
                var ttlRate = 0;
                var ttlTotal = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Item Sales Report </p> <p style="text-align:center;margin:0;">From : ' + $('#startDate').val() + ' To : ' + $('#EndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='dailyItemSalesReport' cellspacing='0' class='reportsprint' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Bill Date</th>";
                //htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Item ID</th>";
                htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'>Item Name</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Cost Center</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Quantity</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Unit</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;'>Rate</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;'>Total</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (summarylist.length > 0) {
                    $.each(summarylist, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.BillDate.split(' ')[0] + "</td>";
                        //htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ITId + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ITName + "</td>";
                        htmls += "<td class='f' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.CostCenterName + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Quantity + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ITUnit + "</td>";
                        htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.rate.toFixed(2) + "</td>";
                        htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Quantity  * value.rate.toFixed(2) + "</td>";
                        htmls += '</tr>';

                        ttlQnty += parseFloat(value.Quantity);
                        ttlRate += parseFloat(value.rate);
                        ttlTotal += parseFloat(value.Quantity) * parseFloat(value.rate);
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='7' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";

                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += "<td colspan=3 style='text-align: right;'>Total: </td>";
                htmls += "<td style='text-align: center;'>" + ttlQnty + "</td>"
                htmls += "<td></td>"
                htmls += "<td style='text-align: right;'>" + ttlRate + "</td>"
                htmls += "<td style='text-align: right;'>" + ttlTotal + "</td>"
                htmls += "</tfoot>"
                htmls += "</table>";
                $("#reportDisplay").html(htmls);
                
            },

            BindSummaryItemSalesReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                summarylist = JSON.parse(result);
                var htmls = '';
                var ttlQnty = 0;
                var ttlRate = 0;
                var ttlTotal = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Item Sales Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#EndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='summaryItemSalesReport' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>";
                htmls += "<thead>";
                htmls += "<tr>";
               // htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Item ID</th>";
                htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'>Item Name</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Cost Center</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Quantity</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Unit</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;'>Rate</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;'>Total</th>";
                htmls += "</tr>";
                htmls += "</thead>";
                htmls += "<tbody>";
                if (summarylist.length > 0) {
                $.each(summarylist, function (index, value) {
                    htmls += "<tr>";
                    //htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ITId + "</td>";
                    htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ITName + "</td>";
                    htmls += "<td class='f' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.CostCenterName + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Quantity + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ITUnit + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.rate.toFixed(2) + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;'>" + parseFloat(value.Quantity) * parseFloat(value.rate) + "</td>";
                    htmls += '</tr>';
                    ttlQnty += parseFloat(value.Quantity);
                    ttlRate += parseFloat(value.rate);
                    ttlTotal += parseFloat(value.Quantity) * parseFloat(value.rate);
                });
            }
                else {
                htmls += "<tr>";
                htmls += "<td colspan='4' style='text-align:center;'> No Data </td>";
                htmls += '</tr>';
            }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += "<td colspan=2 style='text-align: right;'>Total: </td>";
                htmls += "<td style='text-align: center;'>" + ttlQnty + "</td>"
                htmls += "<td></td>"
                htmls += "<td style='text-align: right;'>" + ttlRate + "</td>"
                htmls += "<td style='text-align: right;'>" + ttlTotal + "</td>"
                htmls += "</tfoot>"
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