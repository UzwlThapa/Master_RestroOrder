﻿/**
 * Cake Bill Bind Generator - BillBind.js Standard
 * Same helpers, fonts, 6-column layout, IRD Annex-6 labels as main BillBind.js
 */

var totalItemsQntyVisible = true;
var netAmt = 0.00;
var ttlAmt = 0;
var CodeQR = JSON.parse(localStorage.getItem("QRCode") || "false");
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
 *  CAKE BILL  (BillBind.js standard)
 * ===================================================================== */
function getCakeBill(salesMasterId, foodCourtOrder, salestype) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RoReport/SalesReport.asmx/GetCakeBill",
        data: JSON.stringify({ SalesMasterID: salesMasterId, SalesType: salestype }),
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

            // Guard: build a safe default discount if null
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

            comphtmls += (" <tr><td colspan='6' style='text-align:center;'><img src='/Modules/ROCompanyInfo/logo/" + safeValue(companyInfo[0].Logo, '') + "' style='width:70px;'/></td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontTitle + ";text-align:center;font-weight:bold;'>" + safeValue(companyInfo[0].Name, 'Company') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + safeValue(companyInfo[0].Address, 'N/A') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + safeValue(companyInfo[0].PhoneNo, 'N/A') + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");

            // Seller's PAN (IRD Annex-6 label)
            comphtmls += ("<tr style='border-top:1px dotted;'><td colspan='3' style='font-size:" + billFontMeta + ";text-align:left;'>Seller's " + (companyInfo[0].IsPan ? "PAN" : "VAT") + " : " + safeValue(companyInfo[0].PAN, 'N/A') + "</td>");
            if (billBody && billBody.length > 0 && (toNumber(billBody[0].PrintCount) - 1) != 0) {
                comphtmls += ("<td colspan='3' style='font-size:" + billFontMeta + ";text-align:left;'><span>Copy of Original:" + (toNumber(billBody[0].PrintCount) - 1) + "</span></td></tr>");
            } else {
                comphtmls += ("<td colspan='3'></td></tr>");
            }

            var logoInfo = comphtmls;
            var htmls = "";

            // Bill Number
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";border-top:1px dotted;'>Bill Number : " + safeValue((billBody && billBody.length > 0 ? billBody[0].BillNo : ''), 'N/A') + "</td></tr>";

            // Purchaser's Name / PAN
            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Purchaser's Name : " + safeValue((billBody && billBody.length > 0 ? billBody[0].CusName : ''), 'Walk-in') + "</td>";
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Purchaser's PAN : " + safeValue((billBody && billBody.length > 0 ? billBody[0].PAN : ''), 'N/A') + "</td></tr>";

            // Phone / Cashier
            if (!foodCourtOrder && billBody && billBody.length > 0) {
                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Phone No. : " + safeValue(billBody[0].PhoneNumber, 'N/A') + "</td>";
                htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Cashier : " + safeValue(billBody[0].Cashier, 'N/A') + "</td></tr>";
            } else if (billBody && billBody.length > 0) {
                htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Cashier : " + safeValue(billBody[0].Cashier, 'N/A') + "</td></tr>";
            }

            // Address
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Address : " + safeValue((billBody && billBody.length > 0 ? billBody[0].Address : ''), 'N/A') + "</td></tr>";

            // Transactions Date
            htmls += "<tr><td colspan='6' style='text-align:left;font-size:" + billFontMeta + ";'>Transactions Date : " + safeValue((billBody && billBody.length > 0 && billBody[0].NepaliInvoiceDate ? billBody[0].NepaliInvoiceDate.split('.').join('/') : ''), 'N/A') + "</td></tr>";

            // Invoice Issue Date & Time
            var date = billBody && billBody.length > 0 ? billBody[0].Date.split(" ") : ["", ""];
            var time = date[1] ? date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + (date[2] || "") : "";
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
            htmls += ("<tr class='orderedInfo'>");
            htmls += ("<td style='text-align:left; font-size:" + billFontTblHead + "; font-weight:bold; border-bottom:1px dotted; border-top:1px dotted;'>#</td>");
            htmls += ("<td style='text-align:left; font-size:" + billFontTiny + "; font-weight:bold; border-bottom:1px dotted; border-top:1px dotted;'>HS</td>");
            htmls += ("<td style='text-align:center; font-size:" + billFontTblHead + "; font-weight:bold; border-bottom:1px dotted; border-top:1px dotted;'>Item</td>");
            htmls += ("<td class='bill-col-qty' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:center; border-bottom:1px dotted; border-top:1px dotted;'>Qty</td>");
            htmls += ("<td class='bill-col-rate' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted; border-top:1px dotted;'>Rate</td>");
            htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + "; font-weight:bold; text-align:right; border-bottom:1px dotted; border-top:1px dotted;'>Amnt</td>");
            htmls += ("</tr>");

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
                    htmls += ("<td style='text-align:left;font-size:" + billFontItem + ";'>" + sn + "</td>");
                    htmls += ("<td style='text-align:left;font-size:" + billFontTiny + ";'>" + (item.HsCode ? item.HsCode : "") + "</td>");
                    htmls += ("<td style='text-align:left;font-size:" + billFontItem + ";white-space:normal;word-wrap:break-word;overflow:visible;'>" + safeValue(item.ITName, 'Item') + "</td>");
                    htmls += ("<td class='bill-col-qty' style='" + billColQtyStyle + "'>" + safeValue(item.Quantity, 0) + "</td>");
                    itemsQnty += toNumber(item.Quantity);
                    htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(item.Rate) + "</td>");
                    htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(toNumber(item.Rate) * toNumber(item.Quantity)) + "</td>");
                    cakeTotalAmount += (toNumber(item.Rate) * toNumber(item.Quantity));
                    sn++;
                    htmls += ("</tr>");
                });
            }

            // Room charge (kept for parity with BillBind.js if data ever carries it)
            if (billBody && billBody.length > 0 && !billBody[0].IsTable && toNumber(billBody[0].BookedDays) > 0 && !splitCostCenter) {
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + safeValue(billBody[0].RoomRate, 0) + "/Day): Rs." + safeValue(billBody[0].RoomCharge, 0) + " (" + safeValue(billBody[0].BookedDays, 0) + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = toNumber(billBody[0].RoomCharge);
            }

            // Sub Total
            htmls += "<tr class='" + (splitCostCenter ? "orderedInfo" : "") + "'>";
            htmls += ("<td colspan='4' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";border-top:1px dotted;padding-right:8px;'>");
            if (totalItemsQntyVisible) {
                htmls += ("<span style='font-weight:bold;font-size:" + billFontTotals + ";'>Total Qty: " + itemsQnty + " </span>");
            }
            htmls += ("</td><td colspan='2' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";border-top:1px dotted;padding-right:8px;'>");
            htmls += ("<span style='font-weight:bold;font-size:" + billFontTotals + ";'>Sub Total : </span>Rs." + (cakeTotalAmount + roomAmount).toFixed(2) + "</td>");
            htmls += ("</tr>");

            // Cake discount (flat / percent, from discount.cakedis)
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

            // KOT / Bar / Bakery / Pizza discounts (only if present in discount object)
            var kotdis = toNumber(discount.kotdis);
            var bevdis = toNumber(discount.bardis);
            var bakerydis = toNumber(discount.bakerydis);
            var pizzadis = toNumber(discount.pizzadis);
            if (!discount.isLoyalty && (kotdis > 0 || bevdis > 0 || bakerydis > 0 || pizzadis > 0)) {
                if (kotdis > 0) {
                    htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>KOT Disc" + (discount.isflatdis ? "" : " (" + kotdis + " %)") + " : </span>Rs." + kotdis.toFixed(2) + "</td></tr>");
                }
                if (bevdis > 0) {
                    htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Bar Disc" + (discount.isflatdis ? "" : " (" + bevdis + " %)") + " : </span>Rs." + bevdis.toFixed(2) + "</td></tr>");
                }
                if (bakerydis > 0) {
                    htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Bakery Disc" + (discount.isflatdis ? "" : " (" + bakerydis + " %)") + " : </span>Rs." + bakerydis.toFixed(2) + "</td></tr>");
                }
                if (pizzadis > 0) {
                    htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Pizza Disc" + (discount.isflatdis ? "" : " (" + pizzadis + " %)") + " : </span>Rs." + pizzadis.toFixed(2) + "</td></tr>");
                }
            }

            // Taxable base — computed once, never mutated inside terms loop
            var taxableBase = cakeTotalAmount + roomAmount - cakeDis - loyaltyDisAmount;

            // Basic Amount
            htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
            htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + taxableBase.toFixed(2));
            htmls += ("</td>");
            htmls += ("</tr>");

            ttlAmt = taxableBase;
            netAmt = taxableBase;

            // Terms (VAT, etc.)
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
            htmls += ("<td colspan=6 style='text-align:left;border-bottom:1px dotted;font-size:" + billFontMeta + ";'>" + "PrintedOn: <span id='divPrintedOn'>" + formatAMPM() + "</span></td>");
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

function numberToWords(number) {
    var digit = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
    var elevenSeries = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
    var countingByTens = ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];
    var shortScale = ['', 'thousand', 'million', 'billion', 'trillion'];

    number = number.toString(); number = number.replace(/[\, ]/g, ''); if (number != parseFloat(number)) return 'not a number'; var x = number.indexOf('.'); if (x == -1) x = number.length; if (x > 15) return 'too big'; var n = number.split(''); var str = ''; var sk = 0; for (var i = 0; i < x; i++) { if ((x - i) % 3 == 2) { if (n[i] == '1') { str += elevenSeries[Number(n[i + 1])] + ' '; i++; sk = 1; } else if (n[i] != 0) { str += countingByTens[n[i] - 2] + ' '; sk = 1; } } else if (n[i] != 0) { str += digit[n[i]] + ' '; if ((x - i) % 3 == 0) str += 'hundred '; sk = 1; } if ((x - i) % 3 == 1) { if (sk) str += shortScale[(x - i - 1) / 3] + ' '; sk = 0; } } if (x != number.length) { var y = number.length; } str = str.replace(/\number+/g, ' '); return str.trim() + " only.";
}