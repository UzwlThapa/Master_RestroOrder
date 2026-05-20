/// <reference path="../../../Roi_CounterPerson/jquery.dataTables.min.js" />
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ChartOfAccount/TrailBalance/webService/'
             }, p);
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsTrailBalance.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0
            },
            InitialSetup: function () {
              
            },
            init: function () {
             

                $("#btnView").click(function () {
                    $('.report-view').show();
                    eventFunction.getAllFinancialAcForGrid();
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
                        download: "TrialBalance_" + $('#txtDate').val() + ".xls"
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
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#divForBalanceSheet"), 0, 0, options, function () {
                        pdf.save('TrialBalance_' + $('#txtDate').val() + '.pdf');

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
                        eventFunction.bindCompanyInfo(data.d);
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
                eventFunction.config.method = "getAllFinancialAcForGrid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ Dates: $("#txtDate").val() });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindAllFinancialAcForGrid: function (result) {
                $("#divForBalanceSheet").html('');
                $("#divForBalanceSheet").show();
                data = JSON.parse(result);
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Trial Balance For ' + $('#txtDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                var ShowZero = $('#sltIsZero').val() == "Yes" ? true : false;
                htmls += '<table id="tblOfFinancialAc" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="width: 88px;text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Particulars</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Debit</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Credit</th></tr></thead><tbody>';
                if (data.length > 0) {
                    sn = 1;
                    var tDebit = 0;
                    var tCredit = 0;
                    $.each(data, function (index, value) {
                        var tr = false;
                        if (value.isGroup) {
                            tr = true;
                        } else {
                            if (!(value.Debit == 0 && value.Credit == 0) && !(Math.abs(value.Debit - value.Credit) == 0)) {
                                tr = true;
                            }
                            if (ShowZero) {
                                tr = true;
                            }
                        }
                        if (tr) {
                            htmls += '<tr id="' + value.FinancialAcID + '" class="isGroup' + value.isGroup + ' ' + ((value.Debit > 0 && value.Credit > 0) && value.isGroup ? 'showDetails' : '') + '"><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                            sn++;
                            var Item = '';
                            for (var i = 0; i < value.level; i++) {
                                if (value.level == i + 1) {
                                    Item += "<div class='Lline'></div><span>";
                                }
                                else {
                                    Item += "<div class='vline'></div><span>";
                                }
                            }
                            Item += value.items;
                            Item += '</span>';
                            htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;">' + Item + '</td>';
                            if (value.isGroup && (value.Debit == 0 && value.Credit == 0)) {
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;"></td><td style="text-align:center;border:1px solid #575757;padding:2px;"></td>';
                            }
                            else {
                                bal = value.Debit - value.Credit;
                                tDebit += (bal > 0 ? bal : 0);
                                tCredit += (bal < 0 ? Math.abs(bal) : 0);
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal > 0 ? bal.toFixed(2) : '0.00') + '</td>';
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal < 0 ? Math.abs(bal).toFixed(2) : '0.00') + '</td></tr>';
                            }

                        }
                    });
                    htmls += '<tr><td></td><td style="text-align:right;border:1px solid #575757;padding:2px;">Total : </td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tDebit.toFixed(2) + ' Dr</td><td style="text-align:right;border:1px solid #575757;padding:2px;">' + tCredit.toFixed(2) + ' Cr</td></tr>';
                    //htmls += '<tr><th></th><th style="text-align:right;border:1px solid #575757;padding:2px;">Total : </th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tDebit.toFixed(2) + '</th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tCredit.toFixed(2) + '</th></tr>';
                    //htmls += '<tr><th></th><th style="text-align:right;border:1px solid #575757;padding:2px;">Grand Total : </th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tDebit.toFixed(2) + '</th><th style="text-align:right;border:1px solid #575757;padding:2px;">' + tCredit.toFixed(2) + '</th></tr>';
                    htmls += '</tbody></table>';
                    
                    $("#divForBalanceSheet").append(htmls);

                    $('#tblOfFinancialAc').on('click', '.showDetails', function () {
                        var financialAcId = $(this).closest('tr').attr('id');
                        eventFunction.config.method = "getFinancialAcDetails";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ financialAcId: financialAcId, date: $("#txtDate").val() });
                        eventFunction.config.ajaxCallMode = 4;
                        eventFunction.ajaxCall(eventFunction.config);
                    });
                   
                } else {
                    $("#divForBalanceSheet").append(htmls);
                }
            },
            bindFinancialAcDetails: function (data) {
                var result = JSON.parse(data);
                var htmls = "";
                $("#divForFinancialDetails").html(htmls);
                htmls += '<table class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="width: 88px;text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Particulars</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Debit</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Credit</th></tr></thead><tbody>';
                for (var i = 0; i < result.length; i++) {
                    bal = result[i].Debit - result[i].Credit;
                    htmls += '<tr>';
                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (i + 1) + '</td>';
                    htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;">' + result[i].FinancialAcName + '</td>';
                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal > 0 ? bal.toFixed(2) : '0.00') + '</td>';
                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal < 0 ? Math.abs(bal).toFixed(2) : '0.00') + '</td>';
                    htmls += '</tr>';
                }
                htmls += '</tbody></table>';

                $("#divForFinancialDetails").append(htmls);
                $('#divForFinancialDetails').dialog({
                    title: 'Details'
                })
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
