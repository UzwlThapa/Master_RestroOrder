function validateFloatKeyPress(el, evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    var number = el.value.split('.');
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    //just one dot (thanks ddlab)
    if (number.length > 1 && charCode == 46) {
        return false;
    }
    //get the carat position
    var caratPos = getSelectionStart(el);
    var dotPos = el.value.indexOf(".");
    if (caratPos > dotPos && dotPos > -1 && (number[1].length > 1)) {
        return false;
    }
    return true;
}
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RO_Cogs/service/'
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
                baseURL: p.ModulePath + "CogsService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0
            },
            InitialSetup: function () {
                eventFunction.getItemList();
  
            },
            init: function () {
                eventFunction.InitialSetup();

                $('#btnViewItemReport').on('click', function () {
                    eventFunction.getDailyItemReport();
                });
                $("#btnPrint").click(function () {
                    $('.printedDate').show();
                    var contents = $('#divItemReport').html();
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
                    $('.printedDate').hide();

                });
                $("#btnExport").click(function (e) {
                    $('.printedDate').show();
                    var dNow = new Date();
                    $('.lblPrintedOn').html(dNow);
                    let file = new Blob([$('#divItemReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ItemDailyReport_" + $('#txtStartDate').val() + '_' + $('#txtEndDate').val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('.printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('.printedDate').show();
                    var dNow = new Date();
                    $('.lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML($('#divItemReport'), 0, 0, options, function () {
                        pdf.save('ItemDailyReport_' + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('.printedDate').hide();

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
                        eventFunction.bindDailyItemReport(data.d);
                        break;
                    case 2:
                        eventFunction.bindItemList(data.d);
                        break;

                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            getItemList: function () {
                var costCenter = 0;
                eventFunction.config.method = "getItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.config.data = JSON2.stringify({ costCenter: costCenter });
                eventFunction.ajaxCall(eventFunction.config);
            },


            getDailyItemReport: function () {
                var startDate = $("#txtStartDate").val() + ' 0:0';
                var endDate = $("#txtEndDate").val() + ' 23:59';
                var itemId = $('#selItem').val() == "" ? 0 : $("#selItem").val();
                eventFunction.config.method = "getItemDailyProfit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, itemId: itemId });
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindItemList: function (result) {

                itemlist = JSON.parse(result);
                $('#selItem').html("");
                var htmls = "";

                htmls += "<option value='0' selected>--ALL--</option>";
                $.each(itemlist, function (index, item) {
                    htmls += "<option value='" + item.ITId + "'>" + item.ITName + "</option>";
                });
                $('#selItem').html(htmls);
            },

            bindDailyItemReport: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                $('#divItemReport').html(htmls);
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Daily Item Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To : ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p class="printedDate" style="text-align:center;margin:0;margin-bottom:5px;display:none;">Printed On : <label class="lblPrintedOn">' + new Date() + '</label></p></div>';
                htmls += "<table id='tblItemlist'><thead>";
                htmls += "<tr><th>S.N.</th><th>Item Name</th><th>Item Cost</th><th>Quantity</th><th>MRP</th><th>Total Cost</th><th>Total Sales</th><th>Profit/Loss</th></tr></thead>";
                htmls += "<tbody>";
                var itemTlCost = 0.00;
                var itemTotalQuantity = 0.00;
                var itemTotalMRP = 0.00;
                var itemTotalCost = 0.00;
                var itemTotalSales = 0.00;
                var itemProfit = 0.00;
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + (index + 1) + "</td>";
                        htmls += "<td>" + value.ItemName + "</td>";
                        htmls += "<td>" + value.ItemCost + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.MRP + "</td>";
                        htmls += "<td>" + value.TotalCost + "</td>";
                        htmls += "<td>" + value.TotalSales + "</td>";
                        htmls += "<td>" + value.Profit + "</td>";
                        htmls += "</tr>";
                        itemTlCost += parseFloat(value.ItemCost);
                        itemTotalQuantity += parseFloat(value.Quantity);
                        itemTotalMRP += parseFloat(value.MRP);
                        itemTotalCost += parseFloat(value.TotalCost);
                        itemTotalSales += parseFloat(value.TotalSales);
                        itemProfit += parseFloat(value.Profit);
                    });
                }
                else {

                    htmls += "<tr>";
                    htmls += "<td colspan=8 style='text-align:center;'> No Data Available</th>";
                    htmls += "</tr>";
                }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += '<tr><th colspan=2 style="text-align:center;">Total:</th>';
                htmls += '<th>' + itemTlCost.toFixed(2) + '</th>';
                htmls += '<th>' + itemTotalQuantity.toFixed(2) + '</th>';
                htmls += '<th>' + itemTotalMRP.toFixed(2) + '</th>';
                htmls += '<th>' + itemTotalCost.toFixed(2) + '</th>';
                htmls += '<th>' + itemTotalSales.toFixed(2) + '</th>';
                htmls += '<th>' + itemProfit.toFixed(2) + '</th>';
                htmls += '</tr>';
                htmls += "</tfoot>";
                htmls += "</table>";
                $('#divItemReport').html(htmls);
            
            },

  
            Reset: function () {
                window.location.reload();
            },

        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);