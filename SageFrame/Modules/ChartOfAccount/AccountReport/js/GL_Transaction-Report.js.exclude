(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ChartOfAccount/AccountReport/'

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
                baseURL: p.ModulePath + "Reportwebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0,
                ResponseFromDate: '',
                ResponseToDate: '',

            },
            init: function () {
                $("#btnView").click(function () {
                    $('.report-view').show();
                    eventFunction.GetTransactionReport();

                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#divForBalanceSheet').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "TransactionReport_" + $('#txtFrom').val() + '_' + $('#txtTo').val() + ".xls"
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

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.2;
                    pdf.addHTML($("#divForBalanceSheet"), 0, 0, options, function () {
                        pdf.save("TransactionReport_" + $('#txtFrom').val() + '_' + $('#txtTo').val() + '.pdf');

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
                        eventFunction.bindGetTransactionReport(data.d);
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

            GetTransactionReport: function () {
                eventFunction.config.method = "GetTransactionReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ResponseFromDate = $("#txtFrom").val();
                eventFunction.config.ResponseToDate = $("#txtTo").val();
                eventFunction.config.data = JSON2.stringify({ From: $("#txtFrom").val(), To: $("#txtTo").val() });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindGetTransactionReport: function (result) {
                $("#divForBalanceSheet").html('');
                $("#divForBalanceSheet").show();
                data = JSON.parse(result);
                var htmls = "";
                var ShowZero = $('#sltIsZero').val() == "Yes" ? true : false;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Transaction Report From ' + $('#txtFrom').val() + ' To' + $('#txtTo').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += '<table id="tblOfFinancialAc" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="width: 88px;text-align:center;border:1px solid #575757;padding:2px;">GL ID</th><th style="text-align:left;border:1px solid #575757;padding:2px;">GL Account</th><th style="text-align:right;border:1px solid #575757;padding:2px;">Opening Balance</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Debit</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Credit</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Closing Balance</th></tr></thead><tbody>';
                if (data.length > 0) {
                    var tDebit = 0;
                    var tCredit = 0;
                    var tmpDebid = 0;
                    var tmpCredid = 0;
                    $.each(data, function (index, value) {
                        var tr = false;
                        if (value.IsGroup) {
                            tr = true;
                        } else {
                            if (!(value.DebitAmount == 0 && value.CreditAmount == 0)) {
                                tr = true;
                            }
                            //if (!(value.openingBalance == 0 && value.ClosingAmount == 0)) {
                            //    tr = true;
                            //}
                            if (ShowZero) {
                                tr = true;
                            }
                        }
                        if (tr) {
                            if (value.level == 0) {
                                if (value.GlID != 1) {
                                    htmls += '<tr class="isGrouptrue"><td></td><td colspan="2" style="text-align:right;border:1px solid #575757;padding:2px;">Sub Total : </td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tmpDebid.toFixed(2) + '</td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tmpCredid.toFixed(2) + '</td><td style="text-align:center;border:1px solid #575757;padding:2px;"></td></tr>';
                                    tmpDebid = 0;
                                    tmpCredid = 0;
                                }
                            }
                            htmls += '<tr class="isGroup' + value.IsGroup + '"><td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.GlID + '</td>';
                            var Item = '';
                            for (var i = 0; i < value.level; i++) {
                                if (value.level == i + 1) {
                                    Item += "<div class='Lline'></div><span>";
                                }
                                else {
                                    Item += "<div class='vline'></div><span>";
                                }
                            }
                            Item += value.GLName;
                            Item += '</span>';
                            if (!value.IsGroup) {
                                //htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;"><a target="_blank" href="' + SageFrameHostURL + '/Transaction-Detail-Report.aspx?id=' + value.GlID + '&Fromdate=' + eventFunction.config.ResponseFromDate + '&Todate=' + eventFunction.config.ResponseToDate + '">' + Item + '</a></td>';
                                htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;"><a target="_blank" href="' + SageFrameHostURL + '/General-Ledger.aspx?id=' + value.GlID + '&Fromdate=' + eventFunction.config.ResponseFromDate + '&Todate=' + eventFunction.config.ResponseToDate + '">' + Item + '</a></td>';
                            }
                            else {
                                htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;">' + Item + '</td>';
                            }
                            if (value.IsGroup) {
                                htmls += '<td style="text-align:left;border:1px solid #575757;padding:2px;"></td><td style="text-align:left;border:1px solid #575757;padding:2px;"></td><td style="text-align:left;border:1px solid #575757;padding:2px;"></td><td style="text-align:center;border:1px solid #575757;padding:2px;"></td>';
                            }
                            else {
                                tDebit += value.DebitAmount;
                                tCredit += value.CreditAmount;
                                tmpDebid += value.DebitAmount;
                                tmpCredid += value.CreditAmount;

                                //if (value.openingBalance >= 0) {
                                //    htmls += '<td style = "text-align:right;border:1px solid #575757;padding:2px;">' + value.openingBalance.toFixed(2) + '</td>';
                                //}
                                //else {
                                //    htmls += '<td style = "text-align:right;border:1px solid #575757;padding:2px;">(' + Math.abs(value.openingBalance).toFixed(2) + ')</td>';
                                //}
                                //if (value.DebitAmount >= 0) {
                                //    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + value.DebitAmount.toFixed(2) + '</td>';
                                //}
                                //else {
                                //    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">(' + Math.abs(value.DebitAmount).toFixed(2) + ')</td>';
                                //}
                                //if (value.CreditAmount >= 0) {
                                //    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + value.CreditAmount.toFixed(2) + '</td>';
                                //}
                                //else {
                                //    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">(' + Math.abs(value.CreditAmount).toFixed(2) + ')</td>';
                                //}
                                //if (value.ClosingAmount >= 0) {
                                //    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + value.ClosingAmount.toFixed(2) + ' Cr</td></tr>';
                                //}
                                //else {
                                //    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(value.ClosingAmount).toFixed(2) + ' Dr</td>';
                                //}

                            htmls += '<td style = "text-align:right;border:1px solid #575757;padding:2px;">' + (value.openingBalance == 0 ? value.openingBalance : (value.openingBalance >= 0 ? value.openingBalance + ' Dr' : Math.abs(value.openingBalance).toFixed(2) + ' Cr')) + '</td>';
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(value.DebitAmount).toFixed(2) + '</td>';
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(value.CreditAmount).toFixed(2) + '</td>';
                            htmls += '<td style = "text-align:right;border:1px solid #575757;padding:2px;">' + (value.ClosingAmount == 0 ? value.ClosingAmount : (value.ClosingAmount >= 0 ? value.ClosingAmount + ' Dr' : Math.abs(value.ClosingAmount).toFixed(2) + ' Cr')) + '</td>';
                  
                            }

                        }
                    });
                    htmls += '<tr class="isGrouptrue"><td></td><td style="text-align:right;border:1px solid #575757;padding:2px;">Sub Total : </td><td style="text-align:center;border:1px solid #575757;padding:2px;"></td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tmpDebid.toFixed(2) + ' Dr</td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tmpCredid.toFixed(2) + ' Cr</td></tr>';
                    htmls += '<tr><th style="text-align:center;border:1px solid #575757;padding:2px;"></th><th style="text-align:right;border:1px solid #575757;padding:2px;">Total : </th><th style="text-align:center;border:1px solid #575757;padding:2px;"></th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tDebit.toFixed(2) + ' Dr</th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tCredit.toFixed(2) + ' Cr</th></tr>';
                    htmls += '<tr><th style="text-align:center;border:1px solid #575757;padding:2px;"></th><th style="text-align:right;border:1px solid #575757;padding:2px;">Grand Total : </th><th style="text-align:left;border:1px solid #575757;padding:2px;"></th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tDebit.toFixed(2) + ' Dr</th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tCredit.toFixed(2) + ' Cr</th></tr>';
                    htmls += '</tbody></table>';

                    $("#divForBalanceSheet").append(htmls);
                    //$('#divForBalanceSheet').DataTable({

                    //    dom: 'Bfrtip',

                    //    buttons: [

                    //         'copy', 'csv', 'excel', 'pdf'
                    //    ]
                    //});

                } else {
                    $("#divForBalanceSheet").html(htmls);
                }
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);