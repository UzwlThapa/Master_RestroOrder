
(function ($) {
    var tabs = $("#tabs").tabs();
     var tabs = $("#OrderTab").tabs();
     $('#OrderTab').css('display', 'block');
    $.companyOrderItemcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Order/',
                 HostUrl: '',
                 sentdata: '',
                 roomdata: '',
                 OID: '',
                 userName: '',
                 numpin: ''
                 //names: '',
                 //phoneNo: '',
                 //NoOfGuests: '',
                 //membershipId: ''
             }, p);
        var v = 0;
        var OrderMasterID = 0;
        var OrderListArray = new Array();
        var PreviousOrdersList = new Array();
        var inprogressOrders = new Array();
        var completedOrders = new Array();
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
        var sum = 0;
        var logoName = "logo.png";
        var subItem = false;
        var categoryName = "";
        var ExtraItemsByItem = new Array();
        var OrderItemFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "services/OrderItemWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MenuId: 0,
                Menuupdate: 0
            },

            init: function () {
               
                var Delivery = false;
                var loggername = SageFrameUserName;
                GetUserName(loggername);
                GetPreviousItemByID(p.sentData, p.OID);
                GetGlobalizedMenu();
                GetItemForSearch();
                var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                GetMenuforOrder(languageid);
                getcomboformenu();
                GetExtraItemsByItem();
                initialSetup(p.sentData, p.OID, p.HostUrl, false, false);
               
                
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
                        break;
                }
            },
            ajaxFailure: function () {

            },

            
        };
        OrderItemFunction.init();
    };
    $.fn.companyOrderItemEDIT = function (p) {
        $.companyOrderItemcreate(p);
    };

})(jQuery);



