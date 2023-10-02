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
                transactionID: 0,
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.getFinancialAcName();
                if (p.FinancialID != "") {
                    $("#hdnFinancialID").val(p.FinancialID.toString());
                    $("#txtStartDate").val(p.Fromdate == "" ? $("#txtStartDate").val() : p.Fromdate);
                    $("#txtToDate").val(p.Todate == "" ? $("#txtToDate").val() : p.Todate);
                    eventFunction.GeneralLedgerReport();
                }


                $("#btnView").on('click', function () {
                    //if (["", null].includes($("#hdnFinancialID").val())) {
                    //    jAlert("Please select atleast one finanacial account!", 'Information!!', function () { $.alerts.dialogClass = null; });
                    //}
                    //else {
                    //    $(".report-view").show();
                    //    eventFunction.GeneralLedgerReport();
                    //}
                    $(".report-view").show();
                    eventFunction.GeneralLedgerReport();
                });

                $("#btnSalaryView").on('click', function () {
                    $(".report-view").show();
                    eventFunction.GeneralLedgerReportForIndividualAC();
                })
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
                        console.log(data);
                        eventFunction.BindNewGeneralLedger(data.d);
                        break;

                    case 2:
                        eventFunction.BindLedgerDetail(data.d);
                        break;
                    case 3:
                        eventFunction.getTransactionByIDInDialog(data.d);
                        break;
                    case 4:
                        eventFunction.BindIndividualLedgerDetail(data.d);


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
                var faIds = $("#hdnFinancialID").val();
                eventFunction.config.method = "GeneralLedgerReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ StartDate: StartDate, EndDate: EndDate, FaIds: faIds });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GeneralLedgerReportForIndividualAC: function () {

                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtToDate").val();
                var faIds = $("#hdnFinancialID").val();
                eventFunction.config.method = "GeneralLedgerReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ StartDate: StartDate, EndDate: EndDate, FaIds: faIds });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
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

                function split(val) {
                    return val.split(/,\s*/);
                }
                function extractLast(term) {
                    return split(term).pop();
                }
                // clear input on textbox clear
                $("#voucherDropDownList").keyup(function () {
                    if (!this.value) {
                        $('#hdnFinancialID').val('');
                    }
                });
                $("#voucherDropDownList")
                    // don't navigate away from the field on tab when selecting an item
                    .on("keydown", function (event) {
                        if (event.keyCode === $.ui.keyCode.TAB &&
                            $(this).autocomplete("instance").menu.active) {
                            event.preventDefault();
                        }
                    }).
                    autocomplete({
                        minLength: 0,
                        delay: 0,
                        // delegate back to autocomplete, but extract the last term
                        source: function (request, response) {
                            response($.ui.autocomplete.filter(
                                AutocompleteFinancialAc, extractLast(request.term)));
                        },
                        // prevent value inserted on focus
                        focus: function () {
                            return false;
                        },
                        select: function (event, ui) {

                            var terms = split(this.value);
                            // remove the current input value
                            terms.pop();
                            // add the selected item
                            var label = ui.item.label.replace(/[^a-zA-Z0-9]/g, '');
                            if (terms.includes(label)) {
                                jAlert("Finanacial account already selected!", 'Information!!', function () { $.alerts.dialogClass = null; });
                            } else {
                                terms.push(label);
                                // add placeholder to get the comma-and-space at the end
                                terms.push("");
                                this.value = terms.join(", ");

                                let a = $('#hdnFinancialID').val().split(",");
                                a.push(ui.item.id);
                                $('#hdnFinancialID').val(a.filter(x => x).join(", "));
                            }

                            return false;
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
                htmls += '<tr style="font-weight:bold;">';
                htmls += "<th style='text-align:left;border:1px solid #575757;padding-left:2rem !important;'>Date</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Particulars</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Debit</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Credit</th><th style='text-align:right;border:1px solid #575757;padding-right: 8px !important;'>Balance</th><th style='text-align:right;border:1px solid #575757;padding-right: 8px !important;'>View</th>";
                htmls += "</tr>";
                htmls += "</thead>";
                htmls += "<tbody>";


                if (datas.length > 0) {

                    console.log(datas);

                    const groupNameList = [...new Set(datas.map(item => item.ParentAccount))];

                    if (groupNameList.includes("")) {
                        groupNameList.pop("");
                    }
                    var groupTotalDr = 0;
                    var groupTotalCr = 0;
                    var groupTotalBal = 0;
                    var grandTotalDr = 0;
                    var grandTotalCr = 0;
                    var grandTotalBal = 0;

                    $.each(groupNameList, function (index, value) {
                        // Group Header
                        htmls += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                        htmls += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:2rem!important;">Ledger: ${value}</td>`;
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '</tr>';


                        var groupData = datas.filter((item) => item.ParentAccount == value && item.AccountHead != 'Opening Balance');
                        // Opening Balance

                        var openingBalance = datas.filter((item) => item.ParentAccount == value && item.AccountHead == 'Opening Balance');
                        htmls += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                        htmls += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${openingBalance[0].AccountHead}</td>`;
                        htmls += `<td style="text-align:left;border:1px solid #575757;"></td>`;
                        htmls += `<td style="text-align:right;border:1px solid #575757;">${openingBalance[0].Debit}</td>`;
                        htmls += `<td style="text-align:right;border:1px solid #575757;">${openingBalance[0].Credit}</td>`;
                        htmls += `<td style="text-align:right;border:1px solid #575757;padding-right: 8px !important;">${Math.abs(openingBalance[0].Balance) + (openingBalance[0].Balance >= 0 ? ' Dr' : ' Cr')}</td>`;
                        htmls += '<td></td>';
                        htmls += '</tr>';

                        $.each(groupData, function (index, value) {

                            groupTotalDr += value.Debit;
                            groupTotalCr += value.Credit;
                            groupTotalBal += value.Balance;
                            grandTotalDr += value.Debit;
                            grandTotalCr += value.Credit;
                            grandTotalBal += value.Balance;

                            var date = value.Date;
                            var split = date.split(" ");
                            var dta = split[0];

                            htmls += '<tr>';
                            htmls += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${dta} ${value.AccountHead}</td>`;
                            htmls += `<td style="text-align:left;border:1px solid #575757;">${value.Particulars}</td>`;
                            htmls += `<td style="text-align:right;border:1px solid #575757;">${value.Debit}</td>`;
                            htmls += `<td style="text-align:right;border:1px solid #575757;">${value.Credit}</td>`;
                            htmls += `<td style="text-align:right;border:1px solid #575757;padding-right: 8px !important;">${Math.abs(value.Balance) + (value.Balance >= 0 ? ' Dr' : ' Cr')}</td>`;
                            htmls += `<td style="text-align:right;border:1px solid #575757;padding:2px;"><button class="icon-preview btnViewTransaction" type='button' id="${value.TransactionID}"></button></td>`;
                            htmls += '</tr>';
                        });

                        // Group Footer
                        htmls += '<tr style="text-align:left;background:#cfcfcf;font-weight:bold;">';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += `<td style="text-align:right;">Ledger Total: ${groupTotalDr}</td>`;
                        htmls += `<td style="text-align:right;">${groupTotalCr}</td>`;
                        htmls += `<td style="text-align:right;padding-right: 8px !important;">${Math.abs(groupTotalBal).toFixed(2).toString() + (groupTotalBal >= 0 ? ' Dr' : ' Cr')}</td>`;
                        htmls += '</tr>';

                        groupTotalDr = 0;
                        groupTotalCr = 0;
                        groupTotalBal = 0;
                    });

                    // Grand Total Footer
                    htmls += '<tr style="text-align:left;background:#d3c5c5;font-weight:bold;">';
                    htmls += '<td></td>';
                    htmls += '<td></td>';
                    htmls += '<td></td>';
                    htmls += `<td style="text-align:right;">Grand Total:${grandTotalDr}</td>`;
                    htmls += `<td style="text-align:right;">${grandTotalCr}</td>`;
                    htmls += `<td style="text-align:right;padding-right: 8px !important;">${Math.abs(grandTotalBal).toFixed(2).toString() + (grandTotalBal >= 0 ? ' Dr' : ' Cr')}</td>`;
                    htmls += '</tr>';

                    grandTotalDr = 0;
                    grandTotalCr = 0;
                    grandTotalBal = 0;
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

                $("#unittableSecond").on("click", ".btnViewTransaction", function () {
                    var row = $(this).parents('tr');
                    var id = parseInt($(this).attr('id'));

                    console.log(id);
                    eventFunction.config.transactionID = id;
                    let htmls = '';
                    $("#divFinancialDetailView").html(htmls);

                    var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                    htmls += `<label class="icon-print sfBtn restro-btn" id="btnPrintVerifiedTransaction">
                Print</label>
                        <style>
                           .popup-tblTop, #tableTransactionByIDInDialog {
                                border: 1px solid;
                                border-collapse: collapse;

                            }
                            .popup-tblTop tr,#tableTransactionByIDInDialog tr{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop tr,#tableTransactionByIDInDialog th{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop td, #tableTransactionByIDInDialog td {
                            border: 1px solid;
                                border-collapse: collapse;

                            }
                                                    </style>
                            `;
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
                    htmls += "<table class='popup-tblTop'><tr><td>Voucher No. : " + row.find('td:eq(1)').text() + "</td>";
                    htmls += "<td> Voucher : " + row.find('td:eq(2)').text() + "</td></tr>";
                    htmls += "<tr><td> Descriptions : " + row.find('td:eq(3)').text() + "</td>";
                    htmls += "<td>TransactionDate : " + row.find('td:eq(4)').text() + "</td></tr>";
                    htmls += "<tr><td>Total Debit : " + row.find('td:eq(5)').text() + "</td>";
                    htmls += "<td>Total Credit : " + row.find('td:eq(6)').text() + "</td></tr>";
                    htmls += '</table>';
                    $("#divFinancialDetailView").html(htmls);

                    eventFunction.config.method = "getVerifiedTransactionByID";
                    eventFunction.config.url = "/Modules/ChartOfAccount/verifyTransactionEntry/webService/wsVerifyTransactionEntry.asmx/getVerifiedTransactionByID";
                    eventFunction.config.data = JSON2.stringify({ transactionID: id });
                    eventFunction.config.ajaxCallMode = 3;
                    eventFunction.ajaxCall(eventFunction.config);

                    let footerHtml = '';
                    footerHtml += `<table  style='margin-top:25px; float:right'>
                    <tr><td colspan="7"><div style="width:225px;text-align:center;border-top:1px solid;float:right;">Verified By</div></td></tr>
                                    </table>`;
                    $("#divFinancialDetailView").append(footerHtml);

                    $("#divFinancialDetailView").dialog({
                        'title': 'Transaction',
                        width: 1024,
                        modal: true,
                        resizable: true,
                        dialogClass: 'popup-titlebg',
                    });

                    eventFunction.PrintFunction();
                });

            },
            BindIndividualLedgerDetail: function (data) {
                $("#DailyReport").html('');

                datas = JSON.parse(data);

                console.log(datas);
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">General Ledger Report - ' + $("#voucherDropDownList").val() + ' : From ' + $('#txtStartDate').val() + ' To ' + $('#txtToDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='unittableSecond' class='sfGridwrapper  display pur-static-tbl tablee-section reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>";
                htmls += "<thead>";
                htmls += '<tr style="font-weight:bold;">';
                htmls += "<th style='text-align:left;border:1px solid #575757;padding-left:2rem !important;'>Date</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Particulars</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Debit</th><th style='text-align:right;border:1px solid #575757;padding:2px;'>Credit</th><th style='text-align:right;border:1px solid #575757;padding-right: 8px !important;'>Balance</th><th style='text-align:right;border:1px solid #575757;padding-right: 8px !important;'>View</th>";
                htmls += "</tr>";
                htmls += "</thead>";
                htmls += "<tbody>";


                if (datas.length > 0) {

                    const groupNameList = [...new Set(datas.map(item => item.AccountHead.split(" #")[0]))];
                    if (groupNameList.includes("")) {
                        groupNameList.pop("");
                    }

                    var groupTotalDr = 0;
                    var groupTotalCr = 0;
                    var groupTotalBal = 0;
                    var grandTotalDr = 0;
                    var grandTotalCr = 0;
                    var grandTotalBal = 0;

                    var isOpening = false;
                    

                    $.each(groupNameList, function (index, value) {
                        // Group Header
                        htmls += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                        htmls += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:2rem!important;">Ledger: ${value}</td>`;
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        htmls += '</tr>';


                        var groupData = datas.filter((item) => item.AccountHead.split(" #")[0] == value && item.AccountHead != 'Opening Balance');
                        // Opening Balance

                        if (groupData.length === 0 && value == "Opening Balance") {

                            
                            var openingBalance = datas.filter((item) => item.AccountHead == 'Opening Balance' && !(groupNameList.includes(item.ParentAccount)))

                            console.log(groupNameList, openingBalance);
                            $.each(openingBalance, function (index, element) {
                                htmls += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                                htmls += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${element.ParentAccount}</td>`;
                                htmls += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${element.AccountHead}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;">${element.Debit}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;">${element.Credit}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;padding-right: 8px !important;">${Math.abs(element.Balance) + (openingBalance[0].Balance >= 0 ? ' Dr' : ' Cr')}</td>`;
                                htmls += `<td></td>`
                                htmls += '</tr>';

                                grandTotalDr += element.Debit;
                                grandTotalCr += element.Credit;
                                groupTotalDr += element.Debit;
                                groupTotalDr += element.Credit;

                            })
                        }
                        else if(value != "Opening Balance") {
                            var openingBalance = datas.filter((item) => item.AccountHead == 'Opening Balance' && groupData[0].FinancialAcID == item.FinancialAcID)
                            if (openingBalance.length != 0) {

                                groupTotalDr += openingBalance[0].Debit;
                                groupTotalCr += openingBalance[0].Credit;
                                groupTotalBal = openingBalance[0].Balance;

                                grandTotalCr += openingBalance[0].Credit;
                                grandTotalDr += openingBalance[0].Debit;


                                htmls += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                                htmls += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${openingBalance[0].AccountHead}</td>`;
                                htmls += `<td style="text-align:left;border:1px solid #575757;"></td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;">${openingBalance[0].Debit}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;">${openingBalance[0].Credit}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;padding-right: 8px !important;">${Math.abs(openingBalance[0].Balance) + (openingBalance[0].Balance >= 0 ? ' Dr' : ' Cr')}</td>`;
                                htmls += '<td></td>';
                                htmls += '</tr>';

                            }

                            $.each(groupData, function (index, value) {

                                groupTotalDr += value.Debit;
                                groupTotalCr += value.Credit;
                                groupTotalBal = (groupTotalDr > groupTotalCr ? groupTotalDr - groupTotalCr : groupTotalCr - groupTotalDr);

                                grandTotalDr += value.Debit;
                                grandTotalCr += value.Credit;

                                var date = value.Date;
                                var split = date.split(" ");
                                var dta = split[0];

                                htmls += '<tr>';
                                htmls += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${dta} ${value.AccountHead}</td>`;
                                htmls += `<td style="text-align:left;border:1px solid #575757;">${value.Particulars}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;">${value.Debit}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;">${value.Credit}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;padding-right: 8px !important;">${groupTotalBal + (groupTotalDr >= groupTotalCr ? ' Dr' : ' Cr')}</td>`;
                                htmls += `<td style="text-align:right;border:1px solid #575757;padding:2px;"><button class="icon-preview btnViewTransaction" type='button' id="${value.TransactionID}"></button></td>`;
                                htmls += '</tr>';
                            });
                        }
                       
            

                        

                        // Group Footer

                        htmls += '<tr style="text-align:center;background:#cfcfcf;font-weight:bold;">';
                        htmls += '<td></td>';
                        htmls += '<td></td>';
                        
                        htmls += `<td style="text-align:right;">Ledger Total: ${groupTotalDr}</td>`;
                        htmls += `<td style="text-align:right;">${groupTotalCr}</td>`;
                        htmls += `<td style="text-align:right;padding-right: 8px !important;">${Math.abs(groupTotalBal).toFixed(2).toString() + (groupTotalDr >= groupTotalCr ? ' Dr' : ' Cr')}</td>`;
                        htmls += '<td></td>';
                        htmls += '</tr>';

                       
                        groupTotalDr = 0;
                        groupTotalCr = 0;
                        groupTotalBal = 0;
                    });

                    // Grand Total Footer

                    grandTotalBal = (grandTotalDr > grandTotalCr ? grandTotalDr - grandTotalCr : grandTotalCr - grandTotalDr);

                    htmls += '<tr style="text-align:left;background:#d3c5c5;font-weight:bold;">';
                    htmls += '<td></td>';
                    htmls += '<td></td>';
                    htmls += `<td style="text-align:right;">Grand Total:${grandTotalDr}</td>`;
                    htmls += `<td style="text-align:right;">${grandTotalCr}</td>`;
                    htmls += `<td style="text-align:right;padding-right: 8px !important;">${Math.abs(grandTotalBal).toFixed(2).toString() + (grandTotalDr >= grandTotalCr ? ' Dr' : ' Cr')}</td>`;
                    
                    htmls += '<td></td>';
                    htmls += '</tr>';


                    grandTotalDr = 0;
                    grandTotalCr = 0;
                    grandTotalBal = 0;
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

                $("#unittableSecond").on("click", ".btnViewTransaction", function () {
                    var row = $(this).parents('tr');
                    var id = parseInt($(this).attr('id'));

                    console.log(id);
                    eventFunction.config.transactionID = id;
                    let htmls = '';
                    $("#divFinancialDetailView").html(htmls);

                    var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                    htmls += `<label class="icon-print sfBtn restro-btn" id="btnPrintVerifiedTransaction">
                Print</label>
                        <style>
                           .popup-tblTop, #tableTransactionByIDInDialog {
                                border: 1px solid;
                                border-collapse: collapse;

                            }
                            .popup-tblTop tr,#tableTransactionByIDInDialog tr{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop tr,#tableTransactionByIDInDialog th{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop td, #tableTransactionByIDInDialog td {
                            border: 1px solid;
                                border-collapse: collapse;

                            }
                                                    </style>
                            `;
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
                    htmls += "<table class='popup-tblTop'><tr><td>Voucher No. : " + row.find('td:eq(1)').text() + "</td>";
                    htmls += "<td> Voucher : " + row.find('td:eq(2)').text() + "</td></tr>";
                    htmls += "<tr><td> Descriptions : " + row.find('td:eq(3)').text() + "</td>";
                    htmls += "<td>TransactionDate : " + row.find('td:eq(4)').text() + "</td></tr>";
                    htmls += "<tr><td>Total Debit : " + row.find('td:eq(5)').text() + "</td>";
                    htmls += "<td>Total Credit : " + row.find('td:eq(6)').text() + "</td></tr>";
                    htmls += '</table>';
                    $("#divFinancialDetailView").html(htmls);

                    eventFunction.config.method = "getVerifiedTransactionByID";
                    eventFunction.config.url = "/Modules/ChartOfAccount/verifyTransactionEntry/webService/wsVerifyTransactionEntry.asmx/getVerifiedTransactionByID";
                    eventFunction.config.data = JSON2.stringify({ transactionID: id });
                    eventFunction.config.ajaxCallMode = 3;
                    eventFunction.ajaxCall(eventFunction.config);

                    let footerHtml = '';
                    footerHtml += `<table  style='margin-top:25px; float:right'>
                    <tr><td colspan="7"><div style="width:225px;text-align:center;border-top:1px solid;float:right;">Verified By</div></td></tr>
                                    </table>`;
                    $("#divFinancialDetailView").append(footerHtml);

                    $("#divFinancialDetailView").dialog({
                        'title': 'Transaction',
                        width: 1024,
                        modal: true,
                        resizable: true,
                        dialogClass: 'popup-titlebg',
                    });

                    eventFunction.PrintFunction();
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
                htmls += `< label class="icon-print sfBtn restro-btn" id = "btnPrintVerifiedTransaction" >
                            Print</label >
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
                htmls += `< table align = "center" >
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
                              </table > `;
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
                htmls += `< table  style = 'margin-top:25px; float:right' >
            <tr><td colspan="7"><div style="width:225px;text-align:center;border-top:1px solid;float:right;">Verified By</div></td></tr>
                                    </table > `;
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
            getTransactionByIDInDialog: function (datas) {
                //var datas = result.d;
                //$("#DivForViewItemByID").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableTransactionByIDInDialog' class='display dataTable no-footer'><thead><tr><th>S.N.</th><th>FinancialAc</th><th>FinancialAcID</th><th>Particulars</th><th>Debit</th><th>Credit</th><th>Cheque No.</th><th>Cheque Date</th></tr></thead><tbody>";
                    var valids = "";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.financialAcName + '</td>';
                        htmls += '<td>' + value.FinancialAcID + '</td>';
                        htmls += '<td>' + value.Particulars + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Debit).toFixed(2) + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Credit).toFixed(2) + '</td>';
                        htmls += '<td>' + value.ChequeNo + '</td>';
                        dates = value.ChequeDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        //htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '"></label></td></tr>';
                        $("#hdnPostedBy").val(value.PostedBy);
                        datess = value.PostedOn.split(" ");
                        $("#hdnPostedOn").val(datess[0]);
                        VoucherTypeID = value.VoucherTypeID;
                    });
                    htmls += "</tbody></table>";
                    $("#divFinancialDetailView").append(htmls);
                    $("#tableTransactionByIDInDialog").dataTable({
                        search: false,
                        paging: false,
                        info: false,
                        ordering: false,
                        "jqueryUI": true
                    });
                }
                else {
                    $("#divFinancialDetailView").append("<br/>  No Data");
                }
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