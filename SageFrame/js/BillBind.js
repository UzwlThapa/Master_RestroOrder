var totalItemsQntyVisible = true;
var ttlAmt = 0;
var CodeQR = JSON.parse(localStorage.getItem("QRCode"));
var netAmt = 0.00;
var IsNonTaxable = false;
let sn = 1;

// --- READABLE FONT SIZES (thermal printer optimized) ---
var billFontTitle = "14px";      // company name
var billFontHead = "11px";       // invoice type
var billFontMeta = "10px";       // customer, date, table, PAN
var billFontTblHead = "10px";    // column headers
var billFontItem = "10px";       // item rows
var billFontTotals = "10px";     // subtotal, discount, basic, VAT
var billFontNet = "12px";        // net amount (must stand out)
var billFontFooter = "9px";      // thank you, powered by
var billFontTiny = "9px";        // HS code, add-ons (was 8px)

// --- COLUMN STYLES (monospace enforced) ---
var billColQtyStyle = "text-align:center;font-size:" + billFontItem + ";font-family:monospace;";
var billColRateStyle = "text-align:right;font-size:" + billFontItem + ";font-family:monospace;";
var billColAmntStyle = "text-align:right;font-size:" + billFontItem + ";font-family:monospace;";

// --- COMPLETE PRINT CSS (injected into print window) ---
var billPrintStyles = "<style type='text/css'>"
    + "@media print{body{margin:0!important;padding:0!important;}}"
    + "@page{margin:2mm!important;}"
    + "table{table-layout:fixed!important;width:100%!important;font-family:monospace,'Courier New',monospace!important}"
    + "table td{line-height:1.4!important}"
    + "td.bill-col-qty{padding:0 6px 0 0!important;white-space:nowrap!important;text-align:center!important;font-size:" + billFontItem + "!important;font-family:monospace!important}"
    + "td.bill-col-rate{padding:0 8px 0 4px!important;white-space:nowrap!important;text-align:right!important;min-width:52px!important;font-size:" + billFontItem + "!important;font-family:monospace!important}"
    + "td.bill-col-amnt{padding:0 8px 0 6px!important;white-space:nowrap!important;text-align:right!important;min-width:56px!important;font-size:" + billFontItem + "!important;font-family:monospace!important}"
    + "</style>";

function formatBillMoney(value) {
    return parseFloat(value).toFixed(2);
}

function formatBillAmntCell(value) {
    return "\u00A0\u00A0" + formatBillMoney(value);
}

