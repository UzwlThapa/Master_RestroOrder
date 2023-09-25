var totalItemsQntyVisible = true;
var netAmt = 0.00;
var ttlAmt = 0;
var CodeQR = JSON.parse(localStorage.getItem("QRCode"));
function getCakeBill(salesMasterId, foodCourtOrder) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RoReport/SalesReport.asmx/GetCakeBill",
        data: JSON.stringify({ SalesMasterID: salesMasterId, SalesType: 'cake' }),
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
            comphtmls += "<input type='hidden' value='" + salesMasterId + "' id='hdfSMID' />";
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



            htmls += "<td colspan='1' style='text-align:left;font-size:11px;'>Customer : " + (billBody[0].CusName == "" ? "CASH" : billBody[0].CusName);
            htmls += ("</td>");

            htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>PAN : " + billBody[0].PAN + "</td></tr>";

            htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>INV No : " + billBody[0].BillNo + "</td>";
            var date = billBody[0].Date.split(" ");
            var time = date[1].split(":")[0] + ":" + date[1].split(":")[1] + " " + date[2];
            htmls += "<td colspan='6' style='text-align:right;font-size:11px;margin-right:10px;'>Time : " + time + "</td>";
            htmls += "<tr><td colspan='1' style='text-align:left;font-size:11px;'>Date : " + billBody[0].NepaliInvoiceDate.split('.').join('/') + "</td>";

            htmls += '<td colspan="6" style="text-align:right;font-size:11px;margin-right:10px;">Cashier : ' + billBody[0].Cashier + '</td>';

            htmls += "</tr>";
            //}
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
                htmls += ("<td style='text-align:right;font-size:12px;'>" + (item.Rate * item.Quantity) + "</td>");
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
            netAmt += discount.BasicAmount;
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
                        htmls += ("<td  colspan='7'  style='text-align:right;margin-right:10px;" + (value.BillTerm == "NetAmount" ? "border-top:1px dotted; font-size:14px;" : "") + "'><span id='" + value.BillTerm + "_text'>" + value.BillTerm + "</span> ");
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
            //htmls += ("<td colspan=7 style='text-align:left;font-size:11px;'> In Words : " + numberToWords(netAmt - billBody[0].AdvancePayment) + "</td>");
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
            htmls += ("</table>");

            htmls += "<input type='hidden' value='" + ((!((kotAmount + bevAmount + bakeryAmount + pizzaAmount) > 0)) ? "true" : "false") + "' id='hdfHide' />";
            //htmls += "<div id='divqrcode' style='display:none;'></div><div class='QRCode' style='text-align:center;'><img src='' id='codeimg' style='margin-top:10px; height:100px;'></div>";
            var string = "{Company:\"" + companyInfo[0].Name + "\", Bill No:" + billBody[0].BillNo + ", Date: " + billBody[0].NepaliInvoiceDate.split('.').join('/') + ", Time: " + time + ", Amount: " + ttlAmt + "}";
            body = htmls;
            $('#customer-bill').html(logoInfo + body);
            if (CodeQR == true) {
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
            $("#NetAmount_text").next().text($('#txtNetAmt').val());
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

function numberToWords(number) {
    var digit = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
    var elevenSeries = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
    var countingByTens = ['twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];
    var shortScale = ['', 'thousand', 'million', 'billion', 'trillion'];

    number = number.toString(); number = number.replace(/[\, ]/g, ''); if (number != parseFloat(number)) return 'not a number'; var x = number.indexOf('.'); if (x == -1) x = number.length; if (x > 15) return 'too big'; var n = number.split(''); var str = ''; var sk = 0; for (var i = 0; i < x; i++) { if ((x - i) % 3 == 2) { if (n[i] == '1') { str += elevenSeries[Number(n[i + 1])] + ' '; i++; sk = 1; } else if (n[i] != 0) { str += countingByTens[n[i] - 2] + ' '; sk = 1; } } else if (n[i] != 0) { str += digit[n[i]] + ' '; if ((x - i) % 3 == 0) str += 'hundred '; sk = 1; } if ((x - i) % 3 == 1) { if (sk) str += shortScale[(x - i - 1) / 3] + ' '; sk = 0; } } if (x != number.length) { var y = number.length; } str = str.replace(/\number+/g, ' '); return str.trim() + " only.";

}

