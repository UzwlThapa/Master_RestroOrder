
(function ($) {
    var tabs = $("#tabs").tabs();
    var tabs = $("#OrderTab").tabs();
    $('#OrderTab').css('display', 'block');
    $.companyOrderItemcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/OrderFoodCode/',
                HostUrl: '',
                sentdata: '',
                roomdata: '',
                OID: '',
                userName: '',
                numpin: ''
            }, p);
        var OrderItemFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "Services/OrderFoodCodeWebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MenuId: 0,
                Menuupdate: 0
            },

            init: function () {

                var loggername = SageFrameUserName;
                GetUserName(loggername);
                GetGlobalizedMenu();
                GetItemForSearch();
                var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
                GetMenuforOrder(languageid);
                getcomboformenu();
                GetExtraItemsByItem();
                initialSetup(p.sentData, p.OID, p.HostUrl, true, false);

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

