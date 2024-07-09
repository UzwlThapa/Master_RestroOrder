function Print() {
    var contents = $('#salesBookDiv').html();
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
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/CBMS_Dashboard/',
                master: '0',
            }, p);
        var month = new Array();
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
                baseURL: p.ModulePath + "cbmsWS.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },

            init: function () {

                $('#lblCompanyName').html(companyInfo.Name);
                $('#lblCompanyPAN').html(companyInfo.PAN);
                $('#lblCompanyAddress').html(companyInfo.Address);

                eventFunction.SetMonth();
                $('#txtMnthYear').nepaliDatePicker({
                    npdMonth: true,
                    npdYear: true,
                    npdYearCount: 10 // Options | Number of years to show
                });
                $('#txtToDate').nepaliDatePicker({
                    npdMonth: true,
                    npdYear: true,
                    npdYearCount: 10 // Options | Number of years to show
                });

                $('#txtMnthYear').change(function () {
                    $('#txtEngMnthYear').val(BS2AD($('#txtMnthYear').val()));
                });

                $('#txtToDate').change(function () {
                    $('#txtEngToDate').val(BS2AD($('#txtToDate').val()));
                });

                $("#btnViewSales").click(function () {
                    $('#txtToDate').change();
                    $('#txtEndDate').change();
                    eventFunction.GetSales();
                    $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    let file = new Blob([$('#salesBookDiv').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "SalesBook_From_" + $('#lblYear').html() + '_TO_' + $('#lblMonth').html() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#salesBookDiv"), 0, 0, options, function () {
                        pdf.save('SalesBook_From_' + $('#lblYear').html() + '_To_' + $('#lblMonth').html() + '.pdf');
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
                    error: eventFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        var result = JSON.parse(data.d);
                        debugger;
                        eventFunction.bindSalesData(result);
                        break;
                    case 2:
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            GetSales: function () {

                ($('#lblMonth').html($('#txtMnthYear').val() == "" ? "Beginning" : $('#txtMnthYear').val()));
                ($('#lblYear').html($('#txtToDate').val() == "" ? "End" : $('#txtToDate').val()));
                eventFunction.config.method = "GetSalesBook";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ fromDate: ($('#txtMnthYear').val() == "" ? "Beginning" : $('#txtMnthYear').val()), toDate: ($('#txtToDate').val() == "" ? "End" : $('#txtToDate').val()) });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindSalesData: function (result) {
                $('#salesBookDiv').show();
                var htmls = "";
                var fhtmls = "";
                $('#salesBookTbl>tbody').html(htmls);
                $('#salesBookTbl>tfoot').html(fhtmls);
                totalSales = 0.00;
                nonTaxableSales = 0.00;
                exportSales = 0.00;
                discount = 0.00;
                taxableSales = 0.00;
                totalVat = 0.00;
                let totalQty = 0;
                $.each(result, function (index, value) {
                    htmls += "<tr>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.invoice_date.split(' ')[0] + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.invoice_number + "</td>";
                    htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.buyer_name + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.buyer_pan + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>Item</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Qty + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>pcs</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>N/A</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.total_sales.toFixed(2) + "</td>";

                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>0</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.total_sales.toFixed(2) + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.vat.toFixed(2) + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class='tdrate'>" + 0 + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class=''></td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class=''></td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class=''></td>";

                    htmls += "</tr>";
                    totalSales += value.total_sales;
                    nonTaxableSales += value.tax_exempted_sales;
                    exportSales += value.export_sales;
                    discount += 0.00;
                    taxableSales += value.total_sales;
                    totalVat += value.vat;
                    totalQty += value.Qty;
                });
                $('#salesBookTbl>tbody').html(htmls);
                fhtmls += "<tr>";
                fhtmls += "<th colspan='5' style='text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;'>Total : </th>";
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">' + totalQty + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;"></th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">' + totalSales.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">' + 0 + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">' + taxableSales.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">' + totalVat.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">0</th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;"></th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;"></th>';
                fhtmls += '<th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;"></th>';

                fhtmls += "</tr>";
                $('#salesBookTbl>tfoot').html(fhtmls);
            },
            SetMonth: function () {
                month[0] = "No Month";
                month[1] = "बैशाख";
                month[2] = "जेठ";
                month[3] = "अषाढ";
                month[4] = "श्रावण";
                month[5] = "भाद्र";
                month[6] = "आश्विन";
                month[7] = "कार्तिक";
                month[8] = "मङ्सिर";
                month[9] = "पौष";
                month[10] = "माघ";
                month[11] = "फाल्गुन";
                month[12] = "चैत्र";
            }
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);