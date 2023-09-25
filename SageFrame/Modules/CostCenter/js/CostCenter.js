(function ($) {
    $.CostCenter = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/CostCenter/',
                UserName: '',
            }, p);
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ROCostCenter.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0
            },

            init: function () {
 
                $(".editBtn").on('click', function () {
                   $("#btnCostCenterAdd").hide();
                });
                //$("#btnCostCenterTab").on('click', function () {
                //    $("#btnCostCenterAdd").show();
                //    $("#btnGroupAdd").hide();
                //});

                eventFunction.InitialSetup();

                $('.btnAddCostCenter').on('click', function () {

                    $('#CostCenterForm').dialog({
                       'title': 'Add Cost Center',
                        width: '600px',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'center']
                    });

                    $("#CostCenterForm").dialog("open");


                    $("#btnSaveCostcenter").on("click", function () {
                        debugger;
                        var obj = new Object();
                        obj.CostCenterId = 0;
                        obj.CostCenterName = $("#txtCostCenter").val();
                        obj.DefaultPrinter = $("#txtPrinter").val();
                        obj.coDiscount = $("#txtDiscount").val();
                        obj.Username = "superuser";
                        obj.NumberOfCounter = $("#txtCounter").val();
                        obj.store = $("#txtStore").val();
                        obj.GroupId = $("#txtGroup").val();

                        if (obj.CostCenterName == "" || obj.coDiscount == "" || obj.NumberOfCounter == "") {
                            jAlert("Please Insert Required Field !!", "Error");
                        } else {
                            eventFunction.SaveCostCenter(obj);
                        }

                    });


                });

               


            },

            InitialSetup: function () {
                eventFunction.getStores();
            },

            ResetInitial() {
                $("#CostCenterForm").dialog("close");
                $("#txtCostCenter").val("");
                $("#txtCounter").val("");
                $("#txtDiscount").val("");
            },

            getStores: function () {
                eventFunction.config.method = "GetStores";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //eventFunction.config.data = JSON2.stringify({ startdate: startdate });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            SaveCostCenter: function (dataobj) {
                eventFunction.config.method = "SaveCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dataObj: dataobj });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            

            bindCostCenterForm: function (result) {
                var htm = ""
                htm += ("<select class='sfInputbox' id='txtStore'>");
                $.each(result.Stores, function (index, item) {
                    htm += ("<option value='" + item.STId + "'>" + item.StName + "</option>");
                });
                htm += ("</select>");
                $(".tdTxtStore").html(htm);


                var ht = ""
                ht += ("<select class='sfInputbox' id='txtPrinter'>");
                $.each(result.Printers, function (index, item) {
                    ht += ("<option value='" + item + "'>" + item + "</option>");
                });
                ht += ("</select>");
                $(".tdTxtPrinter").html(ht);


                var ht = ""
                ht += ("<select class='sfInputbox' id='txtGroup'>");
                $.each(result.CostCenterGroup, function (index, item) {
                    ht += ("<option value='" + item.GroupId + "'>" + item.GroupName + "</option>");
                });
                ht += ("</select>");
                $(".tdTxtGroup").html(ht);

                


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
                        eventFunction.bindCostCenterForm(data.d)
                        break;
                    case 1:
                        jAlert("Data Inserted Successfully !!", "Information")
                        eventFunction.ResetInitial();
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },
        };
        eventFunction.init();
    };
    $.fn.CostCenterJs = function (p) {
        $.CostCenter(p);
    };
})(jQuery);