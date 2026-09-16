/**
 * IRD Compliant Bill Bind Generator - Fixed Version
 * Full Item Names, Payment Mode, No Undefined Values, No toFixed crashes
 */

var totalItemsQntyVisible = true;
var ttlAmt = 0;
var CodeQR = JSON.parse(localStorage.getItem("QRCode") || "false");
var netAmt = 0.00;
var IsNonTaxable = false;
let sn = 1;

// --- READABLE FONT SIZES (thermal printer optimized) ---
var billFontTitle  = "14px";
var billFontHead   = "11px";
var billFontMeta   = "10px";
var billFontTblHead= "10px";
var billFontItem   = "10px";
var billFontTotals = "10px";
var billFontNet    = "12px";
var billFontFooter = "9px";
var billFontTiny   = "9px";

// --- COLUMN STYLES ---
var billColQtyStyle  = "text-align:center;font-size:" + billFontItem + ";font-family:monospace;";
var billColRateStyle = "text-align:right;font-size:"  + billFontItem + ";font-family:monospace;";
var billColAmntStyle = "text-align:right;font-size:"  + billFontItem + ";font-family:monospace;";

// --- COMPLETE PRINT CSS ---
var billPrintStyles = "<style type='text/css'>"
    + "@media print{body{margin:0!important;padding:0!important;}}"
    + "@page{margin:2mm!important;}"
    + "table{table-layout:fixed!important;width:100%!important;font-family:monospace,'Courier New',monospace!important}"
    + "table td{line-height:1.4!important}"
    + "td.bill-col-qty{padding:0 6px 0 0!important;white-space:nowrap!important;text-align:center!important;font-size:" + billFontItem + "!important;font-family:monospace!important}"
    + "td.bill-col-rate{padding:0 8px 0 4px!important;white-space:nowrap!important;text-align:right!important;font-size:" + billFontItem + "!important;font-family:monospace!important}"
    + "td.bill-col-amnt{padding:0 8px 0 6px!important;white-space:nowrap!important;text-align:right!important;font-size:" + billFontItem + "!important;font-family:monospace!important}"
    + "</style>";

// --- SAFE NUMERIC HELPERS ---
function toNumber(value) {
    var n = parseFloat(value);
    return isNaN(n) ? 0 : n;
}

function formatBillMoney(value) {
    return toNumber(value).toFixed(2);
}

function formatBillAmntCell(value) {
    return formatBillMoney(value);
}

// --- SAFE STRING HELPER (0 no longer becomes "N/A") ---
function safeValue(value, defaultValue) {
    if (defaultValue === undefined || defaultValue === null) {
        defaultValue = "N/A";
    }
    if (value === undefined || value === null || value === "") {
        return defaultValue;
    }
    return value;
}

// --- LAYOUT ---
function applyBillPrintLayout() {
    if ($("#customer-bill table").length > 0) {
        $("#customer-bill table").css({ "table-layout": "fixed", "width": "100%", "line-height": "1.4" });
        $("#customer-bill table td").not(".bill-col-qty, .bill-col-rate, .bill-col-amnt").css("padding", "0");
        $("#customer-bill table td.bill-col-qty").css({
            "padding": "0 8px 0 0",
            "white-space": "nowrap",
            "text-align": "center"
        });
        $("#customer-bill table td.bill-col-rate").css({
            "padding": "0 10px 0 6px",
            "white-space": "nowrap",
            "text-align": "right"
        });
        $("#customer-bill table td.bill-col-amnt").css({
            "padding": "0 2px 0 8px",
            "white-space": "nowrap",
            "text-align": "right"
        });

        $("#customer-bill table td.col-desc, #customer-bill table td:nth-child(3)").css({
            "white-space": "normal",
            "word-wrap": "break-word",
            "overflow": "visible",
            "max-width": "none"
        });
    }
}

/* =====================================================================
 *  MAIN BILL
 * ===================================================================== */
