var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

var disLimitBasicAmt = 0.00;
var isPossible = false;
var isButtonClicked = false;
var orddetail = null;
var billingterms = null;
var costcenters = null;
var tableinfo = null;
var tokeninfo = null;
var barAmount = 0.00;
var kotAmount = 0.00;
var totalAmount = 0.00;
var kotdis = 0.00;
var bevdis = 0.00;
var roomAmount = 0.00;
var roomdis = 0.00;
var bakeryAmount = 0.00;
var bakerydis = 0.00;
var pizzaAmount = 0.00;
var pizzadis = 0.00;
var DialogWidth = '900';
var noOfGuest = 1;
var sNo = 0;
var username = "";
var totalRestAmt = 0.00;

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
    var tabs = $("#tabs").tabs();
    $('#tabs').css('display', 'block');
    $.companyDashboardcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/RestroDashboard/',
                HostUrl: '',
                TypeId: '',
                numpin: '',
                creditLimit: 0
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
        var totalamount = 0;
        var mergetableid = 0;
        var containOccTab = false;
        var CustID = 0;
        var OrderMasterID = 0;
        var CancelTableID = 0;
        var fromtableId = 0;
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
        var IsEnableDiscount = false;
        var OccupiedRoomList = [];
        var OccupiedTableList = [];
        var billAction = p.HostUrl + "/Generate-Bills.aspx?action=bill"
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
                DashboardFunction.GetUserName();
                DashboardFunction.GetOccupiedTables(true);
                DashboardFunction.GetComplimentaryOccupiedTables(true);
                DashboardFunction.GetTakeAwayOrders();
                DashboardFunction.GetOccupiedRooms();
                DashboardFunction.GetBookedRooms();
                $(".main").css("display", "block");
                $('.shiftItems').on('click', function () {
                    shiftItemsInitialize();
                    var ordermasterid = $(this).attr('id').split('_')[1];
                    tableId = $(this).attr('id').split('_')[2];
                    fromOrderMasterId = $(this).attr('id').split('_')[1];
                    getDataForShift(ordermasterid);
                    $('#btnShiftItem').bind('click');
                });
                console.log(p.creditLimit)

            },
            init: function () {

                DashboardFunction.InitialSetup();
                $('#txtSearch').on('keyup', function () {
                    DashboardFunction.BindOccupiedRoom();
                    DashboardFunction.BindOccupiedTable();
                    DashboardFunction.BindComplimentaryOccupiedTables();
                });


                $('body').off('keyup').on('keyup', function (e) {
                    e.preventDefault();
                    var key = e.key.toLowerCase();

                    if (e.altKey && key == "o") {
                        DashboardFunction.config.method = "OpenDrawer";
                        DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                        DashboardFunction.config.ajaxCallMode = 76;
                        DashboardFunction.ajaxCall(DashboardFunction.config);
                    }

                    if (e.ctrlKey && e.altKey && key == "b") {
                        if (isPossible) {
                            jConfirm('Are You Sure  ?', 'Generate Bill', function (confirmed) {
                                if (confirmed) {
                                    SaveAcc();
                                }
                            });
                        }
                    }

                });

                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        //$('#hdnPinMatch').unbind('change');
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
                setInterval(function () { DashboardFunction.InitialSetup() }, 60000);

                $('#btnSumbit').on('click', function () {
                    var myStr = $("#canceltextarea").val();
                    var newStr = myStr.replace(/  +/g, ' ');
                    if (newStr.length <= 3) {
                        jAlert('Please Insert Valid Reason.', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        DashboardFunction.Checkbill(OrderMasterID, parseInt($('#splitNoCancel').val() == null ? 0 : $('#splitNoCancel').val()), fromtableId);
                        //DashboardFunction.CancelOrderedData();
                    }
                });

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
                        //DashboardFunction.DeleteItem(id);
                    } else if (membershipfor == "PaymentLoyalty") {
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

                        var roles = userRole.split(',');

                        if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                            $("#selDiscountType").val(3);
                            $("#selDiscountType").change();
                        }
                        else {
                        }

                    } else if (membershipfor == "RoomBooking") {
                        $("#MemberID").val(ids[1]);
                        $("#MemberName").val(ids[2] + " " + ids[3]);
                        $("#MemberEmail").val("");
                        $("#MemberPhone").val(ids[7]);
                        $("#MemberIdCardNo").val('');
                        $("#membeshipformlist").dialog('close');
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

                $('.btnBook').on('click', function () {
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
                        break;
                    case 8:
                        jAlert('Table Successfully Shifted', "Information!!", function () { $.alerts.dialogClass = null; });
                        DashboardFunction.Reset();
                        DashboardFunction.InitialSetup();
                        break;
                    case 10:
                        DashboardFunction.Bindmembership(data);
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
                        //location.reload();
                        break;
                    case 49:
                        DashboardFunction.BindUnoccupiedRoomByRoomTypeId(data);
                        break;
                    case 50:
                        DashboardFunction.BindUnoccupiedTableByRoomTypeId(data);
                        break;
                    case 53:
                        //alert("Tables Successfully Merged.");

                        var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(mergetableid);
                        window.location.href = url;
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
                        print();
                        //$('#printno').show();
                        $('#InvoiceType').html('INVOICE');
                        $('#btnPrints').click();
                        DashboardFunction.GetUserName();
                        var paymentAfterGenerateBill = JSON.parse(localStorage.getItem("paymentAfterGenerateBill"));
                        if (paymentAfterGenerateBill) {
                            payment(data.d);
                        }
                        break;
                    case 59:
                        //$('#printno').show();
                        print();
                        $('#BillingView').dialog('close');
                        DashboardFunction.GetOccupiedTables(true);
                        DashboardFunction.GetComplimentaryOccupiedTables(true);
                        DashboardFunction.GetTakeAwayOrders();
                        DashboardFunction.GetOccupiedRooms();
                        DashboardFunction.GetBookedRooms();
                        break;
                    case 60:
                        OccupiedTableList = data.d;
                        DashboardFunction.BindOccupiedTable();
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
                        jAlert('Booking Successfully Updated', "Information!!", function () {
                            $('.roomBookDash').dialog('close');
                            DashboardFunction.GetOccupiedRooms();
                            DashboardFunction.GetBookedRooms();
                            $("#PINbox").val('');
                        });

                        break;
                    case 63:
                        OccupiedRoomList = JSON.parse(data.d)
                        DashboardFunction.BindOccupiedRoom();
                        break;
                    case 64:
                        DashboardFunction.BindBookedRoom(JSON.parse(data.d));
                        break;
                    case 65:
                        DashboardFunction.BindComplimentaryOccupiedTables(data.d);
                        break;
                    case 66:
                        //DashboardFunction.BindComplimentaryOrders(data.d);
                        DashboardFunction.BindComplimentaryOrders(data);
                        break;
                    case 67:
                        DashboardFunction.BindForEditingBooking(data.d);
                        break;
                    case 68:
                        var role = data.d;
                        userRole = role.Roles;
                        break;
                    case 69:
                        var result = data.d;
                        var roles = result.Roles.split(',');

                        if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                            IsEnableDiscount = true;
                        }

                        else {
                            IsEnableDiscount = false;
                        }
                        userRole = data.d.Roles;
                        break;
                    case 70:
                        DashboardFunction.BindmemberInfo(data.d);
                        break;
                    case 71:
                        DashboardFunction.BindTakeAwayOrders(data.d);
                        break;
                    case 73:
                        DashboardFunction.BindCustomerDetails(data.d);
                        break;
                    case 74:
                        DashboardFunction.BindTakeAwaySalesBill(data, 1);
                        break;
                    case 75:
                        DashboardFunction.BindBillStatus(data.d);
                        break;
                    case 76:
                        jAlert('Drawer Opened Successfully !!!', "Information!!", function () { });
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
                DashboardFunction.config.ajaxCallMode = 75;
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

                        if ($('.customerForCash').prop('checked') == false) {

                            var basicAmt = parseFloat(disLimitBasicAmt);
                            //var tempDis = $('.totalDiscount').val().split('.');
                            var ttlDis = parseFloat($('.totalDiscount').attr('attr-amount'));

                            var disper = parseFloat((ttlDis * 100) / basicAmt);

                            // Check for discount limit
                            var creditlimit = p.creditLimit; //Percentage
                            if (creditlimit >=  disper) {
                                InitializePin();
                            }
                            else {
                                jAlert('Discount limit exceed. Please contact admin or higher authority !!!!', "Alert !!!", function () { $.alerts.dialogClass = null; });
                            }
                        } else {
                            InitializePin();
                        }
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
                $("#selDiscountType").val(3);
                $("#selDiscountType").change();
                $("#txtLoyaltyDiscount").change();
                $(".disc").hide();
                $(".roomdisc").hide();
                $(".loyaltydisc").show();
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
            GetDataForTakeAwaySalesBill: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForTakeAwaySalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 74;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetmemberInfo: function (info) {
                DashboardFunction.config.method = "getMemberDetailsbyinfo";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    info: info
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
                roomBook.Remarks = $('#txtRemarks').val();

                DashboardFunction.config.method = "SaveRoomBoking";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ roomBooking: roomBook, orderMaster: ordermaster });
                DashboardFunction.config.ajaxCallMode = 62;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetOccupiedTables: function (isTable) {

                DashboardFunction.config.method = "GetOccupiedTables";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ isTable: isTable });
                DashboardFunction.config.ajaxCallMode = 60;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetComplimentaryOccupiedTables: function (isTable) {

                DashboardFunction.config.method = "GetComplimentaryOccupiedTables";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ isTable: isTable });
                DashboardFunction.config.ajaxCallMode = 65;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetOccupiedRooms: function () {

                DashboardFunction.config.method = "GetOccupiedRooms";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify();
                DashboardFunction.config.ajaxCallMode = 63;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetTakeAwayOrders: function () {
                DashboardFunction.config.method = "GetTakeAwayOrders";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify();
                DashboardFunction.config.ajaxCallMode = 71;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetBookedRooms: function () {

                DashboardFunction.config.method = "GetBookedRooms";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify();
                DashboardFunction.config.ajaxCallMode = 64;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetDataForPrint: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForPrint";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                //DashboardFunction.config.ajaxCallMode = 56;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetDataForSalesBill: function (orderMasterId) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 56;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetComplimentaryOrders: function (orderMasterId) {
                DashboardFunction.config.method = "GetComplimentaryOrders";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 66;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetBill: function (salesMasterId) {
                getBill(salesMasterId, false);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '400',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'center']
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
            GetUnoccupiedTableByRoomTypeId: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeId";
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
            CheckRolesFromPin: function (PinCode) {
                DashboardFunction.config.method = "CheckPin";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    pin: PinCode
                });
                DashboardFunction.config.ajaxCallMode = 69;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            ShiftTable: function () {
                var totableID = tabletoshift;
                var fromordermasterid = DashboardFunction.config.ShiftOrderMasterID;
                var fromSeatNo = $('#shiftingTableSeatNo').val();
                var toSeatNo = $('#shiftToTableSeatNo').val();
                var shiftedby = $('#hdnPinBy').val();
                DashboardFunction.config.method = "shiftTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ fromordermasterid: fromordermasterid, totableID: totableID, fromSeatNo: fromSeatNo, toSeatNo: toSeatNo, shiftedby: shiftedby });
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
            GetBookDataForEditing: function (orderMasterId) {
                DashboardFunction.config.method = "GetBookDataForEditing";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId });
                DashboardFunction.config.ajaxCallMode = 67;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            CheckAvailability: function (startDate, endDate, roombookDetailId, tableId) {

                DashboardFunction.config.method = "CheckAvailability";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, roombookDetailId: roombookDetailId, tableId: tableId });
                DashboardFunction.config.ajaxCallMode = 61;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            CancelOrderedData: function () {

                var id = OrderMasterID;
                var cancel = false;
                var ordermaster = new Object();
                ordermaster.TableId = CancelTableID,
                    ordermaster.OrderMasterID = OrderMasterID,
                    ordermaster.GuestNo = parseInt($('#splitNoCancel').val() == null ? 1 : $('#splitNoCancel').val());
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
            //<<----------------------------- Bind Here ---------------------------------------->

            Bindmembership: function (data) {

                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var datas = JSON.parse(data.d);
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='BookedTable-list display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Select</th><th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.CardNumber + "'>";
                        if (membershipfor == "payment") {
                            htmls += "<td>" + "<img src='/images/paid.png' class='BrandDelete' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "' value='Delete'  /></td>";
                        } else {
                            htmls += "<td>" + "<img src='/images/completed.png' class='BrandDelete' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.CardNumber + "' value='Delete'  /></td>";
                        }
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        // htmls += "<td>" + value.Occupation + "</td>";
                        // htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";

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
                            //"scrollY": false,
                            //"scrollCollapse": false,
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
            BindUnoccupiedRoomByRoomTypeId: function (result) {
                
                var htmls = [];
                $('.RoomsForShift').html("");

                var datas = JSON.parse(result.d);
                
                htmls += "<select class='imgRoomForShift sfInputbox' style='width:150px;' ><option value='' disabled selected>-- select --</option>";
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
                        if (value.IsTable) {
                            if (!value.MergeTableList > 0 && (value.IsTable || value.OrderMasterId > 0)) {
                                //if (!value.MergetableList > 0 && value.restrotablesStatusID == 6 && value.IsTable && (value.BillPaid != 0 || value.IsCancelled != 0)) {
                                htmls += ("<li>");
                                htmls += ("<a id ='");
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + "_" + value.GuestNo + "' class = 'imgtableshift' ><img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + ((value.BillPaid != 0 || value.IsCancelled != 0) ? 'tablegreen' : 'tablered') + ".png'></a> ");
                                htmls += ("<h5 class='");
                                htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' ? "NotPaid" : "Paid");
                                htmls += ("' >" + value.restrotableTitle + "</h5>");
                                htmls += ("</li>");
                            }
                        } else {
                            if (value.restrotablesStatusID == 7) {
                                htmls += ("<li>");
                                htmls += ("<a id ='");
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + "_" + value.GuestNo + "' class = 'imgtableshift' ><img src='" + p.HostUrl + "/Modules/RestroDashboard/image/" + ((value.BillPaid != 0 || value.IsCancelled != 0) ? 'room-red' : 'room-red') + ".png'></a> ");
                                htmls += ("<h5 class='");
                                htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' ? "NotPaid" : "Paid");
                                htmls += ("' >" + value.restrotableTitle + "</h5>");
                                htmls += ("</li>");
                            }
                        }
                        


                    });
                    htmls += "</ul>";

                    $('.TablesForShift').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });

                }


                $(".imgtableshift").on('click', function () {
                    tabletoshift = $(this).attr('id').split('_')[1];
                    $('#shiftToTableName').html($(this).attr('id').split('_')[4]);
                    var seatNo = $(this).attr('id').split("_")[5];
                    $('#shiftToTableSeatNo').html('<option value="0">New</option>');
                    for (var i = 1; i <= seatNo; i++) {
                        $('#shiftToTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
                    }

                });



                $('.TablesForShift').show();


            },
            /////complimentary orders show in popup to print
            BindComplimentaryOrders: function (result) {
                var d = result.d;
                var datas = JSON.parse(d);
                const orderdetails = datas;
                var htmls = "";
                var qnty = 0.0;
                var amt = 0.0;
                var totalAmount = 0.0;
                $('#DialogOrderDetail').html("");
                DialogWidth = '900';
                noOfGuest = 1;
                htmls += "<div id='dialogOrderOpen'>";
                htmls += ("<div class='dashboardmain'>");
                if (orderdetails.length > 0) {
                    noOfGuest = parseInt(orderdetails[0].GuestNo);
                    htmls += ("<div class='left-sec'><div style='text-align:center;'><h4>Complimentary Receipt</h4></div><div class='dialogflex'><h4>Room : " + orderdetails[0].restroRoom + "  / Table : " + orderdetails[0].restrotableTitle + " </h4><h4> Date: " + orderdetails[0].tableDate.toString("MM/dd/yyyy") + "</h4></div>");
                    //htmls += ("<div style='text-align:center'><div><h4>Complimentary Receipt</h4></div><div class='dialogflex'><h4>Room : " + orderdetails[0].restroRoom + "  / Table : " + orderdetails[0].restrotableTitle + " </h4><h4> Date: " + orderdetails[0].tableDate.toString("MM/dd/yyyy") + "</h4></div>");
                    htmls += ("<div class='dialogflex' style=margin-top:5px;><h5>Ordered Items Details</h5>");

                    htmls += "</div>";
                    htmls += ("<div class='item_list_div'  style='text-align:center;'><table class='item-list-tbl' style='text-align:center;'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody id='complimentaryOrdersTbl'>");

                    var sn = 1;
                    $.each(orderdetails, function (index, value) {

                        htmls += ("<tr class='" + value.itemId + " allsplited'><td>" + sn + "</td><td class='" + value.itemId + "+" + value.CostCenterId + "'>" + value.itemName + "</td>");
                        htmls += ("<td>" + value.Quantity + "</td>");
                        htmls += ("<td class='item-rate'>" + value.Rate + "</td>");
                        qnty += parseFloat(value.Quantity);
                        amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                        totalAmount += parseFloat(amt);
                        //console.log('totalAmount: ' + totalAmount);
                        htmls += ("<td class='item-amount'>" + amt.toFixed(2) + "</td></tr>");

                        sn++;
                    });

                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='2'  style='text-align:right;font-weight:bold;'>Total Qnty : </td><td>" + qnty.toFixed(2) + "</td><td style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. </span></td><td>" + totalAmount.toFixed(2) + "</td></tr>");

                    htmls += ("</tfoot></table>");
                    htmls += ("<div style='text-align:left; margin-top:10px;'><span style='font-wight:bold; font-size:12px;'><u>Signature...</u></span></div></div>");
                } else {
                    htmls += ("<div class='left-sec'><h4>Room : No Data </h4><h4> Waiter: " + "</h4></div>");
                }


                htmls += ("<div style='text-align:right'><input type='button' id='btnPrintCompOrders' value='Print Recpt' /></div>");
                $('#DialogOrderDetail').html(htmls);
                $('#DialogOrderDetail').dialog(
                    {
                        'title': 'Complimentary Orders',
                        width: DialogWidth,
                        modal: true,
                        dialogClass: 'CheckEnable unpaidd',
                        position: ['center', 'center']
                    });

                $("#btnPrintCompOrders").click(function () {

                    var contents = $('#dialogOrderOpen').html();
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

                        //// refresh complimentary orders
                        //alert('Print successfull');
                        $('#DialogOrderDetail').dialog('close');
                        DashboardFunction.GetComplimentaryOccupiedTables(true);
                    }, 500);


                });
            },

            BindSalesBill: function (result, seatNo) {
                var isab = companyInfo.IsAbbreviated;
                isButtonClicked = true;
                sNo = seatNo;
                var d = result.d;
                var datas = JSON.parse(d);
                console.log(datas);
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

                    totalAmount = 0.00;

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
                        if (value.SeatNo == sNo) {
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
                            //totalAmount = (totalAmount * (1 + v_rate / 100.0));
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

                totalRestAmt = totalAmount;


                if (tableinfo.RoomBookDetailsID > 0) {
                    htmls += ("<h5>Room Charge Details : </h5>");
                    htmls += ("<table class='room-details-tbl'><thead><th>Room Name</th><th style='width:250px'>Rate</th><th>Days</th><th>Amt (Rs.)</th></thead><tbody>");
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

                    htmls += ("<td data-rate='" + tableinfo.Rate +"'>" + NRate.toFixed(2) + "</td>");
                    htmls += ("<td>" + tableinfo.BookedDays + "</td>");
                    htmls += ("<td>" + (NRate * parseFloat(tableinfo.BookedDays)).toFixed(2) + "</td></tr>");
                    roomAmount += NRate * tableinfo.BookedDays;
                    totalAmount += tableinfo.TotalAmount;
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='roomtotle'>Rs. " + roomAmount.toFixed(2) + "</span></td></tr>");
                    htmls += ("</tfoot></table>");
                }

                htmls += ("<h4>Discount Method</h4><div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'><div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");

                //Change For Dis Limit
                disLimitBasicAmt = totalAmount;
                totaldis = 0;

                htmls += ("<tr>");
                htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option></select> </td>");
                htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable' style='width:50px;'/></td></tr>");

                $.each(costCenterGroup, function (index, item) {
                    htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>" + item.GroupName + " ( Rs. " + item.TotalAmt.toFixed(2) + " ) </td><td>";
                    htmls += "<input type='text' class='sfInputbox txtdiscount txt_dis' data-groupId='" + item.GroupId + "' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='index_" + index + "' value='" + 0 + "' /></td>";

                })

                if (isab) {
                    if (isAbbreviated) {
                        htmls += "<tr class='roomdisc' style='" + ((tableinfo.RoomBookDetailsID > 0) ? "" : "display:none") + "'><td>Room ( Rs. " + (roomAmount/1.13).toFixed(2) + " ) </td><td>";
                    } else {
                        htmls += "<tr class='roomdisc' style='" + ((tableinfo.RoomBookDetailsID > 0) ? "" : "display:none") + "'><td>Room ( Rs. " + (roomAmount).toFixed(2) + " ) </td><td>";
                    }
                } else {

                    htmls += "<tr class='roomdisc' style='" + ((tableinfo.RoomBookDetailsID > 0) ? "" : "display:none") + "'><td>Room ( Rs. " + (roomAmount).toFixed(2) + " ) </td><td>";
                }

                htmls += "<input type='text' class='sfInputbox txtdiscount txt_dis' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtRoomDiscount' value=0 /></td>";
                htmls += "</tr>";
                htmls += "<tr class='loyaltydisc' style='display:none;'><td>Loyalty Discount : </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtLoyaltyDiscount' value='" + tableinfo.LoyaltyDiscount + "' disabled /></td>";
                htmls += "</tr>";
                htmls += ("</tbody></table></div>");

                htmls += '<div id="divBillingTerm"></div></div></div>';

                htmls += '<div class="right-sec"><div class="right-secA"><h4>Customer Info</h4><table><tbody>';

                if (tokeninfo.length > 0) {
                    htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(tokeninfo[0].CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>';
                    htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr>';
                    htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + tokeninfo[0].CustomerName + '"/><input type="hidden" id="txtCusID" value="' + tableinfo.CustomerId + '" /></td></tr>';
                    htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox" value="' + tokeninfo[0].Phone + '"/></td></tr>';
                    htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr>';
                    htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                } else {
                    htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(tableinfo.CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>';
                    htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr>';
                    htmls += '<tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + tableinfo.CustomerName + '"/><input type="hidden" id="txtCusID" value="' + tableinfo.CustomerId + '" /></td></tr>';
                    htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox" value="' + tableinfo.PhoneNo + '"/></td></tr>';
                    htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr>';
                    htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                }

                htmls += '</tbody></table></div>';
                htmls += '<input id="generateBill" type="button" class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/>';
                if (tableinfo.RoomBookDetailsID > 0) {
                    htmls += '<input id="roomService" type="checkBox" class="sfBtn restro-btn" value="Room Service" style="margin-left:10px;"/>';
                    htmls += '<label> Room Service</label>';
                }

                htmls += '</div></div>';

                htmls += ("</div></div></div></div>");
                htmls += ("<input id='Pay_" + tableinfo.TableId + "_" + tableinfo.OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
                var orderMasterId = tableinfo.OrderMasterId;

                $('#DialogOrderDetail').html(htmls);
                $('#txtPan').attr('autocomplete', 'off');

                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
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
                        DashboardFunction.getmembershiplistbyId(tokeninfo[0].CustomerID);
                    }
                }

                $("#tblDiscount").on('click', ".txtdiscount, .txtnum", function (event) {
                    InitializeNumPin(this, $(this).val());
                });


                $('#billnoForSales').on('change', function () {
                    DashboardFunction.BindSalesBill(result, parseInt($('#billnoForSales').val()));
                    seatNo = $('#billnoForSales').val();
                    sNo = seatNo;
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

                $("#roomService").on('click', function () {
                    if ($(this).is(":checked")) {
                        var term = new Object();
                        term.IsAdd = true;
                        term.ID = 62;
                        term.BillTerm = "Room Service";
                        term.Rate = 10;
                        term.Amount = 0;
                        datas.billingTerm.push(term);
                        DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                    } else {
                        debugger;
                        $.each(datas.billingTerm, function (index, value) {
                            if (value.ID == 62) {
                                datas.billingTerm.splice(index,1)
                            }
                        })
                        DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                    }
                });

                // $(".txtdiscount , .txtnum").on('click', function (event) {

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
                    $('.room-details-tbl tbody').html("");
                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        if (value.SeatNo == sNo) {
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
                    if (tableinfo.RoomBookDetailsID > 0) {
                        htm = '';
                        htm += ("<tr><td>" + tableinfo.restrotableTitle + "</td>");

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

                        htm += ("<td data-rate='" + tableinfo.Rate + "'>" + NRate.toFixed(2) + "</td>");
                        htm += ("<td>" + tableinfo.BookedDays + "</td>");
                        htm += ("<td>" + (NRate * parseFloat(tableinfo.BookedDays)).toFixed(2) + "</td></tr>");
                        roomAmount = tableinfo.TotalAmount
                        
                        $('.room-details-tbl tbody').append(htm);
                    }

                    if (isab) {
                        if (isAbbreviated) {
                            totalAmountN = totalAmount * (1 + v_rate / 100);
                            $('.totle').text((totalAmountN).toFixed(2));

                        } else {
                            $('.totle').text((totalAmount).toFixed(2));
                        }
                    } else {

                        $('.totle').text((totalAmount).toFixed(2));
                    }

                    if (isab) {
                        if (isAbbreviated) {
                            $('.roomtotle').text('Rs. ' + (tableinfo.TotalAmount * 1.13).toFixed(2));
                        } else {
                            $('.roomtotle').text('Rs. ' + (tableinfo.TotalAmount).toFixed(2));
                        }
                    } else {
                        $('.roomtotle').text('Rs. ' + (tableinfo.TotalAmount).toFixed(2));
                    }

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

                            var Roomitemrow = $('.room-details-tbl').find('tbody').find('tr');
                            if (Roomitemrow.length > 0) {
                                $.each(Roomitemrow, function (index, value) {
                                    _this = $(this);
                                    var qty = parseFloat(_this.find('td').eq(2).text());
                                    var rate = _this.find('td').eq(1);
                                    var rateInt = parseFloat(rate.data('rate'));
                                    var disAbb = parseFloat((rateInt * (100 - lolDisRate) / 100) * (1 + v_rate / 100));
                                    rate.text(disAbb.toFixed(2))
                                    _this.find('td').eq(3).text((qty * disAbb).toFixed(2))
                                    totalAmountR += parseFloat(_this.find('td').eq(3).text());

                                    //console.log('Rate:' + rateInt + 'Amt:' + (qty * disAbb) + 'Total:' + totalAmountR)
                                });
                                // cgGroup.TotalDis = disRate;
                                $('.roomtotle').text((totalAmountR).toFixed(2));
                            }
                        }
                    }

                    totaldis += ((totalAmount + tableinfo.TotalAmount) * (lolDisRate) / 100);
                    totalAmount = totalAmount + tableinfo.TotalAmount; 
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                });
                $('.txt_dis').on('keyup', function () {
                    totalAmount = 0.00;

                    $.each(costCenterGroup, (i, v) => {
                        totalAmount += v.TotalAmt;
                    });
                    var totalAmountN = 0.00;
                    var totalAmountR = 0.00;
                    var currGroupId = $(this).data('groupid');
                    var currIndex = $(this).attr('id').split('_')[1];
                    var cgGroup = costCenterGroup.find(x => x.GroupId == currGroupId);
                    if ($(this).attr('id') != 'txtRoomDiscount') {
                        cgGroup.TotalDis = parseFloat($(this).val());
                    }

                    if ($("#selDiscountType").val() == "1") {
                        if (($(this).val()) > 100 || ($(this).val()) < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $(this).val(0);
                        }

                        var disRate = parseFloat($(this).val() == "" ? 0 : $(this).val());
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

                                if ($(this).attr('id') == 'txtRoomDiscount') {
                                    var Roomitemrow = $('.room-details-tbl').find('tbody').find('tr');
                                    if (Roomitemrow.length > 0) {
                                        $.each(Roomitemrow, function (index, value) {
                                            _this = $(this);
                                            var qty = parseFloat(_this.find('td').eq(2).text());
                                            var rate = _this.find('td').eq(1);
                                            var rateInt = parseFloat(rate.data('rate'));
                                            var disAbb = parseFloat((rateInt * (100 - disRate) / 100) * (1 + v_rate / 100));
                                            rate.text(disAbb.toFixed(2))
                                            _this.find('td').eq(3).text((qty * disAbb).toFixed(2))
                                            totalAmountR += parseFloat(_this.find('td').eq(3).text());

                                            //console.log('Rate:' + rateInt + 'Amt:' + (qty * disAbb) + 'Total:' + totalAmountR)
                                        });
                                        // cgGroup.TotalDis = disRate;
                                        $('.roomtotle').text((totalAmountR).toFixed(2));
                                    }
                                }
                               
                                


                            } //else {
                            
                                $(".txt_dis").each(function () {
                                    var keyIndex = parseFloat($(this).attr('id').split('_')[1]);
                                    if (keyIndex >= 0) {
                                        dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat($(this).val() / 100)));

                                    } else {
                                        dis += (parseFloat(tableinfo.TotalAmount) * (parseFloat($(this).val() / 100)))
                                    }
                                })

                            totaldis = dis;

                        } else {
                            $(".txt_dis").each(function () {
                                _this = $(this);
                                if (_this.attr('id') == 'txtRoomDiscount' && !$('#txtRoomDiscount').is(':visible') ) {
                                    return false;
                                }
                                if (_this.attr('id') != 'txtRoomDiscount') {
                                    var keyIndex = parseInt(_this.attr('id').split('_')[1]);
                                    dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat(_this.val() / 100)));
                                } else {
                                    dis += (parseFloat(tableinfo.TotalAmount) * (parseFloat($(this).val() / 100)))
                                }
                                
                                

                            })

                            totaldis = dis;
                        }

                    }
                    else {
                        if (currIndex >= 0) {
                            if ($(this).val() > costCenterGroup[currIndex].TotalAmt || $(this).val() < 0) {
                                jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                $(this).val(0);
                            }

                        } else {
                            if ($(this).val() > tableinfo.TotalAmount || $(this).val() < 0) {
                                jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                $(this).val(0);
                            }

                        }
                        
                        var dis = 0


                        if (isab) {
                            if (isAbbreviated) {
                                var ttldis = parseFloat($(this).val() == "" ? 0 : $(this).val());
                                var ttl = 0.00;
                                if (cgGroup != undefined) {
                                     ttl = (cgGroup.TotalAmt == "") ? 0 : cgGroup.TotalAmt;
                                }

                                var Rttl = tableinfo.TotalAmount;
                                var disPercent = 0.00;
                                var RdisPercent = 0.00;
                                if (ttldis > 0) {
                                    disPercent = (ttldis * 100) / ttl;
                                    RdisPercent = (ttldis * 100) / Rttl;
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

                                if ($(this).attr('id') == 'txtRoomDiscount') {
                                    var Roomitemrow = $('.room-details-tbl').find('tbody').find('tr');
                                    if (Roomitemrow.length > 0) {
                                        $.each(Roomitemrow, function (index, value) {
                                            _this = $(this);
                                            var qty = parseFloat(_this.find('td').eq(2).text());
                                            var rate = _this.find('td').eq(1);
                                            var rateInt = parseFloat(rate.data('rate'));
                                            var disAbb = parseFloat((rateInt * (100 - RdisPercent) / 100) * (1 + v_rate / 100));
                                            rate.text(disAbb.toFixed(2))
                                            _this.find('td').eq(3).text((qty * disAbb).toFixed(2))
                                            totalAmountR += parseFloat(_this.find('td').eq(3).text());

                                            //console.log('Rate:' + rateInt + 'Amt:' + (qty * disAbb) + 'Total:' + totalAmountR)
                                        });
                                        // cgGroup.TotalDis = disRate;
                                        $('.roomtotle').text((totalAmountR).toFixed(2));
                                    }
                                };

                            }

                            $(".txt_dis").each(function () {
                                var keyIndex = parseFloat($(this).attr('id').split('_')[1]);
                                if (keyIndex >= 0) {
                                    dis += (parseFloat($(this).val()));
                                    //costCenterGroup[keyIndex].TotalDis = parseFloat($(this).val());
                                } else { //ROOM
                                    dis += (parseFloat($(this).val()));
                                }
                            })

                            totaldis = dis;


                        } else {
                            $(".txt_dis").each(function () {

                                var keyIndex = parseFloat($(this).attr('id').split('_')[1]);
                                if (keyIndex >= 0) {
                                    dis += (parseFloat($(this).val()));
                                    //costCenterGroup[keyIndex].TotalDis = parseFloat($(this).val());
                                } else { //ROOM
                                    dis += (parseFloat($(this).val()));
                                }
                            })
                            totaldis = dis;

                        }

                    }

                    if ($('.roomtotle').length > 0) {
                        totalAmount += parseFloat(tableinfo.TotalAmount);
                    }
                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
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
                    DashboardFunction.Checkbill(tableinfo.OrderMasterId, seatNo, parseInt(tableinfo.TableId));
                    //$('#hdnPinFor').val('generateBill');
                    //InitializePin();
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
                            salesMaster.PhoneNumber = $('#txtNumber').val();
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

            BindTakeAwaySalesBill: function (result, seatNo) {
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

                    totalAmount = 0.00;

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
                            //totalAmount = (totalAmount * (1 + v_rate / 100.0));
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

                disLimitBasicAmt = totalAmount;

                totaldis = 0;

                htmls += ("<tr>");
                htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option></select> </td>");
                htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable' style='width:50px;'/></td></tr>");

                $.each(costCenterGroup, function (index, item) {
                    htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>" + item.GroupName + " ( Rs. " + item.TotalAmt.toFixed(2) + " ) </td><td>";
                    htmls += "<input type='text' class='sfInputbox txtdiscount txt_dis' data-groupId='" + item.GroupId + "' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='index_" + index + "' value='" + 0 + "' /></td>";

                })

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
                htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr><tr><td>Customer : </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + tableinfo.CustomerName + '"/><input type="hidden" id="txtCusID" value="' + tableinfo.CustomerId + '" /></td></tr><tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox"/></td></tr><tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox"/></td></tr><tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                htmls += '</tbody></table></div><input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/></div></div>';

                htmls += ("</div></div></div></div>");
                htmls += ("<input id='Pay_" + tableinfo.TableId + "_" + tableinfo.OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
                var orderMasterId = tableinfo.OrderMasterId;
                $('#DialogOrderDetail').html(htmls);
                $('#txtPan').attr('autocomplete', 'off');

                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                $('#billnoForSales').val(seatNo);
                $('#DialogOrderDetail').dialog(
                    {
                        'title': 'Sales Bill',
                        width: DialogWidth,
                        modal: true,
                        dialogClass: 'CheckEnable unpaidd',
                        position: ['center', 'center']
                    });

                $("#tblDiscount").on('click', ".txtdiscount, .txtnum", function (event) {
                    InitializeNumPin(this, $(this).val());
                });


                $('#billnoForSales').on('change', function () {
                    DashboardFunction.BindSalesBill(result, parseInt($('#billnoForSales').val()));
                    seatNo = $('#billnoForSales').val();
                    sNo = seatNo;
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

                // $(".txtdiscount , .txtnum").on('click', function (event) {

                $('.customerForCash').on('change', function () {
                    if ($('.customerForCash').prop('checked') == true) {
                        membershipfor = "PaymentLoyalty";
                        DashboardFunction.GetCustomeronChange();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            position: ['center', 'center']
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
                            //cgGroup.TotalDis = disRate;
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
                

                var roles = userRole.split(',');
                if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                    $("#enablebtn").hide();
                }
                else {
                    $("#selDiscountType").prop('disabled', true);
                    $(".txtdiscount").prop('disabled', true);
                    $("#enablebtn").show();
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
                    cgGroup.TotalDis = parseFloat($(this).val());

                    if ($("#selDiscountType").val() == "1") {
                        if (($(this).val()) > 100 || ($(this).val()) < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $(this).val(0);
                        }

                        var disRate = parseFloat($(this).val() == "" ? 0 : $(this).val());
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
                                dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat($(this).val() / 100)));
                                //costCenterGroup[keyIndex].TotalDis = parseFloat($(this).val());
                            })

                            totaldis = dis;
                            //}
                        } else {
                            $(".txt_dis").each(function () {
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat($(this).val() / 100)));
                                //costCenterGroup[keyIndex].TotalDis = parseFloat($(this).val());
                            })

                            totaldis = dis;
                        }




                        //totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(roomAmount) * ($('#txtRoomDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    }
                    else {

                        if ($(this).val() > costCenterGroup[currIndex].TotalAmt || $(this).val() < 0) {
                            jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            $(this).val(0);
                        }

                        var dis = 0


                        if (isab) {
                            if (isAbbreviated) {
                                var ttldis = parseFloat($(this).val() == "" ? 0 : $(this).val());
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
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += parseFloat($(this).val());
                                //costCenterGroup[keyIndex].TotalDis = dis;
                            })

                            totaldis = dis;


                        } else {
                            $(".txt_dis").each(function () {
                                var keyIndex = $(this).attr('id').split('_')[1];
                                dis += parseFloat($(this).val());
                                //costCenterGroup[keyIndex].TotalDis = dis;
                            })

                            totaldis = dis;

                        }

                    }


                    DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);
                })


                $("#generateBill").on('click', function () {
                    DashboardFunction.Checkbill(tableinfo.OrderMasterId, seatNo, parseInt(tableinfo.TableId));
                    //$('#hdnPinFor').val('generateBill');
                    //InitializePin();
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
                            salesMaster.PhoneNumber = $('#txtNumber').val();
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
                var resAfterDis = 0.00;
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
                resAfterDis = (parseFloat(totalRestAmt) - parseFloat(totaldis)).toFixed();
                netAmount = 0.00;
                $.each(datas.billingTerm, function (index, item) {
                    if (item.BillTerm == 'Room Service') {
                        htmls += ("<tr>");
                        htmls += ("<td attr-term='" + item.BillTerm + "' attr-percent='" + item.Rate + "'  ><strong>" + item.BillTerm + " " + "(" + item.Rate + "%" + ")" + " : </strong>");
                        htmls += ("<input type=\"text\" id=\"BTerm_" + item.ID + "_" + item.IsAdd + "\" value=\"" + (item.IsAdd ? "" : "-") + "Rs. " + (resAfterDis * item.Rate / 100).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled  attr-amount='" + (resAfterDis * item.Rate / 100).toFixed(2) + "'/>");
                        htmls += ("</td>");
                        htmls += ("</tr>");
                        if (item.IsAdd == 1)
                            netAmount += parseFloat((resAfterDis * item.Rate / 100).toFixed(2));
                        else
                            netAmount -= parseFloat((resAfterDis * item.Rate / 100).toFixed(2));
                    } else {
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
                var vatTerm = datas.billingTerm.filter(x => x.ID == 54);
                
                if (datas.VATforBill) {
                    if (vatTerm[0].BillTerm == "VAT") {

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
                        

                        htmls += ("<td attr-term='VAT' attr-percent='13' ><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + vatTerm[0].ID + "_true" + "\"  value=\"Rs. " + vat + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + vat + "'/></td>");
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


            BindOccupiedTable: function () {

                var data = OccupiedTableList;
                var htmls = "";
                $('#OccupiedTablesdiv').html('');
                $("#OccTablesLength").text(data.length);
                htmls += ("<div class ='Tables'><table id='OccupiedTables' class='BookedTable-list-tbl'>");
                htmls += ("<thead><th>Room / Table</th><th>Check In</th><th>Amount</th><th>Action</th></thead><tbody>");
                if (data.length > 0) {
                    var sn = 1;
                    $.each(data, function (index, type) {
                        if (type.IsTable) {
                            var search = $('#txtSearch').val().toLowerCase();
                            if (type.restroRoom.toLowerCase().includes(search) || type.restrotableTitle.toLowerCase().includes(search) || type.MergeTableName.toLowerCase().includes(search) || search == '') {
                                htmls += ("<tr><td>");
                                htmls += type.restroRoom + " / ";
                                if (type.MergeTableList > 0) {
                                    htmls += (type.MergeTableName);
                                }
                                else {
                                    htmls += (type.restrotableTitle);
                                }

                                htmls += ("</td><td>" + type.tableDate + "</td><td> Rs. " + type.Amount + "</td><td style='width:315px;'><div class='ordering'>");
                                if (window.location.href != billAction) {
                                    htmls += ("<input id='Order_" + type.restrotableId + "_" + sn + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px;' />");

                                }
                                htmls += ("<input id='Pay_" + type.restrotableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                                var Roles = userRole.split(",");
                                if (Roles.includes("Cancel Order") || Roles.includes("Super User")) {
                                    htmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.restrotableId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                                }
                                htmls += ("<input id='shiftItems_" + type.OrderMasterId + "_" + type.restrotableId + "_" + type.GuestNo + "' type='button' class='sfBtn shiftItems restro-btn' value='Shift Items' style='padding:1px 4px; margin-left:10px;' />");
                                if (type.MergeTableList > 0) {
                                    htmls += ("<input id='Merge_" + type.restrotableId + "' type='button' class='sfBtn removeMerge restro-btn' value='UnMerge' style='padding:1px 4px; margin-left:10px;' />");
                                }
                                else {
                                    htmls += ("<input id='Shift_" + type.OrderMasterId + "_" + type.restrotableTitle + "_" + type.GuestNo + "_" + type.restrotableId + "' type='button' class='sfBtn shiftTable restro-btn' value='Shift' style='padding:1px 4px; margin-left:10px;' />");
                                }
                                //if (Roles.includes("Advance Bill") || Roles.includes("Super User")) {
                                //    htmls += ("<input id='Print_" + type.OrderMasterId + "_" + type.restrotableTitle + "' type='button' class='sfBtn print restro-btn' value='Print' style='padding:1px 4px; margin-left:10px;' />");
                                //}
                                htmls += ("</div></td></tr>");
                            }
                        }
                    });
                }

                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='6' style='text-align:center;'> No Data Available </td>";
                    htmls += '</tr>';
                }
                sn++;
                htmls += ("</tbody></table></div>");
                $('#OccupiedTablesdiv').html(htmls);

                //$('#OccupiedTables').dataTable({
                //	"bPaginate" : $('#OccupiedTables tbody tr').length>16,
                //	"iDisplayLength": 16,
                //    "ordering": false,
                //    "bLengthChange": false,
                //     "language": { search: "" ,  searchPlaceholder: "Search..."},

                //});
                $('div.dataTables_filter input').addClass('sfInputbox');
                $('#OccupiedTables').on('click', '.shiftTable', function () {
                    //$('#DialogOrderDetail').dialog('close');
                    DashboardFunction.config.ShiftOrderMasterID = $(this).attr('id').split("_")[1];
                    $('#shiftingTableName').html($(this).attr('id').split("_")[2]);
                    var seatNo = $(this).attr('id').split("_")[3];
                    fromtableId = $(this).attr('id').split('_')[4];
                    $('#shiftingTableSeatNo').html('<option value="0">ALL</option>');
                    for (var i = 1; i <= seatNo; i++) {
                        $('#shiftingTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
                    }
                    $(".imgroomtypeforshift").val("");
                    $(".imgRoomForShift").val("");
                    $(".TablesForShift").hide();
                    //$(".RoomsForShift").hide();
                    $('#divForRoomTableShift').dialog({
                        'title': 'Shift Table',
                        width: 675,
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
                $('#OccupiedTables').on('click', '.print', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForPrint(data[1]);
                });

            },

            BindComplimentaryOccupiedTables: function (data) {
                $('#ComplimentaryOrdersdiv').html('');
                if (data.length > 0) {
                    var sn = 1;
                    var complimentaryHtmls = '';
                    $("#complimentaryTab").show();
                    $("#ComplimentaryOrdersLength").text(data.length);
                    complimentaryHtmls += ("<div class ='orders'><table id='complimentaryTbl' class='BookedTable-list-tbl'>");
                    complimentaryHtmls += ("<thead><th>Room / Table</th><th>Check In</th><th>Amount</th><th>Action</th></thead><tbody>");

                    $.each(data, function (index, type) {
                        if (type.IsTable) {
                            var search = $('#txtSearch').val().toLowerCase();
                            if (type.restroRoom.toLowerCase().includes(search) || type.restrotableTitle.toLowerCase().includes(search) || type.MergeTableName.toLowerCase().includes(search) || search == '') {
                                complimentaryHtmls += ("<tr><td>");
                                complimentaryHtmls += type.restroRoom + " / ";
                                if (type.MergeTableList > 0) {
                                    complimentaryHtmls += (type.MergeTableName);
                                }
                                else {
                                    complimentaryHtmls += (type.restrotableTitle);
                                }

                                complimentaryHtmls += ("</td><td>" + type.tableDate + "</td><td> Rs. " + type.Amount + "</td><td style='width:315px;'><div class='ordering'>");
                                //if (window.location.href != billAction) {
                                //    complimentaryHtmls += ("<input id='Order_" + type.restrotableId + "_" + sn + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px;' />");

                                //}
                                complimentaryHtmls += ("<input id='Print_" + type.restrotableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn printrcpt restro-btn' value='Print Recpt' style='padding:1px 4px; margin-left:10px;'/>");

                                complimentaryHtmls += ("</div></td></tr>");
                            }
                        }
                    });

                } else {
                    complimentaryHtmls += "<tr>";
                    complimentaryHtmls += "<td colspan='6' style='text-align:center;'> No Data Available </td>";
                    complimentaryHtmls += '</tr>';
                }
                sn++;
                complimentaryHtmls += ("</tbody></table></div>");
                $('#ComplimentaryOrdersdiv').html(complimentaryHtmls);

                $('div.dataTables_filter input').addClass('sfInputbox');

                $('#ComplimentaryOrdersdiv').on('click', '.printrcpt', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    //DashboardFunction.GetDataForSalesBill(data[2]);
                    DashboardFunction.GetComplimentaryOrders(data[2]);
                });
            },

            BindTakeAwayOrders: function (data) {
                $('#TakeAwayOrdersdiv').html('');
                if (data.length > 0) {
                    var takeAwayHtmls = '';
                    $("#takeTab").show();
                    $("#TakeAwayOrdersLength").text(data.length);
                    takeAwayHtmls += ("<div class ='orders'><table id='takeAwayTbl' class='BookedTable-list-tbl'>");
                    takeAwayHtmls += ("<thead><th>Order No</th><th>Order ID</th><th>Date Time</th><th>Amount</th><th>Action</th></thead><tbody>");
                    $.each(data, function (index, type) {
                        if (!type.IsTable) {
                            takeAwayHtmls += ("<tr><td>Order No : " + type.OrderNo + "</td>");
                            takeAwayHtmls += ("<td>" + type.OrderMasterId + "</td>");
                            takeAwayHtmls += ("<td>" + type.tableDate + "</td><td> Rs. " + type.Amount + "</td><td style='width:315px;'><div class='ordering'>");
                            if (window.location.href != billAction) {
                                takeAwayHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
                            }
                            takeAwayHtmls += ("<input id='Pay_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                            takeAwayHtmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                            takeAwayHtmls += ("</div></td></tr>");
                        }
                    });
                    takeAwayHtmls += ("</tbody></table></div>");

                    $('#TakeAwayOrdersdiv').html(takeAwayHtmls);

                    $('#takeAwayTbl').on('click', '.cancelorder', function () {
                        OrderMasterID = $(this).attr('id').split("_")[1];
                        CancelTableID = 0;
                        fromtableId = 0;
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
                    $('#takeAwayTbl').on('click', '.ordernow', function () {

                        var id = $(this).attr('id');
                        var data = id.split('_');
                        var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(data[1]);
                        window.location.href = url;
                    });
                    $('#takeAwayTbl').on('click', '.paynow', function () {
                        var id = $(this).attr('id');
                        var data = id.split('_');
                        // DashboardFunction.GetDataForSalesBill(data[1]);
                        DashboardFunction.GetDataForTakeAwaySalesBill(data[1]);
                    });
                }
            },

            BindOccupiedRoom: function () {
                var data = OccupiedRoomList;
                $('#OccupiedRoomsdiv').html('');
                if (data.length > 0) {
                    var roomHtmls = "";
                    $("#OccTab").show();
                    $("#OccRoomsLength").text(data.length);
                    roomHtmls += ("<div class ='Rooms'><table id='OccupiedRooms' class='BookedTable-list-tbl'>");
                    roomHtmls += ("<thead><th>Room</th><th>Customer</th><th>Booked On</th><th>Booked To</th><th>Amount</th><th>Action</th></thead><tbody>");
                    $.each(data, function (index, type) {
                        if (!type.IsTable) {
                            var search = $('#txtSearch').val().toLowerCase();
                            if (type.RestroRoom.toLowerCase().includes(search) || type.restrotableTitle.toLowerCase().includes(search) || type.CustomerName.toLowerCase().includes(search) || search == '') {
                                roomHtmls += ("<tr><td>" + type.RestroRoom + " / " + type.restrotableTitle);
                                roomHtmls += ("</td><td>" + type.CustomerName + "</td>");
                                roomHtmls += ("</td><td>" + type.BookedFrom + "</td>");
                                roomHtmls += ("<td>" + type.BookedTo + "</td><td> Rs. " + type.TotalAmount + "</td><td style='width:315px;'><div class='ordering'>");
                                if (window.location.href != billAction) {
                                    roomHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
                                    roomHtmls += ("<input id='Booking_" + type.OrderMasterId + "' type='button' class='sfBtn editBooking restro-btn' value='Edit' style='padding:1px 4px; margin-left:10px;' />");
                                }
                                //roomHtmls += ("<input id='shiftItems_" + type.OrderMasterId + "_" + type.TableId + "_" + type.GuestNo + "' type='button' class='sfBtn shiftItems restro-btn' value='Shift Items' style='padding:1px 4px; margin-left:10px;' />");
                                //roomHtmls += ("<input id='Shift_" + type.OrderMasterId + "_" + type.restrotableTitle + "_" + type.GuestNo + "' type='button' class='sfBtn shiftTable restro-btn' value='Shift' style='padding:1px 4px; margin-left:10px;' />");
                                roomHtmls += ("<input id='Pay_" + type.TableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                                //var Roles = userRole.split(",");                
                                //if (Roles.includes("Cancel Order") || Roles.includes("Super User")) {
                                roomHtmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.TableId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                                // }
                                roomHtmls += ("</div></td></tr>");
                            }
                        }
                    });
                    roomHtmls += ("</tbody></table></div>");

                    $('#OccupiedRoomsdiv').html(roomHtmls);

                    //$('#OccupiedRooms').dataTable({
                    //    "bPaginate": $('OccupiedRooms tbody tr').length > 12,
                    //    "iDisplayLength": 12,
                    //    ordering: false,
                    //    "bLengthChange": false,
                    //    "language": { search: "", searchPlaceholder: "Search..." },
                    //});
                    $('div.dataTables_filter input').addClass('sfInputbox');
                    $('#OccupiedRooms').on('click', '.shiftTable', function () {
                        //$('#DialogOrderDetail').dialog('close');
                        DashboardFunction.config.ShiftOrderMasterID = $(this).attr('id').split("_")[1];
                        $('#shiftingTableName').html($(this).attr('id').split("_")[2]);
                        var seatNo = $(this).attr('id').split("_")[3];
                        $('#shiftingTableSeatNo').html('<option value="0">ALL</option>');
                        for (var i = 1; i <= seatNo; i++) {
                            $('#shiftingTableSeatNo').append('<option value="' + i + '">' + i + '</option>');
                        }
                        fromtableId = $(this).attr('id').split('_')[4];
                        $(".imgroomtypeforshift").val("");
                        $(".imgRoomForShift").val("");
                        $(".TablesForShift").hide();
                        //$(".RoomsForShift").hide();
                        pinfor = "shift";
                        $('#divForRoomTableShift').dialog({
                            'title': 'Shift Table',
                            width: 675,
                            height: 'auto',
                            modal: true,
                        });
                    });

                    $('#OccupiedRooms').on('click', '.cancelorder', function () {
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
                            if (window.location.href != billAction) {
                                if (type.BookedFrom > new Date()) {
                                    roomHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
                                }
                                roomHtmls += ("<input id='Booking_" + type.OrderMasterId + "' type='button' class='sfBtn editBooking restro-btn' value='Edit' style='padding:1px 4px; margin-left:10px;' />");
                            }
                            //roomHtmls += ("<input id='Pay_" + type.TableId + "_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                            roomHtmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.TableId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                            roomHtmls += ("</div></td></tr>");
                        }
                    });
                    roomHtmls += ("</tbody></table></div>");

                    $('#BookedRoomsdiv').html(roomHtmls);

                    //$('#BookedRooms').dataTable({
                    //    "bPaginate": $('OccupiedRooms tbody tr').length > 10,
                    //   "iDisplayLength": 12,
                    //    ordering: false,
                    //    "bLengthChange": false,
                    //    "language": { search: "" ,  searchPlaceholder: "Search..."},
                    //});
                    $('#BookedRooms').on('click', '.cancelorder', function () {
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
                    $('#BookedRooms').on('click', '.ordernow', function () {

                        var id = $(this).attr('id');
                        var data = id.split('_');
                        var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(data[1]);
                        window.location.href = url;
                    });
                    $('#BookedRooms').on('click', '.paynow', function () {
                        //alert('shree');
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
                        width: '860px',
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
                $('#txtRemarks').val(roomBooking.Remarks);
                $('.btnBook').attr('id', 'Book_' + roomBooking.RoomBookDetailsID);
                $('.btnCancelBook').attr('id', 'No_' + roomBooking.RoomBookDetailsID);
                $('#Membercheckbox').off().on('change', function () {
                    if ($('#Membercheckbox').prop('checked') == true) {
                        membershipfor = "RoomBooking";
                        DashboardFunction.GetCustomeronChange();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            position: ['center', 'center'],

                        });
                    } else {
                        $('#MemberID').val(0);
                    }
                })
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


                var roles = userRole.split(',');

                if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                    $("#selDiscountType").val(3);
                    $("#selDiscountType").change();
                }
                else {
                }

            },

            Reset: function () {
                $(".ui-dialog-content").dialog("close");
                $('#TablesInRooms').hide();
                $("#PINbox").val('');
            },
        };
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);


function SaveAcc() {
    isButtonClicked = false;
    var billingTerm = new Array();
    var salesMaster = new Object();
    var splited = 0;
    var salesDetail = new Array();

    salesMaster.billNo = '1234';
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
    salesMaster.SeatNo = sNo;
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

    $.each(orddetail, function (index, value) {
        if (value.SeatNo == sNo) {
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
    var salesPayment = {};
    //alert(JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount }));
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebservice.asmx/SaveSales",
        data: JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount, payment: salesPayment, isFoodCourt: false }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $('#DialogOrderDetail').dialog('close');
            getBill(data.d, false);
            $('#BillingView').dialog({
                'title': 'Vat Bill',
                width: '350',
                height: 'auto',
                modal: true,
                position: ['center', 'top']
            });
            print();
            //$('#printno').show();
            $('#InvoiceType').html('INVOICE');
            print();
            //$('#btnPrints').click();

            $('#BillingView').dialog('close');
            jAlert('Bill Successfully Generated.', 'Information', function () {
                parent.$.colorbox.close();
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
    //}
}
