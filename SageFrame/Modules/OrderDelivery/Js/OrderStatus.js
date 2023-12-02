var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&
        (charCode < 48 || charCode > 57)) {
        return false;
    } else if ($(element).val().indexOf('.') != -1 && $(element).val().split('.')[1].length >= 2) {
        return false;
    } else {
        return true;
    }
}
function print() {
    var contents = $('#customer-bill').html();
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
                 ModulePath: '/Modules/OrderDelivery/services/',
                 HostUrl: '',
             }, p);
        var v = 0;
        var name = [];
        var checks = [];
        var Custlist = [];
        var CusID = 0;
        var OrderMasterID = 0;
        var CancelTableID = 0;
        var userRole = "";
        var allusers = '';
        var companyProf = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "OrderDeliveryWB.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },
            InitialSetup: function () {
                companyProf.GetOrderDeliveryList();
                companyProf.GetUserName();
                companyProf.GetUnpaidBills();
                companyProf.GetOrderDeliveredList();
                companyProf.GetAllUsers();
            },
            init: function () {
                companyProf.InitialSetup();

                $("#membeshipformlist").on('click', '#BDtable tr', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                        $("#txtCusID").val(ids[1]);
                        $("#txtCashCusName").val(ids[2] + " " + ids[3]);
                        $("#txtCusAddress").val(ids[5]);
                        $("#txtPan").val(ids[4]);
                        $("#txtNumber").val(ids[7]);
                        $("#txtCardNumber").val(ids[8]);
                        $("#txtCashCusName").prop('disabled', true);
                        $("#txtCusAddress").prop('disabled', true);
                        $("#txtLoyaltyDiscount").val(ids[6]);
                        $("#membeshipformlist").dialog('close');
                });



                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        //$('#hdnPinMatch').unbind('change');
                        var pinFor = $('#hdnPinFor').val();
                       if (pinFor == "generateBill") {
                            $('.paynows').click();
                        } else if (pinFor == 'CancelOrder') {
                            $('#cancelby').text($('#hdnPinBy').val());
                            $('#splitNoCancel').val(1);
                            $('#canceltextarea').val('');
                            $('#DisplayCancel').dialog({
                                title: 'Cancel Order'
                            });
                        }
                    }
                });
                PinCodeSetup();
                NumCodeSetup();
                setInterval(function () { companyProf.InitialSetup() }, 60000);


                $('#btnSumbit').on('click', function () {
                    var myStr = $("#canceltextarea").val();
                    var newStr = myStr.replace(/  +/g, ' ');
                    if (newStr.length <= 4) {
                        jAlert('Please Insert Cancel Reason more than 4 words.', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        companyProf.CancelOrderedData();
                    }
                });
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: companyProf.config.type,
                    contentType: companyProf.config.contentType,
                    async: companyProf.config.async,
                    cache: companyProf.config.cache,
                    url: companyProf.config.url,
                    data: companyProf.config.data,
                    dataType: companyProf.config.dataType,
                    success: companyProf.ajaxSuccess,
                    error: companyProf.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        companyProf.BindOrderDeliveryList(data.d);
                        break;
                    case 2:
                        companyProf.BindSalesBill(data, 1);
                        break;
                    case 3:
                        var role = data.d;
                        userRole = role.Roles;
                        break;
                    case 4:
                        companyProf.BindCustomerDetails(data.d);
                        break;
                    case 5:
                        companyProf.Bindmembership(data);
                        break;
                    case 6:
                        $('#DialogOrderDetail').dialog('close');
                        companyProf.GetBill(data.d)
                        print();
                        $('#InvoiceType').html('INVOICE');
                        $('#btnPrints').click();
                        companyProf.Reset();
                        break;
                    case 7:
                        print();
                        $('#BillingView').dialog('close');
                        break;
                    case 8:
                        companyProf.bindUnpaidBillsData(data.d);
                        break;
                    case 9:
                        companyProf.bindOrderDeliveredData(data.d);
                        break;
                    case 10:
                        jAlert('Ordered Cancelled successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        companyProf.Reset();
                        break;
                    case 11:
                        allusers = data.d;
                      //  companyProf.BindUsers();
                        break;
                }
            },
            ajaxFailure: function (data) {


            },


            //-----------------------------------------getdata---------------------------
            GetAllUsers: function () {
                companyProf.config.method = "GetAllUsers";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 11;
                companyProf.ajaxCall(companyProf.config);
            },
            BindUsers: function () {
                var datas = allusers;
                var htmls = "";
                $("#txtDeliveredBy").html('');
                if (datas.UserList.length > 0) {
                    $.each(datas.UserList, function (index, value) {
                        htmls += "<option value='" + value.UserName + "'>" + value.UserName + "</option>";
                    });

                    $("#txtDeliveredBy").html(htmls);
                }

            },
            GetOrderDeliveredList: function () {
                companyProf.config.method = "GetOrderDeliveredList";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.ajaxCallMode = 9;
                companyProf.ajaxCall(companyProf.config);
            },
            GetUnpaidBills: function () {
                companyProf.config.method = "GetUnpaidBills";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.ajaxCallMode = 8;
                companyProf.ajaxCall(companyProf.config);
            },
            GetOrderDeliveryList: function () {

                companyProf.config.method = "GetOrderDeliveryList";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify();
                companyProf.config.ajaxCallMode = 1;
                companyProf.ajaxCall(companyProf.config);
            },
    
            GetDataForSalesBill: function (orderMasterId) {
                companyProf.config.method = "GetDataForSalesBill";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                companyProf.config.ajaxCallMode = 2;
                companyProf.ajaxCall(companyProf.config);
            },

            GetUserName: function () {
                var loggername = SageFrameUserName;
                companyProf.config.method = "GetRolesByUsername";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ username: loggername });
                companyProf.config.ajaxCallMode = 3;
                companyProf.ajaxCall(companyProf.config);
            },

            getmembershiplistbyId: function (memberid) {
                companyProf.config.method = "getmembershiplistbyId";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({
                    memberid: memberid
                });
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },

            GetCustomeronChange: function () {
                var customer = 1;
                companyProf.config.method = "getsdatass";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ customer: customer });
                companyProf.config.ajaxCallMode = 5;
                companyProf.ajaxCall(companyProf.config);
            },
            //---------------------------------------------BindData----------------------------------------------------------------------
            BindCustomerDetails: function (data) {
                var result = JSON.parse(data);
                $('.customerForCash').prop('checked', true);
                $("#txtCusID").val(result[0].MembershipID);
                $("#txtCashCusName").val(result[0].Fname + " " + result[0].Lname);
                $("#txtNumber").val(result[0].TelMobile == "" ? $("#txtNumber").val() : result[0].TelMobile);
                $("#txtLoyaltyDiscount").val(result[0].discount);
                $(".disc").show();
                $(".roomdisc").hide();
                $(".loyaltydisc").hide();
            },
            bindOrderDeliveredData: function (datas) {
                $("#OrderDelievereddiv").html('');
                var htmls = "";
                htmls += "<table id='tblDeliveredData'>";
                htmls += "<thead><th>Bill No</th><th>Table</th><th>Amount</th><th>Delivered By</th><th>Ordered Time</th><th>Dispatched Time</th><th>Delivered Time</th><th>View Bill<th></thead><tbody>";
                if (eval(datas).length > 0) {
                    $.each(eval(datas), function (index, item) {
                        //if
                        htmls += "<tr><td>" + item.billNo + "</td>";
                        htmls += "<td>Food Delivery</td>";
                        htmls += "<td>" + item.NetAmount + "</td>";
                        htmls += "<td>" + item.DeliveredBy + "</td>";
                        htmls += "<td>" + item.Date + "</td>";
                        htmls += "<td>" + item.BillDate + "</td>";
                        htmls += "<td>" + item.DeliveryTime + "</td>";
                        htmls += "<td><label id='" + item.salesMasterId + "' class='icon-preview btnViewBill'/></td>";                      
                        htmls += "</tr>";
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan=4 style='text-align:center;'>No Data Available</td>";
                    htmls += "</tr>"
                }

                htmls += "</tbody></table>";
                $("#OrderDelievereddiv").html(htmls);
                $("#OrderDelievereddiv").on("click", ".btnViewBill", function () {
                    var ids = $(this).attr('id');
                    companyProf.GetBill(ids);
                });
            },


            bindUnpaidBillsData: function (datas) {
                $("#DispatchDelieverydiv").html('');
                var htmls = "";
                htmls += "<table id='tblforunpaidbills'>";
                htmls += "<thead><th>Bill No</th><th>Table</th><th>Amount</th><th>Assigned To</th><th>Dispatched Time</th><th></th></thead><tbody>";
                if (eval(datas).length > 0)
                {
                    $.each(eval(datas), function (index, item) {
                        //if
                        htmls += "<tr><td>" + item.BillNo + "</td>";
                        htmls += "<td>Food Delivery</td>";
                        htmls += "<td>" + item.BillAmount + "</td>";
                        htmls += "<td>" + item.DeliveredBy + "</td>";
                        htmls += "<td>" + item.BillDate + "</td>";
                        htmls += "<td><label id='" + item.salesMasterId + "' class='sfBtn btnViewBill restro-btn' style='padding:1px 4px;margin-right:10px;'>View Bill</label>";
                        htmls += "<label id='" + item.salesMasterId + "_" + item.CusID + "_" + item.Customer.replace(/['"]+/g, '') + "_" + item.Address + "_" + item.PAN + "_" + item.BillNo + "_" + item.BillAmount + "' class='sfBtn btnPayBill restro-btn' style='padding:1px 4px;'>Food Delivered</label></td></tr>";
                    });
                }
  
                        else {
                        htmls += "<tr>";
                        htmls += "<td colspan=4 style='text-align:center;'>No Data Available</td>";
                        htmls += "</tr>"
                    }
                
                htmls += "</tbody></table>";
                $("#DispatchDelieverydiv").html(htmls);

                $("#DispatchDelieverydiv").on("click", ".btnViewBill", function () {
                    var ids = $(this).attr('id');
                    companyProf.GetBill(ids);
                });
                $("#DispatchDelieverydiv").on("click", ".btnPayBill", function () {
                    var datas = $(this).attr('id').split("_");
                    payment(datas[0]);
                });
            },

            BindOrderDeliveryList: function (result) {
                var datas = JSON.parse(result);
                $("#OrderDelieverydiv").html('');
                var htmls = "<table id='Brandtable' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Order ID </th><th> Order No. </th><th> Token No. </th><th>Customer Name</th><th>Contact No.</th><th>Date </th><th>Status</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0)
                {
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + value.OrderMasterId + "</td>";
                        htmls += "<td>" + value.OrderNo + "</td>";
                        htmls += "<td>" + value.TokenNo + "</td>";
                        htmls += "<td>" + value.CustomerName + "</td>";
                        htmls += "<td>" + value.Phone + "</td>";
                        htmls += "<td>" + value.tableDate + "</td>";
                        htmls += "<td><div class='ordering'><input id='Order_" + value.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />";
                        htmls += "<input id='Dispatch_" + value.OrderMasterId + "_" + value.CustomerID + "' type='button' class='sfBtn restro-btn paynow' value='Dispatch' style='padding:1px 4px; margin-left:10px;' />";
                        htmls += "<input id='Cancel_" + value.OrderMasterId + "_" + value.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />";
                        htmls += "</div></td></tr>"
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan=7 style='text-align:center;'>No Data Available</td>";
                    htmls += "</tr>"
                }
                
                htmls += "</tbody></table>";
                $("#OrderDelieverydiv").html(htmls);

                $('#OrderDelieverydiv').on('click', '.paynow', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    companyProf.GetDataForSalesBill(data[1]);
                });

                $('#OrderDelieverydiv').on('click', '.ordernow', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Food-Delivery.aspx?OID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });

                $('#OrderDelieverydiv').on('click', '.cancelorder', function () {
                    OrderMasterID = $(this).attr('id').split("_")[1];
                    var abc = $(this).attr('id').split("_");
                    CancelTableID = 0;
                    var noOfSeat = parseInt($(this).attr('id').split("_")[2]);
                    var htmls = "";
                    $('#splitNoCancel').html('');
                    for (i = 1; i <= noOfSeat; i++) {
                        htmls += '<option value="' + i + '">' + i + '</option>';
                    }
                    $('#splitNoCancel').html(htmls);
                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();

                });
            },


            BindSalesBill: function (result, seatNo) {
                var isab = companyInfo.IsAbbreviated;

                isButtonClicked = true;
                sNo = seatNo;
                var d = result.d;
                var datas = JSON.parse(d);
                const orderdetails = datas.orderDetail;
                orddetail = datas.orderDetail;
                billingterms = datas.billingTerm;
                costcenters = datas.cuscenter;
                var costCenterGroup = datas.costCenterGroups;
                tableinfo = datas.RoomBooking;
                tokeninfo = datas.Token;
                var htmls = "";
                $('#DialogOrderDetail').html("");
                barAmount = 0.00;
                kotAmount = 0.00;
                totalAmount = 0.00;
                kotdis = 0.00;
                bevdis = 0.00;
                roomAmount = 0.00;
                roomdis = 0.00;
                bakeryAmount = 0.00;
                bakerydis = 0.00;
                pizzaAmount = 0.00;
                pizzadis = 0.00;
                var qnty = 0.0;
                DialogWidth = '900';
                noOfGuest = 1;
                htmls += "<div id='dialogOrderOpen'>";
                htmls += ("<div class='dashboardmain'>");

                //Abb Changes
                if (isab) {

                    totalAmount = 0;
                    $.each(orderdetails, function (index, value) {
                        amt = parseFloat(value.Quantity) * parseFloat(value.Rate);

                        totalAmount += parseFloat(amt);

                        if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                            qnty = 0;
                            rate = 0.00;
                            $.each(value.orderExtraItem, function (index, value) {
                                htmls += (value.ExtraItem) + "(" + value.Quantity + ", Rs." + value.ExtraPrice + "); ";
                                qnty += value.Quantity;
                                rate += parseFloat(value.ExtraPrice * value.Quantity);
                            });
                            amt = parseFloat(rate);

                            totalAmount += parseFloat(amt);
                        }
                    });

                    totaldis = 0;

                    //Check
                    totaldis += (parseFloat(kotAmount) * (parseFloat(costcenters[0].coDiscount) / 100));

                    totaldis += (parseFloat(barAmount) * (parseFloat(costcenters[1].coDiscount) / 100));

                    totaldis += (parseFloat(bakeryAmount) * (parseFloat(costcenters[2].coDiscount) / 100));

                    totaldis += (parseFloat(pizzaAmount) * (parseFloat(costcenters[4].coDiscount) / 100));
                    //Check


                    if (totaldis == null || totaldis == "") {
                        totaldis = 0;
                    }

                    amntAfterDisc = 0;
                    amntAfterDisc = (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2);
                    netAmount = 0.00;
                    $.each(datas.billingTerm, function (index, item) {

                        if (item.BillTerm != "Home Delivery") {
                            if (item.BillTerm != "Evening Discount") {
                                if (item.BillTerm != "VAT") {
                                    if (item.IsAdd == 1)
                                        netAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                                    else
                                        netAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                                }
                            }
                        }
                    });
                    netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc)).toFixed(2));
                    if (datas.VATforBill) {
                        if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {

                            var vat = parseFloat(netAmount * 0.13).toFixed(2);
                            netAmount = (parseFloat(netAmount) + parseFloat(vat)).toFixed(2);
                        }
                    }

                    isAbbreviated = true;

                    var v_rate = companyInfo.VATRate;

                    if (netAmount > companyInfo.AbbreviatedValue) {
                        isAbbreviated = false;
                        v_rate = 0.0;
                    }
                }
                //AddChanges


                if (orderdetails.length > 0) {
                    noOfGuest = parseInt(orderdetails[0].GuestNo);
                    htmls += ("<div class='left-sec'><div class='dialogflex'><h4>Room : " + orderdetails[0].restroRoom + "  / Table : " + (orderdetails[0].MergeTableName != "" && orderdetails[0].MergeTableName != null ? orderdetails[0].MergeTableName : orderdetails[0].restrotableTitle) + " </h4><h4> Waiter: " + orderdetails[0].Waiter + "</h4></div>");
                    htmls += ("<div class='dialogflex' style=margin-top:5px;><h5>Ordered Items Details</h5>");
                    htmls += ("<div>Bill No: <select id='billnoForSales' class='sfInputbox' style='width:55px;display:initial;'>")
                    for (i = 1; i <= noOfGuest; i++) {
                        count = 0;
                        $.each(orderdetails, function (index, value) {
                            if (value.SeatNo == i) {
                                count++;
                            }
                            if (value.SeatNo > noOfGuest) {
                                noOfGuest = value.SeatNo;
                            }
                        });
                        if (i == seatNo && count == 0) {
                            seatNo++;
                            sNo = seatNo;
                        }
                        if (count > 0) {
                            htmls += (" <option value='" + i + "'>" + i + "</option> ");
                        }
                    }
                    htmls += "</select></div></div>";
                    htmls += ("<div class='item_list_div'><table class='item-list-tbl'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody id='salesDetailsTbl'>");

                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        if (value.SeatNo == seatNo) {
                            htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                            htmls += ("<td>" + value.Quantity + "</td>");

                            if (!isab)
                                htmls += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + value.Rate + "</td>");
                            else {
                                if (isAbbreviated) {
                                    htmls += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + (value.Rate * (1 + v_rate / 100.0)).toFixed(2) + "</td>");

                                }
                                else {
                                    htmls += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + value.Rate + "</td>");
                                }
                            }
                            qnty += parseFloat(value.Quantity);
                            amt = parseFloat(value.Quantity) * parseFloat(value.Rate);

                            if (!isab) {
                                totalAmount += parseFloat(amt);
                            }



                            if (!isab)
                                htmls += ("<td class='item-amount'>" + amt + "</td></tr>");
                            else
                                htmls += ("<td class='item-amount'>" + (amt * (1 + v_rate / 100.0)).toFixed(2) + "</td></tr>");

                            const group = costCenterGroup.filter(x => x.GroupId === value.GroupId)
                            if (group.length > 0) {
                                const i = costCenterGroup.findIndex(x => x.GroupId === value.GroupId);
                                costCenterGroup[i].TotalAmt += amt;
                            }


                            if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                                htmls += ("<tr class='allsplited' style='font-size: 10px;font-style: italic;'><td></td><td colspan=3>");
                                qnty = 0;
                                rate = 0.00;
                                $.each(value.orderExtraItem, function (index, value) {
                                    htmls += (value.ExtraItem) + "(" + value.Quantity + ", Rs." + value.ExtraPrice + "); ";
                                    qnty += value.Quantity;
                                    rate += parseFloat(value.ExtraPrice * value.Quantity);
                                });
                                htmls += "</td>";
                                //htmls += ("</td><td>" + qnty + "</td>");
                                //htmls += ("<td class='item-rate'>" + (rate/qnty) + "</td>");
                                amt = parseFloat(rate);


                                totalAmount += parseFloat(amt);



                                if (!isab)
                                    htmls += ("<td class='item-amount'>" + amt + "</td></tr>");
                                else
                                    htmls += ("<td class='item-amount'>" + (amt * (1 + v_rate / 100.0)).toFixed(2) + "</td></tr>");

                                const group = costCenterGroup.filter(x => x.GroupId === value.GroupId)
                                if (group.length > 0) {
                                    const i = costCenterGroup.findIndex(x => x.GroupId === value.GroupId);
                                    costCenterGroup[i].TotalAmt += amt;
                                }


                            }
                            sn++;
                        }
                    });
                    if (isab) {
                        if (isAbbreviated) {
                            htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : Rs.<span class='totle'> " + (totalAmount * (1 + v_rate / 100.0)).toFixed(2) + "</span></td></tr>");
                        }
                        else {
                            htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                        }
                    }
                    else {
                        htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    }
                    htmls += ("</tfoot></table></div>");
                } else {
                    htmls += ("<div class='left-sec'><h4>Room : " + "  / Table : " + tableinfo.restrotableTitle + " </h4><h4> Waiter: " + "</h4>");
                }
                if (tableinfo.RoomBookDetailsID > 0) {
                    htmls += ("<h5>Room Charge Details : </h5>");
                    htmls += ("<table class='room-details-tbl'><thead><th>Room Name</th><th style='width:250px'>Rate</th><th>Days</th><th>Amt (Rs.)</th></thead><tbody>");
                    htmls += ("<tr><td>" + tableinfo.restrotableTitle + "</td>");
                    htmls += ("<td>" + tableinfo.Rate + "</td>");
                    htmls += ("<td>" + tableinfo.BookedDays + "</td>");
                    htmls += ("<td>" + tableinfo.Rate * tableinfo.BookedDays + "</td></tr>");
                    roomAmount += tableinfo.Rate * tableinfo.BookedDays;
                    totalAmount += roomAmount;
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='roomtotle'>Rs. " + roomAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
                }

                htmls += ("<h4>Discount Method</h4><div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'><div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");

                totaldis = 0;

                htmls += ("<tr>");
                htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option></select> </td>");
                htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable' style='width:50px;'/></td></tr>");

                $.each(costCenterGroup, function (index, item) {
                    htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>" + item.GroupName + " ( Rs. " + item.TotalAmt.toFixed(2) + " ) </td><td>";
                    htmls += "<input type='text' class='sfInputbox txtdiscount txt_dis' data-groupId='" + item.GroupId + "' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='index_" + index + "' value='" + 0 + "' /></td>";

                })

                htmls += "<tr class='roomdisc' style='" + ((tableinfo.RoomBookDetailsID > 0) ? "" : "display:none") + "'><td>Room ( Rs. " + roomAmount + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtRoomDiscount' value='0' /></td>";
                htmls += "</tr>";
                htmls += "<tr class='loyaltydisc' style='display:none;'><td>Loyalty Discount : </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtLoyaltyDiscount' value='" + tableinfo.LoyaltyDiscount + "' disabled /></td>";
                htmls += "</tr>";
                htmls += ("</tbody></table></div>");

                htmls += '<div id="divBillingTerm"></div></div></div>';
                htmls += '<div class="right-sec"><div class="right-secA"><h4>Customer Info</h4><table><tbody>';
                if (tokeninfo.length > 0) {
                    htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(tableinfo.CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>';
                    htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr>';
                    htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + tokeninfo[0].CustomerName + '"/><input type="hidden" id="txtCusID" value="' + tableinfo.CustomerId + '" /></td></tr>';
                    htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox" value="' + tokeninfo[0].Phone + '"/></td></tr>';
                    htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox" value="' + tokeninfo[0].Address + '"/></td></tr>';
                    htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                } else {
                    htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(tableinfo.CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>';
                    htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr>';
                    htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + tableinfo.CustomerName + '"/><input type="hidden" id="txtCusID" value="' + tableinfo.CustomerId + '" /></td></tr>';
                    htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox"/></td></tr>';
                    htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr>';
                    htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                }
               // htmls += '<tr><td>Delivered By : *</td><td><input type="text" id="txtDeliveredBy" class="sfInputbox"/></td></tr>';
                htmls += '<tr><td>Delivered By : *</td><td><select id="txtDeliveredBy" class="sfInputbox"></select></td></tr>';
                htmls += '</tbody></table></div><input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/></div></div>';

                htmls += ("</div></div></div></div>");
                htmls += ("<input id='Pay_" + tableinfo.TableId + "_" + tableinfo.OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
                var orderMasterId = tableinfo.OrderMasterId;
                $('#DialogOrderDetail').html(htmls);
                $('#txtPan').attr('autocomplete', 'off');

                companyProf.BindUsers();

                companyProf.BindBillingTerm(totalAmount, totaldis, datas);
                $('#billnoForSales').val(seatNo);
                $('#DialogOrderDetail').dialog(
               {

                   'title': 'Sales Bill',
                   width: DialogWidth,
                   modal: true,
                   dialogClass: 'CheckEnable unpaidd',
                   position: ['center', 'center']
               });
                if (tokeninfo.length > 0) {
                    if (tokeninfo[0].CustomerID > 0) {
                        companyProf.getmembershiplistbyId(tokeninfo[0].CustomerID);
                    }
                }

                $("#tblDiscount").on('click', ".txtdiscount, .txtnum", function (event) {
                    InitializeNumPin(this, $(this).val());
                });


                $('#billnoForSales').on('change', function () {
                    companyProf.BindSalesBill(result, parseInt($('#billnoForSales').val()));
                    seatNo = $('#billnoForSales').val();
                    sNo = seatNo;
                });

                $("#txtCardNumber").on('change', function () {
                    var info = $("#txtCardNumber").val();
                    if (info != "") {
                        companyProf.GetmemberInfo(info);
                    }
                });

                $("#txtNumber").on('change', function () {
                    var info = $("#txtNumber").val();
                    if (info != "") {
                        companyProf.GetmemberInfo(info);
                    }
                });
                $('.customerForCash').on('change', function () {
                    if ($('.customerForCash').prop('checked') == true) {
                        membershipfor = "PaymentLoyalty";
                        companyProf.GetCustomeronChange();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            resizable: true,
                            position: ['center', 'top']
                        });
                    } else {
                        $('#txtCusID').val(0);
                        $("#txtCashCusName").val("");
                        $("#txtCusAddress").val("");
                        $("#txtPan").val("");
                        $("#txtNumber").val("");
                        $("#txtCardNumber").val("");
                        $("#txtCashCusName").prop('disabled', false);
                        $("#txtCusAddress").prop('disabled', false);
                        $("#txtPan").prop('disabled', false);

                        $("#selDiscountType").val(1);
                        $("#selDiscountType").change();
                        $("#txtLoyaltyDiscount").val(0);

                    }
                })
                $("#selDiscountType").on('change', function () {
                    $('#txtKotDiscount').prop('disabled', false);
                    $('#txtBarDiscount').prop('disabled', false);
                    $('#txtRoomDiscount').prop('disabled', false);
                    $('#txtBakeryDiscount').prop('disabled', false);
                    $('#txtPizzaDiscount').prop('disabled', false);

                    $('#txtKotDiscount').val(0);
                    $('#txtBarDiscount').val(0);
                    $('#txtRoomDiscount').val(0);
                    $('#txtBakeryDiscount').val(0);
                    $('#txtPizzaDiscount').val(0);

                    $(".txt_dis").val(0);

                    barAmount = 0.00;
                    kotAmount = 0.00;
                    totalAmount = 0.00;
                    var totalAmountN = 0.00;
                    kotdis = 0.00;
                    bevdis = 0.00;
                    totaldis = 0;
                    bakeryAmount = 0.00;
                    bakerydis = 0.00;
                    pizzaAmount = 0.00;
                    pizzadis = 0.00;
                    $('.item-list-tbl tbody').html("");
                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        if (value.SeatNo == seatNo) {
                            var itms = "";

                            itms += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                            itms += ("<td>" + value.Quantity + "</td>");

                            if (!isab)
                                itms += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + value.Rate + "</td>");
                            else {
                                if (isAbbreviated) {
                                    itms += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + (value.Rate * (1 + v_rate / 100.0)).toFixed(2) + "</td>");

                                }
                                else {
                                    itms += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + value.Rate + "</td>");
                                }
                            }
                            amt = parseFloat(value.Quantity) * parseFloat(value.Rate);

                            //if (!isab) {
                            totalAmount += parseFloat(amt);
                            //}

                            if (!isab)
                                itms += ("<td class='item-amount'>" + amt + "</td></tr>");
                            else
                                itms += ("<td class='item-amount'>" + (amt * (1 + v_rate / 100.0)).toFixed(2) + "</td></tr>");



                            if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                                itms += ("<tr class='allsplited' style='font-size: 10px;font-style: italic;'><td></td><td colspan=3>");
                                qnty = 0;
                                rate = 0.00;
                                $.each(value.orderExtraItem, function (index, value) {
                                    itms += (value.ExtraItem) + "(" + value.Quantity + ", Rs." + ($("#selDiscountType").val() == "4" ? '1' : value.ExtraPrice) + "); ";
                                    qnty += value.Quantity;
                                    rate += parseFloat(value.Quantity * value.ExtraPrice);
                                });
                                itms += ("</td>");
                                //itms += ("</td><td>" + qnty + "</td>");
                                if ($("#selDiscountType").val() == "4") {
                                    //itms += ("<td class='item-rate'>" + 1 + "</td>");
                                    amt = parseFloat(qnty);
                                } else {
                                    //itms += ("<td class='item-rate'>" + rate + "</td>");
                                    amt = parseFloat(rate);
                                }
                                totalAmount += parseFloat(amt);

                                //console.log('totalAmount: ' + totalAmount);

                                itms += ("<td class='item-amount'>" + amt + "</td></tr>");


                            }
                            sn++;
                            $('.item-list-tbl tbody').append(itms);
                        }
                    });

                    totalAmount += roomAmount;

                    if (isab) {
                        if (isAbbreviated) {
                            totalAmountN = totalAmount * (1 + v_rate / 100);
                            $('.totle').text((totalAmountN).toFixed(2));

                        } else {
                            $('.totle').text((totalAmount - roomAmount).toFixed(2));
                        }
                    } else {

                        $('.totle').text((totalAmount - roomAmount).toFixed(2));
                    }


                    $('.roomtotle').text('Rs. ' + (totalAmount).toFixed(2));

                    if ($("#selDiscountType").val() == "3") {
                        if ($("#txtCusID").val() != "" && parseInt($("#txtCusID").val()) == 0) {
                            $('.customerForCash').prop('checked', true);
                            $('.customerForCash').change();
                        }
                        $("#txtLoyaltyDiscount").change();
                        $(".disc").hide();
                        $(".roomdisc").hide();
                        $(".loyaltydisc").show();
                    } else {
                        $(".disc").show();
                        if (tableinfo.RoomBookDetailsID > 0) {
                            $(".roomdisc").show();
                        }
                        $(".loyaltydisc").hide();
                    }


                    companyProf.BindBillingTerm(totalAmount, totaldis, datas);
                });

                $('#enablebtn').on('click', function () {
                    $('#hdnPinFor').val('enablebtn');
                    InitializePin();
                });

                $('.ui-dialog.CheckEnable').on('click', '.ui-dialog-titlebar .ui-dialog-titlebar-close', function () {
                    companyProf.GetUserName();

                });

                $("#txtLoyaltyDiscount").on('change', function () {
                    $('#txtKotDiscount').val(0);
                    $('#txtBarDiscount').val(0);
                    $('#txtRoomDiscount').val(0);
                    $('#txtBakeryDiscount').val(0);
                    $('#txtPizzaDiscount').val(0);
                    var lolDisRate = parseFloat($("#txtLoyaltyDiscount").val());
                    var totalAmountN = 0.00;

                    if (isab) {
                        if (isAbbreviated) {
                            var itemrow = $('#salesDetailsTbl').find('tr');
                            $.each(itemrow, function (index, value) {
                                _this = $(this);
                                var qty = parseFloat(_this.find('td').eq(2).text());
                                var rate = _this.find('td').eq(3);
                                var itemGroupId = rate.data('groupid');
                                var rateInt = parseFloat(rate.data('rate'));
                                var disAbb = parseFloat((rateInt * (100 - lolDisRate) / 100) * (1 + v_rate / 100));
                                rate.text(disAbb.toFixed(2))
                                _this.find('td').eq(4).text((qty * disAbb).toFixed(2))
                                totalAmountN += parseFloat(_this.find('td').eq(4).text());

                            });
                            // cgGroup.TotalDis = disRate;
                            $('.totle').text((totalAmountN).toFixed(2));
                        }
                    }

                    totaldis += ((totalAmount) * (lolDisRate) / 100);


                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });

                
                $('#txtRoomDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtRoomDiscount').val() > 100 || $('#txtRoomDiscount').val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtRoomDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtRoomDiscount').val() > roomAmount || $('#txtRoomDiscount').val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtRoomDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtRoomDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    companyProf.BindBillingTerm(totalAmount, totaldis, datas);
                });

                function getValue(that) {
                    var value = $(that).val();
                    if (!['', null, undefined].includes(value)) {
                        value = parseFloat(value);
                    } else {
                        value = 0;
                    }
                    return value;
                }

                $('.txt_dis').on('keyup', function () {

                    totalAmount = 0.00;
                    $.each(costCenterGroup, (i, v) => {
                        totalAmount += v.TotalAmt;
                    });

                    var totalAmountN = 0.00;
                    var currGroupId = $(this).data('groupid');
                    var currIndex = $(this).attr('id').split('_')[1];
                    var cgGroup = costCenterGroup.find(x => x.GroupId == currGroupId);
                    cgGroup.TotalDis = parseFloat(getValue(this));

                    if ($("#selDiscountType").val() == "1") {
                        if ((getValue(this)) > 100 || (getValue(this)) < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $(this).val(0);
                        }

                        var disRate = parseFloat(getValue(this) == "" ? 0 : getValue(this));
                        var dis = 0




                        //Bishal Added
                        if (isab) {
                            if (isAbbreviated) {


                                var itemrow = $('#salesDetailsTbl').find('tr');
                                $.each(itemrow, function (index, value) {
                                    _this = $(this);
                                    var qty = parseFloat(_this.find('td').eq(2).text());
                                    var rate = _this.find('td').eq(3);
                                    var itemGroupId = rate.data('groupid');
                                    var rateInt = parseFloat(rate.data('rate'));
                                    if (itemGroupId == currGroupId) {
                                        var disAbb = parseFloat((rateInt * (100 - disRate) / 100) * (1 + v_rate / 100));
                                        rate.text(disAbb.toFixed(2))
                                        _this.find('td').eq(4).text((qty * disAbb).toFixed(2))

                                    }
                                    totalAmountN += parseFloat(_this.find('td').eq(4).text());

                                });
                                // cgGroup.TotalDis = disRate;
                                $('.totle').text((totalAmountN).toFixed(2));

                            } //else {
                            $(".txt_dis").each(function () {
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat(getValue(this) / 100)));
                            })

                            totaldis = dis;
                            //}
                        } else {
                            $(".txt_dis").each(function () {
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat(getValue(this) / 100)));
                            })

                            totaldis = dis;
                        }




                        //totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    }
                    else {

                        if (getValue(this) > costCenterGroup[currIndex].TotalAmt || getValue(this) < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $(this).val(0);
                        }

                        var dis = 0


                        if (isab) {
                            if (isAbbreviated) {
                                var ttldis = parseFloat(getValue(this) == "" ? 0 : getValue(this));
                                var ttl = cgGroup.TotalAmt == "" ? 0 : cgGroup.TotalAmt;
                                var disPercent = 0.00;
                                if (ttldis > 0) {
                                    disPercent = (ttldis * 100) / ttl;
                                }
                                var itemrow = $('#salesDetailsTbl').find('tr');
                                $.each(itemrow, function (index, value) {
                                    _this = $(this);
                                    var qty = parseFloat(_this.find('td').eq(2).text());
                                    var rate = _this.find('td').eq(3);
                                    var itemGroupId = rate.data('groupid');
                                    var rateInt = parseFloat(rate.data('rate'));
                                    if (itemGroupId == currGroupId) {
                                        var disAbb = parseFloat((rateInt * (100 - disPercent) / 100) * (1 + v_rate / 100));
                                        rate.text(disAbb.toFixed(2))
                                        _this.find('td').eq(4).text((qty * disAbb).toFixed(2))

                                    }
                                    totalAmountN += parseFloat(_this.find('td').eq(4).text());

                                });
                                //cgGroup.TotalDis = ttldis;
                                $('.totle').text((totalAmountN).toFixed(2));

                            }

                            $(".txt_dis").each(function () {
                                dis += parseFloat(getValue(this));
                            })

                            totaldis = dis;


                        } else {
                            $(".txt_dis").each(function () {
                                dis += parseFloat(getValue(this));
                            })

                            totaldis = dis;

                        }

                    }

                    console.log(costCenterGroup);
                    companyProf.BindBillingTerm(totalAmount, totaldis, datas);
                })


                var roles = userRole.split(',');
                if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                    $("#enablebtn").hide();
                }
                else {
                    $("#selDiscountType").prop('disabled', true);
                    $(".txtdiscount").prop('disabled', true);
                    $("#enablebtn").show();
                }


                $("#generateBill").on('click', function () {
                    var myStr = $("#txtDeliveredBy").val();
                    var newStr = myStr.replace(/  +/g, ' ');
                    if (newStr.length <= 2) {
                        jAlert('Please Insert Valid Name', "Alert!!", function () { $.alerts.dialogClass = null; });
                    } else if (parseFloat($('#txtCharge').val()) <= 0) {
                        jConfirm('Do you want to give Free Delivery ?', 'Shift', function (confirmed) {
                            if (confirmed) {
                                $('#hdnPinFor').val('generateBill');
                                InitializePin();
                            }
                        });
                    }
                    else {
                    $('#hdnPinFor').val('generateBill');
                    InitializePin();
                    }
                
                });

                $('.paynows').unbind('click').on('click', function () {
                    jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                        if (confirmed) {
                            //var id = $(this).attr('id').split('_');
                            //console.log(orderdetails);
                            var billingTerm = new Array();
                            var salesMaster = new Object();
                            var splited = 0;
                            var salesDetail = new Array();

                            salesMaster.billNo = tableinfo.BillNo;
                            salesMaster.BillDate = new Intl.DateTimeFormat('en-US').format(new Date());
                            salesMaster.NepaliInvoiceDate = formatDate();
                            salesMaster.BasicAmount = (parseFloat($('.totalAfterDisc').val().split(' ')[1]));
                            salesMaster.RoomId = tableinfo.RoomId;
                            salesMaster.TableId = parseInt(tableinfo.TableId);
                            salesMaster.OrderMasterId = tableinfo.OrderMasterId;
                            salesMaster.totaldiscount = totaldis;
                            salesMaster.TermAmount = 0.00;
                            salesMaster.NetAmount = $('#txtNetAmt').val().split(' ')[1];
                            salesMaster.CusName = $('#txtCashCusName').val();
                            salesMaster.Address = $('#txtCusAddress').val();
                            salesMaster.PAN = $('#txtPan').val();
                            salesMaster.ChequeNo = "";
                            salesMaster.TransactionNo = "";
                            salesMaster.CusID = ($('#txtCusID').val() == "" ? 0 : parseInt($('#txtCusID').val()));
                            salesMaster.sumKot = kotAmount;
                            salesMaster.sumBev = barAmount;
                            salesMaster.Waiter = tableinfo.Waiter;
                            salesMaster.SPMID = 0;
                            salesMaster.IsSplit = (noOfGuest > 1 ? 1 : 0);
                            salesMaster.SeatNo = seatNo;
                            salesMaster.AddedBy = $('#hdnPinBy').val();
                            salesMaster.RoomRate = tableinfo.Rate;
                            salesMaster.BookedDays = tableinfo.BookedDays;
                            salesMaster.RoomCharge = roomAmount;
                            salesMaster.AdvancePayment = tableinfo.AdvancePayment;
                            salesMaster.sumBakery = bakeryAmount;
                            salesMaster.sumPizza = pizzaAmount;
                            salesMaster.DeliveryCharge = $('#txtCharge').val() == "" ? 0 : $('#txtCharge').val();
                            salesMaster.DeliveredBy = $('#txtDeliveredBy').val();
                            $.each(billingterms, function (index, value) {

                                if (document.getElementById('BTerm_' + value.ID + '_' + value.IsAdd) != null) {
                                    var bt = {
                                        ID: value.ID,
                                        Rate: value.Rate,
                                        IsAdd: value.IsAdd,
                                        Amount: $('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]
                                    }
                                    salesMaster.TermAmount += parseFloat($('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]);
                                    billingTerm.push(bt);
                                }
                            });
                            var bt = {
                                ID: 1,
                                Rate: 0,
                                IsAdd: false,
                                Amount: $('#txtNetAmt').val().split(' ')[1]
                            }
                            billingTerm.push(bt);

                            $.each(orderdetails, function (index, value) {
                                if (value.SeatNo == seatNo) {
                                    var extra = [];
                                    if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                                        $.each(value.orderExtraItem, function (index, item) {
                                            var ext = {
                                                ItemID: value.ROI_ItemId,
                                                ExtraItemID: item.ExtraItemID,
                                                ExtraItem: item.ExtraItem,
                                                Quantity: item.Quantity,
                                                Rate: ($('#selDiscountType').val() == "4" ? 1 : item.ExtraPrice),
                                                Amount: ($('#selDiscountType').val() == "4" ? (item.Quantity * 1) : (item.Quantity * item.ExtraPrice))
                                            }
                                            extra.push(ext);
                                        });
                                    };
                                    var sd = {
                                        ItemId: value.ROI_ItemId,
                                        qty: value.Quantity,
                                        rate: ($('#selDiscountType').val() == "4" ? 1 : value.Rate),
                                        Amount: ($('#selDiscountType').val() == "4" ? (value.Quantity * 1) : value.Amount),
                                        NetAmount: value.Amount,
                                        OrderDetailsID: value.OrderDetailsID,
                                        CostCenterId: value.CostCenterId,
                                        IsCombo: value.IsCombo,
                                        extraSales: extra
                                    }
                                    salesDetail.push(sd);
                                }
                            });
                            var discount = new Object();
                            discount.SalesMasterId = 0;
                            discount.kotdis = $('#txtKotDiscount').val();
                            discount.bardis = $('#txtBarDiscount').val();
                            discount.roomdis = $('#txtRoomDiscount').val();
                            discount.isflatdis = ($('#selDiscountType').val() == "2" ? true : false);
                            discount.isLoyalty = ($('#selDiscountType').val() == "3" ? true : false);
                            discount.loyaltydis = $('#txtLoyaltyDiscount').val();
                            discount.bakerydis = $('#txtBakeryDiscount').val();
                            discount.pizzadis = $('#txtPizzaDiscount').val();
                            discount.CCGroup = costCenterGroup;

                            companyProf.config.method = "SaveSalesBill";
                            companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                            companyProf.config.data = JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount });
                            companyProf.config.ajaxCallMode = 6;
                            companyProf.ajaxCall(companyProf.config);
                        }
                    });
                });
            },

            BindBillingTerm: function (totalAmount, totaldis, datas) {
                //Abb Change
                var isab = companyInfo.IsAbbreviated;
                let v_rate = companyInfo.VATRate;
                if (isab) {
                    if (!isAbbreviated) {
                        v_rate = 0.0;
                    }

                    if (totaldis == null || totaldis == "") {
                        totaldis = 0;
                    }
                }
                var htmls = "";
                $("#divBillingTerm").html(htmls);
                amntAfterDisc = 0;
                htmls += ("<table id='billingTerm'>");
                htmls += ("<tr>");
                if (!isab) {
                    htmls += (" <td attr-term='Total Discount' attr-percent='0' ><strong>Total Discount : </strong><input type=\"text\" value=\"Rs. " + parseFloat(totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
                    htmls += (" <td attr-term='Total' ><strong>Total : </strong><input type=\"text\" value=\"Rs. " + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "'/></td></tr>");
                }
                else {
                    if (isAbbreviated) {

                        htmls += (" <td attr-term='Total Discount' attr-percent='0' style='display: none;'><strong>Total Discount : </strong><input type=\"text\" value=\"Rs." + (totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
                        htmls += (" <td attr-term='Total' style='display: none;'><strong>Total : </strong><input type=\"text\" value=\"Rs. " + (totalAmount - totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (totalAmount - totaldis) + "'/></td></tr>");
                    } else {
                        htmls += (" <td attr-term='Total Discount' attr-percent='0' ><strong>Total Discount : </strong><input type=\"text\" value=\"Rs. " + (totaldis * (1 + v_rate / 100.0)).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
                        htmls += (" <td attr-term='Total' ><strong>Total : </strong><input type=\"text\" value=\"Rs. " + ((parseFloat(totalAmount) - parseFloat(totaldis)) * (1 + v_rate / 100.0)).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "'/></td></tr>");

                    }
                }
                amntAfterDisc = (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2);
                netAmount = 0.00;
                tlAmount = 0.00;
                deliveryCharge = 0.00;
                $.each(datas.billingTerm, function (index, item) {
                    {
                        if (item.BillTerm != "Evening Discount") {
                            if (item.BillTerm != "VAT") {
                                htmls += ("<tr>");
                                htmls += ("<td attr-term='" + item.BillTerm + "' attr-percent='" + item.Rate + "'  ><strong>" + item.BillTerm + " " + "(" + item.Rate + "%" + ")" + " : </strong>");
                                htmls += ("<input type=\"text\" id=\"BTerm_" + item.ID + "_" + item.IsAdd + "\" value=\"" + (item.IsAdd ? "" : "-") + "Rs. " + (amntAfterDisc * item.Rate / 100).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled  attr-amount='" + (amntAfterDisc * item.Rate / 100).toFixed(2) + "'/>");
                                htmls += ("</td>");
                                htmls += ("</tr>");
                                if (item.IsAdd == 1)
                                    tlAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                                else
                                    tlAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                            }
                        }
                    }
                });
                tlAmount = parseFloat((parseFloat(tlAmount) + parseFloat(amntAfterDisc)).toFixed(2));
                if (datas.VATforBill) {
                    if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {
                        if (!isab) {
                            htmls += ("<tr>");
                        }
                        else {
                            if (!isAbbreviated) {
                                htmls += ("<tr>");
                            }
                            else {
                                htmls += ("<tr style='display: none;'>");

                            }
                        }

                        //htmls += ("<tr>");
                        htmls += ("<td attr-term='Taxable Amount' attr-percent='0' ><strong>Taxable Amount : </strong><input type=\"text\" id=\"txtTaxableAmt\" value=\"Rs. " + tlAmount.toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + tlAmount.toFixed(2) + "'/></td>");
                        htmls += ("</tr>");
                        if (!isab) {
                            htmls += ("<tr>");
                        }
                        else {
                            if (!isAbbreviated) {
                                htmls += ("<tr>");
                            }
                            else {
                                htmls += ("<tr style='display: none;'>");

                            }
                        }

                        var vat = parseFloat(tlAmount * 0.13).toFixed(2);
                        htmls += ("<td attr-term='VAT' attr-percent='13' ><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + datas.billingTerm[datas.billingTerm.length - 1].ID + "_true" + "\"  value=\"Rs. " + vat + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + vat + "'/></td>");
                        tlAmount = (parseFloat(tlAmount) + parseFloat(vat)).toFixed(2);
                        htmls += ("</tr>");
                    }
                }
                netAmount = parseFloat(tlAmount) + parseFloat(deliveryCharge);
                htmls += ("<tr>");
                htmls += ("<td attr-term='Total Amount' attr-percent='0' ><strong>Total Amount : </strong>");
                htmls += ("<input type=\"text\" id=\"txtTotalAmt\" value=\"Rs. " + tlAmount + "\" class=\"sfInputbox_bill\" disabled attr-amount='" + tlAmount + "'/>");
                htmls += ("</tr>");
                htmls += ("<tr>");
                htmls += ("<td attr-term='Delivery Charge' attr-percent='0' ><strong>Delivery Charge : </strong>");
                htmls += ("<input type=\"text\" id=\"txtCharge\" value=\ " + deliveryCharge + " class=\"sfInputbox_bill\" attr-amount='" + deliveryCharge + "' />");
                htmls += ("</tr>");
                htmls += ("<tr>");

                if (!isab) {
                    htmls += ("<tr>");
                }
                else {
                    if (!isAbbreviated) {
                        htmls += ("<tr>");
                    }
                    else {
                        htmls += ("<tr>");

                    }
                }


                htmls += ("<td attr-term='Net Amount' attr-percent='0' ><strong>Net Amount : </strong>");
                htmls += ("<input type=\"text\" id=\"txtNetAmt\" value=\"Rs. " + netAmount + "\" class=\"sfInputbox_bill\" disabled attr-amount='" + netAmount + "'/>");
                htmls += ("</td>");
                htmls += ("</tr>");
                if (datas.RoomBooking.RoomBookDetailsID > 0) {
                    htmls += ("<tr>");
                    htmls += ("<td attr-term='Advance Payment' ><strong>Advance Payment : </strong>");
                    htmls += ("<input type=\"text\" id=\"txtAdvancePay\" value=\"Rs. " + datas.RoomBooking.AdvancePayment.toFixed(2) + "\" class=\"sfInputbox_bill\" disabled />");
                    htmls += ("</td>");
                    htmls += ("</tr>");
                    htmls += ("<tr>");
                    htmls += ("<td attr-term='Remaining Amount' ><strong>Remaining Amount : </strong>");
                    htmls += ("<input type=\"text\" id=\"txtRemaining\" value=\"Rs. " + (netAmount - datas.RoomBooking.AdvancePayment).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled />");
                    htmls += ("</td>");
                    htmls += ("</tr>");
                }
                htmls += ("</table>");

                $("#divBillingTerm").html(htmls);

                $('#txtCharge').on('keyup', function (event) {
                    var txtTotalAmt = $('#txtTotalAmt').val().split(' ')[1];
                    var delieveryCharge = $('#txtCharge').val() == "" ? 0 : $('#txtCharge').val();
                    if (parseFloat(delieveryCharge) > parseFloat(txtTotalAmt))
                    {
                        jAlert("Delivery Charge must not be greater than Total Amount");
                        $('#txtCharge').val(0);
                    }
                    else {
                      
                        var netAmount = parseFloat(txtTotalAmt) + parseFloat(delieveryCharge);
                        $('#txtNetAmt').val("Rs. " + netAmount.toFixed(2));
                    }
                   
                    
                });
            },

            Bindmembership: function (data) {
                $("#membeshipformlist").html('');
                var datas = JSON.parse(data.d);
                if (datas.length > 0) {
                    var htmls = "<table id='BDtable' class='BookedTable-list display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Select</th><th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.CardNumber + "'>";
                        htmls += "<td>" + "<img src='/images/completed.png' class='BrandDelete' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.CardNumber + "' value='Delete'  /></td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        htmls += "</tr>"
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#BDtable').DataTable(
                         {
                             jQueryUI: true,
                             ordering: false,

                         });

                } else {
                    $('#membeshipformlist').html('No data');
                }

                $(".dataTables_scrollBody").css('height', '100%');

            },
            GetBill: function (salesMasterId) {           
                getBill(salesMasterId, false);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'center']
                });

                $('#btnPrints').unbind('click').on('click', function () {
                    //companyProf.print();
                    $('#divPrintedOn').text(formatAMPM());
                    companyProf.config.method = "savePrintCount";
                    companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                    companyProf.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                    });
                    companyProf.config.ajaxCallMode = 7;
                    companyProf.ajaxCall(companyProf.config);
                });
            },

            CancelOrderedData: function () {
                var id = OrderMasterID;
                var cancel = false;
                var ordermaster = new Object();
                ordermaster.TableId = 0,
                ordermaster.OrderMasterID = OrderMasterID,
                ordermaster.GuestNo = parseInt($('#splitNoCancel').val());
                ordermaster.CancelReason = $("#canceltextarea").val();
                ordermaster.CancelBy = $('#hdnPinBy').val();
                ordermaster.UserName = $('#hdnPinBy').val();
                ordermaster.IsCancelled = true,
                companyProf.config.method = "CancelOrderIntoDataBase";
                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster });
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = jsonText;
                companyProf.config.ajaxCallMode = 10;
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.ID = id;

            },
            Reset: function () {
                companyProf.GetOrderDeliveryList();
                companyProf.GetUserName();
                companyProf.GetUnpaidBills();
                companyProf.GetOrderDeliveredList();
                $(".ui-dialog-content").dialog("close");
            },
        };
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);




