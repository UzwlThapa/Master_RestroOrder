(function ($) {
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ClosingReport/service/',
                 master: '0',
             }, p);
        var v = 0;
        var DiffAmount = 0;
        var Statement = "";
        var SalesStatement = "";
        var stat = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WSforMaterializedView.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0
            },

            init: function () {
                $("#btnView").click(function () {
                    eventFunction.getDataByDates();
                });

                $("#btnPrint").click(function () {

                    if (stat == 0) {
                        eventFunction.print(Statement);
                    }
                    else {
                        eventFunction.print(SalesStatement);
                    }

                });
                $("#btnViewStatement").click(function () {
                    eventFunction.getStatementDataByDates();
                });
            },
            print: function (Contents) {
                var contents = Contents;
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
            getDataByDates: function () {
                var startdate = $("#txtStartDate").val();

                eventFunction.config.method = "getDataByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getStatementDataByDates: function () {
                var startdate = $("#txtStartDate").val();

                eventFunction.config.method = "getStatementDataByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindDataByDates: function (result) {
                stat = 0;
                var datas = result.d;
                var htmls = "";
                var prev = "";
                var count = "";
                if (datas.length > 0) {
                    $("#btnPrint").show();
                    htmls += '<table class="tableForMaterizedView  cellspacing="0" style="border:none;width:100%;"><thead><tr><th width="10px">ITName</th><th>CostCenterName</th><th>Conversion</th><th>QTY</th><th>Symbol</th></tr></thead><tbody>';
                    $.each(datas, function (index, value) {
                        htmls += '<tr><td>' + value.ITName + '</td>';
                        htmls += '<td>' + value.CostCenterName + '</td>';
                        htmls += '<td>' + value.Conversion + '</td>';
                        htmls += '<td>' + value.QTY + '</td>';
                        htmls += '<td>' + value.Symbol + '</td>';
                        htmls += '</tr>';
                    });
                    htmls += '</tbody></table>';
                    $("#DailyReport").html(htmls);
                    $(".tableForMaterizedView").dataTable({
                       "JQueryUI": true,
                        "scrollX" : true
                       

                    });
                } else {
                    $("#DailyReport").html("No Data");
                    $("#btnPrint").hide();
                }
                Statement = "";
                Statement += "<div id='StatementPrint'>";
                Statement += "<h2 style='text-align: center'>Statement</h2>";
                Statement += "<h4 style='text-align: left;border-bottom:1px dashed;margin-bottom:10px;'>Date : " + $('#txtStartDate').val() + "</h4>";
                Statement += "<table>";
                Statement += "<tr><th style='width:50%;text-align:left;border-bottom:1px dashed;'>Group/Product</th><th style='width:50%;text-align:right;border-bottom:1px dashed;'>QTY</th></tr>";

                var d = [];
                $.each(datas, function (index, value) {
                    d.push(value.CostCenterName);
                });
                var unique = jQuery.unique(d);
                $.each(unique, function (index, value) {
                    var lst = $.grep(datas, function (e) {
                        return e.CostCenterName == value;
                    });
                    var count = 0;
                    var grptotal = 0;
                    $.each(lst, function (index, value) {
                        if (count == 0) {
                            Statement += "<tr><td colspan='2' style='border-bottom:1px dashed;border-bottom:1px dashed;margin-bottom:10px;'><Strong>" + value.CostCenterName + "</strong></td></tr>";
                        }
                        Statement += "<tr><td style='width:50%;text-align:left;list-item-type:disc;'>" + value.ITName + "</td><td style='width:50%;text-align:right;'>" + value.QTY + "</td></tr>";
                        grptotal = grptotal + value.QTY;
                        count++;
                        if ((lst.length - 1) == index) {
                            Statement += "<tr><td style='text-align:left;border-bottom:1px dashed;margin-bottom:10px;padding-bottom:10px;'>Count = " + count + "</td><td style='text-align:right;border-bottom:1px dashed;margin-bottom:10px;padding-bottom:10px;'>Grp Total = " + grptotal + "</td></tr>";
                        }
                    });
                });
                Statement += "</table></div>";
            },

            bindStatementDataByDates: function (result) {
                alert();
                stat = 1;
                var datas = result.d;
                var htmls = "";
                if (datas.length > 0) {
                    $("#btnPrint").show();
                    htmls += '<table class="tableForMaterizedView" cellspacing="0" style="border:none;width:100%;"><thead><tr><th width="10px">DATE</th><th>No Of Bill</th><th> Total </th><th> BEV</th><th> KOT</th><th> DISCOUNT</th><th>Total</th><th> Service Charge</th><th> Tax Charge</th><th> Net Amount</th><th> Sales Per Bill</th></tr></thead><tbody>';
                    $.each(datas, function (index, value) {
                        htmls += '<tr><td>' + value.DATE.split(' ')[0] + '</td>';
                        htmls += '<td>' + value.BillNo + '</td>';
                        htmls += '<td class="tot-rig">' + value.TotalAll.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.BEV.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.KOT.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.DISCOUNT.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.Total.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.ServiceCharge.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.TaxCharge.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.NetAmount.toFixed(2) + '</td>';
                        htmls += '<td class="tot-rig">' + value.SalesPerBill.toFixed(2) + '</td>';
                        htmls += '</tr>';
                    });
                    htmls += '</tbody></table>';
                    SalesStatement = " ";
                    SalesStatement += "<div style='width:100%;'>";
                  //  SalesStatement += '<table class="tableForMaterizedView sfGridwrapper nowrap display" cellspacing="0" style="border:none;width:100%px;">';//<thead><tr><th style="width:100px;">DATE</th style="width:150px;"><th>No Of Bill</th><th style="width:100px;"> Total </th><th style="width:100px;"> BEV</th><th style="width:100px;"> KOT</th><th style="width:100px;"> DISCOUNT</th><th style="width:100px;">Total</th><th style="width:150px;"> Service Charge</th><th style="width:150px;"> Tax Charge</th><th style="width:150px;"> Net Amount</th><th style="width:150px;"> Sales Per Bill</th></tr></thead><tbody>';
                    //   SalesStatement += '<table class="tableForMaterizedView sfGridwrapper nowrap display" cellspacing="0" style="border:none;width:100%px;">
                    //<thead><tr><th style="width:100px;">DATE</th style="width:150px;"><th>No Of Bill</th>
                    //<th style="width:100px;"> Total </th><th style="width:100px;"> BEV</th><th style="width:100px;"> KOT</th>
                    //<th style="width:100px;"> DISCOUNT</th><th style="width:100px;">Total</th><th style="width:150px;"> Service Charge</th>
                    //<th style="width:150px;"> Tax Charge</th><th style="width:150px;"> Net Amount</th><th style="width:150px;"> Sales Per Bill</th></tr></thead><tbody>';
                    SalesStatement += "<caption><strong style='font-size:22px;'>Sales Statement</strong></caption>";
                    //     SalesStatement += "<caption>Date : " + $('#txtStartDate').val(); "</caption>";
                    SalesStatement += "<table style='font-size:18px;border:none;width:100%;'><tbody>";
                    $.each(datas, function (index, value) {
                        SalesStatement += '<tr><td>DATE</td><td style="text-align:right;">' + value.DATE.split(' ')[0] + '</td>';
                        SalesStatement += '</tr><tr><td>No Of Bill</td><td style="text-align:right;">' + value.BillNo + '</td>';
                        SalesStatement += '</tr><tr><td>Total</td><td style="text-align:right;">' + value.TotalAll.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>BEV</td><td style="text-align:right;">' + value.BEV.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>KOT</td><td style="text-align:right;">' + value.KOT.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>DISCOUNT</td><td style="text-align:right;">' + value.DISCOUNT.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>Total</td><td style="text-align:right;">' + value.Total.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>Service Charge</td><td style="text-align:right;">' + value.ServiceCharge.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>Tax Charge</td><td style="text-align:right;">' + value.TaxCharge.toFixed(2)  + '</td>';
                        SalesStatement += '</tr><tr><td>Net Amount</td><td style="text-align:right;">' + value.NetAmount.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td>Sales Per Bill</td><td style="text-align:right;">' + value.SalesPerBill.toFixed(2) + '</td>';
                        SalesStatement += '</tr>';
                    });
                    SalesStatement += '</tbody></table>';
                    SalesStatement += "</div>";
                    $("#DailyReport").html(htmls);
                    $(".tableForMaterizedView").dataTable({
                       "JQueryUI": true,
                         "scrollX" : true
                       
                    });
                } else {
                    $("#DailyReport").html("No Data");
                    $("#btnPrint").hide();
                }
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
                        eventFunction.bindDataByDates(data);
                        break;
                    case 2:
                        eventFunction.bindStatementDataByDates(data);
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);