function getBill(salesMasterId, foodCourtOrder) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RoReport/SalesReport.asmx/GetBill",
        data: JSON.stringify({ SalesMasterID: salesMasterId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var data = data.d;
            var splitCostCenter = data.splitCostCenter;
            var companyInfo = data.companyInfo;
            var billInfo = data.billInfo;
            var billBody = data.orderDetail;
            var terms = data.billingTerm;
            var costcenter = data.cuscenter;
            var costCenterGroup = data.costCenterGroup || [];
            var inwords = data.AmntInWord || "Zero Only";
            var discount = data.discount;
            var costCenterDis = {};

            var isab = companyInfo[0].IsAbbreviated;
            var isAbbreviated = false;
            var billAmount = 0;

            if (isab) {
                var v_rate = companyInfo[0].VATRate;
                isAbbreviated = true;

                if (billInfo.TotalAmount > companyInfo[0].AbbreviatedValue) {
                    isAbbreviated = false;
                    v_rate = 0.0;
                }

                $.each(terms, function (index, value) {
                    if (value.BillTerm == "NetAmount") {
                        billAmount = toNumber(value.Amount).toFixed(2);
                    }
                });
            }

            if (costCenterGroup && costCenterGroup.length > 0) {
                $.each(billBody, function (index, item) {
                    var i = costCenterGroup.findIndex(function (x) { return x.GroupId === item.GroupId; });
                    if (i !== -1) {
                        costCenterGroup[i].TotalAmt += item.IsTaxable ? toNumber(item.Amount) : 0.00;
                        costCenterGroup[i].NonTaxableAmt += item.IsTaxable ? 0 : toNumber(item.Amount);
                    }
                });
            }

            if (discount == null) {
                discount = {
                    isLoyalty: false,
                    isflatdis: false,
                    kotdis: 0.00,
                    bardis: 0.00,
                    roomdis: 0.00,
                    bakerydis: 0.00,
                    pizzadis: 0.00
                };
            } else {
                var Discount = [
                    {
                        GroupId: 1,
                        GroupName: 'KOT',
                        Discount: toNumber(discount.kotdis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[0] && costCenterGroup[0].NonTaxableAmt > 0 ? (costCenterGroup[0].NonTaxableAmt / (costCenterGroup[0].NonTaxableAmt + costCenterGroup[0].TotalAmt)) * toNumber(discount.kotdis) : 0.00) : (costCenterGroup[0] ? costCenterGroup[0].NonTaxableAmt * (toNumber(discount.kotdis) / 100) : 0.00),
                        TaxDis: discount.isflatdis ? (costCenterGroup[0] && costCenterGroup[0].TotalAmt > 0 ? (costCenterGroup[0].TotalAmt / (costCenterGroup[0].NonTaxableAmt + costCenterGroup[0].TotalAmt)) * toNumber(discount.kotdis) : 0.00) : (costCenterGroup[0] ? costCenterGroup[0].TotalAmt * (toNumber(discount.kotdis) / 100) : 0.00),
                        TotalAmount: costCenterGroup[0] ? costCenterGroup[0].TotalAmt : 0,
                        NonTaxableAmt: costCenterGroup[0] ? costCenterGroup[0].NonTaxableAmt : 0
                    },
                    {
                        GroupId: 2,
                        GroupName: 'BAR',
                        Discount: toNumber(discount.bardis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[1] && costCenterGroup[1].NonTaxableAmt > 0 ? (costCenterGroup[1].NonTaxableAmt / (costCenterGroup[1].NonTaxableAmt + costCenterGroup[1].TotalAmt)) * toNumber(discount.bardis) : 0.00) : (costCenterGroup[1] ? costCenterGroup[1].NonTaxableAmt * (toNumber(discount.bardis) / 100) : 0.00),
                        TaxDis: discount.isflatdis ? (costCenterGroup[1] && costCenterGroup[1].TotalAmt > 0 ? (costCenterGroup[1].TotalAmt / (costCenterGroup[1].NonTaxableAmt + costCenterGroup[1].TotalAmt)) * toNumber(discount.bardis) : 0.00) : (costCenterGroup[1] ? costCenterGroup[1].TotalAmt * (toNumber(discount.bardis) / 100) : 0.00),
                        TotalAmount: costCenterGroup[1] ? costCenterGroup[1].TotalAmt : 0,
                        NonTaxableAmt: costCenterGroup[1] ? costCenterGroup[1].NonTaxableAmt : 0
                    },
                    {
                        GroupId: 3,
                        GroupName: 'Bakery',
                        Discount: toNumber(discount.bakerydis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[2] && costCenterGroup[2].NonTaxableAmt > 0 ? (costCenterGroup[2].NonTaxableAmt / (costCenterGroup[2].NonTaxableAmt + costCenterGroup[2].TotalAmt)) * toNumber(discount.bakerydis) : 0.00) : (costCenterGroup[2] ? costCenterGroup[2].NonTaxableAmt * (toNumber(discount.bakerydis) / 100) : 0.00),
                        TaxDis: discount.isflatdis ? (costCenterGroup[2] && costCenterGroup[2].TotalAmt > 0 ? (costCenterGroup[2].TotalAmt / (costCenterGroup[2].NonTaxableAmt + costCenterGroup[2].TotalAmt)) * toNumber(discount.bakerydis) : 0.00) : (costCenterGroup[2] ? costCenterGroup[2].TotalAmt * (toNumber(discount.bakerydis) / 100) : 0.00),
                        TotalAmount: costCenterGroup[2] ? costCenterGroup[2].TotalAmt : 0,
                        NonTaxableAmt: costCenterGroup[2] ? costCenterGroup[2].NonTaxableAmt : 0
                    },
                    {
                        GroupId: 4,
                        GroupName: 'Trading',
                        Discount: toNumber(discount.tradingDis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[3] && costCenterGroup[3].NonTaxableAmt > 0 ? (costCenterGroup[3].NonTaxableAmt / (costCenterGroup[3].NonTaxableAmt + costCenterGroup[3].TotalAmt)) * toNumber(discount.tradingDis) : 0.00) : (costCenterGroup[3] ? costCenterGroup[3].NonTaxableAmt * (toNumber(discount.tradingDis) / 100) : 0.00),
                        TaxDis: discount.isflatdis ? (costCenterGroup[3] && costCenterGroup[3].TotalAmt > 0 ? (costCenterGroup[3].TotalAmt / (costCenterGroup[3].NonTaxableAmt + costCenterGroup[3].TotalAmt)) * toNumber(discount.tradingDis) : 0.00) : (costCenterGroup[3] ? costCenterGroup[3].TotalAmt * (toNumber(discount.tradingDis) / 100) : 0.00),
                        TotalAmount: costCenterGroup[3] ? costCenterGroup[3].TotalAmt : 0,
                        NonTaxableAmt: costCenterGroup[3] ? costCenterGroup[3].NonTaxableAmt : 0
                    }
                ];
                costCenterDis.RoomDis = toNumber(discount.roomdis);
                costCenterDis.RoomRate = billBody[0] ? billBody[0].RoomRate : 0;
                costCenterDis.RoomCharge = billBody[0] ? billBody[0].RoomCharge : 0;
                costCenterDis.isLoyalty = discount.isLoyalty || false;
                costCenterDis.isFlatDis = discount.isflatdis || false;
                costCenterDis.LoaylityDis = toNumber(discount.loyaltydis);
                costCenterDis.GroupDis = Discount;
            }

            $('#customer-bill').html("");
            var comphtmls = "";
            comphtmls += "<input type='hidden' value='" + salesMasterId + "' id='hdfSMID' />";
            if (billBody && billBody.length > 0) {
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].PrintCount, '0') + "' id='hdfPrntCnt' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].CusID, '0') + "' id='hdfCusID' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].CusName, 'Walk-in') + "' id='hdfCusName' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].Address, 'N/A') + "' id='hdfAddress' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].PAN, 'N/A') + "' id='hdfPAN' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].BasicAmount, '0') + "' id='hdfBasicAmount' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].PaymentMode, 'CASH') + "' id='hdfPaymentMode' />";
            }
            comphtmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;border-collapse:collapse;table-layout:fixed;font-family:monospace;'>");

            if (splitCostCenter) {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:6%'/><col style='width:26%'/><col style='width:6%'/><col style='width:14%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/></colgroup>";
            } else {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:7%'/><col style='width:38%'/><col style='width:8%'/><col style='width:20%'/><col style='width:23%'/></colgroup>";
            }

            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontTitle + ";text-align:center;font-weight:bold;'>" + safeValue(companyInfo[0].Name, 'Company Name') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + safeValue(companyInfo[0].Address, 'N/A') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + safeValue(companyInfo[0].PhoneNo, 'N/A') + "</td></tr>");

            if (billInfo.IsArchived) {
                comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'><b>Credit Note</b></td></tr>");
            } else if (billInfo.IsCancelled) {
                comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'><b>Credit Note</b></td></tr>");
            } else {
                if (isab) {
                    if (isAbbreviated) {
                        comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>ABBREVIATED TAX INVOICE</b></td></tr>");
                    } else {
                        comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
                    }
                } else {
                    comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
                }
            }

            // Seller's PAN
            comphtmls += ("<tr style='border-top:1px dotted;'><td colspan='3' style='font-size:" + billFontMeta + ";text-align:left;'>Seller's " + (companyInfo[0].IsPan ? "PAN" : "VAT") + " : " + safeValue(companyInfo[0].PAN, 'N/A') + "</td>");

            if (billBody && billBody.length > 0 && (toNumber(billBody[0].PrintCount) - 1) != 0 && !billInfo.IsCancelled && !billInfo.IsArchived) {
                comphtmls += ("<td colspan='3' style='font-size:" + billFontMeta + ";text-align:left;'><span>Copy of Original:" + (toNumber(billBody[0].PrintCount) - 1) + "</span></td></tr>");
            } else {
                comphtmls += ("<td colspan='3'></td></tr>");
            }

            var logoInfo = comphtmls;
            var htmls = "";

            // Bill Number
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";border-top:1px dotted;'>Bill Number : " + safeValue((billBody && billBody.length > 0 ? billBody[0].BillNo : ''), 'N/A') + "</td></tr>";

            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>C/N No : " + safeValue(billInfo.CreditNoteNumber, 'N/A') + "</td></tr>";
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Date : " + safeValue(billInfo.CreditNoteDate, 'N/A') + "</td></tr>";
            }

            // Purchaser's Name
            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Purchaser's Name : " + safeValue((billBody && billBody.length > 0 ? billBody[0].CusName : ''), 'Walk-in');
            htmls += ("</td>");
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Purchaser's PAN : " + safeValue((billBody && billBody.length > 0 ? billBody[0].PAN : ''), 'N/A') + "</td></tr>";

            if (!foodCourtOrder && billBody && billBody.length > 0) {
                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Phone No. : " + safeValue(billBody[0].PhoneNumber, 'N/A') + "</td>";
                htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Cashier : " + safeValue(billBody[0].Cashier, 'N/A') + "</td></tr>";
            }

            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Ref Inv No : " + safeValue(billInfo.InvoiceNo, 'N/A') + "(" + safeValue(billInfo.InvoiceDate, 'N/A') + ")</td></tr>";
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>C/N Remarks : " + safeValue(billInfo.CreditNoteReason, 'N/A') + "</td></tr>";
                if (!foodCourtOrder && billBody && billBody.length > 0) {
                    htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Table : " + safeValue(billBody[0].restrotableTitle, 'N/A') + "</td></tr>";
                } else {
                    htmls += '<tr><td colspan="6" style="text-align:left;font-size:' + billFontMeta + ';">Cashier : ' + safeValue((billBody && billBody.length > 0 ? billBody[0].Cashier : ''), 'N/A') + '</td></tr>';
                }
            } else {
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Address : " + safeValue((billBody && billBody.length > 0 ? billBody[0].Address : ''), 'N/A') + "</td></tr>";
                var date = billBody && billBody.length > 0 ? billBody[0].Date.split(" ") : ["", ""];
                var time = date[1] ? date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + (date[2] || "") : "";

                if (!foodCourtOrder && billBody && billBody.length > 0) {
                    htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Table : " + safeValue(billBody[0].restrotableTitle, 'N/A') + "</td></tr>";
                } else {
                    htmls += '<tr><td colspan="6" style="text-align:left;font-size:' + billFontMeta + ';">Cashier : ' + safeValue((billBody && billBody.length > 0 ? billBody[0].Cashier : ''), 'N/A') + '</td></tr>';
                }
            }

            // Method of payment
            var paymentMode = (billBody && billBody.length > 0 && billBody[0].PaymentMode) ? billBody[0].PaymentMode : 'CASH';
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";border-top:1px dotted;padding-top:2px;'><strong>Method of payment: </strong>" + safeValue(paymentMode, 'CASH') + "</td></tr>";

            if (!(billInfo.IsCancelled || billInfo.IsArchived) && billBody && billBody.length > 0) {
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Transactions Date : " + safeValue(billBody[0].NepaliInvoiceDate ? billBody[0].NepaliInvoiceDate.split('.').join('/') : '', 'N/A') + "</td></tr>";

                var dateSegment = billBody[0].Date.split(' ');
                var timeSegment = dateSegment[1] ? dateSegment[1].split(':') : [];
                var timeAD = timeSegment.length > 0 ? timeSegment[0] + ':' + timeSegment[1] : '';
                var timezone = dateSegment[2] ? dateSegment[2] : "";
                var fullDate = dateSegment[0] ? dateSegment[0].split('/') : [];
                var formattedDate = fullDate.length > 0 ? fullDate[2] + '/' + fullDate[1] + '/' + fullDate[0] : '';

                var invoiceIssueDate = (billInfo && billInfo.IssueDate) ? billInfo.IssueDate : formattedDate;
                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Invoice Issue Date : " + safeValue(invoiceIssueDate, 'N/A') + "</td><td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Time : " + safeValue(timeAD + timezone, 'N/A') + "</td></tr>";
            }

            // HEADER ROW
            htmls += ("<tr class='orderedInfo'>");
            htmls += ("<td style='text-align:left; font-size:" + billFontTblHead + "; font-weight:bold; border-bottom:1px dotted; border-top:1px dotted;'>#</td>");
            htmls += ("<td style='text-align:left; font-size:" + billFontTiny + "; font-weight:bold; border-bottom:1px dotted; border-top:1px dotted;'>HS</td>");
            htmls += ("<td colspan='" + (splitCostCenter ? 1 : 1) + "' style='text-align:center; font-size:" + billFontTblHead + "; font-weight:bold; border-bottom:1px dotted; border-top:1px dotted;'>Item</td>");
            htmls += ("<td class='bill-col-qty' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:center; border-bottom:1px dotted; border-top:1px dotted;'>Qty</td>");
            htmls += ("<td class='bill-col-rate' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted; border-top:1px dotted;'>Rate</td>");

            if (splitCostCenter) {
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted;'>Food</td>");
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted;'>Bev</td>");
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted;'>Bakery</td>");
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted;'>Pizza</td>");
            } else {
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted; border-top:1px dotted;'>Amnt</td>");
            }

            htmls += ("</tr>");

            var count = 1;
            var kotAmount = 0.00;
            var bevAmount = 0.00;
            var roomAmount = 0.00;
            var bakeryAmount = 0.00;
            var pizzaAmount = 0.00;
            var itemsQnty = 0.00;
            var BasicAmt = 0.00;
            sn = 1;

            if (billBody && billBody.length > 0) {
                $.each(billBody, function (index, item) {
                    var rateN = toNumber(item.Rate);
                    htmls += ("<tr class='orderedInfo'>");
                    htmls += ("<td style='text-align:left;font-size:" + billFontItem + ";'>" + sn + "</td>");
                    htmls += ("<td style='text-align:left;font-size:" + billFontTiny + ";'>" + (item.HsCode ? item.HsCode : "") + "</td>");
                    htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:" + billFontItem + ";white-space:normal;word-wrap:break-word;overflow:visible;'>" + safeValue(item.ITName, 'Item') + "</td>");
                    htmls += ("<td class='bill-col-qty' style='" + billColQtyStyle + "'>" + safeValue(item.Quantity, 0) + "</td>");
                    itemsQnty += toNumber(item.Quantity);
                    sn++;

                    if (isab) {
                        if (isAbbreviated) {
                            if (!costCenterDis.isFlatDis) {
                                $.each(costCenterDis.GroupDis, function (i2, value) {
                                    if (value.GroupId == item.GroupId && value.Discount > 0) {
                                        rateN = parseFloat((rateN * (100 - value.Discount) / 100));
                                        return false;
                                    }
                                });
                            } else if (costCenterDis.isLoyalty) {
                                $.each(costCenterDis.GroupDis, function (i2, value) {
                                    if (value.GroupId == item.GroupId && costCenterDis.LoaylityDis > 0) {
                                        rateN = parseFloat((rateN * (100 - costCenterDis.LoaylityDis) / 100));
                                        return false;
                                    }
                                });
                            } else if (costCenterDis.isFlatDis) {
                                $.each(costCenterDis.GroupDis, function (i2, value) {
                                    if (value.GroupId == item.GroupId && value.Discount > 0) {
                                        var ttldis = toNumber(value.Discount);
                                        var found = costCenterGroup.find(function (x) { return x.GroupId == value.GroupId; });
                                        var ttl = found ? found.TotalAmt : 0;
                                        var disPercent = 0.00;
                                        if (ttldis > 0 && ttl > 0) {
                                            disPercent = (ttldis * 100) / ttl;
                                            rateN = parseFloat((rateN * (100 - disPercent) / 100));
                                        }
                                        return false;
                                    }
                                });
                            }

                            htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(rateN * (1 + toNumber(companyInfo[0].VATRate) / 100.0)) + "</td>");

                            if (splitCostCenter) {
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(toNumber(item.Amount) * (1 + toNumber(companyInfo[0].VATRate) / 100.0)) + "</td>");
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(toNumber(item.Bevrage) * (1 + toNumber(companyInfo[0].VATRate) / 100.0)) + "</td>");
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(toNumber(item.Bakery) * (1 + toNumber(companyInfo[0].VATRate) / 100.0)) + "</td>");
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(toNumber(item.Pizza) * (1 + toNumber(companyInfo[0].VATRate) / 100.0)) + "</td>");
                            } else {
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell((rateN * toNumber(item.Quantity)) * (1 + toNumber(companyInfo[0].VATRate) / 100.0)) + "</td>");
                            }
                        } else {
                            htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(rateN) + "</td>");
                            if (splitCostCenter) {
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Amount) + "</td>");
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bevrage) + "</td>");
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bakery) + "</td>");
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Pizza) + "</td>");
                            } else {
                                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(rateN * toNumber(item.Quantity)) + "</td>");
                            }
                        }
                    } else {
                        htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(rateN) + "</td>");
                        if (splitCostCenter) {
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Amount) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bevrage) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bakery) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Pizza) + "</td>");
                        } else {
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(rateN * toNumber(item.Quantity)) + "</td>");
                        }
                    }
                    htmls += ("</tr>");

                    kotAmount += toNumber(item.Amount);
                    bevAmount += toNumber(item.Bevrage);
                    bakeryAmount += toNumber(item.Bakery);
                    pizzaAmount += toNumber(item.Pizza);

                    if (item.orderExtraItem && item.orderExtraItem.length > 0) {
                        var rate = 0.00;
                        htmls += ("<tr class='orderedInfo'>");
                        htmls += ("<td colspan=" + (splitCostCenter ? 3 : 3) + " style='font-size:" + billFontTiny + ";font-style:italic;'>");
                        $.each(item.orderExtraItem, function (i2, ext) {
                            htmls += safeValue(ext.ExtraItem, 'Extra') + "(" + safeValue(ext.Quantity, 0) + ", Rs." + safeValue(ext.ExtraPrice, 0) + "); ";
                            rate += (toNumber(ext.Quantity) * toNumber(ext.ExtraPrice));
                        });
                        htmls += ("</td>");
                        if (splitCostCenter) {
                            htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Amount > 0 ? rate.toFixed(2) : "0.00") + "</td>");
                            htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Bevrage > 0 ? rate.toFixed(2) : "0.00") + "</td>");
                            htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Bakery > 0 ? rate.toFixed(2) : "0.00") + "</td>");
                            htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Pizza > 0 ? rate.toFixed(2) : "0.00") + "</td>");
                        } else {
                            htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + rate.toFixed(2) + "</td>");
                        }
                        htmls += ("</tr>");
                        kotAmount += (item.Amount > 0 ? rate : 0);
                        bevAmount += (item.Bevrage > 0 ? rate : 0);
                        bakeryAmount += (item.Bakery > 0 ? rate : 0);
                        pizzaAmount += (item.Pizza > 0 ? rate : 0);
                        count = count + 1;
                    }

                    if (isab) {
                        if (isAbbreviated) {
                            BasicAmt += (rateN * toNumber(item.Quantity)) * (1 + toNumber(companyInfo[0].VATRate) / 100.0);
                        } else {
                            BasicAmt += rateN * toNumber(item.Quantity);
                        }
                    } else {
                        BasicAmt += rateN * toNumber(item.Quantity);
                    }
                });
            }

            var kotdis = 0.00;
            var bevdis = 0.00;
            var roomdis = 0.00;
            var totaldis = 0.00;
            var bakerydis = 0.00;
            var pizzadis = 0.00;
            var discType = "";

            if (discount.isflatdis == false) {
                kotdis = (kotAmount * (toNumber(discount.kotdis) / 100)).toFixed(2);
                bevdis = (bevAmount * (toNumber(discount.bardis) / 100)).toFixed(2);
                roomdis = (billBody && billBody.length > 0 ? toNumber(billBody[0].RoomCharge) * (toNumber(discount.roomdis) / 100) : 0).toFixed(2);
                bakerydis = (bakeryAmount * (toNumber(discount.bakerydis) / 100)).toFixed(2);
                pizzadis = (pizzaAmount * (toNumber(discount.pizzadis) / 100)).toFixed(2);
                discType = "%";
            } else {
                kotdis = toNumber(discount.kotdis).toFixed(2);
                bevdis = toNumber(discount.bardis).toFixed(2);
                roomdis = toNumber(discount.roomdis).toFixed(2);
                bakerydis = toNumber(discount.bakerydis).toFixed(2);
                pizzadis = toNumber(discount.pizzadis).toFixed(2);
            }

            if (billBody && billBody.length > 0 && !billBody[0].IsTable && billBody[0].BookedDays > 0 && !splitCostCenter) {
                htmls += ("<tr>");
                var roomRateN = toNumber(costCenterDis.RoomRate);

                if (isab) {
                    if (isAbbreviated) {
                        if (!costCenterDis.isFlatDis) {
                            roomRateN = parseFloat((roomRateN * (100 - costCenterDis.RoomDis) / 100));
                        } else if (costCenterDis.isLoyalty) {
                            roomRateN = parseFloat((roomRateN * (100 - costCenterDis.LoaylityDis) / 100));
                        } else if (costCenterDis.isFlatDis) {
                            var ttldis2 = costCenterDis.RoomDis;
                            var ttl2 = costCenterDis.RoomCharge;
                            var disPercent2 = 0.00;
                            if (ttldis2 > 0 && ttl2 > 0) {
                                disPercent2 = (ttldis2 * 100) / ttl2;
                                roomRateN = parseFloat((roomRateN * (100 - disPercent2) / 100));
                            }
                        }
                        roomRateN = roomRateN * (1 + toNumber(companyInfo[0].VATRate) / 100.0);
                        htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + roomRateN.toFixed(2) + "/Day): Rs." + (roomRateN * toNumber(billBody[0].BookedDays)).toFixed(2) + " (" + safeValue(billBody[0].BookedDays, 0) + " Days)</td>");
                        roomAmount = (roomRateN * toNumber(billBody[0].BookedDays));
                    } else {
                        htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + safeValue(billBody[0].RoomRate, 0) + "/Day): Rs." + safeValue(billBody[0].RoomCharge, 0) + " (" + safeValue(billBody[0].BookedDays, 0) + " Days)</td>");
                        roomAmount = toNumber(billBody[0].RoomCharge);
                    }
                } else {
                    htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + safeValue(billBody[0].RoomRate, 0) + "/Day): Rs." + safeValue(billBody[0].RoomCharge, 0) + " (" + safeValue(billBody[0].BookedDays, 0) + " Days)</td>");
                    roomAmount = toNumber(billBody[0].RoomCharge);
                }
                htmls += ("</tr>");
            }

            htmls += "<tr class='" + (splitCostCenter ? "orderedInfo" : "") + "'>";

            if (splitCostCenter) {
                htmls += ("<td colspan='6' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'>");
                if (totalItemsQntyVisible)
                    htmls += ("<span style='float:left;font-weight:bold;font-size:" + billFontTotals + ";'>Total Qty: " + itemsQnty + " </span>");
                htmls += ("Sub Total :</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'></span>Rs." + kotAmount.toFixed(2) + "</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'></span>Rs." + bevAmount.toFixed(2) + "</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'></span>Rs." + bakeryAmount.toFixed(2) + "</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'></span>Rs." + pizzaAmount.toFixed(2) + "</td>");
            } else {
                htmls += ("<td colspan='4' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";border-top:1px dotted;padding-right:8px;'>");
                if (totalItemsQntyVisible) {
                    htmls += ("<span style='font-weight:bold;font-size:" + billFontTotals + ";'>Total Qty: " + itemsQnty + " </span>");
                }
                htmls += ("</td><td colspan='2' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";border-top:1px dotted;padding-right:8px;'>");
                htmls += ("<span style='font-weight:bold;font-size:" + billFontTotals + ";'>Sub Total : </span>Rs." + (BasicAmt + roomAmount).toFixed(2) + "</td>");
            }
            htmls += ("</tr>");

            if (billBody && billBody.length > 0 && !billBody[0].IsTable && billBody[0].BookedDays > 0 && discount.isLoyalty && splitCostCenter) {
                htmls += ("<tr><td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + safeValue(billBody[0].RoomRate, 0) + "/Day): Rs." + safeValue(billBody[0].RoomCharge, 0) + " (" + safeValue(billBody[0].BookedDays, 0) + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = toNumber(billBody[0].RoomCharge);
            }

            if (billBody && billBody.length > 0 && toNumber(billBody[0].totaldiscount) > 0) {
                htmls += ("<tr class='orderedInfo'>");
                if (splitCostCenter) {
                    htmls += ("<td colspan='3' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Disc(KOT : " + safeValue(discount.kotdis, 0) + discType + ", Bar : " + safeValue(discount.bardis, 0) + discType + ", Bakery : " + safeValue(discount.bakerydis, 0) + discType + ", Pizza : " + safeValue(discount.pizzadis, 0) + discType + ")</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(kotdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(pizzadis).toFixed(2) + "</td></tr>");
                    htmls += ("<tr><td colspan='3' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>After Disc. Amnt</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(kotAmount - kotdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(bevAmount - bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(bakeryAmount - bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + toNumber(pizzaAmount - pizzadis).toFixed(2) + "</td>");
                } else {
                    if (costCenterDis.GroupDis && costCenterDis.GroupDis.length > 0) {
                        if (costCenterDis.isLoyalty) {
                            htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Loyality Disc (" + safeValue(costCenterDis.LoaylityDis, 0) + "%): </span>Rs." + toNumber(billBody[0].totaldiscount).toFixed(2) + "</td></tr>");
                        } else {
                            var showTotalDiscount = localStorage.getItem('ShowTotalDiscount') || 'false';
                            if (showTotalDiscount == 'true') {
                                var totalDisc = 0;
                                $.each(costCenterDis.GroupDis, function (i2, value) {
                                    if (value.Discount > 0) {
                                        if (costCenterDis.isFlatDis) {
                                            totalDisc += toNumber(value.Discount);
                                        } else {
                                            totalDisc += toNumber((value.Discount / 100) * (value.TotalAmount + value.NonTaxableAmt));
                                        }
                                    }
                                });
                                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Total Disc: </span>Rs." + totalDisc.toFixed(2) + "</td></tr>");
                            } else {
                                $.each(costCenterDis.GroupDis, function (i2, value) {
                                    if (value.Discount > 0) {
                                        if (costCenterDis.isFlatDis) {
                                            htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>" + value.GroupName + " Disc: </span>Rs." + toNumber(value.Discount).toFixed(2) + "</td></tr>");
                                        } else {
                                            htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>" + value.GroupName + " Disc (" + value.Discount + " %) : </span>Rs." + toNumber((value.Discount / 100) * (value.TotalAmount + value.NonTaxableAmt)).toFixed(2) + "</td></tr>");
                                        }
                                    }
                                });
                                if (costCenterDis.RoomDis > 0) {
                                    if (costCenterDis.isFlatDis) {
                                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Room Disc: </span>Rs." + toNumber(costCenterDis.RoomDis).toFixed(2) + "</td></tr>");
                                    } else {
                                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Room Disc (" + costCenterDis.RoomDis + " %) : </span>Rs." + toNumber((costCenterDis.RoomDis / 100) * costCenterDis.RoomCharge).toFixed(2) + "</td></tr>");
                                    }
                                }
                            }
                        }
                        if (isab) {
                            if (isAbbreviated) {
                                htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><em>(Discount has already been deducted in above mentioned item rate)</em></td></tr>");
                            }
                        }
                    }
                }
                htmls += ("</tr>");
            }

            totaldis = toNumber(billBody && billBody.length > 0 ? billBody[0].totaldiscount : 0).toFixed(2);

            if (!isab) {
                htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
                htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + (kotAmount + bevAmount + roomAmount + bakeryAmount + pizzaAmount - toNumber(totaldis)).toFixed(2));
                htmls += ("</td>");
                htmls += ("</tr>");
            } else {
                if (!isAbbreviated) {
                    htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
                    htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + (kotAmount + bevAmount + roomAmount + bakeryAmount + pizzaAmount - toNumber(totaldis)).toFixed(2));
                    htmls += ("</td>");
                    htmls += ("</tr>");
                }
            }
            var basicamount = (kotAmount + bevAmount + roomAmount + bakeryAmount + pizzaAmount - toNumber(totaldis)).toFixed(2);

            var NonTaxableTotalAmt = 0.00;
            var TaxableTotalAmt = 0.00;
            var NonTaxableDis = 0.00;
            var TaxableDis = 0.00;

            if (costCenterDis.GroupDis) {
                $.each(costCenterDis.GroupDis, function (i2, value) {
                    NonTaxableTotalAmt += toNumber(value.NonTaxableAmt);
                    TaxableTotalAmt += toNumber(value.TotalAmount);
                    NonTaxableDis += toNumber(value.NonTaxDis);
                    TaxableDis += toNumber(value.TaxDis);
                });
            }

            if (terms && terms.length > 0) {
                var servicecharge = 0;
                $.each(terms, function (i2, value) {
                    if (value.BillTerm.toLowerCase() == "service charge") {
                        servicecharge = toNumber(value.Amount).toFixed(2);
                    }
                    if (!isab) {
                        if (value.BillTerm.toLowerCase() == "vat") {
                            if (IsNonTaxable) {
                                htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                                htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>Non Taxable Amount : </span>");
                                htmls += ("<span>Rs. " + (NonTaxableTotalAmt - NonTaxableDis).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");
                            }
                            htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                            htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>Taxable Amount : </span>");
                            if (IsNonTaxable)
                                htmls += ("<span>Rs. " + (TaxableTotalAmt - TaxableDis).toFixed(2) + "</span></td>");
                            else
                                htmls += ("<span>Rs. " + (toNumber(terms[terms.length - 1].Amount) - toNumber(terms[terms.length - 2].Amount) - toNumber(value.Amount)).toFixed(2) + "</span></td>");
                            htmls += ("</tr>");
                        }
                        htmls += ("<tr id='" + value.BillTerm + "' style='font-size:" + billFontTotals + ";text-align:right;'>");
                        if (value.Rate > 0) {
                            htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                            htmls += ("(" + value.Rate + "%" + ") : </span>");
                        } else {
                            htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:" + billFontNet + ";" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
                        }
                        htmls += ("<span>Rs. " + toNumber(value.Amount).toFixed(2) + "</span></td>");
                        htmls += ("</tr>");
                    } else {
                        if (!isAbbreviated) {
                            if (value.BillTerm.toLowerCase() == "vat") {
                                htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                                htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>Taxable Amount : </span>");
                                htmls += ("<span>Rs. " + (toNumber(basicamount) + toNumber(servicecharge)).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");

                                htmls += ("<tr id='" + value.BillTerm + "' style='font-size:" + billFontTotals + ";text-align:right;'>");
                                if (value.Rate > 0) {
                                    if (value.BillTerm.toLowerCase() == "home delivery") {
                                        htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                                        htmls += (" : </span>");
                                    } else {
                                        htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                                        htmls += ("(" + value.Rate + "%" + ") : </span>");
                                    }
                                    htmls += ("<span>Rs. " + toNumber(value.Amount).toFixed(2) + "</span></td>");
                                    htmls += ("</tr>");
                                }
                            }
                        } else {
                            if (value.BillTerm.toLowerCase() == "deliverycharge" && toNumber(value.Amount) > 0) {
                                htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                                htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                                htmls += (" : </span>");
                                htmls += ("<span>Rs. " + toNumber(value.Amount).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");
                            }
                        }
                    }

                    if (isab) {
                        if (value.BillTerm.toLowerCase() == "netamount") {
                            htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:" + billFontNet + ";" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
                            htmls += ("<span>Rs. " + toNumber(value.Amount).toFixed(2) + "</span></td>");
                        }
                    }
                    htmls += ("</tr>");

                    if (value.BillTerm == "NetAmount") {
                        ttlAmt = toNumber(value.Amount); // store numeric
                    }
                });
            }

            if (billBody && billBody.length > 0 && !billBody[0].IsTable && billBody[0].BookedDays > 0) {
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Adv. Payment : </span><span>(Rs. " + toNumber(billBody[0].AdvancePayment).toFixed(2) + ")</span></td>");
                htmls += ("</tr>");
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontNet + ";padding-right:8px;'><span>Rem. Amount : </span><span>Rs. " + toNumber(billBody[0].BasicAmount).toFixed(2) + "</span></td>");
                htmls += ("</tr>");
            }

            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:left;font-size:" + billFontMeta + ";word-break:break-word;white-space:normal;'> In Words : " + safeValue(inwords, 'Zero Only') + "</td>");
            htmls += ("</tr>");

            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:center;font-size:" + billFontFooter + ";'>");
            htmls += ("**Thank You**");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:center;font-size:" + billFontTiny + ";'>");
            htmls += ("Powered By Restro Order");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("</table>");

            htmls += "<input type='hidden' value='" + ((!((kotAmount + bevAmount + bakeryAmount + pizzaAmount) > 0)) ? "true" : "false") + "' id='hdfHide' />";
            htmls += "<div id='divqrcode' style='display:none;'></div><div class='QRCode' style='text-align:center;'><img src='' id='codeimg' style='margin-top:10px; height:100px;display:none;'></div>";
            var string = "{Company:\"" + safeValue(companyInfo[0].Name, 'Company') + "\", Bill No:" + safeValue((billBody && billBody.length > 0 ? billBody[0].BillNo : ''), 'N/A') + ", Date: " + safeValue((billBody && billBody.length > 0 && billBody[0].NepaliInvoiceDate ? billBody[0].NepaliInvoiceDate.split('.').join('/') : ''), 'N/A') + ", Time: " + safeValue(time, 'N/A') + ", Amount: " + toNumber(ttlAmt).toFixed(2) + "}";
            body = htmls;
            $('#customer-bill').html(logoInfo + body);
            if (CodeQR == true) {
                $("#codeimg").show();
                $('#divqrcode').qrcode(string);
                var canvas = $('#divqrcode canvas');
                var img = canvas.get(0).toDataURL("image/png");
                $('#codeimg').attr('src', img);
            }

            if (billBody && billBody.length > 0 && toNumber(billBody[0].PrintCount) >= 3) {
                $('#printno').show();
            }
            applyBillPrintLayout();
            $("#NetAmount_text").text("Net Amount :");
            var chargeEl = $("#DeliveryCharge").text();
            var charge = chargeEl ? chargeEl.split(' ')[2] : 0;
            if (toNumber(charge) <= 0) {
                $('tr#DeliveryCharge').remove();
            }
            $("#NetAmount").css('font-weight', 'Bold');
            $("#NetAmount").css('font-size', billFontNet);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!", function () {
                $.alerts.dialogClass = null;
            });
        }
    });
}

