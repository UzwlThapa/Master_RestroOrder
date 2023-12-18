function Print() {
    var contents = $('#purchaseBookDiv').html();
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
                 ModulePath: '/Modules/RoiPurchase/',
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
                baseURL: p.ModulePath + "PurchaseWebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },

            init: function () {

                $('#lblCompanyName').html(companyInfo.Name);
                $('#lblCompanyPAN').html(companyInfo.PAN);

                //eventFunction.SetMonth();
                $('#txtMnthYear,#txtMnthYearEnd').datepicker({
                    npdMonth: true,
                    npdYear: true
                });
                $("#txtMnthYear").datepicker({
                    onSelect: function (dateText, inst) {
                        // Change the background color of the selected date
                        $(this).css("background-color", "blue");
                    }
                });
                $("#txtMnthYear,#txtMnthYearEnd").datepicker("setDate", new Date());
                $("#btnViewPurchase").click(function () {
                    eventFunction.GetPurchaseBook();
                    $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    let file = new Blob([$('#purchaseBookDiv').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "PurchaseBook_" + $('#lblYear').html() + '_' + $('#lblMonth').html() + ".xls"
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
                    pdf.addHTML($("#purchaseBookDiv"), 0, 0, options, function () {
                        pdf.save('PurchaseBook_' + $('#lblYear').html() + '_' + $('#lblMonth').html() + '.pdf');
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
                        eventFunction.bindSalesData(result);
                        break;
                   
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            GetPurchaseBook: function () {
                var date = $('#txtMnthYear').val().split('/');
                //$('#lblMonth').html(date[0]);
                //$('#lblYear').html(date[2]);
                //eventFunction.config.method = "GetPurchaseBook";
                //eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //eventFunction.config.data = JSON2.stringify({ year: date[2], month: date[0] });
                
                var fromDate = $('#txtMnthYear').val();
                var toDate = $('#txtMnthYearEnd').val();
                $('#lblMonth').html(date[0]);
                $('#lblYear').html(date[2]);
                eventFunction.config.method = "GetPurchaseBook";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ FromDate: fromDate, ToDate: toDate });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindSalesData: function (result) {
                $('#purchaseBookDiv').show();
                var htmls = "";
                var fhtmls = "";
                $('#salesBookTbl>tbody').html(htmls);
                $('#salesBookTbl>tfoot').html(fhtmls);
                totalVatSales = 0.00;
                totalSales = 0.00;
                discount = 0.00;
                vatdiscount = 0.00;
                extradiscount = 0.00;
                taxableSales = 0.00;
                totalVat = 0.00;
                $.each(result, function (index, value) {
                    var amount = (value.VatTotal + value.Total) - (value.Discount + value.vatdiscount + value.ExtraDiscount);
                    var vat = value.VatTotal * 0.13;
                    htmls += "<tr>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.InvoiceDate.split('T')[0] + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'> Purchase No: -" + value.PuNo + " and  Goods Receive No :-" + value.GMNo + " </td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.InvoiceNo + "</td>";
                    htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.Fname + "</td>";
                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.PAN + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.VatTotal + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.Total + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.Discount + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.vatdiscount + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + value.ExtraDiscount + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + amount + "</td>";
                    htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>" + vat.toFixed(2) + "</td>";
                   
                    htmls += "</tr>";
                    totalVatSales += value.VatTotal;
                    totalSales += value.Total;
                    discount += value.Discount;
                    vatdiscount += value.vatdiscount;
                    extradiscount += value.ExtraDiscount;
                    taxableSales += amount;
                   totalVat += vat;
                });
                $('#salesBookTbl>tbody').html(htmls);
                fhtmls += "<tr>";
                fhtmls += "<th colspan='5' style='text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;'>Total Amount : </th>";
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + totalVatSales.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + totalSales.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + discount.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + vatdiscount.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + extradiscount.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + taxableSales.toFixed(2) + '</th>';
                fhtmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">' + totalVat.toFixed(2) + '</th>';
                fhtmls += "</tr>";
                $('#salesBookTbl>tfoot').html(fhtmls);
            },
     
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);

