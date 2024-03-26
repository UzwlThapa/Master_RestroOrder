function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&
        (charCode < 48 || charCode > 57)) {
        return false;
    }
    if ($(element).val().indexOf('.') != -1 && $(element).val().split('.')[1].length >= 2) {
        return false;
    }

    return true;
}
(function ($) {
    $.companyDashboardcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RestroDashboard/',
                 TypeId: '',
                 HostUrl: '',
             }, p);
        var v = 0;
        var pinMatch = false;
        var isMergedTable = false;
        var IsOccuoied = false;
        var shiftTable = "";
        var userRole = "";
        var CheckRole = false;
        var OrderMasterID = 0;
        var CancelTableID = 0;
        var IsEnableDiscount = false;
        var cancelreason = '';
        var fromOrderNo = 0;
        var DashboardFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 
                dataType: 'json',
                baseURL: p.ModulePath + "services/DashBoardWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                RoomId: 0,
                OrderId: 0,
                OrderUpdateId: 0,
                ShiftOrderMasterID: 0
            },

            InitialSetup: function () {
                DashboardFunction.GetTable();
                DashboardFunction.GetLayoutTable();
                DashboardFunction.GetRoomType();
                DashboardFunction.GetUserName();
            },
            init: function () {
                DashboardFunction.InitialSetup();

                $('.btnSumbit').unbind('click').on('click', function () {
                    var myStr = $(this).parent().children(".canceltextarea").val();
                    var newStr = myStr.replace(/  +/g, ' ');
                    if (newStr.length <= 4) {
                        jAlert('Please Insert Cancel Reason more than 4 words.', "Alert!!", function () { $.alerts.dialogClass = null; });
                    } else {
                        $(".canceltextarea").val(newStr);
                        DashboardFunction.CancelOrderedData();
                    }

                });

                 $('.confirmShift').on('click', function () {
                     jConfirm('Are You Sure  ?', 'Shift', function (confirmed) {
                         if (confirmed) {
                             $('#hdnPinFor').val('Shift');
                             InitializePin();
                         }
                     });
                 });

                 $(".imgroomtypeforshift").unbind('click').on('click', function () {
                     var id = $(this).children("option:selected").val();
                     if (id != "") {
                        DashboardFunction.GetUnoccupiedRoomByRoomTypeId(parseInt(id));
                    }
                   
                });
                 $('#hdnPinMatch').on('change', function () {
                     if ($('#hdnPinMatch').val() == "true") {
                         var pinFor = $('#hdnPinFor').val();
                         if (pinFor == 'enablebtn') {
                             var pin = $("#PINbox").val();
                             DashboardFunction.CheckRolesFromPin(pin);
                             if (IsEnableDiscount) {
                                 $("#selDiscountType").prop('disabled', false);
                                 $(".txtdiscount").prop('disabled', false);
                                 $("#enablebtn").hide();
                             }
                             else {
                                 jAlert('Discount is not Allowed', "Information!!", function () {
                                 });
                             }
                         } else if (pinFor == 'Shift') {
                             if (tabletoshift != "") {
                                 DashboardFunction.ShiftTable();
                             }
                         } else if (pinFor == 'generateBill') {
                             $('.paynows').click();
                         } else if (pinFor == 'CancelOrder') {
                             $('.cancelby').text($('#hdnPinBy').val());
                             $('#splitNoCancel').val($('#billno').val());
                             $('.canceltextarea').val('');
                             if ($(".ui-dialog").is(":visible")) {
                               
                             }else{
                                 $('#DisplayCancel').dialog({
                                     title: 'Cancel Order'
                                 });
                            
                             }
                           
                         }
                     }
                 });
                 PinCodeSetup();
                 NumCodeSetup();

                 $(".imgroomtypeformerge").on('change', function () {
                    var id = $(".imgroomtypeformerge").val();
                    DashboardFunction.GetRoomByRoomTypeIdForReservation(parseInt(id));

                });
                $(".imgroomtypeformerge").change();

                $(".btnSave").on("click", function () {
                    var TableList = [];
                    var slides = document.getElementsByClassName("imgtablelayout");
                    for (var i = 0; i < slides.length; i++) {
                        if (slides[i].checked) {
                            var data = slides[i].id.split('_');
                            TableList.push(parseInt(data[1]));
                        }
                    }
                    if (TableList.length > 0) {
                        //alert('Are You Sure  ?', 'Save Tables', function (confirmed) {
                        //    if (confirmed) {
                        //        DashboardFunction.SaveTables();
                        //    }
                        //});
                        var slides = document.getElementsByClassName("imgtablelayout");
                        RestroTableLayout = new Array;
                        for (var i = 0; i < slides.length; i++) {         
                            if (slides[i].checked) {
                                var tbl = new Object();
                                var data = slides[i].id.split('_');
                                tbl.TableID = parseInt(data[1]);
                                tbl.RoomID = parseInt($('.imgRoomLayout').val());
                                tbl.UserModuleID = parseInt(p.UserModuleID);
                                RestroTableLayout.push(tbl);
                            }
                        }
                        table = new Object();

                        var jsonText = JSON2.stringify({ table: RestroTableLayout });
                        DashboardFunction.config.method = "saveTableLayout";
                        DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                        DashboardFunction.config.data = jsonText;
                        DashboardFunction.config.ajaxCallMode = 3;
                        DashboardFunction.ajaxCall(DashboardFunction.config);

                    }
                    else {
                        jAlert('At least 1 table required', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }
                });


                PinCodeSetup();
                NumCodeSetup();
            },

            ajaxCall: function (config) {
                $.ajax({
                    type: DashboardFunction.config.type,
                    contentType: DashboardFunction.config.contentType,
                    async: DashboardFunction.config.async,
                    cache: DashboardFunction.config.cache,
                    url: DashboardFunction.config.url,
                    data: DashboardFunction.config.data,
                    dataType: DashboardFunction.config.dataType,
                    success: DashboardFunction.ajaxSuccess,
                    error: DashboardFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(DashboardFunction.config.ajaxCallMode)) {
                    case 0:
                        DashboardFunction.bindrestrolayout(data.d);
                        break;

                    case 1:
                        DashboardFunction.Bindroomforlayout(data.d);
                        $(".imgRoomLayout").change();
                        break;

                    case 2:
                        DashboardFunction.BindTableforlayout(data.d);
                        break;
                    case 3:
                        jAlert("Saved Succesfully");
                        break;
                    case 4:
                        DashboardFunction.bindrestrolayouttable(data.d);
                        break;
                    case 5:
                        DashboardFunction.BindTabledataById(data);
                        break;
                    case 6:
                        DashboardFunction.BindSalesBill(data, 1);
                        break;
                    case 7:
                        jAlert('Table Successfully Shifted', "Information!!", function () {
                            DashboardFunction.InitialSetup();
                            parent.$.colorbox.close();;
                        });

                        break;
                    case 8:
                        DashboardFunction.BindUnoccupiedRoomByRoomTypeId(data);
                        break;
                    case 9:
                        DashboardFunction.BindGetRoomType(data.d);
                        break;
                    case 10:
                        DashboardFunction.BindUnoccupiedTableByRoomTypeId(data);
                        break;
                    case 11:
                        var role = data.d;
                        userRole = role.Roles;
                        break;
                    case 12:
                        DashboardFunction.BindSalesBillForPay(data, 1);
                        break;
                    case 13:
                        $(".ui-dialog-content").dialog("close");
                         DashboardFunction.GetBill(data.d)
                         DashboardFunction.print();
                         $('#InvoiceType').html('INVOICE');
                        // $('.btnPrints').unbind('click').click();
                         DashboardFunction.savePrintCount();
                         DashboardFunction.GetUserName();
                         var paymentAfterGenerateBill = JSON.parse(localStorage.getItem("paymentAfterGenerateBill"));
                         if (paymentAfterGenerateBill) {
                            payment(data.d);
                         }
                        break;
                    case 14: 
                        $(".ui-dialog-content").dialog("close");
                        DashboardFunction.print();
                        break;
                    case 15:
                        jAlert('Ordered Cancelled successfully', "Information!!", function () { parent.$.colorbox.close(); });
                        break;
                }
            },
            ajaxFailure: function () {

            },

            //   <<-----------------------------Post & Get Here ---------------------------------------->>
            CancelOrderedData: function () {
                var id = OrderMasterID;
                var cancel = false;
                var ordermaster = new Object();
                ordermaster.TableId = CancelTableID,
                    ordermaster.OrderMasterID = OrderMasterID,
                    ordermaster.GuestNo = parseInt($('#splitNoCancel').text() == '' ? '1' : $('#splitNoCancel').text());
                ordermaster.CancelReason = $(".canceltextarea").val();
                ordermaster.CancelBy = $('#hdnPinBy').val();
                ordermaster.UserName = $('#hdnPinBy').val();
                ordermaster.IsCancelled = true,
                DashboardFunction.config.method = "CancelOrderIntoDataBase";

                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster });
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = jsonText;
                DashboardFunction.config.ajaxCallMode = 15;
                DashboardFunction.ajaxCall(DashboardFunction.config);
                DashboardFunction.config.ID = id;


            },

            GetDataForSalesBillFromPay: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 12;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetUserName: function () {
                var loggername = SageFrameUserName;
                DashboardFunction.config.method = "GetRolesByUsername";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ username: loggername });
                DashboardFunction.config.ajaxCallMode = 11;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetRoomType: function () {
                DashboardFunction.config.method = "getRoomType";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.config.data;
                DashboardFunction.config.ajaxCallMode = 9;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetUnoccupiedRoomByRoomTypeId: function (roomtypeid) {
                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 8;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetUnoccupiedTableByRoomTypeId: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 10;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            ShiftTable: function () {
                var tableID = tabletoshift;
                var ordermasterid = DashboardFunction.config.ShiftOrderMasterID;
                var fromSeatNo = $('.shiftingTableSeatNo').val();
                var toSeatNo = $('.shiftToTableSeatNo').val();
                var fromTableTitle = $('#shiftingTableName').text();
                var toTableTitle = $('#shiftToTableName').text();
                DashboardFunction.config.method = "shiftTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    ordermasterid: ordermasterid,
                    tableID: tableID,
                    fromSeatNo: fromSeatNo,
                    fromTableTitle: fromTableTitle,
                    toTableTitle: toTableTitle,
                    toSeatNo: toSeatNo,
                    OrderNo: fromOrderNo
                });
                DashboardFunction.config.ajaxCallMode = 7;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetDataForSalesBill: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 6;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
          
            GettabledataById: function (tableId) {
                DashboardFunction.config.method = "GettabledataByIdforMenu";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    TableId: tableId
                });
                DashboardFunction.config.ajaxCallMode = 5;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetLayoutTable: function () {
                
                DashboardFunction.config.method = "getLayoutTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({

                    UserModuleID: parseInt(p.UserModuleID)
                });
                DashboardFunction.config.ajaxCallMode = 4;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetTable: function () {
                DashboardFunction.config.method = "getTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.config.data;
                DashboardFunction.config.ajaxCallMode = 0;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetRoomByRoomTypeIdForReservation: function (roomtypeid) {
                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 1;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetTableByRoomTypeIdForReservation: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 2;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            bindrestrolayout: function (result) {
                
                tablelist = JSON.parse(result);
                $("#seltable").html('');
                var htmls = "";
                htmls += "<option value='0' selected>All</option>";
                $.each(tablelist, function (index, value) {
                    htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                });

                $("#seltable").html(htmls);

            },



            Bindroomforlayout: function (result) {
                var htmls = [];
                $('.RoomsForLayout').html("");

                var datas = JSON.parse(result);
                htmls += "<label>Rooms : </label> <select class='imgRoomLayout sfInputbox'>";
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += ("<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>");
                    });
                } else {
                    htmls += "No Data";
                }
                htmls += "</select>";
                $('.RoomsForLayout').html(htmls);

                $(".imgRoomLayout").on('change', function () {
                    var id = $(".imgRoomLayout").val();
                    RoomId = parseInt(id);
                    activeorder = id;
                    DashboardFunction.GetTableByRoomTypeIdForReservation(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;
                });

                $('.RoomsForLayout').show();
                // $('.TablesForLayout').hide();
            },

            BindTableforlayout: function (result) {
                var htmls = [];
                $('.TablesForLayout').html("");
                var datas = JSON.parse(result);
                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";
                    $.each(datas, function (index, value) {
                        htmls += "<li>"
                        htmls += ("<input type='checkbox' class='imgtablelayout' id='");
                        htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' /> ");
                        htmls += ("<label for ='");
                        htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = '' >");
                        htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tgreen.png'></label> ");
                        htmls += ("<h5 class='");
                        htmls += ("' >" + value.restrotableTitle + "</h5>");
                        htmls += ("</li>");

                    });
                    htmls += "</ul>";

                    $('.TablesForLayout').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });
                }

            },

            bindrestrolayouttable: function (result) {
                datas = JSON.parse(result);
                var htmls = [];
                var divID = '#ViewTable_' + p.UserModuleID
                $(divID).html("");
                var datas = JSON.parse(result);
                if (datas.length > 0) {
                    var sn = 1;
                    htmls += "<ul>";
                    $.each(datas, function (index, value) {
                        if (!(value.MergeTableList > 0 && value.MergeTableList != value.restrotableId)) {
                            htmls += ("<li>");
                            htmls += ("<a id ='" + (value.IsTable ? "Table_" : "Room_"));
                        if (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0') {
                            if (value.MergeTableList > 0) {
                                if (value.restrotablesStatusID == 6) {
                                    htmls += ("Table_" + value.restrotableId + "_img_yes_notoccupied_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = 'imgtable'>");
                                   
                                    htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tgreen.png'> ");
                                } else {
                                    htmls += ("Table_" + value.restrotableId + "_img_yes_occupied_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = 'imgtable' >");
                                   
                                    htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tred.png'>");
                                }
                            }
                            else {
                                if (value.restrotablesStatusID == 6) {
                                    htmls += ("Table_" + value.restrotableId + "_img_no_notoccupied_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = 'imgtable'>");
                                    
                                    htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tgreen.png'> ");
                                } else {
                                    htmls += ("Table_" + value.restrotableId + "_img_no_occupied_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = 'imgtable' >");
                                     
                                    htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tred.png'> ");
                                }
                            }
                        }
                        else {
                            htmls += ("Table_" + value.restrotableId + "_img_no_occupied_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = 'imgtable'>");
                           
                            htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tred.png'> ");
                        }
                        htmls += ("<h5 class='");
                        htmls += ("' >" + value.restrotableTitle + "</h5>");
                        htmls += ("</a></li>");
                    }
                        sn++;
                    });
                    htmls += "</ul>";

                    $('.TablesForLayout').html(htmls);

                } else {
                   // jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });
                }
                $(divID).html(htmls);

                $(".imgtable").unbind('click').on('click', function (){
                    var data = $(this).attr('id');
                    var id = data.split('_');
                    activeorder = id[2];
                    isMergedTable = (id[4] == "yes" ? true : false);
                    IsOccuoied = (id[5] == "occupied" ? true : false);
                    DashboardFunction.GettabledataById(id[2]);
                
                });
            },

            BindTabledataById: function (result) {
                ItemsArray = [];
                var htmls = '';
                $('#DialogOrderDetail').html("");
                var datas = JSON.parse(result.d);
                var amt = 0.0;
                var amountarray = [];
                var totalAmount = 0.0;
                var qnty = 0.0;
                var DialogWidth = '';
                var seatNo = 1;
                if (datas.length > 0) {
                    DialogWidth = '500';
                    htmls += "<div id='dialogOrderOpen'><div class='dialogflex'>"
                    htmls += "<h4>Details in " + (datas[0].Note != null && datas[0].Note != "" ? datas[0].Note : datas[0].restrotableTitle) + "</h4>";
                    htmls += "<div>Bill No: <select id='billno' class='sfInputbox' style='width:55px;'>";
                    var noOfGuest = parseInt(datas[0].GuestNo);
                    for (i = 1; i <= noOfGuest; i++) {
                        var count = 0;
                        $.each(datas, function (index, value) {
                            if (value.SeatNo == i) {
                                count++;
                            }
                            if (value.SeatNo > noOfGuest) {
                                noOfGuest = value.SeatNo;
                            }
                        });
                        if (i == seatNo && count == 0) {
                            seatNo++;
                        }
                        if (count > 0) {
                            htmls += (" <option value='" + i + "'>" + i + "</option> ");
                        }
                    }
                    htmls += "</select></div></div>";
                    htmls += ("<div class='item_list_div'><table class='item-list-tbl' style='margin-bottom:10px;'><thead><th style='width:250px'>Item</th><th>Qty</th><th>Rate</th><th>Amt</th></thead><tbody id='bindorderlist'>");
                    $.each(datas, function (index, value) {

                        var itemobject = {
                            OrderDetailsID: value.OrderDetailsID,
                            SeatNo: value.SeatNo,
                            restrotableId: value.restrotableId
                        }
                        ItemsArray.push(itemobject);
                        if (value.SeatNo == seatNo) {
                            htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + value.ITName + "</td>");
                            htmls += ("<td>" + value.Quantity + "</td>");
                            htmls += ("<td>" + value.SRate + "</td>");
                            qnty += parseFloat(value.Quantity);
                            amt = parseFloat(value.Quantity) * parseFloat(value.SRate);
                            totalAmount += parseFloat(amt);
                            htmls += ("<td>" + amt.toFixed(2) + "</td></tr>");
                        }
                    });
                    htmls += ("<tr class='Total_Amt'><td colspan='1'  style='text-align:right;font-weight:bold;'>Total Qnty:</td><td colspan='1' style='text-align:left;font-weight:bold;'>" + qnty.toFixed(2) + "</td>");
                    htmls += ("<td colspan='1'  style='text-align:right;font-weight:bold;'>Total Amount:</td><td colspan='1' style='text-align:left;font-weight:bold;'><span class='totle'>" + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tbody></table></div>");
    
                    if (datas[0].Note != null && datas[0].Note != "") {
                        htmls += ("<div class='ordering'><input id='Merge_" + datas[0].restrotableId + "' type='button' class='sfBtn removeMerge restro-btn' value='Remove Merge' />");
                    } else {
                        htmls += ("<div class='ordering'><input id='Shift_" + datas[0].OrderMasterId + "_" + datas[0].restrotableTitle + "_" + datas[0].GuestNo + "_" + type.OrderNo + "' type='button' class='sfBtn shiftTable restro-btn' value='Shift Table' />");
                    }
                    htmls += ("<input id='Order_" + datas[0].restrotableId + "' type='button' class='sfBtn ordernow restro-btn' value='Order Now ' style='margin-left:10px;' />");
                    htmls += ("<input id='shiftItems_" + datas[0].OrderMasterId + "_" + datas[0].restrotableId + "_" + datas[0].GuestNo + "' type='button' class='sfBtn shiftItems restro-btn' value='Shift Items ' style='margin-left:10px;' />");
                    var Roles = userRole.split(",");

                    if (Roles.includes("Cancel Order") || Roles.includes("Super User")) {
                        htmls += ("<input id='Cancel_" + datas[0].OrderMasterId + "_" + datas[0].restrotableId + "_" + datas[0].GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel Order ' style='margin-left:10px;' />");
                    }
                
                    if (Roles.includes("cashier") || Roles.includes("Super User")) {
                        htmls += ("<input id='Pay_" + datas[0].restrotableId + "_" + datas[0].OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay Bill ' style='margin-left:10px;'/></div></div>");
                    }
                    else {
                        htmls += ("<input id='Pay_" + datas[0].restrotableId + "_" + datas[0].OrderMasterId + "' type='button'  class='sfBtn viewnow restro-btn' value='View Bill ' style='margin-left:10px;'/></div></div>");
                    }

                } else {

                    DialogWidth = '300'
                    if (!IsOccuoied) {
                        if (!isMergedTable) {
                            var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(activeorder);
                            window.location.href = url;
                        } else {
                            htmls += ("<h5>No Orders made </h5>");
                            htmls += ("<input id='Pay_" + activeorder + "' type='button' class='sfBtn neworder restro-btn' value='Order Now ' />");
                        }
                    } else {
                        htmls += ("<h4>Bill not Cleared </h4>");
                    }
                    if (isMergedTable) { 
                    } 
                }
                $('#DialogOrderDetail').html(htmls);
                if (datas.length > 0) {
                    $('.shiftItems').on('click', function () {
                        shiftItemsInitialize();
                        var ordermasterid = $(this).attr('id').split('_')[1];
                        tableId = $(this).attr('id').split('_')[2];

                        getDataForShift(ordermasterid);
                        $('#btnShiftItem').bind('click');
                        $(this).offsetParent().dialog('close');
                    });

                }
                $(".splithead").hide();
                $("#DDsplited").on('change', function () {
                    var valu = $("#DDsplited").val();
                    if (valu == '0') {
                        $(".allsplited").show();
                        $('.totle').html(amountarray[valu]);
                        GoSplit = 0;
                    } else {
                        $(".allsplited").hide();
                        $("." + valu).show();
                        $('.totle').html(amountarray[valu]);
                        GoSplit = 1;
                    }

                });  

                if (!(!IsOccuoied && !isMergedTable)) {
                    $('#DialogOrderDetail').dialog(
	                    {
	                        'title': 'ORDER LIST',
	                        width: DialogWidth,
	                        height: 'auto',
	                        modal: true,
	                        position: ['center', 'center']
	                    });
                }
 
                $('.neworder').on('click', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });


                $('.DialogOrderDetail').on('change', '#billno', function () {
                    var selectedBillNo = parseInt($('#billno').val());
                    $("#bindorderlist").html('');
                    var htmls;
                    var i = 1;
                    totalAmount = 0.00;
                    $.each(datas, function (index, value) {
                        if (value.SeatNo == selectedBillNo) {
                            htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + value.ITName + "</td>");
                            htmls += ("<td>" + value.Quantity + "</td>");
                            htmls += ("<td>" + value.SRate + "</td>");
                            amt = parseFloat(value.Quantity) * parseFloat(value.SRate);
                            totalAmount += parseFloat(amt);
                            htmls += ("<td>" + amt.toFixed(2) + "</td></tr>");
                        }

                    });
                    htmls += ("<tr class='Total_Amt'><td colspan='3'  style='text-align:right;'>Total Amount:</td><td colspan='1' style='text-align:left;'><span class='totle'>" + totalAmount.toFixed(2) + "</span></td></tr>");

                    $("#bindorderlist").html(htmls);
                });
                $('.ordering').unbind('click').on('click', '.removeMerge', function () {
                    var tableid = $(this).attr('id').split("_")[1];

                    jConfirm('Are You Sure  ?', 'Remove Merge', function (confirmed) {
                        if (confirmed) {
                            DashboardFunction.config.method = "UnMergeTable";
                            DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                            DashboardFunction.config.data = JSON2.stringify({ tableId: tableid });
                            DashboardFunction.config.ajaxCallMode = 55;
                            DashboardFunction.ajaxCall(DashboardFunction.config);
                        }
                    });
                });
                $('.ordering').unbind('click').on('click', '.cancelorder', function () {
                    $(this).offsetParent().dialog('close');
                    OrderMasterID = $(this).attr('id').split("_")[1];
                    CancelTableID = $(this).attr('id').split("_")[2];
                    var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                    var htmls = "";
                    $('.splitNoCancel').html('');
                    for (i = 1; i <= noOfSeat; i++) {
                        htmls += '<option value="' + i + '">' + i + '</option>';
                    }
                    $('.splitNoCancel').html(htmls);
                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();

                }); 
                $('.ordering').on('click', '.shiftTable', function () {
                    $(this).offsetParent().dialog('close');
                    DashboardFunction.config.ShiftOrderMasterID = $(this).attr('id').split("_")[1];
                    fromOrderNo = $(this).attr('id').split("_")[5];
                    $('.shiftingTableName').html($(this).attr('id').split("_")[2]);
                    var seatNo = $(this).attr('id').split("_")[3];
                    $('.shiftingTableSeatNo').html('<option value="0">ALL</option>');
                    for (var i = 1; i <= seatNo; i++) {
                        $('.shiftingTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
                    }
                    $(".imgroomtypeforshift").val("");
                    $(".imgRoomForShift").val("");
                    $(".TablesForShift").hide(); 
                    $('#divForRoomTableShift').dialog({
                        'title': 'Shift Table',
                        width: 700,
                        height: 'auto',
                        modal: true,
                    });
                });
                 
                $('.ordering').on('click', '.ordernow', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });
                 
                $('.ordering').on('click', '.viewnow', function () {
                    $(this).offsetParent().dialog('close');
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    
                    DashboardFunction.GetDataForSalesBill(data[2]);
                    
                });
                 
                $('.ordering').on('click', '.paynow', function () {
                    $(this).offsetParent().dialog('close');
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBillFromPay(data[2]);

                }); 
            },

            BindSalesBill: function (result, seatNo) {
                var datas = JSON.parse(result.d);
                const orderdetails = datas.orderDetail;
                var billingterms = datas.billingTerm;
                var costcenters = datas.cuscenter;
                var tableinfo = datas.RoomBooking;
                var htmls = "";
                $('#DialogDetail').html("");
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
                var DialogWidth = '900';
                var noOfGuest = 1;
                htmls += "<div id='dialogOrderOpen'>";
                htmls += ("<div class='dashboardmain'>");
                if (orderdetails.length > 0) {
                    noOfGuest = parseInt(orderdetails[0].GuestNo);
                    htmls += ("<div class='left-sec' style='width:100%;margin-right:0;'><div class='dialogflex'><h4>Room : " + orderdetails[0].restroRoom + "  / Table : " + (orderdetails[0].MergeTableName != "" && orderdetails[0].MergeTableName != null ? orderdetails[0].MergeTableName : orderdetails[0].restrotableTitle) + " </h4><h4> Waiter: " + orderdetails[0].Waiter + "</h4></div>");
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
                        }
                        if (count > 0) {
                            htmls += (" <option value='" + i + "'>" + i + "</option> ");
                        }
                    }
                    htmls += "</select></div></div>";
                    htmls += ("<table class='item-list-tbl' style='margin-bottom:10px;'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th class='tdrate'>Rate (Rs.)</th><th class='tdrate'>Amt (Rs.)</th></thead><tbody id='salesDetailsTbl'>");

                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        if (value.SeatNo == seatNo) {
                            htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                            htmls += ("<td>" + value.Quantity + "</td>");
                            htmls += ("<td class='item-rate tdrate'>" + value.Rate + "</td>");
                            amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                            totalAmount += parseFloat(amt); 
                            htmls += ("<td class='item-amount tdrate'>" + amt + "</td></tr>");
                            if (value.CostCenterId == 2) {
                                barAmount += amt;
                            }
                            else if (value.CostCenterId == 95) {
                                bakeryAmount += amt;
                            }
                            else if (value.CostCenterId == 97) {
                                pizzaAmount += amt;
                            }
                            else {
                                kotAmount += amt;
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
                                amt = parseFloat(rate);
                                totalAmount += parseFloat(amt); 
                                htmls += ("<td class='item-amount'>" + amt + "</td></tr>");

                                if (value.CostCenterId == 2) {
                                    barAmount += amt;
                                }
                                else if (value.CostCenterId == 95) {
                                    bakeryAmount += amt;
                                }
                                else if (value.CostCenterId == 97) {
                                    pizzaAmount += amt;
                                }
                                else {
                                    kotAmount += amt;
                                } 
                            }
                            sn++;
                        }
                    });
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='5' style='text-align:right;'><span class='totle'>Amount : Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
                } else {
                    htmls += ("<div class='left-sec' style='width:100%;margin-right:0;'><h4>Room : " + "  / Table : " + tableinfo.restrotableTitle + " </h4><h4> Waiter: " + "</h4>");
                }

                if (tableinfo.RoomBookDetailsID > 0) {
                    htmls += ("<h5>Room Charge Details : </h5>");
                    htmls += ("<table class='room-details-tbl'><thead><th>Room Name</th><th style='width:250px'>Rate</th><th>Days</th><th class='tdrate'>Amt (Rs.)</th></thead><tbody>");
                    htmls += ("<tr><td>" + tableinfo.restrotableTitle + "</td>");
                    htmls += ("<td>" + tableinfo.Rate + "</td>");
                    htmls += ("<td>" + tableinfo.BookedDays + "</td>");
                    htmls += ("<td class='tdrate'>" + tableinfo.Rate * tableinfo.BookedDays + "</td></tr>");
                    roomAmount += tableinfo.Rate * tableinfo.BookedDays;
                    totalAmount += roomAmount;
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='4' style='text-align:right;'><span class='roomtotle'>Amount : Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
                }

                htmls += ("<div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'>");

                totaldis = 0;

                htmls += ("</div>");

                htmls += '<div id="divBillingTerm"></div></div></div>';
                htmls += ("</div></div></div></div>");
                var orderMasterId = tableinfo.OrderMasterId;
                $('#DialogDetail').html(htmls);
                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                $('#billnoForSales').val(seatNo);
                $('#DialogDetail').dialog(
               {
                   'title': 'Sales Bill',
                   width: DialogWidth,
                   height: 'auto',
                   modal: true,
                   position: ['center', 'center']
               });

                $('#billnoForSales').on('change', function () {
                    var Roles = userRole.split(",");
                    if (Roles.includes("cashier") || Roles.includes("Super User")) {
                        DashboardFunction.BindSalesBillForPay(result, parseInt($('#billnoForSales').val()));
                    }
                    else {
                        DashboardFunction.BindSalesBill(result, parseInt($('#billnoForSales').val()));
                    }
                    seatNo = $('#billnoForSales').val();
                });
            },

            BindBillingTerm: function (totalAmount, totaldis, datas) {
                if (totaldis == null || totaldis == "") {
                    totaldis = 0;
                }
                var htmls = "";
                $("#divBillingTerm").html(htmls);
                amntAfterDisc = 0;
                htmls += ("<table id='billingTerm'>");
                htmls += ("<tr>");
                htmls += (" <td attr-term='Total Discount' attr-percent='0' ><strong>Total Discount : </strong><input type=\"text\" value=\"Rs. " + parseFloat(totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
                htmls += (" <td attr-term='Total' ><strong>Total : </strong><input type=\"text\" value=\"Rs. " + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "'/></td></tr>");
                amntAfterDisc = (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2);
                netAmount = 0.00;
                $.each(datas.billingTerm, function (index, item) {
                   
                        if (item.BillTerm != "Evening Discount") {
                            if (item.BillTerm != "VAT") {
                                htmls += ("<tr>");
                                htmls += ("<td attr-term='" + item.BillTerm + "' attr-percent='" + item.Rate + "'  ><strong>" + item.BillTerm + " " + "(" + item.Rate + "%" + ")" + " : </strong>");
                                htmls += ("<input type=\"text\" id=\"BTerm_" + item.ID + "_" + item.IsAdd + "\" value=\"" + (item.IsAdd ? "" : "-") + "Rs. " + (amntAfterDisc * item.Rate / 100).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled  attr-amount='" + (amntAfterDisc * item.Rate / 100).toFixed(2) + "'/>");
                                htmls += ("</td>");
                                htmls += ("</tr>");
                                if (item.IsAdd == 1)
                                    netAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                                else
                                    netAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                            }
                        } 
                });

                netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc)).toFixed(2));
                if (datas.VATforBill) {
                    if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {
                        htmls += ("<tr>");
                        htmls += ("<td attr-term='Taxable Amount' attr-percent='0' ><strong>Taxable Amount : </strong><input type=\"text\" id=\"txtTaxableAmt\" value=\"Rs. " + netAmount.toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + netAmount.toFixed(2) + "'/></td>");
                        htmls += ("</tr>");
                        htmls += ("<tr>");
                        var vat = parseFloat(netAmount * 0.13).toFixed(2);
                        htmls += ("<td attr-term='VAT' attr-percent='13' ><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + datas.billingTerm[datas.billingTerm.length - 1].ID + "_true" + "\"  value=\"Rs. " + vat + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + vat + "'/></td>");
                        netAmount = (parseFloat(netAmount) + parseFloat(vat)).toFixed(2);
                        htmls += ("</tr>");
                    }
                }
                htmls += ("<tr>");
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
            },

            BindUnoccupiedRoomByRoomTypeId: function (result) {
                var htmls = [];
                $('.RoomsForShift').html("");
                var datas = JSON.parse(result.d);
                htmls += "<option value='' disabled selected>-- select --</option>";
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += ("<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>");
                    });
                } else {
                    htmls += "No Data";
                }
                $('.RoomsForShift').html(htmls);

                $(".RoomsForShift").change();
                $(".RoomsForShift").on('change', function () {
                    var id = $(this).children("option:selected").val();
                    RoomId = parseInt(id);
                    activeorder = id;
                    if (id != "") {
                        DashboardFunction.GetUnoccupiedTableByRoomTypeId(parseInt(id));
                    }
                    
                });
                $('.RoomsForShift').show();
                $('.TablesForShift').hide(); 
            },
             
            BindGetRoomType: function (result) {
                $('.imgroomtypeforshift').html("");
                var datas = JSON.parse(result);
                var htmls = "";
                 htmls += "<option value='' disabled selected>-- select --</option>";
                if (datas.length > 0) {
                  
                    $.each(datas, function (index, value) {
                        htmls += ("<option value='" + value.RoomTypeID + "'>" + value.Title + "</option>");
                    });
                } else {
                    htmls += "No Data";
                }
  
                $('.imgroomtypeforshift').html(htmls);
            },

            BindUnoccupiedTableByRoomTypeId: function (result) {
                var htmls = [];
                $('.TablesForShift').html("");
                $('#DialogOrderDetail').html("");
                var datas = JSON.parse(result.d);
                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";
                    $.each(datas, function (index, value) {
                        if (!value.MergeTableList > 0 && (value.IsTable || value.OrderMasterId > 0)) { 
                            htmls += ("<li>");
                            htmls += ("<a id ='");
                            htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + "_" + value.GuestNo + "' class = 'imgtableshift' ><img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + ((value.BillPaid != 0 || value.IsCancelled != 0) ? 'tablegreen' : 'tablered') + ".png'></a> ");
                            htmls += ("<h5 class='");
                            htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' ? "NotPaid" : "Paid");
                            htmls += ("' >" + value.restrotableTitle + "</h5>");
                            htmls += ("</li>");
                        }
                    });
                    htmls += "</ul>";

                    $('.TablesForShift').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });

                }

                $(".imgtableshift").click();

                $(".imgtableshift").on('click', function () {
                    var abc = $(this).attr('id').split('_');
                    tabletoshift = $(this).attr('id').split('_')[1];
                    $('.shiftToTableName').html($(this).attr('id').split('_')[4]);
                    var seatNo = $(this).attr('id').split("_")[5];
                    $('.shiftToTableSeatNo').html('<option value="0">New</option>');
                    for (var i = 1; i <= seatNo; i++) {
                        $('.shiftToTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
                    }
                });
                 
                $('.TablesForShift').show(); 
            },
            BindSalesBillForPay: function (result, seatNo) {
                var d = result.d;
                var datas = JSON.parse(d);
                const orderdetails = datas.orderDetail;
                var billingterms = datas.billingTerm;
                var costcenters = datas.cuscenter;
                var tableinfo = datas.RoomBooking;
                var tokeninfo = datas.Token;
                var htmls = "";
                $('#DialogDetail').html("");
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
                var DialogWidth = '800';
                var noOfGuest = 1;
                htmls += "<div id='dialogOrderOpen'>";
                htmls += ("<div class='dashboardmain'>");
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
                        }
                        if (count > 0) {
                            htmls += (" <option value='" + i + "'>" + i + "</option> ");
                        }
                    }
                    htmls += "</select></div></div>";
                    htmls += ("<table class='item-list-tbl' style='margin-bottom:10px;'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody id='salesDetailsTbl'>");

                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        if (value.SeatNo == seatNo) {
                            htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                            htmls += ("<td>" + value.Quantity + "</td>");
                            htmls += ("<td class='item-rate'>" + value.Rate + "</td>");
                            amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                            totalAmount += parseFloat(amt); 
                            htmls += ("<td class='item-amount'>" + amt + "</td></tr>");
                            if (value.CostCenterId == 2) {
                                barAmount += amt;
                            }
                            else if (value.CostCenterId == 95) {
                                bakeryAmount += amt;
                            }
                            else if (value.CostCenterId == 97) {
                                pizzaAmount += amt;
                            }
                            else {
                                kotAmount += amt;
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
                                amt = parseFloat(rate);
                                totalAmount += parseFloat(amt); 
                                htmls += ("<td class='item-amount'>" + amt + "</td></tr>");

                                if (value.CostCenterId == 2) {
                                    barAmount += amt;
                                }
                                else if (value.CostCenterId == 95) {
                                    bakeryAmount += amt;
                                }
                                else if (value.CostCenterId == 97) {
                                    pizzaAmount += amt;
                                }
                                else {
                                    kotAmount += amt;
                                } 
                            }
                            sn++;
                        }
                    });
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='4'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
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
                htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option><option value='4'>Promotion</option></select> </td>");
                htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable' style='width:50px;'/></td></tr>");
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>KOT ( Rs. " + kotAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtKotDiscount' value='" + costcenters[0].coDiscount + "' /></td>";
                totaldis += (parseFloat(kotAmount) * (parseFloat(costcenters[0].coDiscount) / 100));

                htmls += "</tr>";
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>Bar ( Rs. " + barAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtBarDiscount' value='" + costcenters[1].coDiscount + "' /></td>";
                htmls += "</tr>";
                totaldis += (parseFloat(barAmount) * (parseFloat(costcenters[1].coDiscount) / 100));

                htmls += "</tr>";
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>Bakery ( Rs. " + bakeryAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtBakeryDiscount' value='" + costcenters[2].coDiscount + "' /></td>";
                htmls += "</tr>";
                totaldis += (parseFloat(bakeryAmount) * (parseFloat(costcenters[2].coDiscount) / 100));

                htmls += "</tr>";
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>Pizza ( Rs. " + pizzaAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtPizzaDiscount' value='" + costcenters[4].coDiscount + "' /></td>";
                htmls += "</tr>";
                totaldis += (parseFloat(pizzaAmount) * (parseFloat(costcenters[4].coDiscount) / 100));

                htmls += "</tr>";
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
                    htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName"  value="' + tokeninfo[0].CustomerName + '" class="sfInputbox" value=""/><input type="hidden" id="txtCusID" value="" /></td></tr>';
                    htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber"  value="' + tokeninfo[0].Phone + '" class="txtnum sfInputbox"/></tr>';
                    htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr>';
                    htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                } else {
                    htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(tableinfo.CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>';
                     htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr>';
                    htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value=""/><input type="hidden" id="txtCusID" value="" /></td></tr>';
                    htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox"/></tr>';
                    htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr>';
                    htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                }

                htmls += '</tbody></table></div><input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/></div></div>';

                htmls += ("</div></div></div></div>");
                htmls += ("<input id='Pay_" + tableinfo.TableId + "_" + tableinfo.OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
                var orderMasterId = tableinfo.OrderMasterId;

                $('#DialogDetail').html(htmls);

                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                $('#billnoForSales').val(seatNo);
                $('#DialogDetail').dialog(
               {
                   'title': 'Sales Bill',
                   width: DialogWidth,
                   height: 'auto',
                   modal: true,
                   dialogClass: 'CheckEnable',
                   position: ['center', 'center']
               });
            
                if (tokeninfo.length > 0) {
                    if (tokeninfo[0].CustomerID > 0) {
                        DashboardFunction.getmembershiplistbyId(tokeninfo[0].CustomerID);
                    } 
                }
                
                $('#billnoForSales').on('change', function () {
                    var Roles = userRole.split(",");
                    if (Roles.includes("cashier") || Roles.includes("Super User")) {
                        DashboardFunction.BindSalesBillForPay(result, parseInt($('#billnoForSales').val()));
                    }
                    else {
                        DashboardFunction.BindSalesBill(result, parseInt($('#billnoForSales').val()));
                    }
                    seatNo = $('#billnoForSales').val();

                });

                $("#txtCardNumber").on('change', function () {
                    var info = $("#txtCardNumber").val();
                    if (info != "") {
                        DashboardFunction.GetmemberInfo(info);
                    }
                });

                $("#txtNumber").on('change', function () {
                    var info = $("#txtNumber").val();
                    if (info != "") {
                        DashboardFunction.GetmemberInfo(info);
                    }
                });

                $(".txtdiscount").on('click', function (event) {
                    InitializeNumPin(this, $(this).val());
                });

                $(".txtnum").on('click', function (event) {
                    InitializeNumPin(this, $(this).val());
                });


                $('.customerForCash').on('change', function () {
                    if ($('.customerForCash').prop('checked') == true) {
                        membershipfor = "PaymentLoyalty";
                        DashboardFunction.GetCustomeronChange();
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
                        $("#txtCusAddress").val();
                        $("#txtPan").val("");

                        $("#txtCashCusName").prop('disabled', false);
                        $("#txtCusAddress").prop('disabled', false);
                        $("#txtPan").prop('disabled', false);

                        $("#selDiscountType").val(1);
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

                    barAmount = 0.00;
                    kotAmount = 0.00;
                    totalAmount = 0.00;
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
                            itms += ("<tr class='allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                            itms += ("<td>" + value.Quantity + "</td>");
                            if ($("#selDiscountType").val() == "4") {
                                itms += ("<td class='item-rate'>" + 1 + "</td>");
                                amt = parseFloat(value.Quantity) * parseFloat(1);
                                $('#txtKotDiscount').prop('disabled', true);
                                $('#txtBarDiscount').prop('disabled', true);
                                $('#txtRoomDiscount').prop('disabled', true);
                                $('#txtBakeryDiscount').prop('disabled', true);
                                $('#txtPizzaDiscount').prop('disabled', true);

                            } else {
                                itms += ("<td class='item-rate'>" + value.Rate + "</td>");
                                amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                            }
                            totalAmount += parseFloat(amt); 
                            itms += ("<td class='item-amount'>" + amt.toFixed(2) + "</td></tr>");
                            if (value.CostCenterId == 2) {
                                barAmount += amt;
                            }
                            else if (value.CostCenterId == 95) {
                                bakeryAmount += amt;
                            }
                            else if (value.CostCenterId == 97) {
                                pizzaAmount += amt;
                            }
                            else {
                                kotAmount += amt;
                            }
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
                                if ($("#selDiscountType").val() == "4") { 
                                    amt = parseFloat(qnty);
                                } else { 
                                    amt = parseFloat(rate);
                                }
                                totalAmount += parseFloat(amt); 
                                itms += ("<td class='item-amount'>" + amt + "</td></tr>");

                                if (value.CostCenterId == 2) {
                                    barAmount += amt;
                                }
                                else if (value.CostCenterId == 95) {
                                    bakeryAmount += amt;
                                }
                                else if (value.CostCenterId == 97) {
                                    pizzaAmount += amt;
                                }
                                else {
                                    kotAmount += amt;
                                }
                            }
                            sn++;
                            $('.item-list-tbl tbody').append(itms);
                        }
                    });
                    totalAmount += roomAmount;
                    $('.totle').text('Rs. ' + (totalAmount - roomAmount).toFixed(2));
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


                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });


                $('#enablebtn').on('click', function () {
                    $('#hdnPinFor').val('enablebtn');
                    InitializePin();
                });
                $('.ui-dialog.CheckEnable').on('click', '.ui-dialog-titlebar .ui-dialog-titlebar-close', function () {
                    DashboardFunction.GetUserName();

                });

                $("#txtLoyaltyDiscount").on('change', function () {
                    $('#txtKotDiscount').val(0);
                    $('#txtBarDiscount').val(0);
                    $('#txtRoomDiscount').val(0);
                    $('#txtBakeryDiscount').val(0);
                    $('#txtPizzaDiscount').val(0);
                    totaldis += ((totalAmount) * (parseFloat($("#txtLoyaltyDiscount").val()) / 100));
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                })
                $('#txtKotDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtKotDiscount').val() > 100 || $('#txtKotDiscount').val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtKotDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtKotDiscount').val() > kotAmount || $('#txtKotDiscount').val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtKotDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtRoomDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });

                $('#txtBarDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtBarDiscount').val() > 100 || $('#txtBarDiscount').val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtBarDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtBarDiscount').val() > barAmount || $('#txtBarDiscount').val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtBarDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtRoomDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
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
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });
                $('#txtBakeryDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtBakeryDiscount').val() > 100 || $('#txtBakeryDiscount').val() < 0) {
                            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtBakeryDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtBakeryDiscount').val() > bakeryAmount || $('#txtBakeryDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtBakeryDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtRoomDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });

                $('#txtPizzaDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtPizzaDiscount').val() > 100 || $('#txtPizzaDiscount').val() < 0) {
                            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtPizzaDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtPizzaDiscount').val() > pizzaAmount || $('#txtPizzaDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtPizzaDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtRoomDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });


                $("#generateBill").on('click', function () {
                    $('#hdnPinFor').val('generateBill');
                    InitializePin();
                });


                var roles = userRole.split(',');
                if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                    $("#enablebtn").hide();
                }
                else {
                    $("#selDiscountType").prop('disabled', true);
                    $(".txtdiscount").prop('disabled', true);
                    $("#enablebtn").show();
                }

                $('.paynows').unbind('click').on('click', function () {
                    jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                        if (confirmed) {
                            var billingTerm = new Array();
                            var salesMaster = new Object();
                            var splited = 0;
                            var salesDetail = new Array();

                            salesMaster.billNo = tableinfo.BillNo;
                            salesMaster.BillDate = tableinfo.Date;
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
                            salesMaster.DeliveryCharge = 0;
                            salesMaster.DeliveredBy = "";
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

                            DashboardFunction.config.method = "SaveSalesBill";
                            DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                            DashboardFunction.config.data = JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount });
                            DashboardFunction.config.ajaxCallMode = 13;
                            DashboardFunction.ajaxCall(DashboardFunction.config);           
                        }
                    });
                });
            },
            GetBill: function (salesMasterId) {
                getBill(salesMasterId, false);
                $('#LayoutBillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'center'],
                    open: function () {
                        var df = $(this).children("#customer-bill").html();
                        $('#customer-bill').html(df);
                }
                });
               
                $('.btnPrints').unbind('click').on('click', function () {
                    $('#divPrintedOn').text(formatAMPM());
                    DashboardFunction.config.method = "savePrintCount";
                    DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                    DashboardFunction.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                    });
                    DashboardFunction.config.ajaxCallMode = 14;
                    DashboardFunction.ajaxCall(DashboardFunction.config);
                 
                });
            },

            print: function () {
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
            },
            Reset: function () {
                $(".ui-dialog-content").dialog("close");
                $('#TablesInRooms').hide();
                $("#PINbox").val('');
            },

            savePrintCount: function () {
                $('#divPrintedOn').text(formatAMPM());
                DashboardFunction.config.method = "savePrintCount";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                });
                DashboardFunction.config.ajaxCallMode = 14;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            }
          
        };
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);