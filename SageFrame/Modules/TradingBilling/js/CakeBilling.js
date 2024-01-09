var baseUrl = SageFrameHostURL + "/Modules/TradingBilling/services/CakeBillingWebService.asmx/";
var isButtonClicked = false;
var orddetail = null;
var orderdetails = null;
var foodCourtOrder = true;
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
var checks = [];
var bakeryAmount = 0.00;
var bakerydis = 0.00;
var pizzaAmount = 0.00;
var pizzadis = 0.00;
var DialogWidth = '900';
var noOfGuest = 1;
var sNo = 0;
var username = "";
var discountAmount = 0.00;
var netAmount = 0.00;
var taxableAmount = 0.00;



function GetBillingCustomeronCheck() {
    var customer = 1;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetCustomerDatas",
        data: JSON2.stringify({ customer: customer }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            debugger;
            $("#membeshipformlist").show();
            $("#membeshipformlist").html('');
            var datas = JSON.parse(data.d);
            if (datas.length > 0) {
                var htmls = "<table id='customertable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Name </th><th>PAN</th><th> Address </th><th> ContactNo.</th><th> Discount(%) </th><th>Paid</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"

                $.each(datas, function (index, value) {

                    htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "'>";
                    htmls += "<td>" + value.Name + "</td>";
                    htmls += "<td>" + value.PAN + "</td>";
                    htmls += "<td>" + value.Addresss + "</td>";
                    // htmls += "<td>" + value.Occupation + "</td>";
                    // htmls += "<td>" + value.Company + "</td>";
                    htmls += "<td>" + value.TelMobile + "</td>";
                    htmls += "<td>" + value.discount + "</td>";
                    htmls += "<td>" + "<img src='/images/completed.png' class='selectCust' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                    htmls += "</tr>"
                    checks.push(value.CardNumber);
                });
                htmls += "</tbody>";
                htmls += "</table>";
                $('#membeshipformlist').html(htmls);
                $('#customertable').DataTable(
                    {
                        //"scrollY": false,
                        //"scrollCollapse": false,
                        "jQueryUI": true,
                        // "scrollX" : true,

                    });

                $("#membeshipformlist").dialog({
                    'title': 'Customer',
                    width: 800,
                    modal: true,
                    resizable: true,
                    position: ['center', 'center']
                });


            } else {
                $('#membeshipformlist').html('No data');

            }
            $(".dataTables_scrollBody").css('height', '100%');

            //  $("#membeshipformlist").on('click', '.selectCust', function (event) {
            $("#membeshipformlist").on('click', '#customertable tr', function (event) {
                var deletedata = $(this).attr('id');
                var ids = deletedata.split('_');
                $('#CustomerID').text(ids[1]);
                $('#loyalityDiscount').text(ids[6]);
                $("#txtCustName").val(ids[2] + " " + ids[3]);
                $("#txtNumber").val(ids[7]);
                $("#txtAddress").val(ids[5]);

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

            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
};

//Date and time conversion function here
function formatDate(dateVal) {
    var newDate = new Date(dateVal);

    var sMonth = padValue(newDate.getMonth() + 1);
    var sDay = padValue(newDate.getDate());
    var sYear = newDate.getFullYear();
    var sHour = newDate.getHours();
    var sMinute = padValue(newDate.getMinutes());
    var sAMPM = "AM";

    var iHourCheck = parseInt(sHour);

    if (iHourCheck > 12) {
        sAMPM = "PM";
        sHour = iHourCheck - 12;
    }
    else if (iHourCheck === 0) {
        sHour = "12";
    }

    sHour = padValue(sHour);

    return sMonth + "-" + sDay + "-" + sYear + " " + sHour + ":" + sMinute + " " + sAMPM;
}

function padValue(value) {
    return (value < 10) ? "0" + value : value;
}
//date and time conversion end

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

function savePrintCount(printcount, billNo, printedBy, salesType) {

    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "savePrintCount",
        data: JSON2.stringify({ Printcount: printcount, BillNo: billNo, PrintedBy: printedBy, SalesType: salesType }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            //$('#printno').show();
            Print();
            $('#BillingView').dialog('close');
            jAlert("Bill successfully Generated", "Information!!", function () {
                if (foodCourtOrder) {
                    $('.bindorderlist').html('');
                    Reset();
                } else {
                    parent.$.colorbox.close();
                }
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
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
                ModulePath: '/Modules/TradingBilling/',
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
        var billAction = p.HostUrl + "/Trading-Billing.aspx?action=bill"
        var DashboardFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 
                dataType: 'json',
                baseURL: p.ModulePath + "services/CakeBillingWebService.asmx/",
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
                DashboardFunction.GetOccupiedTables('wholesale');
                DashboardFunction.GetTakeAwayOrders('retail');
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


            },
            init: function () {
                DashboardFunction.InitialSetup();
                $('#txtSearch').on('keyup', function () {
                    DashboardFunction.BindOccupiedRoom();
                    DashboardFunction.BindOccupiedTable();
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
                            //$('#splitNoCancel').val(1);
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
                        //DashboardFunction.Checkbill(OrderMasterID, parseInt($('#splitNoCancel').val() == null ? 0 : $('#splitNoCancel').val()), fromtableId);
                        DashboardFunction.CancelOrderedData();
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

                        //var roles = userRole.split(',');

                        //if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                        //    $("#selDiscountType").val(3);
                        //    $("#selDiscountType").change();
                        //}
                        //else {
                        //}

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
                        DashboardFunction.GetOccupiedTables('cake');
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
                //$("#selDiscountType").val(3);
                //$("#selDiscountType").change();
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
            GetOccupiedTables: function (lookupName) {

                DashboardFunction.config.method = "GetWholesaleOrders";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ lookupName: lookupName });
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
            GetTakeAwayOrders: function (lookupName) {
                DashboardFunction.config.method = "GetWholesaleOrders";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ lookupName: lookupName });
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
            GetDataForSalesBill: function (orderMasterId, salesType) {
                DashboardFunction.config.method = "GetDataForSalesBill";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ orderMasterId: orderMasterId, SalesType: salesType });
                DashboardFunction.config.ajaxCallMode = 56;
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
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName, SalesType: 'cake'
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
                //ordermaster.TableId = CancelTableID,
                ordermaster.OrderMasterID = OrderMasterID,
                    //ordermaster.GuestNo = parseInt($('#splitNoCancel').val() == null ? 1 : $('#splitNoCancel').val());
                    ordermaster.CancelReason = $("#canceltextarea").val();
                //ordermaster.CancelBy = $('#hdnPinBy').val();
                //ordermaster.UserName = $('#hdnPinBy').val();
                //ordermaster.IsCancelled = true,
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

            BindSalesBill: function (result, seatNo) {
                isButtonClicked = true;
                var datas = JSON.parse(result.d);
                orderdetails = datas.CakeOrderList;
                billingterms = datas.billingTerm;
                var htmls = "";
                var date = "";
                $('#DialogOrderDetail').html("");
                totalAmount = 0.00;

                var DialogWidth = '900';
                htmls += "<div id='dialogOrderOpen'>";
                htmls += ("<div class='dashboardmain'>");
                if (orderdetails.length > 0) {
                    htmls += ("<div class='left-sec'><h4>Trading Bill Details</h4>");
                    htmls += ("<h5>Ordered Items Details</h5>");
                    htmls += ("<div class='item_list_div'><table class='item-list-tbl'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody>");

                    var sn = 1;
                    $.each(orderdetails, function (index, value) {
                        htmls += ("<tr class='allsplited'><td>" + sn + "</td><td class=''>" + value.ItemName + "</td>");
                        htmls += ("<td>" + value.Quantity + "</td>");
                        htmls += ("<td class='item-rate'>" + value.Rate + "</td>");
                        amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                        totalAmount += parseFloat(amt);
                        htmls += ("<td class='item-amount'>" + amt + "</td></tr>");

                        sn++;
                    });
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='4'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='totle'>Rs. " + totalAmount + "</span></td></tr>");
                    htmls += ("</tfoot></table></div>");
                } else {
                    htmls += ("<div class='left-sec'><h4>Take Away </h4>");
                }

                htmls += ("<h4>Discount Method</h4><div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'><div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");
                totaldis = 0;
                htmls += ("<tr>");
                htmls += ("<td>Discount Type</td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option></select></td>");
                htmls += ("<td> <input id='txtDiscount' type='text' onkeypress='return validateFloatKeyPress(this,event)' placeholder='0'  class='sfInputbox txtdiscount' style='width:100px;'/></td></tr>");
                htmls += ("</tbody></table></div>");
                htmls += '<div id="divBillingTerm"></div></div></div>';
                //if (datas.CakeOrderList[0].DeliveryTime != null) {
                //    date = new Date(Number(datas.CakeOrderList[0].DeliveryTime.split("(")[1].split(")")[0])).format("yyyy-MM-dd hh:mm tt");
                //} else {
                //    date = new Date().toISOString().slice(0, 10);
                //}

                htmls += '<div class="right-sec"><div class="right-secA"><h4>Customer Info</h4><table><tbody>';
                htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" ' + (parseInt(datas.CakeOrderList[0].CustomerId) > 0 ? "checked" : "") + ' /></div></td></tr>'
                htmls += '<tr><td>Customer Name: </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + datas.CakeOrderList[0].CustomerName + '"/><input type="hidden" id="txtCusID" value="" /></td></tr>';
                htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox" value="' + datas.CakeOrderList[0].Phone + '"/></tr>';
                htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox" value="' + datas.CakeOrderList[0].Address + '"/></td></tr>';
                //htmls += '<tr><td>Delivery Time : </td><td><input type="text" id="txtDeliveryTime" class="sfInputbox" value="' + date + '"/></td></tr>';
                htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
                htmls += '</tbody></table></div>';

                if (foodCourtOrder) {
                    htmls += '<div class="right-secB">';
                    htmls += '<table runat="server" clientidmode="static" id="payBill"><tr>';

                    htmls += '<td class="clsSurpDefct"><span style="font-weight:bold;font-size:15px;">Sur/Def</span> : </td>';
                    htmls += '<td class="clsSurpDefct"><span style="font-weight:boldfont-size:15px;lable width="50px" id="lblSurpDefct">0</lable></span></td></tr><tr>';

                    htmls += '<td>Change Pay Mode<span style="color:red;">*</span> : </td>';
                    htmls += '<td><select id="selPayMode" name="Paymode" class="sfInputbox">';
                    htmls += '<option selected value="1">CASH</option>';
                    htmls += '<option value="3">SWIPE</option>';
                    htmls += '<option value="2">CHEQUE</option>';
                    htmls += '<option value="4">Credit</option>';
                    htmls += '<option value="5">ESewa</option>';
                    htmls += '<option value="6">Fonepay</option>';
                    htmls += '</select></td></tr>';
                    htmls += '<tr class="cashpay"><td>Total Amount :</td>';
                    htmls += '<td><input type="text" class="txtnum sfInputbox" disabled id="txtTotalCalc" /></td></tr>';

                    //htmls += '<tr class="cashpay"><td>Advance Amount :</td>';
                    //htmls += '<td><input type="text" class="txtnum sfInputbox" disabled id="txtAdvance Amount" value="' + datas.CakeOrderList[0].AdvanceAmount + '"/></td></tr>';

                    htmls += '<tr class="cashpay"><td>Tender Amount :</td>';
                    htmls += '<td><input type="text" class="txtnum sfInputbox" onkeypress="return validateFloatKeyPress(this,event)" onkeyup="return calculateSurpDefct(1)" placeholder="0" id="txtTenderAmount" /></td></tr>';
                    htmls += '<tr class="cashpay"><td>Return Amount :</td>';
                    htmls += '<td><input type="text" class="txtnum sfInputbox"  onkeypress="return validateFloatKeyPress(this,event)" onkeyup="return calculateSurpDefct(2)" placeholder="0" id="txtReturnAmount" /></td>';
                    htmls += '</tr><tr id="prov" clientidmode="static" style="display:none;">';
                    htmls += '<td>Provider : </td>';
                    htmls += '<td><select class="sfInputbox" id="selProv"></select></td>';
                    htmls += '</tr><tr id="cheq" clientidmode="static" style="display:none;">';
                    htmls += '<td>Cheque No<span style="color:red;">*</span> : </td>';
                    htmls += '<td><input type="text" name="Cheque" id="txtCheqNo" class="sfInputbox" /></td>';
                    htmls += ' </tr><tr id="trans" clientidmode="static" style="display:none;">';
                    htmls += '<td>Transaction No<span style="color:red;">*</span> : </td>';
                    htmls += '<td><input type="text" name="Transaction" id="txtTransNo" class="sfInputbox" /></td>';
                    htmls += '<tr class="cashpay"><td>Remarks :</td>';
                    htmls += '<td><textarea class="sfInputbox txtRemarks"></textarea></td></tr>';
                    htmls += '</tr></table></div>';
                }
                htmls += '<input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/></div></div>';

                var orderMasterId = orderdetails[0].OrderMasterId;
                $('#DialogOrderDetail').html(htmls);
                DashboardFunction.BindBillingTerm(totalAmount, totaldis, datas);

                $("#txtDiscount").on('keyup', function () {
                    CalculateForDiscount();
                });
                $("#selDiscountType").on('change', function () {
                    CalculateForDiscount();
                });

                function CalculateForDiscount() {

                    if ($("#selDiscountType option:selected").text().toLowerCase() == 'flat') {
                        discountAmount = parseFloat($("#txtDiscount").val()).toFixed(2);
                    }
                    else if ($("#selDiscountType option:selected").text().toLowerCase() == 'percent') {
                        discountAmount = (parseFloat($("#txtDiscount").val()).toFixed(2)) / 100 * totalAmount;
                    }
                    if (isNaN(discountAmount)) {
                        discountAmount = 0.00;
                    }
                    if (discountAmount > totalAmount) {
                        jAlert("Discount Amount Too Big");
                        discountAmount = 0.00;
                        $('#txtDiscount').val('');
                    }
                    //$('.totalDiscount').val('Rs ' + discountAmount);
                    //$('#txtTaxableAmt').val('Rs ' + parseFloat(totalAmount - discountAmount).toFixed(2));
                    //$('#BTerm_54_true').val('Rs ' +parseFloat(datas.billingTerm[0].Rate / 100 * (totalAmount - discountAmount)).toFixed(2));
                    //$('#txtNetAmt').val('Rs' + parseFloat(((totalAmount - discountAmount) + datas.billingTerm[0].Rate / 100 * (totalAmount - discountAmount))).toFixed(2));

                    $("#lblSurpDefct").text(0.00);
                    $(".clsSurpDefct").css('color', 'black');

                    DashboardFunction.BindBillingTerm(totalAmount, discountAmount, datas)
                }


                $(".txtdiscount").on('click', function (event) {
                    InitializeNumPin(this, $(this).val());
                });

                $(".txtnum").on('click', function (event) {
                    InitializeNumPin(this, $(this).val());
                });

                $('#DialogOrderDetail').dialog(
                    {
                        'title': 'Sales Bill',
                        width: DialogWidth,
                        modal: true,
                        dialogClass: 'CheckEnable unpaidd',
                        position: ['center', 'center']
                    });

                //if (tokeninfo.length > 0) {
                //    if (tokeninfo[0].CustomerID > 0) {
                //        GetmembershiplistbyId(tokeninfo[0].CustomerID);
                //    }
                //}

                if (foodCourtOrder) {
                    getProviderList();
                    $("#selPayMode").on('change', function () {

                        CalculateForDiscount();
                        if ($("#selPayMode").val() == 1) {
                            $(".cashpay").show();
                            $("#prov").hide();
                            $("#trans").hide();
                            $("#cheq").hide();
                        }
                        else if ($("#selPayMode").val() == 2) {
                            $(".cashpay").hide();
                            $("#prov").show();
                            $("#trans").hide();
                            $("#cheq").show();
                        }
                        else if ($("#selPayMode").val() == 3) {
                            $(".cashpay").hide();
                            $("#prov").show();
                            $("#trans").show();
                            $("#cheq").hide();
                        }
                        else if ($("#selPayMode").val() == 5) {
                            $(".cashpay").hide();
                            $("#prov").show();
                            $("#trans").show();
                            $("#cheq").hide();
                        }
                        else if ($("#selPayMode").val() == 6) {
                            $(".cashpay").hide();
                            $("#prov").show();
                            $("#trans").show();
                            $("#cheq").hide();
                        }
                        else if ($("#selPayMode").val() == 4) {
                            if ($('.customerForCash').prop('checked') == true) {
                                $(".cashpay").hide();
                                $("#prov").hide();
                                $("#trans").hide();
                                $("#cheq").hide();
                                membershipfor = "payment";
                                //debugger;
                                //if (custid > 0)
                                //    dashboardfunction.deleteitem(custid);
                                //else
                                //    dashboardfunction.getcustomeronchange();
                                $("#cashpaid").hide();
                            } else {
                                jAlert("Please Select Customer First !!!", "Error!!");
                            }
                            
                        }
                    });
                    $("#txtTenderAmount, #txtReturnAmount").on('click', function () {
                        $(this).val('');
                    });
                    $("#txtTotalCalc, #txtTenderAmount").on("keydown keyup change", function () {
                        var returnAmnt = (Number($("#txtTenderAmount").val()) - (Number($("#txtTotalCalc").val()) - (datas.CakeOrderList[0].AdvanceAmount))).toFixed(2);
                        $("#txtReturnAmount").val((parseFloat(returnAmnt) > 0 ? parseFloat(returnAmnt) : 0));
                    });
                }

                $("#txtCardNumber").on('change', function () {
                    var info = $("#txtCardNumber").val();
                    if (info != "") {
                        getMemberDetailsbyinfo(info);
                    }
                });

                $("#txtNumber").on('change', function () {
                    var info = $("#txtNumber").val();
                    if (info != "") {
                        getMemberDetailsbyinfo(info);
                    }
                });

                $('.customerForCash').on('change', function () {
                    if ($('.customerForCash').prop('checked') == true) {
                        GetBillingCustomeronCheck();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            resizable: true,
                            position: ['center', 'center']
                        });
                    } else {
                        $('#txtCusID').val(0);

                        $("#txtCashCusName").val("");
                        $("#txtCusAddress").val();
                        $("#txtPan").val("");
                        $('#txtNumber').val("");
                        $("#txtCashCusName").prop('disabled', false);
                        $("#txtCusAddress").prop('disabled', false);
                        $("#txtPan").prop('disabled', false);

                        $("#selDiscountType").val(1);
                        $("#txtLoyaltyDiscount").val(0);

                    }
                })

                $("#txtLoyaltyDiscount").on('change', function () {
                    $('#txtKotDiscount').val(0);
                    $('#txtBarDiscount').val(0);
                    $('#txtBakeryDiscount').val(0);
                    $('#txtPizzaDiscount').val(0);
                    totaldis += (totalAmount * (parseFloat($("#txtLoyaltyDiscount").val()) / 100));
                    BindBillingTerm((totalAmount - roomAmount), totaldis, datas);
                })
                $('#txtKotDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtKotDiscount').val() > 100 || $('#txtKotDiscount').val() < 0) {
                            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtKotDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtKotDiscount').val() > kotAmount || $('#txtKotDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtKotDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    BindBillingTerm(totalAmount, totaldis, datas);
                });

                $('#txtBarDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtBarDiscount').val() > 100 || $('#txtBarDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtBarDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtBarDiscount').val() > barAmount || $('#txtBarDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtBarDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    BindBillingTerm(totalAmount, totaldis, datas);
                });
                $('#txtBakeryDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtBakeryDiscount').val() > 100 || $('#txtBakeryDiscount').val() < 0) {
                            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtBakeryDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtBakeryDiscount').val() > bakeryAmount || $('#txtBakeryDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtBakeryDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    BindBillingTerm(totalAmount, totaldis, datas);
                });

                $('#txtPizzaDiscount').on('keyup', function (event) {
                    if ($("#selDiscountType").val() == "1") {
                        if ($('#txtPizzaDiscount').val() > 100 || $('#txtPizzaDiscount').val() < 0) {
                            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtPizzaDiscount').val(0);
                        }
                        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
                    } else {
                        if ($('#txtPizzaDiscount').val() > pizzaAmount || $('#txtPizzaDiscount').val() < 0) {
                            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
                            $('#txtPizzaDiscount').val(0);
                        }
                        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
                    }
                    BindBillingTerm(totalAmount, totaldis, datas);
                });



                $("#generateBill").on('click', function () {
                    if (foodCourtOrder) {
                        //$('.paynows').click();
                        DashboardFunction.CakeOrderPayBill();
                    } else {
                        $('#hdnPinFor').val('generateBill');
                        InitializePin();
                    }
                });

                //$('#enablebtn').on('click', function () {
                //    $('#hdnPinFor').val('enablebtn');
                //    InitializePin();
                //});
                $('.paynows').unbind('click').on('click', function () {
                    var billingTerm = new Array();
                    var salesMaster = new Object();
                    var splited = 0;
                    var salesDetail = new Array();

                    salesMaster.billNo = orderdetails[0].BillNo;
                    salesMaster.BillDate = new Intl.DateTimeFormat('en-US').format(new Date());
                    salesMaster.NepaliInvoiceDate = formatDate();
                    salesMaster.BasicAmount = (parseFloat($('.totalAfterDisc').val().split(' ')[1]));
                    salesMaster.RoomId = 0;
                    salesMaster.TableId = parseInt(0);
                    salesMaster.OrderMasterId = orderdetails[0].OrderMasterId;
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
                    salesMaster.Waiter = orderdetails[0].Waiter;
                    salesMaster.SPMID = 0;
                    salesMaster.IsSplit = 0;
                    salesMaster.SeatNo = 1;
                    salesMaster.AddedBy = $('#hdnPinBy').val();;
                    salesMaster.RoomRate = 0;
                    salesMaster.BookedDays = 0;
                    salesMaster.RoomCharge = 0;
                    salesMaster.AdvancePayment = 0;
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
                    });

                    var discount = new Object();
                    discount.orderMasterId = orderdetails[0].OrderMasterId;
                    discount.kotdis = $('#txtKotDiscount').val();
                    discount.bardis = $('#txtBarDiscount').val();
                    discount.roomdis = 0;
                    discount.isflatdis = ($('#selDiscountType').val() == "2" ? true : false);
                    discount.isLoyalty = ($('#selDiscountType').val() == "3" ? true : false);
                    discount.loyaltydis = $('#txtLoyaltyDiscount').val();
                    discount.bakerydis = $('#txtBakeryDiscount').val();
                    discount.pizzadis = $('#txtPizzaDiscount').val();
                    if (foodCourtOrder) {
                        var salesPayment = {};

                        salesPayment.SPMID = $('#selPayMode').val();
                        salesPayment.ChequeNo = ($('#selPayMode').val() == 2 ? $('#txtCheqNo').val() : "");
                        salesPayment.TransactionNo = ($('#selPayMode').val() == 3 ? $('#txtTransNo').val() : "");
                        salesPayment.ProviderID = (($('#selPayMode').val() == 3 || $('#selPayMode').val() == 2) ? $('#selProv').val() : "");
                        salesPayment.TenderAmount = ($('#selPayMode').val() == 1 ? (parseFloat($('#txtTenderAmount').val()) == "" ? 0 : $('#txtTenderAmount').val()) : 0);
                        salesPayment.ReturnAmount = ($('#selPayMode').val() == 1 ? (parseFloat($('#txtReturnAmount').val()) == "" ? 0 : $('#txtReturnAmount').val()) : 0);
                        salesPayment.PayAmount = ($('#selPayMode').val() == 1 ? parseFloat($('#txtTenderAmount').val() - $('#txtReturnAmount').val()) : $('#txtNetAmt').val().split(' ')[1]);

                        salesPayment.CusID = '';
                        salesPayment.Customer = '';
                        salesPayment.Address = '';
                        salesPayment.PAN = '';
                        salesPayment.Remarks = $('.txtRemarks').val();
                        if (foodCourtAutoBillGenerate) {
                            SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPayment)
                        } else {
                            jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                                if (confirmed) {
                                    SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPayment)
                                }
                            });
                        }
                    } else {
                        jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                            if (confirmed) {
                                SaveSalesBill(salesMaster, salesDetail, splited, billingTerm, discount)
                            }
                        });
                    }
                });
            },
            

            CakeOrderPayBill: function () {
                var billingTerm = new Array();
                var salesMaster = new Object();
                var splited = 0;
                var salesDetail = new Array();
                salesMaster.CustomerId = ($('#txtCusID').val() == "" ? 0 : parseInt($('#txtCusID').val()));
                salesMaster.CustomerName = orderdetails[0].CustomerName;
                salesMaster.ContactNumber = orderdetails[0].Phone;
                salesMaster.PAN = orderdetails[0].PAN;
                salesMaster.Address = orderdetails[0].Address;
                //salesMaster.BasicAmount = $('#txtTaxableAmt').val().split(' ')[1];
                salesMaster.BasicAmount = parseFloat(netAmount).toFixed(2);
                salesMaster.TermAmount = 0.00;
                salesMaster.NetAmount = $('#txtNetAmt').val().split(' ')[1];
                salesMaster.AdvancePayment = orderdetails[0].AdvanceAmount;
                salesMaster.Reasons = '';
                salesMaster.NepaliInvoiceDate = formatDate();
                salesMaster.AddedBy = $('#hdnPinBy').val();
                //salesMaster.SalesType = 'cake';
                salesMaster.SalesType = orderdetails[0].SalesType;
                salesMaster.TenderAmount = $('#txtTenderAmount').val().split(' ')[1];
                salesMaster.ReturnAmount = $('#txtReturnAmount').val().split(' ')[1];
                salesMaster.billNo = orderdetails[0].BillNo;
                salesMaster.BillDate = new Intl.DateTimeFormat('en-US').format(new Date());
                salesMaster.OrderMasterId = orderdetails[0].OrderMasterId;
                salesMaster.NetAmount = $('#txtNetAmt').val().split(' ')[1];
                if (orderdetails[0].DeliveryTime != null) {
                    salesMaster.DeliveryTime = new Date(Number(orderdetails[0].DeliveryTime.split('(')[1].split(')')[0]));
                } else {
                    salesMaster.DeliveryTime = new Date().toISOString().slice(0, 10);
                }


                $.each(billingterms, function (index, value) {
                    if (document.getElementById('BTerm_' + value.ID + '_' + value.IsAdd) != null) {
                        var bt = {
                            ID: value.ID,
                            Rate: value.Rate,
                            IsAdd: value.IsAdd,
                            Amount: $('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]
                        };
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
                    //var extra = [];
                    //if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                    //    $.each(value.orderExtraItem, function (index, item) {
                    //        var ext = {
                    //            ItemID: value.ROI_ItemId,
                    //            ExtraItemID: item.ExtraItemID,
                    //            ExtraItem: item.ExtraItem,
                    //            Quantity: item.Quantity,
                    //            Rate: ($('#selDiscountType').val() == "4" ? 1 : item.ExtraPrice),
                    //            Amount: ($('#selDiscountType').val() == "4" ? (item.Quantity * 1) : (item.Quantity * item.ExtraPrice))
                    //        }
                    //        extra.push(ext);
                    //    });
                    //};
                    var sd = {
                        ItemId: value.ItemId,
                        Quantity: value.Quantity,
                        Rate: value.Rate,
                        Amount: value.Quantity * value.Rate,
                        OrderDetailsID: value.OrderDetailsID,
                        //SalesType: 'cake',
                        SalesType: orderdetails[0].SalesType,
                        ItemName: value.ItemName,
                        CostCenterId: value.CostCenterId
                    }
                    salesDetail.push(sd);
                });

                var flatorperdiscount = new Object();
                //flatorperdiscount.orderMasterId = orderdetails[0].OrderMasterId;
                //flatorperdiscount.kotdis = $('#txtKotDiscount').val();
                //flatorperdiscount.bardis = $('#txtBarDiscount').val();
                //flatorperdiscount.roomdis = 0;

                if ($('#selDiscountType option:selected').text().toLowerCase() == 'flat') {
                    flatorperdiscount.IsFlatDis = true;
                }
                else {
                    flatorperdiscount.IsFlatDis = false;
                }
                flatorperdiscount.IsFlatDis = ($('#selDiscountType').val() == "2" ? true : false);
                if (isNaN(parseFloat($('#txtDiscount').val())) || ($('#txtDiscount').val() == "")) {
                    flatorperdiscount.DiscountValue = 0.00;
                }
                else {
                    flatorperdiscount.DiscountValue = parseFloat($('#txtDiscount').val());
                }

                if (isNaN(parseFloat($('#txtDiscount').val())) || ($('#txtDiscount').val() == "")) {
                    flatorperdiscount.TotalDiscount = 0.00;
                } else {
                    flatorperdiscount.TotalDiscount = parseFloat(discountAmount);
                }

                //flatorperdiscount.BasicAmount = $('#txtTaxableAmt').val().split(' ')[1];
                flatorperdiscount.BasicAmount = parseFloat(netAmount).toFixed(2);
                //flatorperdiscount.SalesType = 'cake';
                flatorperdiscount.SalesType = orderdetails[0].SalesType;
                //discount.isLoyalty = ($('#selDiscountType').val() == "3" ? true : false);
                //discount.loyaltydis = $('#txtLoyaltyDiscount').val();
                //discount.bakerydis = $('#txtBakeryDiscount').val();
                //discount.pizzadis = $('#txtPizzaDiscount').val();
                //if (foodCourtOrder) {
                var spm = {};
                spm.SPMID = $('#selPayMode').val();
                spm.ChequeNo = ($('#selPayMode').val() == 2 ? $('#txtCheqNo').val() : "");
                spm.TransactionNo = ($('#selPayMode').val() == 3 ? $('#txtTransNo').val() : "");
                spm.ProviderID = (($('#selPayMode').val() == 3 || $('#selPayMode').val() == 2) ? $('#selProv').val() : "");
                //spm.TenderAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtTenderAmount').val() == "" ? 0 : $('#txtTenderAmount').val())) : 0);
                //spm.ReturnAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtReturnAmount').val() == "" ? 0 : $('#txtReturnAmount').val())) : 0);
                spm.TenderAmount = ($('#selPayMode').val() == 1 ? (parseFloat($('#txtTenderAmount').val()) == "" ? 0 : $('#txtTenderAmount').val()) : 0);

                //spm.ReturnAmount = ($('#selPayMode').val() == 1 ? (parseFloat($('#txtReturnAmount').val()) == "" ? 0 : $('#txtReturnAmount').val()) : 0);
                spm.ReturnAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtReturnAmount').val() == "" ? 0 : parseFloat($('#txtReturnAmount').val()))) : 0);

                spm.PayAmount = ($('#selPayMode').val() == 1 ? parseFloat($('#txtTenderAmount').val() - $('#txtReturnAmount').val()) : $('#txtNetAmt').val().split(' ')[1]);

                spm.CusID = ($('#txtCusID').val() == "" ? 0 : parseInt($('#txtCusID').val()));
                spm.Customer = ($('#txtCashCusName').val() == "" ? "" : $('#txtCashCusName').val());
                spm.Address = '';
                spm.PAN = '';
                spm.Remarks = $('.txtRemarks').val();
                //spm.SalesType = 'cake';
                spm.SalesType = orderdetails[0].SalesType;
                //if (foodCourtAutoBillGenerate) {
                //    SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPayment)
                //} else {
                jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                    if (confirmed) {
                        SaveFoodCourtSalesBill(salesMaster, salesDetail, billingTerm, spm, flatorperdiscount)
                    }
                });
                //}
                // } else {
                //jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                //    if (confirmed) {
                //        SaveSalesBill(salesMaster, salesDetail, splited, billingTerm, discount)
                //    }
                //});
                //}     
            },

            BindTakeAwaySalesBill: function (result, seatNo) {
                isButtonClicked = true;
                sNo = seatNo;
                var d = result.d;
                var datas = JSON.parse(d);
                const orderdetails = datas.orderDetail;
                orddetail = datas.orderDetail;
                billingterms = datas.billingTerm;
                costcenters = datas.cuscenter;
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
                            htmls += ("<td class='item-rate'>" + value.Rate + "</td>");
                            qnty += parseFloat(value.Quantity);
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
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + totalAmount.toFixed(2) + "</span></td></tr>");
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
                htmls += ("<td>Discount Type</td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option><option value='4'>Promotion</option></select> </td>");
                htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable'/></td></tr>");
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

                        //$("#selDiscountType").val(1);
                        //$("#selDiscountType").change();
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
                    debugger;
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

                //commented to remove service charge
                //$.each(datas.billingTerm, function (index, item) {
                //    //if (item.Name != "Service Charge") 
                //    {
                //        if (item.BillTerm != "Evening Discount") {
                //            if (item.BillTerm != "VAT") {
                //                htmls += ("<tr>");
                //                htmls += ("<td attr-term='" + item.BillTerm + "' attr-percent='" + item.Rate + "'  ><strong>" + item.BillTerm + " " + "(" + item.Rate + "%" + ")" + " : </strong>");
                //                htmls += ("<input type=\"text\" id=\"BTerm_" + item.ID + "_" + item.IsAdd + "\" value=\"" + (item.IsAdd ? "" : "-") + "Rs. " + (amntAfterDisc * item.Rate / 100).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled  attr-amount='" + (amntAfterDisc * item.Rate / 100).toFixed(2) + "'/>");
                //                htmls += ("</td>");
                //                htmls += ("</tr>");
                //                if (item.IsAdd == 1)
                //                    netAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                //                else
                //                    netAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                //            }
                //        }
                //    }
                //});
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
                //if (datas.RoomBooking.RoomBookDetailsID > 0) {
                //    htmls += ("<tr>");
                //    htmls += ("<td attr-term='Advance Payment' ><strong>Advance Payment : </strong>");
                //    htmls += ("<input type=\"text\" id=\"txtAdvancePay\" value=\"Rs. " + datas.RoomBooking.AdvancePayment.toFixed(2) + "\" class=\"sfInputbox_bill\" disabled />");
                //    htmls += ("</td>");
                //    htmls += ("</tr>");
                //    htmls += ("<tr>");
                //    htmls += ("<td attr-term='Remaining Amount' ><strong>Remaining Amount : </strong>");
                //    htmls += ("<input type=\"text\" id=\"txtRemaining\" value=\"Rs. " + (netAmount - datas.RoomBooking.AdvancePayment).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled />");
                //    htmls += ("</td>");
                //    htmls += ("</tr>");
                //}
                htmls += ("</table>");
                if (foodCourtOrder) {
                    $('#txtTotalCalc').val(parseFloat(netAmount).toFixed(2));
                    var tender = (parseFloat(netAmount) - (datas.CakeOrderList[0].AdvanceAmount)).toFixed(2);
                    $('#txtTenderAmount').val(tender);
                    $('#txtTotalCalc').change();
                }
                $("#divBillingTerm").html(htmls);
            },



            BindOccupiedTable: function () {
                var data = OccupiedTableList;
                var htmls = "";
                var time = "";
                $('#OccupiedTablesdiv').html('');
                $("#OccTablesLength").text(data.length);
                htmls += ("<div class ='Tables'><table id='OccupiedTables' class='BookedTable-list-tbl'>");
                htmls += ("<thead><th>Order No</th><th>Ordered On</th><th>Customer Name</th><th>Address</th><th>Phone Number</th><th>Total Amount</th><th>Action</th></thead><tbody>");
                if (data.length > 0) {
                    var sn = 1;
                    var AddedOn;
                    $.each(data, function (index, type) {

                        //if (type.DeliveryTime != null) {
                        //    time = formatDate(Number(type.DeliveryTime.split('(')[1].split(')')[0]));
                        //} else {
                        //    //time = new Date();
                        //    time = new Date().toISOString().slice(0, 10);
                        //}
                        AddedOn = new Date(parseInt(type.AddedOn.replace('/Date(', ''))).toLocaleDateString();
                        var search = $('#txtSearch').val().toLowerCase();
                        htmls += ("<tr><td>" + sn + "</td><td>" + AddedOn + "</td><td>");
                        htmls += type.CustomerName;
                        htmls += ("</td><td>" + type.Address + "</td><td>" + type.Phone + "</td><td>Rs. " + type.TotalAmount + "</td><td style='width:315px;'><div class='ordering'>");
                        //if (window.location.href != billAction) {
                        //    htmls += ("<input id='Order_" + type.OrderMasterID + "_" + sn + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px;' />");

                        //}
                        htmls += ("<input id='Pay_" + type.OrderMasterID + "_" + sn + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                        var Roles = userRole.split(",");
                        if (Roles.includes("Cancel Order") || Roles.includes("Super User")) {
                            htmls += ("<input id='Cancel_" + type.OrderMasterID + "_" + sn + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                        }
                        sn++;
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
                    //var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                    var htmls = "";
                    //$('#splitNoCancel').html('');
                    //for (i = 1; i <= noOfSeat; i++) {
                    //    htmls += '<option value="' + i + '">' + i + '</option>';
                    //}
                    //$('#splitNoCancel').html(htmls);
                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();

                });
                $('#OccupiedTables').on('click', '.ordernow', function () {

                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Wholesale-Invoice.aspx?id=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });
                $('#OccupiedTables').on('click', '.paynow', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBill(data[1], 'wholesale');
                });

            },
            BindTakeAwayOrders: function (data) {
                $('#TakeAwayOrdersdiv').html('');
                var data = data;
                var htmls = "";
                var time = "";
                $('#TakeAwayOrdersdiv').html('');
                $("#TakeAwayOrdersLength").text(data.length);
                htmls += ("<div class ='Tables'><table id='RetailOrders' class='BookedTable-list-tbl'>");
                htmls += ("<thead><th>Order No</th><th>Ordered On</th><th>Customer Name</th><th>Address</th><th>Phone Number</th><th>Total Amount</th><th>Action</th></thead><tbody>");
                if (data.length > 0) {
                    var sn = 1;
                    var AddedOn;
                    $.each(data, function (index, type) {

                        //if (type.DeliveryTime != null) {
                        //    time = formatDate(Number(type.DeliveryTime.split('(')[1].split(')')[0]));
                        //} else {
                        //    //time = new Date();
                        //    time = new Date().toISOString().slice(0, 10);
                        //}
                        AddedOn = new Date(parseInt(type.AddedOn.replace('/Date(', ''))).toLocaleDateString();
                        var search = $('#txtSearch').val().toLowerCase();
                        htmls += ("<tr><td>" + sn + "</td><td>" + AddedOn + "</td><td>");
                        htmls += type.CustomerName;
                        htmls += ("</td><td>" + type.Address + "</td><td>" + type.Phone + "</td><td>Rs. " + type.TotalAmount + "</td><td style='width:315px;'><div class='ordering'>");
                        //if (window.location.href != billAction) {
                        //    htmls += ("<input id='Order_" + type.OrderMasterID + "_" + sn + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px;' />");

                        //}
                        htmls += ("<input id='Pay_" + type.OrderMasterID + "_" + sn + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                        var Roles = userRole.split(",");
                        if (Roles.includes("Cancel Order") || Roles.includes("Super User")) {
                            htmls += ("<input id='Cancel_" + type.OrderMasterID + "_" + sn + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                        }
                        sn++;
                    });
                }

                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='6' style='text-align:center;'> No Data Available </td>";
                    htmls += '</tr>';
                }
                sn++;
                htmls += ("</tbody></table></div>");
                $('#TakeAwayOrdersdiv').html(htmls);

                //$('#OccupiedTables').dataTable({
                //	"bPaginate" : $('#OccupiedTables tbody tr').length>16,
                //	"iDisplayLength": 16,
                //    "ordering": false,
                //    "bLengthChange": false,
                //     "language": { search: "" ,  searchPlaceholder: "Search..."},

                //});
                $('div.dataTables_filter input').addClass('sfInputbox');



                $('#RetailOrders').on('click', '.cancelorder', function () {
                    OrderMasterID = $(this).attr('id').split("_")[1];
                    CancelTableID = $(this).attr('id').split("_")[2];
                    fromtableId = $(this).attr('id').split('_')[2];
                    //var noOfSeat = parseInt($(this).attr('id').split("_")[3]);
                    var htmls = "";
                    //$('#splitNoCancel').html('');
                    //for (i = 1; i <= noOfSeat; i++) {
                    //    htmls += '<option value="' + i + '">' + i + '</option>';
                    //}
                    //$('#splitNoCancel').html(htmls);
                    $('#hdnPinFor').val('CancelOrder');
                    InitializePin();

                });
                $('#RetailOrders').on('click', '.ordernow', function () {

                    var id = $(this).attr('id');
                    var data = id.split('_');
                    var url = p.HostUrl + "/Retail-Invoice.aspx?id=" + encodeURIComponent(data[1]);
                    window.location.href = url;
                });
                $('#RetailOrders').on('click', '.paynow', function () {
                    var id = $(this).attr('id');
                    var data = id.split('_');
                    DashboardFunction.GetDataForSalesBill(data[1], 'retail');
                });
                //if (data.length > 0) {
                //    var takeAwayHtmls = '';
                //    $("#takeTab").show();
                //    $("#TakeAwayOrdersLength").text(data.length);
                //    takeAwayHtmls += ("<div class ='orders'><table id='takeAwayTbl' class='BookedTable-list-tbl'>");
                //    takeAwayHtmls += ("<thead><th>Order No</th><th>Order ID</th><th>Date Time</th><th>Amount</th><th>Action</th></thead><tbody>");
                //    $.each(data, function (index, type) {
                //        if (!type.IsTable) {
                //            takeAwayHtmls += ("<tr><td>Order No : " + type.OrderNo + "</td>");
                //            takeAwayHtmls += ("<td>" + type.OrderMasterId + "</td>");
                //            takeAwayHtmls += ("<td>" + type.tableDate + "</td><td> Rs. " + type.Amount + "</td><td style='width:315px;'><div class='ordering'>");
                //            if (window.location.href != billAction) {
                //                takeAwayHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
                //            }
                //            takeAwayHtmls += ("<input id='Pay_" + type.OrderMasterId + "' type='button'  class='sfBtn paynow restro-btn' value='Pay' style='padding:1px 4px; margin-left:10px;'/>");
                //            takeAwayHtmls += ("<input id='Cancel_" + type.OrderMasterId + "_" + type.GuestNo + "' type='button' class='sfBtn cancelorder restro-btn' value='Cancel' style='padding:1px 4px; margin-left:10px;' />");
                //            takeAwayHtmls += ("</div></td></tr>");
                //        }
                //    });
                //    takeAwayHtmls += ("</tbody></table></div>");

                //    $('#TakeAwayOrdersdiv').html(takeAwayHtmls);

                //    $('#takeAwayTbl').on('click', '.cancelorder', function () {
                //        OrderMasterID = $(this).attr('id').split("_")[1];
                //        CancelTableID = 0;
                //        fromtableId = 0;
                //        var noOfSeat = parseInt($(this).attr('id').split("_")[2]);
                //        var htmls = "";
                //        $('#splitNoCancel').html('');
                //        for (i = 1; i <= noOfSeat; i++) {
                //            htmls += '<option value="' + i + '">' + i + '</option>';
                //        }
                //        $('#splitNoCancel').html(htmls);
                //        $('#hdnPinFor').val('CancelOrder');
                //        InitializePin();

                //    });
                //    $('#takeAwayTbl').on('click', '.ordernow', function () {

                //        var id = $(this).attr('id');
                //        var data = id.split('_');
                //        var url = p.HostUrl + "/Order.aspx?OID=" + encodeURIComponent(data[1]);
                //        window.location.href = url;
                //    });
                //    $('#takeAwayTbl').on('click', '.paynow', function () {
                //        var id = $(this).attr('id');
                //        var data = id.split('_');
                //        // DashboardFunction.GetDataForSalesBill(data[1]);
                //        DashboardFunction.GetDataForTakeAwaySalesBill(data[1]);
                //    });
                //}
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
                                roomHtmls += ("<input id='Order_" + type.OrderMasterId + "' type='button' class='sfBtn ordernow restro-btn' value='Order ' style='padding:1px 4px; margin-left:10px;' />");
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
                 
                //var roles = userRole.split(',');

                //if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                //    $("#selDiscountType").val(3);
                //    $("#selDiscountType").change();
                //}
                //else {
                //}

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
function BillShortcutKey(e) {
    //var evtobj = window.event ? event : e
    //if (evtobj.keyCode == 66 && evtobj.altKey && evtobj.ctrlKey && isButtonClicked) {
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



function SaveFoodCourtSalesBill(salesMaster, salesDetail, billingTerm, salesPayment, flatorperdiscount) {
    var customer = 1;

    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "saveCakeSalesBill",
        data: JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, billingTerm: billingTerm, spm: salesPayment, flatorperdiscount: flatorperdiscount }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            $('#DialogOrderDetail').dialog('close');
            getCakeBill(data.d, true, salesMaster.SalesType);

            $('#BillingView').dialog({
                'title': 'Vat Bill',
                width: '900',
                height: 'auto',
                modal: true,
                position: ['center', 'center'],
                dialogClass: 'popup-titlebg'
            });
            $('#btnPrints').unbind('click').on('click', function () {
                $('#divPrintedOn').text(formatAMPM());
                savePrintCount((parseInt($('#hdfPrntCnt').val()) + 1), parseInt($('#hdfSMID').val()), SageFrameUserName, 'cake');
            });

            print();
            $('#InvoiceType').html('INVOICE');
            print();
            $('#BillingView').dialog('close');

            jAlert('Bill printed successfully', "Information!!", function () {
                window.location.reload();
            });

            //var contents = $('#customer-bill').html();
            //var frame1 = document.createElement('iframe');
            //frame1.name = "frame1";
            //document.body.appendChild(frame1);
            //var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
            //frameDoc.document.open();
            //frameDoc.document.write('<html><head><title></title>');
            //frameDoc.document.write('</head><body>');
            //frameDoc.document.write(contents);
            //frameDoc.document.write('</body>');
            //frameDoc.document.close();
            //setTimeout(function () {
            //    window.frames["frame1"].focus();
            //    window.frames["frame1"].print();
            //    document.body.removeChild(frame1);
            //}, 500);


            $('#InvoiceType').html('INVOICE');
            $('#btnPrints').click();

            $('#txtCustName').val('');
            $('#txtContactNo').val('');
            $('#CustomerID').text(0);
            $('#txtTokenNo').val('');
            $("#txtAddress").val('');
            $('#loyalityDiscount').text(0);


        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function calculateSurpDefct(str)  //// str->1 for Tender, str->2 for Return amt
{

    var surpDfct = 0;
    var returnAmt = 0;
    if (str == 1) {
        if ($("#txtTenderAmount").val() > $("#txtTotalCalc").val()) {
            returnAmt = $("#txtTenderAmount").val() - $("#txtTotalCalc").val();
        }

        surpDfct = $("#txtTenderAmount").val() - returnAmt - $("#txtTotalCalc").val();
    } else {
        returnAmt = $("#txtReturnAmount").val();
        surpDfct = $("#txtTenderAmount").val() - returnAmt - $("#txtTotalCalc").val();
    }

    $("#lblSurpDefct").text(surpDfct.toFixed(2));

    if (surpDfct < 0) {
        $(".clsSurpDefct").css('color', 'red');
    } else if (surpDfct > 0) {
        $(".clsSurpDefct").css('color', 'green');
    } else {
        $(".clsSurpDefct").css('color', 'black');
    }
}

function getProviderList() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetProviderList",
        data: '',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            var htmls = "";
            $('#selProv').html(htmls);
            $.each(result, function (index, value) {
                htmls += '<option value="' + value.ProviderID + '">' + value.ProviderName + '</option>';
            });
            $('#selProv').html(htmls);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}


