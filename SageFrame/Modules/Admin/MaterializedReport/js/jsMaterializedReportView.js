(function ($) {
    //var tabs = $("#tabs").tabs();
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Admin/MaterializedReport/service/',
                 master: '0',
                 CompanyName: '',
                 Address: '',
                 PhoneNo: '',
                 Pan: ''
             }, p);
        var v = 0;
        var DiffAmount = 0;
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
                baseURL: p.ModulePath + "WSforMaterializedView.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0


            },
            InitialSetup: function () {
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnView").click(function () {
                    eventFunction.getDataByDates();
                      $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    let file = new Blob([$('#DailyReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "MaterializeView_From_" + $('#txtStartDate').val() + '_To_' + $('#txtEndDate').val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                });
                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#DailyReport').html();
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
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#DailyReport"), 0, 0, options, function () {
                        pdf.save('MaterializeView_From_' + $('#txtStartDate').val() + '_To_' + $('#txtEndDate').val() + '.pdf');
                    });

                });

            },

            getDataByDates: function () {
                var startdate = BS2AD($('#txtStartDate').val());
                var enddate = BS2AD($('#txtEndDate').val());
                eventFunction.config.method = "getDataByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindDataByDates: function (result) {
                var datas = result.d;
                // if (!datas) return;
                var htmls = [];
                var index = 0;
                var a = 0;
                var d = 0;
                var sc = 0;
                var tba = 0;
                var ta = 0;
                var tta = 0;
                
                    htmls[index++]= '<div class="cbms-header">';
                    htmls[index++] = '<h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                    htmls[index++] = '<p style="text-align:center;margin:0;">' + companyInfo.Address + ', PAN: ' + companyInfo.PAN + '</p>';
                    htmls[index++] = '<p style="text-align:center;margin:0;">Materialized Report </p>';
                    htmls[index++] = '<p style="text-align:center;margin:0;">From: ' + $('#txtStartDate').val() + ' &nbsp; &nbsp; To: ' + $('#txtEndDate').val() + '</p>';
                    htmls[index++] = '<p id="printedDate" style="display:none;text-align:center;margin:0;">Printed On : <label id="lblPrintedOn"></label></p>';
                    htmls[index++] = '</div>';
                htmls[index++] = '<table class="tableForMaterizedView sfGridwrapper reportsprint report_XL display" cellspacing="0" style="width:100%;border:none;border-collapse:collapse;"><thead><tr><th style="border:1px solid #575757;text-align:center;">FiscalYear</th><th style="border:1px solid #575757;text-align:center;">Bill_No</th><th style="border:1px solid #575757;text-align:center;">Customer_Name</th><th style="border:1px solid #575757;text-align:center;">Customer_PAN</th><th style="border:1px solid #575757;text-align:center;">Bill_Date</th><th style="border:1px solid #575757;text-align:center;">Amount</th><th style="border:1px solid #575757;text-align:center;">Discount</th><th style="border:1px solid #575757;text-align:center;">ServiceCharge</th><th style="border:1px solid #575757;text-align:center;">TaxableAmount</th><th style="border:1px solid #575757;text-align:center;">Tax_Amount</th><th style="border:1px solid #575757;text-align:center;">Total Amount</th><th style="border:1px solid #575757;text-align:center;">Sync with IRD</th><th style="border:1px solid #575757;text-align:center;">Is_Printed</th><th style="border:1px solid #575757;text-align:center;">Is_bill_Active</th><th style="border:1px solid #575757;text-align:center;">Print_Count</th><th style="border:1px solid #575757;text-align:center;">Last_Printed</th><th style="border:1px solid #575757;text-align:center;">Entered_by</th><th style="border:1px solid #575757;text-align:center;">Printed_by</th><th style="border:1px solid #575757;text-align:center;">Is_realtime</th></tr></thead><tbody>';
                    if (datas.length > 0) {
                    for (var i = 0; i < datas.length; i++) {
                        //htmls[index++] = '<tr class="' + (datas[i].Is_Active ? 'activebill' : 'inactivebill') + '" style="border-bottom:1px solid #575757;padding:2px;' + (datas[i].Is_Active ? '' : 'text-decoration: line-through;') + '"><td style="border:1px solid #575757;padding:2px;">' + datas[i].FiscalYear + '</td>';
                        htmls[index++] = '<tr class="' + datas[i].salesMasterId + '" style="border-bottom:1px solid #575757;padding:2px;' + (datas[i].Is_Active ? '' : '') + '"><td style="border:1px solid #575757;padding:2px;">' + datas[i].FiscalYear + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Bill_No + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Customer_Name + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Customer_PAN + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Bill_Date.split('.').join('/') + '</td>';
                        htmls[index++] = '<td style="text-align:right;padding:2px;border:1px solid #575757;">Rs. ' + datas[i].AMOUNT.toFixed(2) + '</td>';
                        htmls[index++] = '<td style="text-align:right;padding:2px;border:1px solid #575757;">Rs. ' + datas[i].Discount.toFixed(2) + '</td>';
                        htmls[index++] = '<td style="text-align:right;padding:2px;border:1px solid #575757;">Rs. ' + datas[i].ServiceCharge.toFixed(2) + '</td>';
                        htmls[index++] = '<td style="text-align:right;padding:2px;border:1px solid #575757;">Rs. ' + datas[i].TaxableAmount.toFixed(2) + '</td>';
                        htmls[index++] = '<td style="text-align:right;padding:2px;border:1px solid #575757;">Rs. ' + datas[i].Tax_Amount.toFixed(2) + '</td>';
                        htmls[index++] = '<td style="text-align:right;padding:2px;border:1px solid #575757;">Rs. ' + (datas[i].TaxableAmount + datas[i].Tax_Amount).toFixed(2) + '</td>';
                        htmls[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (datas[i].SyncWithIRD ? 'Y' : 'N') + '</td>';
                        htmls[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (datas[i].Is_Printed ? 'Y' : 'N') + '</td>';
                        htmls[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (datas[i].Is_Active ? 'Y' : 'N') + '</td>';
                        //printedDate = value.Printed_Time.split(' ')[0].split('/');
                        //nepali_printedDate = AD2BS(printedDate[2] + '-' + printedDate[0] + '-' + printedDate[1]);
                        //htmls += '<td>' + nepali_printedDate + ' ' + value.Printed_Time.split(' ')[1] + ' ' + value.Printed_Time.split(' ')[2] + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].PrintCount + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Printed_Time + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Entered_by + '</td>';
                        htmls[index++] = '<td style="border:1px solid #575757;padding:2px;">' + datas[i].Printed_by + '</td>';
                        htmls[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (datas[i].SyncWithIRD ? datas[i].isrealtime : 'N') + '</td>';
                        htmls[index++] = '</tr>';
                        if (datas[i].Is_Active == true) {
                            a += datas[i].AMOUNT;
                            d += datas[i].Discount;
                            sc += datas[i].ServiceCharge;
                            tba += datas[i].TaxableAmount;
                            ta += datas[i].Tax_Amount;
                            tta += (datas[i].TaxableAmount + datas[i].Tax_Amount)
                        }
     
                    }
                    htmls[index++] = '</tbody><tfoot><tr><th colspan="5" style="text-align:right;border:1px solid #575757;padding:2px; ">Total :</th>';
                    htmls[index++] = '<th class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + a.toFixed(2) + '</th>';
                    htmls[index++] = '<th class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + d.toFixed(2) + '</th>';
                    htmls[index++] = '<th class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + sc.toFixed(2) + '</th>';
                    htmls[index++] = '<th class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + tba.toFixed(2) + '</th>';
                    htmls[index++] = '<th class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + ta.toFixed(2) + '</th>';
                    htmls[index++] = '<th class="tot-rig" style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ' + tta.toFixed(2) + '</th>';
                        htmls[index++] = '<th colspan="7" style="text-align:right;border:1px solid #575757;padding:2px;"></th>';
                        htmls[index++] = '<th colspan="7" style="text-align:right;border:1px solid #575757;padding:2px;"></th>';
                    htmls[index++] = '</tr></tfoot></table>';
                    $("#DailyReport").html(htmls.join(" "));

                    } else {
                        htmls[index++] = '<tr>';
                        htmls[index++] = '<td colspan="18" style="text-align:center;border:1px solid #575757;">No data Available</td>';
                        htmls[index++] = '</tr>';

                        $("#DailyReport").html(htmls.join(" "));
                    }

                    $(".tableForMaterizedView tr").dblclick(function () {
                        var ids = $(this).closest('tr').attr('class');
                        eventFunction.GetBill(ids);
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
                        eventFunction.bindDataByDates(data);
                        break;
                 
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            GetBill: function (salesMasterId) {               
                getBill(salesMasterId);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg'
                });
           
            },
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);