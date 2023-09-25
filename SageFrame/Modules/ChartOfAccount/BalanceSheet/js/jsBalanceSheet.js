/// <reference path="../../../Roi_CounterPerson/jquery.dataTables.min.js" />
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 HostUrl: '',
                 ModulePath: '/Modules/ChartOfAccount/BalanceSheet/webService/'
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
                baseURL: p.ModulePath + "wsBalanceSheet.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0
            },
            InitialSetup: function () {
                //eventFunction.getAllFinancialAcForGrid();
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnView").on('click', function () {
                    $('.report-view').show();
                    eventFunction.getAllFinancialAcForGrid();
                });
                $("#btnExport").on('click', function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#divForBalanceSheet').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "BalanceSheet_" + $('#txtDate').val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();

                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#divForBalanceSheet').html();
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
                });

                $('#btnPdf').on('click', function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#divForBalanceSheet"), 0, 0, options, function () {
                        pdf.save('BalanceSheet_' + $('#txtDate').val() + '.pdf');

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
                    error: eventFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 1:
                        break;
                    case 3:
                        eventFunction.bindAllFinancialAcForGrid(data.d);
                        break;
                    case 4:
                        eventFunction.bindFinancialAcDetails(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
                switch (parseInt(eventFunction.config.ajaxFailureMode)) {
                    case 2:
                        jAlert("Error!" + console.log(error), 'Error!!', function () { $.alerts.dialogClass = null; });
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            getAllFinancialAcForGrid: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                eventFunction.config.method = "getAllFinancialAcForGrid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindAllFinancialAcForGrid: function (result) {
                var parsedData = JSON.parse(result);
                var data = parsedData.balanceSheet;

                $("#divForBalanceSheet").html('');
                $("#divForBalanceSheet").show();

                //Bishal Updated ON
                var htmls = "";
                var ShowZero = $('#sltIsZero').val() == "Yes" ? true : false;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Balance Sheet For ' + $('#txtDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += '<div class="sfCol_50"><table id="tblOfFinancialAcDr" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;">' +
                    '<thead><tr style="font-weight: bold;background-color: #ff9933;color: white;">' +
                    '<th style="width: 100px;text-align:center;border:1px solid #575757;padding:2px;">ASSESTS </th>' +
                    '<th style="width: 20px;text-align:right;border:1px solid #575757;padding:2px;">(Dr.) Amount</th>' +
                    '</tr></thead><tbody id="tbl_PLDr"></tbody></table></div>';
                htmls += '<div class="sfCol_50"><table id="tblOfFinancialAcCr" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;">' +
                    '<thead><tr style="font-weight: bold;background-color: #ff9933;color: white;">' +
                    '<th style="width: 100px;text-align:center;border:1px solid #575757;padding:2px;">LIABILITES</th>' +
                    '<th style="width: 20px;text-align:right;border:1px solid #575757;padding:2px;">(Cr.) Amount</th>' +
                    '</tr></thead><tbody id="tbl_PLCr"></tbody></table></div>';


                $("#divForBalanceSheet").append(htmls);

                if (data.length > 0) {
                    
                    var htmDr = '';
                    var htmCr = '';
                    var brind;
                    var drlist = [];
                    var crlist = [];
                    var drsn = 1;
                    var crsn = 1;
                    var drdiff = 0;
                    var crdiff = 0;
                    var totalDrAmt = 0;
                    var totalCrAmt = 0;


                    //Creating two list of datas for Dr value and Cr Value
                    $.each(data, function (index, value) {
                        if (value.IsDebit == false) {
                            crlist.push(value);
                        }
                        if (value.IsDebit == true) {
                            drlist.push(value);
                        }
                    });


                    //Looping inside Debit List 

                    //Adding Profit & Loss
                    

                    $.each(drlist, function (index, value) {
                        if (value.isGroup) {
                            htmDr += '<tr id=' + value.FinancialAcID + ' class="isGrouptrue" style="font-weight:bold;">' +
                                '<td style="border:1px solid #575757;">' + value.items + '</td>';

                            if (value.Debit <= 0 && value.Credit <= 0) {
                                htmDr += '<td></td></tr>';
                            } else {
                                var accDiff = value.Debit - value.Credit;
                                htmDr += '<td style="text-align:right;border:1px solid #575757;">' + (accDiff >= 0 ? accDiff.toFixed(2) : "(" + accDiff.toFixed(2) + ")") + '</td></tr>';
                                totalDrAmt += accDiff;
                            }
                                

                        } else {
                            var accDiff = value.Debit - value.Credit;
                            htmDr += '<tr id=' + value.FinancialAcID + ' class="isGroupfalse">' +
                                '<td style="border:1px solid #575757;">' + value.items + '</td>' +
                                '<td style="text-align:right;border:1px solid #575757;">' + (accDiff >= 0 ? accDiff.toFixed(2) : "(" + accDiff.toFixed(2) + ")") + '</td></tr>';
                            totalDrAmt += accDiff;
                        }
                        drsn++;
                    });

                    $('#tbl_PLDr').html(htmDr);


                    htmCr += '<tr style="font-weight:bold;">' +
                        '<td style="border:1px solid #575757;">' + (drlist[0].PLBalance > 0 ? "Profit/Loss (Net Profit)" : "Profit/Loss (Net Loss)") + '</td>' +
                        '<td style="text-align:right;border:1px solid #575757;">' + (drlist[0].PLBalance >= 0 ? drlist[0].PLBalance.toFixed(2) : "(" + drlist[0].PLBalance.toFixed(2) + ")") + '</td></tr>';
                    totalCrAmt += crlist[0].PLBalance;


                    //Looping inside Credit List 
                    $.each(crlist, function (index, value) {
                        if (value.isGroup) {
                            htmCr += '<tr id=' + value.FinancialAcID + ' class="isGrouptrue" style="font-weight:bold;">' +
                                '<td style="border:1px solid #575757;">' + value.items + '</td>';

                            if (value.Debit <= 0 && value.Credit <= 0) {
                                htmCr += '<td></td></tr>';
                            } else {
                                var accDiff = value.Credit - value.Debit;
                                htmCr += '<td style="text-align:right;border:1px solid #575757;">' + (accDiff >= 0 ? accDiff.toFixed(2) : "(" + accDiff.toFixed(2) + ")") + '</td></tr>';
                                totalCrAmt += accDiff;
                            }

                        } else {
                            var accDiff = value.Credit - value.Debit;
                            htmCr += '<tr id=' + value.FinancialAcID + ' class="isGroupfalse">' +
                                '<td style="border:1px solid #575757;">' + value.items + '</td>' +
                                '<td style="text-align:right;border:1px solid #575757;">' + (accDiff >= 0 ? accDiff.toFixed(2) : "(" + accDiff.toFixed(2) + ")") + '</td></tr>';
                            totalCrAmt += accDiff;
                        }

                        crsn++;
                    });
                    $('#tbl_PLCr').html(htmCr);

                    $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                    $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td>&nbsp;</td><td>&nbsp;</td></tr>')



                    
                    //Checking if one list is greater than other to inster blank rows for design;
                    if (drlist.length != crlist.length) {
                        if (drlist.length > crlist.length) {
                            crdiff = drlist.length - crlist.length

                            for (i = 0; i < crdiff; i++) {
                                $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                            }

                        }
                        if (drlist.length < crlist.length) {
                            drdiff = crlist.length - drlist.length

                            for (i = 0; i < drdiff; i++) {
                                $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                            }
                        }
                    }


                    $('#tbl_PLCr').append('<tr style="background-color: #ff9933;color: white;"><td style="text-align:right;">TotalAmount</td><td style="text-align:right;">' + totalCrAmt + '</td></tr>')
                    $('#tbl_PLDr').append('<tr style="background-color: #ff9933;color: white;"><td style="text-align:right;">TotalAmount</td><td style="text-align:right;">' + totalDrAmt + '</td></tr>')


                

                //Bishal Updated
                //htmls += '<table id="tblOfFinancialAc" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="width: 88px;text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Particulars</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Amount</th>';
                //htmls += '<th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Credit</th>';
                //htmls += '</tr></thead><tbody>';
                //if (data.length > 0) {
                //    var tDebit = 0;
                //    var tCredit = 0;
                //    var tmpDebid = 0;
                //    var tmpCredid = 0;

                //    sn = 1;
                //    fnId = 1;
                //    tmpAssest = 0.00;
                //    tmpLiab = 0.00;
                //    $.each(data, function (index, value) {
                //        var tr = false;
                //        if (value.isGroup) {
                //            tr = true;
                //        } else {
                //            if (!(value.Debit == 0 && value.Credit == 0)) {
                //                tr = true;
                //            }
                //            if (ShowZero) {
                //                tr = true;
                //            }
                //        }
                //        if (tr) {
                //            if (value.PFinancialAcID == 0) {
                //                if (value.FinancialAcID != 1) {
                //                    fnId = 2;
                //                    //if (parsedData.profitLoss != 0) {
                //                    //    if (parsedData.profitLoss < 0) {
                //                    //        htmls += '<tr class="isGrouptrue"><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td><td style="text-align:left;border:1px solid #575757;padding:2px;">Loss Transfer From P/L Account : </td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(parsedData.profitLoss).toFixed(2) + '</td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + 0.00 + '</td></tr>';
                //                    //        tmpDebid += Math.abs(parsedData.profitLoss)
                //                    //        tDebit += Math.abs(parsedData.profitLoss)
                //                    //        sn++;
                //                    //    }
                //                    //}

                //                    htmls += '<tr class="isGrouptrue"><td colspan="2" style="text-align:right;border:1px solid #575757;padding:2px;">Sub Total : </td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tmpAssest.toFixed(2) + '</td></tr>';
                //                    tmpDebid = 0;
                //                    tmpCredid = 0;
                //                }
                //            }
                //           // htmls += '<tr id="' + value.FinancialAcID + '" class="isGroup' + value.isGroup + ' ' + ((value.Debit > 0 && value.Credit > 0) && value.isGroup ? 'showDetails' : '') + '"><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                //           htmls += '<tr id="' + value.FinancialAcID + '" class="isGroup' + value.isGroup + ' showDetails "><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                //            sn++;
                //            var Item = '';
                //            for (var i = 0; i < value.level; i++) {
                //                if (value.level == i + 1) {
                //                    Item += "<div class='Lline'></div><span>";
                //                }
                //                else {
                //                    Item += "<div class='vline'></div><span>";
                //                }
                //            }
                //            Item += value.items;
                //            Item += '</span>';
                //            htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;">' + Item + '</td>';
                //            if (value.isGroup && (value.Debit == 0 && value.Credit == 0)) {
                //                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;"></td>';
                //            }
                //            else {
                //                tDebit += value.Debit;
                //                tCredit += value.Credit;
                //                tmpDebid += value.Debit;
                //                tmpCredid += value.Credit;
                //                bal = 0.00;
                //                if (fnId == 1) {
                //                    tmpAssest += (value.Debit - value.Credit);
                //                    bal = (value.Debit - value.Credit);
                //                } else {
                //                    tmpLiab += (value.Credit - value.Debit);
                //                    bal = (value.Credit - value.Debit);
                //                }
                //                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal >= 0 ? bal.toFixed(2) : '(' + Math.abs(bal.toFixed(2)) + ')') + '</td>';
                //                //htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(bal) +  (bal >= 0 ? ' Dr': ' Cr') + '</td>';
                //            }                   
                //        }
                //    });
                //    if (parsedData.profitLoss != 0) {
                //        htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td><td style="text-align:left;border:1px solid #575757;padding:2px;">' + (parsedData.profitLoss > 0 ? 'By Net Profit' : 'To Net Loss') + '</td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + (parsedData.profitLoss > 0 ? (parsedData.profitLoss).toFixed(2) : '(' + Math.abs(parsedData.profitLoss).toFixed(2) + ')') + '</td></tr>';
                //        //htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td><td style="text-align:left;border:1px solid #575757;padding:2px;">' + (parsedData.profitLoss > 0 ? 'By Net Profit' : 'To Net Loss') + '</td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(parsedData.profitLoss) + (parsedData.profitLoss >= 0 ? ' Dr' : ' Cr') + '</td></tr>';
                //        tmpCredid += Math.abs(parsedData.profitLoss);
                //        tCredit += Math.abs(parsedData.profitLoss);
                //        tmpLiab += parsedData.profitLoss;
                //        sn++;
                //    }
                //    htmls += '<tr class="isGrouptrue"><td colspan="2" style="text-align:right;border:1px solid #575757;padding:2px;">Sub Total : </td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tmpLiab.toFixed(2) + '</td></tr>';
                //    htmls += '<tr><th colspan="2" style="text-align:right;border:1px solid #575757;padding:2px;"></th><th style="text-align:right;border:1px solid #575757;padding:2px;"></th></tr>';
                //    htmls += '</tbody></table>';
                    //$("#divForBalanceSheet").append(htmls);

                    $('#tblOfFinancialAcDr').on('click', '.isGrouptrue', function () {
                        var financialAcId = $(this).attr('id');
                        eventFunction.config.method = "getFinancialAcDetails";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ financialAcId: financialAcId, date: $("#txtEndDate").val() });
                        eventFunction.config.ajaxCallMode = 4;
                        eventFunction.ajaxCall(eventFunction.config);
                    });

                    $('#tblOfFinancialAcCr').on('click', '.isGrouptrue', function () {
                        var financialAcId = $(this).attr('id');
                        eventFunction.config.method = "getFinancialAcDetails";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ financialAcId: financialAcId, date: $("#txtEndDate").val() });
                        eventFunction.config.ajaxCallMode = 4;
                        eventFunction.ajaxCall(eventFunction.config);
                    });

                    $('#tblOfFinancialAcCr').on('dblclick', '.isGroupfalse', function () {
                        var id = $(this).attr('id');
                        var url = p.HostUrl + "/General-Ledger.aspx?ID=" + encodeURIComponent(id);
                        //  window.location.href = url;
                        window.open(url);
                    });


                    $('#tblOfFinancialAcDr').on('dblclick', '.isGroupfalse', function () {
                        var id = $(this).attr('id');
                        var url = p.HostUrl + "/General-Ledger.aspx?ID=" + encodeURIComponent(id);
                        //  window.location.href = url;
                        window.open(url);
                    });
                } else {
                    $("#divForBalanceSheet").html(htmls);
                }
            },
            bindFinancialAcDetails: function (data) {
                var result = JSON.parse(data);
                var htmls = "";
                $("#divForFinancialDetails").html(htmls);

                htmls += '<table class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="width: 88px;text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Particulars</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Debit</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Credit</th></tr></thead><tbody>';
                    if (result.length > 0) {        
                    for (var i = 0; i < result.length; i++) {
                    bal = result[i].Debit - result[i].Credit;
                    htmls += '<tr class="viewlegder" id="'+ result[i].FinancialAcID + '">';
                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (i + 1) + '</td>';
                    htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;">' + result[i].FinancialAcName + '</td>';
                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal > 0 ? bal.toFixed(2) : '0.00') + '</td>';
                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal < 0 ? Math.abs(bal).toFixed(2) : '0.00') + '</td>';
                    htmls += '</tr>';
                    }
                    } else {
                        htmls += '<tr>';
                        htmls += '<td colspan = 4 style="text-align:center;"> No data available</td>';
                        htmls += '</tr>';
                    }
                htmls += '</tbody></table>';

                $("#divForFinancialDetails").append(htmls);
                $('#divForFinancialDetails').dialog({
                    title: 'Details'
                });

                $('#divForFinancialDetails').on('dblclick', '.viewlegder', function () {
                    var id = $(this).attr('id');
                    var url = p.HostUrl + "/General-Ledger.aspx?ID=" + encodeURIComponent(id);
                  //  window.location.href = url;
                    window.open(url);
                });


            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);