function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Admin/DashboardSummary/WebServices/'
             }, p);
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsDashboardSummary.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },
            InitialSetup: function () {
                eventFunction.getSalesChart();
            },
            init: function () {
                eventFunction.InitialSetup();

                $('#btnGenDayClosingRprt').on('click', function () {
                    eventFunction.GenerateDayClosingReport();
                });
                $('#txtCashSettlement').on('keyup', function () {
                    $('#txtClosingBalance').val((parseFloat($('#txtCashInCounter').val()) - parseFloat($('#txtCashSettlement').val())).toFixed(2));
                });
                $('#btnCloseDay').on('click', function () {
                    eventFunction.CloseTheDay();
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
                    
                    case 2:
                        eventFunction.SalesChart(data.d);
                        break;
                    case 6:
                        if(data.d != null && data.d != "")
                            eventFunction.BindDayClosingData(data.d);
                        else
                            jAlert("There is no data.", "Information!!");
                        break;
                    case 7:
                        $("#divCloseDay").dialog('close');
                        jAlert("The Day has been closed.", "Information!!");
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            getSalesChart: function () {
                eventFunction.config.method = "getSalesChart";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SalesChart: function (d) {
				 if (d.length > 0) {
                var data = [[], [], [], [], []];
                var data2 = [[]];
                for (var i = 0; i < d.length; i++) {
                    data2[0].push([d[i].Bill_Date.split(' ')[0], parseFloat(d[i].NoOfBill)]);
                    data[0].push([d[i].Bill_Date.split(' ')[0], parseFloat(d[i].Amount)]);
                    data[1].push([d[i].Bill_Date.split(' ')[0], parseInt(d[i].Discount)]);
                    data[2].push([d[i].Bill_Date.split(' ')[0], parseInt(d[i].ServiceCharge)]);
                    data[3].push([d[i].Bill_Date.split(' ')[0], parseInt(d[i].TaxableAmount)]);
                    data[4].push([d[i].Bill_Date.split(' ')[0], parseInt(d[i].Tax_Amount)]);
                    //  [[[1, 2], [3, 5.12], [5, 13.1], [7, 33.6], [9, 85.9], [11, 219.9]]]
                }
                $.jqplot('chart1', data, {
                    title: 'Monthly Sales',
                    legend: {
                        show: true,
                        placement: 'outside'
                    },
                    axesDefaults: {
                        rendererOptions: {
                            baselineWidth: 1.5,
                            baselineColor: '#444444',
                            drawBaseline: false

                        }
                    },
                    grid: {
                        background: 'rgba(57,57,57,0.0)',
                        drawBorder: false,
                        shadow: false,
                        gridLineColor: '#f2f2f2',
                        gridLineWidth: 2
                    },
                    shadow: false,
                    shadowDepth: false,
                    axes: {
                        xaxis: {
                            renderer: $.jqplot.DateAxisRenderer,
                            tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                            tickOptions: {
                                formatString: "%b %e",
                                angle: -30,
                                textColor: '#424242'
                            },
                            tickInterval: "3 days",
                            drawMajorGridlines: false,
                            drawMinorGridlines: true,
                            rendererOptions: {
                                tickInset: 0.5,
                                minorTicks: 1
                            }
                        },
                        yaxis: {
                            pad: 0,
                            rendererOptions: {
                                minorTicks: 1
                            },
                            tickOptions: {
                                formatString: "%'d",
                                showMark: false
                            }
                        }
                    }, animate: true, animateReplot: true,
                    highlighter: {
                        show: true,
                        showLabel: true,
                        tooltipAxes: 'y',
                        sizeAdjust: 7.5, tooltipLocation: 'ne'
                    },
                    // Will anima
                    series: [
                        {
                            lineWidth: 1,
                            label: 'Amount',
                            shadow: false,
                            //fill:true,
                        },
                        {
                            lineWidth: 1,
                            label: 'Discount',
                        },
                            {
                                lineWidth: 1,
                                label: 'ServiceCharge',
                            },
                            {
                                lineWidth: 1,
                                label: 'TaxableAmount',
                            },
                            {
                                lineWidth: 1,
                                label: 'Tax_Amount',
                            },

                    ]
                });

                $.jqplot('chart2', data2, {
                    title: 'No of Bills',
                    legend: {
                        show: true,
                        placement: 'outside'
                    },

                    axesDefaults: {
                        rendererOptions: {
                            baselineWidth: 1.5,
                            baselineColor: '#444444',
                            drawBaseline: false

                        }
                    },
                    grid: {
                        background: 'rgba(57,57,57,0.0)',
                        drawBorder: false,
                        shadow: false,
                        gridLineColor: '#f2f2f2',
                        gridLineWidth: 2
                    },
                    shadowDepth: false,
                    axes: {
                        xaxis: {
                            renderer: $.jqplot.DateAxisRenderer,
                            tickRenderer: $.jqplot.CanvasAxisTickRenderer,
                            tickOptions: {
                                formatString: "%b %e",
                                angle: -30,
                                textColor: '#424242'
                            },
                            tickInterval: "3 days",
                            drawMajorGridlines: false,
                            drawMinorGridlines: true,
                            rendererOptions: {
                                tickInset: 0.5,
                                minorTicks: 1
                            }
                        },
                        yaxis: {
                            pad: 0,
                            rendererOptions: {
                                minorTicks: 1
                            },
                            tickOptions: {
                                formatString: "%'d",
                                showMark: false
                            }
                        }
                    }, animate: true, animateReplot: true,
                    highlighter: {
                        show: true,
                        showLabel: true,
                        tooltipAxes: 'y',
                        sizeAdjust: 7.5, tooltipLocation: 'ne'
                    },
                    // Will anima
                    seriesDefaults: {
                        rendererOptions: {
                            smooth: true,
                            //animation: {
                            //    show: true
                            //}
                        },
                        //showMarker: false
                    },
                    series: [
                        {
                            lineWidth: 1,
                            label: 'No of Bills',
                            shadow: false,
                            fill: true,
                        }

                    ]
                });
                $('.jqplot-highlighter-tooltip').addClass('ui-corner-all');
				 } else {
                    $('#chart1').html("NO data");
                    $('#chart2').html("NO data");
                }

            },
           
            GenerateDayClosingReport: function () {
                eventFunction.config.method = "GenerateDayClosingReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindDayClosingData: function (result) {
                if (result.IsClosed) {
                    jAlert("The Day has already been closed", "Information!!", function () {
                        $.alerts.dialogClass = null;
                    });
                }
                else {
                    $('#hdfFinancialID').val(result.FinancialID);
                    $('#hdfPeriod').val(result.Period);
                    $('#txtOpeningBal').val(result.OpeningBalance);
                    $('#txtCash').val(result.Cash);
                    $('#txtCheque').val(result.Cheque);
                    $('#txtCard').val(result.Card);
                    $('#txtCredit').val(result.Credit);
                    $('#txtTotalCashReceived').val(result.TotalCashReceived);
                    $('#txtSurplusDeficit').val(result.SurplusDeficit);
                    $('#txtCreditCollected').val(result.CreditCollected);
                    $('#txtCashInCounter').val(result.CashInCounter);
                    $('#txtCashSettlement').val(result.CashSettlement);
                    $('#txtClosingBalance').val(result.ClosingBalance);

                    var date = new Date();
                    $('#divCloseDay').dialog({
                        'title': 'Close Day : ' + (date.getMonth() + 1) + '-' + date.getDate() + '-' + date.getFullYear(),
                        width: 800,
                        modal: true,
                        resizable: true,
                         dialogClass: 'popup-titlebg',
                         "jQueryUI": true,
                    });
                }
            },
            CloseTheDay: function () {
                var financialID = $('#hdfFinancialID').val();
                var splitdate = $('#hdfPeriod').val().split(' ')[0].split('/');
                var cashSettlement = parseFloat($('#txtCashSettlement').val());
                var formattedMomth = ("0" + splitdate[0]).slice(-2);
                var formattedDay = ("0" + splitdate[1]).slice(-2);
                var period = String(splitdate[2]) + String(formattedMomth) + String(formattedDay);

                eventFunction.config.method = "CloseTheDay";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ financialID: financialID, period: period, cashSettlement: cashSettlement })
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
