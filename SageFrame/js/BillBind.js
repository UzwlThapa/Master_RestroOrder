var totalItemsQntyVisible = true;
var ttlAmt = 0;
var CodeQR = JSON.parse(localStorage.getItem("QRCode"));
var netAmt = 0.00;
var IsNonTaxable = false;

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
            debugger;
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
            comphtmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;margin-right:10px;margin-right:10px;border-collapse:collapse;font-family: monospace;'>");
            comphtmls += ("<tr><td colspan='7' style='font-size:16px;text-align:center;font-weight:bold;'>" + companyInfo[0].Name + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'>" + companyInfo[0].Address + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'>" + companyInfo[0].PhoneNo + "</td></tr>");
            if (billInfo.IsArchived) {
                comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'><b>Credit Note</b></td></tr>");
            } else if (billInfo.IsCancelled) {
                comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'><b>Cancellation</b></td></tr>");
            }
            else {
                if (isab) {
                    if (isAbbreviated) {
                        comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'><b id='InvoiceType'>ABBREVIATED TAX INVOICE</b></td></tr>");
                    }
                    else {
                        comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");

                    }
                }
                else {
                    comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
                }
            }
            comphtmls += ("<tr><td colspan='1' style='font-size:11px;text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>");

            if (billBody[0].PrintCount - 1 != 0) {
                if (!billInfo.IsCancelled && !billInfo.IsArchived) {

                    comphtmls += ("<td colspan='6' style='font-size:11px;text-align:right;margin-right:10px;'><span>Copy of Original:" + (billBody[0].PrintCount - 1) + "</span></td></tr>");

                }
            }

            var logoInfo = comphtmls;

            var htmls = "";
            htmls += "<tr style='border-top:1px dotted;'>";

            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<td colspan='2' style='text-align:left;font-size:11px;'>C/N No : " + billInfo.CreditNoteNumber + "</td></tr>";
                htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>Date : " + billInfo.CreditNoteDate + "</td></tr>";
                htmls += "<tr>";
            }

            htmls += "<td colspan='1' style='text-align:left;font-size:11px;'>Customer : " + (billBody[0].CusName == "" ? "" : billBody[0].CusName);
            htmls += ("</td>");

            htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>PAN : " + billBody[0].PAN + "</td></tr>";
            if (!foodCourtOrder) {
                htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>Phone No. : " + billBody[0].PhoneNumber + "</td>";
                htmls += "<td colspan='6' style='text-align:right;font-size:11px;'>Cashier : " + billBody[0].Cashier + "</td></tr>";
            }
            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<tr><td colspan='2' style='text-align:left;font-size:11px;'>Ref Inv No : " + billInfo.InvoiceNo + "(" + billInfo.InvoiceDate + ")</td></tr>";
                htmls += "<tr><td colspan='4' style='text-align:right !important;font-size:11px;'>C/N Remarks : " + billInfo.CreditNoteReason + "</td></tr>";
                if (!foodCourtOrder) {
                    htmls += "<tr><td colspan='2' style='text-align:left;font-size:11px;'>Table : " + billBody[0].restrotableTitle + "</td></tr>";
                } else {
                    htmls += '<tr><td colspan="4" style="text-align:right !important;font-size:11px;">Cashier : ' + billBody[0].Cashier + '</td></tr>';
                }
            } else {
                htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>Address : " + billBody[0].Address + "</td>";
                var date = billBody[0].Date.split(" ");
                var time = date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + date[2];
                htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>INV No : " + billBody[0].BillNo + "</td>";

                htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>Invoice Date : " + billBody[0].NepaliInvoiceDate.split('.').join('/') + "</td>";
                if (!foodCourtOrder) {
                    htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>Table : " + billBody[0].restrotableTitle + "</td>";
                } else {
                    htmls += '<td colspan="6" style="text-align:right;font-size:11px;margin-right:10px;">Cashier : ' + billBody[0].Cashier + '</td>';
                }
                htmls += "</tr>";

                htmls += "<tr><td colspan='2' style='text-align:left;font-size:11px;'>Transaction Date : " + billBody[0].Date.split(' ')[0] + "</td>";

                htmls += "</tr>";
            }

            htmls += ("<tr class='orderedInfo'>");
            htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:12px;font-weight:bold;border-bottom:1px dotted;border-top:1px dotted;'>Item</td>");
            htmls += ("<td style='font-size:12px;font-weight:bold;text-align:center;border-bottom:1px dotted;border-top:1px dotted;'>Qty</td>");
            htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;'>Rate</td>");
            if (splitCostCenter) {
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;'>Food</td>");
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;'>Bev</td>");
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;'>Bakery</td>");
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;margin-right:10px;'>Pizza</td>");
            }
            else {
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;margin-right:10px;'>Amnt</td>");
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
            $.each(billBody, function (index, item) {
                var rateN = item.Rate;
                htmls += ("<tr class='orderedInfo' style='height:16px;'>");
                htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:12px;'>" + item.ITName.split('_')[0] + "</td>");
                htmls += ("<td style='text-align:center;font-size:12px;'>" + item.Quantity + "</td>");
                itemsQnty += item.Quantity;
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

                        //Item Rate Including VAT without Discount (JUNAR UPDATE)
                        htmls += ("<td style='text-align:right;font-size:12px;'>" + (rateN * (1 + companyInfo[0].VATRate / 100.0)).toFixed(2) + "</td>");

                        if (splitCostCenter) {
                            htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Amount * (1 + companyInfo[0].VATRate / 100.0)).toFixed(2) + "</td>");
                            htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Bevrage * (1 + companyInfo[0].VATRate / 100.0)).toFixed(2) + "</td>");
                            htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Bakery * (1 + companyInfo[0].VATRate / 100.0)).toFixed(2) + "</td>");
                            htmls += ("<td style='text-align:right;font-size:12px;margin-right:10px;'>" + (item.Pizza * (1 + companyInfo[0].VATRate / 100.0)).toFixed(2) + "</td>");
                        }
                        else {
                            //Item Rate Including VAT without Discount (JUNAR UPDATE)
                            htmls += ("<td style='text-align:right;font-size:12px;margin-right:10px;'>" + ((rateN * item.Quantity) * (1 + companyInfo[0].VATRate / 100.0)).toFixed(2) + "</td>");
                        }
                    }
                    else {
                        htmls += ("<td style='text-align:right;font-size:12px;'>" + (rateN) + "</td>");
                        if (splitCostCenter) {
                            htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Amount).toFixed(2) + "</td>");
                            htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Bevrage) + "</td>");
                            htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Bakery) + "</td>");
                            htmls += ("<td style='text-align:right;font-size:12px;margin-right:10px;'>" + (item.Pizza) + "</td>");
                        }
                        else {
                            htmls += ("<td style='text-align:right;font-size:12px;margin-right:10px;'>" + (rateN * item.Quantity).toFixed(2) + "</td>");
                        }
                    }
                }
                else {
                    htmls += ("<td style='text-align:right;font-size:12px;'>" + (rateN) + "</td>");
                    if (splitCostCenter) {
                        htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Amount).toFixed(2) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Bevrage) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Bakery) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:12px;margin-right:10px;'>" + (item.Pizza) + "</td>");
                    }
                    else {
                        htmls += ("<td style='text-align:right;font-size:12px;margin-right:10px;'>" + (rateN * item.Quantity).toFixed(2) + "</td>");
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
                    htmls += ("<tr class='orderedInfo' style='height:14px;'>");
                    htmls += ("<td colspan=" + (splitCostCenter ? 3 : 3) + " style='font-size:10px;font-style:italic;'>");
                    $.each(item.orderExtraItem, function (index, ext) {
                        htmls += ext.ExtraItem + "(" + ext.Quantity + ", Rs." + (ext.ExtraPrice) + "); ";
                        rate += (ext.Quantity * ext.ExtraPrice);
                    });
                    htmls += ("</td>");
                    if (splitCostCenter) {
                        htmls += ("<td style='text-align:right;font-size:12px;;font-style:italic;'>" + (item.Amount > 0 ? rate : 0) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:12px;;font-style:italic;'>" + (item.Bevrage > 0 ? rate : 0) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:12px;;font-style:italic;'>" + (item.Bakery > 0 ? rate : 0) + "</td>");
                        htmls += ("<td style='text-align:right;font-size:12px;;font-style:italic;'>" + (item.Pizza > 0 ? rate : 0) + "</td>");
                    }
                    else {
                        htmls += ("<td style='text-align:right;font-size:12px;;font-style:italic;'>" + rate + "</td>");
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
                        htmls += ("<td colspan='4' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + (roomRateN).toFixed(2) + "/Day): Rs." + (roomRateN * billBody[0].BookedDays).toFixed(2) + " (" + billBody[0].BookedDays + " Days)</td>");
                        roomAmount = (roomRateN * billBody[0].BookedDays);
                    } else {
                        htmls += ("<td colspan='4' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                        roomAmount = billBody[0].RoomCharge;
                    }
                } else {
                    htmls += ("<td colspan='4' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                    roomAmount = billBody[0].RoomCharge;
                }
                htmls += ("</tr>");
            }
            htmls += "<tr class='" + (splitCostCenter ? "orderedInfo" : "") + "'>";

            if (splitCostCenter) {
                htmls += ("<td colspan='3' style='text-align:right;border-bottom:1px dotted;font-size:11px;'><span style='font-weight:bold;font-size:11px;'>");
                if (totalItemsQntyVisible)
                    htmls += ("<span style='float:left;font-weight:bold;font-size:11px;'>Total Qty: " + itemsQnty + " </span>");
                htmls += ("Sub Total :</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:11px;'><span style='font-weight:bold;font-size:11px;'></span>Rs." + kotAmount.toFixed(2) + "</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:11px;'><span style='font-weight:bold;font-size:11px;'></span>Rs." + bevAmount.toFixed(2) + "</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:11px;'><span style='font-weight:bold;font-size:11px;'></span>Rs." + bakeryAmount.toFixed(2) + "</td>");
                htmls += ("<td colspan='1' style='text-align:right;border-bottom:1px dotted;font-size:11px;'><span style='font-weight:bold;font-size:11px;'></span>Rs." + pizzaAmount.toFixed(2) + "</td>");
            }
            else {
                htmls += ("<td colspan='2' style='text-align:right;border-bottom:1px dotted;font-size:11px;border-top:1px dotted;'><span style='font-weight:bold;font-size:11px;'>");
                if (totalItemsQntyVisible)
                    htmls += ("<span style='font-weight:bold;font-size:11px;'>Total Qty: " + itemsQnty + " </span></td><td colspan='2' style='text-align:right;border-bottom:1px dotted;font-size:11px;border-top:1px dotted;margin-right:10px;'>");

                //Item Rate Including VAT without Discount (JUNAR UPDATE)
                htmls += ("Sub Total : </span>Rs." + (BasicAmt + roomAmount).toFixed(2) + "</td>");
            }
            htmls += ("</tr>");


            if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && discount.isLoyalty && splitCostCenter) {
                htmls += ("<tr><td colspan='7' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = billBody[0].RoomCharge;
            }

            if (billBody[0].totaldiscount > 0) {
                htmls += ("<tr  class='orderedInfo'>");
                if (splitCostCenter) {
                    htmls += ("<td colspan='3' style='text-align:right;font-size:11px;'>Disc(KOT : " + discount.kotdis + discType + ", Bar : " + discount.bardis + discType + ", Bakery : " + discount.bakerydis + discType + ", Pizza : " + discount.pizzadis + discType + ")</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(kotdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;margin-right:10px;'>Rs." + parseFloat(pizzadis).toFixed(2) + "</td></tr>");
                    htmls += ("<tr><td colspan='3' style='text-align:right;font-size:11px;'>After Disc. Amnt</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(kotAmount - kotdis).toFixed(2)) + "</td>";
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bevAmount - bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bakeryAmount - bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;margin-right:10px;'>Rs." + parseFloat(pizzaAmount - pizzadis).toFixed(2) + "</td>");
                }
                else {
                    if (costCenterDis.GroupDis.length > 0) {
                        if (costCenterDis.isLoyalty) {
                            htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>Loyality Disc (" + costCenterDis.LoaylityDis + "%): </span>Rs." + parseFloat(billBody[0].totaldiscount).toFixed(2) + "</td></tr>");
                        } else {
                            $.each(costCenterDis.GroupDis, function (index, value) {
                                if (value.Discount > 0) {
                                    if (costCenterDis.isFlatDis) {
                                        htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>" + value.GroupName + " Disc: </span>Rs." + parseFloat(value.Discount).toFixed(2) + "</td></tr>");

                                    } else {
                                        htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>" + value.GroupName + " Disc (" + value.Discount.toFixed(2) + " %) : </span>Rs." + parseFloat((value.Discount / 100) * (value.TotalAmount + value.NonTaxableAmt)).toFixed(2) + "</td></tr>");
                                    }
                                }
                            });
                            if (costCenterDis.RoomDis > 0) {

                                if (costCenterDis.isFlatDis) {
                                    htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>Room Disc: </span>Rs." + parseFloat(costCenterDis.RoomDis).toFixed(2) + "</td></tr>");

                                } else {
                                    htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>Room Disc (" + costCenterDis.RoomDis.toFixed(2) + " %) : </span>Rs." + parseFloat((costCenterDis.RoomDis / 100) * costCenterDis.RoomCharge).toFixed(2) + "</td></tr>");
                                }
                            }
                        }
                        if (isab) {
                            if (isAbbreviated) {
                                htmls += ("<tr><td colspan='4' style='text-align:right;font-size:9px;margin-right:10px;font-style'><em>(Discount has already been deducted in above mentioned item rate)</em></td></tr>");
                            }
                        }
                    }
                }
                htmls += ("</tr>");
            }

            totaldis = (billBody[0].totaldiscount).toFixed(2);

            if (!isab) {
                htmls += ("<tr style='border-top:1px solid;'><td colspan='" + (splitCostCenter ? "7" : "4") + "' style='font-weight:bold;text-align:right;font-size:11px;margin-right:10px;'>");
                htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + (parseFloat(kotAmount) + parseFloat(bevAmount) + parseFloat(roomAmount) + parseFloat(bakeryAmount) + parseFloat(pizzaAmount) - parseFloat(totaldis)).toFixed(2));
                htmls += ("</td>");
                htmls += ("</tr>");
            }
            else {
                if (!isAbbreviated) {
                    htmls += ("<tr style='border-top:1px solid;'><td colspan='" + (splitCostCenter ? "7" : "4") + "' style='font-weight:bold;text-align:right;font-size:11px;margin-right:10px;'>");
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
                                htmls += ("<tr style='font-size:11px;text-align:right;'>");
                                htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>Non Taxable Amount : </span>");
                                htmls += ("<span>Rs. " + (NonTaxableTotalAmt - NonTaxableDis).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");
                            }
                            htmls += ("<tr style='font-size:11px;text-align:right;'>");
                            htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>Taxable Amount : </span>");
                            if (IsNonTaxable)
                                htmls += ("<span>Rs. " + (TaxableTotalAmt - TaxableDis).toFixed(2) + "</span></td>");
                            else
                                htmls += ("<span>Rs. " + parseFloat(terms[terms.length - 1].Amount - terms[terms.length - 2].Amount - value.Amount).toFixed(2) + "</span></td>");
                            htmls += ("</tr>");
                        }
                        htmls += ("<tr id='" + value.BillTerm + "' style='font-size:11px;text-align:right;'>");
                        if (value.Rate > 0) {
                            htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>" + value.BillTerm);
                            htmls += ("(" + value.Rate + "%" + ") : </span>");
                        }
                        else {
                            htmls += ("<td  colspan='7'  style='text-align:right;margin-right:10px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:14px;" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
                        }
                        htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                        htmls += ("</tr>");
                    }
                    else {
                        if (!isAbbreviated) {
                            if (value.BillTerm.toLowerCase() == "vat") {
                                htmls += ("<tr style='font-size:11px;text-align:right;'>");
                                htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>Taxable Amount : </span>");
                                htmls += ("<span>Rs. " + parseFloat(parseFloat(basicamount) + parseFloat(servicecharge)).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");

                                htmls += ("<tr id='" + value.BillTerm + "' style='font-size:11px;text-align:right;'>");
                                if (value.Rate > 0) {
                                    if (value.BillTerm.toLowerCase() == "home delivery") {
                                        htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>" + value.BillTerm);
                                        htmls += (" : </span>");
                                    } else {
                                        htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>" + value.BillTerm);
                                        htmls += ("(" + value.Rate + "%" + ") : </span>");
                                    }

                                    htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                                    htmls += ("</tr>");
                                }
                            }
                        } else {

                            if (value.BillTerm.toLowerCase() == "deliverycharge" && value.Amount > 0) {
                                htmls += ("<tr style='font-size:11px;text-align:right;'>");
                                htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>" + value.BillTerm);
                                htmls += (" : </span>");
                                htmls += ("<span>Rs. " + parseFloat(value.Amount).toFixed(2) + "</span></td>");
                                htmls += ("</tr>");
                            }
                        }
                    }

                    if (isab) {
                        if (value.BillTerm.toLowerCase() == "netamount") {
                            htmls += ("<td  colspan='7'  style='text-align:right;margin-right:10px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:14px;" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
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
                htmls += ("<td colspan='" + (splitCostCenter ? "7" : "4") + "'  style='text-align:right;font-size:12px;'><span>Adv. Payment : </span><span>(Rs. " + billBody[0].AdvancePayment.toFixed(2) + ")</span></td>");
                htmls += ("</tr>");
                htmls += ("<tr>");
                htmls += ("<td colspan='" + (splitCostCenter ? "7" : "4") + "'  style='font-weight:bold;text-align:right;font-size:14px;'><span>Rem. Amount : </span><span>Rs. " + billBody[0].BasicAmount.toFixed(2) + "</span></td>");
                htmls += ("</tr>");
            }

            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:right;border-bottom:1px dotted;font-size:11px;'>");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:left;font-size:11px;'> In Words : " + inwords + "</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:left;border-bottom:1px dotted;font-size:11px;'>" + "PrintedOn: <span  id='divPrintedOn'>" + formatAMPM() + "</span></td>");
            htmls += ("</tr>");

            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:center;font-size:12px;'>");
            htmls += ("**Thank You**");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:center;font-size:10px;'>");
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
            $("#customer-bill table td").css('padding', '0');
            $("#NetAmount_text").text("Net Amount :");
            var charge = $("#DeliveryCharge").text().split(' ')[2];
            if (parseFloat(charge) <= 0) {
                $('tr#DeliveryCharge').remove();
            }
            $("#NetAmount").css('font-weight', 'Bold');
            $("#NetAmount").css('font-size', '18px');
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!", function () {
                $.alerts.dialogClass = null;
            });
        }
    });
}

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
            comphtmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;margin-right:10px;margin-right:10px;border-collapse:collapse;'>");
            comphtmls += (" <tr><td colspan='7' style='text-align:center;'><img src='/Modules/ROCompanyInfo/logo/" + companyInfo[0].Logo + "' style='width:70px;'/></td></tr>");
            comphtmls += ("<tr><td colspan='7' style='font-size:16px;text-align:center;font-weight:bold;'>" + companyInfo[0].Name + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'>" + companyInfo[0].Address + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'>" + companyInfo[0].PhoneNo + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' style='font-size:12px;text-align:center;'><b id='InvoiceType'>TAX INVOICE</b></td></tr>");
            comphtmls += ("<tr><td colspan='1' style='font-size:11px;text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>");

            var logoInfo = comphtmls;
            var htmls = "";
            htmls += "<tr style='border-top:1px dotted;'>";
            htmls += "<td colspan='1' style='text-align:left;font-size:11px;'>Customer : " + (billBody[0].CusName == "" ? "" : billBody[0].CusName);
            htmls += ("</td>");

            htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>PAN : " + billBody[0].PAN + "</td></tr>";
            htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>INV No : " + billBody[0].BillNo + "</td>";

            var date = billBody[0].Date.split(" ");
            var time = date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + date[2];
            htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>Time : " + time + "</td>";
            htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>Date : " + billBody[0].NepaliInvoiceDate.split('.').join('/') + "</td>";
            htmls += '<td colspan="6" style="text-align:right;font-size:11px;margin-right:10px;">Cashier : ' + billBody[0].Cashier + '</td>';
            htmls += "</tr>";
            htmls += ("<tr class=''>");
            htmls += ("<td style='text-align:left;font-size:12px;font-weight:bold;border-bottom:1px dotted;border-top:1px dotted;'>Item</td>");
            htmls += ("<td style='font-size:12px;font-weight:bold;text-align:center;border-bottom:1px dotted;border-top:1px dotted;'>Qty</td>");
            htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;'>Rate</td>");
            if (splitCostCenter) {
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;'>Food</td>");
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;'>Bev</td>");
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;'>Bakery</td>");
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;margin-right:10px;'>Pizza</td>");
            }
            else {
                htmls += ("<td style='font-size:12px;font-weight:bold;text-align:right;border-bottom:1px dotted;border-top:1px dotted;margin-right:10px;'>Amnt</td>");
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

            //for bill body
            $.each(billBody, function (index, item) {
                htmls += ("<tr class='orderedInfo' style='height:16px;'>");
                htmls += ("<td colspan=" + (splitCostCenter ? 1 : 1) + " style='text-align:left;font-size:12px;'>" + item.ITName + "</td>");
                htmls += ("<td style='text-align:center;font-size:12px;'>" + item.Quantity + "</td>");
                itemsQnty += item.Quantity;
                htmls += ("<td style='text-align:right;font-size:12px;'>" + item.Rate + "</td>");
                htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Rate * item.Quantity).toFixed(2) + "</td>");
                cakeTotalAmount += (item.Rate * item.Quantity);

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
                htmls += ("<td colspan='4' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = billBody[0].RoomCharge;
            }
            htmls += "<tr class='" + (splitCostCenter ? "orderedInfo" : "") + "'>";
            htmls += ("<td colspan='4' style='text-align:right;border-bottom:1px dotted;font-size:11px;'><span style='font-weight:bold;font-size:11px;'>");
            htmls += ("Sub Total : </span>Rs." + cakeTotalAmount.toFixed(2) + "</td>");
            htmls += ("</tr>");
            if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && discount.isLoyalty && splitCostCenter) {
                htmls += ("<tr><td colspan='7' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                htmls += ("</tr>");
                roomAmount = billBody[0].RoomCharge;
            }
            if (discount.cakedis != "") {
                htmls += ("<tr>");
                htmls += ("<td colspan='" + (splitCostCenter ? 7 : 4) + "' style='text-align:right;font-size:11px;margin-right:10px;'>Discount: ");
                htmls += ("Rs." + parseFloat(discount.cakedis));
                htmls += ("</td>");
                htmls += ("</tr>");
            }

            if (discount.isLoyalty) {
                htmls += ("<tr>");
                htmls += ("<td colspan='" + (splitCostCenter ? 7 : 4) + "' style='text-align:right;font-size:11px;margin-right:10px;'>Loyalty Discount (" + discount.loyaltydis + " %) : ");
                htmls += ("Rs." + parseFloat((kotAmount + bevAmount + bakeryAmount + pizzaAmount + roomAmount) * (parseFloat(discount.loyaltydis) / 100)).toFixed(2))
                htmls += ("</td>");
                totaldis = parseFloat((kotAmount + bevAmount + bakeryAmount + pizzaAmount + roomAmount) * (parseFloat(discount.loyaltydis) / 100)).toFixed(2);
                htmls += ("</tr>");
            }
            else {
                htmls += ("<tr  class='orderedInfo'>");
                if (splitCostCenter) {
                    htmls += ("<td colspan='3' style='text-align:right;font-size:11px;'>Disc(KOT : " + discount.kotdis + discType + ", Bar : " + discount.bardis + discType + ", Bakery : " + discount.bakerydis + discType + ", Pizza : " + discount.pizzadis + discType + ")</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(kotdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;margin-right:10px;'>Rs." + parseFloat(pizzadis).toFixed(2) + "</td></tr>");
                    htmls += ("<tr><td colspan='3' style='text-align:right;font-size:11px;'>After Disc. Amnt</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(kotAmount - kotdis).toFixed(2)) + "</td>";
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bevAmount - bevdis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;'>Rs." + parseFloat(bakeryAmount - bakerydis).toFixed(2) + "</td>");
                    htmls += ("<td style='text-align:right;font-size:11px;margin-right:10px;'>Rs." + parseFloat(pizzaAmount - pizzadis).toFixed(2) + "</td>");
                }
                else {
                    if (kotdis > 0) {
                        htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>KOT Disc (" + discount.kotdis + discType + ") : </span>Rs." + parseFloat(kotdis).toFixed(2) + "</td></tr>");
                    }
                    htmls += ("<tr class='orderedInfo'>");
                    if (bevdis > 0) {
                        htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>Bar Disc (" + discount.bardis + discType + ") : </span>Rs." + parseFloat(bevdis).toFixed(2) + "</td>");
                    }
                    htmls += ("<tr class='orderedInfo'>");
                    if (bakerydis > 0) {
                        htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>Bakery Disc (" + discount.bakerydis + discType + ") : </span>Rs." + parseFloat(bakerydis).toFixed(2) + "</td>");
                    }
                    htmls += ("<tr class='orderedInfo'>");
                    if (pizzadis > 0) {
                        htmls += ("<td colspan='4' style='text-align:right;font-size:11px;margin-right:10px;'><span>Pizza Disc (" + discount.pizzadis + discType + ") : </span>Rs." + parseFloat(pizzadis).toFixed(2) + "</td>");
                    }
                }
                htmls += ("</tr>");
                if (!billBody[0].IsTable && billBody[0].BookedDays > 0 && !discount.isLoyalty && splitCostCenter) {
                    htmls += ("<tr><td colspan='7' style='text-align:right;font-size:11px;margin-right:10px;'>Room Chrg (Rs. " + billBody[0].RoomRate + "/Day): Rs." + billBody[0].RoomCharge + " (" + billBody[0].BookedDays + " Days)</td>");
                    htmls += ("</tr>");
                    roomAmount = billBody[0].RoomCharge;
                }
                if (!billBody[0].IsTable && billBody[0].BookedDays > 0) {
                    htmls += ("<tr>");
                    htmls += ("<td colspan='" + (splitCostCenter ? 7 : 4) + "' style='text-align:right;border-top:1px dotted;font-size:11px;margin-right:10px;'>Room Disc. : Rs." + parseFloat(roomdis).toFixed(2) + "</td>");
                    htmls += ("</tr>");
                }
                totaldis = (parseFloat(kotdis) + parseFloat(bevdis) + parseFloat(roomdis) + parseFloat(bakerydis) + parseFloat(pizzadis)).toFixed(2);
            }

            htmls += ("<tr style='border-top:1px solid;'><td colspan='" + (splitCostCenter ? "7" : "4") + "' style='font-weight:bold;text-align:right;font-size:11px;margin-right:10px;'>");
            htmls += ("<span style='font-weight:bold;'> Basic Amnt : </span>Rs. " + parseFloat(cakeTotalAmount - discount.cakedis).toFixed(2));
            htmls += ("</td>");
            htmls += ("</tr>");

            if (terms.length > 0) {
                $.each(terms, function (index, value) {

                    if (value.BillTerm.toLowerCase() == "vat") {
                        htmls += ("<tr style='font-size:11px;text-align:right;'>");
                        htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>Taxable Amount : </span>");
                        htmls += ("<span>Rs. " + parseFloat(cakeTotalAmount - discount.cakedis).toFixed(2) + "</span></td>");
                        htmls += ("</tr>");
                        cakeTotalAmount = parseFloat(cakeTotalAmount - discount.cakedis).toFixed(2);
                    }
                    htmls += ("<tr id='" + value.BillTerm + "' style='font-size:11px;text-align:right;'>");
                    if (value.Rate > 0) {
                        htmls += ("<td  colspan='7' style='text-align:right;margin-right:10px;'><span>" + value.BillTerm);
                        htmls += ("(" + value.Rate + "%" + ") : </span>");
                    }
                    else {
                        htmls += ("<td  colspan='7'  style='text-align:right;margin-right:10px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:14px;" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.Amount.toFixed(2) + "</span> ");
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
            htmls += ("<td colspan=7 style='text-align:right;border-bottom:1px dotted;font-size:11px;'>");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:left;font-size:11px;'> In Words : " + data.AmntInWord + "</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:left;border-bottom:1px dotted;font-size:11px;'>" + "PrintedOn: <span  id='divPrintedOn'>" + formatAMPM() + "</span></td>");
            htmls += ("</tr>");

            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:center;font-size:12px;'>");
            htmls += ("**Thank You**");
            htmls += ("</td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            htmls += ("<td colspan=7 style='text-align:center;font-size:10px;'>");
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
            $("#customer-bill table td").css('padding', '0');
            $("#NetAmount_text").text("Net Amount :");
            $("#NetAmount_text").next().text(netAmt);
            var charge = $("#DeliveryCharge").text().split(' ')[2];
            if (parseFloat(charge) <= 0) {
                $('tr#DeliveryCharge').remove();
            }
            $("#NetAmount").css('font-weight', 'Bold');
            $("#NetAmount").css('font-size', '18px');
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
