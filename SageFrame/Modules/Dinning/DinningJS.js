
var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

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
    var tabs = $("#tabs").tabs();
    $('#tabs').css('display', 'block');
    $.companyDashboardcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/RestroDashboard/',
                HostUrl: '',
                TypeId: '',
                numpin: ''
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
        var userRole = "";
        var CheckRole = false;
        var IsEnableDiscount = false;
        var Paymode = [];
        var RemainingAmount = 0;
        var fromtableId = 0;
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
                MenuId: 0,
                Menuupdate: 0,
                RoomId: 0,
                OrderId: 0,
                OrderUpdateId: 0,
                ShiftOrderMasterID: 0


            },
            InitialSetup: function () {
                $('.padv').hide();
                var id = $('ul#restroSpace li:first').attr('id');
                $("ul#restroSpace li:first").closest('li').addClass('active');
                DashboardFunction.GetRoomByRoomTypeId(parseInt(id));

            },
            init: function () {
                DashboardFunction.InitialSetup();
                DashboardFunction.GetUserName();
                DashboardFunction.GetPaymentModesAndProvidersForAdvancePayment();
                DashboardFunction.BindProviders();

                $('#BookAdvancePay').on('focus', function () {
                    DashboardFunction.BindPaymentModesAndProviders();
                });

                $('#BookAdvancePay').on('keyup, keydown', function () {
                    RemainingAmount = 0;
                    RemainingAmount = $("#Rembalance").val() - $("#BookAdvancePay").val();
                });
                $('#BookAdvancePay').on('change', function () {
                    RemainingAmount = 0;
                    RemainingAmount = $("#Rembalance").val() - $("#BookAdvancePay").val();
                });

                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'Book') {
                            DashboardFunction.SaveRoomBook();
                        } else if (pinFor == 'enablebtn') {
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
                            DashboardFunction.ShiftTable();
                        } else if (pinFor == 'generateBill') {
                            $('.paynows').click();
                        } else if (pinFor == 'CancelOrder') {
                            $('#cancelby').text($('#hdnPinBy').val());
                            $('#splitNoCancel').val($('#billno').val());
                            $('#canceltextarea').val('');
                            $('#DisplayCancel').dialog({
                                title: 'Cancel Order'
                            });
                        }
                    }
                });
                PinCodeSetup();
                NumCodeSetup();

                $(".imgroomtype").on('click', function () {
                    $('#CusOrder').hide();
                    $('.hometab').hide();

                    $('#DialogOrderDetail').dialog(
                        {
                            'title': 'Order',
                            "resize": "auto",
                            width: 300,
                            position: ['center', 'center']

                        });
                    $('#DialogOrderDetail').dialog("close");
                    var data = $(this).attr('id');
                    var id = data.split('_')[0];
                    DashboardFunction.GetRoomByRoomTypeId(parseInt(id));
                });

                $('#btnSumbit').on('click', function () {
                    var myStr = $("#canceltextarea").val();
                    var newStr = myStr.replace(/  +/g, ' ');
                    if (newStr.length <= 3) {
                        jAlert('Please Insert Valid Reason.', "Alert!!", function () { $.alerts.dialogClass = null; });
                    } else {
                        $("#canceltextarea").val(newStr);
                        DashboardFunction.Checkbill(OrderMasterID, parseInt($('#splitNoCancel').val() == null ? 0 : $('#splitNoCancel').val()), fromtableId);
                        //DashboardFunction.CancelOrderedData();   
                    }

                });

                $("#membeshipformlist").on('click', '#Brandtable tr', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    if (membershipfor == "PaymentLoyalty") {
                        $("#txtCusID").val(ids[1]);
                        $("#txtCashCusName").val(ids[2] + " " + ids[3]);
                        $("#txtCusAddress").val(ids[5]);
                        $("#txtPan").val(ids[4]);
                        $("#txtLoyaltyDiscount").val(ids[6]);
                        $("#txtNumber").val(ids[7]);
                        $("#txtCardNumber").val(ids[9]);
                        $("#membeshipformlist").dialog('close');
                        //$("#selDiscountType").change();
                    } else if (membershipfor == "RoomBooking") {
                        $("#MemberID").val(ids[1]);
                        $("#MemberName").val(ids[2] + " " + ids[3]);
                        $("#MemberEmail").val("");
                        $("#MemberPhone").val(ids[7]);
                        $("#Rembalance").val(ids[8]);
                        $("#MemberIdCardNo").val('');
                        $("#membeshipformlist").dialog('close');
                        var amt = parseFloat((ids[8]) == "" ? 0 : ids[8]) - $("#BookAdvancePay").val();
                        RemainingAmount = amt;
                    }
                });

                $('#membeshipformlist').on('dialogclose', function () {
                    $("#selPayMode").val(1).change();
                });

                $(".imgroomtypeforshift").on('click', function () {
                    var id = $(".imgroomtypeforshift").val();
                    DashboardFunction.GetUnoccupiedRoomByRoomTypeId(parseInt(id));
                });

                $('#txtBookFrom').datetimepicker({
                    //minDate: 'dateToday',

                    hour: 12,
                    minute: 00,
                    minDate: new Date(),
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
                    minDate: new Date(),
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
                    if ($('#txtBookFrom').val() != "" && $('#txtBookTo').val() != "" && $('#MemberName').val() != "" && $('#MemberPhone').val() != "" && $('#txtRemarks').val() != "") {
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
                $('#confirmShift').on('click', function () {
                    jConfirm('Are You Sure  ?', 'Shift', function (confirmed) {
                        if (confirmed) {
                            $('#hdnPinFor').val('Shift');
                            //InitializePin();
                            DashboardFunction.Checkbill(DashboardFunction.config.ShiftOrderMasterID, $("#shiftingTableSeatNo").val(), fromtableId);
                        }
                    });
                });
                $('#txtRate').on('change', function () {
                    $('#txtAmount').val((parseFloat($('#txtDays').val()) * parseFloat($('#txtRate').val())).toFixed(2));
                });
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
                        //console.log(data);
                        //var orderId = JSON.parse(data.d);
                        //var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(orderId);
                        //window.location.href = url;
                        break;
                    case 5:
                        //DashboardFunction.BindLoyaltyDetails(data);
                        break;
                    case 6:
                        //DashboardFunction.GettabledataById(activeorder);
                        break;
                    case 7:
                        //DashboardFunction.bindShiftTableData(data.d);
                        break;
                    case 8:
                        jAlert('Table Successfully Shifted', "Information!!", function () {
                            DashboardFunction.Reset();
                            DashboardFunction.InitialSetup();
                            parent.$.colorbox.close();;
                        });

                        break;
                    case 9:
                        //DashboardFunction.bindUnpaidBillsData(data.d);
                        break;
                    case 10:
                        DashboardFunction.Bindmembership(data);
                        break;
                    case 11:
                        //DashboardFunction.Bindmember(data);
                        break;
                    case 12:
                    //DashboardFunction.UpdateSalesPayMode();
                    case 13:
                        //jAlert('Bill Successfully Paid', "Information!!", function () { $.alerts.dialogClass = null; });
                        //DashboardFunction.Reset();
                        //DashboardFunction.InitialSetup();
                        //return false;
                        break;
                    case 14:
                        DashboardFunction.BindProviderList(data.d)
                        break;
                    case 15:
                        var result = JSON.parse(data.d);
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
                        break;
                    case 49:
                        DashboardFunction.BindUnoccupiedRoomByRoomTypeId(data);
                        break;
                    case 50:
                        DashboardFunction.BindUnoccupiedTableByRoomTypeId(data);
                        break;
                    case 51:
                        //DashboardFunction.BindRoomByRoomTypeIdForMerge(data);
                        break;
                    case 52:
                        //DashboardFunction.BindTableByRoomTypeIdForMerge(data);
                        break;
                    case 53:
                        //var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(mergetableid);
                        //window.location.href = url;
                        break;
                    case 54:
                        //DashboardFunction.BindMergedTables(JSON.parse(data));
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
                        $('#InvoiceType').html('INVOICE');
                        $('#btnPrints').click();

                        DashboardFunction.GetUserName();
                        var paymentAfterGenerateBill = JSON.parse(localStorage.getItem("paymentAfterGenerateBill"));
                        if (paymentAfterGenerateBill) {
                            payment(data.d);
                        }
                        break;
                    case 58:
                        //DashboardFunction.bindBillBody(data.d);
                        break;
                    case 59:
                        DashboardFunction.print();
                        $('#BillingView').dialog('close');
                        //DashboardFunction.GetOccupiedTables(true);
                        //DashboardFunction.GetOccupiedRooms();
                        //DashboardFunction.GetBookedRooms();
                        break;
                    case 60:
                        DashboardFunction.BindOccupiedTable(data.d);
                        break;
                    case 61:
                        if (JSON.parse(data.d) >= 1) {
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
                            DashboardFunction.Reset();
                            DashboardFunction.InitialSetup();
                            //DashboardFunction.GetOccupiedRooms();
                            //DashboardFunction.GetBookedRooms();
                        });
                        break;
                    case 63:
                        //DashboardFunction.BindOccupiedRoom(JSON.parse(data.d));
                        break;
                    case 64:
                        //DashboardFunction.BindBookedRoom(JSON.parse(data.d));
                        break;
                    case 65:
                        //DashboardFunction.BindWaiterCallLog(data);
                        break;
                    case 67:
                        //DashboardFunction.BindForEditingBooking(data.d);
                        break;
                    case 68:
                        var role = data.d;
                        userRole = role.Roles;
                        break;
                    case 69:
                        DashboardFunction.BindSalesBillForPay(data, 1);

                        break;
                    case 70:
                        var result = data.d;
                        var roles = result.Roles.split(',');
                        localStorage.setItem("roles", roles);
                        if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                            IsEnableDiscount = true;
                        }

                        else {
                            IsEnableDiscount = false;
                        }
                        userRole = data.d.Roles;
                        break;
                    case 71:
                        DashboardFunction.BindmemberInfo(data.d);
                        break;
                    case 72:
                        Paymode = data.d;
                        // DashboardFunction.BindPaymentModesAndProviders();
                        break;
                    case 73:
                        DashboardFunction.BindCustomerDetails(data.d);
                        break;

                    case 74:
                        DashboardFunction.BindBillStatus(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            Checkbill: function (OrderMasterId, SeatNo, tableId) {
                DashboardFunction.config.method = "checkOrder";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    orderMasterId: OrderMasterId, seatNo: SeatNo, tableId: tableId
                });
                DashboardFunction.config.ajaxCallMode = 74;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },


            BindBillStatus: function (data) {
                var result = JSON.parse(data);
                if (result[0].ErrorNumber == 200) {
                    if ($('#hdnPinFor').val() == 'CancelOrder') {
                        DashboardFunction.CancelOrderedData();
                    } else if ($('#hdnPinFor').val() == 'Shift') {
                        InitializePin();
                    } else {
                        $('#hdnPinFor').val('generateBill');
                        InitializePin();
                    }
                }
                else {
                    jAlert(result[0].ErrorMessage, "Information!!", function () {
                    });
                }
            },

            BindCustomerDetails: function (data) {
                var result = JSON.parse(data);
                $('.customerForCash').prop('checked', true);
                $("#txtCusID").val(result[0].MembershipID);
                $("#txtCashCusName").val(result[0].Fname + " " + result[0].Lname);
                $("#txtNumber").val(result[0].TelMobile);
                $("#txtLoyaltyDiscount").val(result[0].discount);
                $("#txtLoyaltyDiscount").change();
                $(".disc").hide();
                $(".roomdisc").hide();
                $(".loyaltydisc").show();
            },

            GetPaymentModesAndProvidersForAdvancePayment: function () {
                var loggername = SageFrameUserName;
                DashboardFunction.config.method = "GetPaymentModesAndProvidersForAdvancePayment";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.config.data;
                DashboardFunction.config.ajaxCallMode = 72;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            getmembershiplistbyId: function (memberid) {
                DashboardFunction.config.method = "getmembershiplistbyId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    memberid: memberid
                });
                DashboardFunction.config.ajaxCallMode = 73;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            BindProviders: function () {
                var result = JSON.parse(Paymode);
                var cardProviders = result.providers;
                var paymentModes = result.paymentModes;

                var htmls = '';
                $.each(cardProviders, function (index, provider) {
                    htmls += '<option value="' + provider.ProviderID + '">' + provider.ProviderName + '</option>';
                });
                $('.ProviderName').html(htmls);
            },
            GetmemberInfo: function (info) {
                DashboardFunction.config.method = "getMemberDetailsbyinfo";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    info: info
                });
                DashboardFunction.config.ajaxCallMode = 71;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            CheckRolesFromPin: function (PinCode) {
                DashboardFunction.config.method = "CheckPin";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    pin: PinCode
                });
                DashboardFunction.config.ajaxCallMode = 70;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetUserName: function () {
                var loggername = SageFrameUserName;
                DashboardFunction.config.method = "GetRolesByUsername";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ username: loggername });
                DashboardFunction.config.ajaxCallMode = 68;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
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
                ordermaster.IsCancelled = false;

                var roomBook = new Object();
                roomBook.RoomBookDetailsID = $('#hdfRoomBookDetailId').val();
                roomBook.TableId = $('#hdfTableId').val();
                roomBook.BookedFrom = $('#txtBookFrom').val();
                roomBook.BookedTo = $('#txtBookTo').val();
                roomBook.BookedDays = $('#txtDays').val();
                roomBook.Rate = $('#txtRate').val();
                roomBook.TotalAmount = $('#txtAmount').val();
                roomBook.AdvancePayment = $('#BookAdvancePay').val() == "" ? 0 : $('#BookAdvancePay').val();
                roomBook.CustomerId = $('#MemberID').val();
                roomBook.CustomerName = $('#MemberName').val();
                roomBook.PhoneNo = $('#MemberPhone').val();
                roomBook.EmailAddress = $('#MemberEmail').val();
                roomBook.CtznNo = $('#MemberIdCardNo').val();
                var paymodeid = $('.PaymentModeID').text() == "" ? 1 : $('.PaymentModeID').text();
                var pid = $('.ProviderName').val() == null ? 0 : $('.ProviderName').val();
                roomBook.PaymentModeID = paymodeid;
                roomBook.ProviderID = ((paymodeid != 1) ? pid : 0);
                roomBook.TransactionNo = $('#txtTransNo').val() == "" ? 0 : $('#txtTransNo').val();
                roomBook.RemainingAmount = RemainingAmount;
                roomBook.Remarks = $('#txtRemarks').val();

                DashboardFunction.config.method = "SaveRoomBoking";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ roomBooking: roomBook, orderMaster: ordermaster });
                DashboardFunction.config.ajaxCallMode = 62;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            CheckAvailability: function (startDate, endDate, roombookDetailId, tableId) {

                DashboardFunction.config.method = "CheckAvailability";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, roombookDetailId: roombookDetailId, tableId: tableId });
                DashboardFunction.config.ajaxCallMode = 61;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetDataForSalesBill: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 56;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetDataForSalesBillFromPay: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 69;
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

            ShiftTable: function () {
                debugger;
                var totableID = tabletoshift;
                var fromordermasterid = DashboardFunction.config.ShiftOrderMasterID;
                var fromSeatNo = $('#shiftingTableSeatNo').val();
                var toSeatNo = $('#shiftToTableSeatNo').val();
                var shiftedby = $('#hdnPinBy').val();

                var fromTableTitle = $('#shiftingTableName').text();
                var toTableTitle = $('#shiftToTableName').text();

                DashboardFunction.config.method = "shiftTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    fromordermasterid: fromordermasterid,
                    totableID: totableID,
                    fromSeatNo: fromSeatNo,
                    toSeatNo: toSeatNo,
                    shiftedby: shiftedby,
                    fromTableTitle: fromTableTitle,
                    toTableTitle: toTableTitle,
                    OrderNo: fromOrderNo
                });
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

            BindTableByRoomTypeId: function (result) {
                var htmls = [];
                $('.TablesInRooms').html("");
                $('#DialogOrderDetail').html("");
                var datas = JSON.parse(result.d);

                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";

                    $.each(datas, function (index, value) {
                      
                        if (value.MergeTableList == 0 && value.MergeTableName == "" || value.MergeTableList > 0 && value.MergeTableName != "") {
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
                                        return h + ":" + (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                          
                                    }
                                }
                                var dinal = secondsTimeSpanToHMS(diff)
                                htmls += ("' >" + value.tabletime + "</h5><h5 class='order-timeA'>" + dinal + "</h5>");
                            }

                            htmls += ("</li></a>");
                        } 
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

            BindRoomByRoomTypeId: function (result) {
                var htmls = [];
                $('.Rooms').html("");
                var datas = JSON.parse(result.d);
                if (datas.length > 0) {
                    //htmls += "<h4>Rooms in " + datas[0].Title + "</h4><hr><ul>";
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
                            amt = parseFloat(value.Amount);
                            totalAmount += parseFloat(amt);
                            htmls += ("<td>" + amt.toFixed(2) + "</td></tr>");
                        }
                    });
                    htmls += ("<tr class='Total_Amt'><td colspan='1'  style='text-align:right;font-weight:bold;'>Total Qnty:</td><td colspan='1' style='text-align:left;font-weight:bold;'>" + qnty.toFixed(2) + "</td>");
                    htmls += ("<td colspan='1'  style='text-align:right;font-weight:bold;'>Total Amount:</td><td colspan='1' style='text-align:left;font-weight:bold;'><span class='totle'>" + totalAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tbody></table></div>");

                    var Roles = userRole.split(",");

                    debugger;
                    if (datas[0].Note != null && datas[0].Note != "") {
                    } else {
                        if (Roles.includes("Table Shift") || Roles.includes("Super User")) {
                            htmls += ("<div class='ordering'><input id='Shift_" + datas[0].OrderMasterId + "_" + datas[0].restrotableTitle + "_" + datas[0].GuestNo + "_" + datas[0].restrotableId + "_" + datas[0].OrderNo + "' type='button' class='sfBtn shiftTable restro-btn' value='Shift Table' />");
                        }
                    }
                    htmls += ("<input id='Order_" + datas[0].restrotableId + "' type='button' class='sfBtn ordernow restro-btn' value='Order Now ' style='margin-left:10px;' />");
                    if (Roles.includes("Item Shift") || Roles.includes("Super User")) {
                        htmls += ("<input id='shiftItems_" + datas[0].OrderMasterId + "_" + datas[0].restrotableId + "_" + datas[0].GuestNo + "_" + datas[0].OrderNo + "' type='button' class='sfBtn shiftItems restro-btn' value='Shift Items ' style='margin-left:10px;' />");
                    }

                    if (Roles.includes("Cancel Order") || Roles.includes("Super User")) {
                        htmls += ("<input id='Cancel_" + datas[0].OrderMasterId + "_" + datas[0].restrotableId + "_" + datas[0].GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel Order ' style='margin-left:10px;' />");
                    }

                    if (Roles.includes("cashier") || Roles.includes("Super User")) {
                        htmls += ("<input id='Pay_" + datas[0].restrotableId + "_" + datas[0].OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay Bill ' style='margin-left:10px;'/></div></div>");
                    }
                    else {
                        if (Roles.includes("View Bill") || Roles.includes("Super User")) {
                            htmls += ("<input id='Pay_" + datas[0].restrotableId + "_" + datas[0].OrderMasterId + "' type='button'  class='sfBtn viewnow restro-btn' value='View Bill ' style='margin-left:10px;'/></div></div>");
                        }
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
                }

                $('#DialogOrderDetail').html(htmls);
                if (datas.length > 0) {
                    $('.shiftItems').on('click', function () {
                        shiftItemsInitialize();
                        var ordermasterid = $(this).attr('id').split('_')[1];
                        tableId = $(this).attr('id').split('_')[2];
                        fromOrderMasterId = $(this).attr('id').split('_')[1];
                        var orderNo = $(this).attr('id').split('_')[3];
                        getDataForShift(ordermasterid, orderNo);
                        $('#btnShiftItem').bind('click');
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
                    fromtableId = $(this).attr('id').split('_')[2];
                    var noOfSeat = parseInt($(this).attr('id').split("_")[4]);
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
                    debugger;
                    $('#DialogOrderDetail').dialog('close');
                    DashboardFunction.config.ShiftOrderMasterID = $(this).attr('id').split("_")[1];
                    $('#shiftingTableName').html($(this).attr('id').split("_")[2]);
                    var seatNo = $(this).attr('id').split("_")[3];
                    fromtableId = $(this).attr('id').split('_')[4];
                    fromOrderNo = $(this).attr('id').split('_')[5];
                    fromOrderMasterId = DashboardFunction.config.ShiftOrderMasterID;

                    $('#shiftingTableSeatNo').html('<option value="0">ALL</option>');
                    for (var i = 1; i <= seatNo; i++) {
                        $('#shiftingTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
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

                $('#DialogOrderDetail').on('click', '.ordernow', function () {
                    debugger;
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });

                $('#DialogOrderDetail').on('click', '.viewnow', function () {
                    $('#DialogOrderDetail').dialog('close');
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBill(data[2]);

                });

                $('#DialogOrderDetail').on('click', '.paynow', function () {
                    $('#DialogOrderDetail').dialog('close');
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBillFromPay(data[2]);
                });
            },

            BindRoomdataById: function (result) {
                var htmls = [];
                $('#DialogOrderDetail').html("");
                var roominfo = result.RoomInfo;
                var datas = result.RoomBookingDetails;
                htmls += "<div id='dialogOrderOpen' scrolling='auto'><h4>Details of " + roominfo.restrotableTitle.toUpperCase() + "</h4>";
                htmls += ("<div class='booking-dtl'>");
                htmls += ("<button id='Add_" + roominfo.restrotableId + "' type='button' class='sfBtn addNew restro-btn fa fa-plus'>Add</button></div>");
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
                        htmls += ("<td><input id='Order_" + value.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order'/>");
                        htmls += ("<input id='Pay_" + value.OrderMasterId + "' type='button'  class='sfBtn roompaynow restro-btn' value='Pay' style='margin-left:10px;'/>");
                        htmls += ("<input id='Cancel_" + value.OrderMasterId + "_" + value.TableId + "_" + 1 + "' type='button'  class='sfBtn cancelorder restro-btn' value='Cancel' style='margin-left:10px;'/>");
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
                    fromtableId = $(this).attr('id').split('_')[2];
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
                    DashboardFunction.ResetAdvancePay();
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
                    $('#txtRemarks').val('');
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
                    $('#Membercheckbox').off().on('change', function () {
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
                    var htmls = "<table id='Brandtable' class='BookedTable-list'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th>PAN</th><th> Address </th><th> ContactNo.</th><th style='width:20px;'> Discount(%) </th><th class='tdcenter' style='width:20px;'>Paid</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.RemainingBalance + "_" + value.CardNumber + "'>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td>" + value.Addresss + "</td>";
                        // htmls += "<td>" + value.Occupation + "</td>";
                        // htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:20px;'>" + value.discount + "</td>";
                        if (membershipfor == "payment") {
                            htmls += "<td class='tdcenter' style='width:20px;'>" + "<img src='/images/paid.png' class='BrandDelete' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "' value='Delete'  /></td>";
                        } else {
                            htmls += "<td class='tdcenter' style='width:20px;'>" + "<img src='/images/completed.png' class='BrandDelete' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.RemainingBalance + "' value='Delete'  /></td>";
                        }
                        // htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                        {
                            jQueryUI: true,
                            //jQueryUI :true,
                            // "scrollX" :true,
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
                $("#membeshipformlist").on('click', '.BrandEdit', function (event) {
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

            BindUnoccupiedRoomByRoomTypeId: function (result) {
                var htmls = [];
                $('.RoomsForShift').html("");

                var datas = JSON.parse(result.d);
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
                            htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + "_" + value.GuestNo + "_" + (value.BillPaid.toString() == '1' ? 'tableyellow' : value.IsOccupied == 1 ? 'tablered' : 'tablegreen') + "' class= 'imgtableshift' ><img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + (value.BillPaid.toString() == '1' ? 'tableyellow' : value.IsOccupied == 1 ? 'tablered' : 'tablegreen') + ".png'></a> ");
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

                $(".imgtableshift").on('click', function () {
                    tabletoshift = $(this).attr('id').split('_')[1];
                    var seatNo = $(this).attr('id').split("_")[5];
                    var status = $(this).attr('id').split("_")[6];

                    if (status == 'tableyellow') {
                        jAlert("Please clear pending bill first!", 'Alert!!');
                    }
                    else if (status == 'tablered') {
                        jAlert("Table is already occupied!", 'Alert!!');
                    }
                    else {

                        $('#shiftToTableName').html($(this).attr('id').split('_')[4]);
                        $('#shiftToTableSeatNo').html('<option value="0">New</option>');
                        for (var i = 1; i <= seatNo; i++) {
                            $('#shiftToTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
                        }
                    }
                });
                $('.TablesForShift').show();
            },

            BindSalesBill: function (result, seatNo) {
                var isab = companyInfo.IsAbbreviated;
                var datas = JSON.parse(result.d);
                const orderdetails = datas.orderDetail;
                var billingterms = datas.billingTerm;
                var costcenters = datas.cuscenter;
                var costCenterGroup = datas.costCenterGroups;
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
                var qnty = 0.0;
                var DialogWidth = '900';
                var noOfGuest = 1;
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
                    netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc) + parseFloat(tableinfo.TotalAmount)).toFixed(2));
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

                    totalAmount = 0;


                }
                //AddChanges

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

                            totalAmount += parseFloat(amt);
                            ;
                            //console.log('totalAmount: ' + totalAmount);
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
                                //console.log('totalAmount: ' + totalAmount);

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
                            //totalAmount = (totalAmount * (1 + v_rate / 100.0));
                        }
                        else {
                            htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                        }
                    }
                    else {
                        htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    }
                    htmls += ("</tfoot></table>");
                } else {
                    htmls += ("<div class='left-sec' style='width:100%;margin-right:0;'><h4>Room : " + "  / Table : " + tableinfo.restrotableTitle + " </h4><h4> Waiter: " + "</h4>");
                }
                if (tableinfo.RoomBookDetailsID > 0) {
                    htmls += ("<h5>Room Charge Details : </h5>");
                    htmls += ("<table class='room-details-tbl'><thead><th>Room Name</th><th style='width:250px'>Rate</th><th>Days</th><th class='tdrate'>Amt (Rs.)</th></thead><tbody>");
                    htmls += ("<tr><td>" + tableinfo.restrotableTitle + "</td>");
                    var NRate = 0.00;
                    if (isab) {
                        if (isAbbreviated) {
                            NRate = parseFloat(tableinfo.Rate) * (1 + v_rate / 100.0);
                        } else {
                            NRate = parseFloat(tableinfo.Rate);
                        }
                    } else {
                        NRate = parseFloat(tableinfo.Rate);
                    }

                    htmls += ("<td data-rate='" + tableinfo.Rate + "'>" + NRate.toFixed(2) + "</td>");
                    htmls += ("<td>" + tableinfo.BookedDays + "</td>");
                    htmls += ("<td>" + (NRate * parseFloat(tableinfo.BookedDays)).toFixed(2) + "</td></tr>");
                    roomAmount += NRate * tableinfo.BookedDays;
                    totalAmount += tableinfo.TotalAmount;
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='roomtotle'>Rs. " + roomAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
                }

                htmls += ("<div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'>");

                totaldis = 0;


                htmls += ("</div>");

                htmls += '<div id="divBillingTerm"></div></div></div>';

                htmls += ("</div></div></div></div>");
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

            BindSalesBillForPay: function (result, seatNo) {
                var isab = companyInfo.IsAbbreviated;


                var d = result.d;
                var datas = JSON.parse(d);

                const orderdetails = datas.orderDetail;
                var billingterms = datas.billingTerm;
                var costcenters = datas.cuscenter;
                var costCenterGroup = datas.costCenterGroups;
                var tableinfo = datas.RoomBooking;
                var tokeninfo = datas.Token;
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
                var qnty = 0.00;
                var DialogWidth = '800';
                var noOfGuest = 1;
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

                    totalAmount = 0;

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
                            //totalAmount = (totalAmount * (1 + v_rate / 100.0));
                        }
                        else {
                            htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                        }
                    }
                    else {
                        htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
                    }
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

                htmls += ("<h4>Discount Method</h4>");
                htmls += ("<div class='dialogflex' style = 'border-top:1px solid gainsboro;border-bottom:none;' > <div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");

                totaldis = 0;

                htmls += ("<tr>");
                htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option></select> </td>");
                htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable' style='width:50px;'/></td></tr>");

                $.each(costCenterGroup, function (index, item) {
                    htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>" + item.GroupName + " ( Rs. " + item.TotalAmt.toFixed(2) + " ) </td><td>";
                    htmls += "<input type='text' class='sfInputbox txtdiscount txt_dis' data-groupId='" + item.GroupId + "' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='index_" + index + "' value='" + 0 + "' /></td>";
                });

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

                $('#DialogOrderDetail').html(htmls);

                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                $('#billnoForSales').val(seatNo);
                $('#DialogOrderDetail').dialog(
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

                        //$("#selDiscountType").val(1);
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
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
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

                                $('.totle').text((totalAmountN).toFixed(2));

                            }
                            $(".txt_dis").each(function () {
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat(getValue(this) / 100)));
                            });

                            totaldis = dis;

                        } else {
                            $(".txt_dis").each(function () {
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat(getValue(this) / 100)));
                            });

                            totaldis = dis;
                        }
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

                                $('.totle').text((totalAmountN).toFixed(2));

                            }

                            $(".txt_dis").each(function () {
                                dis += parseFloat(getValue(this));
                            })

                            totaldis = dis;


                        } else {
                            $(".txt_dis").each(function (ind, item) {
                                dis += parseFloat(getValue(this));
                            })

                            totaldis = dis;

                        }

                    }


                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                })


                $("#generateBill").on('click', function () {
                    DashboardFunction.Checkbill(tableinfo.OrderMasterId, seatNo, parseInt(tableinfo.TableId));
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
                            debugger;
                            var billingTerm = new Array();
                            var salesMaster = new Object();
                            var splited = 0;
                            var salesDetail = new Array();
                            salesMaster.billNo = tableinfo.BillNo;
                            salesMaster.BillDate = tableinfo.Date;
                            salesMaster.NepaliInvoiceDate = formatDate();
                            salesMaster.BasicAmount = (parseFloat($('.totalAfterDisc').val().split(' ')[1])); //Total After Discount
                            salesMaster.RoomId = tableinfo.RoomId;
                            salesMaster.TableId = parseInt(tableinfo.TableId);
                            salesMaster.OrderMasterId = tableinfo.OrderMasterId;
                            salesMaster.totaldiscount = totaldis;
                            salesMaster.TermAmount = 0.00;
                            salesMaster.NetAmount = $('#txtNetAmt').val().split(' ')[1]; //Net Amount
                            salesMaster.CusName = $('#txtCashCusName').val();
                            salesMaster.Address = $('#txtCusAddress').val();
                            salesMaster.PhoneNumber = $('#txtNumber').val();
                            salesMaster.PAN = $('#txtPan').val();
                            salesMaster.ChequeNo = "";
                            salesMaster.TransactionNo = "";
                            salesMaster.CusID = ($('#txtCusID').val() == "" ? 0 : parseInt($('#txtCusID').val()));
                            salesMaster.sumKot = kotAmount;
                            salesMaster.sumBev = barAmount;
                            salesMaster.Waiter = tableinfo.Waiter;
                            salesMaster.SPMID = 0;
                            salesMaster.IsSplit = (noOfGuest > 1 ? 1 : 0);
                            salesMaster.SeatNo = seatNo < 0 ? 1 : seatNo;
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
                            debugger;
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
                //Abb Change
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
                        htmls += ("<td attr-term='Taxable Amount' attr-percent='0' ><strong>Taxable Amount : </strong><input type=\"text\" id=\"txtTaxableAmt\" value=\"Rs. " + netAmount.toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + netAmount.toFixed(2) + "'/></td>");
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

                        var vat = parseFloat(netAmount * 0.13).toFixed(2);
                        htmls += ("<td attr-term='VAT' attr-percent='13' ><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + datas.billingTerm[datas.billingTerm.length - 1].ID + "_true" + "\"  value=\"Rs. " + vat + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + vat + "'/></td>");
                        netAmount = (parseFloat(netAmount) + parseFloat(vat)).toFixed(2);
                        htmls += ("</tr>");

                    }
                }


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
            BindmemberInfo: function (result) {
                var datas = JSON.parse(result);
                $("#txtCusID").val(datas[0].MembershipID);
                $("#txtCashCusName").val(datas[0].Name);
                $("#txtCusAddress").val(datas[0].Address);
                $("#txtPan").val(datas[0].PAN);
                $("#txtNumber").val(datas[0].TelMobile);
                $("#txtCardNumber").val(datas[0].CardNumber);

                $("#txtCashCusName").prop('disabled', true);
                $("#txtCusAddress").prop('disabled', true);
                $("#txtLoyaltyDiscount").val(datas[0].discount);
                //var roles = userRole.split(',');
                //if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                //    $("#selDiscountType").val(3);
                //    $("#selDiscountType").change();
                //    //$("#txtLoyaltyDiscount").change();
                //    //$(".disc").hide();
                //    //$(".roomdisc").hide();
                //    //$(".loyaltydisc").show();
                //}
                //else {
                //}

            },


            BindPaymentModesAndProviders: function () {
                var result = JSON.parse(Paymode);
                var cardProviders = result.providers;
                var paymentModes = result.paymentModes;

                var htmls = '';
                $('#payment').html(htmls);
                htmls += '<div class="unpaidbill_ttl" style="display:flex;justify-content:space-between;"><h4>Total Amount</h4>';
                htmls += '</div>';
                htmls += '<table id="tblPayment" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';
                $.each(paymentModes, function (index, mode) {
                    htmls += '<tr>';
                    if (mode.PaymentModeID != 4) {
                        htmls += '<td><input type="checkbox" class="pmntCheck" id="chkBox_' + mode.PaymentModeID + '" ' + (mode.PaymentModeID == 1 ? 'checked' : '') + ' /><label for="chkBox_' + mode.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + mode.PaymentMode + ' : </label></td>';
                    }
                    htmls += '<td></td>';
                    htmls += '<td>';
                    if (mode.PaymentModeID == 1) {
                        htmls += 'Tender Amount <input type="text" id="txtTenderAmount" class="pmt txtNum sfInputbox" value="0" />';
                        htmls += '</td>';
                        htmls += '<td>Return Amount <input type="text" id="txtReturnAmount" class="pmt txtNum sfInputbox" value="0"/></td>';
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" value="0"/></td>';
                    } else if (mode.PaymentModeID == 4) {
                        htmls += '';

                    } else {
                        htmls += 'Provider<select class="sfInputbox selPaymentMode">';
                        $.each(cardProviders, function (index, provider) {
                            htmls += '<option value="' + provider.ProviderID + '">' + provider.ProviderName + '</option>';
                        });
                        htmls += '</select>';
                        htmls += '</td>';
                        htmls += '<td># <input type="text" class="pmt sfInputbox txtTransaction" placeholder="' + (mode.PaymentModeID == 2 ? 'Cheque No.' : 'Transaction No.') + '" /></td>';
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount"  value="0"/></td>';
                    }
                    htmls += '</tr>';
                });
                htmls += '</table>';
                htmls += '<input type="button" class="sfBtn restro-btn" id="paymentBtn" value="Pay" />';
                $('#payment').html(htmls);

                $('#payment').dialog({
                    'title': 'Pay Bill',
                    width: 600,
                    modal: false,
                    dialogClass: 'unpaidd',
                    position: ['center', 'center']
                });

                $(".pmntCheck").click(function () {
                    $('.pmntCheck').not(this).prop("checked", false);
                });

                $('#tblPayment').on('keyup keydown', "#txtTenderAmount", function () {
                    var row = $(this).closest('tr');
                    var returnAmnt = (Number($("#txtTenderAmount").val()) - Number($("#txtReturnAmount").val()));
                    var payAmnt = (Number($("#txtTenderAmount").val()) - $("#txtReturnAmount").val());
                    $(row).find('.txtPayAmount').val(payAmnt.toFixed(2));

                });
                $('#tblPayment').on('keyup keydown', "#txtReturnAmount", function () {
                    var row = $(this).closest('tr');
                    var returnAmnt = Number($("#txtReturnAmount").val()).toFixed(2);
                    var payAmnt = (Number($("#txtTenderAmount").val()) - returnAmnt);
                    $(row).find('.txtPayAmount').val(payAmnt.toFixed(2));
                });


                $('#paymentBtn').unbind('click').on('click', function () {
                    var PaymentList = new Array();
                    if ($("#tblPayment input:checkbox:checked").length == 1) {
                        $('.pmntCheck').each(function () {
                            if ($(this).is(':checked')) {
                                var Payment = new Object();
                                var row = $(this).closest('tr');
                                var spmid = $(this).attr('id').split('_')[1];
                                Payment.SPMID = spmid;
                                Payment.ChequeNo = (spmid == 2 ? $(row).find('.txtTransaction').val() : '');
                                Payment.ProviderName = (spmid == 2 || spmid == 3 ? $(row).find('.selPaymentMode').text() : '');
                                Payment.TransactionNo = (spmid == 3 ? $(row).find('.txtTransaction').val() : '');
                                Payment.ProviderID = (spmid == 2 || spmid == 3 ? $(row).find('.selPaymentMode').val() : '');
                                Payment.Paymode = ((spmid == 1) ? "CASH" : ((spmid == 2) ? "Cheque" : ((spmid == 3) ? "SWAP" : "")));
                                Payment.PayAmount = $(row).find('.txtPayAmount').val();
                                PaymentList.push(Payment);
                            }
                        })
                        $('#BookAdvancePay').val(PaymentList[0].PayAmount);
                        $('.ProviderName').val(PaymentList[0].ProviderID);
                        $('.PaymentMode').text(PaymentList[0].Paymode);
                        $('.PaymentModeID').text(PaymentList[0].SPMID);
                        $('#txtTransNo').val(PaymentList[0].TransactionNo == "" ? PaymentList[0].ChequeNo : PaymentList[0].TransactionNo);
                        if (PaymentList[0].Paymode == "CASH") {
                            $('.padv').hide();
                        }
                        else {
                            $('.padv').show();
                        }
                        $('#payment').dialog('close');
                    } else {
                        jAlert('Select Atleast One Payment Mode.', 'Alert!!');
                        $('#paymentBtn').bind('click');
                    }

                });

            },
            ResetAdvancePay: function () {
                $('#BookAdvancePay').val("");
                $('#txtRemarks').val('');
                $('.ProviderName').val("");
                $('#txtTransNo').val("");
                $('.PaymentMode').text("");
                $('.PaymentModeID').text("");
                $('.padv').hide();
                $("#Rembalance").val("0");
                RemainingAmount = 0;
            },

            Reset: function () {
                $(".ui-dialog-content").dialog("close");
                $('#TablesInRooms').hide();
            },
        };
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);