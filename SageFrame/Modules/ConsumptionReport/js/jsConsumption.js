function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#divForConsumptionReport').html();
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
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ConsumptionReport/service/',
                 master: '0',
             }, p);
        var v = 0;
        var DiffAmount = 0;
        var Statement = "";
        var SalesStatement = "";
        var getClosingReport_StateWisegetClosingReport_StateWise = "";
        var StatementCategoryWise = "";
        var StatementBillWiseSales = "";
        var stat = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WSforConsumption.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },

            init: function () {
                $("#btnView").click(function () {
                    $(".report-view").show();
                    eventFunction.getConsumptionReportByDates();
                });


                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#divForConsumptionReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ConsumptionReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#divForConsumptionReport"), 0, 0, options, function () {
                        pdf.save('ConsumptionReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('#reportDate').hide();
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
                        eventFunction.bindConsumptionReport(data.d);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            getConsumptionReportByDates: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();

                eventFunction.config.method = "getConsumptionReportByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindConsumptionReport: function (result) {
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                datas = JSON.parse(result);
                var htmls = "";
                var sn = 1;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Consumption Report </p> <p style="text-align:center;margin:0;">From : ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += '<table class="tableforlisting reportsprint" cellspacing="0" style="border:none;width:100%;"><thead><tr><th>S.N.</th><th>Ingredient Name</th><th>Quantity</th><th>Unit</th></tr></thead><tbody>';
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += '<tr><td>' + sn + '</td>';
                        htmls += '<td>' + value.IngredientName + '</td>';
                        htmls += '<td>' + value.Qnty + '</td>';
                        htmls += '<td>' + value.Symbol + '</td>';
                        htmls += '</tr>';
                        sn++;
                    });
                } else {
                    htmls += '<tr><td colspan=4 style="text-align:center;">';
                    htmls += 'No Data';
                    htmls += '</td></tr>';
                }
                htmls += '</tbody></table> <br /><hr /><br />';

                $("#divForConsumptionReport").html(htmls);
                

            },
           
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);