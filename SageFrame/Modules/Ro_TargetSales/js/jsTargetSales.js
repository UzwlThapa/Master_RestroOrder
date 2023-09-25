(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Ro_TargetSales/service/'
             }, p);
        var selectedIndex = 0;
        var today = new Date();
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "webService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                AgentID: 0,
                AgentUpdate: 0
            },
            InitialSetup: function () {
            },
            init: function () {
                eventFunction.InitialSetup();
                $(".picker").datepicker({
                    dateFormat: "yy-mm-dd"
                }).datepicker("setDate", "0");

                $("#btnView").on('click', function () {
                    if ($('#targetdate').val() != "" && $('#targetdate').val() != null) {
                        var date = $('#targetdate').val()
                        eventFunction.getTargetSales(date);
                    }
                    else {
                            jAlert('Empty Date Selected', "Alert!!", function () { $.alerts.dialogClass = null; });
                    }
                });
                $("#btnPrint").on('click', function () {
                    
                    window.open('data:application/vnd.ms-excel,' + encodeURIComponent($('#TargetSales').html()));
                    e.preventDefault();
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
                        
                        eventFunction.bindTargetSales(data.d);
                        break;
                    case 1:
                        jAlert('Saved Successfully', "Information!!", function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        break;
                    case 2:
                        eventFunction.bindSalesDetails(data.d);
                        break;
                   
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
           
            getTargetSales: function (date) {
                eventFunction.config.method = "getTargetSales";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.config.data = JSON2.stringify({ date: date });
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindTargetSales: function (data) {
                if (data.length > 0) {
                    $("#btnPrint").show();
                }
                var abc = "";
                var htmls = "";
                $(".TargetSales").html(htmls);
                $("#sales").html(abc);
                var sn = 1;
                var todaysales = 0;
                var topitem = "";
                var totsales = 0;
                var years = 0;
                var avgsales = 0;
                var date = $('#targetdate').val().split("-")[0];
                abc += '<table border="1" style="display:block;"><tr><td><label>Date : </label></td><td><span id="datetarget"></span></td>';
                abc += '<td><label>Target Sales : </label></td><td><span id="targetsale"></span></td></tr></table>';
                $(".TargetSales").append(abc);
                $.each(data, function (index, value) {
                    if (value.Dates.split(" ")[2] == date) {
                        document.getElementById('datetarget').innerHTML = value.Dates.split(" ")[0] + ' ' + value.Dates.split(" ")[1];
                        todaysales = value.TotalSales;
                        topitem = value.TopItem + ' (' + value.Quantity + ')';
                    }
                    
                });
                 
                $.each(data, function (index, value) {
                        //if (value.TotalSales != "" && value.TotalSales != null) {
                    htmls += '<table border="1" class="sfGridwrapper tableForlist" style="display:block;width:50%;">';
                    htmls += '<tr><td>Year : </td><td>' + value.Dates.split(" ")[2] + '</td></tr>';
                    if (value.Dates.split(" ")[2] == (date)) {
                        htmls += '<tr><td>Total Sales : </td><td><label id="salesondate">' + value.TotalSales + '</label></td></tr>';
                    } else {
                        htmls += '<tr><td>Total Sales : </td><td>' + value.TotalSales + '</td></tr>';
                        if (value.TotalSales != "" && value.TotalSales != null) {
                            totsales = parseFloat(totsales) + parseFloat(value.TotalSales);
                        }
                        years = years + 1;
                    }
                    //    if (parseFloat(todaysales) < parseFloat(value.TotalSales)) {
                    //        htmls += '<td style="Color:red;">Todays Sales : ' + todaysales + '</td></tr>';
                    //    }
                    //    else {
                    //        htmls += '<td style="Color:green;">Todays Sales : ' + todaysales + '</td></tr>';
                    //    }
                    //}
                    htmls += "<tr><td>Highest Item Sales : </td><td>";
                    $.each(value.SalesItems, function (index, datas) {
                        htmls += '' + datas.CostCenterName + ': ' + datas.TopItem + ' (' + datas.Quantity + ')';
                    });
                    //htmls += "</td></tr><tr><td'><label id='" + value.Dates + "_"+ value.TotalSales + "' class='sfBtn viewDetails'>View Details</label></td><td>";
                    htmls += '</td></tr><tr><td></td><td><label id="' + value.Dates + '_'+ value.TotalSales + '" class="sfBtn viewDetails">View Details</label>';
                    htmls += '</td></tr></table>';
                        //}
                });
                avgsales = totsales / years;
                document.getElementById('targetsale').innerHTML = avgsales;
                
                $(".TargetSales").append(htmls);
                if (avgsales > todaysales) {
                    document.getElementById('salesondate').style.color = 'red';
                } else {
                    document.getElementById('salesondate').style.color = 'green';
                }

                $(".viewDetails").on('click', function () {
                    var datas = $(this).attr('id').split('_');
                    var htmls = "";
                    $("#divForSalesAnalytics").html(htmls);

                    htmls += "<label>Date: " + datas[0];
                    htmls += "</label></br><label>Total Sales: " + datas[1];
                    $("#divForSalesAnalytics").html(htmls);

                    eventFunction.config.method = "getSalesDetailsByDate";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ date: datas[0] });
                    eventFunction.config.ajaxCallMode = 2;
                    eventFunction.ajaxCall(eventFunction.config);
                });
                
            },
            bindSalesDetails: function (data) {
                var htmls = "";
                var sn = 1;
                htmls += '<table class="sfGridwrapper tableFordetails"><thead><tr><th class="sfEdit">S.N.</th><th>Cost Center</th><th>Item Name</th><th>Quantity</th><th>Rate</th><th>Net Amount</th><th>Is Cumbo</th></tr></thead><tbody>'
                $.each(data, function (index, value) {
                    htmls += '<tr><td>' + sn + '</td>';
                    htmls += '<td>' + value.CostCenterName + '</td>';
                    htmls += '<td>' + value.ITName + '</td>';
                    htmls += '<td>' + value.QTY + '</td>';
                    htmls += '<td>' + value.rate + '</td>';
                    htmls += '<td>' + value.NetAmount + '</td>';
                    htmls += '<td>' + value.IsCombo + '</td></tr>';
                    sn++;
                });
                htmls += '</tbody></table>';
                $("#divForSalesAnalytics").append(htmls);
                $(".tableFordetails").dataTable();

                $("#divForSalesAnalytics").dialog({
                    'title': 'Sales Analytics',
                    width: 1000,
                    dialogClass : 'popup-titlebg',
                });
            },
            Reset: function () {
                window.location.reload();
            },
           
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);