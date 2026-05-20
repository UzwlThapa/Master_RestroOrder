(function ($) {
    // var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROI_Item/'
             }, p);
        var v = 0;
        var i = 2;
        var AutocompleteItem = [];
        var htmls = "";
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "RoiItem.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0,
                ItemID: 0,
            },
            InitialSetup: function () {
            },
            init: function () {
                 
                $("#itemName").change(function () {
                    var item = $("#itemName").val();
                    eventFunction.config.method = "CheckItemExistenceForCategory";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ item: item });
                    eventFunction.config.ajaxCallMode = 0;
                    eventFunction.ajaxCall(eventFunction.config);
                });
                 
                $("#fileImage").change(function () {
                    var path = $('input[type=file]').val();
                    var filename = path.replace(/^.*\\/, "");

                    $("#txtImage").val(filename);
                    eventFunction.readURL(this);
                    eventFunction.uploadImage();
                });
            },

            readURL: function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#ImgPrvs').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            },

            uploadImage: function () {
                var fileUpload = $("#fileImage").get(0);
                var files = fileUpload.files;

                var data = new FormData();
                for (var i = 0; i < files.length; i++) {
                    data.append(files[i].name, files[i]);
                }

                $.ajax({
                    url: "/Modules/ROI_Item/FileUploadHandler.ashx",
                    type: "POST",
                    data: data,
                    contentType: false,
                    processData: false,
                    success: function (result) { },
                    error: function (err) {
                        jAlert(err.statusText, "Error!!", function () {
                            $.alerts.dialogClass = null;
                        });
                    }
                });
                //success: function (result) { alert(result); },
            },

            ajaxCall: function (config) {
                $.ajax({
                    type: eventFunction.config.type,
                    contentType: eventFunction.config.contentType,
                    async: eventFunction.config.async,
                    cache: eventFunction.config.cache,
                    url: eventFunction.config.url,
                    data: eventFunction.config.data,
                    dataType: eventFunction.config.dataType,
                    success: eventFunction.ajaxSuccess,
                    error: eventFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 0:
                        eventFunction.BindCheckItemExistence(data.d);
                        break;
                }
            },
            ajaxFailure: function () { 
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            

            BindCheckItemExistence: function (result) {
                debugger;
                datas = JSON.parse(result);
                var htmls = '';
                if (datas.length > 0) {
                    jAlert("Category Name: " + $("#itemName").val() + " is Already Saved", "Information!!", function () {
                        $.alerts.dialogClass = null;
                    });
                    $("#itemName").val("");
                    $('#itemName').focus();
                }
                else {
                    $("#itemCode").attr("placeholder", $("#itemName").val());
                }
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
