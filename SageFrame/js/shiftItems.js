var ordersList = [];
var tableId = 0;
var fromOrderMasterId = 0;
var fromOrderNo = 0;
var shiftItemList = [];
var tablesList = [];
var userRoles = JSON.parse(localStorage.getItem("userRoles"));
function shiftItemsInitialize() {
    $('.shiftTo').show();
    getTables();
    getRooms();
    for (var i = 0; i < userRoles.length; i++) {
        if (userRoles[i].UserName == SageFrameUserName) {
            var roles = userRoles[i].Roles.split(',');
            if (roles.indexOf('Complementary') >= 0 || roles.indexOf('super user') >= 0) {
                $('.shiftType').show();
            }
            break;
        }
    }

    //$('#selShiftType').on('change', function () {
    //    if ($(this).val() == 'Complementary') {
    //        $('.shiftTo').hide();
    //    } else {
    //        $('.shiftTo').show();
    //    }
    //});

    $('#toRooms').change();
    $('#hdnPinMatch').on('change', function () {
        if ($('#hdnPinMatch').val() == "true") {
            if ($('#hdnPinFor').val() == 'ShiftItem') {
                $('#hdnPinMatch').unbind('change');
                shiftItems();
            }
        }
    });

    $('#btnShiftItem').unbind('click').on('click', function () {
        Checkbillgenerated();
    });
}

function getDataForShift(orderMasterId, orderNo) {
    fromOrderMasterId = orderMasterId;
    fromOrderNo = orderNo;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebService.asmx/getDataForShift",
        data: JSON.stringify({ orderMasterId: orderMasterId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            ordersList = [];
            shiftItemList = [];
            ordersList = JSON.parse(data.d);
            var guestNo = 1;
            var gn = '';
            $('#fromSplitNo').html(gn)
            $.each(ordersList, function (index, value) {
                if (value.SeatNo > guestNo) {
                    guestNo = value.SeatNo;
                }
            });
            for (i = 1; i <= guestNo; i++) {
                gn += '<option value="' + i + '">' + i + '</option>'
            }
            $('#fromSplitNo').html(gn)
            $('#fromSplitNo').on('change', function () {
                shiftItemList = [];
                bindOrderList();
            });

            if (ordersList.length > 0) {
                $('#shiftItems').dialog({
                    "title": 'Shift Items From : ' + ordersList[0].restrotableTitle,
                    "width": 850,
                    modal: true,
                });
            } else {
                jAlert("No Item to shift.", "Alert!!");
            }

            bindOrderList();
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });

}
function bindOrderList() {
    var seatNo = $('#fromSplitNo').val();
    var htmls = '';
    var i = 1;
    $.each(ordersList, function (index, order) {
        if (order.SeatNo == seatNo) {
            htmls += '<tr id="tr_' + order.ROI_ItemId + '_' + order.IsCombo + '">';
            htmls += '<td>' + i + '</td>';
            htmls += '<td>' + order.ITName + '</td>';
            htmls += '<td class="ordQnty">' + order.Quantity + '</td>';
            htmls += '<td><img src="/Images/shift.png" class="shiftThisItem preview-icon" type="button"  id="' + order.ROI_ItemId + '_' + order.IsCombo + '_' + order.ITName + '" /></td>';
            htmls += '</tr>';
            i++;
        }
    })
    $('#tblOrderList>tbody').html(htmls);
    bindShiftingItemsList();
    $('#shiftAllItems').on('click', function () {
        shiftItemList = [];
        for (var i = 0; i < ordersList.length; i++) {
            debugger;
            if (ordersList[i].SeatNo == seatNo) {
                var item = new Object();
                item.ItemId = ordersList[i].ROI_ItemId;
                item.IsCombo = ordersList[i].IsCombo;
                item.ItemName = ordersList[i].ITName;
                item.Rate = ordersList[i].Rate;
                item.Quantity = ordersList[i].Quantity;
                shiftItemList.push(item);
            }
        }
        $('.ordQnty').html(0);
        bindShiftingItemsList();
    });
    $('.shiftThisItem').on('click', function () {
        var row = $(this).closest('tr');
        var qnty = parseFloat($(row).find('td:eq(2)').text());
        var data = $(this).attr('id').split('_');
        var found = false;
        $.each(shiftItemList, function (index, item) {
            if (item.ItemId == data[0] && String(item.IsCombo) == data[1]) {
                if (qnty > 0 && qnty > 1) {
                    item.Quantity += 1;
                    qnty -= 1;
                } else if (qnty > 0 && qnty <= 1) {
                    item.Quantity += qnty;
                    qnty = 0;
                }
                else {
                    jAlert('No Quantity Remaining', 'Alert!!');
                }
                found = true;
            }
        });
        if (!found) {
            var item = new Object();
            item.ItemId = data[0];
            item.IsCombo = data[1];
            item.ItemName = data[2];
            if (qnty > 0 && qnty > 1) {
                item.Quantity = 1;
                qnty -= 1;
            } else if (qnty > 0 && qnty <= 1) {
                item.Quantity = qnty;
                qnty = 0;
            }
            shiftItemList.push(item);
        }
        $(row).find('td:eq(2)').text(qnty);
        bindShiftingItemsList();
    });
}

