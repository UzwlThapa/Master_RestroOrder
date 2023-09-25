function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#SummarySalesReport').html();
    $('#printedDate').hide();
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
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/AdvanceReport/'
             }, p);
        var selectedIndex = 0;
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "AdvanceReportService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
            },
            InitialSetup: function () {
       
                eventFunction.GetRoom();
                eventFunction.GetTable();             
                eventFunction.GetPaymentMode();
                eventFunction.GetCardProvider();
                eventFunction.GetCustomer();

                eventFunction.GetWaiter();
                eventFunction. GetCashier();
              
               
            },
            init: function () {
                eventFunction.InitialSetup();
              


                $("#btnView").click(function () {                 
                    eventFunction.GetSummarySalesReport();
                    $('.report-view').show();
                });

                $('#btnPrint').on('click', function () {
                    Print();
                });

                //--------------------------Export To EXCEL----------------

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var contents = $('#SummarySalesReport').clone();
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').remove();
                    let file = new Blob([contents.get(0).innerHTML], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "SalesSummaryReport_" + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    var contents = $('#SummarySalesReport');
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').hide();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML(contents, 0, 0, options, function () {
                        pdf.save('SalesSummaryReport_' + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + '.pdf');
                    });
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').show();
                    $('#printedDate').hide();

                });

                $("#selroom").on('change', function () {
                    if ($("#selroom").val() == '') {
                        eventFunction.GetTable();
                    }
                    else {
                        var restroRoomId = $("#selroom").val();
                        var ids = restroRoomId.split('_');
                        var id = ids[0];

                        eventFunction.config.method = "getRestroTableByRoomID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({
                            restroRoomId: id
                        });
                        eventFunction.config.ajaxCallMode = 1;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
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
                        eventFunction.BindRoom(data.d);
                        break;

                    case 1:
                        eventFunction.BindTable(data.d);
                        break;

                    case 2:
                        eventFunction.BindPaymentMode(data.d);
                        break;

                    case 3:
                        eventFunction.BindProvider(data.d);
                        break;

                    case 4:
                        eventFunction.BindCustomer(data.d);
                        break;


                    case 5:
                        eventFunction.BindWaiter(data.d);
                        break;

                    case 6:
                        eventFunction.BindCashier(data.d);
                        break;

                    case 7:
                     
                        eventFunction.BindSalesSummaryReport(data.d);
                        break;

                    case 8:
                        eventFunction.BindSummaryReport(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            GetRoom: function () {
               
                eventFunction.config.method = "getRestroRoom";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetTable: function () {
                eventFunction.config.method = "getRestroTable";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPaymentMode: function () {
                eventFunction.config.method = "GetPaymentModes";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCardProvider: function () {
                eventFunction.config.method = "getCardProvider";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },



            GetCustomer: function () {
                eventFunction.config.method = "GetCustomerForReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },



            GetWaiter: function () {
                eventFunction.config.method = "GetWaiterForReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCashier: function () {
                eventFunction.config.method = "GetCashierForReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },


            GetSummarySalesReport: function () {

                if ($("#selroom").val() == '') {
                    var room = $("#selroom").val();
                }
                else {
                    var restroRoomId = $("#selroom").val();
                    var ids = restroRoomId.split('_');
                    var room = ids[1];
                }
            
                var table = $("#seltable").val();
                var invoiceno = $("#txtInvoiceNo").val() == "" ? 0 : $("#txtInvoiceNo").val();
                var customer = $("#selCustomer").val();
                var waiter = $("#selWaiter").val();
                var cashier = $("#selCashier").val();
                var paymentmodeid = $("#selPaymentMode").val() == null ? 0 : $("#selPaymentMode").val();
                var provider = $("#selProviderName").val();
                var datefrom = $("#txtStartDate").val();
                var dateTo = $("#txtEndDate").val();
                var timefrom = $("#txtTimeFrom").val() == null ? 0 : $("#txtTimeFrom").val();
                var timeTo = $("#txtTimeTo").val() == "" ? 24 : $("#txtTimeTo").val();

                eventFunction.config.method = "getSalesSummaryReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    room:room, table:table, invoiceno:invoiceno, customer:customer, waiter:waiter, cashier:cashier, paymentmodeid:paymentmodeid, provider:provider, datefrom:datefrom, dateTo:dateTo, timefrom:timefrom, timeTo:timeTo
                });
                if (paymentmodeid == 0) {
                    eventFunction.config.ajaxCallMode = 7
                }
                else {
                    eventFunction.config.ajaxCallMode = 8
                }
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------Bind Here ---------------------------------------->>

            BindSalesSummaryReport: function (result) {
                $("#SummarySalesReport").show();
                $("#SummarySalesReport").html('');
                saleslist = JSON.parse(result);
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , '+ (companyInfo.IsPan ? 'PAN':'VAT') +' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Cost Center Wise Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';

                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Invoice No</th><th>Bill Date</th><th> Bill No. </th><th> Customer </th><th> Waiter</th><th> Table</th><th> Room</th><th> Cashier</th><th class='tdrate'> Amount </th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (saleslist.length > 0) {
                    var paymentmode = saleslist[0].PaymentMode;
                    $.each(saleslist, function (index, value) {
                        var word = value.BillDate;
                        var date = word.split("T");
                            htmls += "<tr>";
                            htmls += "<td>" + value.InvoiceNo + "</td>";
                            htmls += "<td>" + date[0] + "</td>";
                            htmls += "<td>" + value.BillNo + "</td>";
                            htmls += "<td>" + value.Customer + "</td>";
                            htmls += "<td>" + value.Waiter + "</td>";
                            htmls += "<td>" + value.Table + "</td>";
                            htmls += "<td>" + value.Room + "</td>";
                            htmls += "<td>" + value.Cashier + "</td>";
                            htmls += "<td class='tdrate'>" + value.Amount + "</td>";
                            htmls += "</tr>"
                        });
                }

                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data Available </td>";
                    htmls += '</tr>';
                }
                        htmls += "</tbody>";
                        htmls += "</table>";
                        $('#SummarySalesReport').html(htmls);
                        //$('#Brandtable').DataTable(
                        //     {
                        //         "bJQueryUI": true,
                        //         dom: 'Bfrtip',

                        //         buttons: [

                        //             'print', 'excel', 'pdf'
                        //         ],
                        //     });
               
            },

            BindSummaryReport: function (result) {
                $("#SummarySalesReport").show();
                $("#SummarySalesReport").html('');
                saleslist = JSON.parse(result);
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Cost Center Wise Report From ' + $('#txtStartDate').val() + ' To ' + $('#txtEndDate').val() + '</p>';

                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Invoice No</th><th>Bill Date</th><th> Bill No. </th><th> Customer </th><th> Waiter</th><th> Table</th><th> Room</th><th>Provider Name</th><th>Payment Mode</th><th> Cashier</th><th> Amount </th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (saleslist.length > 0) {
                    var paymentmode = saleslist[0].PaymentMode;
                        $.each(saleslist, function (index, value) {
                            var word = value.BillDate;
                            var date = word.split("T");
                            htmls += "<tr>";
                            htmls += "<td>" + value.InvoiceNo + "</td>";
                            htmls += "<td>" + date[0] + "</td>";
                            htmls += "<td>" + value.BillNo + "</td>";
                            htmls += "<td>" + value.Customer + "</td>";
                            htmls += "<td>" + value.Waiter + "</td>";
                            htmls += "<td>" + value.Table + "</td>";
                            htmls += "<td>" + value.Room + "</td>";
                            htmls += "<td>" + value.ProviderName + "</td>";
                            htmls += "<td>" + value.PaymentMode + "</td>";
                            htmls += "<td>" + value.Cashier + "</td>";
                            htmls += "<td>" + value.Amount + "</td>";
                            htmls += "</tr>"
                        });
                }

                    else {
                    htmls += "<tr>";
                    htmls += "<td colspan='11' style='text-align:center;'> No Data Available </td>";
                    htmls += '</tr>';
                    }
                        htmls += "</tbody>";
                        htmls += "</table>";
                        $('#SummarySalesReport').html(htmls);
                        //$('#Brandtable').DataTable(
                        //     {
                        //         "bJQueryUI": true,
                        //         dom: 'Bfrtip',
                        //         buttons: [
                        //             'print', 'excel', 'pdf'
                        //         ],

                        //     });
                  
                
            },

            BindRoom: function (result) {
                roomlist = JSON.parse(result);
                if (roomlist.length > 0) {
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(roomlist, function (index, value) {
                        htmls += "<option value='" + value.restroRoomId + "_" + value.restroRoom + "'>" + value.restroRoom + "</option>";
                    });

                    $("#selroom").html(htmls);
                }
            },

            BindTable: function (result) {
               tablelist = JSON.parse(result);
                $("#seltable").html('');
                if (tablelist.length > 0) {                
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(tablelist, function (index, value) {
                        htmls += "<option value='" + value.restrotableTitle + "'>" + value.restrotableTitle + "</option>";
                    });

                    $("#seltable").html(htmls);
                }
            },


            BindPaymentMode: function (result) {

                paymentlist = JSON.parse(result)
                if (paymentlist.length > 0) {
                    $("#selPaymentMode").html('');
                    var htmls = "";
                    htmls += "<option value='0' selected>All</option>";
                    $.each(paymentlist, function (index, value) {
                        htmls += "<option value='" + value.PaymentModeID + "'>" + value.PaymentMode + "</option>";
                    });

                    $("#selPaymentMode").html(htmls);
                }
            },
         

            BindProvider: function (result) {

                providerlist = JSON.parse(result);
                if (providerlist.length > 0) {
                    $("#selProviderName").html('');
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(providerlist, function (index, value) {
                        htmls += "<option value='" + value.ProviderName + "'>" + value.ProviderName + "</option>";
                    });

                    $("#selProviderName").html(htmls);
                }
            },

            BindCustomer: function (result) {

                customerlist = JSON.parse(result);
                if (customerlist.length > 0) {
                    $("#selCustomer").html('');
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(customerlist, function (index, value) {
                        htmls += "<option value='" + value.Customer + "'>" + value.Customer + "</option>";
                    });

                    $("#selCustomer").html(htmls);
                }
            },


            BindWaiter: function (result) {

                waiterlist = JSON.parse(result);
                if (waiterlist.length > 0) {
                    $("#selWaiter").html('');
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(waiterlist, function (index, value) {
                        htmls += "<option value='" + value.Waiter + "'>" + value.Waiter + "</option>";
                    });

                    $("#selWaiter").html(htmls);
                }
            },


            BindCashier: function (result) {

                cashierlist = JSON.parse(result);
                if (cashierlist.length > 0) {
                    $("#selCashier").html('');
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(cashierlist, function (index, value) {
                        htmls += "<option value='" + value.Cashier + "'>" + value.Cashier + "</option>";
                    });

                    $("#selCashier").html(htmls);
                }
            },


        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);