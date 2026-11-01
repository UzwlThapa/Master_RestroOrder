/* .asmx WebMethods returning JsonConvert.SerializeObject(list) arrive as
{d: "..."} -> data.d is a STRING. Older/newer builds may hand back an
object or a double-encoded string instead. Normalise all of them here so
dropdowns never die with:
Uncaught SyntaxError: "[object Object]" is not valid JSON */
function pad2(n) { return n < 10 ? '0' + n : '' + n; }
function isoDate(dpSelector, endOfDay) {
    var dt = null;
    try { dt = $(dpSelector).datepicker('getDate'); } catch (e) { dt = null; }
    if (!dt) {
        var v = $(dpSelector).val();
        if (v) {
            // jqUI datepicker with dateFormat:"yy-mm-dd" -> unambiguous ISO-ish text.
            var m = /^(\d{4})-(\d{2})-(\d{2})/.exec(String(v).replace(/^\s+|\s+$/g, ''));
            if (m) { dt = new Date(parseInt(m[1], 10), parseInt(m[2], 10) - 1, parseInt(m[3], 10)); }
            else { dt = new Date(v); }   // legacy US-format pages: browser-dependent, but better than nothing
        }
    }
    if (!dt || isNaN(dt.getTime())) dt = new Date();
    return dt.getFullYear() + '-' + pad2(dt.getMonth() + 1) + '-' + pad2(dt.getDate())
           + (endOfDay ? ' 23:59' : ' 00:00');
}
function toInt(v) { var n = parseInt(v, 10); return isNaN(n) ? 0 : n; }
function parseResult(result) {
    if (result === null || result === undefined || result === '') return [];
    if (typeof result === 'object') {
        if (result.d !== undefined && result.d !== null) return parseResult(result.d);
        return result;
    }
    if (typeof result === 'string') {
        var s = result.replace(/^\s+|\s+$/g, '');
        if (s === '') return [];
        try {
            var o = JSON.parse(s);
            if (typeof o === 'string') { o = JSON.parse(o); }
            return o;
        } catch (e) { return []; }
    }
    return [];
}

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
            ajaxFailure: function (xhr, status, err) {
                alert("Report request failed (" + eventFunction.config.method + ")\nHTTP " +
                      (xhr && xhr.status ? xhr.status : status) + "\n" +
                      (xhr && xhr.responseText ? xhr.responseText.substring(0, 300) : err));
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
                            StartEndDateByReport: function () {
                  var Start = isoDate("#txtStartDate", false);
                  var EndDate = isoDate("#txtToDate", true);
                eventFunction.config.method = "getOrderItemReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: Start, endDate: EndDate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindOrderItemReport: function (result) {            
                orderlist = parseResult(result);
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
