(function ($) {
    var tabs = $("#tabs").tabs();
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_CReport/',
                 master: '0',
             }, p);
        var v = 0;
        var DiffAmount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsForCReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0


            },
            InitialSetup: function () {
                eventFunction.getCostCenterlist();
            },
            init: function () {
                    eventFunction.InitialSetup();
                $("#btnView").click(function () {
                    $("#DivForView").show();
                    if ($("input[type=radio][name=option]:checked").val() == 0) {
                        eventFunction.getVaultView();
                        eventFunction.getVaultViewClose();
                    }
                    else {
                        eventFunction.getCounterView();
                        eventFunction.getCounterViewClose();
                    }
                });

                $("input[type=radio][name=option]").change(function () {
                    $("#DivForView").hide();
                });

                $("#selCostCenter").change(function () {
                    //alert( $(this).val());
                    var ids = $(this).val();
                    eventFunction.getNumberOfCounter(ids);
                });
            },

            getNumberOfCounter: function (data) {
                eventFunction.config.method = "getNumberOfCounter";
                eventFunction.config.data = JSON2.stringify({ id: data });
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindNumberOfCounter: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                $.each(data, function (index, value) {
                    a = value.NumberOfCounter;
                });
                htmls += '<option selected disabled value="">-select- </option>';
                for (var i = 1; i <= a; i++) {
                    htmls += "<option value='" + i + "'>" + i + "</option>"
                }
                $("#txtCN").html(htmls);
            },

             getCostCenterlist: function () {
                eventFunction.config.method = "getCostCenterlist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindCostCenterList: function (result) {
                var data = result.d;
                var htmls = "";
                $.each(data, function (index, value) {
                    htmls += "<option value='" + value.CostCenterID + "'>" + value.CostCenterName + "</option>"
                });
                $("#selCostCenter").append(htmls);
            },

            getVaultView: function () {
                date = $("#txtDate").val();
                eventFunction.config.method = "getVaultView";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ date: date });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindVaultView: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                var balance = 0;
                var difference = 0;
                var ApprovedBy = "";
                var IsClosing = "";
                if (data.length > 0) {
                    htmls += "<table id='tableForCounterTotal' class='inventory-table'><thead><tr><th colspan='4' style='background:#FFFFFF;color:#ff9933'>Open Drawer Report: " + $('#txtDate').val() + "</th></tr><tr><th>S.N.</th><th>Note</th><th>Number</th><th>IsCoin</th></tr></thead>";
                    htmls += "<tbody>";
                    $.each(data, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.Note + '</td>';
                        htmls += '<td>' + value.Number + '</td>';
                        htmls += '<td>' + value.IsCoin + '</td></tr>';
                        balance = value.Balance;
                        difference = value.DiffAmount;
                        ApprovedBy = value.ApprovedBy;
                        IsClosing = value.IsClosing;
                    });
                    htmls += "<tr><td></td><td></td><td>Balance</td><td>" + balance + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Difference</td><td>" + difference + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Is Closing</td><td>" + IsClosing + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Approved By</td><td>" + ApprovedBy + "</td></tr>";
                    htmls += "</tbody>";
                    //htmls += "<tfoot>";
                    //htmls += "<tr><th colspan='3' style='text-align:right'>Balance</th><th>" + balance + "</th></tr>";
                    //htmls += "<tr><th colspan='3' style='text-align:right'>Difference</th><th>" + difference + "</th></tr>";
                    //htmls += "<tr><th colspan='3' style='text-align:right'>Is Closing</th><th>" + IsClosing + "</th></tr>";
                    //htmls += "<tr><th colspan='3' style='text-align:right'>Approved By</th><th>" + ApprovedBy + "</th></tr>";
                    //htmls += "</tfoot>";
                    htmls += "</table>";
                } else {
                    htmls+="No Data!"
                }
                $("#DivForView").html(htmls);
                $("#tableForCounterTotal").dataTable({
                    paging: false,
                    ordering: false,
                    searching: false,
                    info:false,
                    dom: 'Bfrtip',

                    buttons: [

                         'print', 'pdf', 'excel'
                    ]

                });
            },

            getVaultViewClose: function () {
                date = $("#txtDate").val();
                eventFunction.config.method = "getVaultViewClose";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ date: date });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindVaultViewClose: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                var balance = 0;
                var difference = 0;
                var ApprovedBy = "";
                var IsClosing = "";
                if (data.length > 0) {
                    htmls += "<table id='tableForCounterTotalClose' class='inventory-table'><thead><tr><th colspan='4' style='background:#FFFFFF;color:#ff9933'>Close Drawer Report: " + $('#txtDate').val() + "</th></tr><tr><th>S.N.</th><th>Note</th><th>Number</th><th>IsCoin</th></tr></thead><tbody>";
                    $.each(data, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.Note + '</td>';
                        htmls += '<td>' + value.Number + '</td>';
                        htmls += '<td>' + value.IsCoin + '</td></tr>';
                        balance = value.Balance;
                        difference = value.DiffAmount;
                        ApprovedBy = value.ApprovedBy;
                        IsClosing = value.IsClosing;
                    });
                    htmls += "<tr><td></td><td></td><td>Balance</td><td>" + balance + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Difference</td><td>" + difference + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Is Closing</td><td>" + IsClosing + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Approved By</td><td>" + ApprovedBy + "</td></tr>";
                    htmls += "</tbody>";
                    htmls += "</table>";
                }
                else {
                    htmls+="No Data!"
                }
                $("#DivForView").append(htmls);
                $("#tableForCounterTotalClose").dataTable({
                    paging: false,
                    ordering: false,
                    searching: false,
                    info: false,
                    dom: 'Bfrtip',

                    buttons: [

                         'print', 'pdf', 'excel'
                    ]
                });
            },


            getCounterView: function () {
                date = $("#txtDate").val();
                counter = $("#selCostCenter").val();
                counterNo = $("#txtCN").val();
                eventFunction.config.method = "getCounterView";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ counter: counter, date: date, counterNo: counterNo });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindCounterView: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                var balance = 0;
                var difference = 0;
                var ApprovedBy = "";
                var IsClosing = "";
                if (data.length > 0) {
                htmls += "<table id='tableForCounterTotal' class='inventory-table'><thead><tr><th colspan='4' style='background:#FFFFFF;color:#ff9933'>Open Counter Report: " + $('#txtDate').val() + "</th></tr><tr><th>S.N.</th><th>Note</th><th>Number</th><th>IsCoin</th></tr></thead><tbody>";
                $.each(data, function (index, value) {
                    a++;
                    htmls += '<tr><td>' + a + '</td>';
                    htmls += '<td>' + value.Note + '</td>';
                    htmls += '<td>' + value.Number + '</td>';
                    htmls += '<td>' + value.IsCoin + '</td></tr>';
                    balance = value.Balance;
                    difference = value.DifAmount;
                    ApprovedBy = value.ApprovedBy;
                    IsClosing = value.IsClosing;
                });
                htmls += "<tr><td></td><td></td><td>Balance</td><td>" + balance + "</td></tr>";
                htmls += "<tr><td></td><td></td><td>Difference</td><td>" + difference + "</td></tr>";
                htmls += "<tr><td></td><td></td><td>Is Closing</td><td>" + IsClosing + "</td></tr>";
                htmls += "<tr><td></td><td></td><td>Approved By</td><td>" + ApprovedBy + "</td></tr>";
                htmls += "</tbody>";
                htmls += "</table>";
                } else {
                    htmls += "No Data!";
                }
                $("#DivForView").html(htmls);
                $("#tableForCounterTotal").dataTable({
                    paging: false,
                    ordering: false,
                    searching: false,
                    info: false,
                    dom: 'Bfrtip',

                    buttons: [

                         'print', 'pdf', 'excel'
                    ]
                });
            },
            getCounterViewClose: function () {
                date = $("#txtDate").val();
                counter = $("#selCostCenter").val();
                counterNo = $("#txtCN").val();
                eventFunction.config.method = "getCounterViewClose";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ counter: counter, date: date, counterNo: counterNo });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindCounterViewClose: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                var balance = 0;
                var difference = 0;
                var ApprovedBy = "";
                var IsClosing = "";
                if (data.length > 0) {
                    htmls += "<table id='tableForCounterTotalClose' class='inventory-table'><thead><tr><th colspan='4' style='background:#FFFFFF;color:#ff9933'>Open Counter Report: " + $('#txtDate').val() + "</th></tr><tr><th>S.N.</th><th>Note</th><th>Number</th><th>IsCoin</th></tr></thead><tbody>";
                    $.each(data, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.Note + '</td>';
                        htmls += '<td>' + value.Number + '</td>';
                        htmls += '<td>' + value.IsCoin + '</td></tr>';
                        balance = value.Balance;
                        difference = value.DifAmount;
                        ApprovedBy = value.ApprovedBy;
                        IsClosing = value.IsClosing;
                    });
                    htmls += "<tr><td></td><td></td><td>Balance</td><td>" + balance + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Difference</td><td>" + difference + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Is Closing</td><td>" + IsClosing + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Approved By</td><td>" + ApprovedBy + "</td></tr>";
                    htmls += "</tbody>";
                    htmls += "</table>";
                } else {
                    htmls += "No Data! For Close Drawer";
                }
                $("#DivForView").append(htmls);
                $("#tableForCounterTotalClose").dataTable({
                    paging: false,
                    ordering: false,
                    searching: false,
                    info: false,
                    dom: 'Bfrtip',

                    buttons: [

                         'print', 'pdf', 'excel'
                    ]
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
                        break;
                    case 1:
                        eventFunction.bindVaultView(data);
                        break;
                    case 2:
                        eventFunction.bindCounterView(data);
                        break;
                    case 3:
                        eventFunction.bindVaultViewClose(data);
                        break;
                    case 4:
                        eventFunction.bindCounterViewClose(data);
                        break;
                    case 5:
                        eventFunction.bindCostCenterList(data);
                        break;
                    case 8:
                        eventFunction.bindNumberOfCounter(data);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },
            reset: function () {

            },

            resetCReport: function () {
            },
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);