
(function ($) {
    $.companyOrderItemcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Billing/',
                 HostUrl: '',
                 sentdata: '',
                 roomdata: '',
                 OID: ''
             }, p);
        var v = 0;
        var OrderMasterID = 0;
        var OrderListArray = new Array();
        var NewOrderListArray = new Array();
        var activeorder = 0;
        var noOfGuest = 1;
        var selectedBillNo = 1;
        var isSplit = 0;
        var Note = "";
        var ExtraCharge = 0.0;
        var RoomId = 0;
        var OID=0;
        var TableId = 0;
        var IsCanceled = 0;
        var status = "";
        var OrderItemFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 
                dataType: 'json',
                baseURL: p.ModulePath + "services/OrderItemWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MenuId: 0,
                Menuupdate: 0


            },

            init: function () {
                //OrderItemFunction.GetPreviousItemByID();
                OrderItemFunction.GetMenuforOrder();
                //OrderItemFunction.GetRoomAndTable();
                $('#SendOrder').on('click', function () {
                    OrderItemFunction.SaveOrderedData();
                });
                $('#CancelOrder').on('click', function () {
                    OrderItemFunction.CancelOrderedData();
                    var url = p.HostUrl;
                    window.location.href = url;
                });


                $('#splitcheckbox').on('click', function () {
                    $('.splitdiv').toggle();
                    if (isSplit == 0) {
                        isSplit = 1;
                    } else {
                        isSplit = 0;
                    }
                });

                //$('.splitMainView').hide();
                $('#NoOfBill').on('click', function () {
                    $('.billdialogue').html('');
                    var htmls = '';
                    htmls += '<div id="dialog-form">';
                    //htmls += '<p class="validateTips">Please Enter No Of Guest To Split the Bill</p>';
                    htmls += '<form>';
                    htmls += '<fieldset>';
                    htmls += '<label for="name">Number:</label>';
                    htmls += '<input type="text"  id="noofguesttxtbox" class="text ui-widget-content ui-corner-all">';
                    //htmls += '<input type="submit" tabindex="-1" style="position:absolute; top:-1000px">';
                    htmls += '</fieldset>';
                    htmls += '</form>';
                    htmls += '</div>';
                    $('.billdialogue').html(htmls);
                    $('#noofguesttxtbox').val(noOfGuest);

                    $('.billdialogue').dialog(
                     {
                         'title': 'Split Bill',
                         "resize": "auto",
                         width: 300,
                         buttons: {
                             "Submit": function () {
                                 if ($('#noofguesttxtbox').val() == 0 || $('#noofguesttxtbox').val() == "") {
                                     noOfGuest = 1;
                                 } else {
                                     noOfGuest = $('#noofguesttxtbox').val();
                                 }

                                 $('#billno').html('');
                                 var newhtml = '';
                                 for (var i = 1; i <= noOfGuest; i++) {
                                     newhtml += "<option value=" + i + ">" + i + "</option>";
                                 }
                                 $('#billno').html(newhtml);
                                 $(this).dialog('close');
                             },
                             Cancel: function () {
                                 $(this).dialog('close');
                             }
                         }
                     });


                    $('#billno').change(function () {
                        selectedBillNo = $('#billno').val();
                        $(".bindorderlist").html('');
                        var htmls;
                        var i = 1;

                        $.each(OrderListArray, function (index, item) {
                            // if (item.SeatNo == selectedBillNo && item.GuestNo == selectedBillNo) {
                            if (item.SeatNo == selectedBillNo) {
                                //htmls += "<tr>";
                                htmls += "<tr id='tr_" + item.ItemId + "'>";
                                htmls += "<td>" + i + "</td>";
                                htmls += "<td>" + item.ItemName + "</td>";
                                htmls += "<td><input type='button' value='-' class='qtyminus sfBtn' field='qty_" + item.ItemId + "' />";
                                htmls += "<input type='text' id='qty_" + item.ItemId + "' value='" + item.Quantity + "' class='qty' width='20px' />";
                                htmls += "<input type='button' value='+' class='qtyplus sfBtn' field='qty_" + item.ItemId + "' /></td>";
                                //htmls += "<td><span id='minus_" + item.ItemId + "' class='minus sfBtn'> - </span> <span id='qty_" + item.ItemId + "' class='qty'>1</span><span id='plus_" + item.ItemId + "' class='plus sfBtn'> + </span></td>";
                               // htmls += "<td><img src='/images/extra.png' class='extra' width='20px' height='20px'/></td>";
                                htmls += "<td><span class='status'>Ordered</span></td>";
                                htmls += "<tr>";
                                i = i + 1;
                            //} else {
                            //    if (i <= 1) {
                            //        htmls += "<tr><td>No Item ordered in Splited Guest No" + selectedBillNo + "</td></tr>";
                            //        i = i + 1;
                            //    }

                            }

                        });

                        $(".bindorderlist").html(htmls);
                    });
                    if (p.sentData != 0 || p.roomData) {
                        $('.splitMainView').show();
                    }

                });

            },
            ajaxCall: function (config) {
                $.ajax({
                    type: OrderItemFunction.config.type,
                    contentType: OrderItemFunction.config.contentType,
                    async: OrderItemFunction.config.async,
                    cache: OrderItemFunction.config.cache,
                    url: OrderItemFunction.config.url,
                    data: OrderItemFunction.config.data,
                    dataType: OrderItemFunction.config.dataType,
                    success: OrderItemFunction.ajaxSuccess,
                    error: OrderItemFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(OrderItemFunction.config.ajaxCallMode)) {
                    case 0:
                        OrderItemFunction.bindMenuforOrder(data);
                        break;
                    case 1:
                        OrderItemFunction.BindGetCategoriesBymenuID(data);
                        break;
                    case 2:
                        OrderItemFunction.BindItemByCategoryID(data);
                        break;
                    case 3:
                        OrderItemFunction.BindPreviousOrderByID(data);
                        break;
                    case 4:
                        alert("Ordered Cancelled successfully");
                        //var id = OrderItemFunction.config.ID;
                        //$("#" + id + "_").remove();
                        break;
                    case 5:
                        alert("Ordered Saved successfully");
                        var url = p.HostUrl;
                        window.location.href = url;
                    case 6:
                        var id = OrderItemFunction.config.ID;
                        $("#" + id + "_").remove();
                        //
                        //    OrderItemFunction.BindRoomAndTable(data);
                        //    break;
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            OrderMaster: function OrderMaster() {
                this.OrderDetailList = OrderItemFunction.OrderDetails


            },

            //SaveOrderedData

            CancelOrderedData: function () {
                var id = OrderMasterID;
                var cancel = false;
                var ordermaster = new Object();
                if (parseInt(p.OID) == 0) {
                    ordermaster.TableId = TableId
                    ordermaster.RoomId = RoomId
                }
                else {
                    ordermaster.TableId = 0,
                    ordermaster.RoomId = 0,
                    ordermaster.OID = parseInt(p.OID);
                }
                ordermaster.OrderMasterID = OrderMasterID, 
                ordermaster.IsCancelled = true,
                
                OrderItemFunction.config.method = "CancelOrderIntoDataBase";

                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster });
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = jsonText;
                OrderItemFunction.config.ajaxCallMode = 4;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
                //eventFunction.config.ajaxCallMode = 3;
                OrderItemFunction.config.ID = id;
                //eventFunction.ajaxCall(eventFunction.config);

            },

            SaveOrderedData: function () {
                var billpd = false;
                var splited = false;
                var cancel = false;
                if (isSplit != 0) {
                    splited = true;
                }
                //OrderListArray=OrderListArray.concat(NewOrderListArray);
                var orders = [];
                var orderDetailsList = new Array();
                for (var i = 0; i < OrderListArray.length; i++) {
                    var orderDetail = new Object();
                    orderDetail.OrderDetailsID = OrderListArray[i].OrderDetailsID,
                    orderDetail.Quantity = OrderListArray[i].Quantity,
                    orderDetail.ItemId = OrderListArray[i].ItemId,
                    orderDetail.Rate = 0.0,
                    orderDetail.IsCancelled = cancel,
                    orderDetail.Note = OrderListArray[i].Note,
                    orderDetail.ExtraCharge = OrderListArray[i].ExtraCharge
                    orderDetail.SeatNo = OrderListArray[i].SeatNo

                    //orderDetail.SeatNo = noOfGuest[i];
                    orderDetail.Status = OrderListArray[i].Status,
                    orderDetail.Amount = 0.0
                    orderDetailsList.push(orderDetail);
                }
                var ordermaster = new Object();

                //var OrderMasterInf =[];
                
                ordermaster.orderDetailsList = orderDetailsList,
                ordermaster.OrderMasterID = OrderMasterID
                if (parseInt(p.OID)== 0)
                {
                    ordermaster.TableId = TableId
                    ordermaster.RoomId = RoomId
                }
                else{
                    ordermaster.TableId = 0,
                    ordermaster.RoomId = 0,
                    ordermaster.OID = parseInt(p.OID);
                }
                ordermaster.BasicAmount = 0.0,
                ordermaster.BillNo = "",
                ordermaster.Date = Date.now,
                ordermaster.IsCancelled = cancel,
                ordermaster.TermAmount = 0.0,
                ordermaster.NetAmount = 0.0,
                ordermaster.UserName = SageFrameUserName,
                ordermaster.Remarks = "",
                ordermaster.IsSplit = splited,
                ordermaster.GuestNo = noOfGuest,
                ordermaster.BillPaid = 0
                


                //OrderMasterInf.push(ordermaster);

                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster });
                OrderItemFunction.config.method = "SaveOrderIntoDataBase";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = jsonText;
                OrderItemFunction.config.ajaxCallMode = 5;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },


            GetMenuforOrder: function () {
                OrderItemFunction.config.method = "GetMenuforOrder1";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({pitId:0,level:1});
                OrderItemFunction.config.ajaxCallMode = 0;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },

            GetCategoriesBymenuID: function (menuid) {
                OrderItemFunction.config.method = "GetCategoriesBymenuID";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({
                    MenuId: menuid
                });
                OrderItemFunction.config.ajaxCallMode = 1;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },

            GetItemByCategoryID: function (categoryId) {
                OrderItemFunction.config.method = "GetItemByCategoryID";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({
                    CategoriesID: categoryId
                });
                OrderItemFunction.config.ajaxCallMode = 2;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            GetPreviousItemByID: function () {
                OrderItemFunction.config.method = "GetPreviousItemByID";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({
                    Id: parseInt(p.sentData),
                    RId: parseInt(p.roomData),
                    OID:parseInt(p.OID),
                });
                OrderItemFunction.config.ajaxCallMode = 3;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },

            //GetRoomAndTable: function () {
            //    OrderItemFunction.config.method = "GetRoomAndTable";
            //    OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
            //    OrderItemFunction.config.data = JSON2.stringify({
            //        Id: parseInt(p.sentData),
            //        RId: parseInt(p.roomData),
            //    });
            //    OrderItemFunction.config.ajaxCallMode = 5;
            //    OrderItemFunction.ajaxCall(OrderItemFunction.config);

            //},            

            //----------------------------->>>>>>       Binding part     <<<<<<<<<<<<--------------------------

            //BindRoomAndTable: function (result) {
            //    var htmls = [];
            //    //$('#Menushow').html("");
            //    var datas = result.d;
            //    $('#OLroomname').text(item.room);
            //    $('#OLTablename').text(item.restrotableTitle);
            //    $('#Menushow').html(htmls);
            //},



            BindPreviousOrderByID: function (sentdata) {
                var datas = sentdata.d;
                var htmls;
                var i = 1;
                //var result = $.grep(OrderListArray, function (e) { return e.ItemId == values[1] && e.SeatNo == selectedBillNo && e.GuestNo == selectedBillNo; });

                if (sentdata.d.length > 0 || roomd) {
                    $.each(datas, function (index, item) {

                        $('#OLroomname').text(item.room);
                        $('#OLTablename').text(item.restrotableTitle);
                        RoomId = item.RoomId;
                        TableId = item.TableId;

                        if (item.ItemID != 0) {
                            var order = new Object();
                            order.ItemId = item.ItemID
                            order.ItemName = item.ItemName;
                            order.Quantity = item.Quantity;
                            order.Note = item.Note;
                            order.ExtraCharge = item.ExtraCharge;
                            order.SeatNo = item.SeatNo;
                            order.GuestNo = item.GuestNo;
                            order.IsSplit = item.IsSplit;
                            order.RoomId = item.RoomId;
                            order.TableID = item.TableId;
                            order.Remarks = item.Remarks;
                            order.IsCancelled = item.IsCancelled;
                            order.Status = 'Ordered'
                            order.OrderDetailsID = item.OrderDetailsID;
                            OrderListArray.push(order);

                            //$('#OLroomname').text(item.RoomId);
                            //$('#OLTablename').text(item.TableId);



                            isSplit = item.IsSplit;
                            noOfGuest = item.GuestNo;

                            if ($('#billno').val() != 0) {
                                selectedBillNo = $('#billno').val();
                            }
                            else {
                                selectedBillNo = 1;
                            }
                            Note = "";
                            ExtraCharge = 0.0;
                            //RoomId = item.RoomId;
                            //TableId = item.TableId;
                            IsCanceled = 0;
                            status = "";
                            OrderMasterID = item.OrderMasterId;

                            $(".bindorderlist").html('');

                            //htmls += "<tr>";
                            htmls += "<tr id='tr_" + item.ItemID + "'>";
                            htmls += "<td>" + i + "</td>";
                            htmls += "<td>" + item.ItemName + "</td>";
                            htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemID + "' />";
                            htmls += "<input type='text' id='qty_" + item.ItemID + "' value='" + item.Quantity + "' class='qty' width='20px' />";
                            htmls += "<input type='button' value='+' id='plus_" + index + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemID + "' /></td>";
                            //htmls += "<td><span id='minus_" + item.ItemId + "' class='minus sfBtn'> - </span> <span id='qty_" + item.ItemId + "' class='qty'>1</span><span id='plus_" + item.ItemId + "' class='plus sfBtn'> + </span></td>";
                            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "' src='/images/extra.png' class='extra' width='60px' height='60px' /></td>";
                            htmls += "<td><span class='status'>Ordered</span></td>";
                            htmls += "<tr>";
                            i = i + 1;
                        }
                    });

                } else {
                    //OrderItemFunction.GetRoomAndTable();
                    $('#OLroomname').text(p.roomData);
                    $('#OLTablename').text(p.sentData);
                    RoomId = p.roomData;
                    TableId = p.sentData;
                }


                $(".bindorderlist").html(htmls);

                $('.extra').on('click', function () {

                    $('.extradiv').html('');
                    var htmls = '';
                    //html += '<div id="dialog-form" title="Create new user">';
                    //htmls += '<p class="validateTips">Please Enter No Of Guest To Split the Bill</p>';
                    htmls += '<form>';
                    htmls += '<fieldset>';
                    htmls += '<label for="name">Note:</label>';
                    htmls += '<textarea id="extranote" class="text ui-widget-content ui-corner-all"></textarea>';
                    htmls += '<label for="name">ExtraCharge:</label>';
                    htmls += '<input type="text"  id="extracharge" class="text ui-widget-content ui-corner-all">';
                    htmls += '</fieldset>';
                    htmls += '</form>';
                    //html += '</div>';

                    $('.extradiv').html(htmls);

                    var index = $(this).attr('id');
                    var splitindex = index.split('_');

                    $('#extranote').val(OrderListArray[parseInt(splitindex[1])].Note);
                    $('#extracharge').val(OrderListArray[parseInt(splitindex[1])].ExtraCharge);

                    $('.extradiv').dialog(
                     {
                         'title': 'Extra Details',
                         "resize": "auto",
                         width: 300,
                         buttons: {
                             "Submit": function () {
                                 OrderListArray[parseInt(splitindex[1])].Note = $('#extranote').val();
                                 OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('#extracharge').val());
                                 $(this).dialog('close');
                             },
                             Cancel: function () {
                                 $('#extranote').val('');
                                 $('#extracharge').val('');
                                 $(this).dialog('close');
                             }
                         }
                     });


                });



                $('.qtyplus').click(function (e) {
                    // Stop acting like a button
                    e.preventDefault();
                    // Get the field name
                    fieldName = $(this).attr('field');
                    var index = $(this).attr('id');
                    var splitindex = index.split('_')
                    // Get its current value
                    var currentVal = parseInt($('#' + fieldName).val());
                    // If is not undefined
                    if (!isNaN(currentVal)) {
                        // Increment
                        $('#' + fieldName).val(currentVal + 1);
                    } else {
                        // Otherwise put a 0 there
                        $('#' + fieldName).val(0);
                    }

                    var last = $('#' + fieldName).val();

                    OrderListArray[parseInt(splitindex[1])].Quantity = last;

                    OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(splitindex[2]);
                    OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
                });
                // This button will decrement the value till 0
                $(".qtyminus").click(function (e) {
                    // Stop acting like a button
                    e.preventDefault();
                    // Get the field name
                    fieldName = $(this).attr('field');
                    var index = $(this).attr('id');
                    var splitindex = index.split('_')
                    // Get its current value
                    var currentVal = parseInt($('#' + fieldName).val());
                    // If it isn't undefined or its greater than 0
                    if (!isNaN(currentVal) && currentVal > 0) {
                        // Decrement one
                        $('#' + fieldName).val(currentVal - 1);
                    } else {
                        // Otherwise put a 0 there
                        $('#' + fieldName).val(0);
                    }
                    if (currentVal == 1) {
                        var itemrow = fieldName.split('_');
                        var row = itemrow[1];
                        //var id = OrderItemFunction.config.ID;
                        $("#tr_" + row).remove();


                        $.each(OrderListArray, function (i) {
                            if (OrderListArray[i].ItemId == row) {
                                OrderListArray.splice(i, 1);
                                return false;
                            }
                        });

                        //jQuery.grep(OrderListArray, function (value) {
                        //    return value.ItemId != 'Kristian';
                        //});
                        //$.each(OrderListArray, function (index, item) {
                        //    if (item.ItemId == row) {
                        //        ispresent = 1;
                        //        result = 0;
                        //    }
                        //});
                    }
                    else {
                        var last = $('#' + fieldName).val();
                        OrderListArray[parseInt(splitindex[1])].Quantity = last;
                        OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(splitindex[2]);
                        OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
                    }
                });
            },

            bindMenuforOrder: function (result) {
                var htmls = [];
                $('#Menushow').html("");
                var datas = result.d;
                htmls += "<h4>  Menus </h4>";
                if (datas.length > 0) {

                    htmls += "<div class='menus'>";
                    $.each(datas, function (index, value) {

                        //htmls += "<div><img id='menuimg_" + value.MenuID + "' class='menuimg'  src='/Modules/ROMenu/images/Chrysanthemum.jpg" + value.PhotoPath + "' width='150px' height='120px' alt='Item_Image'>";
                        htmls += "<div><img id='menuimg_" + value.ItemId +"' class='menuimg'  src='/Modules/ROMenu/images/Chrysanthemum.jpg' width='150px' height='120px' alt='Item_Image'>";
                        htmls += "<label class='itmname'>" + value.ItemName + "</label></div>";

                    });
                    htmls += "</div>";
                    $('#Menushow').html(htmls);


                } else {
                    htmls += "<h6>No Menu Available </h6>";
                    $('#Menushow').html(htmls);
                }

                $('.menus').owlCarousel({

                    navigation: true,
                    addClassActive: true
                });




                $('.menuimg').on('click', function () {
                    var data = $(this).attr('id');
                    var values = data.split('_');
                    //var level = 1;
                    OrderItemFunction.GetCategoriesBymenuID(parseInt(values[1]));

                });
            },


            BindGetCategoriesBymenuID: function (result) {
                var htmls = [];
                $('#Categoryshow').html("");
                $('#Itemshow').html("");
                var datas = result.d;
                htmls += "<h4> Categories </h4>";
                if (datas.length > 0) {

                    htmls += "<div class='category'>";
                    $.each(datas, function (index, value) {

                        htmls += "<div><img id='categoryimg_" + value.CategoriesID + "' class='categoryimg'  src='/Modules/ROCategory/images/" + value.PhotoPath + "' width='150px' height='120px'>";
                        htmls += "<label class='itmname'>" + value.CategoriesName + "</label></div>";

                    });
                    htmls += "</div>";
                    $('#Categoryshow').html(htmls);


                } else {
                    htmls += "<h6>No category Available in this Section</h6>";
                    $('#Categoryshow').html(htmls);
                }


                $('.category').owlCarousel({

                    navigation: true,
                    addClassActive: true
                });


                $('.categoryimg').on('click', function () {
                    var data = $(this).attr('id');
                    var values = data.split('_');

                    OrderItemFunction.GetItemByCategoryID(parseInt(values[1]));

                });
            },



            BindItemByCategoryID: function (result) {
                var htmls = [];
                $('#Itemshow').html("");
                var datas = result.d;
                htmls += "<h4>  Items </h4>";
                if (datas.length > 0) {

                    htmls += "<div class='items'>";
                    $.each(datas, function (index, value) {

                        htmls += "<div><img id='itemimg_" + value.ItemID + "_" + value.ItemName + "' class='itemimg'  src='/Modules/ROItem/images/" + value.PhotoPath + "' width='150px' height='120px'>";
                        htmls += "<label class='itmname'>" + value.ItemName + "</label></div>";

                    });
                    htmls += "</div>";
                    $('#Itemshow').html(htmls);
                } else {
                    htmls += "<h6>No Items Available in this Section</h6>";
                    $('#Itemshow').html(htmls);
                }
                $('.items').owlCarousel({

                    navigation: true,
                    addClassActive: true
                });

                $('.itemimg').on('click', function () {
                    var data = $(this).attr('id');
                    var values = data.split('_');
                    var ispresent = 1;
                    var result = 0;
                    $.each(OrderListArray, function (index, item) {
                        if (item.ItemId == values[1]) {
                            ispresent = 0;
                            result = 1;

                        }

                    });
                    //var result = $.grep(OrderListArray, function (e) { return e.ItemId == values[1] && e.SeatNo == selectedBillNo && e.GuestNo == selectedBillNo; });

                    if (result == 0) {
                        var order = new Object();
                        order.ItemId = parseInt(values[1]);
                        order.ItemName = values[2];
                        order.Quantity = 1;
                        order.Note = "";
                        order.ExtraCharge = 0.0;
                        order.SeatNo = selectedBillNo;
                        order.GuestNo = 1;
                        order.IsSplit = 0;
                        order.RoomId = p.roomData;
                        order.TableId = p.sentData;
                        //order.RoomId = $('#OLroomname').val();
                        //order.TableID = $('#OLTablename').val();
                        order.Remarks = "";
                        order.IsCancelled = 0;
                        order.Status = 'Ordered'
                        order.OrderDetailsID = 0;
                        //NewOrderListArray.push(order);
                        //var newOrderList = new Array();
                        //newOrderList.push(order);
                        //OrderListArray=OrderListArray.concat(NewOrderListArray);
                        OrderListArray.push(order);
                        //alert(JSON2.stringify(OrderListArray));
                        $(".bindorderlist").html('');

                        var htmls;
                        var i = 1;

                        $.each(OrderListArray, function (index, item) {
                            //if (item.SeatNo == selectedBillNo && item.GuestNo == selectedBillNo) {
                            htmls += "<tr id='tr_" + item.ItemId + "'>";
                            htmls += "<td>" + i + "</td>";
                            htmls += "<td>" + item.ItemName + "</td>";
                            htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemId + "' />";
                            htmls += "<input type='text' id='qty_" + item.ItemId + "' value='" + item.Quantity + "' class='qty' width='20px' />";
                            htmls += "<input type='button' value='+' id='plus_" + index + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemId + "' /></td>";
                            //htmls += "<td><span id='minus_" + item.ItemId + "' class='minus sfBtn'> - </span> <span id='qty_" + item.ItemId + "' class='qty'>1</span><span id='plus_" + item.ItemId + "' class='plus sfBtn'> + </span></td>";
                            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "' src='/images/extra.png' class='extra' width='60px' height='60px'/></td>";
                            htmls += "<td><span class='status'>Ordered</span></td>";
                            htmls += "<tr>";
                            i = i + 1;
                            //}
                        });

                        $(".bindorderlist").html(htmls);

                        $('.extra').on('click', function () {

                            $('.extradiv').html('');
                            var htmls = '';
                            //html += '<div id="dialog-form" title="Create new user">';
                            //htmls += '<p class="validateTips">Please Enter No Of Guest To Split the Bill</p>';
                            htmls += '<form>';
                            htmls += '<fieldset>';
                            htmls += '<label for="name">Note:</label>';
                            htmls += '<textarea id="extranote" class="text ui-widget-content ui-corner-all"></textarea>';
                            htmls += '<label for="name">ExtraCharge:</label>';
                            htmls += '<input type="text"  id="extracharge" class="text ui-widget-content ui-corner-all">';
                            htmls += '</fieldset>';
                            htmls += '</form>';
                            //html += '</div>';
                            $('.extradiv').html(htmls);

                            var index = $(this).attr('id');
                            var splitindex = index.split('_');

                            $('#extranote').val(OrderListArray[parseInt(splitindex[1])].Note);
                            $('#extracharge').val(OrderListArray[parseInt(splitindex[1])].ExtraCharge);

                            $('.extradiv').dialog(
                             {
                                 'title': 'Extra Details',
                                 "resize": "auto",
                                 width: 300,
                                 buttons: {
                                     "Submit": function () {
                                         OrderListArray[parseInt(splitindex[1])].Note = $('#extranote').val();
                                         OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('#extracharge').val());
                                         $(this).dialog('close');
                                     },
                                     Cancel: function () {
                                         $('#extranote').val('');
                                         $('#extracharge').val('');
                                         $(this).dialog('close');
                                     }
                                 }
                             });

                        });



                        $('.qtyplus').click(function (e) {
                            // Stop acting like a button
                            e.preventDefault();
                            // Get the field name
                            fieldName = $(this).attr('field');
                            var index = $(this).attr('id');
                            var splitindex = index.split('_')
                            // Get its current value
                            var currentVal = parseInt($('#' + fieldName).val());
                            // If is not undefined
                            if (!isNaN(currentVal)) {
                                // Increment
                                $('#' + fieldName).val(currentVal + 1);
                            } else {
                                // Otherwise put a 0 there
                                $('#' + fieldName).val(0);

                            }
                            var last = $('#' + fieldName).val();

                            OrderListArray[parseInt(splitindex[1])].Quantity = last;

                            OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(splitindex[2]);
                            OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
                        });
                        // This button will decrement the value till 0
                        $(".qtyminus").click(function (e) {
                            // Stop acting like a button
                            e.preventDefault();
                            // Get the field name
                            fieldName = $(this).attr('field');
                            var index = $(this).attr('id');
                            var splitindex = index.split('_')
                            // Get its current value
                            var currentVal = parseInt($('#' + fieldName).val());
                            // If it isn't undefined or its greater than 0
                            if (!isNaN(currentVal) && currentVal > 0) {
                                // Decrement one
                                $('#' + fieldName).val(currentVal - 1);
                            } else {
                                // Otherwise put a 0 there
                                $('#' + fieldName).val(0);
                            }

                            if (currentVal == 1) {
                                var itemrow = fieldName.split('_');
                                var row = itemrow[1];
                                //var id = OrderItemFunction.config.ID;
                                $("#tr_" + row).remove();



                                $.each(OrderListArray, function (i) {
                                    if (OrderListArray[i].ItemId == row) {
                                        OrderListArray.splice(i, 1);
                                        return false;
                                    }
                                });
                                //$.each(OrderListArray, function (index, item) {

                                //sugar.js
                                //                                OrderListArray.remove(function (el) {
                                //                                    return el.ItemId === row;
                                //                                });



                                //    if (item.ItemId == values[1]) {
                                //        ispresent = 1;
                                //        result = 0;
                                //    }
                                //});
                            }
                            else {
                                var last = $('#' + fieldName).val();
                                OrderListArray[parseInt(splitindex[1])].Quantity = last;
                                OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(splitindex[2]);
                                OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
                            }


                        });
                    } else {
                        alert('Item Already Entered Please increase the Quantity');
                    }

                    $('.splitMainView').show();


                });
            },






        };
        OrderItemFunction.init();
    };
    $.fn.companyOrderItemEDIT = function (p) {
        $.companyOrderItemcreate(p);
    };
})(jQuery);