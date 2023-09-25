(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROISalesPaymentMode/'
             }, p);
        var v = 0;
      
        var eventFunction = {
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
       
            },
            InitialSetup: function () {
                $("#salespaymentmodeTable").hide();
                $("#SalesPaymentModeButton").hide();
                $("#tblSwap").hide();
            },
            init: function () {

                eventFunction.InitialSetup();
 
                $("#AddSalesPaymentMode").on('click', function () {
                    $("#salespaymentmodeTable").show(1000);
                    $("#SalesPaymentModeButton").show(1000);
                    $("#AddSalesPaymentMode").hide(1000);

                });
                $("#btnUnitCancel").on('click', function () {
                    $("#salespaymentmodeTable").hide(1000);
                    $("#SalesPaymentModeButton").hide(1000);
                    $("#AddSalesPaymentMode").show(1000);
                    //eventFunction.ResetAll();
                });
                $("#btnSalesPaymentModeSave").on('click', function () {

                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                       
                        $("#salespaymentmodeTable").hide(1000);
                        $("#SalesPaymentModeButton").hide(1000);
                        $("#AddSalesPaymentMode").show(1000);
                        eventFunction.ResetAll();
                    }
                });

                $("#chckSwap").change(function () {

                    //if (this.checked) {
                    //    $("#tblSwab").hide();
                    //}
                    if ($("#chckSwap").is(':checked'))
                    {
                        $("#tblSwap").show();  // checked
                        //$("#chckSwap").hide();  // checked

                    }
                    else {
                        $("#tblSwap").hide();
                    }//location.reload();
                });


                //$("#unittable").on('click', '.UnitEdit', function () {
                //    $("#UnitTable").show();
                //    $("#UnitButton").show();
                //    var ids = $(this).attr('id');
                //    var words = ids.split('_');
                //    eventFunction.config.UnitId = words[0];
                //    $("#textUnit").val(words[1]);
                //    eventFunction.config.Unitupdate = 1;

                //});
                //$("#unittable").on('click', '.UnitDelete', function () {
                //    eventFunction.DeleteUnit(this);
                //    eventFunction.ResetAll();
                //});

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
                        jAlert('Successfully Inserted', 'Information!!', function () { $.alerts.dialogClass = null; });

                        break;
                    case 2:
                        jAlert('Successfully Updated', 'Information!!', function () { $.alerts.dialogClass = null; });
                        location.reload();
                        break;
                    case 3:
                        jAlert('Successfully Delete', 'Information!!', function () { $.alerts.dialogClass = null; });
                        var id = eventFunction.config.ID;
                        $("#" + id + "_").remove();
                        break;
                    //case 4:
                    //    eventFunction.BindUnit(data);
                    //    break;
                    //case 5:
                    //    eventFunction.BindUnit1(data);
                    //    break;
                    //case 6:
                    //    eventFunction.BindDDUnit(data);
                    //    break;
                    //case 7:
                    //    alert(data.d);

                    //    //alert(errorlist[data.ErrorBit]);
                    //    break;
                    //case 8:
                    //    eventFunction.BindUnit2(data);
                    //    break;

                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 1:
                //        alert("Duplicate UnitName   Not Valid", "fail");
                //        break;


                //}
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            //getUnitFromDatabaseforDD: function () {
            //    eventFunction.config.method = "getUnitFromDatabaseforDD";
            //    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            //    eventFunction.config.data = eventFunction.config.data;
            //    eventFunction.config.ajaxCallMode = 6;
            //    eventFunction.ajaxCall(eventFunction.config);
            //},


      
            UnitSave: function () {
                var UnitInf = {};

                UnitInf.UnitID = eventFunction.config.UnitId;
                UnitInf.UnitName = $('#textUnit').val();
                eventFunction.config.method = "UnitSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ UnitInf: UnitInf });

                if (eventFunction.config.Unitupdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.Unitupdate = 0;
            },
            GetUnit: function () {
                eventFunction.config.method = "GetUnitfromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },


            DeleteUnit: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var UnitID = id;
                eventFunction.config.method = "UnitDelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ UnitID: UnitID });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },
   

            //<<-----------------------------------BindTable Herere ------------------------------------->>>
       

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

          
         


        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);