function applyBillPrintLayout() {
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
        "text-align": "right",
        "min-width": "58px"
    });
    $("#customer-bill table td.bill-col-amnt").css({
        "padding": "0 2px 0 8px",
        "white-space": "nowrap",
        "text-align": "right",
        "min-width": "62px"
    });
}

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
            // removed debugger
            var data = data.d;
            var splitCostCenter = data.splitCostCenter;
            var companyInfo = data.companyInfo;
            var billInfo = data.billInfo;
            var billBody = data.orderDetail;
            var terms = data.billingTerm;
            var costcenter = data.cuscenter;
            var costCenterGroup = data.costCenterGroup;
            var inwords = data.AmntInWord;
            var discount = data.discount;
            var costCenterDis = new Object;

            var isab = companyInfo[0].IsAbbreviated;
            var isAbbreviated = false;
            var billAmount = 0;

            //Check Abbrevieted Bill
            if (isab) {
                var v_rate = companyInfo[0].VATRate;

                isAbbreviated = true;

                if (billInfo.TotalAmount > companyInfo[0].AbbreviatedValue) {
                    isAbbreviated = false;
                    v_rate = 0.0;
                }

                $.each(terms, function (index, value) {
                    if (value.BillTerm == "NetAmount") {
                        billAmount = parseFloat(value.Amount).toFixed(2);
                    }
                });
            }

            $.each(billBody, function (index, item) {
                const group = costCenterGroup.filter(x => x.GroupId === item.GroupId)
                if (group.length > 0) {
                    const i = costCenterGroup.findIndex(x => x.GroupId === item.GroupId);
                    costCenterGroup[i].TotalAmt += item.IsTaxable ? parseFloat(item.Amount) : 0.00;
                    costCenterGroup[i].NonTaxableAmt += item.IsTaxable ? 0 : parseFloat(item.Amount);
                }
            });

            if (discount == null) {
                var disc = new Object();
                disc.isLoyalty = false;
                disc.isflatdis = false;
                disc.kotdis = 0.00;
                disc.bardis = 0.00;
                disc.roomdis = 0.00;
                disc.bakerydis = 0.00;
                disc.pizzadis = 0.00;

                discount = disc;

            } else {
                var Discount = [
                    {
                        GroupId: 1,
                        GroupName: 'KOT',
                        Discount: parseFloat(discount.kotdis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[0].NonTaxableAmt > 0 ? (costCenterGroup[0].NonTaxableAmt / (costCenterGroup[0].NonTaxableAmt + costCenterGroup[0].TotalAmt)) * parseFloat(discount.kotdis) : 0.00) : (costCenterGroup[0].NonTaxableAmt * (parseFloat(discount.kotdis) / 100)),
                        TaxDis: discount.isflatdis ? (costCenterGroup[0].TotalAmt > 0 ? (costCenterGroup[0].TotalAmt / (costCenterGroup[0].NonTaxableAmt + costCenterGroup[0].TotalAmt)) * parseFloat(discount.kotdis) : 0.00) : (costCenterGroup[0].TotalAmt * (parseFloat(discount.kotdis) / 100)),
                        TotalAmount: costCenterGroup[0].TotalAmt,
                        NonTaxableAmt: costCenterGroup[0].NonTaxableAmt
                    },
                    {
                        GroupId: 2,
                        GroupName: 'BAR',
                        Discount: parseFloat(discount.bardis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[1].NonTaxableAmt > 0 ? (costCenterGroup[1].NonTaxableAmt / (costCenterGroup[1].NonTaxableAmt + costCenterGroup[1].TotalAmt)) * parseFloat(discount.bardis) : 0.00) : (costCenterGroup[1].NonTaxableAmt * (parseFloat(discount.bardis) / 100)),
                        TaxDis: discount.isflatdis ? (costCenterGroup[1].TotalAmt > 0 ? (costCenterGroup[1].TotalAmt / (costCenterGroup[1].NonTaxableAmt + costCenterGroup[1].TotalAmt)) * parseFloat(discount.bardis) : 0.00) : (costCenterGroup[1].TotalAmt * (parseFloat(discount.bardis) / 100)),
                        TotalAmount: costCenterGroup[1].TotalAmt,
                        NonTaxableAmt: costCenterGroup[1].NonTaxableAmt
                    },
                    {
                        GroupId: 3,
                        GroupName: 'Bakery',
                        Discount: parseFloat(discount.bakerydis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[2].NonTaxableAmt > 0 ? (costCenterGroup[2].NonTaxableAmt / (costCenterGroup[2].NonTaxableAmt + costCenterGroup[2].TotalAmt)) * parseFloat(discount.bakerydis) : 0.00) : (costCenterGroup[2].NonTaxableAmt * (parseFloat(discount.bakerydis) / 100)),
                        TaxDis: discount.isflatdis ? (costCenterGroup[2].TotalAmt > 0 ? (costCenterGroup[2].TotalAmt / (costCenterGroup[2].NonTaxableAmt + costCenterGroup[2].TotalAmt)) * parseFloat(discount.bakerydis) : 0.00) : (costCenterGroup[2].TotalAmt * (parseFloat(discount.bakerydis) / 100)),
                        TotalAmount: costCenterGroup[2].TotalAmt,
                        NonTaxableAmt: costCenterGroup[2].NonTaxableAmt
                    },
                    {
                        GroupId: 4,
                        GroupName: 'Trading',
                        Discount: parseFloat(discount.tradingDis),
                        NonTaxDis: discount.isflatdis ? (costCenterGroup[3].NonTaxableAmt > 0 ? (costCenterGroup[3].NonTaxableAmt / (costCenterGroup[3].NonTaxableAmt + costCenterGroup[3].TotalAmt)) * parseFloat(discount.tradingDis) : 0.00) : (costCenterGroup[3].NonTaxableAmt * (parseFloat(discount.tradingDis) / 100)),
                        TaxDis: discount.isflatdis ? (costCenterGroup[3].TotalAmt > 0 ? (costCenterGroup[3].TotalAmt / (costCenterGroup[3].NonTaxableAmt + costCenterGroup[3].TotalAmt)) * parseFloat(discount.tradingDis) : 0.00) : (costCenterGroup[3].TotalAmt * (parseFloat(discount.tradingDis) / 100)),
                        TotalAmount: costCenterGroup[3].TotalAmt,
                        NonTaxableAmt: costCenterGroup[3].NonTaxableAmt
                    },
                ];
                costCenterDis.RoomDis = parseFloat(discount.roomdis);
                costCenterDis.RoomRate = billBody[0].RoomRate;
                costCenterDis.RoomCharge = billBody[0].RoomCharge;
                costCenterDis.isLoyalty = discount.isLoyalty;
                costCenterDis.isFlatDis = discount.isflatdis;
                costCenterDis.LoaylityDis = parseFloat(discount.loyaltydis);
                costCenterDis.GroupDis = Discount;
            }

            $('#customer-bill').html("");
            var comphtmls = "";
            comphtmls += "<input type='hidden' value='" + salesMasterId + "' id='hdfSMID' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].PrintCount + "' id='hdfPrntCnt' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].CusID + "' id='hdfCusID' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].CusName + "' id='hdfCusName' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].Address + "' id='hdfAddress' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].PAN + "' id='hdfPAN' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].BasicAmount + "' id='hdfBasicAmount' />";
            comphtmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;border-collapse:collapse;table-layout:fixed;font-family:monospace;'>");
            // --- DYNAMIC COLGROUP (fixes splitCostCenter column mismatch) ---
            if (splitCostCenter) {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:6%'/><col style='width:26%'/><col style='width:6%'/><col style='width:14%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/></colgroup>";
            } else {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:7%'/><col style='width:38%'/><col style='width:8%'/><col style='width:20%'/><col style='width:23%'/></colgroup>";
            }
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontTitle + ";text-align:center;font-weight:bold;'>" + companyInfo[0].Name + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + companyInfo[0].Address + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + companyInfo[0].PhoneNo + "</td></tr>");
            if (billInfo.IsArchived) {
                comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'><b>Credit Note</b></td></tr>");
            } else if (billInfo.IsCancelled) {
                comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'><b>Credit Note</b></td></tr>");
            }
            else {
                if (isab) {
                    if (isAbbreviated) {
                        comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>ABBREVIATED TAX INVOICE</b></td></tr>");
                    }
                    else {
                        comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");

                    }
                }
                else {
                    comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
                }
            }

            // FIX: this <tr> must always be closed. The original left it open
            // whenever PrintCount was 1 (no copy) or the bill was cancelled/archived.
            comphtmls += ("<tr><td colspan='3' style='font-size:" + billFontMeta + ";text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>");
            if (billBody[0].PrintCount - 1 != 0 && !billInfo.IsCancelled && !billInfo.IsArchived) {
                comphtmls += ("<td colspan='3' style='font-size:" + billFontMeta + ";text-align:left;'><span>Copy of Original:" + (billBody[0].PrintCount - 1) + "</span></td></tr>");
            } else {
                comphtmls += ("<td colspan='3'></td></tr>");
            }

            var logoInfo = comphtmls;

            var htmls = "";
            htmls += "<tr style='border-top:1px dotted;'>";

            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>C/N No : " + billInfo.CreditNoteNumber + "</td></tr>";
                htmls += "<tr><td colspan='1' style='text-align:left;font-size:" + billFontMeta + ";'>Date : " + billInfo.CreditNoteDate + "</td></tr>";
                htmls += "<tr>";
            }

            // --- META ROWS: improved colspan distribution (4+2) ---
            htmls += "<td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Customer : " + (billBody[0].CusName == "" ? "" : billBody[0].CusName);
            htmls += ("</td>");
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>PAN : " + billBody[0].PAN + "</td></tr>";
            if (!foodCourtOrder) {
                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Phone No. : " + billBody[0].PhoneNumber + "</td>";
                htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Cashier : " + billBody[0].Cashier + "</td></tr>";
            }
            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<tr><td colspan='3' style='text-align:left;font-size:" + billFontMeta + ";'>Ref Inv No : " + billInfo.InvoiceNo + "(" + billInfo.InvoiceDate + ")</td></tr>";
                htmls += "<tr><td colspan='3' style='text-align:left !important;font-size:" + billFontMeta + ";'>C/N Remarks : " + billInfo.CreditNoteReason + "</td></tr>";
                if (!foodCourtOrder) {
                    htmls += "<tr><td colspan='3' style='text-align:left;font-size:" + billFontMeta + ";'>Table : " + billBody[0].restrotableTitle + "</td></tr>";
                } else {
                    htmls += '<tr><td colspan="3" style="text-align:left !important;font-size:' + billFontMeta + ';">Cashier : ' + billBody[0].Cashier + '</td></tr>';
                }
            } else {
                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Address : " + billBody[0].Address + "</td>";
                var date = billBody[0].Date.split(" ");
                var time = date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + date[2];
                htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>INV No : " + billBody[0].BillNo + "</td>";

                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Date(B.S.) : " + billBody[0].NepaliInvoiceDate.split('.').join('/') + "</td>";
                if (!foodCourtOrder) {
                    htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Table : " + billBody[0].restrotableTitle + "</td>";
                } else {
                    htmls += '<td colspan="2" style="text-align:left;font-size:' + billFontMeta + ';">Cashier : ' + billBody[0].Cashier + '</td>';
                }
                htmls += "</tr>";

                var dateSegment = billBody[0].Date.split(' ');
                var timeSegment = dateSegment[1].split(':');
                var time = `${timeSegment[0]}:${timeSegment[1]}`;
                var timezone = dateSegment[2] ? dateSegment[2] : "";
                var fullDate = dateSegment[0].split('/');
                var formattedDate = `${fullDate[2]}/${fullDate[1]}/${fullDate[0]}`;

                htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Date(A.D.) : " + formattedDate + "</td><td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Time : " + time + timezone + "</td>";
                htmls += "</tr>";
            }

            // --- HEADER ROW (uses billFontTblHead) ---
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
            kotAmount = 0.00;
            bevAmount = 0.00;
            roomAmount = 0.00;
            bakeryAmount = 0.00;
            pizzaAmount = 0.00;
            itemsQnty = 0.00;

            var BasicAmt = 0.00;
            sn = 1;

            $.each(billBody, function (index, item) {
                var rateN = item.Rate;
                // --- ITEM ROW: no fixed height, item name truncated ---
                htmls += ("<tr class='orderedInfo'>");
                htmls += ("<td style='text-align:left;font-size:" + billFontItem + ";'>" + sn + "</td>");
                htmls += ("<td style='text-align:left;font-size:" + billFontTiny + ";'>" + (item.HsCode ? item.HsCode : "") + "</td>");
                htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:" + billFontItem + ";overflow:hidden;white-space:nowrap;text-overflow:ellipsis;max-width:0;'>" + item.ITName.split('_')[0] + "</td>");
                htmls += ("<td class='bill-col-qty' style='" + billColQtyStyle + "'>" + item.Quantity + "</td>");
                itemsQnty += item.Quantity;
                sn++;
                if (isab) {
                    if (isAbbreviated) {
                        if (!costCenterDis.isFlatDis) {
                            $.each(costCenterDis.GroupDis, function (index, value) {
                                if (value.GroupId == item.GroupId && value.Discount > 0) {
                                    rateN = parseFloat((rateN * (100 - value.Discount) / 100));
                                    return false;
                                }
                            })
                        } else if (costCenterDis.isLoyalty) {
                            $.each(costCenterDis.GroupDis, function (index, value) {
                                if (value.GroupId == item.GroupId && costCenterDis.LoaylityDis > 0) {
                                    rateN = parseFloat((rateN * (100 - costCenterDis.LoaylityDis) / 100));
                                    return false;
                                }
                            })
                        } else if (costCenterDis.isFlatDis) {
                            $.each(costCenterDis.GroupDis, function (index, value) {

                                if (value.GroupId == item.GroupId && value.Discount > 0) {

                                    var ttldis = parseFloat(value.Discount == "" ? 0 : value.Discount);
                                    var ttl = costCenterGroup.find(x => x.GroupId == value.GroupId).TotalAmt;
                                    var disPercent = 0.00;
                                    if (ttldis > 0) {
                                        disPercent = (ttldis * 100) / ttl;
                                        rateN = parseFloat((rateN * (100 - disPercent) / 100));
                                    }
                                    return false;
                                }
                            })
                        }

                        //Item Rate Including VAT without Discount
                        htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(rateN * (1 + companyInfo[0].VATRate / 100.0)) + "</td>");

                        if (splitCostCenter) {
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Amount * (1 + companyInfo[0].VATRate / 100.0)) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bevrage * (1 + companyInfo[0].VATRate / 100.0)) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bakery * (1 + companyInfo[0].VATRate / 100.0)) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Pizza * (1 + companyInfo[0].VATRate / 100.0)) + "</td>");
                        }
                        else {
                            //Item Rate Including VAT without Discount
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell((rateN * item.Quantity) * (1 + companyInfo[0].VATRate / 100.0)) + "</td>");
                        }
                    }
                    else {
                        htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(rateN) + "</td>");
                        if (splitCostCenter) {
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Amount) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bevrage) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bakery) + "</td>");
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Pizza) + "</td>");
                        }
                        else {
                            htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(rateN * item.Quantity) + "</td>");
                        }
                    }
                }
                else {
                    htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(rateN) + "</td>");
                    if (splitCostCenter) {
                        htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Amount) + "</td>");
                        htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bevrage) + "</td>");
                        htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Bakery) + "</td>");
                        htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Pizza) + "</td>");
                    }
                    else {
                        htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(rateN * item.Quantity) + "</td>");
                    }
                }
                htmls += ("</tr>");

                //Bishal Added
                kotAmount += (item.Amount);
                bevAmount += (item.Bevrage);
                bakeryAmount += (item.Bakery);
                pizzaAmount += (item.Pizza);

                if (item.orderExtraItem.length > 0) {
                    rate = 0.00;
                    htmls += ("<tr class='orderedInfo'>"); // removed fixed height
                    htmls += ("<td colspan=" + (splitCostCenter ? 3 : 3) + " style='font-size:" + billFontTiny + ";font-style:italic;'>");
                    $.each(item.orderExtraItem, function (index, ext) {
                        htmls += ext.ExtraItem + "(" + ext.Quantity + ", Rs." + (ext.ExtraPrice) + "); ";
                        rate += (ext.Quantity * ext.ExtraPrice);
                    });
                    htmls += ("</td>");
                    if (splitCostCenter) {
                        htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Amount > 0 ? rate : 0) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Bevrage > 0 ? rate : 0) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Bakery > 0 ? rate : 0) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + (item.Pizza > 0 ? rate : 0) + "</td>");
                    }
                    else {
                        htmls += ("<td style='text-align:right;font-size:" + billFontTiny + ";font-style:italic;'>" + rate + "</td>");
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
                        BasicAmt += (rateN * item.Quantity) * (1 + companyInfo[0].VATRate / 100.0);
                    } else {
                        BasicAmt += rateN * item.Quantity;
                    }
                } else {

                    BasicAmt += rateN * item.Quantity;
                }
            });
            kotdis = 0.00;
            bevdis = 0.00;
            roomdis = 0.00;
            totaldis = 0.00;
            bakerydis = 0.00;
            pizzadis = 0.00;
            var discType = "";
            if (discount.isflatdis == false) {
                kotdis = (kotAmount * (parseFloat(discount.kotdis) / 100)).toFixed(2);
                bevdis = (bevAmount * (parseFloat(discount.bardis) / 100)).toFixed(2);
                roomdis = (billBody[0].RoomCharge * (parseFloat(discount.roomdis) / 100)).toFixed(2);
                bakerydis = (bakeryAmount * (parseFloat(discount.bakerydis) / 100)).toFixed(2);
                pizzadis = (pizzaAmount * (parseFloat(discount.pizzadis) / 100)).toFixed(2);
                discType = "%";
            }
            else {
                kotdis = parseFloat(discount.kotdis).toFixed(2);
                bevdis = parseFloat(discount.bardis).toFixed(2);
                roomdis = parseFloat(discount.roomdis).toFixed(2);
                bakerydis = parseFloat(discount.bakerydis).toFixed(2);
                pizzadis = parseFloat(discount.pizzadis).toFixed(2);
            }
            if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && !splitCostCenter) {
                // FIX: this block emitted a <td> with no opening <tr> — added below.
                htmls += ("<tr>");
                var roomRateN = costCenterDis.RoomRate;

                if (isab) {
                    if (isAbbreviated) {
                        if (!costCenterDis.isFlatDis) {
                            roomRateN = parseFloat((roomRateN * (100 - costCenterDis.RoomDis) / 100));
                        } else if (costCenterDis.isLoyalty) {
                            roomRateN = parseFloat((roomRateN * (100 - costCenterDis.LoaylityDis) / 100));
                        } else if (costCenterDis.isFlatDis) {
                            var ttldis = costCenterDis.RoomDis;
                            var ttl = costCenterDis.RoomCharge;
                            var disPercent = 0.00;
                            if (ttldis > 0) {
                                disPercent = (ttldis * 100) / ttl;
                                roomRateN = parseFloat((roomRateN * (100 - disPercent) / 100));
                            }
                        }
                        roomRateN = roomRateN * (1 + companyInfo[0].VATRate / 100.0);
                        htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + (roomRateN).toFixed(2) + "/Day): Rs." + (roomRateN * billBody[0].BookedDays).toFixed(2) + " (" + billBody[0].BookedDays + " Days)</td>");
                        roomAmount = (roomRateN * billBody[0].BookedDays);
                    } else {
                        htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                        roomAmount = billBody[0].RoomCharge;
                    }
                } else {
                    htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                    roomAmount = billBody[0].RoomCharge;
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
            }
            else {
                // FIX: restructured so the <td> pair always closes correctly
                // regardless of totalItemsQntyVisible (previously left a <td> open
                // when that flag was false).
                htmls += ("<td colspan='4' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";border-top:1px dotted;padding-right:8px;'>");
                if (totalItemsQntyVisible) {
                    htmls += ("<span style='font-weight:bold;font-size:" + billFontTotals + ";'>Total Qty: " + itemsQnty + " </span>");
                }
                htmls += ("</td><td colspan='2' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";border-top:1px dotted;padding-right:8px;'>");

                //Item Rate Including VAT without Discount
                htmls += ("<span style='font-weight:bold;font-size:" + billFontTotals + ";'>Sub Total : </span>Rs." + (BasicAmt + roomAmount).toFixed(2) + "</td>");
            }
            htmls += ("</tr>");

            if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && discount.isLoyalty && splitCostCenter) {
                htmls += ("<tr><td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = billBody[0].RoomCharge;
            }

            if (billBody[0].totaldiscount > 0) {
                htmls += ("<tr  class='orderedInfo'>");
                if (splitCostCenter) {
                    htmls += ("<td colspan='3' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Disc(KOT : " + discount.kotdis + discType + ", Bar : " + discount.bardis + discType + ", Bakery : " + discount.bakerydis + discType + ", Pizza : " + discount.pizzadis + discType + ")</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(kotdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(pizzadis).toFixed(2) + "</td></tr>");
                    htmls += ("<tr><td colspan='3' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>After Disc. Amnt</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(kotAmount - kotdis).toFixed(2)) + "</td>";
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bevAmount - bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bakeryAmount - bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(pizzaAmount - pizzadis).toFixed(2) + "</td>");
                }
                else {
                    if (costCenterDis.GroupDis.length > 0) {
                        if (costCenterDis.isLoyalty) {
                            htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Loyality Disc (" + costCenterDis.LoaylityDis + "%): </span>Rs." + parseFloat(billBody[0].totaldiscount).toFixed(2) + "</td></tr>");
                        } else {
                            // removed debugger
                            var showTotalDiscount = localStorage.getItem('ShowTotalDiscount') ?? 'false';
                            if (showTotalDiscount == 'true') {
                                var totalDisc = 0;
                                $.each(costCenterDis.GroupDis, function (index, value) {
                                    if (value.Discount > 0) {
                                        if (costCenterDis.isFlatDis) {
                                            totalDisc += parseFloat(value.Discount);

                                        } else {
                                            totalDisc += parseFloat((value.Discount / 100) * (value.TotalAmount + value.NonTaxableAmt));
                                        }
                                    }
                                });
                                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Total Disc: </span>Rs." + parseFloat(totalDisc).toFixed(2) + "</td></tr>");
                            }
                            else {
                                $.each(costCenterDis.GroupDis, function (index, value) {
                                    if (value.Discount > 0) {
                                        if (costCenterDis.isFlatDis) {
                                            htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>" + value.GroupName + " Disc: </span>Rs." + parseFloat(value.Discount).toFixed(2) + "</td></tr>");

                                        } else {
                                            htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>" + value.GroupName + " Disc (" + value.Discount + " %) : </span>Rs." + parseFloat((value.Discount / 100) * (value.TotalAmount + value.NonTaxableAmt)).toFixed(2) + "</td></tr>");
                                        }
                                    }
                                });
                                if (costCenterDis.RoomDis > 0) {

                                    if (costCenterDis.isFlatDis) {
                                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Room Disc: </span>Rs." + parseFloat(costCenterDis.RoomDis).toFixed(2) + "</td></tr>");

                                    } else {
                                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Room Disc (" + costCenterDis.RoomDis + " %) : </span>Rs." + parseFloat((costCenterDis.RoomDis / 100) * costCenterDis.RoomCharge).toFixed(2) + "</td></tr>");
                                    }
                                }
                            }
                        }
                        if (isab) {
                            if (isAbbreviated) {
                                htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;font-style'><em>(Discount has already been deducted in above mentioned item rate)</em></td></tr>");
                            }
                        }
                    }
                }
                htmls += ("</tr>");
            }

            totaldis = (billBody[0].totaldiscount).toFixed(2);

            if (!isab) {
                htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
                htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + (parseFloat(kotAmount) + parseFloat(bevAmount) + parseFloat(roomAmount) + parseFloat(bakeryAmount) + parseFloat(pizzaAmount) - parseFloat(totaldis)).toFixed(2));
                htmls += ("</td>");
                htmls += ("</tr>");
            }
            else {
                if (!isAbbreviated) {
                    htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
                    htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + (parseFloat(kotAmount) + parseFloat(bevAmount) + parseFloat(roomAmount) + parseFloat(bakeryAmount) + parseFloat(pizzaAmount) - parseFloat(totaldis)).toFixed(2));
                    htmls += ("</td>");
                    htmls += ("</tr>");
                }
            }
            var basicamount = (parseFloat(kotAmount) + parseFloat(bevAmount) + parseFloat(roomAmount) + parseFloat(bakeryAmount) + parseFloat(pizzaAmount) - parseFloat(totaldis)).toFixed(2);

            var NonTaxableTotalAmt = 0.00;
            var TaxableTotalAmt = 0.00;
            var NonTaxableDis = 0.00;
            var TaxableDis = 0.00;

            $.each(costCenterDis.GroupDis, function (index, value) {
                NonTaxableTotalAmt += value.NonTaxableAmt;
                TaxableTotalAmt += value.TotalAmount;
                NonTaxableDis += value.NonTaxDis;
                TaxableDis += value.TaxDis;
            });

            if (terms.length > 0) {
                var servicecharge = 0;
                $.each(terms, function (index, value) {
                    if (value.BillTerm.toLowerCase() == "service charge") {
                        servicecharge = parseFloat(value.Amount).toFixed(2);
                    }
                    if (!isab) {

                        if (value.BillTerm.toLowerCase() == "vat") {
                            if (IsNonTaxable) {
                                htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                                htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>Non Taxable Amount : </span>");
                                htmls += ("<span>Rs. " + (NonTaxableTotalAmt - NonTaxableDis).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");
                            }
                            htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                            htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>Taxable Amount : </span>");
                            if (IsNonTaxable)
                                htmls += ("<span>Rs. " + (TaxableTotalAmt - TaxableDis).toFixed(2) + "</span></td>");
                            else
                                htmls += ("<span>Rs. " + parseFloat(terms[terms.length - 1].Amount - terms[terms.length - 2].Amount - value.Amount).toFixed(2) + "</span></td>");
                            htmls += ("</tr>");
                        }
                        htmls += ("<tr id='" + value.BillTerm + "' style='font-size:" + billFontTotals + ";text-align:right;'>");
                        if (value.Rate > 0) {
                            htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                            htmls += ("(" + value.Rate + "%" + ") : </span>");
                        }
                        else {
                            htmls += ("<td  colspan='6'  style='text-align:right;padding-right:8px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:" + billFontNet + ";" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
                        }
                        htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                        htmls += ("</tr>");
                    }
                    else {
                        if (!isAbbreviated) {
                            if (value.BillTerm.toLowerCase() == "vat") {
                                htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                                htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>Taxable Amount : </span>");
                                htmls += ("<span>Rs. " + parseFloat(parseFloat(basicamount) + parseFloat(servicecharge)).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");

                                htmls += ("<tr id='" + value.BillTerm + "' style='font-size:" + billFontTotals + ";text-align:right;'>");
                                if (value.Rate > 0) {
                                    if (value.BillTerm.toLowerCase() == "home delivery") {
                                        htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                                        htmls += (" : </span>");
                                    } else {
                                        htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                                        htmls += ("(" + value.Rate + "%" + ") : </span>");
                                    }

                                    htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                                    htmls += ("</tr>");
                                }
                            }
                        } else {

                            if (value.BillTerm.toLowerCase() == "deliverycharge" && value.Amount > 0) {
                                htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                                htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                                htmls += (" : </span>");
                                htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");
                            }
                        }
                    }

                    if (isab) {
                        if (value.BillTerm.toLowerCase() == "netamount") {
                            htmls += ("<td  colspan='6'  style='text-align:right;padding-right:8px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:" + billFontNet + ";" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
                            htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                        }
                    }
                    htmls += ("</tr>");

                    if (value.BillTerm == "NetAmount") {
                        ttlAmt = parseFloat(value.Amount).toFixed(2);
                    }
                });
            }

            if (!billBody[0].IsTable && billBody[0].BookedDays > 0) {
                htmls += ("<tr>");
                htmls += ("<td colspan='6'  style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Adv. Payment : </span><span>(Rs. " + billBody[0].AdvancePayment.toFixed(2) + ")</span></td>");
                htmls += ("</tr>");
                htmls += ("<tr>");
                htmls += ("<td colspan='6'  style='font-weight:bold;text-align:right;font-size:" + billFontNet + ";padding-right:8px;'><span>Rem. Amount : </span><span>Rs. " + billBody[0].BasicAmount.toFixed(2) + "</span></td>");
                htmls += ("</tr>");
            }

            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            // --- In Words with word-break ---
            htmls += ("<td colspan=6 style='text-align:left;font-size:" + billFontMeta + ";word-break:break-word;white-space:normal;'> In Words : " + inwords + "</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:left;border-bottom:1px dotted;font-size:" + billFontMeta + ";'>" + "PrintedOn: <span  id='divPrintedOn'>" + formatAMPM() + "</span></td>");
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
            var string = "{Company:\"" + companyInfo[0].Name + "\", Bill No:" + billBody[0].BillNo + ", Date: " + billBody[0].NepaliInvoiceDate.split('.').join('/') + ", Time: " + time + ", Amount: " + parseFloat(ttlAmt).toFixed(2) + "}";
            body = htmls;
            $('#customer-bill').html(logoInfo + body);
            if (CodeQR == true) {
                $("#codeimg").show();
                $('#divqrcode').qrcode(string);
                var canvas = $('#divqrcode canvas');
                var img = canvas.get(0).toDataURL("image/png");
                $('#codeimg').attr('src', img);
            }

            if (billBody[0].PrintCount >= 3) {
                $('#printno').show();
            }
            applyBillPrintLayout();
            $("#NetAmount_text").text("Net Amount :");
            var charge = $("#DeliveryCharge").text().split(' ')[2];
            if (parseFloat(charge) <= 0) {
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

// --- CAKE BILL FUNCTION (same fixes applied) ---
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
            var inwords = data.AmntInWord;
            var discount = data.discount;

            $('#customer-bill').html("");
            //Company logo
            var comphtmls = "";
            comphtmls += "<input type='hidden' value='" + SalesMasterID + "' id='hdfSMID' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].PrintCount + "' id='hdfPrntCnt' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].CusID + "' id='hdfCusID' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].CusName + "' id='hdfCusName' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].Address + "' id='hdfAddress' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].PAN + "' id='hdfPAN' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].BasicAmount + "' id='hdfBasicAmount' />";
            comphtmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;border-collapse:collapse;table-layout:fixed;font-family:monospace;'>");
            // --- DYNAMIC COLGROUP (same as main) ---
            if (splitCostCenter) {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:6%'/><col style='width:26%'/><col style='width:6%'/><col style='width:14%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/><col style='width:11%'/></colgroup>";
            } else {
                comphtmls += "<colgroup><col style='width:4%'/><col style='width:7%'/><col style='width:38%'/><col style='width:8%'/><col style='width:20%'/><col style='width:23%'/></colgroup>";
            }
            comphtmls += (" <tr><td colspan='6' style='text-align:center;'><img src='/Modules/ROCompanyInfo/logo/" + companyInfo[0].Logo + "' style='width:70px;'/></td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontTitle + ";text-align:center;font-weight:bold;'>" + companyInfo[0].Name + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + companyInfo[0].Address + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:10px;text-align:center;'>" + companyInfo[0].PhoneNo + "</td></tr>");
            comphtmls += ("<tr><td colspan='6' style='font-size:" + billFontHead + ";text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
            comphtmls += ("<tr><td colspan='1' style='font-size:" + billFontMeta + ";text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>");

            var logoInfo = comphtmls;
            var htmls = "";
            htmls += "<tr style='border-top:1px dotted;'>";
            // --- META ROWS: 4+2 ---
            htmls += "<td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Customer : " + (billBody[0].CusName == "" ? "" : billBody[0].CusName);
            htmls += ("</td>");
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>PAN : " + billBody[0].PAN + "</td></tr>";
            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>INV No : " + billBody[0].BillNo + "</td>";

            var date = billBody[0].Date.split(" ");
            var time = date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + date[2];
            htmls += "<td colspan='2' style='text-align:left;font-size:" + billFontMeta + ";'>Time : " + time + "</td>";
            htmls += "<tr><td colspan='4' style='text-align:left;font-size:" + billFontMeta + ";'>Date : " + billBody[0].NepaliInvoiceDate.split('.').join('/') + "</td>";
            htmls += '<td colspan="2" style="text-align:left;font-size:' + billFontMeta + ';">Cashier : ' + billBody[0].Cashier + '</td>';
            htmls += "</tr>";
            // --- HEADER ROW ---
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
            }
            else {
                htmls += ("<td class='bill-col-amnt' style='font-size:" + billFontTblHead + ";font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;'>Amnt</td>");
            }
            htmls += ("</tr>");

            var count = 1;
            kotAmount = 0.00;
            bevAmount = 0.00;
            roomAmount = 0.00;
            bakeryAmount = 0.00;
            pizzaAmount = 0.00;
            itemsQnty = 0.00;
            var cakeTotalAmount = 0.00;
            sn = 1;
            //for bill body
            $.each(billBody, function (index, item) {
                // --- ITEM ROW: no fixed height, truncated name ---
                htmls += ("<tr class='orderedInfo'>");
                htmls += ("<td style='width: 2%;text-align:left;font-size:" + billFontItem + ";'>" + sn + "</td>");
                htmls += ("<td style='width: 2%;text-align:left;font-size:" + billFontTiny + ";'>" + item.HsCode + "</td>");
                htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:" + billFontItem + ";overflow:hidden;white-space:nowrap;text-overflow:ellipsis;max-width:0;'>" + item.ITName + "</td>");
                htmls += ("<td class='bill-col-qty' style='" + billColQtyStyle + "'>" + item.Quantity + "</td>");
                itemsQnty += item.Quantity;
                htmls += ("<td class='bill-col-rate' style='" + billColRateStyle + "'>" + formatBillMoney(item.Rate) + "</td>");
                htmls += ("<td class='bill-col-amnt' style='" + billColAmntStyle + "'>" + formatBillAmntCell(item.Rate * item.Quantity) + "</td>");
                cakeTotalAmount += (item.Rate * item.Quantity);
                sn++;
                htmls += ("</tr>");
            });

            //bill body close
            kotdis = 0.00;
            bevdis = 0.00;
            roomdis = 0.00;
            totaldis = 0.00;
            bakerydis = 0.00;
            pizzadis = 0.00;
            var discType = "";
            if (discount.isflatdis == false) {
                kotdis = (kotAmount * (parseFloat(discount.kotdis) / 100)).toFixed(2);
                bevdis = (bevAmount * (parseFloat(discount.bardis) / 100)).toFixed(2);
                roomdis = (billBody[0].RoomCharge * (parseFloat(discount.roomdis) / 100)).toFixed(2);
                bakerydis = (bakeryAmount * (parseFloat(discount.bakerydis) / 100)).toFixed(2);
                pizzadis = (pizzaAmount * (parseFloat(discount.pizzadis) / 100)).toFixed(2);
                discType = "%";
            }
            else {
                kotdis = parseFloat(discount.kotdis).toFixed(2);
                bevdis = parseFloat(discount.bardis).toFixed(2);
                roomdis = parseFloat(discount.roomdis).toFixed(2);
                bakerydis = parseFloat(discount.bakerydis).toFixed(2);
                pizzadis = parseFloat(discount.pizzadis).toFixed(2);
            }
            if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && !splitCostCenter) {
                // FIX: this block emitted a <td> with no opening <tr> — added below.
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = billBody[0].RoomCharge;
            }
            htmls += "<tr class='" + (splitCostCenter ? "orderedInfo" : "") + "'>";
            htmls += ("<td colspan='6' style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'><span style='font-weight:bold;font-size:" + billFontTotals + ";'>");
            htmls += ("Sub Total : </span>Rs." + cakeTotalAmount.toFixed(2) + "</td>");
            htmls += ("</tr>");
            if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && discount.isLoyalty && splitCostCenter) {
                htmls += ("<tr><td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = billBody[0].RoomCharge;
            }
            if (discount.cakedis != "") {
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Discount: ");
                htmls += ("Rs." + parseFloat(discount.cakedis));
                htmls += ("</td>");
                htmls += ("</tr>");
            }

            if (discount.isLoyalty) {
                htmls += ("<tr>");
                htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Loyalty Discount (" + discount.loyaltydis + " %) : ");
                htmls += ("Rs." + parseFloat((kotAmount + bevAmount + bakeryAmount + pizzaAmount + roomAmount) * (parseFloat(discount.loyaltydis) / 100)).toFixed(2))
                htmls += ("</td>");
                totaldis = parseFloat((kotAmount + bevAmount + bakeryAmount + pizzaAmount + roomAmount) * (parseFloat(discount.loyaltydis) / 100)).toFixed(2);
                htmls += ("</tr>");
            }
            else {
                htmls += ("<tr  class='orderedInfo'>");
                if (splitCostCenter) {
                    htmls += ("<td colspan='3' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Disc(KOT : " + discount.kotdis + discType + ", Bar : " + discount.bardis + discType + ", Bakery : " + discount.bakerydis + discType + ", Pizza : " + discount.pizzadis + discType + ")</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(kotdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(pizzadis).toFixed(2) + "</td></tr>");
                    htmls += ("<tr><td colspan='3' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>After Disc. Amnt</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(kotAmount - kotdis).toFixed(2)) + "</td>";
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bevAmount - bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(bakeryAmount - bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Rs." + parseFloat(pizzaAmount - pizzadis).toFixed(2) + "</td>");
                }
                else {
                    if (kotdis > 0) {
                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>KOT Disc (" + discount.kotdis + discType + ") : </span>Rs." + parseFloat(kotdis).toFixed(2) + "</td></tr>");
                    }
                    htmls += ("<tr class='orderedInfo'>");
                    if (bevdis > 0) {
                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Bar Disc (" + discount.bardis + discType + ") : </span>Rs." + parseFloat(bevdis).toFixed(2) + "</td>");
                    }
                    htmls += ("<tr class='orderedInfo'>");
                    if (bakerydis > 0) {
                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Bakery Disc (" + discount.bakerydis + discType + ") : </span>Rs." + parseFloat(bakerydis).toFixed(2) + "</td>");
                    }
                    htmls += ("<tr class='orderedInfo'>");
                    if (pizzadis > 0) {
                        htmls += ("<td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'><span>Pizza Disc (" + discount.pizzadis + discType + ") : </span>Rs." + parseFloat(pizzadis).toFixed(2) + "</td>");
                    }
                }
                htmls += ("</tr>");
                if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && !discount.isLoyalty && splitCostCenter) {
                    htmls += ("<tr><td colspan='6' style='text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                    htmls += ("</tr>");
                    roomAmount = billBody[0].RoomCharge;
                }
                if (!billBody[0].IsTable && billBody[0].BookedDays > 0) {
                    htmls += ("<tr>");
                    htmls += ("<td colspan='6' style='text-align:right;border-top:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>Room Disc. : Rs." + parseFloat(roomdis).toFixed(2) + "</td>");
                    htmls += ("</tr>");
                }
                totaldis = (parseFloat(kotdis) + parseFloat(bevdis) + parseFloat(roomdis) + parseFloat(bakerydis) + parseFloat(pizzadis)).toFixed(2);
            }

            htmls += ("<tr style='border-top:1px solid;'><td colspan='6' style='font-weight:bold;text-align:right;font-size:" + billFontTotals + ";padding-right:8px;'>");
            htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + parseFloat(cakeTotalAmount - discount.cakedis).toFixed(2));
            htmls += ("</td>");
            htmls += ("</tr>");

            if (terms.length > 0) {
                $.each(terms, function (index, value) {

                    if (value.BillTerm.toLowerCase() == "vat") {
                        htmls += ("<tr style='font-size:" + billFontTotals + ";text-align:right;'>");
                        htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>Taxable Amount : </span>");
                        htmls += ("<span>Rs. " + parseFloat(cakeTotalAmount - discount.cakedis).toFixed(2) + "</span></td>");
                        htmls += ("</tr>");
                        cakeTotalAmount = parseFloat(cakeTotalAmount - discount.cakedis).toFixed(2);
                    }
                    htmls += ("<tr id='" + value.BillTerm + "' style='font-size:" + billFontTotals + ";text-align:right;'>");
                    if (value.Rate > 0) {
                        htmls += ("<td  colspan='6' style='text-align:right;padding-right:8px;'><span>" + value.BillTerm);
                        htmls += ("(" + value.Rate + "%" + ") : </span>");
                    }
                    else {
                        htmls += ("<td  colspan='6'  style='text-align:right;padding-right:8px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:" + billFontNet + ";" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.Amount.toFixed(2) + "</span> ");
                        netAmt = value.Amount;
                    }

                    htmls += ("<span>Rs. " + parseFloat(cakeTotalAmount * (value.Rate / 100)).toFixed(2) + "</span></td>");
                    htmls += ("</tr>");
                    if (value.BillTerm == "NetAmount") {
                        ttlAmt = parseFloat(cakeTotalAmount).toFixed(2);

                    }
                });
            }

            htmls += ("</td><tr>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:right;border-bottom:1px dotted;font-size:" + billFontTotals + ";padding-right:8px;'>");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:left;font-size:" + billFontMeta + ";word-break:break-word;white-space:normal;'> In Words : " + data.AmntInWord + "</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=6 style='text-align:left;border-bottom:1px dotted;font-size:" + billFontMeta + ";'>" + "PrintedOn: <span  id='divPrintedOn'>" + formatAMPM() + "</span></td>");
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
            htmls += "<div id='divqrcode' style='display:none;'></div><div class='QRCode' style='text-align:center;'><img src='' id='codeimg' style='margin-top:10px; height:100px; display:none;'></div>";
            var string = "{Company:\"" + companyInfo[0].Name + "\", Bill No:" + billBody[0].BillNo + ", Date: " + billBody[0].NepaliInvoiceDate.split('.').join('/') + ", Time: " + time + ", Amount: " + ttlAmt.toFixed(2) + "}";
            body = htmls;
            $('#customer-bill').html(logoInfo + body);
            if (CodeQR == true) {
                $("#codeimg").show();
                $('#divqrcode').qrcode(string);
                var canvas = $('#divqrcode canvas');
                var img = canvas.get(0).toDataURL("image/png");
                $('#codeimg').attr('src', img);
            }

            if (billBody[0].PrintCount >= 3) {
                $('#printno').show();
            }
            applyBillPrintLayout();
            $("#NetAmount_text").text("Net Amount :");
            $("#NetAmount_text").next().text(netAmt);
            var charge = $("#DeliveryCharge").text().split(' ')[2];
            if (parseFloat(charge) <= 0) {
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

function formatAMPM() {
    var date = new Date();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strDateTime = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + '/' + (date.getDate() < 10 ? '0' : '') + date.getDate() + '/' + date.getFullYear() + "   " + hours + ':' + minutes + ' ' + ampm;
    return strDateTime;
}

function formatDate() {
    var date = new Date();
    var dateformat = date.getFullYear() + '-' + ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + '-' + (date.getDate() < 10 ? '0' : '') + date.getDate();
    return AD2BS(dateformat).split('-').join('.');
}