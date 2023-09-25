/// <reference path="VoucherReport.js" />
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/ChartOfAccount/AccountReport/',
                CompanyName: '',
                FinancialID: '',
                Fromdate: '',
                Todate: '',
                Pan: ''

            }, p);
        var v = 0;
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
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.getFinancialAcName();
                if (p.FinancialID != "") {
                    $("#hdnFinancialID").val(p.FinancialID);
                    $("#txtStartDate").val(p.Fromdate == "" ? $("#txtStartDate").val() : p.Fromdate);
                    $("#txtToDate").val(p.Todate == "" ? $("#txtToDate").val() : p.Todate);
                    eventFunction.GeneralLedgerReport();
                }


                $("#btnView").on('click', function () {
                    if ($("#hdnFinancialID").val() == 0) {
                        jAlert("Please select one of the Finanacial Account", 'Information!!', function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        $(".report-view").show();
                        eventFunction.GeneralLedgerReport();
                    }

                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#DailyReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "GLReport_" + $('#txtStartDate').val() + '_' + $("#txtToDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();

                    $('#printedDate').hide();
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
                    pdf.addHTML($("#DailyReport"), 0, 0, options, function () {
                        pdf.save('GLReport_' + $('#txtStartDate').val() + '_' + $("#txtToDate").val() + '.pdf');

                    });
                    $('#printedDate').hide();
                });
            },

            init: function () {

                eventFunction.InitialSetup();

                //--------------------------Print PDF----------------
                $("#btnPrint").on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#DailyReport').html();
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
                        eventFunction.bindFinancialAcName(data.d);
                        break;
                    case 1:
                        eventFunction.BindNewGeneralLedger(data.d);
                        break;

                    case 2:
                        eventFunction.BindLedgerDetail(data.d);
                        break;


                }
            },
            ajaxFailure: function () {

            },
            getFinancialAcName: function () {
                eventFunction.config.method = "getFinancialAc";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GeneralLedgerReport: function () {

                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtToDate").val();
                var VoucherNo = $("#hdnFinancialID").val();
                eventFunction.config.method = "GeneralLedgerReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ StartDate: StartDate, EndDate: EndDate, VoucherNo: VoucherNo });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            bindFinancialAcName: function (result) {
                data = JSON.parse(result);
                var AutocompleteFinancialAc = [];
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        AutocompleteFinancialAc.push({ label: value.items, id: value.FinancialAcID });
                    });
                }

                $("#voucherDropDownList").autocomplete({
                    source: AutocompleteFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                        $('#hdnFinancialID').val(ui.item.id);
                    }
                });
            },

            BindNewGeneralLedger: function (data) {
                $("#DailyReport").html('');

                datas = JSON.parse(data);
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">General Ledger Report - ' + $("#voucherDropDownList").val() + ' : From ' + $('#txtStartDate').val() + ' To ' + $('#txtToDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='unittableSecond' class='sfGridwrapper  display pur-static-tbl tablee-section reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>";
                htmls += "<thead>";
                htmls += "<tr>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>VoucherNo</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>AccountHead</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Particulars</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Debit</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Credit</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Balance</th>";
                htmls += "</tr>";
                htmls += "</thead>";
                htmls += "<tbody>";

                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        var date = value.Date;
                        var split = date.split(" ");
                        var dta = split[0];
                        let voucherHtml = value.VoucherNo;
                        if (value.TransactionID > 0) {
                            voucherHtml = `<span class="lblVoucherLink" data-id='${value.TransactionID}'>${value.VoucherNo}</span>`;
                        }

                        htmls += '<tr>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + dta + '</td>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + voucherHtml + '</td>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AccountHead + '</td>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.Particulars + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + value.Debit + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + value.Credit + '</td>';
                        //htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (value.Balance >= 0 ? value.Balance : '('+ Math.abs(value.Balance) +')') + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + Math.abs(value.Balance) + (value.Balance >= 0 ? ' Dr' : ' Cr') + '</td>';
                        htmls += '</tr>';
                    });

                }
                else {
                    $('#DailyReport').html('No data');
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#DailyReport').html(htmls);

                $('.lblVoucherLink').off('click').on('click', function () {
                    let voucherID = $(this).attr('data-id');
                    eventFunction.config.method = "GetLedgerDetail";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ transactionID: voucherID });
                    eventFunction.config.data = eventFunction.config.data;
                    eventFunction.config.ajaxCallMode = 2;
                    eventFunction.ajaxCall(eventFunction.config);
                });

            },

            BindLedgerDetail: function (data) {
                data = JSON.parse(data);

                var ledgerInfo = data.TransactionInfo[0];
                var ledgerDetail = data.TransactionDetail;

                //let htmls = '';

                let htmls = '';
                $("#divFinancialView").html(htmls);

                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                htmls += `<label class="icon-print sfBtn restro-btn" id="btnPrintVerifiedTransaction">
                Print</label>
                        <style>
                           .popup-tblTop, #tableTransactionByIDInDialog {
                                border: 1px solid;
                                border-collapse: collapse;

                            }
                            .popup-tblTop tr, #tableTransactionByIDInDialog tr{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop tr, #tableTransactionByIDInDialog th{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop td, #tableTransactionByIDInDialog td {
                            border: 1px solid;
                                border-collapse: collapse;

                            }
                                                    </style>
                            `;
                //htmls += "<div class='' style='text-align:center; width: 100%'>";
                htmls += `<table align="center" >
                                <tr>
                                    <td colspan="2" style="text-align: center; padding: 0px;">
                                        <img src="/Modules/ROCompanyInfo/logo/${companyInfo.Logo}" style="width:70px;"></td>
                                </tr>
                                <tr>
                                    <td colspan="7" style="font-size: 16px; text-align: center; font-weight: bold; padding: 0px;">${companyInfo.Name}</td>
                                </tr>
                                <tr>
                                    <td colspan="7" style="font-size: 12px; text-align: center; padding: 0px;">${companyInfo.Address} , ${(companyInfo.IsPan ? 'PAN' : 'VAT')} : ${companyInfo.PAN}</td>
                                </tr>
                                <tr><td colspan="7" style="font-size: 12px; text-align: center; padding: 0px;"></td></tr>
                              </table>`;
                htmls += "<table class='popup-tblTop'><tr><td>Voucher No. : " + ledgerInfo.VoucherNo + "</td>";
                htmls += "<td> Voucher : " + ledgerInfo.VoucherName + "</td></tr>";
                htmls += "<tr><td> Descriptions : " + ledgerInfo.Descriptions + "</td>";
                htmls += "<td>TransactionDate : " + ledgerInfo.TransactionDate + "</td></tr>";
                htmls += "<tr><td>Total Debit : " + ledgerInfo.totalDebit + "</td>";
                htmls += "<td>Total Credit : " + ledgerInfo.totalCredit + "</td></tr>";
                htmls += '</table>';

                htmls += "<table id='tableTransactionByIDInDialog' class='display dataTable no-footer' style='margin-top:15px;'><thead><tr><th>S.N.</th><th>FinancialAc</th><th>FinancialAcID</th><th>Particulars</th><th>Debit</th><th>Credit</th><th>Cheque No.</th><th>Cheque Date</th></tr></thead><tbody>";
                if (ledgerDetail.length >= 0) {
                    $(ledgerDetail).each(function (index, value) {
                        htmls += '<tr>';
                        htmls += '<td>' + (index + 1) + '</td>';
                        htmls += '<td>' + value.financialAcName + '</td>';
                        htmls += '<td>' + value.FinancialAcID + '</td>';
                        htmls += '<td>' + value.Particulars + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Debit).toFixed(2) + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Credit).toFixed(2) + '</td>';
                        htmls += '<td>' + value.ChequeNo + '</td>';
                        dates = value.ChequeDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                    });
                    htmls += '</tbody></table>';
                    $("#divForListingVerifiedTransaction").html(htmls);
                    $("#tableTransactionByIDInDialog").dataTable({
                        search: false,
                        paging: false,
                        info: false,
                        ordering: false,
                        "jqueryUI": true
                    });
                }

                //let footerHtml = '';
                htmls += `<table  style='margin-top:25px; float:right'>
                                        <tr><td colspan="7"><div style="width:225px;text-align:center;border-top:1px solid;float:right;">Verified By</div></td></tr>
                                    </table>`;
                $("#divFinancialView").html(htmls);


                $("#divFinancialView").dialog({
                    'title': 'Detail',
                    width: 1024,
                    modal: true,
                    resizable: true,
                    dialogClass: 'popup-titlebg',
                });

                eventFunction.PrintFunction();
            },

            PrintFunction: function () {

                $('#btnPrintVerifiedTransaction').off('click').on('click', function () {
                    var $clone = $('#divFinancialView').clone();


                    $('#btnPrintVerifiedTransaction').remove();
                    $('.dataTables_filter').remove();

                    var contents = $('#divFinancialView').html();

                    $('#divFinancialView').html($clone.html());

                    eventFunction.PrintFunction();

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

                        //// refresh complimentary orders
                        //alert('Print successfull');
                        $('#DialogOrderDetail').dialog('close');
                        //DashboardFunction.GetComplimentaryOccupiedTables(true);
                    }, 500);
                });
            },


            BindGeneralLedger: function (data) {
                $("#DailyReport").html('');

                datas = JSON.parse(data);
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtToDate").val();
                var now = new Date();

                var _DateStr = $.datepicker.formatDate('mm/dd/yy', now);

                debit = 0.00;
                credit = 0.00;
                balance = 0.00;
                if (datas.length > 0) {
                    var htmls = "<table class='pur-static-tbl1'><tr><td colspan='2'> <h2 style='text-align: center;margin:0;'>" + $("#voucherDropDownList :selected").text() + "Transaction </h2></td></tr>";
                    htmls += "<tr><td colspan='2'><h4 style='text-align: center;margin:0;'>" + datas[0].CompanyName + "</h4></td></tr>";
                    htmls += "'<tr><td style='text-align:right;font-size:15px;'> From : " + $("#txtStartDate").val() + " To : " + $("#txtToDate").val() + "</td></tr>";
                    htmls += "<tr><td style='text-align:right;font-size:15px;'> Created  : " + _DateStr + "</td></tr></table>";
                    htmls += "<table id='unittableSecond' class='sfGridwrapper  display pur-static-tbl tablee-section' cellspacing='0'>";
                    htmls += "<thead>";
                    htmls += "<tr>";
                    htmls += "<th>Date</th><th>Transaction</th><th class='tdrate'>Debit</th><th class='tdrate'>Credit</th><th class='tdrate'>Balance</th>";
                    htmls += "</tr>";
                    htmls += "</thead>";
                    htmls += "<tbody>";


                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + value.TransactionDate.split(' ')[0] + "</td>";
                        htmls += "<td>" + value.FinanceName + "</td>";

                        if (value.Debit != 0) {
                            htmls += "<td class='tdrate'>" + parseFloat(value.Debit).toFixed(2) + "</td>";
                            //htmls += "<td>0</td>";
                            debit = (parseFloat(debit) + parseFloat(value.Debit)).toFixed(2);
                            balance = (parseFloat(balance) + parseFloat(value.Debit)).toFixed(2);
                            htmls += "<td class='tdrate'>" + balance + "</td>";
                        } else {
                            //htmls += "<td>0</td>";
                            htmls += "<td class='tdrate'>" + parseFloat(value.Credit).toFixed(2) + "</td>";
                            credit = (parseFloat(credit) + parseFloat(value.Credit)).toFixed(2);
                            balance = (parseFloat(balance) - parseFloat(value.Credit)).toFixed(2);
                            htmls += "<td class='tdrate'>" + balance + "</td>";
                        }
                        htmls += "</tr>";

                    });
                    htmls += "<tr><th colspan='2' style='text-align:right;border-right:1px solid #FFF;'>Total :</th><th style='text-align:right;border-right:1px solid #FFF;'>" + parseFloat(debit).toFixed(2) + "</th><th style='text-align:right;border-right:1px solid #FFF;'>" + parseFloat(credit).toFixed(2) + "</th><th></th></tr>";
                }
                else {
                    htmls += "<tr class='tableItem' >";
                    htmls += "<td>No Data Found</td><tr>";
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#DailyReport').html(htmls);

            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>



        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);