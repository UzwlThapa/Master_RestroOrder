(function ($) {
	var tabs = $("#tabs").tabs();
	$.HouseKeepingFunction = function (p) {
		p = $.extend
			 ({
				 PortalID: '',
				 ModulePath: '/Modules/HouseKeeping/',
			 }, p);
		var HouseKeeping = {
			config: {
				isPostBack: false,
				async: false,
				cache: false,
				type: 'POST',
				contentType: "application/json; charset=utf-8",
				data: {},
				dataType: 'json',
				baseURL: p.ModulePath + "WebService.asmx/",
				method: "",
				url: "",
				ajaxCallMode: 0,
			},
			InitialSetup: function () {
			},

			init: function () {
			},

			ajaxCall: function (config) {
				$.ajax({
					type: HouseKeeping.config.type,
					contentType: HouseKeeping.config.contentType,
					async: HouseKeeping.config.async,
					cache: HouseKeeping.config.cache,
					url: HouseKeeping.config.url,
					data: HouseKeeping.config.data,
					dataType: HouseKeeping.config.dataType,
					success: HouseKeeping.ajaxSuccess,
					error: HouseKeeping.ajaxFailure
				});
			},

			ajaxSuccess: function (data) {
				switch (parseInt(HouseKeeping.config.ajaxCallMode)) {
					case 0:
						break;
				}
			},
			ajaxFailure: function () {
			},

			//<<-----------------------------Post & Get Here ---------------------------------------->>




			//<<-----------------------------------Reset & Validation ------------------------------------->>>

			ResetAll: function () {
			},

			ValidationForm: function () {
			},
		};
		HouseKeeping.init();
	};
	$.fn.MainHouseKeeping = function (p) {
		$.HouseKeepingFunction(p);
	};
})(jQuery);