
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Reports/'
             }, p);
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var selectedIndex = 0;
        var items = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
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
                eventFunction.GetCostCenter();
                eventFunction.GetTable();
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnView").click(function () {
                    $('.report-view').show();
                    if ($("#selectViewBy").val() == 1)
                    {
                        eventFunction.GetAllOrderDetailReport();
                    }
                    else {
                        eventFunction.GetOrderDetailsReportSummary();
                    }
                   
                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();

                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);

                    let file = new Blob([$('#reportDisplay').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ItemsShiftReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#reportDisplay').html();
                    $('#printedDate').hide();
                    var frame1 = document.createElement('iframe');
                    frame1.name = "frame1";
                    document.body.appendChild(frame1);
                    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
                    frameDoc.document.open();
                    frameDoc.document.write('<html><head><title></title>');
                    frameDoc.document.write('</head><body>');
                    frameDoc.document.write(contents);
                    frameDoc.document.write('</body>');
                    frameDoc.document.close();
                    setTimeout(function () {
                        window.frames["frame1"].focus();
                        window.frames["frame1"].print();
                        document.body.removeChild(frame1);
                    }, 500);
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);

                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#reportDisplay"), 0, 0, options, function () {
                        pdf.save('ItemsShiftReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
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
                        eventFunction.BindAllOrderDetailReport(data.d);
                        break;
                    case 1:
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 2:
                        eventFunction.BindTable(data.d);
                        break;
                    case 3:
                        eventFunction.BindOrderDetailsReportSummary(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetOrderDetailsReportSummary: function () {
                var startDate = $("#txtStartDate").val();
                var endDate = $("#txtEndDate").val();
                var tableid = $("#seltable").val();
                var costCenter = $("#selectFilterBy").val();

                eventFunction.config.method = "getOrderDetailsReportSummary";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    startDate: startDate, endDate: endDate, tableid: tableid, costCenter: costCenter
                });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetAllOrderDetailReport: function () {
                var startDate = $("#txtStartDate").val();
                var endDate = $("#txtEndDate").val();
                var tableid = $("#seltable").val(); 
                var costCenter = $("#selectFilterBy").val();

                eventFunction.config.method = "getAllOrderDetailReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    startDate: startDate, endDate: endDate, tableid: tableid, costCenter: costCenter
                });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },


            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetTable: function () {
                eventFunction.config.method = "getRestroTable";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },


       
            

            //<<-----------------------------Bind Here ---------------------------------------->>


            BindTable: function (result) {
                tablelist = JSON.parse(result);
                $("#seltable").html('');
                var htmls = "";
                htmls += "<option value='0' selected>All</option>";
                $.each(tablelist, function (index, value) {
                    htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                });

                $("#seltable").html(htmls);

            },

            BindCostCenter: function (result) {

                costlist = JSON.parse(result);
                $('#selectFilterBy').html("");
                var htmls = "";

                htmls += "<option value='0' selected>--ALL--</option>";
                $.each(costlist, function (index, item) {
                    htmls += "<option value='" + item.CostCenterID + "'>" + item.CostCenterName + "</option>";
                });
                $('#selectFilterBy').html(htmls);
            },

            BindOrderDetailsReportSummary: function (result) {
                itemlist = JSON.parse(result);

                $("#reportDisplay").html('');
                var htmls = "";
                var ttlQnty = 0;
                var ttlRate = 0;
                var ttlTotal = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Item Shift Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + '   To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;"">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>CostCenter Name</th><th>Item Name </th><th>Quantity </th><th> Rate </th><th>Total</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (itemlist.length > 0) {
                    $.each(itemlist, function (index, value) {

                        htmls += "<tr>";
                        htmls += "<td>" + value.CostCenterName + "</td>";
                        htmls += "<td>" + value.ItemName + "</td>";
                        htmls += "<td style='text-align: left;'>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.Rate + "</td>";
                        htmls += "<td>" + parseFloat(value.Quantity) * parseFloat(value.Rate) + "</td>";
                        htmls += "</tr>"
                        ttlQnty += parseFloat(value.Quantity);
                        ttlRate += parseFloat(value.Rate);
                        ttlTotal += parseFloat(value.Quantity) * parseFloat(value.Rate);
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += "<td colspan='2' style='text-align: center;'>Total: </td>";
                htmls += "<td style='text-align: left;'>" + ttlQnty + "</td>"
                htmls += "<td>" + ttlRate + "</td>"
                htmls += "<td>" + ttlTotal + "</td>"
                htmls += "</tfoot>"
                htmls += "</table>";
            

                $('#reportDisplay').html(htmls);
            

            },


            BindAllOrderDetailReport: function (result) {
                itemlist = JSON.parse(result);

                $("#reportDisplay").html('');
                var htmls = "";
                var ttlQnty = 0;
                var ttlRate = 0;
                var ttlTotal = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Item Shift Report </p> <p style="text-align:center;margin:0;">From: ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val()) + ' To: ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;"">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Date </th><th>Table Name </th><th>CostCenter Name</th><th>Item Name </th><th>Quantity </th><th> Rate </th><th>Total</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (itemlist.length > 0) {
                    $.each(itemlist, function (index, value) {

                        htmls += "<tr>";
                        htmls += "<td>" + value.Date + "</td>";
                        htmls += "<td>" + value.restrotableTitle + "</td>";
                        htmls += "<td>" + value.CostCenterName + "</td>";
                        htmls += "<td>" + value.ItemName + "</td>";
                        htmls += "<td style='text-align: left;'>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.Rate + "</td>";
                        htmls += "<td>" + parseFloat(value.Quantity) * parseFloat(value.Rate) + "</td>";
                        htmls += "</tr>"
                        ttlQnty += parseFloat(value.Quantity);
                        ttlRate += parseFloat(value.Rate);
                        ttlTotal += parseFloat(value.Quantity) * parseFloat(value.Rate);
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += "<td colspan=4 style='text-align: center;'>Total: </td>";
                htmls += "<td style='text-align: left;'>" + ttlQnty + "</td>"
                htmls += "<td>" + ttlRate + "</td>"
                htmls += "<td>" + ttlTotal + "</td>"
                htmls += "</tfoot>"
                htmls += "</table>";
                $('#reportDisplay').html(htmls);


            },

        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);