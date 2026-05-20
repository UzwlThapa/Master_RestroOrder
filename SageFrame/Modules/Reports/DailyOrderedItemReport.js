(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Reports/'
             }, p);
        var selectedIndex = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "AllReports.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
            },
            InitialSetup: function () {
        
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#StartEndReportView").click(function () {                
                    eventFunction.StartEndDateByReport();
                });
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
                        eventFunction.BindOrderItemReport(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            StartEndDateByReport: function () {   
                var Start = $("#txtStartDate").val() + " 00:00";
                var EndDate = $("#txtToDate").val() + " 23:59";
                eventFunction.config.method = "getOrderItemReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: Start, endDate: EndDate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindOrderItemReport: function (result) {            
                orderlist = JSON.parse(result);
                $("#DailyOrderReport").show();
                $("#filter").show();
                $("#DailyOrderReport").html('');
                var htmls = "<table id='Cashtable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Cost Center Name </th><th>Item Name </th><th>Qty</th>"
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (orderlist.length > 0) {               
                    $.each(orderlist, function (index, value) {

                        htmls += "<tr class='tableItem'>";
                        htmls += "<td>" + value.CostCenterName + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.QTY + "</td>";
                        htmls += "</tr>"
               

                    });
                } else {
                    $('#DailyOrderReport').html('No data');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#DailyOrderReport').html(htmls);
                    var table = $('#Cashtable').DataTable(
                         {
                            "jQueryUI" : true,
                            ordering : false,
                             dom: 'Bfrtip',
                             buttons: [
                                 'copy', 'csv', 'excel', 'pdf', 'print'
                             ]

                         });

               
                $('#selResponsible').on('change', function () {
                    table.columns(0).search(this.value).draw();
                });

            },
            Reset: function () {
                window.location.reload();

                //eventFunction.InitialSetup();
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        Amnities: {
                            required: true,
                        }
                    },
                    messages: {
                    },
                });
                if (v.form()) {
                    return true;
                }
                else
                    return false;

            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
