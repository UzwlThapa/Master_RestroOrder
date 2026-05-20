(function ($) {
    $.FrontPageEdit = function (p) {
        var order = 0;
        var level = 0;
        p = $.extend
                ({
                    CultureCode: '',
                    UserModuleID: '1'
                }, p);
        var FrontPageEdit = {
            config: {
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: '{}',
                dataType: 'json',
                method: "",
                url: "",
                categoryList: "",
                ajaxCallMode: 0,
                arr: [],
                arrModules: [],
                baseURL: SageFrameAppPath + '/Modules/FrontPage/WebService/FrontPageEdit.asmx/',
                Path: SageFrameAppPath + '/Modules/FrontPage/',
                PortalID: SageFramePortalID,
                UserName: SageFrameUserName,
                UserModuleID: p.UserModuleID                
            },
            init: function () {             
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: FrontPageEdit.config.type,
                    contentType: FrontPageEdit.config.contentType,
                    cache: FrontPageEdit.config.cache,
                    async: FrontPageEdit.config.async,
                    url: FrontPageEdit.config.url,
                    data: FrontPageEdit.config.data,
                    dataType: FrontPageEdit.config.dataType,
                    success: FrontPageEdit.ajaxSuccess,
                    error: FrontPageEdit.ajaxFailure
                });
            },
        }
        FrontPageEdit.init();
    }
    $.fn.FrontPageEdit = function (p) {
        $.FrontPageEdit(p);
    };
})(jQuery);
