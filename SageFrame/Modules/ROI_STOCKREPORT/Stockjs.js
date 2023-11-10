function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#DailyReport').clone();
    $('#printedDate').hide();
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    frameDoc.document.write('<html><head><title></title>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents.get(0).innerHTML);
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
                ModulePath: '/Modules/RoiPurchase/'
            }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;

        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "PurchaseWebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {

                $("#txtMonthlyDate").datepicker({
                    dateFormat: 'yy-m',
                });

                $(".hide").hide();

                for (i = new Date().getFullYear(); i > 2014; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }
                eventFunction.GetStore();
            },
            init: function () {

                eventFunction.InitialSetup();
                //----------------------------------------Master----------------

                $("#waiter").on('click', function () {

                    if (waiter == 0) {
                        waiter = 1;
                    }
                    else {
                        waiter = 0;
                    }
                });
                $("#table").on('click', function () {

                    if (table == 0) {
                        table = 1;
                    }
                    else {
                        table = 0;
                    }
                });
                $("#room").on('click', function () {

                    if (room == 0) {
                        room = 1;
                    }
                    else {
                        room = 0;
                    }
                });

                $("#btnView").on('click', function () {
                    eventFunction.stockreport();
                    $('.report-view').show();
                });

                //--------------------------Export To PDF----------------

                //--------------------------Print PDF----------------

                $('#btnPrint').on('click', function () {
                    Print();
                });

                //--------------------------Export To EXCEL----------------

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var contents = $('#DailyReport').clone();
                    let file = new Blob([contents.get(0).innerHTML], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "Stock Report_.xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    var contents = $('#DailyReport');
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML(contents, 0, 0, options, function () {
                        pdf.save('SalesReport_.pdf');
                    });
                    $('#printedDate').hide();

                });

                $('#DailyReport').on('click', '.btnStockDetail', function () {
                    var itemid = $(this).attr('id');
                    var storeId = $('#ddlStore').val();

                    $('#divItemledger').html('');

                    $('#StockDetailView').dialog({
                        'title': 'Stock Details ',
                        width: '90%',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'center'],
                        dialogClass: 'popup-titlebg',
                    });

                    var detail = itemid + '_' + storeId;
                    $('#txtDetailHidden').attr('data-detail', detail);
                });

                $('#StockDetailView').on('click', '#btnDetailView', function () {
                    var itemId = ($('#txtDetailHidden').attr('data-detail')).split('_')[0];
                    var storeId = ($('#txtDetailHidden').attr('data-detail')).split('_')[1];

                    var obj = {};
                    obj.ItemId = itemId;
                    obj.StoreId = storeId;
                    obj.StartDate = $('#txtDetailStartDate').val();
                    obj.EndDate = $('#txtDetailEndDate').val();
                    eventFunction.GetStockDetailByItem(obj);
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
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 2:
                        eventFunction.BindStore(data.d);
                        break;
                    case 3:
                        eventFunction.BindStockDetails(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            GetStore: function () {
                eventFunction.config.method = "getIssueToDDl";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetStockDetailByItem: function (obj) {
                eventFunction.config.method = "getStockDetailByItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ obj: obj });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindStockDetails: function (data) {
                var ledger = JSON.parse(data);

                var salesQuantity = 0.0;
                var salesReturnQuantity = 0.0;
                var purchaseQuantity = 0.0;
                var openingQty = 0.0;
                var complimentryQty = 0.0;
                var issueQty = 0.0;
                var adjustmentQuantity = 0.0;

                var htmls = "";
                var htmls = "<table id='Brandtable' class='reportsprint' style='width: 100%' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Date</th><th>Item Name</th><th>Opening Qty </th><th> Purchase Qty </th><th> Sales Qty </th><th> Return Qty </th><th> Adjust Qty </th><th> Complementry Qty </th><th> Issue Qty </th><th> Balance</th><th> Unit Description</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (ledger.length > 0) {
                    htmls += "<tbody>"
                    $.each(ledger, function (index, value) {

                        salesQuantity += (value.SalesQty == null ? 0 : value.SalesQty);
                        purchaseQuantity += (value.PurchaseQty == null ? 0 : value.PurchaseQty);
                        openingQty += (value.OpeningQty == null ? 0 : value.OpeningQty);
                        complimentryQty += (value.ComplementQty == null ? 0 : value.ComplementQty);
                        issueQty += (value.IssueQty == null ? 0 : value.IssueQty);
                        adjustmentQuantity += (value.AdjustQty == null ? 0 : value.AdjustQty);
                        salesReturnQuantity += (value.SalesReturnQty == null ? 0 : value.SalesReturnQty);

                        htmls += "<tr>";
                        htmls += "<td>" + value.TransactionDate.split('T')[0] + "</td>";
                        htmls += "<td>" + value.ITCode + "</td>";
                        if (value.OpeningQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + formatNumber(value.OpeningQty, false) + "</td>";
                        }
                        if (value.PurchaseQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + formatNumber(value.PurchaseQty, false) + "</td>";
                        }
                        if (value.SalesQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>(" + formatNumber(value.SalesQty) + ")</td>";
                        }
                        if (value.SalesReturnQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + formatNumber(value.SalesReturnQty, false) + "</td>";
                        }
                        if (value.AdjustQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + formatNumber(value.AdjustQty, false) + "</td>";
                        }
                        if (value.ComplementQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>(" + formatNumber(value.ComplementQty, false) + ")</td>";
                        }
                        if (value.IssueQty == null) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + (value.IssueQty) + "</td>";
                        }

                        if (value.ItemBalance == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + formatNumber(value.ItemBalance) + "</td>";
                        }
                        htmls += "<td>" + value.Symbol + "</td>";

                        htmls += "</tr>"
                    });
                    htmls += "</tbody>";
                    htmls += `<tr style='font-weight: bold' ><td></td><td>Total</td><td>${formatNumber(openingQty, false)}</td>
                    <td>${formatNumber(purchaseQuantity, false)}</td><td>${formatNumber(salesQuantity, false)}</td>
                    <td>${formatNumber(salesReturnQuantity, false)}</td><td>${formatNumber(adjustmentQuantity, false)}</td>
                                <td>${formatNumber(complimentryQty, false)}</td><td>${formatNumber(issueQty, false)}</td><td></td>
                                <td></td></tr>`;
                }
                else {
                    $('#divItemledger').html('No data');
                }
                htmls += "</table>";
                $('#divItemledger').html(htmls);
            },

            BindStore: function (data) {
                datas = JSON.parse(data);
                var htmls = "";
                htmls = "<option value='0' selected> --All-- </option>";
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });
                    $("#ddlStore").html(htmls);
                }
            },

            stockreport: function () {
                var storeID = $("#ddlStore").val();
                var searchText = $("#txtSearchText").val();
                eventFunction.config.method = "stockreport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ storeID: storeID, searchText: searchText });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            stockreportDaily: function () {
                var valuedate = $("#txtStartDate").val();
                eventFunction.config.method = "stockreportdaily";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ TodayDate: valuedate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            stockreportWeekly: function () {
                var valuedate = $("#txtStartDate").val();

                eventFunction.config.method = "stockreportWeekly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ TodayDate: valuedate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            stockreportMonthly: function () {
                var year = $("#seit").val();
                var month = $("#month").val();
                eventFunction.config.method = "stockreportMonthly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, month: month });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            stockreportYearly: function () {
                var year = $("#seit").val();
                eventFunction.config.method = "stockreportYear";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            stockreportRange: function () {
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtToDate").val();
                eventFunction.config.method = "stockreportRange";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ StartDate: StartDate, EndDate: EndDate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>> 
            BindSalesDaily: function (data) {
                $("#DailyReport").show();
                $("#DailyReport").html('');

                var storeid = $('#ddlStore').val();
                var totalStockValue = 0.00;
                datas = JSON.parse(data);
                var htmls = "<table id='salseReport' class='reportsprint' cellspacing='0' style='border:none;width:100%;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>ItemName</th><th class='table'>Stocks</th><th class='table'>Stock Value</th>";
                if (storeid != 0) {
                    htmls += "<th>Action</th>";
                }
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + (index + 1) + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + formatNumber(value.CLBal, false) + " (" + value.Symbol + ")</td>";
                        htmls += "<td>" + formatNumber(value.TotalValue) + " (Rs)</td>";
                        if (storeid != 0) {
                            htmls += "<td><label id='" + value.ITId + "' class='btnStockDetail  view icon-preview'></label></td>";
                        }
                        htmls += "</tr>"
                        totalStockValue += parseFloat((parseInt(value.TotalValue * 100) / 100)); // proper decimal places for value like: -1.5845632502852868e+29
                        console.log('datas value.TotalValue', value.TotalValue);
                        console.log('datas totalStockValue', totalStockValue);
                    });
                    console.log('totalStockValue', totalStockValue);
                    htmls += "<tr><td colspan='3' style='text-align:right;'><strong>Total Stock Value: </strong></td><td><strong>" + formatNumber(totalStockValue) + " (Rs)</strong></td></tr>";
                } else {
                    htmls += "<tr><td></td>";
                    htmls += "<td>No data</td><td></td></tr>";
                }
                htmls += "</tbody>";
                htmls += "</table>";

                $('#DailyReport').html(htmls);
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#textUnit').val('');
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        //StoreItem
                        textUnit: {
                            required: true,
                        },
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
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);