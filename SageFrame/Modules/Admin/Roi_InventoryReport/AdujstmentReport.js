function Print() {
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
}

(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Admin/Roi_InventoryReport/'
             }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0
        var Amount = 0;
        var PuNoArray = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsInventoryReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {
            

                $("#txtMonthlyDate").datepicker({
                    dateFormat: 'yy-m',
                });
                $(".hide").hide();
                for (i = new Date().getFullYear() ; i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }
            },
            init: function () {
                eventFunction.InitialSetup();


                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#DailyReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "DailyReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
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
                    pdf.addHTML($("#DailyReport"), 0, 0, options, function () {
                        pdf.save('DailyReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });

                //----------------------------------------Daily----------------
                $("#btnViewAdjustment").on('click', function () {
                    $(".report-view").show();
                        eventFunction.GetDailyReport();
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
                        eventFunction.BindAdjustmentReport(data.d);
                        break;
               
                }
            },
            ajaxFailure: function () {

            },

          

            GetDailyReport: function () {
                var startdate = $("#txtStartDate").val() + ' 0:0';
                var enddate = $("#txtEndDate").val() + ' 23:59';
                var reportNumber = 5;
                eventFunction.config.method = "getdailyReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0
                eventFunction.ajaxCall(eventFunction.config);
            },



            BindAdjustmentReport: function (data) {
                $("#DailyReport").show();
                $("#DailyReport").html('');
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                datas = JSON.parse(data);
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Adjustment Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='salseReport' class='sfGridwrapper reportsprint' cellspacing='0' style='border:none;width:100%;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>AdjustmentNo.</th><th>Item Name</th><th>Qty</th><th>Unit</th><th>Adjustment Type</th><th>Store</th><th>fiscal Year</th><th>PostedBy</th><th>PostedOn</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) { 
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.AMNo + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td class='b'>" + value.Qnty + "</td>";
                        htmls += "<td>" + value.UnitName + "</td>";
                        htmls += "<td>" + value.AdjustmentTypeName + "</td>";
                        htmls += "<td>" + value.StName + "</td>";
                        htmls += "<td >" + value.fyName + "</td>";
                        htmls += "<td>" + value.PostedBy + "</td>";
                        var posted = value.PostedOn.split(" ");
                        htmls += "<td >" + posted[0] + "</td>";
                        htmls += "</tr>"
                        count++;
                       
                    });

                    TotalAmount = 0;
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='10' style='text-align:center;'> No Data Available</td>";
                    htmls += "</tr>"
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

    
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
