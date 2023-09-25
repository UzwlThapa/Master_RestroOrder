var orderlistviewtype = JSON.parse(localStorage.getItem("ordermenulisttype"));
function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}
function validateFloatKeyPress(el, evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    var number = el.value.split('.');
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    //just one dot (thanks ddlab)
    if (number.length > 1 && charCode == 46) {
        return false;
    }
    //get the carat position
    var caratPos = getSelectionStart(el);
    var dotPos = el.value.indexOf(".");
    if (caratPos > dotPos && dotPos > -1 && (number[1].length > 1)) {
        return false;
    }
    return true;
}

function getSelectionStart(o) {
    if (o.createTextRange) {
        var r = document.selection.createRange().duplicate()
        r.moveEnd('character', o.value.length)
        if (r.text == '') return o.value.length
        return o.value.lastIndexOf(r.text)
    } else return o.selectionStart
}
(function ($) {
    var tabs = $("#tabs").tabs();
    var tabs = $("#OrderTab").tabs();
    $.companyOrderItemcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RestroComplementary/',
                 HostUrl: '',
                 sentdata: '',
                 roomdata: '',
                 OID: '',
                 userName: '',
                 OrdermenuImageshow: '',
                 //names: '',
                 //phoneNo: '',
                 //NoOfGuests: '',
                 //membershipId: ''
             }, p);
        var v = 0;
        var OrderMasterID = 0;
        var CompId = 0;
        var CompMasterID = 0;
        var OrderListArray = new Array();
        var NewOrderListArray = new Array();
        var activeorder = 0;
        var noOfGuest = 1;
        var extraItem = 1;
        var selectedBillNo = 1;
        var isSplit = 0;
        var Note = "";
        var NpitemID = 0;
        var checks = [];
        var NpitemName = '';
        var IsCombo = '';
        var Nprate = 0;
        var ExtraCharge = 0.0;
        var RoomId = 0;
        var OID = 0;
        var TableId = 0;
        var IsCanceled = 0;
        var pinMatch = false;
        var iscancelling = false;
        var cancelobjs = [];
        var username = "";
        var pinfor = "";
        var status = "";
        var AutocompleteItem = new Array();
        var ExtraItems = new Array();
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var sum = 0;
        var logoName = "logo.png";
        var subItem = false;
        var categoryName = "";
        var ExtraItemsByItem = new Array();
        var OrderItemFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "services/ComplementaryWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MenuId: 0,
                Menuupdate: 0
            },

            init: function () {
                OrderItemFunction.GetGlobalizedMenu();
                OrderItemFunction.GetRoom();
                OrderItemFunction.GetItem();
                OrderItemFunction.GetMenuforOrder();
                OrderItemFunction.getcomboformenu();
                OrderItemFunction.GetExtraItemsByItem();
                
                logoName = companyInfo.Logo;
                $("#selLanguage").on('change', function () {
                    var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                    OrderItemFunction.GetMenuforOrder(languageid);
                });

                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        //$('#hdnPinMatch').unbind('change');
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'SendOrder') {
                            if ($("#ddlRoomName").val() == null && $("#ddlRoom").val() == null) {
                                jAlert("please select Roomname and RoomType", "ALERT!!", function () { $.alerts.dialogClass = null; });
                            }
                            else if ($("#ddlTableName").val() == null) {
                                jAlert("please select tablename", "ALERT!!", function () { $.alerts.dialogClass = null; });
                            }
                            else if ($("#txtDetails").val() == null || $("#txtDetails").val() == "" || $("#txtDetails").val() == " ") {
                                jAlert("Please insert details for Complementary", "ALERT!!", function () { $.alerts.dialogClass = null; });
                            }
                            else if (($("#orderlist-table tbody tr").length) > 0) {
                                OrderItemFunction.getOrderDetailByOrderMasterID();
                                //OrderItemFunction.SaveOrderedData();
                            }
                            
                            else {
                                jAlert("no item selected", "ALERT!!", function () { $.alerts.dialogClass = null; });
                            }
                        } else if (pinFor == 'CancelOrder') {
                            $('#cancelby').text(username);
                            $('#DisplayCancel').dialog();
                        }
                    }
                });
                PinCodeSetup();
                NumCodeSetup();
                $(".bindorderlist").on('click', '.qtyplus', function (e) {
                    e.preventDefault();
                    // Get the field name
                    if (e.handled !== true) { //Checking for the event whether it has occurred or not.
                        e.handled = true; // Basically setting value that the current event has occurred.
                        fieldName = $(this).attr('field');
                        var index = $(this).attr('id');
                        var splitindex = index.split('_');
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
                        OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(splitindex[3]);
                        OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
                    }

                    OrderItemFunction.CalculateTotal();
                });

                $("#ddlRoomName").on('change', function () {
                    $("#ddlTableName").attr("disabled", "disabled");
                    var RoomTypeID = $("#ddlRoomName").val();
                    OrderItemFunction.config.method = "GetRoomByRestroTypeId";
                    OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                    OrderItemFunction.config.data = JSON2.stringify({
                        RoomTypeID: RoomTypeID
                    });
                    OrderItemFunction.config.ajaxCallMode = 23;
                    OrderItemFunction.ajaxCall(OrderItemFunction.config);
                });


                $("#ddlRoom").on('change', function () {
                    $("#ddlTableName").attr("disabled", false);
                    var restroRoomId = $("#ddlRoom").val();
                    OrderItemFunction.config.method = "getRestroTableByRoomID";
                    OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                    OrderItemFunction.config.data = JSON2.stringify({
                        restroRoomId: restroRoomId
                    });
                    OrderItemFunction.config.ajaxCallMode = 24;
                    OrderItemFunction.ajaxCall(OrderItemFunction.config);
                });


                $(".bindorderlist").on('keyup', '.qty', function () {
                    // Get the field name
                    fieldName = $(this).attr('field');
                    var index = $(this).attr('index');
                    var splitindex = index.split('_')
                    // Get its current value
                    var currentVal = parseFloat($('#' + fieldName).val());
                    var last = $('#' + fieldName).val();

                    OrderListArray[parseFloat(splitindex[0])].Quantity = last;
                    OrderListArray[parseInt(splitindex[0])].SeatNo = parseInt(splitindex[1]);
                    OrderListArray[parseInt(splitindex[0])].GuestNo = parseInt(splitindex[1]);
                    var amount = 0;

                    OrderItemFunction.CalculateTotal();
                });

                $(".bindorderlist").on('click', '.qtyminus', function (e) {
                    //Icrease
                    e.preventDefault();
                    // Get the field name
                    if (e.handled !== true) { //Checking for the event whether it has occurred or not.
                        e.handled = true; // Basically setting value that the current event has occurred.
                        // Get the field name
                        fieldName = $(this).attr('field');
                        var index = $(this).attr('id');
                        var fieldsplit = fieldName.split('_');
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
                            $("#tr_" + row + "_" + itemrow[2]).remove();


                            $.each(OrderListArray, function (i) {
                                if (OrderListArray[i].ItemId == parseInt(row) && OrderListArray[i].IsCombo.toString() == itemrow[2]) {
                                    OrderListArray.splice(i, 1);
                                    return false;
                                }
                            });

                        }
                        else {
                            var last = $('#' + fieldName).val();
                            OrderListArray[parseInt(splitindex[1])].Quantity = last;
                            OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(splitindex[3]);
                            OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
                        }

                        OrderItemFunction.CalculateTotal();
                        return;
                    }
                });

                $(".sfCol_13").hide();

                $('#SendOrder').on('click', function () {
                    $('#hdnPinFor').val('SendOrder');

                    InitializePin();
                });

                $('#CancelOrder').on('click', function () {
                    if (OrderMasterID == 0) {
                        jConfirm('Are You Sure  ?', 'Cancel', function (confirmed) {
                            if (confirmed) {
                                var url = p.HostUrl;
                                window.location.href = url;
                            }
                        });
                    } else {
                        $('#hdnPinFor').val('CancelOrder');
                        InitializePin();
                    }
                });

                $('#btnSumbit').on('click', function () {
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
                $('#billno').change(function () {
                    selectedBillNo = parseInt($('#billno').val());
                    $(".bindorderlist").html('');
                    var htmls;
                    var i = 1;
                    $.each(OrderListArray, function (index, item) {
                        // if (item.SeatNo == selectedBillNo && item.GuestNo == selectedBillNo) {
                        if (selectedBillNo == 0) {
                            htmls += "<tr catr='c' id='tr_" + item.ItemId + "_" + item.IsCombo + "'>";
                            htmls += "<td>" + i + "</td>";
                            htmls += "<td>" + item.ItemName + "</td>";
                            htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + item.ItemId + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                            htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemId + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                            htmls += "<input type='button' value='+' id='plus_" + index + "_" + item.ItemId + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' /></td>";

                            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "_" + item.ItemId + "_" + item.ItemName + "' src='/images/extra.png' class='extras' width='30px' height='30px' /></td>";
                            //htmls += "<td><span class='status'>" + item.Status + "</span></td>";
                            htmls += "<tr>";
                            i = i + 1;
                        }
                        else if (item.SeatNo == selectedBillNo) {
                            //htmls += "<tr>";
                            htmls += "<tr catr='c' id='tr_" + item.ItemId + "_" + item.IsCombo + "'>";
                            htmls += "<td>" + i + "</td>";
                            htmls += "<td>" + item.ItemName + "</td>";
                            htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + item.ItemId + "_" + selectedBillNo + "' class='qtyminus qtyminuss' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                            htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemId + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                            htmls += "<input type='button' value='+' id='plus_" + index + "_" + item.ItemId + "_" + selectedBillNo + "' class='qtyplus qtypluss' field='qty_" + item.ItemId + "_" + item.IsCombo + "' /></td>";

                            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "_" + item.ItemId + "_" + item.ItemName + "' src='/images/extra.png' class='extras' width='30px' height='30px' /></td>";
                            // htmls += "<td><span class='status'>" + item.Status + "</span></td>";
                            htmls += "</tr>";
                            i = i + 1;


                        }


                    });

                    $(".bindorderlist").html(htmls);
                });
       
                $('#orderlist-table').on('click', '.extra', function () {
                    var index = $(this).attr('id');
                    var splitindex = index.split('_');
                    var itemsextra;
                    var itemID = splitindex[3];


                    $('.extradiv').html('');
                    var htmls = '';

                    htmls += '<form>';
                    htmls += '<fieldset>';
                    htmls += '<label for="name">Note:</label>';
                    htmls += '<textarea class="ddlSpicy sfInputbox">';
                    htmls += '</textarea><br>'

                    htmls += "<table><thead><tr><th>Extra</th><th>Extra Item</th><th width='15px'>Quantity</th></tr><tbody>";
                    $.each(ExtraItemsByItem, function (index, value) {
                        if (value.ItemID == itemID) {
                            var ordered = false;
                            var qnty = 0;
                            $.each(ExtraItems, function (index, data) {
                                if (data.ItemID == value.ItemID && data.ExtraItemID == value.ExtraItemID) {
                                    ordered = true;
                                    qnty = data.Quantity;
                                }
                            });

                            htmls += "<tr><td><input type='checkbox' class='ckbxExtraItem' id='" + value.ExtraItemID + "_" + value.ExtraItem + "_" + value.ExtraPrice + "' " + (ordered ? 'Checked' : '') + "> </td>";
                            htmls += "<td><label for='" + value.ExtraItemID + "_" + value.ExtraItem + "_" + value.ExtraPrice + "'>" + value.ExtraItem + "(Rs. " + value.ExtraPrice + ")</label></td>";
                            htmls += "<td><input type='text' id='Qnty_" + value.ExtraItemID + "' onkeypress='return isNumber(event)' style='width:80%;' value='" + (ordered ? qnty : '0') + "' class='ExtraQuantity qty' /></td></tr>";
                        }
                    });
                    htmls += "</tbody></table>";

                    //if (ExtraItems != "") {

                    //    //htmls += '<select class="HomeDelivs">'+ ExtraItems +'</select>';
                    //    htmls += ExtraItems;
                    //    //htmls += '<input type="hidden" class="hdnHomeDelivs"/>';
                    //    htmls += '<input type="textbox" class="HomeDelivs hdnHomeDelivs sfInputbox" style="width:50%;display:none;"/>';
                    //}
                    //else {
                    //    htmls += '<input type="textbox" class="HomeDelivs sfInputbox" style="width:50%;display:none;"/>';
                    //}

                    htmls += '<label for="name"style="display:none;">Home Delivery</label>';
                    htmls += '<input type="checkbox" id="chkbox_' + parseInt(splitindex[3]) + '" class="ChkboxHomedelivery"style="display:none;" value="Home Delivery" />';
                    htmls += '<select id="selectboxHomeDeliveryQuantity_' + parseInt(splitindex[3]) + '" class="sele"></select>';
                    htmls += '</fieldset>';
                    htmls += '</form>';
                    $('.extradiv').html(htmls);

                    $('.ckbxExtraItem').on('change', function () {
                        if ($(this).is(':checked')) {
                            $('#Qnty_' + $(this).attr('id').split('_')[0]).val(1);
                            $('#Qnty_' + $(this).attr('id').split('_')[0]).change();
                        }
                    });

                    $('.ExtraQuantity').on('change', function () {
                        itemQnty = parseInt($('#qty_' + itemID + '_false').val());
                        qnty = 0;
                        $('.ExtraQuantity').each(function () {
                            qnty += parseInt($(this).val());
                            if (qnty > itemQnty) {
                                qnty -= parseInt($(this).val());
                                $(this).val(0);
                                jAlert("Extra Item Qunatity Cannot be greater than Item Quantity", "ALERT!!", function () { $.alerts.dialogClass = null; });
                            }
                        })
                    });

                    $('.ddlSpicy').val(OrderListArray[parseInt(splitindex[1])].Note);
                    $('.HomeDelivs').val(OrderListArray[parseInt(splitindex[1])].ExtraCharge);
                    $(".sele").css("display", "none");
                    //var count = parseInt(splitindex[1]);
                    //var itemid = parseInt(splitindex[3]);
                    //var MyRows = $('#OrderList').find('tbody').find('tr');
                    //extraItem = parseInt($("#" + "qty_" + itemid).val());

                    //if (extraItem == 0) {
                    //    extraItem = 1;
                    //}
                    //else {
                    //    extraItem = parseInt($("#" + "qty_" + itemid).val());
                    //}


                    $('.extradiv').dialog(
                     {
                         'title': splitindex[4],
                         "resize": "auto",
                         width: 300,
                         buttons: {
                             "Submit": function () {
                                 var arrlength = ExtraItems.length;
                                 for (var i = 0; i < arrlength; i++) {
                                     var removeIndex = ExtraItems.map(function (item) { return item.ItemID; }).indexOf(parseInt(itemID));
                                     if (removeIndex >= 0) {
                                         ExtraItems.splice(removeIndex, 1);
                                     }
                                 }
                                 $('.ckbxExtraItem').each(function (i, obj) {

                                     if ($(this).is(':checked')) {
                                         //$('.ddlSpicy').val($('.ddlSpicy').val() + ', ' + $(this).attr('id').split('_')[1]);
                                         var word = $(this).attr('id').split("_");
                                         var extra = new Object;

                                         extra.ItemID = parseInt(itemID);
                                         extra.ExtraItemID = parseInt(word[0]);
                                         extra.ExtraItem = word[1];
                                         extra.ExtraPrice = parseFloat(word[2]);
                                         extra.Quantity = parseInt($('#Qnty_' + parseInt(word[0])).val());
                                         ExtraItems.push(extra);
                                     }
                                 });
                                 if ($('.ChkboxHomedelivery').is(':checked')) {
                                     OrderListArray[parseInt(splitindex[1])].IsHomeDelivery = true;
                                     OrderListArray[parseInt(splitindex[1])].HomeDeliveyNumber = $('.sele').val();
                                 } else {
                                     OrderListArray[parseInt(splitindex[1])].IsHomeDelivery = false;
                                     OrderListArray[parseInt(splitindex[1])].HomeDeliveyNumber = 0;
                                 }
                                 OrderListArray[parseInt(splitindex[1])].Note = $('.ddlSpicy').val();
                                 OrderListArray[parseInt(splitindex[1])].ExtraItem = "";
                                 //OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('.HomeDelivs').val());
                                 OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('.HomeDelivs').val());

                                 OrderItemFunction.CalculateTotal();
                                 $(this).dialog('close');
                             },
                             Cancel: function () {
                                 $('.ddlSpicy').val('');
                                 $('.HomeDelivs').val('');
                                 $(this).dialog('close');
                             }
                         }
                     });
                    //$(".ckbxExtraItem").on('click', function () {
                    //    var ids = $(this).attr('id');
                    //    var word = ids.split("_");
                    //    if ($(this).is(':checked')) {

                    //    } else {
                    //        var removeIndex = ExtraItems.map(function (item) { return item.ItemID; }).indexOf(itemID);
                    //        ExtraItems.splice(removeIndex, 1);
                    //        console.log(ExtraItems);
                    //    }
                    //});
                    $('.ChkboxHomedelivery').on('click', function () {
                        var index = $(this).attr('id');
                        var splitindex = index.split('_');

                        if ($(this).is(':checked')) {

                            $("#" + "selectboxHomeDeliveryQuantity_" + parseInt(splitindex[1])).html('');
                            var newhtml = '';
                            var quantitynumber = parseInt($("#" + "qty_" + parseInt(splitindex[1])).val());
                            for (var i = 1; i <= quantitynumber; i++) {
                                newhtml += "<option value=" + i + ">" + i + "</option>";
                            }
                            $("#" + "selectboxHomeDeliveryQuantity_" + parseInt(splitindex[1])).html(newhtml);
                            $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).toggle();
                            $(".sele").css("display", "block");

                        } else {
                            $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).toggle();
                        }
                    });
                });
                //$("#orderlist-table").on('click', '.extras', function () {
                //    //$('.extras').on('click', function () {

                //    $('.extradiv').html('');
                //    var htmls = '';

                //    //html += '<div id="dialog-form" title="Create new user">';
                //    //htmls += '<p class="validateTips">Please Enter No Of Guest To Split the Bill</p>';
                //    htmls += '<form>';
                //    htmls += '<fieldset>';
                //    htmls += '<label for="name">Note:</label>';
                //    htmls += '<textarea class="ddlSpicy sfInputbox">';
                //    htmls += '</textarea>'
                //    htmls += '<label for="name" style="display:none;">Extra Charge :</label>';
                //    htmls += '<input type="textbox" class="HomeDelivs sfInputbox" style="width:50%;display:none;"/>';
                //    htmls += '<label for="name" style="display:none;">Home Delivery</label>';
                //    htmls += '<input type="checkbox" id="chkbox_' + itemid + '" class="ChkboxHomedelivery" style="display:none;" value="Home Delivery" />';
                //    htmls += '<select id="selectboxHomeDeliveryQuantity_' + itemid + '" style="display:none;"></select>';
                //    htmls += '</fieldset>';
                //    htmls += '</form>';
                //    $('.extradiv').html(htmls);

                //    var index = $(this).attr('id');
                //    var splitindex = index.split('_');
                //    $('.ddlSpicy').val(OrderListArray[parseInt(splitindex[1])].Note);
                //    $('.HomeDelivs').val(OrderListArray[parseInt(splitindex[1])].ExtraCharge);



                //    var count = parseInt(splitindex[1]);
                //    var itemid = parseInt(splitindex[3]);
                //    var MyRows = $('#OrderList').find('tbody').find('tr');
                //    extraItem = parseInt($("#" + "qty_" + itemid).val());

                //    if (extraItem == 0) {
                //        extraItem = 1;
                //    }
                //    else {
                //        extraItem = parseInt($("#" + "qty_" + itemid).val());
                //    }

                //    $('.HomeDelivs').html('');
                //    var newhtml = '';
                //    for (var i = 1; i <= extraItem; i++) {
                //        newhtml += "<option value=" + i + ">" + i + "</option>";
                //    }
                //    $('.HomeDelivs').html(newhtml);

                //    var index = $(this).attr('id');
                //    var splitindex = index.split('_');
                //    $('.ddlSpicy').val(OrderListArray[parseInt(splitindex[1])].Note);
                //    $('.HomeDelivs').val(OrderListArray[parseInt(splitindex[1])].ExtraCharge);

                //    $('.extradiv').dialog(
                //     {
                //         'title': splitindex[4],
                //         "resize": "auto",
                //         width: 300,
                //         buttons: {
                //             "Submit": function () {
                //                 OrderListArray[parseInt(splitindex[1])].Note = $('.ddlSpicy').val();
                //                 OrderListArray[parseInt(splitindex[1])].ExtraItem = "";
                //                 OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('.HomeDelivs').val());

                //                 if ($('.ChkboxHomedelivery').is(':checked')) {
                //                     OrderListArray[parseInt(splitindex[1])].IsHomeDelivery = true;
                //                     OrderListArray[parseInt(splitindex[1])].HomeDeliveyNumber = $('.sele').val();
                //                 } else {
                //                     OrderListArray[parseInt(splitindex[1])].IsHomeDelivery = false;
                //                     OrderListArray[parseInt(splitindex[1])].HomeDeliveyNumber = 0;
                //                 }
                //                 $(this).dialog('close');
                //             },
                //             Cancel: function () {
                //                 $('.ddlSpicy').val('');
                //                 $('.HomeDelivs').val('');
                //                 $(this).dialog('close');
                //             }
                //         }
                //     });
                //    $('.ChkboxHomedelivery').on('click', function () {
                //        var index = $(this).attr('id');
                //        var splitindex = index.split('_');

                //        if ($(this).is(':checked')) {

                //            $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).html('');
                //            var newhtml = '';
                //            var quantitynumber = parseInt($("#" + "qty_" + itemid).val());
                //            for (var i = 1; i <= quantitynumber; i++) {
                //                newhtml += "<option value=" + i + ">" + i + "</option>";
                //            }
                //            $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).html(newhtml);
                //            $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).toggle();
                //        } else {
                //            $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).toggle();
                //        }
                //    });


                //});

                //$('#NoOfBill').on('click', function () {
                //    $('.billdialogue').html('');
                //    var htmls = '';
                //    htmls += '<div id="dialog-form">';
                //    //htmls += '<p class="validateTips">Please Enter No Of Guest To Split the Bill</p>';
                //    htmls += '<form>';
                //    htmls += '<fieldset>';
                //    htmls += '<label for="name">Number:</label>';
                //    htmls += '<input type="text" onkeypress="return validateFloatKeyPress(this,event)"  id="noofguesttxtbox" class="sfInputbox text ui-widget-content ui-corner-all" style="width:100px;">';
                //    //htmls += '<input type="submit" tabindex="-1" style="position:absolute; top:-1000px">';
                //    htmls += '</fieldset>';
                //    htmls += '</form>';
                //    htmls += '</div>';
                //    $('.billdialogue').html(htmls);
                //    $('#noofguesttxtbox').val(noOfGuest);
                //    $('.billdialogue').dialog(
                //     {
                //         'title': 'ORDER',
                //         "resize": "auto",
                //         width: 300,
                //         buttons: {
                //             "Submit": function () {
                //                 if ($('#noofguesttxtbox').val() == 0 || $('#noofguesttxtbox').val() == "") {
                //                     noOfGuest = 1;
                //                 } else {
                //                     noOfGuest = $('#noofguesttxtbox').val();
                //                 }

                //                 $('#billno').html('');
                //                 var newhtml = '';
                //                 for (var i = 1; i <= noOfGuest; i++) {
                //                     newhtml += "<option value=" + i + ">" + i + "</option>";
                //                 }
                //                 $('#billno').html(newhtml);
                //                 $(this).dialog('close');
                //             },
                //             Cancel: function () {
                //                 $(this).dialog('close');
                //             }
                //         }
                //     });



                //    if (p.sentData != 0 || p.roomData) {
                //        $('.splitMainView').show();
                //    }

                //});


                //$("#splitdisplayall").on('click', function () {
                //    if ($('#splitcheckbox').prop('checked', true)) {
                //        $(".bindorderlist").html('');
                //        var htmls;
                //        var i = 1;
                //        $.each(OrderListArray, function (index, item) {
                //            // if (item.SeatNo == selectedBillNo && item.GuestNo == selectedBillNo) {

                //            //htmls += "<tr>";
                //            htmls += "<tr catr='c' id='tr_" + item.ItemId + "_" + item.IsCombo + "'>";
                //            htmls += "<td>" + i + "</td>";
                //            htmls += "<td>" + item.ItemName + "</td>";
                //            htmls += "<td><input type='button' value='-' class='qtyminus sfBtn' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                //            htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemId + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                //            htmls += "<input type='button' value='+' class='qtyplus sfBtn' field='qty_" + item.ItemId + "_" + item.IsCombo + "' /></td>";
                //            //htmls += "<td><span id='minus_" + item.ItemId + "' class='minus sfBtn'> - </span> <span id='qty_" + item.ItemId + "' class='qty' index='" + index + "_" + selectedBillNo+ "'>1</span><span id='plus_" + item.ItemId + "' class='plus sfBtn'> + </span></td>";
                //            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "' src='/images/extra.png' class='extraa' width='30px' height='30px' /></td>";
                //            //htmls += "<td><img src='/images/extra.png' class='extra' width='20px' height='20px'/></td>";
                //            // htmls += "<td><span class='status'>" + item.ItemStatus + "</span></td>";
                //            htmls += "<tr>";
                //            i = i + 1;

                //        });

                //        $(".bindorderlist").html(htmls);
                //    }
                //    //if ($('#splitdisplayall').prop('checked', false)) {
                //    //    alert("Display all");
                //    //}
                //})s


                $("#txtSearch").autocomplete({
                    source: AutocompleteItem,
                    delay: 0,
                    select: function (event, ui) {
                        //$("#Menushow").hide();
                        //$("#btnSearch").show();
                        $.scrollTo(200);
                        var name = ui.item.value;
                        var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                        OrderItemFunction.config.method = "txtSearchForItem";
                        OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                        OrderItemFunction.config.data = JSON.stringify({ ItemName: name, languageid: languageid });
                        OrderItemFunction.config.ajaxCallMode = 1;
                        OrderItemFunction.ajaxCall(OrderItemFunction.config);
                    },
                });

                $("#btnSearch").click(function () {
                    $("#txtSearch").val("");
                    $("#Menushow").show();
                    OrderItemFunction.GetMenuforOrder();
                    $("#btnSearch").hide();
                });
        
                if (orderlistviewtype) {
                    $('#Itemshow2').on('click', '.orderbackB', function () {
                        $('#Itemshow2').hide();
                        $('#Itemshow').show();
                    });
                }
                $('#Itemshow,#Itemshow2 ').on('click', '.itemimg', function () {
                    if (orderlistviewtype) {
                        $('#Itemshow2').show();
                    }
                    var data = $(this).attr('id');
                    var values = data.split('_');
                    IsCombo = $(this).attr('attr-type');
                    if (values[4] == "true") {
                        subItem = true;
                        categoryName = values[2];
                        if (orderlistviewtype) {
							
                            $('#Itemshow').hide();
                        }
                        OrderItemFunction.GetItemByCategoryID(parseInt(values[1]));
                    } else {
                        subItem = false;
                        var ispresent = 1;
                        var result = 0;
                        $.each(OrderListArray, function (index, item) {
                            if (item.ItemId == values[1] && item.IsCombo == false) {
                                //if (item.SeatNo == parseInt($('#billno').val())) {
                                ispresent = 0;
                                result = 1;
                                // }
                            }
                        });
                        //var result = $.grep(OrderListArray, function (e) { return e.ItemId == values[1] && e.SeatNo == selectedBillNo && e.GuestNo == selectedBillNo; });

                        if (result == 0) {
                            var order = new Object();
                            order.ItemId = parseInt(values[1]);
                            order.ItemName = values[2];
                            order.IsCombo = IsCombo == 'c' ? true : false;
                            order.Quantity = 1;
                            order.Note = "";
                            order.ExtraCharge = 0.0;
                            order.SeatNo = selectedBillNo;
                            order.GuestNo = 1;
                            order.IsSplit = 0;
                            order.RoomId = p.roomData;
                            order.TableId = p.sentData;   
                            order.Remarks = "";
                            order.IsCancelled = 0;
                            order.Status = 'Ordered'
                            order.OrderDetailsID = 0;
                            order.Rate = values[6];
                            OrderListArray.push(order);
                            var htmls;
                            var i = 1;
                            $.each(OrderListArray, function (index, item) {
                                {
                                    htmls += "<tr attr-type='I' catr='c' id='tr_" + item.ItemId + "_" + item.IsCombo + "'>";
                                    htmls += "<td>" + i + "</td>";
                                    htmls += "<td>" + item.ItemName + "</td>";
                                    htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + item.ItemId + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                                    htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemId + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemId + "_" + item.IsCombo + "'/>";
                                    htmls += "<input type='button' value='+' id='plus_" + index + "_" + item.ItemId + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' /></td>";
                                    htmls += "<td class='rate'>" + item.Rate + "</td>";
                                    htmls += "<td class='total' style='display:none;'></td>";
                                    htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "_" + item.ItemId + "_" + item.ItemName + "' src='/images/extra.png' class='extra' width='30px' height='30px'/></td>";
                                    // htmls += "<td><span class='status'>" + item.ItemStatus + "</span></td>";
                                    htmls += "</tr>";
                                    i = i + 1;
                                }
                            });

                            $(".bindorderlist").html(htmls);

                        } else {
                            //alert('Item Already Entered Please increase the Quantity');
                            $('#qty_' + values[1] + '_false').val((parseInt($('#qty_' + values[1] + '_false').val()) + 1));
                            $('#qty_' + values[1] + '_false').keyup();
                        }

                        $('.splitMainView').show();
                    }
                });
                if (orderlistviewtype) {
                    $('#Itemshow').on('click', '.itemimg', function () {

                        $('#Itemshow2').show();
                    });
                }
            },

            GetCompanyInfoLogo: function () {
                OrderItemFunction.config.method = "GetCompanyInfoLogo";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                //OrderItemFunction.config.data = JSON2.stringify({
                //    ItemId: itemid
                //});
                OrderItemFunction.config.ajaxCallMode = 10;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },

            GetItem: function () {
                OrderItemFunction.config.method = "GetItemForSearch";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = OrderItemFunction.config.data;
                OrderItemFunction.config.ajaxCallMode = 8;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            BindDropdwonItem: function (result) {
                var datas = result.d;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        AutocompleteItem.push(value.ITName);
                        //htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });

                }

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
                        OrderItemFunction.GetOrderedExtraItemByOrderMaster(data.d.AllOrders[0].OrderMasterId);
                        break;
                    case 4:
                        jAlert("Ordered Cancelled successfully", "Information!!", function () { $.alerts.dialogClass = null; });
                        break;
                    case 8:
                        OrderItemFunction.BindDropdwonItem(data);
                        break;
                    case 7:
                        jAlert(data.d, "Information!!", function () { $.alerts.dialogClass = null; });
                        break;
                    case 5:
                       // if (TableId == 0) {
                           // OrderItemFunction.GetDataForSalesBill(data.d);
                        //}
                        //else {
                       // <b>' + $('#toTables :selected').text() + '</b>'
                            $.alerts.dialogClass = "order-info";
                            jAlert("Complementary is successfully saved, </br> <b>" + $('#ddlTableName :selected').text() + "</b>", "Information!!", function () {
                                parent.$.colorbox.close();
                            });
                      //  }
                        break;
                    case 6:
                        var id = OrderItemFunction.config.ID;
                        $("#" + id + "_").remove();
                        break;
                    case 9:
                        //if (data.d.length > 0) {

                        //    ExtraItems = "";
                        //    $.each(data.d, function (index, value) {
                        //        //ExtraItems += "<option value='" + value.ExtraPrice + "'>" + value.ExtraItem + "</option>";
                        //        ExtraItems += "<input type='checkbox' class='ckbxExtraItem' id='" + value.ExtraItem + "_" + value.ExtraPrice + "'> <label for='" + value.ExtraItem + "_" + value.ExtraPrice + "'>" + value.ExtraItem + "(Rs. " + value.ExtraPrice + ")</label><br/>";
                        //    });
                        //} else {
                        //    ExtraItems = "";
                        //}
                        break;
                    case 10:
                        break;
                    case 11:
                        if (data.d.length > 0) {
                            $('#tabs ul').show();
                        }
                        OrderItemFunction.BindComboforMenu(data);
                        break;
                    case 12:
                        var result = JSON.parse(data.d);
                        if (result != null) {
                            pinMatch = true;
                            username = result;
                        }
                        else {
                            pinMatch = false;
                        }
                        break;
                    case 13:
                        OrderItemFunction.bindForCancel(data.d);
                        break;
                    case 14:
                        OrderItemFunction.SaveOrderedData();
                        break;
                 
                    case 17:
                        $('#DialogOrderDetail').dialog('close');

                        break;
                    case 18:
                        //OrderItemFunction.bindBillBody(data.d);
                        break;
             
                    case 20:
                        if (data.d.length > 0) {
                            $.each(data.d, function (index, value) {
                                var extItm = new Object();
                                extItm.ItemID = value.ItemID;
                                extItm.ExtraItemID = value.ExtraItemID;
                                extItm.ExtraPrice = value.ExtraPrice;
                                extItm.ExtraItem = value.ExtraItem;

                                ExtraItemsByItem.push(extItm);
                            });
                        }
                        break;
                    case 21:
                        if (data.d.length > 0) {
                            $.each(data.d, function (index, value) {
                                var extItm = new Object();
                                extItm.ItemID = value.ItemID;
                                extItm.ExtraItemID = value.ExtraItemID;
                                extItm.ExtraPrice = value.ExtraPrice;
                                extItm.ExtraItem = value.ExtraItem;
                                extItm.Quantity = value.Quantity;

                                ExtraItems.push(extItm);
                            });
                        }
                        break;

                    case 22:
                        OrderItemFunction.BindDropdownRoomType(data);
                        break;

                    case 23:
                        OrderItemFunction.BindRoomByrestroRoomId(data);
                        break;

                    case 24:
                        OrderItemFunction.BindRoomByRoomId(data.d);
                        break;

                    case 25:
                        OrderItemFunction.BindGlobalizedMenu(data.d);
                        break;

                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetMenuforOrder: function () {
                var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                OrderItemFunction.config.method = "getGlobalizedMenu";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({ languageid: languageid });
                OrderItemFunction.config.ajaxCallMode = 0;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },

            GetOrderedExtraItemByOrderMaster: function (orderMasterID) {
                OrderItemFunction.config.method = "GetOrderedExtraItemByOrderMaster";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({ orderMasterID: orderMasterID });
                OrderItemFunction.config.ajaxCallMode = 21;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            GetExtraItemsByItem: function () {
                OrderItemFunction.config.method = "GetExtraItemsByItem";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = OrderItemFunction.config.data;
                OrderItemFunction.config.ajaxCallMode = 20;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
          

            getOrderDetailByOrderMasterID: function () {
                OrderItemFunction.config.method = "getOrderDetailByOrderMasterID";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({
                    OrderMasterID: OrderMasterID
                });
                OrderItemFunction.config.ajaxCallMode = 13;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            bindForCancel: function (result) {
                if (result.length > 0) {
                    $("#tblforcancelitem tbody").html("");
                    var array = [];
                    var rowCount = $('#orderlist-table tbody tr[catr="c"]').length;
                    for (var i = 0; i < rowCount; i++) {
                        var data = $('#orderlist-table tbody').find('tr[catr="c"]:eq(' + i + ')').attr('id');
                        var id = data.split("_")[1] + "_" + data.split("_")[2];
                        var v = "#qty_" + id;
                        var quantity = $(v).val();

                        array.push({ "id": id, "qty": quantity });

                    }
                    $.each(result, function (index, item) {
                        var found = false;
                        var qnty = 0;
                        var execute = false;
                        for (var i = 0; i < array.length; i++) {
                            if (item.ItemID.toString() == parseInt(array[i].id.split('_')[0])) {
                                if (item.IsCombo.toString() == array[i].id.split('_')[1]) {
                                    found = true;
                                    qnty = array[i].qty;
                                    execute = true;
                                    break;
                                }
                            }
                        }
                        if (!array.includes(item.ItemID + "_" + item.IsCombo)) {
                            execute = true;
                        }
                        if (execute) {
                            if (found && qnty < item.Quantity) {
                                var htmls = "";
                                htmls += ("<tr>");
                                htmls += ("<td>" + item.Item + "</td>");
                                htmls += ("<td>" + (item.Quantity - qnty) + "</td>");
                                htmls += ("<td>" + item.OrderBy + "</td>");
                                htmls += ("<td><textarea class='txtreason sfInputbox'></textarea></td>");
                                htmls += ("<td><select class='selResponsible sfInputbox'><option value='Waiter'>Waiter</option><option value='Customer'>Customer</option><option value='Chef'>Chef</option></select></td>");
                                htmls += ("</tr>");

                                $(htmls).appendTo("#tblforcancelitem tbody");
                            }
                            if (!found) {
                                var htmls = "";
                                htmls += ("<tr>");
                                htmls += ("<td>" + item.Item + "</td>");
                                htmls += ("<td>" + (item.Quantity - qnty) + "</td>");
                                htmls += ("<td>" + item.OrderBy + "</td>");
                                htmls += ("<td><textarea class='txtreason sfInputbox'></textarea></td>");
                                htmls += ("<td><select class='selResponsible sfInputbox'><option value='Waiter'>Waiter</option><option value='Customer'>Customer</option><option value='Chef'>Chef</option></select></td>");
                                htmls += ("</tr>");

                                $(htmls).appendTo("#tblforcancelitem tbody");
                            }

                        }
                    });
                    if ($('#tblforcancelitem tbody tr').length > 0) {
                        $('#canceledOrderItem').dialog({
                            'title': 'Canceled Items',
                            width: 800,
                            modal: true,
                        });

                        $('.saveCanceledItem').on('click', function () {
                            var rcount = $('#tblforcancelitem tbody tr').length;

                            for (var i = 0; i < rcount; i++) {
                                cancelobj = {
                                    Item: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('td:eq(0)').text(),
                                    Quantity: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('td:eq(1)').text(),
                                    OrderBy: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('td:eq(2)').text(),
                                    CanceledBy: $('#hdnPinBy').val(),
                                    Reason: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('.txtreason').val(),
                                    Responsible: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('.selResponsible option:selected').text(),
                                    tableId: TableId
                                }
                                cancelobjs.push(cancelobj);
                            }

                            OrderItemFunction.SaveCanceledItems();

                        });
                    }
                    else {
                        OrderItemFunction.SaveOrderedData();
                    }

                }
                else {
                    OrderItemFunction.SaveOrderedData();
                }
            },
            SaveCanceledItems: function () {
                OrderItemFunction.config.method = "SaveCanceledItems";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({ CancelItems: cancelobjs });
                OrderItemFunction.config.ajaxCallMode = 14;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            OrderMaster: function OrderMaster() {
                this.OrderDetailList = OrderItemFunction.OrderDetails

            },
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
                ordermaster.CancelReason = $("#canceltextarea").val();
                ordermaster.CancelBy = $('#hdnPinBy').val();
                ordermaster.IsCancelled = true,
                //ordermaster.UserName = SageFrameUserName;
                //ordermaster.Date = OrderListArray[0].
                OrderItemFunction.config.method = "CancelOrderIntoDataBase";

                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster });
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = jsonText;
                OrderItemFunction.config.ajaxCallMode = 4;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
                //OrderItemFunction.config.ajaxCallMode = 3;
                OrderItemFunction.config.ID = id;
                //OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },

            BindDropdownRoomType: function (result) {
                var datas = result.d;
                $("#ddlRoomName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-- Select --</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.RoomTypeID + "'>" + value.Title + "</option>";
                    });

                    $("#ddlRoomName").html(htmls);
                }

            },
            BindGlobalizedMenu: function (result) {
                var datas = JSON.parse(result);
                $("#selLanguage").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.LanguageID + "'>" + value.CultureName + "</option>";
                    });

                    $("#selLanguage").html(htmls);
                }

            },

            BindRoomByrestroRoomId: function (result) {
       
                var datas = result.d;
                var htmls = '';
                htmls += '<option value="" selected disabled>-- Select --</option>';
                $.each(datas, function (index, value) {
                    htmls += "<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>";
                });
                $("#ddlRoom").html(htmls);
            },

            BindRoomByRoomId: function (result) {
                
                var datas = JSON.parse(result);
                var htmls = '';
                htmls += '<option value="" selected disabled>-- Select --</option>';
                $.each(datas, function (index, value) {
                    htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                });
                $("#ddlTableName").html(htmls);
            },

            SaveOrderedData: function () {
                
                var billpd = false;
                var splited = false;
                var cancel = false;             
                if ($('input[id="splitcheckbox"]').is(':checked')) {
                    splited = true;
                }
                var orders = [];
                var orderDetailsList = new Array();
                for (var i = 0; i < OrderListArray.length; i++) {
                    if (splited = true) {
                        var orderDetail = new Object();
                        orderDetail.Quantity = OrderListArray[i].Quantity,
                        orderDetail.ItemId = OrderListArray[i].ItemId,
                        orderDetail.IsCombo = OrderListArray[i].IsCombo,
                        orderDetail.Rate = 0.0,
                        orderDetail.Note = OrderListArray[i].Note,
                        orderDetail.Amount = 0.0
                        orderDetailsList.push(orderDetail);
                    }
                    else {
                        if (OrderListArray[i].SeatNo = $('#billno').val()) {
                            var orderDetail = new Object();
                            orderDetail.Quantity = OrderListArray[i].Quantity,
                            orderDetail.ItemId = OrderListArray[i].ItemId,
                            orderDetail.IsCombo = OrderListArray[i].IsCombo,
                            orderDetail.Rate = 0.0,
                            orderDetail.Note = OrderListArray[i].Note,
                            orderDetail.Amount = 0.0
                            orderDetailsList.push(orderDetail);
                        }
                    }

                }
                var ordermaster = new Object();
                ordermaster.orderDetailsList = orderDetailsList,
                ordermaster.CompMasterID = CompMasterID
                ordermaster.TableId = $("#ddlTableName").val();
                ordermaster.RoomId = $("#ddlRoom").val();
                ordermaster.BasicAmount = 0.0,
                ordermaster.BillNo = "",
                ordermaster.Date = Date.now,
                ordermaster.IsCancelled = cancel,
                ordermaster.TermAmount = 0.0,
                ordermaster.NetAmount = 0.0,
                ordermaster.UserName = $('#hdnPinBy').val(),
                ordermaster.Remarks = "",
                ordermaster.IsSplit = splited,
                ordermaster.GuestNo = noOfGuest,
                ordermaster.BillPaid = 0,
                ordermaster.ArchivedBy = $('#hdnPinBy').val();
                ordermaster.Details = $('#txtDetails').val();

                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster, orderExtraItem: ExtraItems });
                OrderItemFunction.config.method = "SaveOrderIntoDataBase";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = jsonText;
                OrderItemFunction.config.ajaxCallMode = 5;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },
            getcomboformenu: function () {
                OrderItemFunction.config.method = "getitemforcumbo";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = {};
                OrderItemFunction.config.ajaxCallMode = 11;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },
            //GetMenuforOrder: function () {
            //    OrderItemFunction.config.method = "GetMenuforOrder";
            //    OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
            //    OrderItemFunction.config.data = {};
            //    OrderItemFunction.config.ajaxCallMode = 0;
            //    OrderItemFunction.ajaxCall(OrderItemFunction.config);

            //},
            GetCategoriesBymenuID: function (menuid) {
                var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                OrderItemFunction.config.method = "GetCategoriesBymenuID";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({
                    MenuId: menuid, languageid: languageid
                });     
                OrderItemFunction.config.ajaxCallMode = 1;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);

            },
            GetItemByCategoryID: function (categoryId) {
                var LanguageID = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                OrderItemFunction.config.method = "GetItemByCategoryID";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = JSON2.stringify({
                    CategoriesID: categoryId, LanguageID: LanguageID
                });
                OrderItemFunction.config.ajaxCallMode = 2;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },      
            GetRoom: function () {
                OrderItemFunction.config.method = "getRoomType";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = OrderItemFunction.config.data;
                OrderItemFunction.config.ajaxCallMode = 22;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            GetGlobalizedMenu: function () {
                OrderItemFunction.config.method = "getLanguage";
                OrderItemFunction.config.url = OrderItemFunction.config.baseURL + OrderItemFunction.config.method;
                OrderItemFunction.config.data = OrderItemFunction.config.data;
                OrderItemFunction.config.ajaxCallMode = 25;
                OrderItemFunction.ajaxCall(OrderItemFunction.config);
            },
            //----------------------------->>>>>>       Binding part     <<<<<<<<<<<<--------------------------

        
            BindComboforMenu: function (result) {
                var htmls = [];
                $('#ComboMenu').html("");
                var datas = result.d;
                htmls += "<h4>Main Menus</h4>";
                if (datas.length > 0) {

                    htmls += "<div class='menuss'>";
                    $.each(datas, function (index, value) {
                        if (value.ImagePath == "")
                            htmls += "<div><img attr-type='c' id='menuimg_" + value.ComboID + "_" + value.Name + "_true_" + value.SalesPrice + "' class='menuimgg' src='/Modules/ROCompanyInfo/logo/" + companyInfo.Logo + "' width='150px' height='120px'>";
                            //"~/Modules/ROCompanyInfo/logo/"+
                        else
                            htmls += "<div><img attr-type='c' id='menuimg_" + value.ComboID + "_" + value.Name + "_true_" + value.SalesPrice + "' class='menuimgg' src='/Modules/ROCumboPack/images/" + value.ImagePath + "' width='150px' height='120px' alt='Image not found'>";
                        htmls += "<div attr-type='c' class='itmname menuimgg' id='menuimg_" + value.ComboID + "_" + value.Name + "_true_" + value.SalesPrice + "' >" + value.Name + " (Rs. " + value.SalesPrice + ")</div></div>";

                    });
                    htmls += "</div>";
                    $('#ComboMenu').html(htmls);
                } else {
                    htmls += "<h6>No Menu Available </h6>";
                    $('#ComboMenu').html(htmls);
                }
                if (!orderlistviewtype) {
                    $('.menuss').owlCarousel({
                        navigation: true,
                        addClassActive: true
                    });
                }

                $(".menuimg").on("error", function () {
                    $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
                });



                $('.menuimgg').on('click', function () {
                    if (orderlistviewtype) {
                        $('#Categoryshow').show();
                    }
                    var data = $(this).attr('id');
                    var values = data.split('_');
                    var IsCombo = $(this).attr('attr-type');
                    var ispresent = 1;
                    var result = 0;
                    $.each(OrderListArray, function (index, item) {
                        if (item.ItemId == values[1] && item.IsCombo == true) {
                            ispresent = 0;
                            result = 1;
                        }

                    });
                 
                    if (result == 0) {
                        var order = new Object();
                        order.ItemId = parseInt(values[1]);
                        order.ItemName = values[2];
                        order.Rate = values[4];
                        order.Quantity = 1;
                        order.IsCombo = IsCombo == 'c' ? true : false;
                        order.Note = "";
                        order.ExtraCharge = 0.0;
                        order.SeatNo = selectedBillNo;
                        order.GuestNo = 1;
                        order.IsSplit = 0;
                        order.RoomId = p.roomData;
                        order.TableId = p.sentData;              
                        order.Remarks = "";
                        order.IsCancelled = 0;
                        order.Status = 'Ordered'
                        order.OrderDetailsID = 0;
                        OrderListArray.push(order);
                        var htmls;
                        var i = OrderListArray.length;
                        htmls += "<tr attr-type='c' catr='c' id='tr_" + order.ItemId + "_" + order.IsCombo + "'>";
                        htmls += "<td>" + i + "</td>";
                        htmls += "<td>" + order.ItemName + "</td>";
                        htmls += "<td><input type='button' value='-' id='minus_" + (i - 1) + "_" + order.ItemId + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + order.ItemId + "_" + order.IsCombo + "' />";
                        htmls += "<input type='text' onkeypress='r eturn validateFloatKeyPress(this,event)' id='qty_" + order.ItemId + "_" + order.IsCombo + "' value='" + order.Quantity + "' class='qty' index='" + (i - 1) + "_" + selectedBillNo + "' width='20px' field='qty_" + order.ItemId + "_" + order.IsCombo + "'/>";
                        htmls += "<input type='button' value='+' id='plus_" + (i - 1) + "_" + order.ItemId + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + order.ItemId + "_" + order.IsCombo + "' /></td>";
                        //htmls += "<td><span id='minus_" + item.ItemId + "' class='minus sfBtn'> - </span> <span id='qty_" + item.ItemId + "' class='qty' index='" + index + "_" + selectedBillNo+ "'>1</span><span id='plus_" + item.ItemId + "' class='plus sfBtn'> + </span></td>";
                        htmls += "<td class='rate'>" + order.Rate + "</td>";
                        htmls += "<td class='total' style='display:none;'></td>";
                        //yo ni hoina 
                        htmls += "<td><img id='extra_" + (i - 1) + "_" + selectedBillNo + "_" + order.ItemId + "_" + order.ItemName + "' src='/images/extra.png' class='extra' width='30px' height='30px'/></td>";
                        // htmls += "<td><span class='status'>" + order.ItemStatus == undefined ? "" : order.ItemStatus + "</span></td>";
                        htmls += "</tr>";
 
                        $(".bindorderlist").append(htmls);
                        
                    
                    } else {

                        //alert('Item Already Entered Please increase the Quantity');
                        $('#qty_' + values[1] + '_true').val((parseInt($('#qty_' + values[1] + '_true').val()) + 1));
                        $('#qty_' + values[1] + '_true').keyup();

                    }

                    $('.splitMainView').show();


                });

                //$('.menuimg').on('click', function () {
                //    var data = $(this).attr('id');
                //    var values = data.split('_');
                //    OrderItemFunction.GetCategoriesBymenuID(parseInt(values[1]));

                //});
            },
            bindMenuforOrder: function (result) {
                var htmls = [];
                $('#Menushow').html("");
                //var datas = result.d;
                var datas = JSON.parse(result.d);
                htmls += "<h4>Main Menus</h4>";
                if (datas.length > 0) {

                    htmls += "<div class='menus'>";
                    $.each(datas, function (index, value) {
                        //htmls += "<div><img id='menuimg_" + value.ItemId + "' class='menuimg' alt='~/Modules/ROCompanyInfo/logo/sageframe.png' src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' width='150px' height='120px'>";
                        if (value.ImagePath == "")
                            // htmls += "<div><img id='menuimg_" + value.ItemId + "' class='menuimg' src='/Modules/ROI_Item/ImageItem/sageframe.png' width='150px' height='120px'>";
                            htmls += "<div><img id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "' class='menuimg' src='/Modules/ROCompanyInfo/logo/" + companyInfo.Logo + "' width='150px' height='120px'>";
                            //"~/Modules/ROCompanyInfo/logo/"+
                        else
                            htmls += "<div><img id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "' class='menuimg' src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' width='150px' height='120px' alt='Image not found'>";
                        htmls += "<div class='itmname menuimg' id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "'>" + value.LanguageMenuText + "</div></div>";

                    });
                    htmls += "</div>";
                    $('#Menushow').html(htmls);


                } else {
                    htmls += "<h6>No Menu Available </h6>";
                    $('#Menushow').html(htmls);
                }
                if (p.OrdermenuImageshow == "false") {
                    $('img.menuimg').remove();
                    $('.restaurant-part-menu').click(function () {
                        $('img.categoryimg , img.itemimg').remove();
                    });
                }
                if (!orderlistviewtype) {
                    $('.menus').owlCarousel({

                        navigation: true,
                        addClassActive: true
                    });
                }
                $(".menuimg").on("error", function () {
                    $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
                });



                $('.menuimg').on('click', function () {

                    var data = $(this).attr('id');
                    var values = data.split('_');
                    categoryName = values[2];
                    OrderItemFunction.GetCategoriesBymenuID(parseInt(values[1]));
                    if (orderlistviewtype) {
                        $('#Menushow').hide();
                        $('#Categoryshow , #Itemshow2, #Itemshow2').show();
                    }
                });
            },
            BindGetCategoriesBymenuID: function (result) {

                var htmls = [];
                $('#Categoryshow').html("");
                $('#Itemshow').html("");
                $('#Itemshow2').html("");

                var datas = result.d;
                if (orderlistviewtype) {
                    htmls += "<img src='/images/back.png' class='orderbackA'/><h4>" + categoryName + " Items </h4>";
                } else {
                    htmls += "<h4>" + categoryName + " Items </h4>";
                }
                if (datas.length > 0) {

                    htmls += "<div class='category menus'>";
                    $.each(datas, function (index, value) {
                        if (value.ImagePath == "") {
                            //htmls += "<div><img id='categoryimg_" + value.ItemId + "_" + value.ItemName + "' class='categoryimg' src='/Modules/ROI_Item/ImageItem/sageframe.png' width='150px' height='120px'>";
                            //htmls += "<div><img attr-type='i' attr-iscat=" + value.IsCategory + " id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.SRate + "' class='categoryimg' src='/Modules/ROCompanyInfo/logo/" + logoName + "' width='150px' height='120px'>";
                            htmls += '<div><img attr-type="i" attr-iscat=' + value.IsCategory + ' id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.SRate + '" class="categoryimg" src="/Modules/ROCompanyInfo/logo/' + logoName + '" width="150px" height="120px">';
                        }
                        else
                           // htmls += "<div><img attr-type='i' attr-iscat=" + value.IsCategory + " id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.SRate + "' class='categoryimg'  src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' width='150px' height='120px'>";
                        htmls += '<div><img attr-type="i" attr-iscat=' + value.IsCategory + ' id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.SRate + '" class="categoryimg"  src="/Modules/ROI_Item/ImageItem/' + value.ImagePath + '" width="150px" height="120px">';
                        if (value.SRate == '0')
                           // htmls += "<div class='itmname categoryimg' id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.SRate + "' attr-iscat=" + value.IsCategory + ">" + value.LanguageMenuText + "</div></div>";
                            htmls += '<div class="itmname categoryimg" id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.SRate + '" attr-iscat=' + value.IsCategory + '>' + value.LanguageMenuText + '</div></div>';
                        else
                            //htmls += "<div class='itmname categoryimg' id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.SRate + "' attr-iscat=" + value.IsCategory + ">" + value.LanguageMenuText + "(Rs." + value.SRate + ")</div></div>";
                            htmls += '<div class="itmname categoryimg" id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.SRate + '" attr-iscat=' + value.IsCategory + '>' + value.LanguageMenuText + '(Rs.' + value.SRate + ')</div></div>';
                    });
                    htmls += "</div>";
                    $('#Categoryshow').html(htmls);


                } else {
                    htmls += "<h6>No category Available in this Section</h6>";
                    $('#Categoryshow').html(htmls);
                }

                $(".categoryimg").on("error", function () {
                    $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
                });

                if (p.OrdermenuImageshow == "false") {
                    $('img.menuimg').remove();
                    $('.restaurant-part-menu').click(function () {
                        $('img.categoryimg , img.itemimg').remove();
                    });
                } else {
                    $('#Menushow').hide();
                }

                if (orderlistviewtype) {
                    $('.orderbackA').on('click', function () {
                        $('#Categoryshow').hide();
                        $('#Itemshow , #Itemshow2 ').hide();
                        $('#Menushow').show();
                    });
                } else {
                    $('.category').owlCarousel({

                        navigation: true,
                        addClassActive: true
                    });
                }
             

                $('.categoryimg').on('click', function () {
                    $('#Itemshow').html("");
                    var data = $(this).attr('id');
                    var values = data.split('_');
                    NpitemID = values[1];
                    NpitemName = values[2];
                    Nprate = values[4];
                    IsCombo = $(this).attr('attr-type');
                    var IsCat = $(this).attr('attr-iscat') == "true" ? true : false;
					$('#Itemshow').show();
                    if (IsCat) {
                        if (orderlistviewtype) {
                            $('#Categoryshow').hide();
                        }
                        subItem = false;
                        categoryName = values[2];
                        OrderItemFunction.GetItemByCategoryID(parseInt(values[1]));
                        $('html, body').animate({
                            scrollTop: $("#Itemshow").offset().top - 100
                        }, 200);
                    }
                    else {
                        if (orderlistviewtype) {
                            $('#Categoryshow').show();
                        }
                        OrderItemFunction.BindItemsToOrder();
                    }
                });
               
            },
            BindItemsToOrder: function () {
                var ispresent = 1;
                var result = 0;
                $.each(OrderListArray, function (index, item) {
                    if (item.ItemId == parseInt(NpitemID) && item.IsCombo == false) {
                        ispresent = 0;
                        result = 1;
                    }

                });
                if (result == 0) {
                    var order = new Object();
                    order.ItemId = parseInt(NpitemID);
                    order.ItemName = NpitemName;
                    order.Rate = parseInt(Nprate);
                    order.IsCombo = IsCombo == 'c' ? true : false;
                    order.Quantity = 1;
                    order.Note = "";
                    order.ExtraCharge = 0.0;
                    order.IsHomeDelivery = false;
                    order.HomeDeliveyNumber = 0;
                    order.SeatNo = selectedBillNo;
                    order.GuestNo = 1;
                    order.IsSplit = 0;
                    order.RoomId = p.roomData;
                    order.TableId = p.sentData;
                    order.Remarks = "";
                    order.IsCancelled = 0;
                    order.Status = 'Ordered'
                    order.OrderDetailsID = 0;
                    OrderListArray.push(order);
                    $(".bindorderlist").html('');
                    $(".bindfoot").html('');
                    var htmls;
                    var i = 1;

                    $.each(OrderListArray, function (index, item) {
                        //if (item.SeatNo == selectedBillNo)
                        {
                            htmls += "<tr catr='c' id='tr_" + item.ItemId + "_" + item.IsCombo + "'>";
                            htmls += "<td>" + i + "</td>";
                            htmls += "<td>" + item.ItemName + "</td>";
                            htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
                            htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemId + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemId + "_" + item.IsCombo + "'/>";
                            htmls += "<input type='button' value='+' id='plus_" + index + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' /></td>";
                            //htmls += "<td><span id='minus_" + item.ItemId + "' class='minus sfBtn'> - </span> <span id='qty_" + item.ItemId + "' class='qty' index='" + index + "_" + selectedBillNo+ "'>1</span><span id='plus_" + item.ItemId + "' class='plus sfBtn'> + </span></td>";
                            htmls += "<td class='rate'>" + item.Rate + "</td>";
                            htmls += "<td class='total' style='display:none;'></td>";
                            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "_" + item.ItemId + "_" + item.ItemName + "' src='/images/extra.png' class='extra' width='30px' height='30px'/></td>";
                            // htmls += "<td><span class='status'>" + item.ItemStatus == undefined ? "" : item.ItemStatus + "</span></td>";
                            htmls += "</tr>";
                            i = i + 1;
                        }
                    });
                    $(".bindorderlist").html(htmls);
                    var amount = 0;
                    $("#orderlist-table>.bindorderlist>tr").each(function (index, value) {
                        var qty = $(value).find(".qty").val();
                        var rate = $(value).find(".rate").text();
                        var result = parseFloat(qty) * parseFloat(rate);
                        $(value).find('.total').text(result.toFixed(1));
                    });
                    var MyRows = $('#orderlist-table').find('.bindorderlist').find('tr');
                    for (var i = 0; i < MyRows.length; i++) {
                        amount += parseFloat($(MyRows[i]).find('.total').text());
                    }
                    $('.totalamount').text('Total Amount: RS. ' + amount);
                }
                else {
                    //alert('Item Already Entered Please increase the Quantity');
                    $('#qty_' + NpitemID + '_false').val((parseInt($('#qty_' + NpitemID + '_false').val()) + 1));
                    $('#qty_' + NpitemID + '_false').keyup();
                }
            },
            BindItemByCategoryID: function (result) {
                var htmls = [];
                if (subItem) {
                    $('#Itemshow2').html("");
                } else {
                    $('#Itemshow').html("");
                    $('#Itemshow2').html("");
                }
                var datas = result.d;
                if (orderlistviewtype) {
                    htmls += "<img src='/images/back.png' class='orderbackB'/><h4>" + categoryName + " Items </h4>";
                } else {
                    htmls += "<h4>" + categoryName + " Items </h4>";
                }
                if (datas.length > 0) {
                    htmls += "<div class='" + (subItem ? "items" : "itemsss") + "'>";
                    $.each(datas, function (index, value) {
                        if (value.ImagePath == "")
                            htmls += "<div><img attr-type='i' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.LanguageMenuText + "_" + value.SRate + "' class='itemimg' src='/Modules/ROCompanyInfo/logo/" + logoName + "' width='150px' height='120px'>";
                        else
                            htmls += "<div><img attr-type='i' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.LanguageMenuText + "_" + value.SRate + "' class='itemimg'  src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' width='150px' height='120px'>";
                        if (value.SRate == '0')
                            htmls += "<div class='itmname itemimg' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.LanguageMenuText + "_" + value.SRate + "'>" + value.LanguageMenuText + "</div></div>";
                        else
                            htmls += "<div class='itmname itemimg' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.LanguageMenuText + "_" + value.SRate + "'>" + value.LanguageMenuText + "(Rs." + value.SRate + ")</div></div>";
                    });
                    htmls += "</div>";
                }
                else {
                    htmls += "<h6>No Item Available in this Section.</h6>"
                }
                if (subItem) {
                    $('#Itemshow2').html(htmls);
                    if (!orderlistviewtype) {
                        $('.items').owlCarousel({
                            navigation: true,
                            addClassActive: true
                        });
                    }
                }
				
                else {
                    $('#Itemshow').html(htmls);
                    if (!orderlistviewtype) {
                        $('.itemsss').owlCarousel({
                            navigation: true,
                            addClassActive: true
                        });
                    }
                }

 
            },

            CalculateTotal: function () {
                var amount = 0;
                var extraRate = 0;
                $.each(ExtraItems, function (index, value) {
                    extraRate += parseFloat(value.Quantity) * parseFloat(value.ExtraPrice);
                });
                $("#orderlist-table>.bindorderlist>tr").each(function (index, value) {
                    var qty = $(value).find(".qty").val();
                    var rate = $(value).find(".rate").text();
                    var result = parseFloat(qty) * parseFloat(rate);
                    $(value).find('.total').text(result.toFixed(1));
                });
                var MyRows = $('#orderlist-table').find('.bindorderlist').find('tr');
                for (var i = 0; i < MyRows.length; i++) {
                    amount += parseFloat($(MyRows[i]).find('.total').text());
                }
                var total = amount + extraRate;
                $('.totalamount').text('Total Amount: RS. ' + total);
            },
        };
        if (orderlistviewtype) {
            $('#Itemshow').on('click', '.orderbackB', function () {
                if (subItem) {
                    $('#Itemshow2').hide();
                    $('#Itemshow').hide();
                    $('#Categoryshow').show();
                }
                else {
                    $('#Categoryshow').show();
                    $('#Itemshow').hide();
                }
            });
        }
        OrderItemFunction.init();
    };
    $.fn.companyOrderItemEDIT = function (p) {
        $.companyOrderItemcreate(p);
    };
})(jQuery);



