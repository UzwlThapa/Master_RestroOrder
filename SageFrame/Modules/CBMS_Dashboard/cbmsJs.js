(function ($) {
    $.CReport = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/CBMS_Dashboard/',
                 master: '0',
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
                baseURL: p.ModulePath + "cbmsWS.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },

            init: function () {

                eventFunction.getCbmsData();
                //$('#tblSyncedData').DataTable({
                //    searching: false,
                //    paging: false,

                ////});
                //eventFunction.getCbmsSyncedData();
                //$("#btnSyncAllSales").click(function () {
                //    eventFunction.SyncAllSales();
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
                        jAlert(data.d, "Information!!", function () {
                            $.alerts.dialogClass = null;
                        });
                        eventFunction.init();
                        break;
                    case 1:
                        eventFunction.bindCbmsData(data.d);
                        break;
                    case 2:
                        eventFunction.bindCbmsSyncedData(data.d);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            getCbmsData: function () {
                eventFunction.config.method = "getCbmsData";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            getCbmsSyncedData: function () {
                var noOfDays = 7;
                eventFunction.config.method = "getCbmsSyncedData";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ days: noOfDays });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            SyncAllSales: function () {
                eventFunction.config.method = "SyncAllSales";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindCbmsData: function (result) {
                $('#lblTotalSales').html(result.TotalSales);
                $('#lblSyncedSales').html(result.SyncedSalesBill);
                $('#lblUnSyncedSales').html(result.UnSyncedSalesBill);
                $('#lblSalesReturnedBills').html(result.SyncedReturnedSalesBill + result.UnSyncedReturnedSalesBill);
                $('#lblUnSyncedReturnedBills').html(result.UnSyncedReturnedSalesBill);
            },
            bindCbmsSyncedData: function (result) {
                var htmls = "";
                $('#cbmsSyncedData').html(htmls);
                $.each(result, function (index, value) {
                    htmls += "<tr>";
                    htmls += "<td>" + value.SyncedDate + "</td>";
                    htmls += "<td>" + value.NoOfBills + "</td>";
                    htmls += "<td>" + value.TotalSalesAmount + "</td>";
                    htmls += "<td>" + value.TaxableSalesAmount + "</td>";
                    htmls += "<td>" + value.VatAmount + "</td>";
                    htmls += "</tr>";
                });
                $('#cbmsSyncedData').html(htmls);
            },

        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);