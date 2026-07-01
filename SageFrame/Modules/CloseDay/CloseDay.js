function IntegerAndDecimal(evt, element) {
    var charCode = evt.which || evt.keyCode;

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#CloseDayReport').html();
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
}

function prints() {
    $("#btnCloseDay").hide();
    $(".sfInputbox").css('border', 'none');
    var contents = $('.dashboardmain').html();
    $("#btnCloseDay").show();
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
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                CloseDay: '',
                OccupiedTableDayClosedEnable: '',
                FixedFloat: '0',                   // Fixed float amount from config
                ModulePath: '/Modules/Admin/DashboardSummary/WebServices/'
            }, p);
        var tableList = new Array;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsDashboardSummary.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },
            InitialSetup: function () {
                if (p.CloseDay == 1) {
                    eventFunction.GenerateDayClosingReport();
                    eventFunction.GetOccupiedTableList();
                }
                // If fixed float is enabled, make CashSettlement read-only
                if (parseFloat(p.FixedFloat) > 0) {
                    $('#txtCashSettlement').prop('readonly', true);
                }
            },
            // Applies fixed float logic: auto-calculates CashSettlement and ClosingBalance
            ApplyFixedFloat: function (cashInCounter) {
                var floatAmt = parseFloat(p.FixedFloat);
                if (floatAmt <= 0) return false;

                cashInCounter = parseFloat(cashInCounter) || 0;

                // Settlement = amount to remove = CashInCounter - floatAmt (min 0)
                var settlement = Math.max(0, cashInCounter - floatAmt);
                $('#txtCashSettlement').val(settlement.toFixed(2));

                // ClosingBalance = actual cash left (could be less than float if short)
                var closingBalance = cashInCounter - settlement;
                $('#txtClosingBalance').text('Rs. ' + closingBalance.toFixed(2));

                // Warning if drawer is short
                if (cashInCounter < floatAmt) {
                    var shortAmt = (floatAmt - cashInCounter).toFixed(2);
                    $('#shortfallWarning').remove();
                    $('<div id="shortfallWarning" style="color:red;font-weight:bold;margin-top:5px;">' +
                        '⚠ Cash drawer is short by Rs. ' + shortAmt + '. Please verify the count.</div>')
                        .insertAfter('#txtCashSettlement');
                } else {
                    $('#shortfallWarning').remove();
                }
                return true;
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnView").click(function () {
                    eventFunction.GetCloseReport();
                    $('.report-view').show();
                });

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#CloseDayReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "CloseDayReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
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
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#CloseDayReport"), 0, 0, options, function () {
                        pdf.save('CloseDayReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                });

                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'CloseDay') {
                            eventFunction.CloseTheDay();
                            eventFunction.SaveCashDenomination();
                        }
                    }
                });
                PinCodeSetup();
                NumCodeSetup();

                $("#btnPrints").click(function () {
                    $('h5').css('margin', '5px');
                    $('.closeday-sec table , .closeday-total table').css('font-size', '75%');
                    $('.right-sec').css('border-top', '1px solid');
                    prints();
                });

                // Expenses keyup – recalc CashInCounter and apply fixed float
                $('#txtExpenses').on('keyup', function () {
                    var expenses = parseFloat($('#txtExpenses').val()) || 0;
                    var opening = parseFloat($('#txtOpeningBal').text().split(' ')[1]) || 0;
                    var totalCashReceived = parseFloat($('#txtTotalCashReceived').text().split(' ')[1]) || 0;
                    var newCounter = opening + totalCashReceived - expenses;
                    $('#txtCashInCounter').text('Rs. ' + newCounter.toFixed(2));
                    eventFunction.ApplyFixedFloat(newCounter);
                    $('#txtExpenses').attr('value', expenses);
                });

                // CashSettlement keyup – but it's read-only when fixed float is active
                $('#txtCashSettlement').on('keyup', function () {
                    var cash = parseFloat($('#txtCashSettlement').val()) || 0;
                    var counter = parseFloat($('#txtCashInCounter').text().split(' ')[1]) || 0;
                    var closing = counter - cash;
                    $('#txtClosingBalance').text('Rs. ' + closing.toFixed(2));
                    $('#txtCashSettlement').attr('value', cash);
                });

                // Denomination count – compute total
                $('#Cash').on('keyup', function () {
                    var thousand = 1000 * $('#txtthousand').val();
                    var fivehundred = 500 * $('#txtfivehundred').val();
                    var hundred = 100 * $('#txthundred').val();
                    var fifty = 50 * $('#txtfifty').val();
                    var twenty = 20 * $('#txttwenty').val();
                    var ten = 10 * $('#txtten').val();
                    var five = 5 * $('#txtfive').val();
                    var two = 2 * $('#txttwo').val();
                    var one = 1 * $('#txtone').val();
                    var totalsum = thousand + fivehundred + hundred + fifty + twenty + ten + five + two + one;
                    $('#txtTotalSum').val(totalsum);
                    $('#txtTotalSum').attr('value', totalsum);
                    $('#txtthousand').attr('value', $('#txtthousand').val());
                    $('#txtfivehundred').attr('value', $('#txtfivehundred').val());
                    $('#txthundred').attr('value', $('#txthundred').val());
                    $('#txtfifty').attr('value', $('#txtfifty').val());
                    $('#txttwenty').attr('value', $('#txttwenty').val());
                    $('#txtten').attr('value', $('#txtten').val());
                    $('#txtfive').attr('value', $('#txtfive').val());
                    $('#txttwo').attr('value', $('#txttwo').val());
                    $('#txtone').attr('value', $('#txtone').val());
                });

                // Close Day button – validate denomination against Cash In Counter
                $('#btnCloseDay').on('click', function () {
                    // Get the physical cash expected in the drawer
                    var cashInCounter = parseFloat($('#txtCashInCounter').text().split(' ')[1]) || 0;
                    // Get the cash counted from denominations
                    var totalsum = parseFloat($('#txtTotalSum').val()) || 0;

                    // Allow a 1 Rupee difference to handle rounding
                    var diff = Math.abs(totalsum - cashInCounter);

                    // Check if tables are occupied (if the feature is enabled)
                    if (p.OccupiedTableDayClosedEnable == "true") {
                        if (tableList != "[]") {
                            jAlert("Some tables are still occupied. Please make sure all tables are vacant before closing the day.");
                            return;
                        }
                    }

                    // Main validation: denomination total must match Cash In Counter
                    if (diff > 1) {
                        jAlert(
                            "Cash Denomination total (Rs. " + totalsum.toFixed(2) +
                            ") does not match the Cash In Counter (Rs. " + cashInCounter.toFixed(2) + ").\n\n" +
                            "Please count the cash in the drawer again and enter the correct numbers."
                        );
                        return;
                    }

                    // Everything is correct – proceed with PIN check
                    $('#hdnPinFor').val('CloseDay');
                    InitializePin();
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
                        if (data.d != null && data.d != "")
                            eventFunction.BindDayClosingData(data.d);
                        else
                            $("#divCloseDay").hide(),
                                $("#CashDomination").hide(),
                                jAlert("There is no data.", "Information!!");
                        break;
                    case 2:
                        $("#divCloseDay").hide(),
                            jAlert("The Day has been closed.", "Information!!");
                        break;
                    case 3:
                        var result = data.d;
                        if (result != null) {
                            pinMatch = true;
                            username = result;
                        }
                        else {
                            pinMatch = false;
                        }
                        break;
                    case 4:
                        parent.$.colorbox.close();
                        break;
                    case 5:
                        eventFunction.BindCloseDayReport(data.d);
                        break;
                    case 6:
                        tableList = data.d;
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetOccupiedTableList: function () {
                eventFunction.config.method = "getOccupiedTableList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCloseReport: function () {
                var fromDate = $("#txtStartDate").val();
                var toDate = $("#txtEndDate").val();
                eventFunction.config.method = "ClosDayReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ fromDate: fromDate, toDate: toDate });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindCloseDayReport: function (data) {
                $("#CloseDayReport").show();
                $("#CloseDayReport").html();
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var htmls = '';
                var tblOpeningBalance = 0;
                var tblCash = 0;
                var tblCheque = 0;
                var tblCard = 0;
                var tblCredit = 0;
                var tblTotalCashReceived = 0;
                var tblSurplusDeficit = 0;
                var tblCreditCollectedInCash = 0;
                var tblCreditCollectedInCard = 0;
                var tblCreditCollectedInCheque = 0;
                var tblAdvanceCollectedInCash = 0;
                var tblAdvanceCollectedInCard = 0;
                var tblAdvanceCollectedInCheque = 0;
                var tblCashInCounter = 0;
                var tblCashSettlement = 0;
                var tblClosingBalance = 0;
                var tblTotalSales = 0;
                var tblTotalExpenses = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Close Day Report</p> <p style="text-align:center;margin:0;">From : ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val()) + '   To : ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='tableForViewReport' class='reportsprint' cellspacing='0' style='border:none;width:100%;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Date</th><th>Op Balance</th><th>Cash</th><th>Cheque</th><th>Card</th><th>Credit</th>"
                htmls += "<th>Tt ChReceived</th><th>surplus Deficit</th><th>Cr Cash</th><th>Cr Card</th><th>Cr Cheque</th>"
                htmls += "<th>Ad Cash</th><th>Ad Card</th><th>Ad Chq</th><th>Ch Counter</th><th>Ch Settlement</th><th>Cl Balance</th>"
                htmls += "<th>Total Sales</th><th>Total Exp</th>"
                htmls += "</tr>"
                htmls += "</thead>"

                htmls += "<tbody>"
                var datas = JSON.parse(data);
                if (datas.length > 0) {
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        var date = value.Period.split(" ")
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + date[0] + "</td>";
                        htmls += "<td>" + value.OpeningBalance + "</td>";
                        htmls += "<td>" + value.Cash + "</td>";
                        htmls += "<td>" + value.Cheque + "</td>";
                        htmls += "<td>" + value.Card + "</td>";
                        htmls += "<td>" + value.Credit + "</td>";
                        htmls += "<td>" + value.TotalCashReceived + "</td>";
                        htmls += "<td>" + value.SurplusDeficit + "</td>";
                        htmls += "<td>" + value.CreditCollectedInCash + "</td>";
                        htmls += "<td>" + value.CreditCollectedInCard + "</td>";
                        htmls += "<td>" + value.CreditCollectedInCheque + "</td>";
                        htmls += "<td>" + value.AdvanceCollectedInCash + "</td>";
                        htmls += "<td>" + value.AdvanceCollectedInCard + "</td>";
                        htmls += "<td>" + value.AdvanceCollectedInCheque + "</td>";
                        htmls += "<td>" + value.CashInCounter + "</td>";
                        htmls += "<td>" + value.CashSettlement + "</td>";
                        htmls += "<td>" + value.ClosingBalance + "</td>";
                        htmls += "<td>" + value.TotalSales + "</td>";
                        htmls += "<td>" + value.TotalExpenses + "</td>";
                        htmls += "</tr>"

                        tblOpeningBalance += value.OpeningBalance;
                        tblCash += value.Cash;
                        tblCheque += value.Cheque;
                        tblCard += value.Card;
                        tblCredit += value.Credit;
                        tblTotalCashReceived += value.TotalCashReceived;
                        tblSurplusDeficit += value.SurplusDeficit;
                        tblCreditCollectedInCash += value.CreditCollectedInCash;
                        tblCreditCollectedInCard += value.CreditCollectedInCard;
                        tblCreditCollectedInCheque += value.CreditCollectedInCheque;
                        tblAdvanceCollectedInCash += value.AdvanceCollectedInCash;
                        tblAdvanceCollectedInCard += value.AdvanceCollectedInCard;
                        tblAdvanceCollectedInCheque += value.AdvanceCollectedInCheque;
                        tblCashInCounter += value.CashInCounter;
                        tblCashSettlement += value.CashSettlement;
                        tblClosingBalance += value.ClosingBalance;
                        tblTotalSales += value.TotalSales;
                        tblTotalExpenses += value.TotalExpenses;

                        count++;
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='17' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += '<tr><th colspan=2 >Total:</th><th>  Rs. ' + tblOpeningBalance.toFixed(2) + '</th>';
                htmls += '<th>' + tblCash.toFixed(2) + '</th>';
                htmls += '<th>' + tblCheque.toFixed(2) + '</th>';
                htmls += '<th>' + tblCard.toFixed(2) + '</th>';
                htmls += '<th>' + tblCredit.toFixed(2) + '</th>';
                htmls += '<th>' + tblTotalCashReceived.toFixed(2) + '</th>';
                htmls += '<th>' + tblSurplusDeficit.toFixed(2) + '</th>';
                htmls += '<th>' + tblCreditCollectedInCash.toFixed(2) + '</th>';
                htmls += '<th>' + tblCreditCollectedInCard.toFixed(2) + '</th>';
                htmls += '<th>' + tblCreditCollectedInCheque.toFixed(2) + '</th>';
                htmls += '<th>' + tblAdvanceCollectedInCash.toFixed(2) + '</th>';
                htmls += '<th>' + tblAdvanceCollectedInCard.toFixed(2) + '</th>';
                htmls += '<th>' + tblAdvanceCollectedInCheque.toFixed(2) + '</th>';
                htmls += '<th>' + tblCashInCounter.toFixed(2) + '</th>';
                htmls += '<th>' + tblCashSettlement.toFixed(2) + '</th>';
                htmls += '<th>' + tblClosingBalance.toFixed(2) + '</th>';
                htmls += '<th>' + tblTotalSales.toFixed(2) + '</th>';
                htmls += '<th>' + tblTotalExpenses.toFixed(2) + '</th>';
                htmls += '</tr>';

                htmls += "</tfoot>";
                htmls += "</table>";

                $('#CloseDayReport').html(htmls);
            },
            GenerateDayClosingReport: function () {
                eventFunction.config.method = "GenerateDayClosingReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindDayClosingData: function (result) {
                if (result.IsClosed) {
                    $("#divCloseDay").hide(),
                        $("#CashDomination").hide(),
                        jAlert("The Day has already been closed", "Information!!", function () {
                            parent.$.colorbox.close();
                        });
                }
                else {
                    $('#hdfFinancialID').val(result.FinancialID);
                    $('#hdfPeriod').val(result.Period);
                    $('#txtOpeningBal').html('Rs. ' + result.OpeningBalance);
                    $('#txtTotalSales').html('Rs. ' + result.TotalSales);
                    $('#txtCash').html('Rs. ' + result.Cash);
                    $('#txtCheque').html('Rs. ' + result.Cheque);
                    $('#txtCard').html('Rs. ' + result.Card);
                    $('#txtCredit').html('Rs. ' + result.Credit);
                    $('#txteSewa').html('Rs. ' + result.eSewa);
                    $('#txtFonePay').html('Rs. ' + result.FonePay);
                    $('#txtTotalCashReceived').html('Rs. ' + result.TotalCashReceived);
                    $('#txtSurplusDeficit').html('Rs. ' + result.SurplusDeficit);
                    $('#txtCreditCollectedInCash').html('Rs. ' + result.CreditCollectedInCash);
                    $('#txtCreditCollectedIneSewa').html('Rs. ' + result.CreditCollectedIneSewa);
                    $('#txtCreditCollectedInFonePay').html('Rs. ' + result.CreditCollectedInFonePay);
                    $('#txtCreditCollectedInCheque').html('Rs. ' + result.CreditCollectedInCheque);
                    $('#txtCreditCollectedInCard').html('Rs. ' + result.CreditCollectedInCard);
                    $('#txtCashInCounter').html('Rs. ' + result.CashInCounter);
                    $('#txtCashSettlement').val(result.CashSettlement);
                    $('#txtClosingBalance').html('Rs. ' + result.ClosingBalance);
                    $('#txtAdvanceCollectedInCash').html('Rs. ' + result.AdvanceCollectedInCash);
                    $('#txtAdvanceCollectedInCheque').html('Rs. ' + result.AdvanceCollectedInCheque);
                    $('#txtAdvanceCollectedInCard').html('Rs. ' + result.AdvanceCollectedInCard);
                    $('#txtAdvanceCollectedIneSewa').html('Rs. ' + result.AdvanceCollectedIneSewa);
                    $('#txtAdvanceCollectedInFonePay').html('Rs. ' + result.AdvanceCollectedInFonePay);

                    // Apply fixed float logic after data is loaded
                    var cashInCounter = parseFloat($('#txtCashInCounter').text().split(' ')[1]) || 0;
                    eventFunction.ApplyFixedFloat(cashInCounter);
                }
            },
            CloseTheDay: function () {
                var financialID = $('#hdfFinancialID').val();
                var splitdate = $('#hdfPeriod').val().split(' ')[0].split('/');
                var cashSettlement = parseFloat($('#txtCashSettlement').val());
                var formattedMomth = ("0" + splitdate[1]).slice(-2);   // Month (was splitdate[0])
                var formattedDay = ("0" + splitdate[0]).slice(-2);    // Day (was splitdate[1])
                var period = String(splitdate[2]) + String(formattedMomth) + String(formattedDay);
                var totalexpenses = $('#txtExpenses').val();
                var remarks = $('#txtRemarks').val();
                var cashinCounter = $('#txtCashInCounter').text().split(' ')[1];
                var closingBalance = $('#txtClosingBalance').text();

                if (closingBalance.indexOf("Rs") > -1) {
                    closingBalance = closingBalance.split(' ')[1];
                }

                eventFunction.config.method = "CloseTheDay";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    financialID: financialID, period: period, cashSettlement: cashSettlement, cashinCounter: cashinCounter, closingBalance: closingBalance, totalexpenses: totalexpenses, remarks: remarks
                })
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SaveCashDenomination: function () {
                var cash = new Object;
                cash.thousand = $("#txtthousand").val() == "" ? 0 : $("#txtthousand").val();
                cash.fivehundred = $("#txtfivehundred").val() == "" ? 0 : $("#txtfivehundred").val();
                cash.hundred = $("#txthundred").val() == "" ? 0 : $("#txthundred").val();
                cash.fifty = $("#txtfifty").val() == "" ? 0 : $("#txtfifty").val();
                cash.twenty = $("#txttwenty").val() == "" ? 0 : $("#txttwenty").val();
                cash.ten = $("#txtten").val() == "" ? 0 : $("#txtten").val();
                cash.five = $("#txtfive").val() == "" ? 0 : $("#txtfive").val();
                cash.two = $("#txttwo").val() == "" ? 0 : $("#txttwo").val();
                cash.one = $("#txtone").val() == "" ? 0 : $("#txtone").val();

                eventFunction.config.method = "SaveCashDenomination";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ cash: cash })
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);