function Print() {
    $('#printedDate').show();
    $('#reportDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#GoodsReceiveViewReport').html();
    $('#printedDate').hide();
    $('#reportDate').hide();
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
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RoiGoodsReceiveReport/'
             }, p);
        var v = 0;
        var TotalAmount = 0;
        var PuNoArray = [];
        var VAT = 0;
        var Amount = 0;
        var VATAmount = 0;
        var Discount = 0;
        var IsVat = 0;
        var VatItemTotal = 0;
        var NonVatItemTotal = 0;
        var TotalDiscount = 0;
        var ExtraDiscount = 0;
        var TaxAmount = 0;
        var TotalAmount = 0;
        var goods = [];
        var purchase = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "GoodsReceiveReport.asmx/",

                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.ReceivedList();
                //eventFunction.getPurchaseList();
            },
            init: function () {
                
                eventFunction.InitialSetup();
                
                $("#btnView").click(function () {
                    eventFunction.GetGoodsReceiveReport();
                    $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#GoodsReceiveViewReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "GoodsReceiveReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
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
                    pdf.addHTML($("#GoodsReceiveViewReport"), 0, 0, options, function () {
                        pdf.save('GoodsReceiveReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
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
                        eventFunction.BindGoodsReceiveReport(data.d);
                        break;
                    case 1:
                        eventFunction.BindGoodsDetailsReport(data.d);
                        break;
                    case 2:
                        eventFunction.bindGoodsReceivedList(data.d);
                        break;
                    case 3:
                        eventFunction.bindPurchaseList(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },
            //<<-----------------------------Post & Get Here ---------------------------------------->>
            getPurchaseList: function () {
                eventFunction.config.method = "getPurchaseList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            ReceivedList: function () {
                eventFunction.config.method = "GetGoodReceivedPO";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetGoodsReceiveReport: function () {
                var startDate = $("#txtStartDate").val();
                var endDate = $("#txtEndDate").val();
                var PoNO = $("#txtPurchaseNo").val();
                var GmNo = $("#txtReceiveNo").val();
                var itemname = $("#txtItemName").val();
                var paymentID = $("#sltPayMode option:selected").val();
                eventFunction.config.method = "getGoodsReceiveReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, PoNO: PoNO, GmNo: GmNo, itemname: itemname, paymentID: paymentID });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPurchaseDetailsbygmID: function (gmID) {
                eventFunction.config.method = "GetGoodsDetailsbygmID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    gmID: gmID
                });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },


            BindGoodsReceiveReport: function (data) {
                $("#GoodsReceiveViewReport").show();
                $("#GoodsReceiveViewReport").html();
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Good Recieved Report <p style="text-align:center;margin:0;">From : ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val())  + '   To : ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='tableForViewReport' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Item Name</th><th>Quantity</th><th>Rate</th><th>Total</th><th>Discount</th><th>VAT</th><th>Net Total</th><th>Goods Recieve No</th><th>PurchaseNo.</th><th>Purchase Date</th><th>Payment Mode</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                
                htmls += "<tbody>"
                var datas = JSON.parse(data);

                var discountTotal = 0.0;
                var vatTotal = 0.0;
                var netTotal = 0.0;
                debugger;
                if (datas.length > 0) {
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Quentity + "</td>";
                        htmls += "<td>" + value.UnitRate + "</td>";
                        htmls += "<td>" + value.Total + "</td>";
                        htmls += "<td>" + value.Discount + "</td>";
                        htmls += "<td>" + value.VatTotal + "</td>";
                        htmls += "<td>" + (value.Total - value.Discount + value.VatTotal) + "</td>";
                        TotalAmount = TotalAmount + value.Total;
                        discountTotal = discountTotal + value.Discount;
                        vatTotal = vatTotal + value.VatTotal;
                        netTotal = netTotal + (value.Total - value.Discount + value.VatTotal);
                        // htmls += "<td>" + value.GMNo + "</td>";
                        htmls += "<td><label class='gmid' id=" + value.GMId + ">" + value.GMNo + "</label></td>";
                        
                        htmls += "<td>" + value.PuNo + "</td>";
                        htmls += "<td>" + value.PurchaseDate + "</td>";
                        htmls += "<td>" + value.PaymentModeName + "</td>";
                        htmls += "</tr>"
                        count++;
                    });

                    htmls += "<tr>";
                    htmls += "<td colspan='4' class='tot-rig'>Total Amount :</td>";
                    htmls += "<td> Rs. " + (TotalAmount).toFixed(2) + "</td>";
                    htmls += "<td> Rs. " + (discountTotal).toFixed(2) + "</td>";
                    htmls += "<td> Rs. " + (vatTotal).toFixed(2) + "</td>";
                    htmls += "<td> Rs. " + (netTotal).toFixed(2) + "</td>";
                    htmls += "<td colspan='2'></td>";
                    htmls += "</tr>";

                    TotalAmount = 0;
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='7' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "</table>";

                $('#GoodsReceiveViewReport').html(htmls);
                $("#tableForViewReport").on('click', '.gmid', function () {
                    var gmID = $(this).attr('id');
                    eventFunction.GetPurchaseDetailsbygmID(gmID);
      
                    $('#ViewReport').dialog({
                        'title': 'Purchase order',
                        width: '400',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top']
                    });
                });
            },

            BindGoodsDetailsReport: function (data) {
          
                $("#ViewReport").show();
                $("#ViewReport").html();
             
                var datas = JSON.parse(data);
                var companyInfo = datas.companyInfo;
                var purchaseMain = datas.goodsMain;
                var htmls = '';
                var date = purchaseMain[0].InvoiceDate.split("T");
                htmls += '<button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right:2px;">Print</button>';

                htmls += '<div id="ViewReport" style="margin-top:10px;">';
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
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Buyer's Name. : " + purchaseMain[0].Fname + "</td>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Address. : " + purchaseMain[0].Address + "</td>";
                htmls += "</tr></table>";

                htmls += "<table id='tableForPurchaseDetailsReport' class='sfGridwrapper display' cellspacing='0' style='width:100%;text-align:left;border:1px solid;border-top:none;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:5%;'>SN</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:45%;'>ItemName</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Quantity</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Rate</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:20%;'>Total</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:12%;'>Discount</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                var count = 1;
                $.each(purchaseMain, function (index, value) {
                    htmls += "<tbody style='border-bottom:1px solid;'>"
                    htmls += "<tr>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:5%;'>" + count + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:45%;'>" + (value.IsVat ? '' : '*') + "" + value.ITName + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.Quentity + ' ' + value.Symbol + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.UnitRate + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:15%;'>" + value.Total + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.Discount + "</td>";
                 
                    if (value.IsVat == true) {
                        VatItemTotal += parseFloat(value.Total);
                        VAT = VatItemTotal - parseFloat(value.Discount);
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
                htmls += "<tr><td rowspan='7' colspan='3' style='border-top:1px solid;border-right:1px solid;'>In Words Rs. " + convertNumberToWords(TotalAmount) + " only.</td></tr>"
                htmls += "<tr>"

                htmls += "<td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>Taxable Total</td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + VatItemTotal.toFixed(2) + "</td></tr>";
                htmls += "<td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>Nontaxable Total</td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + NonVatItemTotal.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>Total Discount </td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalDiscount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>Extra Discount </td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + ExtraDiscount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>13 % VAT</td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TaxAmount.toFixed(2) + "</td></tr>";
                // htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>13 % VAT </td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + VAT.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>Net Amount</td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalAmount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='7' style='border-top:1px solid;text-align:left;padding-top:5px;'>Note:- (*) Sign Before Product Name is Non Taxable Items.</td></tr>"
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
                $('#ViewReport').html(htmls);

                $("#btnPrints").click(function () {
                    prints();
                });

            },

            bindGoodsReceivedList: function (result) {
                goodsList = JSON.parse(result);
                goods = [];
                if (goodsList.length > 0) {
                    $.each(goodsList, function (index, value) {
                        goods.push({ label: value.GMNo, id: value.GMId });
                    });
                }

                $("#txtReceiveNo").autocomplete({
                    source: goods,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#txtReceiveNo").val(ids);
                    }

                });
            },

            bindPurchaseList: function (result) {
                purchaseList = JSON.parse(result);
                purchase = [];
                if (purchaseList.length > 0) {
                    $.each(purchaseList, function (index, value) {
                        purchase.push({ label: value.PuNo, id: value.PurchaseMainID });
                    });
                }

                $("#txtPurchaseNo").autocomplete({
                    source: purchase,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#txtPurchaseNo").val(ids);
                    }

                });
            },
            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
             
            },

        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
