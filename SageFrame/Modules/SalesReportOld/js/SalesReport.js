
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&
        (charCode < 48 || charCode > 57)) {
        return false;
    }
    if ($(element).val().indexOf('.') != -1 && $(element).val().split('.')[1].length >= 2) {
        return false;
    }

    return true;
}

function Print() {
    $('#printedDate').show();
    $('#reportDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#ReservationReport').html();
    $('#printedDate').hide();
    $('#reportDate').hide();
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
    $.companyDashboardcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/SalesReportOld/',
                 HostUrl: '',
                 TypeId: '',
                 Username: '',
             }, p);
        var v = 0;
       
        var DashboardFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 
                dataType: 'json',
                baseURL: p.ModulePath + "SalesReportService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            init: function () {
                
                $("#btnView").on('click', function () {
                    $(".report-view").show();
                    DashboardFunction.GetSalesOldReport();

                });

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#ReservationReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "salesReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#ReservationReport"), 0, 0, options, function () {
                        pdf.save('salesReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });

            },

            ajaxCall: function (config) {
                $.ajax({
                    type: DashboardFunction.config.type,
                    contentType: DashboardFunction.config.contentType,
                    async: DashboardFunction.config.async,
                    cache: DashboardFunction.config.cache,
                    url: DashboardFunction.config.url,
                    data: DashboardFunction.config.data,
                    dataType: DashboardFunction.config.dataType,
                    success: DashboardFunction.ajaxSuccess,
                    error: DashboardFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(DashboardFunction.config.ajaxCallMode)) {
                    
                    case 1:
                        DashboardFunction.BindSalesOldReport(data.d);
                        break;
                    
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            
            GetSalesOldReport: function () {
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtEndDate").val();
                DashboardFunction.config.method = "getSalesReportOld";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    StartDate: StartDate, EndDate: EndDate
                });
                DashboardFunction.config.ajaxCallMode = 1;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            BindSalesOldReport: function (result) {
                datas = JSON.parse(result);
                datas = datas.Table;

                $('#ReservationReport').show();
                $("#ReservationReport").html();
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Sales Report </p> <p style="text-align:center;margin:0;">From: ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val()) + ' To: ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='tableFor' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += `
                            <th>Fiscal Year</th>
                            <th>Bill Date</th>
                            <th>Bill No</th>
                            <th>Customer Name</th>
                            <th>Sub Total</th>
                            <th>Discount</th>
                            <th>Service Charge</th>
                            <th>Taxable Amount</th>
                            <th>Tax Amount</th>
                            <th>Grand Total</th>
                            `;
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>";

                var sub_total = 0.0;
                var discount = 0.0;
                var service_charge = 0.0;
                var taxable_amount = 0.0;
                var tax_amount = 0.0;
                var grand_total = 0.0;

                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        
                        htmls += "<tr>";
                        htmls += "<td>" + value.fiscal_year + "</td>";
                        htmls += "<td>" + value.date_of_sale + "</td>";
                        htmls += "<td>" + value.bill_no + "</td>";
                        htmls += "<td>" + value.customer_name + "</td>";
                        htmls += "<td>" + value.sub_total + "</td>";
                        htmls += "<td>" + value.discount + "</td>";
                        htmls += "<td>" + value.service_charge + "</td>";
                        htmls += "<td>" + value.taxable_amount + "</td>";
                        htmls += "<td>" + value.tax_amount + "</td>";
                        htmls += "<td>" + value.grand_total + "</td>";
                       
                        htmls += "</tr>"

                        sub_total += value.sub_total;
                        discount += value.discount;
                        service_charge += value.service_charge;
                        taxable_amount += value.taxable_amount;
                        tax_amount += value.tax_amount;
                        grand_total += value.grand_total;
                    });

                    htmls += "<tr>";
                    htmls += "<th colspan='3' > </th>";
                    htmls += "<th style='text-align:center;'>Total </th>";
                    htmls += "<th>" + sub_total.toFixed(2) + "</th>";
                    htmls += "<th>" + discount.toFixed(2) + "</th>";
                    htmls += "<th>" + service_charge.toFixed(2) + "</th>";
                    htmls += "<th>" + taxable_amount.toFixed(2) + "</th>";
                    htmls += "<th>" + tax_amount.toFixed(2) + "</th>";
                    htmls += "<th>" + grand_total.toFixed(2) + "</th>";

                    htmls += "</tr>"

                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='10' style='text-align:center;'> No Data Available</td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "</table>";

                $('#ReservationReport').html(htmls);

      
               
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        DateTime: {
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
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);
