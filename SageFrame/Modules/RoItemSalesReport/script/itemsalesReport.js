
/* ---- shared report helpers (date/int/JSON safety) ---- */
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
    /* .asmx WebMethods returning JsonConvert.SerializeObject(list) arrive as
       {d: "..."} -> data.d is a STRING. Older/newer builds may hand back an
       object or a double-encoded string instead. Normalise all of them here so
       dropdowns never die with:
       Uncaught SyntaxError: "[object Object]" is not valid JSON */
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
                 ModulePath: ''
             }, p);
        var v = 0;
        var TotalAmount = 0;
        var totamount = 0;
        var name = [];
        var checks = [];
        var companyProf = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: "/Modules/RoReport/SalesReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MemberID: 27,
                MemberIDUpdate: 0




            },
            InitialSetup: function () {
                $(".picker").datepicker({
                    dateFormat: "yy-mm-dd"
                }).datepicker("setDate", "0");


                $("#btnView").on("click", function () {
                    companyProf.getitemsalesReport();
                })
                
                
            },
            init: function () {
                companyProf.InitialSetup();
            },



            ajaxCall: function (config) {
                $.ajax({
                    type: companyProf.config.type,
                    contentType: companyProf.config.contentType,
                    async: companyProf.config.async,
                    cache: companyProf.config.cache,
                    url: companyProf.config.url,
                    data: companyProf.config.data,
                    dataType: companyProf.config.dataType,
                    success: companyProf.ajaxSuccess,
                    error: companyProf.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        companyProf.BindCusCash(data.d);
                        break;


                }
            },
            ajaxFailure: function (xhr, status, err) {
                alert("Report request failed (" + (xhr && xhr.status ? xhr.status : '?') + "): "
                    + (xhr && xhr.responseText ? xhr.responseText.slice(0, 300) : (err || status)));
            },


            //-----------------------------------------getdata---------------------------\\

           

            
            //---------------------------------------------BindData-------------------------------------------\\

            getitemsalesReport: function () {
                var Start = isoDate("#txtStartDate", false);
                var EndDate = isoDate("#endDate", true);
                companyProf.config.method = "getiemsalesreport";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ Start: Start, EndDate: EndDate });
                companyProf.config.ajaxCallMode = 1;
                companyProf.ajaxCall(companyProf.config);
            },

            BindCusCash: function (result) {
                $("#reportDisplay").show();
                $("#reportDisplay").html('');
                salesList = parseResult(result);
                var htmls = "<table id='Cashtable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>BillDate</th><th>Cost Center Name </th><th>Item Name </th><th>Qty</th><th class='tdrate'>Rate</th><th class='tdrate'>Net Amount </th><th>IsCombo</th>"
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (salesList.length > 0) {               
                    $.each(salesList, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.BillDate.split(" ")[0] + "</td>";
                        htmls += "<td>" + value.CostCenterName + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.QTY + " ("+ value.ITUnit + ")</td>";
                        htmls += "<td class='tdrate'>Rs. " + value.rate + "</td>";
                        htmls += "<td class='tdrate'>Rs. " + parseFloat(value.NetAmount).toFixed(2) + "</td>";
                        htmls += "<td>" + value.IsCombo + "</td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);

                    });
                } else {
                    $('#reportDisplay').html('No data');

                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#reportDisplay').html(htmls);
                    $('#Cashtable').DataTable(
                         {
                            "jQueryUI" : true,
                             dom: 'Bfrtip',
                             buttons: [
                                 'copy', 'csv', 'excel', 'pdf', 'print'
                             ]

                         });
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        FirstName: {
                            required: true,
                        },

                        

                        PaidAmount: {
                            required: true,
                            number: true,
                        }
                    },
                    messages: {
                        textUnit: {
                            number: '*'
                        },
                    },
                });
                if (v.form()) {
                    return true;
                }
                else
                    return false;
            },



        };
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
