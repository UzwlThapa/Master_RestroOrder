function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#reportDisplay').html();
    $('#printedDate').hide();
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
                 ModulePath: '/Modules/CostCenterwiseReport/',
             }, p);
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
                baseURL: p.ModulePath + "CostCenterwiseService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },

            init: function () {
                eventFunction.GetCostCenter();
                $("#reportDisplay").hide();

                $("#btnView").on('click', function () {
                    $('.report-view').show();
                    var view = $("#viewOption").val();
                    if (view == 1) {
                        eventFunction.GetDailyCostCenterReport();
                    }
                    else if (view == 2) {
                        eventFunction.GetSummaryCostCenterReport();
                    }
                    else if (view == 0) {
                        eventFunction.GetAllCostCenterReport();
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
                        download: "CostCenterReport_" + $('#startDate').val() + '-' + $("#endDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
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
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#reportDisplay"), 0, 0, options, function () {
                        pdf.save('CostCenterReport_' + $('#startDate').val() + '-' + $("#endDate").val() + '.pdf');
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
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 2:
                        eventFunction.BindAllCostCenterReport(data.d);
                        break;
                    case 3:
                        eventFunction.BindDailyCostCenterReport(data.d);
                        break;
                    case 4:
                        eventFunction.BindSummaryCostCenterReport(data.d);
                        break;
                };
            },

            ajaxFailure: function (error) {
                console.debug(error);
            },

            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindCostCenter: function (result) {

                costList = JSON.parse(result);

                var htmls = "";
                $('#costcenterOption').html(htmls);
                htmls += '<option value="0"> All </option>';
                $.each(costList, function (index, value) {
                    htmls += '<option value="' + value.CostCenterID + '">' + value.CostCenterName + '</option>';
                });
                $('#costcenterOption').html(htmls);
            },

            GetAllCostCenterReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#endDate").val() + " " + 23 + ":" + 59;
                var costCenter = $("#costcenterOption").val();
                eventFunction.config.method = "getAllCostCenterReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, costCenter: costCenter });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindAllCostCenterReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');         
                allList = JSON.parse(result);
                var htmls = '';
                var tblQty = 0;
                var tblRate = 0;
                var tblTotal = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Cost Center Wise Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#endDate').val() + '</p>';

                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                    htmls += "<table id='allSalesReport' class='sfGridwrapper display reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Cost Center</th>";
                    htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'>Item Name</th>";
                    htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Quantity</th>";
                    htmls += "<th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Rate</th>";
                    htmls += "<th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Total Sales</th>";                   
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    if (allList.length > 0) {  
                    $.each(allList, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td class='f' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.CostCenterName + "</td>";
                        htmls += "<td class='b' style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ItemName + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Quantity + "</td>";
                        htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Rate.toFixed(2) + "</td>";
                        htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Total.toFixed(2) + "</td>";
                        htmls += '</tr>';
                        tblQty += value.Quantity;
                        tblRate += value.Rate;
                        tblTotal += value.Total;
                    });
                    }
                    else {
                        htmls += "<tr>";
                        htmls += "<td colspan='5' style='text-align:center;'> No Data </td>";
                        htmls += '</tr>';
                    }

                    htmls += "</tbody>";
                    htmls += "<tfoot>";
                    htmls += "<tr>";
                    htmls += '<tr><th colspan=2 style="text-align:center;">Total:</th>';
                    htmls += '<th style="text-align:center;border:1px solid #575757;padding:2px;">' + tblQty.toFixed(2) + '</th>';
                    htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblRate.toFixed(2) + '</th>';
                    htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblTotal.toFixed(2) + '</th>';
                    htmls += '</tr>';
                    htmls += "</tfoot>";
                    htmls += "</table>";
                    $("#reportDisplay").html(htmls);
                 
            },

            GetDailyCostCenterReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#endDate").val() + " " + 23 + ":" + 59;
                var costCenter = $("#costcenterOption").val();
                eventFunction.config.method = "getDailyCostCenterReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, costCenter: costCenter });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindDailyCostCenterReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');

                dailyList = JSON.parse(result);
                var htmls = '';
                var tblTotal = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Cost Center Wise Report From ' + $('#startDate').val() + ' To ' + $('#endDate').val() + '</p>';

                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='dailySalesReport' class='sfGridwrapper display reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Cost Center</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;'>Total Sales</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (dailyList.length > 0) {  
                $.each(dailyList, function (index, value) {
                    htmls += "<tr>";
                    htmls += "<td class='b' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.BillDate.split(' ')[0] + "</td>";
                    htmls += "<td class='f' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.CostCenterName + "</td>";
                    htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Total.toFixed(2) + "</td>";
                    htmls += '</tr>';
                    tblTotal += value.Total;
                });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='3' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += '<tr><th colspan=2 style="text-align:center;">Total:</th>';
                htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblTotal.toFixed(2) + '</th>';
                htmls += '</tr>';
                htmls += "</tfoot>";
                htmls += "</table>";
                $("#reportDisplay").html(htmls);
            
            },

            GetSummaryCostCenterReport: function () {
                var startDate = $("#startDate").val() + " " + 00 + ":" + 00;
                var endDate = $("#endDate").val() + " " + 23 + ":" + 59;
                var costCenter = $("#costcenterOption").val();
                eventFunction.config.method = "getSummaryCostCenterReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, costCenter: costCenter });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindSummaryCostCenterReport: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');

                summaryList = JSON.parse(result);
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Cost Center Wise Report From ' + $('#startDate').val() + ' To ' + $('#endDate').val() + '</p>';

                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='summarySalesReport' class='sfGridwrapperreportsprint display' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th  style='text-align:center;border:1px solid #575757;padding:2px;'>Cost Center</th>";
                htmls += "<th  style='text-align:center;border:1px solid #575757;padding:2px;'>Total Sales</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (summaryList.length > 0) {  
                $.each(summaryList, function (index, value) {
                    htmls += "<tr>";
                    htmls += "<td class='d'  style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.CostCenterName + "</td>";
                    htmls += "<td class='f'  style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Total.toFixed(2) + "</td>";
                    htmls += '</tr>';
                });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='2' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
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