(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 Username: '',
                 ModulePath: '/Modules/RoiPurchase/'
             }, p);
        var v = 0;
        var ArrayData = [];
        var arraycount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "PurchaseWebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0


            },
            InitialSetup: function () {





            },
            init: function () {

                eventFunction.InitialSetup();

                eventFunction.GetItem();

                $("#ddlitem").on('change', function () {

                    var id = $('#ddlitem option:selected').val();
                    eventFunction.config.method = "getunitbyItem";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ itemID: id });
                    eventFunction.config.ajaxCallMode = 2;
                    eventFunction.ajaxCall(eventFunction.config);


                })


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
                        break;
                    case 1:
                        eventFunction.BindDropdwonItem(data);
                        break;
                    case 2:
                        eventFunction.BindDropdwonUnit(data);
                        break;


                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>


            GetItem: function () {
                eventFunction.config.method = "getitemfromdatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>>


            BindDropdwonUnit: function (result) {
                var datas = result.d;
                $("#ddlunits").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "'>" + value.UnitName + "</option>";
                        ArrayData.push(value.UnitID);
                    });

                    $("#ddlunits").html(htmls);

                    
                }
                //$('#txtQuentity').on('keypress input change', function () {
                $('#txtQuentity').on('keypress input change', function () {
                 
                  var  dotLength = $(this).val().match(/\.+/ig);
                    if (dotLength == null) {
                            var value = $('#ddlunits').children('[value="' + ArrayData[0] + '"]');
                            value.attr('disabled', false);
                        }
                    else {
                            var value = $('#ddlunits').children('[value="' + ArrayData[(dotLength.length - 1)] + '"]');
                            value.attr('disabled', true);
                            var value1 = $('#ddlunits').children('[value="' + ArrayData[(dotLength.length)] + '"]');
                            value1.attr('disabled', false);
                        }
                });
            },

           
            BindDropdwonItem: function (result) {
                var datas = result.d;
                var x = new Array();
                $("#ddlitem").html('');

                if (datas.length > 0) {
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });

                    $("#ddlitem").html(htmls);
                }

            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#textItemName').val(null);
                $('#textItemCode').val(null);
                $('#textItemPrice').val(null);
                $('#ddlUnit').val(null);
                $('#ddlCategory').val(null);
                $('#ddlCostCenter').val(null);
                $('#txtFile').val('');
                $('.showimage').hide();
                $('#ImgPreview').val('');
                $('#textItemDescription').val(null);
                eventFunction.config.NewItemID = 0;
                eventFunction.config.ItemIDUpdate = 0;
            },


        };

        v = $('#form1').validate({
            rules: {

                ////StoreItem
                textItemName: {
                    required: true,
                },
                path: {
                    required: true
                }
                ,
                textItemDescription: {
                    maxlength: 5
                },

            },
            messages: {
                textItemPrice: {
                    number: 'Price must be number'

                }
            }

        });
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);