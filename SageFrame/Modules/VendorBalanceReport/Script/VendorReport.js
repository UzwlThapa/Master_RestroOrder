function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#membeshipformlist').html();
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
                 ModulePath: '/Modules/RoReport/'
             }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0;
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForVendorReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0


            },
            InitialSetup: function () {
                eventFunction.GetCustomer();

                $("#txtMonthlyDate").datepicker({
                    dateFormat: 'yy-m',
                });

               // $("#txtMonthlyDate").datepicker("setDate", new Date());

                $(".hide").hide();

                for (i = new Date().getFullYear() ; i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }

                $('#viewReport').on('click', function () {
                    eventFunction.ShowReports();
                    $(".report-view").show();
                });

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#membeshipformlist').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "VendorReport_" + $('#dateStartDate').val() + '-' + $("#dateEndDate").val() + ".xls"
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
                    pdf.addHTML($("#membeshipformlist"), 0, 0, options, function () {
                        pdf.save('VendorReport_' + $('#dateStartDate').val() + '-' + $("#dateEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });
            },

            ShowReports: function () {
                var datefrom = $('#dateStartDate').val();
                var dateTo = $('#dateEndDate').val();
                var VenderId = $('#ddCusName').find(":selected").val();

                eventFunction.config.method = "GetVenderReportByDate";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ DateFrom: datefrom, DateTo: dateTo ,VenderId :VenderId });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },
            init: function () {

                eventFunction.InitialSetup();
          
              
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
                   
                    case 3:
                        eventFunction.BindDateWise(data.d);
                        break;
                  
                    case 6:
                        eventFunction.BindVenderData(data.d);
                        break;
                    case 7:
                        eventFunction.DropDownCustomer(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
              
            },

          

            GetCustomer: function () {
                eventFunction.config.method = "getVendorName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByMonthly: function () {
                var year = $("#seit").val();
                var month = $("#month").val();
                eventFunction.config.method = "getdailyVendorReportByMonthly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, month: month });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByYearly: function () {
                var year = $("#seit").val();
                eventFunction.config.method = "getdailyVendorReportByYearly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            DropDownCustomer: function (result) {
                datas = JSON.parse(result);           
                if (!datas) return;
                $("#ddCusName").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='0' disabled selected>-All-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.MembershipID + "'>" + value.Name + "</option>";
                    });

                    $("#ddCusName").html(htmls);
                }

            },


            Bindmembership: function (data) {
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');

                debugger;
                datas = JSON.parse(data);
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Vendor Report </p> <p style="text-align:center;margin:0;">From :  ' + ($('#dateStartDate').val() == "" ? "Beginning" : $('#dateStartDate').val()) + ' To ' + ($('#dateEndDate').val() == "" ? "End" : $('#dateEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Name </th><th style='width:200px'> Table Number </th><th> Bill No </th><th> Remaining Balance </th><th> Date</th><th> Net Amount</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {                 
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.CusName + "</td>";
                        htmls += "<td style='width:200px'>" + value.restrotableTitle + "</td>";
                        htmls += "<td>" + value.billNo + "</td>";
                        
                        htmls += "<td>" + value.RemainingBalance + "</td>";
                     //   htmls += "<td>" + value.UptoNowPaid + "</td>";
                        htmls += "<td>" + value.BillDate.split(' ')[0] + "</td>";
                        htmls += "<td>" + value.NetAmount + "</td>";
                        htmls += "</tr>"

                        
                        TotalAmount = TotalAmount + value.NetAmount;
                    });

                } else {
                    htmls += "<tr>";
                    htmls += "<td Colspan=6 style='text-align:center;'> N0 Data Available</td>";
                    htmls += "</tr>"

                }
                    htmls += "<thead class='Sales-total_amount'>"
                    htmls += "<tr>";
                    htmls += "<th colspan='5' class='a' style='text-align:right;'>" + "Total Amount :" + "</th>";
                    htmls += "<th>" + TotalAmount.toFixed(2) + "</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"

                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;

                    htmls += "</tbody>";

                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                  

            },

            BindVenderData: function (data) {
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                datas = JSON.parse(data);

                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Vendor Report </p> <p style="text-align:center;margin:0;">From :  ' + ($('#dateStartDate').val() == "" ? "Beginning" : $('#dateStartDate').val()) + ' To ' + ($('#dateEndDate').val() == "" ? "End" : $('#dateEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='DateWisetable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Vendor Name </th><th style='width:200px'> Item Name </th><th> Purchase Quantity </th><th> Unit Rate</th><th> Good Received Quantity</th><th> Remaining Quantity</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                 
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem'>";
                        htmls += "<td>" + value.Fname + "</td>";
                        htmls += "<td style='width:200px'>" + value.ITName + "</td>";
                        htmls += "<td>" + value.PurchaseQuantity + " ( " + value.Description + ")</td>";
                        htmls += "<td>Rs. " + value.UnitRate + "</td>";
                        htmls += "<td>" + (value.GoodReceivedQuantity < '0' ? 0 : value.GoodReceivedQuantity) + "</td>";
                        htmls += "<td>" + (value.Remaining < '0' ? 0 : value.Remaining) + "</td>";
                        htmls += "</tr>"
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td Colspan=6 style='text-align:center;'> No Data Available</td>";
                    htmls += "</tr>"

                }
                    htmls += "</tbody>";

                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
          
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
