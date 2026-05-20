function formatDate(date) {
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var year = date.getFullYear();
    return year + "-" + month + "-" + day;
}
function onlyUnique(value, index, self) {
    return self.indexOf(value) === index;
}
(function ($) {
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ClosingReport3_Monthly/service/',
                 master: '0',
             }, p);
        var v = 0;
        var DiffAmount = 0;
        var Statement = "";
        var SalesStatement = "";
        var StatementDatewise = "";
        var stat = 0;
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var viewType = '';
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WSforClosingReport3_Monthly.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0
            },

            init: function () {

                $("#btnView").click(function () {
                    $("#btnPrint").show();
                    $("#btnExport").show();
                    $("#btnPdf").show();
                    viewType = '';
                    eventFunction.getDataByDates();
                    $('.report-view').show();
                });

                $("#btnPrint").click(function () {
                    if (stat == 0) {
                        eventFunction.print(Statement);
                    }
                    else if (stat == 2) {
                        eventFunction.print(StatementDatewise);
                    }
                    else {
                        eventFunction.print(SalesStatement);
                    }

                });
                $("#btnViewStatement").click(function () {
                    viewType = 'Statement';
                    eventFunction.getStatementDataByDates();
                     $('.report-view').show();
                });

                $("#btnViewDatewise").click(function () {
                    viewType = 'DateWise';
                    eventFunction.getStatementDatewise();
                     $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    $('.printedDate').show();
                    var dNow = new Date();
                    $('.lblPrintedOn').html(dNow);
                    let file = new Blob([$('#DailyReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ClosingReport_" + $('#txtStartDate').val() + '_' + $('#txtEndDate').val() + '_' + viewType + ".xls"
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
                    pdf.addHTML($('#DailyReport'), 0, 0, options, function () {
                        pdf.save('ClosingReport_' + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + '_' + viewType + '.pdf');
                    });
                    $('.printedDate').hide();

                });

            },
            print: function (Contents) {
                $('.printedDate').show();
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
                $('.printedDate').hide();
            },
            getDataByDates: function () {
                var startdate = $("#txtStartDate").val() + ' 0:0';
                var enddate = $("#txtEndDate").val() + ' 23:59';
                eventFunction.config.method = "getDataByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getStatementDataByDates: function () {
                var startdate = $("#txtStartDate").val() + ' 0:0';
                var enddate = $("#txtEndDate").val() + ' 23:59';
                eventFunction.config.method = "getStatementDataByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getStatementDatewise: function () {
                var startdate = $("#txtStartDate").val() + ' 0:0';
                var enddate = $("#txtEndDate").val() + ' 23:59';
                eventFunction.config.method = "getStatementDatewise";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindDataByDates: function (result) {
                stat = 0;
                datas = JSON.parse(result);
                var htmls = "";
                var prev = "";
                var count = "";
                var tblQty = 0;
                var tblRate = 0;
                var tblTotal = 0;
                total = 0.00;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Closing Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p class="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label class="lblPrintedOn">' + new Date() + '</label></p></div>';
                htmls += '<table class="tableForMaterizedView reportsprint" cellspacing="0" style="border:none;width:100%;border-collapse:collapse;"><thead><tr>'
                htmls += '<th style="text-align:center;border:1px solid #575757;padding:2px;">Item ID</th>' 
                htmls += '<th style="text-align:left;border:1px solid #575757;padding:2px;">ITName</th><th style="text-align:center;border:1px solid #575757;padding:2px;">CostCenterName</th><th style="text-align:center;border:1px solid #575757;padding:2px;">QTY</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Symbol</th><th style="text-align:right;border:1px solid #575757;padding:2px;">Rate</th><th style="text-align:right;border:1px solid #575757;padding:2px;">Total</th></tr></thead><tbody>';
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += '<tr>' 
                       htmls += '<td  style="text-align:center;border:1px solid #575757;padding:2px;">' + value.ITId + '</td>';
                        htmls += '<td  style="text-align:left;border:1px solid #575757;padding:2px;">' + value.ITName + '</td>';
                        htmls += '<td  style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CostCenterName + '</td>';
                        //htmls += '<td>' + value.Conversion + '</td>';
                        htmls += '<td  style="text-align:center;border:1px solid #575757;padding:2px;">' + value.QTY + '</td>';
                        htmls += '<td  style="text-align:center;border:1px solid #575757;padding:2px;">' + value.Symbol + '</td>';
                        htmls += '<td  style="text-align:right;border:1px solid #575757;padding:2px;">' + value.Rate + '</td>';
                        total += (value.Rate * value.QTY);
                        htmls += '<td  style="text-align:right;border:1px solid #575757;padding:2px;">' + (value.Rate * value.QTY) + '</td>';
                        htmls += '</tr>';

                        tblQty += value.QTY;
                        tblRate += value.Rate;
                        tblTotal += (value.Rate * value.QTY);
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='7' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                    $("#btnPrint").hide();
                    $("#btnExport").hide();
                    $("#btnPdf").hide();
                }
                htmls += '</tbody>';
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += '<tr><th colspan=3 style="text-align:center;">Total:</th>';
                htmls += '<th style="text-align:center;border:1px solid #575757;padding:2px;">' + tblQty.toFixed(2) + '</th>';
                htmls += '<th></th>';
                htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblRate.toFixed(2) + '</th>';
                htmls += '<th style="text-align:right;border:1px solid #575757;padding:2px;">' + tblTotal.toFixed(2) + '</th>';
                htmls += '</tr>';
                htmls += "</tfoot>";
                htmls += '</table>';
                    $("#DailyReport").html(htmls);
                    //$(".tableForMaterizedView").dataTable({
                    //     "bJQueryUI": true,
                    //});
            
                Statement = "";
                Statement += "<div id='StatementPrint'>";
                Statement += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                Statement += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                Statement += '<p style="margin:0;text-align:center;">Closing Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To : ' + $('#txtEndDate').val() + '</p>';
                Statement += '<p class="printedDate" style="text-align:center;margin:0;margin-bottom:5px;">Printed On : <label class="lblPrintedOn">' + new Date() + '</label></p>';
                Statement += "<table class='reportsprint' style='width:100%;'>";
                Statement += "<tr><th style='text-align:left;border-bottom:1px dashed;'>Grp/Item</th><th style='text-align:right;border-bottom:1px dashed;'>QTY</th><th style='text-align:right;border-bottom:1px dashed;'>Rate</th><th style='text-align:right;border-bottom:1px dashed;'>Total</th></tr>";

                var d = [];
                $.each(datas, function (index, value) {
                    d.push(value.CostCenterName);
                });
                var unique = d.filter(onlyUnique);
                $.each(unique, function (index, value) {
                    var lst = $.grep(datas, function (e) {
                        return e.CostCenterName == value;
                    });
                    var count = 0;
                    var grptotal = 0;
                    grpTotalAmnt = 0.00;
                    $.each(lst, function (index, value) {
                        if (count == 0) {
                            Statement += "<tr><td colspan='4' style='border-bottom:1px dashed;border-bottom:1px dashed;margin-bottom:10px;'><Strong>" + value.CostCenterName + "</strong></td></tr>";
                        }
                        // Statement += "<tr><td style='text-align:left;list-item-type:disc;' class='unique_Id'>" + value.ITId+ "</td>"  
                        Statement += "<td style='text-align:left;list-item-type:disc;'>" + value.ITName + "</td><td style='text-align:right;'>" + value.QTY + "</td>";
                        Statement += "<td style='text-align:right;list-item-type:disc;'>" + value.Rate + "</td><td style='text-align:right;'>" + (value.Rate * value.QTY) + "</td></tr>";
                        grptotal = grptotal + value.QTY;
                        grpTotalAmnt += value.Rate * value.QTY;
                        count++;
                        if ((lst.length - 1) == index) {
                            Statement += "<tr><td style='text-align:left;border-bottom:1px dashed;margin-bottom:10px;padding-bottom:10px;'>Count = " + count + "</td><td style='text-align:right;border-bottom:1px dashed;margin-bottom:10px;padding-bottom:10px;'>Qty Tot =" + grptotal + "</td><td style='text-align:right;border-bottom:1px dashed;margin-bottom:10px;padding-bottom:10px;'></td><td style='text-align:right;border-bottom:1px dashed;margin-bottom:10px;padding-bottom:10px;'>" + grpTotalAmnt + "</td></tr>";
                        }
                    });
                });
                Statement += "</table></div>";
            },

            bindStatementDataByDates: function (result) {
                stat = 1;
                r = JSON.parse(result)
                datas = r.getStatement;
                costcenterGroup = r.getCostcenterGroup;
                var htmls = "";
                if (datas.length > 0) {
                    
                    SalesStatement = " ";
                    SalesStatement += "<div>";
                    SalesStatement += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                    SalesStatement += '<p style="margin:0;text-align:center;">Closing Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To : ' + $('#txtEndDate').val() + '</p></div>';
                    SalesStatement += "<table class='reportsprint report_L' style='font-size:14px;border:none;width:100%;border-collapse:collapse;'><tbody>";
                    var subTotal = 0.00;
                    $.each(datas, function (index, value) {
                        var date = new Date(value.DATE.split('/')[0]);
                        SalesStatement += '<tr><td style="text-align:left;border-top:1px solid black;border-bottom:1px solid black;padding:2px;">DATE</td><td style="text-align:left;border-top:1px solid black;border-bottom:1px solid black;padding:2px;">' + formatDate(date) + ' /' + value.DATE.split('/')[1] + '</td>';

                        if (costcenterGroup.length > 0) {
                            $.each(costcenterGroup, function (index, value) {
                                SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">' + value.GroupName + ' Sales</td><td style="text-align:left;padding:2px;">Rs. ' + value.TotalAmt.toFixed(2) + '</td>';
                                subTotal += value.TotalAmt; 
                            });

                        }
                        //SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Bar Sales</td><td style="text-align:left;padding:2px;">Rs. ' + value.BEV.toFixed(2) + '</td>';
                        //SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Cafe Sales</td><td style="text-align:left;padding:2px;">Rs. ' + value.Bakery.toFixed(2) + '</td>';

                        SalesStatement += '</tr><tr><td style="text-align:left;border-top:1px solid black;padding:2px;">Sub Total</td><td style="text-align:left;border-top:1px solid black;padding:2px;">Rs. ' + subTotal.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Total Discount (-)</td><td style="text-align:left;padding:2px;">Rs. ' + value.DISCOUNT.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Service Charge (+)</td><td style="text-align:left;padding:2px;">Rs. ' + value.ServiceCharge.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">VAT</td><td style="text-align:left;padding:2px;">Rs. ' + value.TaxCharge.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;border-top:1px solid black;border-bottom:1px solid black;padding:2px;">Net Sales</td><td style="text-align:left;border-top:1px solid black;border-bottom:1px solid black;padding:2px;">Rs. ' + value.NetAmount.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:center;padding:2px;font-weight: bolder;">Sales Description</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Cash</td><td style="text-align:left;padding:2px;">Rs. ' + value.CashReceived.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Cheque</td><td style="text-align:left;padding:2px;">Rs. ' + value.ChequeReceived.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Card</td><td style="text-align:left;padding:2px;">Rs. ' + value.CardReceived.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Credit</td><td style="text-align:left;padding:2px;">Rs. ' + value.CreditReceived.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">eSewa</td><td style="text-align:left;padding:2px;">Rs. ' + value.eSewaReceived.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">FonePay</td><td style="text-align:left;padding:2px;">Rs. ' + value.FonePayReceived.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Surplus/Deficit</td><td style="text-align:left;padding:2px;">Rs. ' + value.SurplusDeficit.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;padding:2px;">Complementry</td><td style="text-align:left;padding:2px;">Rs. ' + value.Complementry.toFixed(2) + '</td>';
                        SalesStatement += '</tr><tr><td style="text-align:left;border-top:1px solid black;border-bottom:1px solid black;padding:2px;">Total Amt</td><td style="text-align:left;border-top:1px solid black;border-bottom:1px solid black;padding:2px;">Rs. ' + (value.NetAmount + value.Complementry).toFixed(2) + '</td>';
                        SalesStatement += '</tr>';
                    });
                    SalesStatement += '</tbody></table>';
                    SalesStatement += "</div>";
                    $("#DailyReport").html(SalesStatement);
                    //$("#DailyReport").html(htmls);
                    //$(".tableForMaterizedView").dataTable({
                    //     "bJQueryUI": true,
                    //    ordering: true,
                    //    scrollX: true
                    //});
                } else {
                    $("#DailyReport").html("No Data");
                    $("#btnPrint").hide();
                    $("#btnExport").hide();
                    $("#btnPdf").hide();
                }
            },

            bindStatementDatewise: function (result) {
                stat = 2;
                datas = JSON.parse(result);
                var htmls = "";
                bills = 0;
                subTotal = 0.00;
                bevTotal = 0.00;
                kotTotal = 0.00;
                bakeryTotal = 0.00;
                pizzaTotal = 0.00;
                roomTotal = 0.00;
                bevDis = 0.00;
                KotDis = 0.00;
                bakeryDis = 0.00;
                pizzaDis = 0.00;
                roomDis = 0.00;
                discTotal = 0.00;
                basicAmntTotal = 0.00;
                scTotal = 0.00;
                taxableAmntTotal = 0.00;
                taxCTotal = 0.00;
                netAmntTotal = 0.00;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';        
                htmls += '<p style="margin:0;text-align:center;">Closing Report Datewise </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To : ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p class="printedDate" style="text-align:center;margin:0;margin-bottom:5px;">Printed On : <label class="lblPrintedOn">' + new Date() + '</label></p></div>';
                htmls += '<table class="tableForMaterizedView reportsprint" cellspacing="0" style="border:none;"><thead><tr><th style="text-align:center;border:1px solid #575757;padding:2px;">DATE</th>';
                htmls += '<th style="text-align:center;border:1px solid #575757;padding:2px;">Bill No</th>';
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Sub Total </th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> BEV</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> KOT</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Bakery</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Pizza</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Room</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">BEV Dis </th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> KOT Dis</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Bakery Dis</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Pizza Dis</th>'
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Room Disc</th>'
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Discount</th>'
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Basic Amt.</th>'
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> S.C.</th>'
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Taxable Amnt.</th>'
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> TaxC.</th>'
                htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Net Amt</th>';
                //htmls += '<th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;"> Sales Per Bill</th>';
                htmls += '</tr></thead><tbody>';
                if (datas.length > 0) {
                    StatementDatewise = "";

                    $.each(datas, function (index, value) {
                        htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.DATE.split(' ')[0] + '</td>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.BillNo + '</td>';
                        bills += value.BillNo;
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.Total.toFixed(2) + '</td>';
                        subTotal += value.Total;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.BEV.toFixed(2) + '</td>';
                        //bevTotal += value.BEV;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.KOT.toFixed(2) + '</td>';
                        //kotTotal += value.KOT;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.Bakery.toFixed(2) + '</td>';
                        //bakeryTotal += value.Bakery;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.Pizza.toFixed(2) + '</td>';
                        //pizzaTotal += value.Pizza;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.RoomCharge.toFixed(2) + '</td>';
                        //roomTotal += value.RoomCharge;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.BarDiscount.toFixed(2) + '</td>';
                        //bevDis += value.BarDiscount;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.KotDiscount.toFixed(2) + '</td>';
                        //KotDis += value.KotDiscount;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.BakeryDiscount.toFixed(2) + '</td>';
                        //bakeryDis += value.BakeryDiscount;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.PizzaDiscount.toFixed(2) + '</td>';
                        //pizzaDis += value.PizzaDiscount;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.RoomDiscount.toFixed(2) + '</td>';
                        //roomDis += value.RoomDiscount;
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.DISCOUNT.toFixed(2) + '</td>';
                        discTotal += value.DISCOUNT;
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.TotalAll.toFixed(2) + '</td>';
                        basicAmntTotal += value.TotalAll;
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.ServiceCharge.toFixed(2) + '</td>';
                        scTotal += value.ServiceCharge;
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + (value.NetAmount - value.TaxCharge).toFixed(2) + '</td>';
                        taxableAmntTotal += (value.NetAmount - value.TaxCharge);
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.TaxCharge.toFixed(2) + '</td>';
                        taxCTotal += value.TaxCharge;
                        htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.NetAmount.toFixed(2) + '</td>';
                        netAmntTotal += value.NetAmount;
                        //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + value.SalesPerBill.toFixed(2) + '</td>';
                        htmls += '</tr>';
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='13' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                    $("#btnPrint").hide();
                    $("#btnExport").hide();
                    $("#btnPdf").hide();
                }
                

                htmls += '<tr><td style="text-align:right;border:1px solid #575757;padding:2px;"></td>';
                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;"><b>Total</b></td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b>Rs. ' + subTotal.toFixed(2) + '</b></td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + bevTotal.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + kotTotal.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + bakeryTotal.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + pizzaTotal.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + roomTotal.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + bevDis.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + KotDis.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + bakeryDis.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + pizzaDis.toFixed(2) + '</td>';
                //htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + roomDis.toFixed(2) + '</td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b> Rs. ' + discTotal.toFixed(2) + '</b></td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b> Rs. ' + basicAmntTotal.toFixed(2) + '</b></td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b> Rs. ' + scTotal.toFixed(2) + '</b></td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b> Rs. ' + taxableAmntTotal.toFixed(2) + '</b></td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b> Rs. ' + taxCTotal.toFixed(2) + '</b></td>';
                htmls += '<td class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;"><b> Rs. ' + netAmntTotal.toFixed(2) + '</b></td>';
                //htmls += '<td></td>';
                htmls += '</tr>';
                    htmls += '</tbody></table>';
                    StatementDatewise += htmls;
                    //SalesStatement += "<div style='width:90%;'>";
                    ////  SalesStatement += '<table class="tableForMaterizedView sfGridwrapper nowrap display" cellspacing="0" style="border:none;width:100%px;">';//<thead><tr><th style="width:100px;">DATE</th style="width:150px;"><th>No Of Bill</th><th style="width:100px;"> Total </th><th style="width:100px;"> BEV</th><th style="width:100px;"> KOT</th><th style="width:100px;"> DISCOUNT</th><th style="width:100px;">Total</th><th style="width:150px;"> Service Charge</th><th style="width:150px;"> Tax Charge</th><th style="width:150px;"> Net Amount</th><th style="width:150px;"> Sales Per Bill</th></tr></thead><tbody>';
                    ////   SalesStatement += '<table class="tableForMaterizedView sfGridwrapper nowrap display" cellspacing="0" style="border:none;width:100%px;">
                    ////<thead><tr><th style="width:100px;">DATE</th style="width:150px;"><th>No Of Bill</th>
                    ////<th style="width:100px;"> Total </th><th style="width:100px;"> BEV</th><th style="width:100px;"> KOT</th>
                    ////<th style="width:100px;"> DISCOUNT</th><th style="width:100px;">Total</th><th style="width:150px;"> Service Charge</th>
                    ////<th style="width:150px;"> Tax Charge</th><th style="width:150px;"> Net Amount</th><th style="width:150px;"> Sales Per Bill</th></tr></thead><tbody>';
                    ////     SalesStatement += "<caption>Date : " + $('#txtStartDate').val(); "</caption>";
                    //SalesStatement += "<table style='font-size:18px;border:none;width:100%;'><tbody>";
                    //$.each(datas, function (index, value) {
                    //    SalesStatement += '<tr><td>DATE</td><td style="text-align:right;">' + value.DATE.split(' ')[0] + '</td>';
                    //    SalesStatement += '</tr><tr><td>No Of Bill</td><td style="text-align:right;">' + value.BillNo + '</td>';
                    //    SalesStatement += '</tr><tr><td>Total</td><td style="text-align:right;">' + value.TotalAll.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>BEV</td><td style="text-align:right;">' + value.BEV.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>KOT</td><td style="text-align:right;">' + value.KOT.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>DISCOUNT</td><td style="text-align:right;">' + value.DISCOUNT.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>Total</td><td style="text-align:right;">' + value.Total.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>Service Charge</td><td style="text-align:right;">' + value.ServiceCharge.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>Tax Charge</td><td style="text-align:right;">' + value.TaxCharge.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>Net Amount</td><td style="text-align:right;">' + value.NetAmount.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr><tr><td>Sales Per Bill</td><td style="text-align:right;">' + value.SalesPerBill.toFixed(2) + '</td>';
                    //    SalesStatement += '</tr>';
                    //});
                    //SalesStatement += '</tbody></table>';
                    //SalesStatement += "</div>";
                    $("#DailyReport").html(htmls);
                    //$(".tableForMaterizedView").dataTable({
                    //    "bJQueryUI" : true,
                    //    scrollX : true
                    //});
                    $('.printedDate').hide();
             
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
                        eventFunction.bindDataByDates(data.d);
                        break;
                    case 2:
                        eventFunction.bindStatementDataByDates(data.d);
                        break;
                    case 3:
                        eventFunction.bindStatementDatewise(data.d);
                        break;
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