/* =====================================================================
 *  CAKE BILL
 * ===================================================================== */
function getSalesReport_CakeBill(SalesMasterID, SalesType) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RoReport/SalesReport.asmx/GetCakeBill",
        data: JSON.stringify({ SalesMasterID: SalesMasterID, SalesType: SalesType }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var data = data.d;
            var splitCostCenter = data.splitCostCenter;
            var companyInfo = data.companyInfo;
            var billInfo = data.billInfo;
            var billBody = data.orderDetail;
            var terms = data.billingTerm;
            var costcenter = data.cuscenter;
            var inwords = data.AmntInWord || "Zero Only";
            var discount = data.discount;

            // Guard: if discount object is null, build a safe default
            if (discount == null) {
                discount = {
                    isLoyalty: false,
                    isflatdis: false,
                    kotdis: 0.00,
                    bardis: 0.00,
                    roomdis: 0.00,
                    bakerydis: 0.00,
                    pizzadis: 0.00,
                    cakedis: 0.00,
                    loyaltydis: 0.00
                };
            } else {
                if (discount.cakedis === undefined || discount.cakedis === null || discount.cakedis === "") {
                    discount.cakedis = 0.00;
                }
                if (discount.loyaltydis === undefined || discount.loyaltydis === null || discount.loyaltydis === "") {
                    discount.loyaltydis = 0.00;
                }
            }

            $('#customer-bill').html("");
            var comphtmls = "";
            comphtmls += "<input type='hidden' value='" + SalesMasterID + "' id='hdfSMID' />";
            if (billBody && billBody.length > 0) {
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].PrintCount, '0') + "' id='hdfPrntCnt' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].CusID, '0') + "' id='hdfCusID' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].CusName, 'Walk-in') + "' id='hdfCusName' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].Address, 'N/A') + "' id='hdfAddress' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].PAN, 'N/A') + "' id='hdfPAN' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].BasicAmount, '0') + "' id='hdfBasicAmount' />";
                comphtmls += "<input type='hidden' value='" + safeValue(billBody[0].PaymentMode, 'CASH') + "' id='hdfPaymentMode' />";
            }
            comphtmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;border-collapse:collapse;table-layout:fixed;font-family:monospace;'>");
            if (splitCostCenter) {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:6%'/><col style='width:26%'/><col style='width:6%'/><col style='width:14%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/></colgroup>";
            } else {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:7%'/><col style='width:38%'/><col style='width:8%'/><col style='width:20%'/><col style='width:23%'/></colgroup>";
            }
            comphtmls += (" <tr><td colspan='6' style='text-align:center;'><img src='/Modules/ROCompanyInfo/logo/" + safeValue(companyInfo[0].Logo, '') + "' style='width:70px;'/></td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontTitle + ";text-align:center;font-weight:bold;'>" + safeValue(companyInfo[0].Name, 'Company') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + safeValue(companyInfo[0].Address, 'N/A') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + safeValue(companyInfo[0].PhoneNo, 'N/A') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontMeta + ";text-align:left;'>Seller's " + (companyInfo[0].IsPan ? "PAN" : "VAT") + " : " + safeValue(companyInfo[0].PAN, 'N/A') + "</td></tr>");

            var logoInfo = comphtmls;
            var htmls = "";

            // Bill Number
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";border-top:1px dotted;'>Bill Number : " + safeValue((billBody && billBody.length > 0 ? billBody[0].BillNo : ''), 'N/A') + "</td></tr>";

            // Purchaser
            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Purchaser's Name : " + safeValue((billBody && billBody.length > 0 ? billBody[0].CusName : ''), 'Walk-in') + "</td>";
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Purchaser's PAN : " + safeValue((billBody && billBody.length > 0 ? billBody[0].PAN : ''), 'N/A') + "</td></tr>";

            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Phone No. : " + safeValue((billBody && billBody.length > 0 ? billBody[0].PhoneNumber : ''), 'N/A') + "</td>";
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Cashier : " + safeValue((billBody && billBody.length > 0 ? billBody[0].Cashier : ''), 'N/A') + "</td></tr>";

            var date = billBody && billBody.length > 0 ? billBody[0].Date.split(" ") : ["", ""];
            var time = date[1] ? date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + (date[2] || "") : "";
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Address : " + safeValue((billBody && billBody.length > 0 ? billBody[0].Address : ''), 'N/A') + "</td></tr>";
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Transactions Date : " + safeValue((billBody && billBody.length > 0 && billBody[0].NepaliInvoiceDate ? billBody[0].NepaliInvoiceDate.split('.').join('/') : ''), 'N/A') + "</td></tr>";

            var dateSegment = billBody && billBody.length > 0 ? billBody[0].Date.split(' ') : [""];
            var timeSegment = dateSegment[1] ? dateSegment[1].split(':') : [];
            var timeAD = timeSegment.length > 0 ? timeSegment[0] + ':' + timeSegment[1] : '';
            var fullDate = dateSegment[0] ? dateSegment[0].split('/') : [];
            var formattedDate = fullDate.length > 0 ? fullDate[2] + '/' + fullDate[1] + '/' + fullDate[0] : '';
            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Invoice Issue Date : " + safeValue(formattedDate, 'N/A') + "</td><td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Time : " + safeValue(timeAD + (date[2] || ""), 'N/A') + "</td></tr>";

            // Method of payment
            var paymentMode = (billBody && billBody.length > 0 && billBody[0].PaymentMode) ? billBody[0].PaymentMode : 'CASH';
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";border-top:1px dotted;padding-top:2px;'><strong>Method of payment: </strong>" + safeValue(paymentMode, 'CASH') + "</td></tr>";

            // HEADER ROW
            htmls += ("<tr class=''>");
            htmls += ("<td style='text-align:left;font-size:" + billFontTblHead + ";font-weight:bold;border-bottom:1px dotted;border-top:1px dotted;'>#</td>");
            htmls += ("<td style='text-align:left;font-size:" + billFontTiny + ";font-weight:bold;border-bottom:1px dotted;border-top:1px dotted;'>HS</td>");
            htmls += ("<td style='text-align:center;font-size:" + billFontTblHead + ";font-weight:bold;border-bottom:1px dotted;border-top:1px dotted;'>Item</td>");
            htmls += ("<td class='bill-col-qty' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:center;border-bottom:1px dotted;border-top:1px dotted;'>Qty</td>");
            htmls += ("<td class='bill-col-rate' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;'>Rate</td>");
            if (splitCostCenter) {
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;'>Food</td>");
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;'>Bev</td>");
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;'>Bakery</td>");
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;'>Pizza</td>");
            } else {
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;'>Amnt</td>");
            }
            htmls += ("</tr>");

            var count = 1;
            var kotAmount = 0.00;
            var bevAmount = 0.00;
            var roomAmount = 0.00;
            var bakeryAmount = 0.00;
            var pizzaAmount = 0.00;
            var itemsQnty = 0.00;
            var cakeTotalAmount = 0.00;
            sn = 1;

            if (billBody && billBody.length > 0) {
                $.each(billBody, function (index, item) {
                    htmls += ("<tr class='orderedInfo'>");
                    htmls += ("<td style='width: 2%;text-align:left;font-size:" + billFontItem + ";'>" + sn + "</td>");
                    htmls += ("<td style='width: 2%;text-align:left;font-size:" + billFontTiny + ";'>" + (item.HsCode || '') + "</td>");
                    htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:" + billFontItem + ";white-space:normal;word-wrap:break-word;overflow:visible;'>" + safeValue(item.ITName, 'Item') + "</td>");
                    htmls += ("<td class='bill-col-qty' style='" + billColQtyStyle + "'>" + safeValue(item.Quantity, 0) + "</td>");
                    itemsQnty += toNumber(item.Quantity);
                    htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(item.Rate) + "</td>");
                    htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(toNumber(item.Rate) * toNumber(item.Quantity)) + "</td>");
                    cakeTotalAmount += (toNumber(item.Rate) * toNumber(item.Quantity));
                    sn++;
                    htmls += ("</tr>");
                });
            }

            // Room charge (if applicable — same pattern as main bill)
            if (billBody && billBody.length > 0 && !billBody[0].IsTable && toNumber(billBody[0].BookedDays) > 0 && !splitCostCenter) {
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + safeValue(billBody[0].RoomRate, 0) + "/Day): Rs." + safeValue(billBody[0].RoomCharge, 0) + " (" + safeValue(billBody[0].BookedDays, 0) + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = toNumber(billBody[0].RoomCharge);
            }

            // Sub Total
            htmls += "<tr class='" + (splitCostCenter ? "orderedInfo" : "") + "'>";
            htmls += ("<td colspan='6' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'>");
            if (totalItemsQntyVisible)
                htmls += ("<span style='float:left;font-weight:bold;font-size:" + billFontTotals + ";'>Total Qty: " + itemsQnty + " </span>");
            htmls += ("Sub Total : </span>Rs." + (cakeTotalAmount + roomAmount).toFixed(2) + "</td>");
            htmls += ("</tr>");

            // Cake discount
            var cakeDis = toNumber(discount.cakedis);
            if (cakeDis > 0) {
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Discount : Rs." + cakeDis.toFixed(2) + "</td>");
                htmls += ("</tr>");
            }

            // Loyalty discount
            var loyaltyDisPercent = toNumber(discount.loyaltydis);
            var loyaltyDisAmount = 0.00;
            if (discount.isLoyalty) {
                loyaltyDisAmount = toNumber((cakeTotalAmount + roomAmount) * (loyaltyDisPercent / 100));
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Loyalty Discount (" + loyaltyDisPercent + " %) : Rs." + loyaltyDisAmount.toFixed(2) + "</td>");
                htmls += ("</tr>");
            }

            var taxableBase = cakeTotalAmount + roomAmount - cakeDis - loyaltyDisAmount;

            // Basic Amount
            htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
            htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + taxableBase.toFixed(2));
            htmls += ("</td>");
            htmls += ("</tr>");

            // Terms (VAT, etc.) — do NOT mutate taxableBase inside the loop
            ttlAmt = taxableBase;
            netAmt = taxableBase;

            if (terms && terms.length > 0) {
                var taxableShown = false;
                $.each(terms, function (i2, value) {
                    var termName = (value.BillTerm || "").toLowerCase();

                    if (termName == "vat" && !taxableShown) {
                        htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                        htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>Taxable Amount : </span>");
                        htmls += ("<span>Rs. " + taxableBase.toFixed(2) + "</span></td>");
                        htmls += ("</tr>");
                        taxableShown = true;
                    }

                    htmls += ("<tr id='" + safeValue(value.BillTerm, '') + "' style='font-size:" + billFontTotals + ";text-align:right;'>");
                    if (toNumber(value.Rate) > 0) {
                        htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;'><span>" + safeValue(value.BillTerm, '') + "(" + value.Rate + "%) : </span>");
                        htmls += ("<span>Rs. " + toNumber(value.Amount).toFixed(2) + "</span></td>");
                    } else {
                        var isNet = (value.BillTerm == "NetAmount");
                        htmls += ("<td colspan='6' style='text-align:right;padding-right:8px;" + (isNet ? "border-top:1px dotted; font-size:" + billFontNet + ";" : "") + "'><span id='" + safeValue(value.BillTerm, '') + "_text'>" + safeValue(value.BillTerm, '') + "</span> ");
                        htmls += ("<span>Rs. " + toNumber(value.Amount).toFixed(2) + "</span></td>");
                        if (isNet) {
                            netAmt = toNumber(value.Amount);
                            ttlAmt = toNumber(value.Amount);
                        }
                    }
                    htmls += ("</tr>");
                });
            }

            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'></td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:left;font-size:" + billFontMeta + ";word-break:break-word;white-space:normal;'> In Words : " + safeValue(inwords, 'Zero Only') + "</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:center;font-size:" + billFontFooter + ";'>**Thank You**</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:center;font-size:" + billFontTiny + ";'>Powered By Restro Order</td>");
            htmls += ("</tr>");
            htmls += ("</table>");

            htmls += "<input type='hidden' value='" + ((!((kotAmount + bevAmount + bakeryAmount + pizzaAmount) > 0)) ? "true" : "false") + "' id='hdfHide' />";
            htmls += "<div id='divqrcode' style='display:none;'></div><div class='QRCode' style='text-align:center;'><img src='' id='codeimg' style='margin-top:10px; height:100px; display:none;'></div>";

            var string = "{Company:\"" + safeValue(companyInfo[0].Name, 'Company') + "\", Bill No:" + safeValue((billBody && billBody.length > 0 ? billBody[0].BillNo : ''), 'N/A') + ", Date: " + safeValue((billBody && billBody.length > 0 && billBody[0].NepaliInvoiceDate ? billBody[0].NepaliInvoiceDate.split('.').join('/') : ''), 'N/A') + ", Time: " + safeValue(time, 'N/A') + ", Amount: " + toNumber(ttlAmt).toFixed(2) + "}";
            body = htmls;
            $('#customer-bill').html(logoInfo + body);

            if (CodeQR == true) {
                $("#codeimg").show();
                $('#divqrcode').qrcode(string);
                var canvas = $('#divqrcode canvas');
                var img = canvas.get(0).toDataURL("image/png");
                $('#codeimg').attr('src', img);
            }

            if (billBody && billBody.length > 0 && toNumber(billBody[0].PrintCount) >= 3) {
                $('#printno').show();
            }
            applyBillPrintLayout();
            $("#NetAmount_text").text("Net Amount :");
            $("#NetAmount_text").next().text(netAmt.toFixed(2));
            var chargeEl = $("#DeliveryCharge").text();
            var charge = chargeEl ? chargeEl.split(' ')[2] : 0;
            if (toNumber(charge) <= 0) {
                $('tr#DeliveryCharge').remove();
            }
            $("#NetAmount").css('font-weight', 'Bold');
            $("#NetAmount").css('font-size', billFontNet);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!", function () {
                $.alerts.dialogClass = null;
            });
        }
    });
}

/* =====================================================================
 *  HELPERS
 * ===================================================================== */
function formatAMPM() {
    var date = new Date();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12;
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strDateTime = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + '/' + (date.getDate() < 10 ? '0' : '') + date.getDate() + '/' + date.getFullYear() + "   " + hours + ':' + minutes + ' ' + ampm;
    return strDateTime;
}

function formatDate() {
    var date = new Date();
    var dateformat = date.getFullYear() + '-' + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + '-' + (date.getDate() < 10 ? '0' : '') + date.getDate();
    return AD2BS(dateformat).split('-').join('.');
}