function bindShiftingItemsList() {
    var htmls = '';
    var i = 1;
    $.each(shiftItemList, function (index, item) {
        htmls += '<tr>';
        htmls += '<td>' + i + '</td>';
        htmls += '<td>' + item.ItemName + '</td>';
        htmls += '<td>' + item.Quantity + '</td>';
        htmls += '<td><img src="/Images/deduct.png" class="deductThisItem preview-icon" type="button"  id="ded_' + item.ItemId + '_' + item.IsCombo + '" /></td>';
        htmls += '</tr>';
        i++;
    })
    $('#tblitemsList>tbody').html(htmls);
    $('.deductThisItem').on('click', function () {
        var data = $(this).attr('id').split('_');
        var row = $('#tr_' + data[1] + '_' + data[2]).closest('tr');
        var thisrow = $(this).closest('tr');
        var qnty = parseFloat($(row).find('td:eq(2)').text());
        var thisqnty = parseFloat($(thisrow).find('td:eq(2)').text());
        var ind = 0;
        $.each(shiftItemList, function (index, item) {
            if (item.ItemId == data[1] && String(item.IsCombo) == data[2]) {
                if (thisqnty > 0 && thisqnty > 1) {
                    qnty += 1;
                    item.Quantity -= 1;
                    thisqnty -= 1;
                } else if (thisqnty > 0 && thisqnty <= 1) {
                    qnty += item.Quantity;
                    item.Quantity = 0;
                    thisqnty = 0;
                    ind = index;
                }
            }
        });
        $(row).find('td:eq(2)').text(qnty);
        if (thisqnty == 0) {
            shiftItemList.splice(ind, 1);
            $(thisrow).remove();
        } else {
            $(thisrow).find('td:eq(2)').text(thisqnty);
        }
    });
    $('#deductAllItems').on('click', function () {
        shiftItemList = [];
        bindOrderList();
    });
}
function getRooms() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebService.asmx/getRooms",
        data: JSON.stringify(),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var roomsList = JSON.parse(data.d);
            var htmls = '';
            // $('#toRooms').html(htmls)
            htmls += '<option selected disabled>-- Select --</option>';
            $.each(roomsList, function (index, room) {
                htmls += '<option value="' + room.restroRoomId + '">' + room.restroRoom + '</option>';
            });
            $('#toRooms').html(htmls)
            $('#toRooms').off().on('change', function () {
                bindTables($('#toRooms').val());
                $('#toTables').change();
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function bindTables(roomID) {
    var htmls = '';
    $('#toTables').html(htmls)
    $.each(tablesList, function (index, table) {
        if ((table.restroRoomId == roomID && table.IsTable == 0 && table.restrotablesStatusID != 6) || (table.restroRoomId == roomID && table.IsTable == 1)) {
            htmls += '<option value="' + table.restrotableId + '" attr-GN="' + table.GuestNo + '">' + table.restrotableTitle + '</option>';
        }
    });
    $('#toTables').html(htmls)
    $('#toTables').on('change', function () {

        var guestNo = $('option:selected', this).attr('attr-GN');
        var gn = '';
        gn += '<option value="1">1' + (guestNo == 0 ? ' (New)' : '') + '</option>'
        for (i = 1; i < guestNo; i++) {
            gn += '<option value="' + (i + 1) + '">' + (i + 1) + (i == guestNo ? '(New)' : '') + '</option>'
        }
        $('#toSplitNo ').html(gn)
    });
}
function getTables() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebService.asmx/getTablesData",
        data: JSON.stringify(),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            tablesList = [];
            tablesList = JSON.parse(data.d);

        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function shiftItems() {
    debugger;
    var shift = new Object();
    shift.shiftType = $('#selShiftType').val();
    shift.OrderMasterID = fromOrderMasterId;
    shift.OrderNo = fromOrderNo;
    shift.fromTable = tableId;

    var tableF = tablesList.filter((val) => val.restrotableId == tableId);
    if (tableF != null) {
        shift.fromTableTitle = tableF[0].restrotableTitle;
    } 

    shift.toTable = $('#toTables').val() == null ? tableId : $('#toTables').val();
    var tableT = tablesList.filter((val) => val.restrotableId == shift.toTable);
    if (tableT != null) {
        shift.toTableTitle = tableT[0].restrotableTitle;
    }
    shift.fromSplitNo = $('#fromSplitNo').val();
    shift.toSplitNo = $('#toSplitNo').val();
    shift.shiftedBy = $('#hdnPinBy').val();
    shift.itemList = shiftItemList;
    debugger;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebService.asmx/shiftItemsWeb",
        data: JSON.stringify({ shiftItems: shift }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $('#shiftItems').dialog('close');
            jAlert('Item Successfully Shifted', 'Information!!', function () {
                $(".ui-dialog-content").dialog("close");
                // $('.imgRoom').click();              
                parent.$.colorbox.close();
            });
            $('#hdnPinFor').val("");
            $('#hdnPinMatch').val("false");
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function Checkbillgenerated() {
    var SeatNo = $('#fromSplitNo').val();
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RestroDashboard/services/DashBoardWebService.asmx/checkOrder",
        data: JSON.stringify({ orderMasterId: fromOrderMasterId, seatNo: SeatNo, tableId: tableId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            if (result[0].ErrorNumber == 200) {
                if (shiftItemList.length > 0) {
                    if ($('#selShiftType').val() == "Regular") {
                        if ($('#toRooms').val() == null) {
                            jAlert('Please select Room', 'Alert!!');
                        }
                        else if ($('#toTables').val() == null) {
                            jAlert('Please select Table', 'Alert!!');
                        }
                        else {
                            jConfirm('Are you sure to shift table in <b>' + $('#toTables :selected').text() + '</b>', 'Confirmation!!', function (confirm) {
                                if (confirm) {
                                    $('#hdnPinFor').val('ShiftItem');
                                    InitializePin();
                                }
                            });
                        }
                    }

                    else {
                        jConfirm('Are you sure?', 'Confrmation!!', function (confirm) {
                            if (confirm) {
                                $('#hdnPinFor').val('ShiftItem');
                                InitializePin();
                            }
                        });
                    }

                } else {
                    jAlert('Select Items to Shift', 'Alert!!');
                }
            }
            else {
                jAlert(result[0].ErrorMessage, "Information!!", function () {
                });
            }
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
