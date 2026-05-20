/// <reference path="../../../../js/jquery-1.7.js" />
/// <reference path="WebService.asmx" />
(function ($) {
    var tabs = $("#tabs").tabs();
    $.chalanSetting = function (p) {
        p = $.extend
             ({
                 ModulePath: '/Modules/Admin/ActivityLog'
             }, p);

        var TotalAmount = 0;
        var TotalReturnedAmount = 0;
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
                baseURL: p.ModulePath + "/WebService.asmx/",
                method: "",
                url: "",
                ModulePath: p.ModulePath,
                ajaxCallMode: 0,

            },
            InitialSetup: function () {
            },
            init: function () {
                eventFunction.InitialSetup();
                $('#btnView').on('click', function () {
                    eventFunction.GetItem();
                     $('.report-view').show();
                });
                $("#btnExport").click(function (e) {
                    let file = new Blob([$('#DailyReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ActivityLog_" + $('#txtStartDate').val() + '_' + $('#txtEndDate').val() + ".xls"
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
                        pdf.save('ActivityLog_' + $('#txtStartDate').val() + '_' + $('#txtEndDate').val() + '.pdf');
                    });

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
                        eventFunction.BindData(data.d);
                        break;

                }
            },
            ajaxFailure: function () {

            },

            BindData: function (d) {
                var h = [];
                var index = 0;
                h[index++] = '<div class="cbms-header">';
                h[index++] = '<h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                h[index++] = '<p style="text-align:center;margin:0;">' + companyInfo.Address + ', PAN: ' + companyInfo.PAN + '</p>';
                h[index++] = '<p style="text-align:center;margin:0;">Activity Log of ' + $('.lstUser').val() + '</p>';
                h[index++] = '<p style="text-align:center;margin:0;">From: ' + $('#txtStartDate').val() + ' &nbsp; &nbsp; To : ' + $('#txtEndDate').val() + '</p>';
                h[index++] = '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;"">Printed On : <label id="lblPrintedOn"></label></p>';
                h[index++] = '</div>';
                h[index++] = '<table class="reportsprint" id="bindTable" style="border:none;width:100%;border-collapse:collapse;">';
                h[index++] = '<thead><tr><th style="text-align:center;border:1px solid #575757;padding:2px;">Bill No</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Order ID</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Date Time</th><th style="text-align:center;border:1px solid #575757;padding:2px;">User</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Event</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Table</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Room</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Description</th></tr></thead><tbody>';
                for (var i = 0; i < d.length; i++) {
                    h[index++] = '<tr>';
                    h[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].Bill_No;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].ordermasterid;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].date;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].UserName;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:left;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].Event;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].restrotableTitle;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:center;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].RoomType;
                    h[index++] = '</td>';
                    h[index++] = '<td style="text-align:left;border:1px solid #575757;padding:2px;">';
                    h[index++] = d[i].Description;
                    h[index++] = '</td>';
                    h[index++] = '</tr>';
                }
                h[index++] = '</tbody></table>';
                $('#DailyReport').html(h.join(" "));
            },


            GetItem: function () {
                var StartDate = $('#txtStartDate').val();
                var EndDate = $('#txtEndDate').val();
                var User = $('.lstUser').val();

                eventFunction.config.method = "GetActivityLog";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ StartDate: StartDate, EndDate: EndDate, User });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            }



        };
        eventFunction.init();
    };
    $.fn.DailyChalanEDIT = function (p) {
        $.chalanSetting(p);
    };
})(jQuery);
