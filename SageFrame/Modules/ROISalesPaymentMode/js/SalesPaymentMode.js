(function ($) {
    $.companyProfCreate
        = function (p) {
        p = $.extend({
            UserModuleID: '',
            ModulePath: '/Modules/ROISalesPaymentMode/',
            HostUrl: '',

        }, p);
        var v = 0;
        var eventFuntion = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "Services/SalesPaymentMode.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0
            },
            InitialFuntion: function () {
              
             
            },
            init: function () {
                //eventFuntion.InitialFuntion();
                $("#salespaymentmodeTable").hide();
                $("#SalesPaymentModeButton").hide();
                //$("#textSalesPaymentModeName").on('change', function () {
                //    alert('change');
                //});
                $("#AddSalesPaymentMode").on('click', function () {
                    $("#salespaymentmodeTable").show(1000);
                    $("#SalesPaymentModeButton").show(1000);
                    $("#AddSalesPaymentMode").hide(1000);

                });
                $("#btnItemCancel").on('click', function () {
                    $("#salespaymentmodeTable").hide(1000);
                    $("#SalesPaymentModeButton").hide(1000);
                    $("#AddSalesPaymentMode").show(1000);
                    //eventFunction.ResetAll();
                });


                $("#chckSwap").change(function() {
                    if ($("#chckSwap").is(':checked'))
                        $("#tblSwap").show();  // checked
                    else
                        $("#tblSwap").hide();
                    //location.reload();
                });


            },
            ajaxCall: function (config) {
                $.ajax({
                    type: eventFuntion.config.type,
                    contentType: eventFuntion.config.contentType,
                    async: eventFuntion.config.async,
                    cache: eventFuntion.config.cache,
                    url: eventFuntion.config.url,
                    data: eventFuntion.config.data,
                    dataType: eventFuntion.config.dataType,
                    success: eventFuntion.ajaxSuccess,
                    error: eventFuntion.ajaxFailure
                });
            },

            ajaxSuccess: function (data) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 1:
                        jAlert('Successfully Inserted', 'Information!!', function () { $.alerts.dialogClass = null; });
                        location.reload();
                        break;
                    case 2:
                        jAlert('Successfully Updated', 'Information!!', function () { $.alerts.dialogClass = null; });
                        location.reload();
                        break;
                    case 3:
                        jAlert('Successfully Deleted', 'Information!!', function () { $.alerts.dialogClass = null; });
                        var id = eventFunction.config.ID;
                        $("#" + id + "_").remove();
                        //eventFunction.GetItem();
                        break;

                }
            },
            ajaxFailure: function () {
            },
            //<<-----------------------------Post & Get Here ---------------------------------------->>
            SPMSave: function ()
            {
                var SalesPaymentModeInf = {};
                SalesPaymentModeInf.SPMID = eventFunction.config.NewSPMID;
                SalesPaymentModeInf.SPMName = $('#textItemName').val();
                SalesPaymentModeInf.SPMDescription = $('#textItemDescription').val();


                eventFunction.config.method = "SPMSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ ItemsInf: ItemsInf });
                if (eventFunction.config.ItemIDUpdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.SPMIDUpdate = 0;
            },

            GetSPM: function () {
                eventFunction.config.method = "GetSPMfromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            DeleteSPM: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var SPMID = id;
                eventFunction.config.method = "SPMDelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ SPMID: SPMID });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SwapSelected: function () {
                $('#textItemName').val('>Payment Mode');
                if ($("#chckSwap").is(':checked'))
                    $("#tblSwap").show();  // checked
                else
                    $("#tblSwap").hide();
              
            },


        }
    };



    $.fn.companyProfEDIT = function (p) {

        $.companyProfCreate(p);
    };
})(jQuery)