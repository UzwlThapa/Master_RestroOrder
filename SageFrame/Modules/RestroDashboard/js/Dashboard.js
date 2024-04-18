
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $('#tabs').css('display', 'block');
    $.companyDashboardcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/RestroDashboard/',
                HostUrl: '',
                TypeId: '',
            }, p);
        var v = 0;
        var isSplit = 0;
        var GoSplit = 0;
        var activeorder = 0;
        var Tobepayedno = 0;
        var selectedTableId = 0;
        var checks = [];
        var ItemsArray = new Array();
        var noOfGuest = 0;
        var pinMatch = false;
        var isMergedTable = false;
        var IsOccuoied = false;
        var username = "";
        var totalamount = 0;
        var mergetableid = 0;
        var containOccTab = false;
        var CustID = 0;
        var OrderMasterID = 0;
        var CancelTableID = 0;
        var CustName = "";
        var membershipfor = "";
        var CustAddress = "";
        var pinfor = "";
        var tabletoshift = "";
        var CustPAN = "";
        var logoInfo = "";
        var body = "";
        var available = true;
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
                MenuId: 0,
                Menuupdate: 0,
                RoomId: 0,
                OrderId: 0,
                OrderUpdateId: 0,
                ShiftID: 0


            },
            InitialSetup: function () {

                DashboardFunction.GetOccupiedTables(true);
                DashboardFunction.GetOccupiedRooms();
                DashboardFunction.GetBookedRooms();

                $(".main").css("display", "block");
                //$("#CusOrder").show();
                if (p.TypeId == 0) {
                    $('.dineIn').attr('checked', true);
                    $(".com").hide();
                    $(".dine").show();
                }
                else if (p.TypeId == 1) {
                    $('.takeaway').attr('checked', true);
                    $(".com").show();
                    $(".dine").hide();
                }
                else {
                    $('.delivery').attr('checked', true);
                    $(".com").show();
                    $(".dine").hide();
                }
            },
            init: function () {
                //$('#DialogOrderDetail').html('');
                DashboardFunction.InitialSetup();
                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        //$('#hdnPinMatch').unbind('change');
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'Book') {
                            DashboardFunction.SaveRoomBook();
                        } else if (pinFor == 'Merge') {
                            var mergeTableList = [];

                            var slides = document.getElementsByClassName("imgtablemerge");
                            for (var i = 0; i < slides.length; i++) {
                                if (slides[i].checked) {
                                    var data = slides[i].id.split('_');
                                    mergeTableList.push(parseInt(data[1]));
                                }
                            }
                            if (mergeTableList.length > 1) {
                                jConfirm('Are You Sure  ?', 'Merge Tables', function (confirmed) {
                                    if (confirmed) {
                                        DashboardFunction.SaveMergeTables();
                                    }
                                });
                            }
                            else {
                                jAlert('At least 2 tables required to merge', "Alert!!", function () { $.alerts.dialogClass = null; });
                            }
                        } else if (pinFor == 'Shift') {
                            DashboardFunction.ShiftTable();
                        } else if (pinFor == 'generateBill') {
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

                $('#callwaiterDiv').on('click', '.waiters', function () {
                    var datas = $(this).attr('id');
                    var dataarray = datas.split('_');
                    var waiter = dataarray[1]
                    //var Ipurl = dataarray[1].WaiterIP + "/?Department=WaiterCall&ItemName=BY&TableName=Web";
                    DashboardFunction.callWaiter(waiter);
                });



                $('#callwaiter').click(function (e) {
                    e.stopPropagation();
                    DashboardFunction.GetWaiterLog();
                    $('#callwaiterDiv').dialog(
                        {
                            'title': 'Online Waiters',
                            width: 300,
                            height: 'auto',
                            modal: true,
                            position: ['center', 'center']
                        });

                    var effect = 'slide';
                    var options = { direction: 'right' };
                    var duration = 700;
                    $('.delivery').prop('checked', true);
                    $(".com").show();
                    $(".dine").hide();
                });

                $(".imgroomtype").on('click', function () {
                    $('#CusOrder').hide();
                    $('.hometab').hide();

                    $('#DialogOrderDetail').dialog(
                        {
                            'title': 'Order',
                            "resize": "auto",
                            width: 300,
                            position: 'center',

                        });
                    $('#DialogOrderDetail').dialog("close");
                    var data = $(this).attr('id');
                    var id = data.split('_')[0];
                    DashboardFunction.GetRoomByRoomTypeId(parseInt(id));
                });
                $('.restro-offer li#mergeTable').click(function (e) {
                    $(".TablesForMerge").hide();
                    $(".btnMerge").hide();
                    $(".imgroomtypeformerge").val("");
                    $(".imgRoomMerge").val("");
                    containOccTab = false;
                    $("#listForMerge").hide();
                    $("#tableForTempMerge tbody").html("");
                    $('#divForRoomTableMerge').dialog({
                        'title': 'Merge Tables',
                        width: 650,
                        height: 'auto',
                        modal: true,
                        position: ['center', 'center']
                    });
                });
                $(".imgtable").on('click', function () {
                    var data = $(this).attr('id');
                    var id = data.split('_');
                    activeorder = id[1];
                    DashboardFunction.GettabledataById(parseInt(id[1]));
                });
                $('#btnSumbit').on('click', function () {
                    DashboardFunction.CancelOrderedData();

                });
                $("#btnAddNewOrder").on('click', function () {
                    $("#CusOrder").dialog({
                        title: 'Add New Order',
                        "resize": "auto",
                        width: 300,
                    });
                });
                $("#btnSaveOrder").off().on("click", function (event) {

                    DashboardFunction.SaveCusOrder();

                });
                $("#membeshipformlist2").on('keyup', '#txtCalPaidAmount', function (event) {

                    var TotalAmount = parseFloat($("#txtCalTotalAmount").val());

                    var paidamount = parseFloat($("#txtCalPaidAmount").val());


                    var totalsum = TotalAmount;
                    if (paidamount > 0 && paidamount <= TotalAmount) {
                        totalsum = TotalAmount - paidamount
                    } else {
                        $("#txtCalPaidAmount").val("");
                    }


                    $("#txtCalRemainingAmount").val(totalsum.toFixed(2));
                })
                $("#membeshipformlist").on('click', '#Brandtable tr', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    if (membershipfor == "payment") {

                        var id = parseInt(ids[1]);

                        var rows = $(this).closest('tr');
                        CustID = id;
                        CustName = rows.find('td:eq(0)').text();
                        CustAddress = rows.find('td:eq(2)').text();
                        CustPAN = rows.find('td:eq(1)').text();

                        //$("#chkCus").prop("checked", true);

                        //totamount = $("#bindtotalamount").val();
                        DashboardFunction.DeleteItem(id);
                    } else if (membershipfor == "PaymentLoyalty") {
                        $("#txtCusID").val(ids[1]);
                        $("#txtCashCusName").val(ids[2] + " " + ids[3]);
                        $("#txtCusAddress").val(ids[5]);
                        $("#txtPan").val(ids[4]);

                        $("#txtCashCusName").prop('disabled', true);
                        $("#txtCusAddress").prop('disabled', true);
                        $("#txtPan").prop('disabled', true);

                        $("#txtLoyaltyDiscount").val(ids[6]);
                        $("#membeshipformlist").dialog('close');
                        //$("#selDiscountType").change();

                    } else if (membershipfor == "RoomBooking") {
                        $("#MemberID").val(ids[1]);
                        $("#MemberName").val(ids[2] + " " + ids[3]);
                        $("#MemberEmail").val("");
                        $("#MemberPhone").val(ids[7]);
                        $("#MemberIdCardNo").val('');
                        $("#membeshipformlist").dialog('close');
                    }

                });
                $("#btnPay").unbind('click').on("click", function () {
                    //var checkValid = companyProf.ValidationForm();
                    if ($("#selPayMode").val() != "" && $("#selPayMode").val() != null) {
                        if ($('#selPayMode').val() == 1) {
                            if (parseInt($('#hdnCusID').val() > 0)) {
                                DashboardFunction.UpdateTotalCashPaid();
                            }
                            DashboardFunction.UpdateSalesPayMode();
                        }
                        if ($('#selPayMode').val() == 2) {
                            if ($('#txtCheqNo').val() != null && $('#txtCheqNo').val() != "") {
                                if (parseInt($('#hdnCusID').val() > 0)) {
                                    DashboardFunction.UpdateTotalCashPaid();
                                }
                                DashboardFunction.UpdateSalesPayMode();
                            } else {
                                jAlert('Empty Cheque No.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            }
                        }
                        if ($('#selPayMode').val() == 3) {
                            if ($('#txtTransNo').val() != null && $('#txtTransNo').val() != "") {
                                if (parseInt($('#hdnCusID').val() > 0)) {
                                    DashboardFunction.UpdateTotalCashPaid();
                                }
                                DashboardFunction.UpdateSalesPayMode();
                            } else {
                                jAlert('Empty Transaction No.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            }
                        }
                    } else {
                        //companyProf.SaveAmount();
                        jAlert('Select Payment Mode', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }
                });
                $('#membeshipformlist').on('dialogclose', function () {
                    $("#selPayMode").val(1).change();
                });
                $("#UnpaidBills").on("click", ".btnViewBill", function () {
                    var ids = $(this).attr('id');
                    $("#UnpaidBills").dialog('close');
                    DashboardFunction.GetBill(ids);
                    //$('#printno').show();
                    $('#InvoiceType').html('INVOICE');
                });
                $("#UnpaidBills").on("click", ".btnPayBill", function () {
                    var datas = $(this).attr('id').split("_");
                    payment(datas[0]);
                    //var datas = $(this).attr('id').split("_");
                    //$("#hdfSalesMasterId").val(datas[0]);
                    //totalamount = datas[6];
                    //CustID = datas[1];
                    //CustName = datas[2];
                    //CustAddress = datas[3];
                    //CustPAN = datas[4];
                    //DashboardFunction.GetProviderList();
                    //$("#selPayMode").val(1);
                    //$("#selPayMode").change();
                    //$("#txtTotalAmount").val(datas[6]);
                    //$("#txtTenderAmount").val(datas[6])
                    //$("#txtReturnAmount").val(0)
                    //$("#txtTransNo").val('')
                    //$("#txtCheqNo").val('')

                    //$('#paymentSelect').dialog({
                    //    'title': 'Pay Bill : ' + datas[5],
                    //    width: 400,
                    //    modal:true,
                    //});
                    //$("#txtTenderAmount, #txtReturnAmount").on('click', function () {
                    //    $(this).val('');
                    //});
                    //$("#txtTotalAmount, #txtTenderAmount").on("keydown keyup", function () {
                    //    var returnAmnt = (Number($("#txtTenderAmount").val()) - Number($("#txtTotalAmount").val())).toFixed(2);
                    //    $("#txtReturnAmount").val((parseFloat(returnAmnt) > 0 ? parseFloat(returnAmnt) : 0));
                    //});
                    //$("#selPayMode").on('change', function () {
                    //    if ($("#selPayMode").val() == 1) {
                    //        //$("#calculator").show();
                    //        $(".cashpay").show();
                    //        $("#prov").hide();
                    //        $("#trans").hide();
                    //        $("#cheq").hide();
                    //    }
                    //    if ($("#selPayMode").val() == 2) {
                    //        //$("#calculator").hide();
                    //        $(".cashpay").hide();
                    //        $("#prov").show();
                    //        $("#trans").hide();
                    //        $("#cheq").show();
                    //        //$("#btnPay").show();
                    //    }
                    //    if ($("#selPayMode").val() == 3) {
                    //        //$("#calculator").hide();
                    //        $(".cashpay").hide();
                    //        $("#prov").show();
                    //        $("#trans").show();
                    //        $("#cheq").hide();
                    //        //$("#btnPay").show();
                    //    }
                    //    if ($("#selPayMode").val() == 4) {
                    //        //$("#calculator").hide();
                    //        $(".cashpay").hide();
                    //        $("#prov").hide();
                    //        $("#trans").hide();
                    //        $("#cheq").hide();
                    //        //$("#btnPay").show();
                    //        membershipfor = "payment";
                    //        if (CustID > 0)
                    //            DashboardFunction.DeleteItem(CustID);
                    //        else
                    //            DashboardFunction.GetCustomeronChange();
                    //        $("#CashPaid").hide();
                    //    }
                    //});
                });
                $(".btnMerge").on("click", function () {
                    $('#hdnPinFor').val('Merge');
                    InitializePin();
                });
                $("#membeshipformlist2").unbind('click').on('click', '.updatemember', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    DashboardFunction.UpdateCustomerName(ids[1]);
                });
                $('.restro-offer li#take-awayy').click(function (e) {
                    //var orderId = data.d;
                    var url = p.HostUrl + "/Order.aspx";
                    //var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(0);
                    window.location.href = url;
                });
                $('.restro-offer li#complementary').click(function (e) {
                    //var orderId = data.d;
                    var url = p.HostUrl + "/Complementary.aspx";
                    //var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(0);
                    window.location.href = url;
                });
                $('.restro-offer li#unpaid-bills').click(function (e) {
                    e.stopPropagation();
                    DashboardFunction.GetUnpaidBills();

                });
                $(".imgroomtypeformerge").on('change', function () {
                    var id = $(".imgroomtypeformerge").val();
                    DashboardFunction.GetRoomByRoomTypeIdForMerge(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;
                });
                $(".imgroomtypeforshift").on('click', function () {
                    var id = $(".imgroomtypeforshift").val();
                    DashboardFunction.GetUnoccupiedRoomByRoomTypeId(parseInt(id));
                });

                $('#txtBookFrom').datetimepicker({
                    //minDate: 'dateToday',
                    hour: 12,
                    minute: 00,
                    onSelect: function (date) {
                        var date2 = $('#txtBookFrom').datetimepicker('getDate');
                        date2.setDate(date2.getDate());
                        $('#txtBookTo').datetimepicker('option', 'minDate', date2);
                    },
                    onClose: function () {
                        var sDate = $('#txtBookFrom').val();
                        var eDate = $('#txtBookTo').val();
                        if (eDate != "") {
                            if (new Date(sDate) <= new Date(eDate)) {
                                DashboardFunction.CheckAvailability(sDate, eDate, $('#hdfRoomBookDetailId').val(), $('#hdfTableId').val());
                                if (available) {
                                    var diff = (new Date(eDate) - new Date(sDate));
                                    var days = (diff / 1000 / 60 / 60 / 24).toFixed(2);
                                    var FinalDays = 0;
                                    if (days.split(".")[1] != "00") {
                                        FinalDays = (parseInt(days.split(".")[0]) + 1);
                                    } else
                                        FinalDays = parseInt(days.split(".")[0]);

                                    $('#txtDays').val(FinalDays);
                                    $('#txtAmount').val((parseFloat(FinalDays) * parseFloat($('#txtRate').val())).toFixed(2));
                                    //$('#BookAdvancePay').val('0');
                                } else {
                                    jAlert('!!SORRY!! Room Not available for the selected Date and Time.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                    $('#txtBookFrom').val('');
                                    $('#txtBookTo').val('');
                                }
                            } else {
                                jAlert('Booking End Date Should be greater than Booking From Date.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                $('#txtBookFrom').val('');
                                $('#txtBookTo').val('');
                            }
                        }
                    }
                });
                $('#txtBookTo').datetimepicker({
                    hour: 12,
                    minute: 01,
                    onClose: function () {
                        var sDate = $('#txtBookFrom').val();
                        var eDate = $('#txtBookTo').val();
                        if (sDate != "") {
                            if (new Date(sDate) <= new Date(eDate)) {
                                DashboardFunction.CheckAvailability(sDate, eDate, $('#hdfRoomBookDetailId').val(), $('#hdfTableId').val());
                                if (available) {
                                    var diff = (new Date(eDate) - new Date(sDate));
                                    var days = (diff / 1000 / 60 / 60 / 24).toFixed(2);
                                    var FinalDays = 0;
                                    if (days.split(".")[1] != "00") {
                                        FinalDays = (parseInt(days.split(".")[0]) + 1);
                                    } else
                                        FinalDays = parseInt(days.split(".")[0]);

                                    $('#txtDays').val(FinalDays);
                                    $('#txtAmount').val((parseFloat(FinalDays) * parseFloat($('#txtRate').val())).toFixed(2));
                                    //$('#BookAdvancePay').val('0');
                                } else {
                                    jAlert('!!SORRY!! Room Not available for the selected Date and Time.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                    $('#txtBookFrom').val('');
                                    $('#txtBookTo').val('');
                                }
                            } else {
                                jAlert('Booking End Date Should be greater than Booking From Date.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                $('#txtBookFrom').val('');
                                $('#txtBookTo').val('');
                            }
                        } else {
                            jAlert('Select Booking Starting Date.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $('#txtBookTo').val('');
                        }
                    }
                });

                $('.btnBook').unbind('click').on('click', function () {
                    if ($('#txtBookFrom').val() != "" && $('#txtBookTo').val() != "" && $('#MemberName').val() != "" && $('#MemberPhone').val() != "") {
                        jConfirm('Are You Sure  ?', 'Book', function (confirmed) {
                            if (confirmed) {
                                $('#hdnPinFor').val('Book');
                                InitializePin();
                            }
                        });
                    } else {
                        jAlert('Enter Required (*) Fields.', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }

                });
                $('.btnCancelBook').on('click', function () {
                    $('.dashboardmain').dialog('close');
                });
                shiftItemsInitialize();
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
                        DashboardFunction.BindRoomByRoomTypeId(data);
                        break;
                    case 1:
                        DashboardFunction.BindTableByRoomTypeId(data);
                        break;
                    case 2:
                        DashboardFunction.BindTabledataById(data);
                        break;
                    case 3:

                        DashboardFunction.BindRoomdataById(data.d);

                        break;

                    case 4:
                        //alert('Order Saved SuccessFully');

                        //$("#CusOrder").dialog("close");
                        var orderId = data.d;
                        //   

                        var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(orderId);
                        window.location.href = url;
                        break;
                    case 5:
                        DashboardFunction.BindLoyaltyDetails(data);
                        break;
                    case 6:
                        DashboardFunction.GettabledataById(activeorder);
                        break;
                    case 7:
                        DashboardFunction.bindShiftTableData(data.d);
                        break;
                    case 8:
                        jAlert('Table Successfully Shifted', "Information!!", function () { $.alerts.dialogClass = null; });
                        DashboardFunction.Reset();
                        DashboardFunction.InitialSetup();
                        break;
                    case 9:
                        DashboardFunction.bindUnpaidBillsData(data.d);
                        break;
                    case 10:
                        DashboardFunction.Bindmembership(data);
                        break;
                    case 11:
                        DashboardFunction.Bindmember(data);
                        break;
                    case 12:
                        DashboardFunction.UpdateSalesPayMode();
                    case 13:
                        //alert("Bill Paid");
                        jAlert('Bill Successfully Paid', "Information!!", function () { $.alerts.dialogClass = null; });
                        DashboardFunction.Reset();
                        DashboardFunction.InitialSetup();
                        //location.reload();
                        //
                        return false;
                        break;
                    case 14:
                        DashboardFunction.BindProviderList(data.d)
                        break;
                    case 15:
                        var result = data.d;
                        if (result != null) {
                            pinMatch = true;
                            username = result;
                        }
                        else {
                            pinMatch = false;
                        }
                        break;
                    case 16:
                        jAlert('Ordered Cancelled successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        DashboardFunction.Reset();
                        DashboardFunction.InitialSetup();
                        //location.reload();
                        break;
                    case 49:
                        DashboardFunction.BindUnoccupiedRoomByRoomTypeId(data);
                        break;
                    case 50:
                        DashboardFunction.BindUnoccupiedTableByRoomTypeId(data);
                        break;
                    case 51:
                        DashboardFunction.BindRoomByRoomTypeIdForMerge(data);
                        break;
                    case 52:
                        DashboardFunction.BindTableByRoomTypeIdForMerge(data);
                        break;
                    case 53:
                        //alert("Tables Successfully Merged.");

                        var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(mergetableid);
                        window.location.href = url;
                        break;
                    case 54:
                        DashboardFunction.BindMergedTables(data);
                        break;
                    case 55:
                        jAlert('Tables Successfully Unmerged', "Information!!", function () {
                            $('.TablesInRooms').hide();
                        });
                        DashboardFunction.Reset();
                        DashboardFunction.InitialSetup();
                        //location.reload();
                        break;
                    case 56:
                        DashboardFunction.BindSalesBill(data, 1);
                        break;
                    case 57:
                        $('#DialogOrderDetail').dialog('close');

                        DashboardFunction.GetBill(data.d)
                        DashboardFunction.print();
                        //$('#printno').show();
                        $('#InvoiceType').html('INVOICE');
                        $('#btnPrints').click();
                        break;
                    case 58:
                        //DashboardFunction.bindBillBody(data.d);
                        break;
                    case 59:
                        //$('#printno').show();
                        DashboardFunction.print();
                        $('#BillingView').dialog('close');
                        DashboardFunction.GetOccupiedTables(true);
                        DashboardFunction.GetOccupiedRooms();
                        DashboardFunction.GetBookedRooms();
                        break;
                    case 60:

                        //if (data.d.length > 0) {
                        //    if (data.d[0].IsTable) {
                        DashboardFunction.BindOccupiedTable(data.d);
                        //} else {
                        //}
                        //}
                        break;
                    case 61:
                        if (data.d >= 1) {
                            available = false;
                        }
                        else {
                            available = true;
                        }
                        break;
                    case 62:
                        jAlert($('#hdfRoomBookDetailId').val() == "0" ? 'Booked Successfully..' : 'Booking Successfully Updated', "Information!!", function () {
                            $('.dashboardmain').dialog('close');
                            $('#DialogOrderDetail').dialog('close');
                            DashboardFunction.GetOccupiedRooms();
                            DashboardFunction.GetBookedRooms();
                        });
                        break;
                    case 63:
                        DashboardFunction.BindOccupiedRoom(JSON.parse(data.d));
                        break;
                    case 64:
                        DashboardFunction.BindBookedRoom(JSON.parse(data.d));
                        break;

                    case 65:
                        DashboardFunction.BindWaiterCallLog(data);
                        break;
                    case 67:
                        DashboardFunction.BindForEditingBooking(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            SaveRoomBook: function () {
                var ordermaster = new Object();
                ordermaster.UserName = $('#hdnPinBy').val();
                ordermaster.TableId = $('#hdfTableId').val();
                ordermaster.RoomId = ($('#hdfRoomId').val() == "" ? 0 : $('#hdfRoomId').val());
                ordermaster.Date = Date.now;
                ordermaster.BillPaid = 0;
                ordermaster.BillNo = '';
                ordermaster.Remarks = '';
                ordermaster.GuestNo = 1;

                var roomBook = new Object();
                roomBook.RoomBookDetailsID = $('#hdfRoomBookDetailId').val();
                roomBook.TableId = $('#hdfTableId').val();
                roomBook.BookedFrom = $('#txtBookFrom').val();
                roomBook.BookedTo = $('#txtBookTo').val();
                roomBook.BookedDays = $('#txtDays').val();
                roomBook.Rate = $('#txtRate').val();
                roomBook.TotalAmount = $('#txtAmount').val();
                roomBook.AdvancePayment = $('#BookAdvancePay').val();
                roomBook.CustomerId = $('#MemberID').val();
                roomBook.CustomerName = $('#MemberName').val();
                roomBook.PhoneNo = $('#MemberPhone').val();
                roomBook.EmailAddress = $('#MemberEmail').val();
                roomBook.CtznNo = $('#MemberIdCardNo').val();

                DashboardFunction.config.method = "SaveRoomBoking";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ roomBooking: roomBook, orderMaster: ordermaster });
                DashboardFunction.config.ajaxCallMode = 62;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetWaiterLog: function () {
                DashboardFunction.config.method = "GetWaiterLog";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.data;
                DashboardFunction.config.ajaxCallMode = 65;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            CheckAvailability: function (startDate, endDate, roombookDetailId, tableId) {

                DashboardFunction.config.method = "CheckAvailability";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, roombookDetailId: roombookDetailId, tableId: tableId });
                DashboardFunction.config.ajaxCallMode = 61;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetOccupiedTables: function (isTable) {

                DashboardFunction.config.method = "GetOccupiedTables";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ isTable: isTable });
                DashboardFunction.config.ajaxCallMode = 60;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetOccupiedRooms: function () {

                DashboardFunction.config.method = "GetOccupiedRooms";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify();
                DashboardFunction.config.ajaxCallMode = 63;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetBookedRooms: function () {

                DashboardFunction.config.method = "GetBookedRooms";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify();
                DashboardFunction.config.ajaxCallMode = 64;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetDataForSalesBill: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 56;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetBill: function (salesMasterId) {
                getBill(salesMasterId, false);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top']
                });

                $('#btnPrints').unbind('click').on('click', function () {
                    //DashboardFunction.print();
                    $('#divPrintedOn').text(formatAMPM());
                    DashboardFunction.config.method = "savePrintCount";
                    DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                    DashboardFunction.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                    });
                    DashboardFunction.config.ajaxCallMode = 59;
                    DashboardFunction.ajaxCall(DashboardFunction.config);
                });
            },


            ClearMergeList: function () {
                DashboardFunction.config.method = "ClearMergeList";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ tableId: mergetableid });
                //DashboardFunction.config.ajaxCallMode = 8;
                DashboardFunction.ajaxCall(DashboardFunction.config);

            },
            SaveMergeTables: function () {

                var slides = document.getElementsByClassName("imgtablemerge");
                var mergelist = 0;
                var i = 0
                while (mergelist < 1) {
                    if (slides[i].checked) {
                        var data = slides[i].id.split('_');
                        mergelist = data[1];
                    }
                    i++;
                }
                //mergetableid = parseInt(mergelist);
                mergetableid = (mergetableid > 0 ? mergetableid : parseInt(mergelist));
                mergeTableList = new Array;
                for (var i = 0; i < slides.length; i++) {
                    if (slides[i].checked) {
                        var data = slides[i].id.split('_');
                        merge = {
                            MergeID: parseInt(data[6]),
                            TableID: parseInt(data[1]),
                            MergeTableList: mergetableid,
                        }
                        mergeTableList.push(merge);
                    }
                }
                DashboardFunction.config.method = "MergeTables";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ mergeTableList: mergeTableList });
                DashboardFunction.config.ajaxCallMode = 53;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetMergedTables: function (tableId) {
                DashboardFunction.config.method = "GetMergedTables";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    tableId: tableId
                });
                DashboardFunction.config.ajaxCallMode = 54;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetRoomByRoomTypeIdForMerge: function (roomtypeid) {
                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 51;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetUnoccupiedTableByRoomTypeId: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeIdWeb";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 50;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetUnoccupiedRoomByRoomTypeId: function (roomtypeid) {
                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 49;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetTableByRoomTypeIdForMerge: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeIdWeb";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 52;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            ShiftTable: function () {
                var tableID = tabletoshift;
                var ordermasterid = DashboardFunction.config.ShiftID;
                DashboardFunction.config.method = "shiftTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ ordermasterid: ordermasterid, tableID: tableID });
                DashboardFunction.config.ajaxCallMode = 8;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetCustomeronChange: function () {
                var customer = 1;
                DashboardFunction.config.method = "getsdatass";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ customer: customer });
                DashboardFunction.config.ajaxCallMode = 10;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            callWaiter: function (waiterIp) {
                DashboardFunction.config.method = "callWaiter";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    WaiterIp: waiterIp
                });
                DashboardFunction.config.ajaxCallMode = 66;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            DeleteItem: function (id) {
                //var id = parseInt(item.id.split("_")[1])
                //$("#" + id + "_").remove();

                var membersid = id;

                DashboardFunction.config.method = "GetCusOnChange";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON.stringify({ MembershipID: membersid });
                DashboardFunction.config.ajaxCallMode = 11;

                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            UpdateCustomerName: function (id) {
                var MembersID = id;
                var MemberInfo = {};

                MemberInfo.MembershipID = MembersID;
                MemberInfo.RemainingBalance = parseFloat($('#txtCalRemainingAmount').val() == "" ? 0 : $('#txtCalRemainingAmount').val());
                MemberInfo.PayAmount = parseFloat($('#txtCalPaidAmount').val() == "" ? 0 : $('#txtCalPaidAmount').val());
                MemberInfo.AddedBy = SageFrameUserName;
                DashboardFunction.config.method = "SaveCustomerAmount";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ MemberInfo: MemberInfo });
                //if (companyProf.config.MemberIDUpdate == 1)
                {
                    DashboardFunction.config.ajaxCallMode = 12;
                    $("#membeshipformlist2").hide();
                }

                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetProviderList: function () {
                DashboardFunction.config.method = "GetProviderList";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.config.data;
                DashboardFunction.config.ajaxCallMode = 14;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            BindProviderList: function (data) {
                var htmls = "";
                $('#selProv').html(htmls);
                $.each(data, function (index, value) {
                    htmls += '<option value="' + value.ProviderID + '">' + value.ProviderName + '</option>';
                });
                $('#selProv').html(htmls);
            },
            UpdateSalesPayMode: function () {
                //var MembershipID = id;
                var salesPayment = {};
                salesPayment.salesMasterId = $('#hdfSalesMasterId').val();
                salesPayment.SPMID = $('#selPayMode').val();
                salesPayment.ChequeNo = ($('#selPayMode').val() == 2 ? $('#txtCheqNo').val() : "");
                salesPayment.TransactionNo = ($('#selPayMode').val() == 3 ? $('#txtTransNo').val() : "");
                salesPayment.ProviderID = (($('#selPayMode').val() == 3 || $('#selPayMode').val() == 2) ? $('#selProv').val() : "");
                salesPayment.TenderAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtTenderAmount').val() == "" ? 0 : $('#txtTenderAmount').val())) : 0);
                salesPayment.ReturnAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtReturnAmount').val() == "" ? 0 : $('#txtReturnAmount').val())) : 0);

                salesPayment.CusID = CustID;
                salesPayment.Customer = CustName;
                salesPayment.Address = CustAddress;
                salesPayment.PAN = CustPAN;
                DashboardFunction.config.method = "UpdateSalesPayMode";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ salesPayment: salesPayment });
                DashboardFunction.config.ajaxCallMode = 13;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            UpdateTotalCashPaid: function () {
                //var MembershipID = id;
                var MemberInfo = {};
                MemberInfo.MembershipID = membersid;
                MemberInfo.UptoNowPaid = $('#hdfBillAmount').val();
                DashboardFunction.config.method = "SaveTotalCashPaid";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ MemberInfo: MemberInfo });
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetUnpaidBills: function () {
                DashboardFunction.config.method = "GetUnpaidBills";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.ajaxCallMode = 9;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            bindUnpaidBillsData: function (datas) {
                var htmls = "";
                htmls += "<table id='tblforunpaidbills'>";
                htmls += "<thead><th>Bill No</th><th>Table</th><th>Amount</th><th></th><th></th></thead><tbody>";
                $.each(datas, function (index, item) {
                    htmls += "<tr><td>" + item.BillNo + "</td>";
                    htmls += "<td>" + item.TableName + "</td>";
                    htmls += "<td>" + item.BillAmount + "</td>";
                    htmls += "<td><label id='" + item.salesMasterId + "' class='sfBtn btnViewBill restro-btn' style='padding:1px 4px;'>View Bill</label></td>";
                    htmls += "<td><label id='" + item.salesMasterId + "_" + item.CusID + "_" + item.Customer + "_" + item.Address + "_" + item.PAN + "_" + item.BillNo + "_" + item.BillAmount + "' class='sfBtn btnPayBill restro-btn' style='padding:1px 4px;'>Pay Bill</label></td></tr>";
                });
                htmls += "</tbody></table>";
                $("#UnpaidBills").html(htmls);
                $("#tblforunpaidbills").dataTable({
                    "pageLength": 5,
                    "lengthMenu": [5, 10, 25],
                    "bPaginate": $('#tblforunpaidbills tbody tr').length > 7,
                    "iDisplayLength": 7,
                    "ordering": false,
                    "lengthMenu": [[5, 10, -1], [5, 10, "All"]]
                    //"lengthChange": false,
                });
                $('div.dataTables_filter input').addClass('sfInputbox');
                $('#UnpaidBills').dialog({
                    'title': 'Unpaid Bills',
                    width: 500,
                    modal: true,
                });
            },
            GetShifttabledata: function () {
                DashboardFunction.config.method = "Gettabledataforshift";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.ajaxCallMode = 7;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            bindShiftTableData: function (datas) {
                var htmls = '';
                htmls = "<option value='' disabled selected>-Select-</option>";
                $.each(JSON.parse(datas), function (index, item) {
                    htmls += "<option value='" + item.restrotableId + "'>" + item.restrotableTitle + "</option>";
                });
                $("#selShiftTable").html(htmls);
            },
            GetRoomByRoomTypeId: function (roomtypeid) {

                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 0;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetTableByRoomTypeId: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeIdWeb";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 1;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GettabledataById: function (tableId) {
                DashboardFunction.config.method = "GettabledataByIdforMenu";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    TableId: tableId
                });
                DashboardFunction.config.ajaxCallMode = 2;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },


            GetroomdataById: function (tableId) {
                DashboardFunction.config.method = "GetroomdataByIdforMenu";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    tableId: tableId
                });
                DashboardFunction.config.ajaxCallMode = 3;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            CheckLoyaltyForDiscount: function (loyaltyno, phoneno) {
                if (loyaltyno == '0') {
                    var loyal = 0;
                }
                else {
                    //if (loyaltyno.indexOf('_') > -1) {
                    //    var loylty = loyaltyno.split('_');

                    //    var loyal = loylty[1];
                    //}
                    //else {
                    //    var loyal = 0;
                    //}

                }

                DashboardFunction.config.method = "CheckLoyaltyForDiscount";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    // MembershipID: loyaltyno,
                    MembershipID: loyaltyno,
                    TelMobile: phoneno

                });
                DashboardFunction.config.ajaxCallMode = 5;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetBookDataForEditing: function (orderMasterId) {
                DashboardFunction.config.method = "GetBookDataForEditing";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 67;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            BindLoyaltyDetails: function (result) {
                $('.rightDiv').html("");
                //  $('.buttonDiv').html('');
                var datas = result.d;
                if (datas.length <= 0) {
                    $('.ok').show();
                    $(".cancel").show();
                    //$('.ok').val("");
                    //$(".cancel").val("");
                    jAlert('Data not found..', "Alert!!", function () { $.alerts.dialogClass = null; });
                    return;
                }
                var htmls = "";
                var htmlss = "";

                var gotloyaltyid = result.d[0].MembershipID;
                var gotPhoneNo = result.d[0].TelMobile;
                var loyaltyId = "ROL_" + gotloyaltyid;
                if (datas.length > 0) {
                    htmls += ("<div>Name: " + result.d[0].Fname + " " + result.d[0].Lname + "</div>");
                    htmls += ("<div>Address: " + result.d[0].Address + "</div>");
                    htmls += ("<div>City: " + result.d[0].City + "</div>");
                    htmls += ("<div>Country: " + result.d[0].Country + "</div>");
                    htmls += ("<div>Tel Home: " + result.d[0].TelHome + "</div>");
                    htmls += ("<div>Work: " + result.d[0].TelWork + "</div>");
                    htmls += ("<div>Mobile: " + result.d[0].TelMobile + "</div>");
                    htmls += ("<div>Email: " + result.d[0].Email + "</div>");
                    htmls += ("<div>Occupation: " + result.d[0].Occupation + "</div>");
                    htmls += ("<div>Company: " + result.d[0].Company + "</div>");
                    htmls += ("<div>Birthday: " + result.d[0].Birthday + "</div>");
                    htmls += ("<div>Anniversary: " + result.d[0].Anniversary + "</div>");
                    htmls += ("<div>Card No: " + result.d[0].CardNumber + "</div>");
                    htmls += ("<div>Date Of Issue: " + result.d[0].DateOfIssue + "</div>");
                    htmls += ("<div>Date Of Expire: " + result.d[0].DateOfExpire + "</div>");

                    htmlss += ("<input id='Pay_" + Tobepayedno + "' type='button' class='sfBtn restro-btn pay' value='Pay' />");
                    htmlss += ("<input type='button' class='sfBtn restro-btn cancel' value='Cancel' style='margin-left:10px;'/>");
                } else {
                    htmls += ("Name: " + value.Fname + " " + value.Lname + "<br />");
                    htmlss += ("<input type='button' class='sfBtn cancel' value='Cancel' />");
                }
                $('.rightDiv').html(htmls);
                $('.buttonDiv').html(htmlss);

                $(".pay").on('click', function () {
                    var data = $(this).attr('id');
                    var id = data.split('_');
                    var url = p.HostUrl + "/Sales-Bill.aspx?ID=" + Tobepayedno + "&loyaltyNo=" + loyaltyId + "&PhnNo=" + gotPhoneNo;
                    window.location.href = url;
                });

                $(".cancel").on('click', function () {
                    $('#DialogOrderDetail').dialog("close");
                });

            },
            BindTableByRoomTypeId: function (result) {

                var htmls = [];
                $('.TablesInRooms').html("");
                $('#DialogOrderDetail').html("");
                var datas = JSON.parse(result.d);

                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";

                    $.each(JSON.parse(datas), function (index, value) {
                        htmls += ("<a id ='" + (value.IsTable ? "Table_" : "Room_"));
                        if (value.BillPaid.toString() == '1') {
                            htmls += ("" + value.restrotableId + "_clearBill' class='imgtable'>");
                            htmls += ("<li style='width: 6rem !important;'>");
                            htmls += ("<img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + (value.IsTable ? "tableyellow.png" : "room-red.png") + "'> ");
                            htmls += ("<h5 style='color: #a9a960;font-weight:bold;font-size: 9pt;' class='");
                        }
                        else {
                            if (value.IsOccupied == 0) {
                                htmls += ("" + value.restrotableId + "_img_yes_notoccupied_" + value.restrotableTitle + "' class = 'imgtable'  >");
                                htmls += ("<li style='width: 6rem !important;'>");
                                htmls += ("<img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + (value.IsTable ? "tablegreen.png" : "room-green.png") + "'> ");
                                htmls += ("<h5 style='color: green;font-weight:bold;font-size: 9pt;' class='");
                            } else {
                                htmls += ("" + value.restrotableId + "_img_yes_occupied_" + value.restrotableTitle + "' class = 'imgtable'  >");
                                htmls += ("<li style='width: 6rem !important;'>");
                                htmls += ("<img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + (value.IsTable ? "tablered.png" : "room-red.png") + "'> ");
                                htmls += ("<h5 style='color: red;font-weight:bold;font-size: 9pt;' class='");
                            }
                        }

                        htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' && value.IsTable ? "NotPaid" : "Paid");
                        htmls += ("' >" + (value.MergeTableList > 0 ? value.MergeTableName : value.restrotableTitle) + "</h5>");

                        if (value.tableDate !== "") {
                            htmls += ("<h5 class='order-time'");
                            var dateprev = new Date(value.tableDate);
                            var datet = new Date();
                            var diff = (datet - dateprev) / 1000;
                            function secondsTimeSpanToHMS(s) {
                                var h = Math.floor(s / 3600); //Get whole hours
                                s -= h * 3600;
                                var m = Math.floor(s / 60); //Get remaining minutes
                                s -= m * 60;
                                if (h == 0) {
                                    return (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           
                                } else {
                                    return h + ":" + (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                          
                                }
                            }
                            var dinal = secondsTimeSpanToHMS(diff)
                            htmls += ("' >" + value.tabletime + "</h5><h5 class='order-timeA'>" + dinal + "</h5>");
                        }

                        htmls += ("</li></a>");
                    });
                    htmls += "</ul>";

                    $('.TablesInRooms').html(htmls);
                } else {
                    jAlert('No Tables Available in selected Room..', "Alert!!", function () { $.alerts.dialogClass = null; });
                }

                $(".imgtable").on('click', function () {
                    var data = $(this).attr('id');
                    var id = data.split('_');

                    if (id[2] == 'clearBill') {
                        jAlert("Please clear pending bill first!", 'Alert!!');
                    }
                    else {
                        activeorder = id[1];
                        isMergedTable = (id[3] == "yes" ? true : false);
                        IsOccuoied = (id[4] == "occupied" ? true : false);
                        if (id[0] == "Table") {
                            DashboardFunction.GettabledataById(id[1]);
                        }
                        if (id[0] == "Room") {
                            DashboardFunction.GetroomdataById(id[1]);
                        }
                    }
                });
                $('.TablesInRooms').show();
            },

            //<<----------------------------- Bind Here ---------------------------------------->>
            BindWaiterCallLog: function (result) {
                $('#callwaiterDiv').html("");

                var datas = result.d;
                var htmls = "";

                if (datas.length > 0) {
                    htmls = "<ul>";
                    $.each(datas, function (index, value) {
                        if (value.image == '') {
                            htmls += ("<li><span id='waiter_" + value.WaiterIP + "' class='waiters'> <img src='/Modules/Admin/UserManagement/UserPic/waiter.png'><span>" + value.WaiterName + "</span><i class='fas fa-bell'></i></span></li>");
                        }
                        else {
                            htmls += ("<li><span id='waiter_" + value.WaiterIP + "' class='waiters'><img src='/Modules/Admin/UserManagement/UserPic/" + value.image + "' ><span>" + value.WaiterName + "</span><i class='fas fa-bell'></i></span></li>");
                        }
                    });
                    htmls += "</ul>";

                } else {

                    htmls = "No Waiters Online";
                }
                $('#callwaiterDiv').html(htmls);

            },




            SaveCusOrder: function () {
                var Cusinfo = {};
                //  Cusinfo.OrderID = DashboardFunction.config.EmployeeId;
                Cusinfo.Name = $('#txtCusName').val();
                Cusinfo.OrderDate = $('#txtOrderDate').val();
                Cusinfo.OrderTime = $('#txtOrderTime').val();
                Cusinfo.People = 0;
                Cusinfo.AppoinmentReceiveTime = 0;
                Cusinfo.AppoinmentReceiveDate = 0;
                Cusinfo.Message = "";
                Cusinfo.CellNo = "";
                Cusinfo.FullAddress = "";
                var value = parseInt($('input[name="gender"]:checked').val());
                if (value == 0) {
                    Cusinfo.People = $("#txtPeople").val();
                    Cusinfo.isTakeAwayhome = false;
                }
                else if (value == 1) {
                    Cusinfo.isTakeAwayhome = true;
                    Cusinfo.AppoinmentReceiveTime = $('#txtAppReceiveTime').val();
                    Cusinfo.AppoinmentReceiveDate = $('#txtAppReceiveDate').val();
                    Cusinfo.Message = $('#txtmsg').val();
                    Cusinfo.CellNo = $('#txtCell').val();
                    Cusinfo.FullAddress = $('#txtAddress').val();
                }
                else {
                    Cusinfo.AppoinmentReceiveTime = $('#txtAppReceiveTime').val();
                    Cusinfo.AppoinmentReceiveDate = $('#txtAppReceiveDate').val();
                    Cusinfo.Message = $('#txtmsg').val();
                    Cusinfo.CellNo = $('#txtCell').val();
                    Cusinfo.isTakeAwayhome = false;
                    Cusinfo.FullAddress = $('#txtAddress').val();
                }
                Cusinfo.isTakeAwayhome

                DashboardFunction.config.method = "SaveCus";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ Cusinfo: Cusinfo });
                if (DashboardFunction.config.OrderUpdateId == 4) {
                    DashboardFunction.config.ajaxCallMode = 5;
                } else {
                    DashboardFunction.config.ajaxCallMode = 4;
                }

                DashboardFunction.ajaxCall(DashboardFunction.config);
                DashboardFunction.config.OrderUpdateId = 0;
            },

            BindRoomByRoomTypeId: function (result) {
                var htmls = [];
                $('.Rooms').html("");
                var datas = result.d;
                if (datas.length > 0) {
                    htmls += "<h4>Rooms</h4><hr><ul>";
                    $.each(datas, function (index, value) {
                        htmls += ("<a id ='");
                        htmls += ("Room_" + value.restroRoomId + "_img' class = 'imgRoom' >")
                        htmls += ("<li style='width: 6rem !important;'>");
                        htmls += ("<img src='" + p.HostUrl + "/Modules/RestroDashboard/image/room.png'> ");
                        htmls += ("<h5 class='NotPaid'>" + value.restroRoom + "</h5></li></a>");

                    });
                    htmls += "</ul>";

                    $('.Rooms').html(htmls);

                    DashboardFunction.GetTableByRoomTypeId(parseInt(datas[0].restroRoomId));

                } else {
                    $('.Rooms').html('No data');
                    $('.Tables').hide();
                    $('.TablesInRooms').hide();
                }
                $('.imgroomtype').on('click', function () {
                    $(this).closest('li').siblings('li').removeClass('active');
                    $(this).closest('li').addClass('active');
                });

                $(".imgRoom").on('click', function () {
                    $(this).closest('li').siblings('li').removeClass('active');
                    $(this).closest('li').addClass('active');
                    var data = $(this).attr('id');
                    var id = data.split('_');
                    RoomId = parseInt(id[1]);
                    activeorder = id[1];
                    DashboardFunction.GetTableByRoomTypeId(parseInt(id[1]));
                });

                $('.Rooms').show();
                $('#OccupiedRoomsdiv').hide();
                $('#BookedRoomsdiv').hide();
            },

            BindTabledataById: function (result) {
                ItemsArray = [];
                var htmls = '';

                $('#DialogOrderDetail').html("");
                var datas = result.d;
                var amt = 0.0;
                var amountarray = [];
                var totalAmount = 0.0;
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
                    htmls += ("<table class='item-list-tbl'><thead><th style='width:250px'>Item</th><th>Qty</th><th>Rate</th><th>Amt</th></thead><tbody id='bindorderlist'>");
                    $.each(JSON.parse(datas), function (index, value) {

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
                            amt = parseFloat(value.Quantity) * parseFloat(value.SRate);
                            totalAmount += parseFloat(amt);
                            htmls += ("<td>" + amt.toFixed(2) + "</td></tr>");
                        }
                    });
                    htmls += ("<tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Amount:</td><td colspan='1' style='text-align:left;font-weight:bold;'><span class='totle'>" + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tbody></table>");
                    if (datas[0].Note != null && datas[0].Note != "") {
                        htmls += ("<div class='ordering'><input id='Merge_" + datas[0].restrotableId + "' type='button' class='sfBtn removeMerge restro-btn' value='Remove Merge' />");
                    } else {
                        htmls += ("<div class='ordering'><input id='Shift_" + datas[0].OrderMasterId + "' type='button' class='sfBtn shiftTable restro-btn' value='Shift Table' />");
                    }
                    htmls += ("<input id='Order_" + datas[0].restrotableId + "' type='button' class='sfBtn ordernow restro-btn' value='Order Now ' style='margin-left:10px;' />");
                    htmls += ("<input id='shiftItems_" + datas[0].OrderMasterId + "_" + datas[0].restrotableId + "_" + datas[0].GuestNo + "' type='button' class='sfBtn shiftItems restro-btn' value='Shift Items ' style='margin-left:10px;' />");
                    htmls += ("<input id='Cancel_" + datas[0].OrderMasterId + "_" + datas[0].restrotableId + "_" + datas[0].GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel Order ' style='margin-left:10px;' />");
                    htmls += ("<input id='Pay_" + datas[0].restrotableId + "_" + datas[0].OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay Now ' style='margin-left:10px;'/></div></div>");

                } else {

                    DialogWidth = '300'
                    if (!IsOccuoied) {
                        htmls += ("<h5>No Orders made </h5>");
                        htmls += ("<input id='Pay_" + activeorder + "' type='button' class='sfBtn neworder restro-btn' value='Order Now ' />");
                    } else {
                        htmls += ("<h4>Bill not Cleared </h4>");
                    }
                    if (isMergedTable) {
                        htmls += ("<input id='Merge_" + activeorder + "' type='button' class='sfBtn removeMerge restro-btn' value='Remove Merge' style='margin-left:10px;' />");
                    }
                }
                $('#DialogOrderDetail').html(htmls);
                shiftItemsInitialize();
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

                $('#DialogOrderDetail').dialog(
                    {
                        'title': 'ORDER LIST',
                        width: DialogWidth,
                        height: 'auto',
                        modal: true,
                        position: ['center', 'center']
                    });
                $('.neworder').on('click', function () {

                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });
                $('#billno').change(function () {
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
                $('#DialogOrderDetail').on('click', '.shiftTable', function () {
                    $('#DialogOrderDetail').dialog('close');
                    DashboardFunction.config.ShiftID = $(this).attr('id').split("_")[1];
                    $(".imgroomtypeforshift").val("");
                    $(".imgRoomForShift").val("");
                    $(".TablesForShift").hide();
                    pinfor = "shift";
                    $('#divForRoomTableShift').dialog({
                        'title': 'Shift Table',
                        width: 650,
                        height: 'auto',
                        modal: true,
                    });
                });
                $('#DialogOrderDetail').unbind('click').on('click', '.removeMerge', function () {
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
                $('#DialogOrderDetail').on('click', '.cancelorder', function () {
                    $('#DialogOrderDetail').dialog('close');
                    OrderMasterID = $(this).attr('id').split("_")[1];
                    CancelTableID = $(this).attr('id').split("_")[2];
                    var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                    var htmls = "";
                    $('#splitNoCancel').html('');
                    for (i = 1; i <= noOfSeat; i++) {
                        htmls += '<option value="' + i + '">' + i + '</option>';
                    }
                    $('#splitNoCancel').html(htmls);
                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();
                });
                $('#DialogOrderDetail').on('click', '.shiftTable', function () {
                    $('#DialogOrderDetail').dialog('close');
                    DashboardFunction.config.ShiftID = $(this).attr('id').split("_")[1];
                    $(".imgroomtypeforshift").val("");
                    $(".imgRoomForShift").val("");
                    $(".TablesForShift").hide();
                    $('#divForRoomTableShift').dialog({
                        'title': 'Shift Table',
                        width: 650,
                        height: 'auto',
                    });
                });
                $('#DialogOrderDetail').on('click', '.ordernow', function () {

                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });
                $('#DialogOrderDetail').on('click', '.paynow', function () {
                    $('#DialogOrderDetail').dialog('close');
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBill(data[2]);

                });

            },
            // Order By Room
            SaveSplittedData: function () {
                DashboardFunction.config.method = "SaveSplittedData";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    ItemsArray: ItemsArray
                });
                DashboardFunction.config.ajaxCallMode = 6;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            BindRoomdataById: function (result) {
                var htmls = [];
                $('#DialogOrderDetail').html("");
                var roominfo = result.RoomInfo;
                var datas = result.RoomBookingDetails;
                htmls += "<div id='dialogOrderOpen' scrolling='auto'><h4>Details of " + roominfo.restrotableTitle.toUpperCase() + "</h4>";
                htmls += ("<div class='booking-dtl'>");
                htmls += ("<input id='Add_" + roominfo.restrotableId + "' type='button' class='sfBtn addNew restro-btn' value='Add'/></div>");
                var DialogWidth = '';

                if (datas.length > 0) {
                    DialogWidth = '700';
                    htmls += ("<table class='booking-list-tbl'><thead>");
                    htmls += ("<th>Customer Name</th><th>Booked From</th><th>Booked To</th><th colspan='2'>Action</th></thead>");
                    htmls += "<tbody>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += ("<td>" + value.CustomerName + "</td>");
                        htmls += ("<td>" + value.BookedFrom + "</td>");
                        htmls += ("<td>" + value.BookedTo + "</td>");
                        htmls += ("<td><input id='Order_" + value.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order' style='padding:5px 10px;'/>");
                        htmls += ("<input id='Pay_" + value.OrderMasterId + "' type='button'  class='sfBtn roompaynow restro-btn' value='Pay' style='padding:5px 10px;margin-left:10px;'/>");
                        htmls += ("<input id='Cancel_" + value.OrderMasterId + "_" + value.TableId + "_" + 1 + "' type='button'  class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:5px 10px;margin-left:10px;'/>");
                        htmls += ("</td>");
                        htmls += "</tr>";
                    });
                    htmls += ("</tbody></table>");

                } else {
                    DialogWidth = '300';

                }
                $('#DialogOrderDetail').html(htmls);

                $('#DialogOrderDetail').dialog({
                    'title': 'Booking Details',
                    "resize": "auto",
                    width: DialogWidth,
                });
                $('.booking-list-tbl').on('click', '.roompaynow', function () {
                    $('#DialogOrderDetail').dialog('close');
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBill(data[1]);
                });
                $('.booking-list-tbl').on('click', '.cancelorder', function () {
                    $('#DialogOrderDetail').dialog('close');
                    OrderMasterID = $(this).attr('id').split("_")[1];
                    CancelTableID = $(this).attr('id').split("_")[2];
                    var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                    var htmls = "";
                    $('#splitNoCancel').html('');
                    for (i = 1; i <= noOfSeat; i++) {
                        htmls += '<option value="' + i + '">' + i + '</option>';
                    }
                    $('#splitNoCancel').html(htmls);
                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();
                });
                $('.booking-list-tbl').on('click', '.ordernow', function () {

                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });

                $('.addNew').on('click', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    $('.dashboardmain').dialog(
                        {
                            'title': 'Room Book',
                            width: '900px',
                            height: 'auto',
                            position: ['center', 'center'],
                            dialogClass: 'roombookk',
                            modal: true
                        });
                    $('#hdfRoomBookDetailId').val(0);
                    $('#Membercheckbox').attr('checked', false);
                    $('#txtRoomName').val(roominfo.restrotableTitle.toUpperCase());
                    $('#hdfRoomId').val(roominfo.restroRoomId);
                    $('#hdfTableId').val(roominfo.restrotableId);
                    $('#txtBookFrom').val('');
                    $('#txtBookTo').val('');
                    $('#txtDays').val(0);
                    $('#txtAmount').val(0);
                    $('#BookAdvancePay').val(0);
                    $('#txtRate').val(roominfo.Rate);
                    $('#MemberID').val(0);
                    $('#MemberName').val('');
                    $('#MemberPhone').val('');
                    $('#MemberEmail').val('');
                    $('#MemberIdCardNo').val('');
                    $('.btnBook').attr('id', 'Book_' + data[1]);
                    $('.btnBook').bind('click');
                    $('.btnCancelBook').attr('id', 'No_' + data[1]);
                    htmls += "</div></div></div>";
                    $('#dashboardmain').html(htmls);
                    $('#Membercheckbox').on('change', function () {
                        if ($('#Membercheckbox').prop('checked') == true) {
                            membershipfor = "RoomBooking";
                            DashboardFunction.GetCustomeronChange();
                            $("#membeshipformlist").dialog({
                                'title': 'Customer',
                                width: 800,
                                modal: true,
                                resizable: true,
                            });
                        } else {
                            $('#MemberID').val(0);
                        }
                    })

                });
            },
            Bindmembership: function (data) {
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var datas = JSON.parse(data.d);
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='BookedTable-list display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th><th>Paid</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "'>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.Occupation + "</td>";
                        htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        if (membershipfor == "payment") {
                            htmls += "<td>" + "<img src='/images/paid.png' class='BrandDelete' style='width:30px' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "' value='Delete'  /></td>";
                        } else {
                            htmls += "<td>" + "<img src='/images/completed.png' class='BrandDelete' style='width:30px' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                        }
                        htmls += "</tr>"
                        checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                        {
                            jQueryUI: true,
                            ordering: false,

                        });
                    $("#membeshipformlist").dialog({
                        'title': 'Customer',
                        width: 800,
                        modal: true,
                        resizable: true,
                        position: ['center', 'top']
                    });


                } else {
                    $('#membeshipformlist').html('No data');

                }
                $("#membeshipformlist").on('click', '.tableItem', function (event) {
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    DashboardFunction.config.MembershipID = words[0];

                    $('#txtFirstName').val(words[1]);
                    $('#txtLastName').val(words[2]);
                    $('#txtAddress').val(words[3]);
                    $('#txtCity').val(words[4]);
                    $('#txtCountry').val(words[5]);
                    $('#txtPhoneHome').val(words[6]);
                    $('#txtPhoneWork').val(words[7]);
                    $('#txtPhoneMobile').val(words[8]);
                    $('#txtEmail').val(words[9]);
                    $('#txtOccupation').val(words[10]);
                    $('#txtCompany').val(words[11]);
                    $('#txtBirthday').val(words[12]);
                    $('#txtAnniversary').val(words[13]);
                    $('#txtCardNumber').val(words[14]);
                    $('#txtDateOfIssue').val(words[15]);
                    $('#txtDateOfExpiry').val(words[16]);
                    $('#txtDiscount').val(words[17]);
                    $('#txtPan').val(words[18]);
                    $('#Customer').val(words[19]);
                    $("input[type=radio][name=Customer]").prop('checked', false);

                    if (words[19] == "true") {
                        $('#rdoCustomer').prop('checked', true);
                        //$('#rdoVender').attr('checked', false);
                        $(".custo").show();
                        $(".vend").hide();
                    }
                    else {
                        $('#rdoVender').prop('checked', true);
                        // $('#rdoCustomer').attr('checked', false);
                        $(".custo").hide();
                        $(".vend").show();
                    }
                    $(".main").show();
                    $("input[type=radio][name=Customer]").attr("disabled", "disabled");
                    $("#btnAddItem").hide();
                    $("#divForMember").show();
                    $("#tabss").hide();
                    DashboardFunction.config.MembershipIDUpdate = 1;
                });


                $(".dataTables_scrollBody").css('height', '100%');

            },
            Bindmember: function (data) {
                $("#membeshipformlist2").dialog({
                    'title': 'Customer Balance',
                    width: 800,
                    modal: true,
                    resizable: true,
                });
                $("#membeshipformlist2").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='MemberTable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th style='width:200px'> Address </th><th> Phone </th><th> Card Number </th><th> Remaining Balance </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:200px'>" + value.Address + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td>" + value.CardNumber + "</td>";
                        htmls += "<td>" + value.RemainingBalance + "</td>";

                        //  htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        // htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        htmls += "<tr>"
                        //var sum = (parseFloat(value.RemainingBalance) + parseFloat(totamount)).toFixed(2);
                        var sum = parseFloat(totalamount).toFixed(2);

                        //htmls += "<td>" + value.RemainingBalance + "</td>";
                        htmls += "<table style='display:block;margin-top:10px;background:#e6e6e6;'>"
                        htmls += "<tr>"
                        htmls += "<td style='font-weight:bold;font-size:17px;text-align:center;'>Balance</td>"
                        htmls += "<td style='text-align:center;'><input type='textbox' disable value='" + sum + " ' placeholder='Total Amt' class='sfInputbox total' id='txtCalTotalAmount' style='width:120px;' readonly='readonly'/></td>";
                        htmls += "<td style='text-align:center;'><input type='textbox' placeholder='Paid Amt' class='sfInputbox total' id='txtCalPaidAmount' name='PaidAmount'  style='width:120px;'/></td>";
                        htmls += "<td style='text-align:center;'><input type='textbox' placeholder='" + sum + "' class='sfInputbox total' id='txtCalRemainingAmount' style='width:120px;' readonly='readonly' value='" + sum + "'/></td>";

                        htmls += "<td style='text-align:center;'>" + "<input class='sfBtn restro-btn updatemember' type='button'  id=_" + value.MembershipID + " value='Pay the Bill'  /></td>";
                        htmls += "</tr>"
                        htmls += "</table>"


                    });

                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#membeshipformlist2').html(htmls);
                    $('#MemberTable').DataTable(
                        {
                            "scrollY": false,
                            "scrollCollapse": false,
                            "jQueryUI": true,

                        });

                } else {
                    $('#membeshipformlist2').html('No data');

                }



                $(".dataTables_scrollBody").css('height', '100%');

            },
            CancelOrderedData: function () {

                var id = OrderMasterID;
                var cancel = false;
                var ordermaster = new Object();
                ordermaster.TableId = CancelTableID,
                    ordermaster.OrderMasterID = OrderMasterID,
                    ordermaster.GuestNo = parseInt($('#splitNoCancel').text() == '' ? '1' : $('#splitNoCancel').text());
                ordermaster.CancelReason = $("#canceltextarea").val();
                ordermaster.CancelBy = $('#hdnPinBy').val();
                ordermaster.UserName = $('#hdnPinBy').val();
                ordermaster.IsCancelled = true,
                    //ordermaster.UserName = SageFrameUserName;
                    //ordermaster.Date = OrderListArray[0].
                    DashboardFunction.config.method = "CancelOrderIntoDataBase";

                var jsonText = JSON2.stringify({ orderMasterInfo: ordermaster });
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = jsonText;
                DashboardFunction.config.ajaxCallMode = 16;
                DashboardFunction.ajaxCall(DashboardFunction.config);
                //eventFunction.config.ajaxCallMode = 3;
                DashboardFunction.config.ID = id;
                //eventFunction.ajaxCall(eventFunction.config);

            },
            BindRoomByRoomTypeIdForMerge: function (result) {
                var htmls = [];
                $('.RoomsForMerge').html("");

                var datas = JSON.parse(result.d);
                htmls += "<select class='imgRoomMerge sfInputbox' style='width:200px;'><option value='' disabled selected>-- select --</option>";
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += ("<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>");
                    });
                } else {
                    htmls += "No Data";
                }
                htmls += "</select>";
                $('.RoomsForMerge').html(htmls);

                $(".imgRoomMerge").on('change', function () {
                    var id = $(".imgRoomMerge").val();
                    RoomId = parseInt(id);
                    activeorder = id;
                    DashboardFunction.GetTableByRoomTypeIdForMerge(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;
                });
                $('.RoomsForMerge').show();
                $('.TablesForMerge').hide();

            },
            BindUnoccupiedRoomByRoomTypeId: function (result) {
                var htmls = [];
                $('.RoomsForShift').html("");

                var datas = result.d;
                htmls += "<select class='imgRoomForShift sfInputbox' style='width:200px;' ><option value='' disabled selected>-- select --</option>";
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += ("<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>");
                    });
                } else {
                    htmls += "No Data";
                }
                htmls += "</select>";

                $('.RoomsForShift').html(htmls);

                $(".imgRoomForShift").on('change', function () {
                    var id = $(".imgRoomForShift").val();
                    RoomId = parseInt(id);
                    activeorder = id;
                    DashboardFunction.GetUnoccupiedTableByRoomTypeId(parseInt(id));


                });
                $('.RoomsForShift').show();
                $('.TablesForShift').hide();

            },
            BindTableByRoomTypeIdForMerge: function (result) {
                var htmls = [];
                $('.TablesForMerge').html("");
                $('#DialogOrderDetail').html("");
                var datas = result.d;
                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";
                    $.each(datas, function (index, value) {
                        var billNotCleared = ((value.BillPaid == 1 && value.restrotablesStatusID == 7) ? true : false);
                        if (value.MergeTableList <= 0 && value.IsTable && !billNotCleared) {
                            htmls += "<li>"
                            htmls += ("<input type='checkbox' class='imgtablemerge' id='");

                            if (value.BillPaid == 0 && value.IsCancelled == 0) {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_yes' + "' /> ");
                            } else {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_no' + "' /> ");
                            }
                            htmls += ("<label for ='");

                            if (value.BillPaid == 0 && value.IsCancelled == 0) {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_yes' + "' class = '' >");
                                htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablered.png'></label> ");
                            } else {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_no' + "' class = '' >");
                                htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablegreen.png'></label> ");
                            }

                            htmls += ("<h5 class='");
                            htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' ? "NotPaid" : "Paid");
                            htmls += ("' >" + value.restrotableTitle + "</h5>");

                            if (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0') {
                                htmls += ("<h5 class='order-time'");

                                var dateprev = new Date(value.tableDate);
                                var datet = new Date();
                                var diff = (datet - dateprev) / 1000;
                                function secondsTimeSpanToHMS(s) {
                                    var h = Math.floor(s / 3600); //Get whole hours
                                    s -= h * 3600;
                                    var m = Math.floor(s / 60); //Get remaining minutes
                                    s -= m * 60;
                                    if (h == 0) {
                                        return (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           }
                                    } else {
                                        return h + "H:" + (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           }
                                    }

                                }
                                var dinal = secondsTimeSpanToHMS(diff)
                                htmls += ("' >" + value.tabletime + "</h5><h5 class='order-timeA'>" + dinal + "</h5>");
                            }
                            htmls += ("</li>");
                        }
                    });
                    htmls += "</ul>";

                    $('.TablesForMerge').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });
                }


                $(".imgtablemerge").on('change', function () {
                    var data = $(this).attr('id').split('_');
                    var occupiedtable = data[7];
                    var isOcc = (occupiedtable == "yes" ? true : false);
                    var imgid = 'IMG_' + data[1];

                    if (isOcc && !$(this).prop('checked')) {
                        $(this).prop('checked', false);
                        document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tablered.png';
                        containOccTab = false;
                        mergetableid = 0;
                    } else if (!isOcc && !$(this).prop('checked')) {
                        $(this).prop('checked', false);
                        document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tablegreen.png';
                    } else {
                        if (containOccTab && isOcc) {
                            jAlert('Two Occupied Tables cannot be merged.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $(this).prop('checked', false);
                            document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tablered.png';
                        }
                        else {
                            containOccTab = (occupiedtable == "yes" ? true : containOccTab);
                            mergetableid = (isOcc ? data[1] : mergetableid);

                            document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tableyellow.png';
                        }
                    }


                });



                $('.TablesForMerge').show();
                $('.btnMerge').show();



            },
            BindUnoccupiedTableByRoomTypeId: function (result) {

                var htmls = [];
                $('.TablesForShift').html("");
                $('#DialogOrderDetail').html("");
                var datas = result.d;
                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";

                    $.each(datas, function (index, value) {
                        if (!value.MergetableList > 0 && value.restrotablesStatusID == 6 && value.IsTable && (value.IsOccupied == 0 || value.BillPaid.toString() != '1' || value.IsCancelled != 0) {
                            htmls += ("<li>");
                            htmls += ("<a id ='");
                            htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + "' class = 'imgtableshift' ><img src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablegreen.png'></a> ");
                            if (value.MergeTableList > 0) {
                                htmls += ("<h5 class='NotPaid'");
                                htmls += ("' >" + value.restrotableTitle + "/" + value.MergeTableName + "</h5>");

                            }
                            else {
                                htmls += ("<h5 class='");
                                htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' ? "NotPaid" : "Paid");
                                htmls += ("' >" + value.restrotableTitle + "</h5>");
                            }


                            if (value.IsOccupied == 1 && value.tableDate !== "") {
                                htmls += ("<h5 class='order-time'");

                                var dateprev = new Date(value.tableDate);
                                var datet = new Date();
                                var diff = (datet - dateprev) / 1000;
                                function secondsTimeSpanToHMS(s) {
                                    var h = Math.floor(s / 3600); //Get whole hours
                                    s -= h * 3600;
                                    var m = Math.floor(s / 60); //Get remaining minutes
                                    s -= m * 60;
                                    if (h == 0) {
                                        return (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                          
                                    } else {
                                        return h + "H:" + (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                          
                                    }
                                }
                                var dinal = secondsTimeSpanToHMS(diff)
                                htmls += ("' >" + value.tabletime + "</h5><h5 class='order-timeA'>" + dinal + "</h5>");

                            }

                            htmls += ("</li>");
                        }


                    });
                    htmls += "</ul>";

                    $('.TablesForShift').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });

                }


                $(".imgtableshift").on('click', function () {
                    tabletoshift = $(this).attr('id').split('_')[1];
                    jConfirm('Are You Sure  ?', 'Shift', function (confirmed) {
                        if (confirmed) {
                            $('#hdnPinFor').val('Shift');
                            InitializePin();
                        }
                    });
                });



                $('.TablesForShift').show();


            },

            BindSalesBill: function (result, seatNo) {
                var datas = result.d;
                const orderdetails = datas.orderDetail;
                var billingterms = datas.billingTerm;
                var costcenters = datas.cuscenter;
                var tableinfo = datas.RoomBooking;
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
                var DialogWidth = '900';
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
                    htmls += ("<table class='item-list-tbl'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody id='salesDetailsTbl'>");

                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        if (value.SeatNo == seatNo) {
                            htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                            htmls += ("<td>" + value.Quantity + "</td>");
                            htmls += ("<td class='item-rate'>" + value.Rate + "</td>");
                            amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                            totalAmount += parseFloat(amt);
                            //console.log('totalAmount: ' + totalAmount);
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
                                //htmls += ("</td><td>" + qnty + "</td>");
                                //htmls += ("<td class='item-rate'>" + (rate/qnty) + "</td>");
                                amt = parseFloat(rate);
                                totalAmount += parseFloat(amt);
                                //console.log('totalAmount: ' + totalAmount);
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
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='roomtotle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
                }

                htmls += ("<h4>Discount Method</h4><div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'><div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");

                totaldis = 0;

                htmls += ("<tr>");
                htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option><option value='4'>Promotion</option></select></td></tr>");
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>KOT ( Rs. " + kotAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px; onkeypress='return IntegerAndDecimal(event,this);' id='txtKotDiscount' value='" + costcenters[0].coDiscount + "' /></td>";
                totaldis += (parseFloat(kotAmount) * (parseFloat(costcenters[0].coDiscount) / 100));

                htmls += "</tr>";
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>Bar ( Rs. " + barAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtBarDiscount' value='" + costcenters[1].coDiscount + "' /></td>";
                htmls += "</tr>";
                totaldis += (parseFloat(barAmount) * (parseFloat(costcenters[1].coDiscount) / 100));

                htmls += "</tr>";
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>Bakery ( Rs. " + bakeryAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px; onkeypress='IntegerAndDecimal(event,this,true)' id='txtBakeryDiscount' value='" + costcenters[2].coDiscount + "' /></td>";
                htmls += "</tr>";
                totaldis += (parseFloat(bakeryAmount) * (parseFloat(costcenters[2].coDiscount) / 100));

                htmls += "</tr>";
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>Pizza ( Rs. " + pizzaAmount.toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px; onkeypress='IntegerAndDecimal(event,this,true)' id='txtPizzaDiscount' value='" + costcenters[4].coDiscount + "' /></td>";
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
                htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(tableinfo.CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>';
                htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + tableinfo.CustomerName + '"/><input type="hidden" id="txtCusID" value="' + tableinfo.CustomerId + '" /></td></tr><tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr><tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                htmls += '</tbody></table></div><input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/></div></div>';

                htmls += ("</div></div></div></div>");
                htmls += ("<input id='Pay_" + tableinfo.TableId + "_" + tableinfo.OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
                var orderMasterId = tableinfo.OrderMasterId;
                $('#DialogOrderDetail').html(htmls);
                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                $('#billnoForSales').val(seatNo);
                $('#DialogOrderDetail').dialog(
                    {
                        'title': 'Sales Bill',
                        width: DialogWidth,
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top']
                    });
                $('#billnoForSales').on('change', function () {
                    DashboardFunction.BindSalesBill(result, parseInt($('#billnoForSales').val()));
                    seatNo = $('#billnoForSales').val();
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
                            //console.log('totalAmount: ' + totalAmount);
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
                $("#txtLoyaltyDiscount").on('change', function () {
                    $('#txtKotDiscount').val(0);
                    $('#txtBarDiscount').val(0);
                    $('#txtRoomDiscount').val(0);
                    $('#txtBakeryDiscount').val(0);
                    $('#txtPizzaDiscount').val(0);
                    totaldis += ((totalAmount - roomAmount) * (parseFloat($("#txtLoyaltyDiscount").val()) / 100));
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
                            DashboardFunction.config.ajaxCallMode = 57;
                            DashboardFunction.ajaxCall(DashboardFunction.config);
                        }
                    });
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
                    //if (item.Name != "Service Charge") 
                    {
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
                    }
                });
                netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc)).toFixed(2));
                if (datas.VATforBill) {
                    if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {
                        htmls += ("<tr>");
                        htmls += ("<td attr-term='Taxable Amount' attr-percent='0' ><strong>Taxable Amount : </strong><input type=\"text\" id=\"txtTaxableAmt\" value=\"Rs. " + netAmount.toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + netAmount.toFixed(2) + "'/></td>");
                        htmls += ("</tr>");
                        htmls += ("<tr>");
                        htmls += ("<td attr-term='VAT' attr-percent='13' ><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + datas.billingTerm[datas.billingTerm.length - 1].ID + "_true" + "\"  value=\"Rs. " + ((netAmount) * 13 / 100).toFixed(2) + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + ((netAmount) * 13 / 100).toFixed(2) + "'/></td>");
                        netAmount = parseFloat(parseFloat(netAmount * 1.13).toFixed(2));
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
            BindOccupiedTable: function (data) {
                var htmls = "";
                $('#OccupiedTablesdiv').html('');
                $("#OccTablesLength").text(data.length);
                htmls += ("<div class ='Tables'><table id='OccupiedTables' class='BookedTable-list-tbl'>");
                htmls += ("<thead><th>Room / Table</th><th>Check In</th><th>Action</th></thead><tbody>");
                $.each(data, function (index, type) {
                    if (type.IsTable) {
                        htmls += ("<tr><td>");
                        htmls += type.restroRoom + " / ";
                        if (type.MergeTableList > 0) {
                            htmls += (type.MergeTableName);
                        }
                        else {
                            htmls += (type.restrotableTitle);
                        }

                        htmls += ("</td><td>" + type.tableDate + "</td><td style='width:315px;'><div class='ordering'>");
                        htmls += ("<input id='Order_" + type.restrotableId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px;' />");
                        htmls += ("<input id='Pay_" + type.restrotableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                        htmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.restrotableId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                        if (type.MergeTableList > 0) {
                            htmls += ("<input id='Merge_" + type.restrotableId + "' type='button' class='sfBtn removeMerge restro-btn' value='UnMerge' style='padding:1px 4px; margin-left:10px;' />");
                        }
                        else {
                            htmls += ("<input id='Shift_" + type.OrderMasterId + "' type='button' class='sfBtn shiftTable restro-btn' value='Shift' style='padding:1px 4px; margin-left:10px;' />");
                        }
                        htmls += ("<input id='shiftItems_" + type.OrderMasterId + "_" + type.restrotableId + "_" + type.GuestNo + "' type='button' class='sfBtn shiftItems restro-btn' value='Shift Items' style='padding:1px 4px; margin-left:10px;' />");

                        htmls += ("</div></td></tr>");
                    }
                });
                htmls += ("</tbody></table></div>");
                $('#OccupiedTablesdiv').html(htmls);

                $('#OccupiedTables').dataTable({
                    "bPaginate": $('#OccupiedTables tbody tr').length > 16,
                    "iDisplayLength": 16,
                    "ordering": false,
                    "bLengthChange": false,
                    "language": { search: "", searchPlaceholder: "Search..." },

                });
                $('div.dataTables_filter input').addClass('sfInputbox');
                $('#OccupiedTables').on('click', '.shiftTable', function () {
                    DashboardFunction.config.ShiftID = $(this).attr('id').split("_")[1];
                    $(".imgroomtypeforshift").val("");
                    $(".imgRoomForShift").val("");
                    $(".TablesForShift").hide();
                    pinfor = "shift";
                    $('#divForRoomTableShift').dialog({
                        'title': 'Shift Table',
                        width: 650,
                        height: 'auto',
                        modal: true,
                    });
                });
                $('#OccupiedTables').on('click', '.removeMerge', function () {
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

                $('#OccupiedTables').on('click', '.cancelorder', function () {
                    OrderMasterID = $(this).attr('id').split("_")[1];
                    CancelTableID = $(this).attr('id').split("_")[2];
                    var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                    var htmls = "";
                    $('#splitNoCancel').html('');
                    for (i = 1; i <= noOfSeat; i++) {
                        htmls += '<option value="' + i + '">' + i + '</option>';
                    }
                    $('#splitNoCancel').html(htmls);

                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();
                });
                $('#OccupiedTables').on('click', '.ordernow', function () {

                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });
                $('#OccupiedTables').on('click', '.paynow', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBill(data[2]);
                });

            },
            BindOccupiedRoom: function (data) {
                $('#OccupiedRoomsdiv').html('');
                if (data.length > 0) {
                    var roomHtmls = "";
                    $("#OccTab").show();
                    $("#OccRoomsLength").text(data.length);
                    roomHtmls += ("<div class ='Rooms'><table id='OccupiedRooms' class='BookedTable-list-tbl'>");
                    roomHtmls += ("<thead><th>Room</th><th>Customer</th><th>Booked On</th><th>Booked To</th><th>Action</th></thead><tbody>");
                    $.each(data, function (index, type) {
                        if (!type.IsTable) {
                            roomHtmls += ("<tr><td>" + type.RestroRoom + " / " + type.restrotableTitle);
                            roomHtmls += ("</td><td>" + type.CustomerName + "</td>");
                            roomHtmls += ("</td><td>" + type.BookedFrom + "</td>");
                            roomHtmls += ("<td>" + type.BookedTo + "</td><td style='width:315px;'><div class='ordering'>");
                            roomHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("<input id='Pay_" + type.TableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                            roomHtmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.TableId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("<input id='Booking_" + type.OrderMasterId + "' type='button' class='sfBtn editBooking restro-btn' value='Edit' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("</div></td></tr>");
                        }
                    });
                    roomHtmls += ("</tbody></table></div>");

                    $('#OccupiedRoomsdiv').html(roomHtmls);

                    $('#OccupiedRooms').dataTable({
                        "bPaginate": $('OccupiedRooms tbody tr').length > 12,
                        "iDisplayLength": 12,
                        ordering: false,
                        "bLengthChange": false,
                        "language": { search: "", searchPlaceholder: "Search..." },
                    });
                    $('div.dataTables_filter input').addClass('sfInputbox');
                    $('#OccupiedRooms').on('click', '.cancelorder', function () {
                        OrderMasterID = $(this).attr('id').split("_")[1];
                        CancelTableID = $(this).attr('id').split("_")[2];
                        var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                        var htmls = "";
                        $('#splitNoCancel').html('');
                        for (i = 1; i <= noOfSeat; i++) {
                            htmls += '<option value="' + i + '">' + i + '</option>';
                        }
                        $('#splitNoCancel').html(htmls);

                        $('#hdnPinFor').val('CancelOrder');
                        InitializePin();
                    });
                    $('#OccupiedRooms').on('click', '.ordernow', function () {

                        var id = $(this).attr('id');
                        var data = id.split('_');
                        var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(data[1]);
                        window.location.href = url;
                    });
                    $('#OccupiedRooms').on('click', '.paynow', function () {
                        var id = $(this).attr('id');
                        var data = id.split('_');
                        DashboardFunction.GetDataForSalesBill(data[2]);
                    });
                    $('#OccupiedRooms').on('click', '.editBooking', function () {
                        var id = $(this).attr('id');
                        var data = id.split('_');
                        DashboardFunction.GetBookDataForEditing(data[1]);
                    });
                }
            },
            BindBookedRoom: function (data) {
                $('#BookedRoomsdiv').html('');
                if (data.length > 0) {
                    var roomHtmls = "";
                    $("#bookRoomTab").show();
                    $("#BookRoomsLength").text(data.length);
                    roomHtmls += ("<div class='homebookroom'><table id='BookedRooms' class='BookedTable-list-tbl'>");
                    roomHtmls += ("<thead><th>Room</th><th>Customer</th><th>Booked On</th><th>Booked To</th><th>Action</th></thead><tbody>");
                    $.each(data, function (index, type) {
                        if (!type.IsTable) {
                            roomHtmls += ("<tr><td>" + type.RestroRoom + " / " + type.restrotableTitle);
                            roomHtmls += ("</td><td>" + type.CustomerName + "</td>");
                            roomHtmls += ("</td><td>" + type.BookedFrom + "</td>");
                            roomHtmls += ("<td>" + type.BookedTo + "</td><td style='width:315px;'><div class='ordering'>");
                            roomHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("<input id='Pay_" + type.TableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                            roomHtmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.TableId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("<input id='Booking_" + type.OrderMasterId + "' type='button' class='sfBtn editBooking restro-btn' value='Edit' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("</div></td></tr>");
                        }
                    });
                    roomHtmls += ("</tbody></table></div>");

                    $('#BookedRoomsdiv').html(roomHtmls);

                    $('#BookedRooms').dataTable({
                        "bPaginate": $('OccupiedRooms tbody tr').length > 10,
                        "iDisplayLength": 12,
                        ordering: false,
                        "bLengthChange": false,
                        "language": { search: "", searchPlaceholder: "Search..." },
                    });
                    $('#BookedRooms').on('click', '.cancelorder', function () {
                        OrderMasterID = $(this).attr('id').split("_")[1];
                        CancelTableID = $(this).attr('id').split("_")[2];
                        var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                        var htmls = "";
                        $('#splitNoCancel').html('');
                        for (i = 1; i <= noOfSeat; i++) {
                            htmls += '<option value="' + i + '">' + i + '</option>';
                        }
                        $('#splitNoCancel').html(htmls);

                        $('#hdnPinFor').val('CancelOrder');
                        InitializePin();
                    });
                    $('#BookedRooms').on('click', '.ordernow', function () {

                        var id = $(this).attr('id');
                        var data = id.split('_');
                        var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(data[1]);
                        window.location.href = url;
                    });
                    $('#BookedRooms').on('click', '.paynow', function () {
                        var id = $(this).attr('id');
                        var data = id.split('_');
                        DashboardFunction.GetDataForSalesBill(data[2]);
                    });
                    $('#BookedRooms').on('click', '.editBooking', function () {
                        var id = $(this).attr('id');
                        var data = id.split('_');
                        DashboardFunction.GetBookDataForEditing(data[1]);
                    });
                }
            },
            BindForEditingBooking: function (result) {
                var roomBooking = JSON.parse(result);

                $('.roomBookDash').dialog(
                    {
                        'title': 'Room Book',
                        width: '900px',
                        height: 'auto',
                        position: ['center', 'center'],
                        dialogClass: 'roombookk',
                        modal: true
                    });
                $('#hdfRoomBookDetailId').val(roomBooking.RoomBookDetailsID);
                $('#txtRoomName').val(roomBooking.restrotableTitle.toUpperCase());
                $('#hdfRoomId').val(roomBooking.restroRoomId);
                $('#hdfTableId').val(roomBooking.TableId);
                $('#txtBookFrom').val(roomBooking.BookedFrom);
                $('#txtBookTo').val(roomBooking.BookedTo);
                $('#txtDays').val(roomBooking.BookedDays);
                $('#txtAmount').val(roomBooking.TotalAmount);
                $('#BookAdvancePay').val(roomBooking.AdvancePayment);
                $('#txtRate').val(roomBooking.Rate);

                $('#Membercheckbox').attr('checked', (roomBooking.CustomerId > 0 ? true : false));
                $('#MemberID').val(roomBooking.CustomerId);
                $('#MemberName').val(roomBooking.CustomerName);
                $('#MemberPhone').val(roomBooking.PhoneNo);
                $('#MemberEmail').val(roomBooking.EmailAddress);
                $('#MemberIdCardNo').val(roomBooking.CtznNo);
                $('.btnBook').attr('id', 'Book_' + roomBooking.RoomBookDetailsID);
                $('.btnCancelBook').attr('id', 'No_' + roomBooking.RoomBookDetailsID);
                $('#Membercheckbox').on('change', function () {
                    if ($('#Membercheckbox').prop('checked') == true) {
                        membershipfor = "RoomBooking";
                        DashboardFunction.GetCustomeronChange();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            resizable: true,
                        });
                    } else {
                        $('#MemberID').val(0);
                    }
                })
            },
            Reset: function () {
                $(".ui-dialog-content").dialog("close");
                $('#TablesInRooms').hide();
                //$('#UnpaidBills').dialog('close');
                //$('#MembershipPopTable').dialog('close');
                //$('#callwaiterDiv').dialog('close');
                //$('#sample').dialog('close');
                //$('#membeshipformlist').dialog('close');
                //$('#membeshipformlist2').dialog('close');
                //$('#PINcode').dialog('close');
                //$('#DisplayCancel').dialog('close');
                //$('#divForRoomTableMerge').dialog('close');
                //$('#divForRoomTableShift').dialog('close');
                //$('#DisplayCancel').dialog('close');
                //$('#CusOrder').dialog('close');
            },
        };
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);