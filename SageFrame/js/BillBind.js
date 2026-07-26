// Replace your entire getBill function with this optimized version:

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
            
            // ===== ADD THERMAL PRINTER CSS =====
            comphtmls += "<style>@media print{*{font-family:'Courier New',monospace !important;font-size:9px !important;line-height:1 !important;margin:0 !important;padding:0 !important;}body{width:80mm !important;}table{width:100% !important;max-width:80mm !important;border-collapse:collapse !important;}td,th{padding:1px !important;font-size:9px !important;line-height:1.1 !important;}.text-right{text-align:right !important;}.text-center{text-align:center !important;}.text-left{text-align:left !important;}.bold{font-weight:bold !important;}.border-dash{border-bottom:1px dashed #000 !important;}.border-dot{border-bottom:1px dotted #ccc !important;}}</style>";
            
            comphtmls += "<input type='hidden' value='" + salesMasterId + "' id='hdfSMID' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].PrintCount + "' id='hdfPrntCnt' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].CusID + "' id='hdfCusID' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].CusName + "' id='hdfCusName' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].Address + "' id='hdfAddress' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].PAN + "' id='hdfPAN' />";
            comphtmls += "<input type='hidden' value='" + billBody[0].BasicAmount + "' id='hdfBasicAmount' />";
            
            // ===== THERMAL OPTIMIZED TABLE =====
            comphtmls += ("<table style='width:100%;border-collapse:collapse;font-family:monospace;font-size:9px;'>");
            
            // Company Header - Optimized for thermal
            comphtmls += ("<tr><td colspan='7' class='text-center bold' style='font-size:10px;padding:2px 0;border-bottom:1px dashed #000;'>" + companyInfo[0].Name + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' class='text-center' style='font-size:8px;padding:1px 0;'>" + companyInfo[0].Address + "</td></tr>");
            comphtmls += ("<tr><td colspan='7' class='text-center' style='font-size:8px;padding:1px 0;border-bottom:1px dashed #000;'>" + companyInfo[0].PhoneNo + "</td></tr>");
            
            // Invoice Type
            if (billInfo.IsArchived || billInfo.IsCancelled) {
                comphtmls += ("<tr><td colspan='7' class='text-center bold' style='font-size:9px;padding:2px 0;'>CREDIT NOTE</td></tr>");
            } else {
                if (isab && isAbbreviated) {
                    comphtmls += ("<tr><td colspan='7' class='text-center bold' style='font-size:9px;padding:2px 0;'>ABBREVIATED TAX INVOICE</td></tr>");
                } else {
                    comphtmls += ("<tr><td colspan='7' class='text-center bold' style='font-size:9px;padding:2px 0;'>TAX INVOICE</td></tr>");
                }
            }
            
            // PAN and Copy Info
            comphtmls += ("<tr><td colspan='4' class='text-left' style='font-size:8px;padding:1px 0;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + ": " + companyInfo[0].PAN + "</td>");
            if (billBody[0].PrintCount - 1 != 0 && !billInfo.IsCancelled && !billInfo.IsArchived) {
                comphtmls += ("<td colspan='3' class='text-right' style='font-size:8px;padding:1px 0;'>Copy: " + (billBody[0].PrintCount - 1) + "</td></tr>");
            } else {
                comphtmls += ("<td colspan='3'></td></tr>");
            }

            var logoInfo = comphtmls;

            var htmls = "";
            
            // ===== CUSTOMER INFO - THERMAL OPTIMIZED =====
            var customerName = billBody[0].CusName || "";
            if (customerName.length > 25) customerName = customerName.substring(0, 22) + '...';
            
            htmls += "<tr class='border-dash'>";
            htmls += "<td colspan='4' class='text-left' style='font-size:8px;padding:1px 0;'>Customer: " + customerName + "</td>";
            htmls += "<td colspan='3' class='text-right' style='font-size:8px;padding:1px 0;'>PAN: " + (billBody[0].PAN || "") + "</td></tr>";
            
            if (!foodCourtOrder) {
                var phone = billBody[0].PhoneNumber || "";
                if (phone.length > 15) phone = phone.substring(0, 12) + '...';
                htmls += "<tr><td colspan='4' class='text-left' style='font-size:8px;padding:1px 0;'>Phone: " + phone + "</td>";
                htmls += "<td colspan='3' class='text-right' style='font-size:8px;padding:1px 0;'>Cashier: " + (billBody[0].Cashier || "") + "</td></tr>";
            }
            
            if (billInfo.IsCancelled || billInfo.IsArchived) {
                htmls += "<tr><td colspan='7' class='text-left' style='font-size:8px;padding:1px 0;'>Ref Inv: " + (billInfo.InvoiceNo || "") + "</td></tr>";
                htmls += "<tr><td colspan='7' class='text-left' style='font-size:8px;padding:1px 0;border-bottom:1px dotted #ccc;'>Remarks: " + (billInfo.CreditNoteReason || "") + "</td></tr>";
            } else {
                // Format dates for thermal
                var nepaliDate = (billBody[0].NepaliInvoiceDate || "").split('.').join('/');
                var date = billBody[0].Date.split(" ");
                var time = date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + (date[2] || "");
                
                htmls += "<tr><td colspan='4' class='text-left' style='font-size:8px;padding:1px 0;'>Inv No: " + (billBody[0].BillNo || "") + "</td>";
                htmls += "<td colspan='3' class='text-right' style='font-size:8px;padding:1px 0;'>Date(BS): " + nepaliDate + "</td></tr>";
                
                htmls += "<tr><td colspan='4' class='text-left' style='font-size:8px;padding:1px 0;'>Date(AD): " + date[0] + "</td>";
                htmls += "<td colspan='3' class='text-right' style='font-size:8px;padding:1px 0;border-bottom:1px dotted #ccc;'>Time: " + time + "</td></tr>";
                
                if (!foodCourtOrder) {
                    htmls += "<tr><td colspan='7' class='text-left' style='font-size:8px;padding:1px 0;'>Table: " + (billBody[0].restrotableTitle || "Take Away") + "</td></tr>";
                }
            }

            // ===== ITEM TABLE HEADER - THERMAL OPTIMIZED =====
            htmls += "<tr style='border-top:1px dashed #000;border-bottom:1px dashed #000;'>";
            htmls += "<td class='text-left bold' style='width:5%;font-size:8px;padding:2px 0;'>SN</td>";
            
            if (!splitCostCenter) {
                htmls += "<td class='text-left bold' style='width:45%;font-size:8px;padding:2px 0;'>Item</td>";
                htmls += "<td class='text-center bold' style='width:10%;font-size:8px;padding:2px 0;'>Qty</td>";
                htmls += "<td class='text-right bold' style='width:20%;font-size:8px;padding:2px 0;'>Rate</td>";
                htmls += "<td class='text-right bold' style='width:20%;font-size:8px;padding:2px 0;'>Amount</td>";
            } else {
                // Split cost center layout
                htmls += "<td class='text-left bold' style='width:30%;font-size:8px;padding:2px 0;'>Item</td>";
                htmls += "<td class='text-center bold' style='width:8%;font-size:8px;padding:2px 0;'>Qty</td>";
                htmls += "<td class='text-right bold' style='width:12%;font-size:8px;padding:2px 0;'>Rate</td>";
                htmls += "<td class='text-right bold' style='width:15%;font-size:8px;padding:2px 0;'>Food</td>";
                htmls += "<td class='text-right bold' style='width:15%;font-size:8px;padding:2px 0;'>Beverage</td>";
            }
            htmls += "</tr>";

            var count = 1;
            kotAmount = 0.00;
            bevAmount = 0.00;
            roomAmount = 0.00;
            bakeryAmount = 0.00;
            pizzaAmount = 0.00;
            itemsQnty = 0.00;

            var BasicAmt = 0.00;
            sn = 1;
            
            // ===== ITEM ROWS - THERMAL OPTIMIZED =====
            $.each(billBody, function (index, item) {
                var rateN = item.Rate;
                var itemName = item.ITName.split('_')[0];
                // Truncate long item names for thermal
                if (itemName.length > 25) itemName = itemName.substring(0, 22) + '...';
                
                htmls += "<tr>";
                htmls += "<td class='text-left' style='font-size:8px;padding:1px 0;width:5%;'>" + sn + "</td>";
                
                if (!splitCostCenter) {
                    htmls += "<td class='text-left' style='font-size:8px;padding:1px 0;width:45%;'>" + itemName + "</td>";
                    htmls += "<td class='text-center' style='font-size:8px;padding:1px 0;width:10%;'>" + item.Quantity + "</td>";
                    
                    // Calculate rate with discount if abbreviated
                    if (isab && isAbbreviated) {
                        if (!costCenterDis.isFlatDis) {
                            $.each(costCenterDis.GroupDis, function (index, value) {
                                if (value.GroupId == item.GroupId && value.Discount > 0) {
                                    rateN = parseFloat((rateN * (100 - value.Discount) / 100));
                                    return false;
                                }
                            })
                        }
                        rateN = rateN * (1 + companyInfo[0].VATRate / 100.0);
                    }
                    
                    htmls += "<td class='text-right' style='font-size:8px;padding:1px 0;width:20%;'>" + parseFloat(rateN).toFixed(2) + "</td>";
                    htmls += "<td class='text-right' style='font-size:8px;padding:1px 0;width:20%;'>" + parseFloat(rateN * item.Quantity).toFixed(2) + "</td>";
                } else {
                    htmls += "<td class='text-left' style='font-size:8px;padding:1px 0;width:30%;'>" + itemName + "</td>";
                    htmls += "<td class='text-center' style='font-size:8px;padding:1px 0;width:8%;'>" + item.Quantity + "</td>";
                    htmls += "<td class='text-right' style='font-size:8px;padding:1px 0;width:12%;'>" + parseFloat(rateN).toFixed(2) + "</td>";
                    htmls += "<td class='text-right' style='font-size:8px;padding:1px 0;width:15%;'>" + parseFloat(item.Amount || 0).toFixed(2) + "</td>";
                    htmls += "<td class='text-right' style='font-size:8px;padding:1px 0;width:15%;'>" + parseFloat(item.Bevrage || 0).toFixed(2) + "</td>";
                }
                
                htmls += "</tr>";
                
                itemsQnty += item.Quantity;
                sn++;
                
                // Accumulate amounts
                kotAmount += parseFloat(item.Amount || 0);
                bevAmount += parseFloat(item.Bevrage || 0);
                bakeryAmount += parseFloat(item.Bakery || 0);
                pizzaAmount += parseFloat(item.Pizza || 0);
                
                // Calculate Basic Amount
                if (isab && isAbbreviated) {
                    BasicAmt += (rateN * item.Quantity) * (1 + companyInfo[0].VATRate / 100.0);
                } else {
                    BasicAmt += rateN * item.Quantity;
                }
            });

            // ===== TOTALS SECTION - THERMAL OPTIMIZED =====
            htmls += "<tr style='border-top:1px dashed #000;'>";
            htmls += "<td colspan='" + (splitCostCenter ? 2 : 3) + "' class='text-right bold' style='font-size:8px;padding:2px 0;'>";
            if (typeof totalItemsQntyVisible !== 'undefined' && totalItemsQntyVisible) {
                htmls += "Qty: " + itemsQnty + " | ";
            }
            htmls += "Sub Total:</td>";
            htmls += "<td colspan='" + (splitCostCenter ? 3 : 2) + "' class='text-right bold' style='font-size:8px;padding:2px 0;'>";
            htmls += "Rs." + parseFloat(BasicAmt + roomAmount).toFixed(2) + "</td>";
            htmls += "</tr>";

            // Discount section
            var totaldis = parseFloat(billBody[0].totaldiscount || 0).toFixed(2);
            if (billBody[0].totaldiscount > 0) {
                htmls += "<tr>";
                htmls += "<td colspan='" + (splitCostCenter ? 2 : 3) + "' class='text-right' style='font-size:8px;padding:1px 0;'>Discount:</td>";
                htmls += "<td colspan='" + (splitCostCenter ? 3 : 2) + "' class='text-right' style='font-size:8px;padding:1px 0;'>";
                htmls += "Rs." + totaldis + "</td>";
                htmls += "</tr>";
                
                if (isab && isAbbreviated) {
                    htmls += "<tr><td colspan='" + (splitCostCenter ? 5 : 5) + "' class='text-center' style='font-size:7px;font-style:italic;padding:1px 0;'>(Discount deducted in item rate)</td></tr>";
                }
            }

            // Tax calculations
            var basicamount = (parseFloat(kotAmount) + parseFloat(bevAmount) + parseFloat(roomAmount) + parseFloat(bakeryAmount) + parseFloat(pizzaAmount) - parseFloat(totaldis)).toFixed(2);
            
            if (!isab || (isab && !isAbbreviated)) {
                htmls += "<tr>";
                htmls += "<td colspan='" + (splitCostCenter ? 2 : 3) + "' class='text-right' style='font-size:8px;padding:1px 0;'>Basic Amount:</td>";
                htmls += "<td colspan='" + (splitCostCenter ? 3 : 2) + "' class='text-right' style='font-size:8px;padding:1px 0;'>" + basicamount + "</td>";
                htmls += "</tr>";
            }

            // Tax terms
            if (terms && terms.length > 0) {
                $.each(terms, function (index, value) {
                    if (value.BillTerm.toLowerCase() == "vat") {
                        htmls += "<tr>";
                        htmls += "<td colspan='" + (splitCostCenter ? 2 : 3) + "' class='text-right' style='font-size:8px;padding:1px 0;'>Taxable Amount:</td>";
                        htmls += "<td colspan='" + (splitCostCenter ? 3 : 2) + "' class='text-right' style='font-size:8px;padding:1px 0;'>" + parseFloat(basicamount).toFixed(2) + "</td>";
                        htmls += "</tr>";
                    }
                    
                    if (value.Rate > 0) {
                        htmls += "<tr>";
                        htmls += "<td colspan='" + (splitCostCenter ? 2 : 3) + "' class='text-right' style='font-size:8px;padding:1px 0;'>" + 
                                value.BillTerm + " (" + value.Rate + "%):</td>";
                        htmls += "<td colspan='" + (splitCostCenter ? 3 : 2) + "' class='text-right' style='font-size:8px;padding:1px 0;'>" + parseFloat(value.Amount || 0).toFixed(2) + "</td>";
                        htmls += "</tr>";
                    }
                    
                    if (value.BillTerm == "NetAmount") {
                        ttlAmt = parseFloat(value.Amount || 0).toFixed(2);
                        htmls += "<tr style='border-top:1px dashed #000;border-bottom:1px dashed #000;'>";
                        htmls += "<td colspan='" + (splitCostCenter ? 2 : 3) + "' class='text-right bold' style='font-size:9px;padding:2px 0;'>NET AMOUNT:</td>";
                        htmls += "<td colspan='" + (splitCostCenter ? 3 : 2) + "' class='text-right bold' style='font-size:9px;padding:2px 0;'>Rs. " + ttlAmt + "</td>";
                        htmls += "</tr>";
                    }
                });
            }

            // ===== FOOTER - THERMAL OPTIMIZED =====
            // In Words (truncated for thermal)
            var inWordsTruncated = inwords;
            if (inWordsTruncated.length > 40) {
                inWordsTruncated = inWordsTruncated.substring(0, 37) + '...';
            }
            
            htmls += "<tr>";
            htmls += "<td colspan='" + (splitCostCenter ? 5 : 5) + "' class='text-left' style='font-size:8px;padding:2px 0;word-break:break-word;'>";
            htmls += "In Words: " + inWordsTruncated;
            htmls += "</td></tr>";
            
            htmls += "<tr>";
            htmls += "<td colspan='" + (splitCostCenter ? 5 : 5) + "' class='text-left' style='font-size:7px;padding:1px 0;'>";
            htmls += "Printed: " + (typeof formatAMPM === 'function' ? formatAMPM() : new Date().toLocaleString());
            htmls += "</td></tr>";
            
            htmls += "<tr>";
            htmls += "<td colspan='" + (splitCostCenter ? 5 : 5) + "' class='text-center' style='font-size:9px;padding:3px 0;border-top:1px dashed #000;'>";
            htmls += "** Thank You **";
            htmls += "</td></tr>";
            
            htmls += "<tr>";
            htmls += "<td colspan='" + (splitCostCenter ? 5 : 5) + "' class='text-center' style='font-size:7px;padding:1px 0;'>";
            htmls += "Powered By Restro Order";
            htmls += "</td></tr>";
            
            htmls += "</table>";

            // QR Code section (hidden by default for thermal)
            htmls += "<div id='divqrcode' style='display:none;'></div>";
            htmls += "<div class='QRCode' style='text-align:center;margin-top:5px;'>";
            htmls += "<img src='' id='codeimg' style='height:60px;display:none;'>";
            htmls += "</div>";

            // Combine and display
            var string = "{Company:\"" + companyInfo[0].Name + "\", Bill No:" + billBody[0].BillNo + ", Date: " + nepaliDate + ", Time: " + time + ", Amount: " + parseFloat(ttlAmt).toFixed(2) + "}";
            body = htmls;
            $('#customer-bill').html(logoInfo + body);
            
            // Handle QR Code
            if (CodeQR == true) {
                $("#codeimg").show();
                $('#divqrcode').qrcode(string);
                var canvas = $('#divqrcode canvas');
                if (canvas.length > 0) {
                    var img = canvas.get(0).toDataURL("image/png");
                    $('#codeimg').attr('src', img);
                }
            }

            // Show print warning if needed
            if (billBody[0].PrintCount >= 3) {
                $('#printno').show();
            }
            
            // Apply thermal formatting immediately
            $("#customer-bill table td").css('padding', '1px');
            $("#NetAmount_text").text("NET AMOUNT:");
            
            var charge = $("#DeliveryCharge").text().split(' ')[2];
            if (parseFloat(charge) <= 0) {
                $('tr#DeliveryCharge').remove();
            }
            
            // Hide QR code for thermal printing
            if (window.matchMedia && window.matchMedia('print').matches) {
                $('.QRCode').hide();
            }
            
            // Apply thermal-specific styles
            $('table').css({
                'font-family': "'Courier New', monospace",
                'font-size': '9px',
                'line-height': '1.1'
            });
            
            $('td, th').css({
                'padding': '1px 2px',
                'line-height': '1.1'
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!", function () {
                $.alerts.dialogClass = null;
            });
        }
    });
}

// Helper function to format date/time with AM/PM
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
