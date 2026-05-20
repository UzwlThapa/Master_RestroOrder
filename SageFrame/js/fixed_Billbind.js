// ============================================================
// BillBind.js - Fixed for POS80C Thermal Printer
// Fixes: null safety, column overflow, item name wrapping,
//        beer price merging, in-words truncation, all fields
// ============================================================

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

            // ── NULL GUARD: stop if response is empty ──────────────
            if (!data || !data.d) {
                jAlert("Bill data not found.", "Error!!");
                return;
            }

            var data            = data.d;
            var splitCostCenter = data.splitCostCenter || false;
            var companyInfo     = data.companyInfo     || [];
            var billInfo        = data.billInfo        || {};
            var billBody        = data.orderDetail     || [];
            var terms           = data.billingTerm     || [];
            var costCenterGroup = data.costCenterGroup || [];
            var inwords         = data.AmntInWord      || '';
            var discount        = data.discount;
            var costCenterDis   = {};

            // ── NULL GUARD: stop if critical arrays are empty ──────
            if (!companyInfo.length || !billBody.length) {
                jAlert("Bill data incomplete.", "Error!!");
                return;
            }

            // ── SAFE HELPERS ───────────────────────────────────────
            function safe(val, fallback) {
                fallback = fallback !== undefined ? fallback : '';
                return (val !== null && val !== undefined) ? val : fallback;
            }
            function safeFloat(val) {
                var f = parseFloat(val);
                return isNaN(f) ? 0.00 : f;
            }
            function safeTrunc(str, maxLen) {
                str = safe(str, '');
                return str.length > maxLen ? str.substring(0, maxLen - 2) + '..' : str;
            }

            // ── ABBREVIATED BILL CHECK ─────────────────────────────
            var isab        = companyInfo[0].IsAbbreviated || false;
            var isAbbreviated = false;
            var billAmount  = 0;
            var v_rate      = 0;

            if (isab) {
                v_rate = safeFloat(companyInfo[0].VATRate);
                isAbbreviated = true;
                if (safeFloat(billInfo.TotalAmount) > safeFloat(companyInfo[0].AbbreviatedValue)) {
                    isAbbreviated = false;
                    v_rate = 0.0;
                }
                $.each(terms, function (i, value) {
                    if (value.BillTerm === "NetAmount") {
                        billAmount = safeFloat(value.Amount).toFixed(2);
                    }
                });
            }

            // ── COST CENTER GROUP TOTALS ───────────────────────────
            $.each(billBody, function (index, item) {
                var group = costCenterGroup.filter(x => x.GroupId === item.GroupId);
                if (group.length > 0) {
                    var i = costCenterGroup.findIndex(x => x.GroupId === item.GroupId);
                    costCenterGroup[i].TotalAmt      += item.IsTaxable ? safeFloat(item.Amount) : 0.00;
                    costCenterGroup[i].NonTaxableAmt += item.IsTaxable ? 0 : safeFloat(item.Amount);
                }
            });

            // ── DISCOUNT SETUP ─────────────────────────────────────
            if (!discount) {
                discount = {
                    isLoyalty:  false,
                    isflatdis:  false,
                    kotdis:     0.00,
                    bardis:     0.00,
                    roomdis:    0.00,
                    bakerydis:  0.00,
                    pizzadis:   0.00,
                    tradingDis: 0.00,
                    loyaltydis: 0.00
                };
            }

            // Safe cost center group access (default to 0 if group missing)
            function getCCG(idx) {
                return costCenterGroup[idx] || { TotalAmt: 0, NonTaxableAmt: 0 };
            }
            function calcDis(flatDis, ccg, dis) {
                if (flatDis) {
                    var total = ccg.NonTaxableAmt + ccg.TotalAmt;
                    return {
                        NonTaxDis: total > 0 ? (ccg.NonTaxableAmt / total) * safeFloat(dis) : 0,
                        TaxDis:    total > 0 ? (ccg.TotalAmt    / total) * safeFloat(dis) : 0
                    };
                }
                return {
                    NonTaxDis: ccg.NonTaxableAmt * (safeFloat(dis) / 100),
                    TaxDis:    ccg.TotalAmt      * (safeFloat(dis) / 100)
                };
            }

            var Discount = [
                { GroupId: 1, GroupName: 'KOT',     Discount: safeFloat(discount.kotdis),     ...calcDis(discount.isflatdis, getCCG(0), discount.kotdis),     TotalAmount: getCCG(0).TotalAmt, NonTaxableAmt: getCCG(0).NonTaxableAmt },
                { GroupId: 2, GroupName: 'BAR',     Discount: safeFloat(discount.bardis),     ...calcDis(discount.isflatdis, getCCG(1), discount.bardis),     TotalAmount: getCCG(1).TotalAmt, NonTaxableAmt: getCCG(1).NonTaxableAmt },
                { GroupId: 3, GroupName: 'Bakery',  Discount: safeFloat(discount.bakerydis),  ...calcDis(discount.isflatdis, getCCG(2), discount.bakerydis),  TotalAmount: getCCG(2).TotalAmt, NonTaxableAmt: getCCG(2).NonTaxableAmt },
                { GroupId: 4, GroupName: 'Trading', Discount: safeFloat(discount.tradingDis), ...calcDis(discount.isflatdis, getCCG(3), discount.tradingDis), TotalAmount: getCCG(3).TotalAmt, NonTaxableAmt: getCCG(3).NonTaxableAmt },
            ];

            costCenterDis.RoomDis    = safeFloat(discount.roomdis);
            costCenterDis.RoomRate   = safe(billBody[0].RoomRate,   0);
            costCenterDis.RoomCharge = safe(billBody[0].RoomCharge, 0);
            costCenterDis.isLoyalty  = discount.isLoyalty  || false;
            costCenterDis.isFlatDis  = discount.isflatdis  || false;
            costCenterDis.LoaylityDis = safeFloat(discount.loyaltydis);
            costCenterDis.GroupDis   = Discount;

            // ══════════════════════════════════════════════════════
            // BUILD HTML
            // ══════════════════════════════════════════════════════
            $('#customer-bill').html("");
            var comphtmls = "";

            // ── THERMAL CSS (POS80C: 72mm printable width) ─────────
            comphtmls += "<style>";
            comphtmls += "@media print{";
            comphtmls += "  *{font-family:'Courier New',Courier,monospace !important;font-size:8px !important;line-height:1.3 !important;margin:0 !important;padding:0 !important;box-sizing:border-box !important;}";
            comphtmls += "  body{width:72mm !important;margin:0 !important;padding:0 !important;}";
            comphtmls += "  table{width:100% !important;table-layout:fixed !important;border-collapse:collapse !important;word-wrap:break-word !important;}";
            comphtmls += "  td,th{padding:1px 2px !important;font-size:8px !important;line-height:1.3 !important;overflow:hidden !important;word-break:break-word !important;vertical-align:top !important;}";
            comphtmls += "  .hdr{font-size:10px !important;font-weight:bold !important;text-align:center !important;}";
            comphtmls += "  .sub{font-size:8px !important;text-align:center !important;}";
            comphtmls += "  .bold{font-weight:bold !important;}";
            comphtmls += "  .tr{text-align:right !important;}";
            comphtmls += "  .tc{text-align:center !important;}";
            comphtmls += "  .tl{text-align:left !important;}";
            comphtmls += "  .dash{border-top:1px dashed #000 !important;}";
            comphtmls += "  .dasb{border-bottom:1px dashed #000 !important;}";
            comphtmls += "  .QRCode{display:none !important;}";
            comphtmls += "}";
            // Screen preview styles (mirrors print)
            comphtmls += "  #customer-bill table{width:100%;table-layout:fixed;border-collapse:collapse;font-family:'Courier New',monospace;font-size:8px;line-height:1.3;}";
            comphtmls += "  #customer-bill td,#customer-bill th{padding:1px 2px;font-size:8px;line-height:1.3;overflow:hidden;word-break:break-word;vertical-align:top;}";
            comphtmls += "</style>";

            // ── HIDDEN FIELDS ──────────────────────────────────────
            comphtmls += "<input type='hidden' value='" + salesMasterId                      + "' id='hdfSMID' />";
            comphtmls += "<input type='hidden' value='" + safe(billBody[0].PrintCount, 0)    + "' id='hdfPrntCnt' />";
            comphtmls += "<input type='hidden' value='" + safe(billBody[0].CusID, '')        + "' id='hdfCusID' />";
            comphtmls += "<input type='hidden' value='" + safe(billBody[0].CusName, '')      + "' id='hdfCusName' />";
            comphtmls += "<input type='hidden' value='" + safe(billBody[0].Address, '')      + "' id='hdfAddress' />";
            comphtmls += "<input type='hidden' value='" + safe(billBody[0].PAN, '')          + "' id='hdfPAN' />";
            comphtmls += "<input type='hidden' value='" + safe(billBody[0].BasicAmount, 0)   + "' id='hdfBasicAmount' />";

            // ── MAIN TABLE ─────────────────────────────────────────
            // 5 columns: SN(4%) | Item(40%) | Qty(8%) | Rate(22%) | Amt(26%)
            comphtmls += "<table>";

            // ── COMPANY HEADER ─────────────────────────────────────
            comphtmls += "<tr><td colspan='5' class='hdr dasb'>" + safe(companyInfo[0].Name) + "</td></tr>";
            comphtmls += "<tr><td colspan='5' class='sub'>" + safe(companyInfo[0].Address) + "</td></tr>";
            comphtmls += "<tr><td colspan='5' class='sub dasb'>" + safe(companyInfo[0].PhoneNo) + "</td></tr>";

            // ── INVOICE TYPE ───────────────────────────────────────
            if (billInfo.IsArchived || billInfo.IsCancelled) {
                comphtmls += "<tr><td colspan='5' class='tc bold'>CREDIT NOTE</td></tr>";
            } else if (isab && isAbbreviated) {
                comphtmls += "<tr><td colspan='5' class='tc bold'>ABBREVIATED TAX INVOICE</td></tr>";
            } else {
                comphtmls += "<tr><td colspan='5' class='tc bold'>TAX INVOICE</td></tr>";
            }

            // ── PAN / COPY INFO ────────────────────────────────────
            var panLabel = companyInfo[0].IsPan ? "PAN" : "VAT";
            var copyNo   = safeFloat(billBody[0].PrintCount) - 1;
            comphtmls += "<tr>";
            comphtmls += "  <td colspan='3' class='tl'>" + panLabel + ": " + safe(companyInfo[0].PAN) + "</td>";
            if (copyNo > 0 && !billInfo.IsCancelled && !billInfo.IsArchived) {
                comphtmls += "  <td colspan='2' class='tr'>Copy: " + copyNo + "</td>";
            } else {
                comphtmls += "  <td colspan='2'></td>";
            }
            comphtmls += "</tr>";

            var logoInfo = comphtmls;

            // ══════════════════════════════════════════════════════
            // BODY HTML (customer info + items + totals + footer)
            // ══════════════════════════════════════════════════════
            var htmls   = "";
            var ttlAmt  = "0.00";
            var nepaliDate = "";
            var time       = "";

            // ── CUSTOMER INFO ──────────────────────────────────────
            var customerName = safeTrunc(billBody[0].CusName, 22);
            var cusPhone     = safeTrunc(billBody[0].PhoneNumber, 15);
            var cashier      = safe(billBody[0].Cashier, '');
            var cusPAN       = safe(billBody[0].PAN, '');

            htmls += "<tr class='dash'>";
            htmls += "  <td colspan='3' class='tl'>Cust: " + customerName + "</td>";
            htmls += "  <td colspan='2' class='tr'>PAN: " + cusPAN + "</td>";
            htmls += "</tr>";

            if (!foodCourtOrder) {
                htmls += "<tr>";
                htmls += "  <td colspan='3' class='tl'>Ph: " + cusPhone + "</td>";
                htmls += "  <td colspan='2' class='tr'>Cashier: " + cashier + "</td>";
                htmls += "</tr>";
            }

            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<tr><td colspan='5' class='tl'>Ref Inv: " + safe(billInfo.InvoiceNo) + "</td></tr>";
                htmls += "<tr><td colspan='5' class='tl dasb'>Remarks: " + safe(billInfo.CreditNoteReason) + "</td></tr>";
            } else {
                // Safe date parsing
                var rawDate = safe(billBody[0].Date, '');
                var dateParts = rawDate.split(" ");
                var dateOnly  = dateParts[0] || '';
                var timePart  = dateParts[1] || '';
                var ampm      = dateParts[2] || '';
                var timeHM    = timePart ? timePart.split(":")[0] + ":" + (timePart.split(":")[1] || '00') + " " + ampm : '';

                nepaliDate = safe(billBody[0].NepaliInvoiceDate, '').split('.').join('/');
                time = timeHM;

                htmls += "<tr>";
                htmls += "  <td colspan='3' class='tl'>Inv No: " + safe(billBody[0].BillNo) + "</td>";
                htmls += "  <td colspan='2' class='tr'>Date(NP): " + nepaliDate + "</td>";
                htmls += "</tr>";

                htmls += "<tr>";
                htmls += "  <td colspan='3' class='tl'>Date(AD): " + dateOnly + "</td>";
                htmls += "  <td colspan='2' class='tr dasb'>Time: " + time + "</td>";
                htmls += "</tr>";

                if (!foodCourtOrder) {
                    htmls += "<tr><td colspan='5' class='tl'>Table: " + safe(billBody[0].restrotableTitle, 'Take Away') + "</td></tr>";
                }
            }

            // ── ITEM TABLE HEADER ──────────────────────────────────
            // Columns: SN(4%) | Item(40%) | Qty(8%) | Rate(22%) | Amt(26%)
            htmls += "<tr class='dash dasb'>";
            if (!splitCostCenter) {
                htmls += "<th style='width:4%'  class='tl bold'>SN</th>";
                htmls += "<th style='width:40%' class='tl bold'>Item</th>";
                htmls += "<th style='width:8%'  class='tc bold'>Qty</th>";
                htmls += "<th style='width:22%' class='tr bold'>Rate</th>";
                htmls += "<th style='width:26%' class='tr bold'>Amt</th>";
            } else {
                htmls += "<th style='width:4%'  class='tl bold'>SN</th>";
                htmls += "<th style='width:34%' class='tl bold'>Item</th>";
                htmls += "<th style='width:8%'  class='tc bold'>Qty</th>";
                htmls += "<th style='width:12%' class='tr bold'>Rate</th>";
                htmls += "<th style='width:21%' class='tr bold'>Food</th>";
                htmls += "<th style='width:21%' class='tr bold'>Bev</th>";
            }
            htmls += "</tr>";

            // ── ITEM ROWS ──────────────────────────────────────────
            var sn          = 1;
            var kotAmount   = 0.00;
            var bevAmount   = 0.00;
            var roomAmount  = 0.00;
            var bakeryAmount = 0.00;
            var pizzaAmount = 0.00;
            var itemsQnty   = 0.00;
            var BasicAmt    = 0.00;

            $.each(billBody, function (index, item) {
                // ── NULL SAFE item name ────────────────────────────
                var rawName  = safe(item.ITName, '(No Name)');
                var itemName = rawName.split('_')[0] || '(No Name)';
                // Truncate to 20 chars so rate/amount columns have room
                itemName = safeTrunc(itemName, 20);

                var rateN = safeFloat(item.Rate);

                htmls += "<tr>";
                htmls += "<td class='tl'>" + sn + "</td>";

                if (!splitCostCenter) {
                    htmls += "<td class='tl'>" + itemName + "</td>";
                    htmls += "<td class='tc'>" + safe(item.Quantity, 0) + "</td>";

                    // Abbreviated: apply discount + VAT to rate
                    if (isab && isAbbreviated && !costCenterDis.isFlatDis) {
                        $.each(costCenterDis.GroupDis || [], function (gi, gv) {
                            if (gv.GroupId === item.GroupId && gv.Discount > 0) {
                                rateN = rateN * (100 - gv.Discount) / 100;
                                return false;
                            }
                        });
                        rateN = rateN * (1 + v_rate / 100.0);
                    }

                    htmls += "<td class='tr'>" + rateN.toFixed(2) + "</td>";
                    htmls += "<td class='tr'>" + (rateN * safeFloat(item.Quantity)).toFixed(2) + "</td>";
                } else {
                    htmls += "<td class='tl'>" + itemName + "</td>";
                    htmls += "<td class='tc'>" + safe(item.Quantity, 0) + "</td>";
                    htmls += "<td class='tr'>" + rateN.toFixed(2) + "</td>";
                    htmls += "<td class='tr'>" + safeFloat(item.Amount).toFixed(2)  + "</td>";
                    htmls += "<td class='tr'>" + safeFloat(item.Bevrage).toFixed(2) + "</td>";
                }

                htmls += "</tr>";

                itemsQnty   += safeFloat(item.Quantity);
                sn++;

                kotAmount   += safeFloat(item.Amount);
                bevAmount   += safeFloat(item.Bevrage);
                bakeryAmount += safeFloat(item.Bakery);
                pizzaAmount += safeFloat(item.Pizza);

                if (isab && isAbbreviated) {
                    BasicAmt += (rateN * safeFloat(item.Quantity)) * (1 + v_rate / 100.0);
                } else {
                    BasicAmt += rateN * safeFloat(item.Quantity);
                }
            });

            // ── SUBTOTAL ───────────────────────────────────────────
            var cols = splitCostCenter ? 5 : 4; // item cols count
            htmls += "<tr class='dash'>";
            htmls += "<td colspan='" + (splitCostCenter ? 3 : 3) + "' class='tr bold'>";
            if (typeof totalItemsQntyVisible !== 'undefined' && totalItemsQntyVisible) {
                htmls += "Total Qty: " + itemsQnty + " | ";
            }
            htmls += "Sub Total:</td>";
            htmls += "<td colspan='2' class='tr bold'>Rs." + (BasicAmt + roomAmount).toFixed(2) + "</td>";
            htmls += "</tr>";

            // ── DISCOUNT ───────────────────────────────────────────
            var totaldis = safeFloat(billBody[0].totaldiscount).toFixed(2);
            if (safeFloat(billBody[0].totaldiscount) > 0) {
                // Per cost center discount breakdown
                if (costCenterDis.GroupDis) {
                    $.each(costCenterDis.GroupDis, function (i, gd) {
                        if (gd.Discount > 0) {
                            htmls += "<tr>";
                            htmls += "<td colspan='3' class='tr'>" + gd.GroupName + " Disc (" + gd.Discount + (costCenterDis.isFlatDis ? "" : "%") + "):</td>";
                            htmls += "<td colspan='2' class='tr'>Rs." + (safeFloat(gd.TaxDis) + safeFloat(gd.NonTaxDis)).toFixed(2) + "</td>";
                            htmls += "</tr>";
                        }
                    });
                }
                htmls += "<tr>";
                htmls += "<td colspan='3' class='tr'>Total Discount:</td>";
                htmls += "<td colspan='2' class='tr'>Rs." + totaldis + "</td>";
                htmls += "</tr>";

                if (isab && isAbbreviated) {
                    htmls += "<tr><td colspan='5' class='tc' style='font-style:italic;font-size:7px;'>(Discount deducted in item rate)</td></tr>";
                }
            }

            // ── BASIC AMOUNT + TAX ─────────────────────────────────
            var basicamount = (kotAmount + bevAmount + roomAmount + bakeryAmount + pizzaAmount - safeFloat(totaldis)).toFixed(2);

            if (!isab || (isab && !isAbbreviated)) {
                htmls += "<tr>";
                htmls += "<td colspan='3' class='tr'>Basic Amt:</td>";
                htmls += "<td colspan='2' class='tr'>" + basicamount + "</td>";
                htmls += "</tr>";
            }

            if (terms && terms.length > 0) {
                $.each(terms, function (index, value) {
                    if (!value || !value.BillTerm) return;

                    if (value.BillTerm.toLowerCase() === "vat") {
                        htmls += "<tr>";
                        htmls += "<td colspan='3' class='tr'>Taxable Amt:</td>";
                        htmls += "<td colspan='2' class='tr'>" + safeFloat(basicamount).toFixed(2) + "</td>";
                        htmls += "</tr>";
                    }

                    if (safeFloat(value.Rate) > 0) {
                        htmls += "<tr>";
                        htmls += "<td colspan='3' class='tr'>" + safe(value.BillTerm) + " (" + value.Rate + "%):</td>";
                        htmls += "<td colspan='2' class='tr'>" + safeFloat(value.Amount).toFixed(2) + "</td>";
                        htmls += "</tr>";
                    }

                    if (value.BillTerm === "NetAmount") {
                        ttlAmt = safeFloat(value.Amount).toFixed(2);
                        htmls += "<tr class='dash dasb'>";
                        htmls += "<td colspan='3' class='tr bold'>NET AMOUNT:</td>";
                        htmls += "<td colspan='2' class='tr bold'>Rs." + ttlAmt + "</td>";
                        htmls += "</tr>";
                    }
                });
            }

            // ── IN WORDS (full, wraps naturally) ──────────────────
            htmls += "<tr>";
            htmls += "<td colspan='5' class='tl' style='word-break:break-word;white-space:normal;'>";
            htmls += "In Words: " + safe(inwords, '-');
            htmls += "</td></tr>";

            // ── PRINT TIME ─────────────────────────────────────────
            htmls += "<tr>";
            htmls += "<td colspan='5' class='tl' style='font-size:7px;'>";
            htmls += "Printed: " + (typeof formatAMPM === 'function' ? formatAMPM() : new Date().toLocaleString());
            htmls += "</td></tr>";

            // ── THANK YOU ──────────────────────────────────────────
            htmls += "<tr class='dash'>";
            htmls += "<td colspan='5' class='tc bold'>** Thank You **</td>";
            htmls += "</tr>";

            htmls += "<tr>";
            htmls += "<td colspan='5' class='tc' style='font-size:7px;'>Powered By Restro Order</td>";
            htmls += "</tr>";

            htmls += "</table>";

            // ── QR CODE ────────────────────────────────────────────
            htmls += "<div id='divqrcode' style='display:none;'></div>";
            htmls += "<div class='QRCode' style='text-align:center;margin-top:5px;'>";
            htmls += "<img src='' id='codeimg' style='height:60px;display:none;'>";
            htmls += "</div>";

            // ── RENDER ─────────────────────────────────────────────
            var qrString = "{Company:\"" + safe(companyInfo[0].Name) + "\", Bill No:" + safe(billBody[0].BillNo) + ", Date: " + nepaliDate + ", Time: " + time + ", Amount: " + safeFloat(ttlAmt).toFixed(2) + "}";
            $('#customer-bill').html(logoInfo + htmls);

            // ── QR CODE GENERATION ─────────────────────────────────
            if (typeof CodeQR !== 'undefined' && CodeQR === true) {
                $("#codeimg").show();
                try {
                    $('#divqrcode').qrcode(qrString);
                    var canvas = $('#divqrcode canvas');
                    if (canvas.length > 0) {
                        var img = canvas.get(0).toDataURL("image/png");
                        $('#codeimg').attr('src', img);
                    }
                } catch (e) {
                    console.warn("QR code generation failed:", e);
                }
            }

            // ── PRINT WARNING (copy count) ─────────────────────────
            if (safeFloat(billBody[0].PrintCount) >= 3) {
                $('#printno').show();
            }

            // ── DELIVERY CHARGE ROW (remove if zero) ───────────────
            try {
                var charge = safeFloat($("#DeliveryCharge").text().split(' ')[2]);
                if (charge <= 0) {
                    $('tr#DeliveryCharge').remove();
                }
            } catch (e) { /* ignore */ }

        },
        failure: function (response) {
            jAlert("Sorry, an error occurred. Contact the support team.", "Error!!", function () {
                $.alerts.dialogClass = null;
            });
        }
    });
}
