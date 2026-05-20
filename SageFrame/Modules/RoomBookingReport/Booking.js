(function ($) {
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RoomBookingReport/',
                 master: '0',
             }, p);
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
                baseURL: p.ModulePath + "RoomBooking.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0
            },

            init: function () {
                eventFunction.GetCustomer();
                eventFunction.GetRestroTable();

                $("#btnView").click(function () {
                    $('.report-view').show();
                        eventFunction.getRoombookingReport();           
                });



                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#divForReport').clone();
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
                });

                //--------------------------Export To EXCEL----------------

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    let file = new Blob([$('#divForReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "RoomBookingReport_" + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    var contents = $('#divForReport');
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML(contents, 0, 0, options, function () {
                        pdf.save('RoomBookingReport_' + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();

                });
            },
            getRoombookingReport: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                var customer = $("#txtName").val();
                var table = $("#txtRoomName").val();
                eventFunction.config.method = "getRoomBookingReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startdate, endDate: enddate, customer: customer, table: table });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindRoomBookingReport: function (result) {

                CreditList = JSON.parse(result);
                $("#divForReport").html('');
                var htmls = "";
                var sn = 1;
                var totalpaid = 0;
                var totalRate= 0;
                var totalAdv = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Credit Pay Report </p> <p style="text-align:center;margin:0;"> From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += '<table class="tableforlisting reportsprint" cellspacing="0" style="border:none;width:100%;border-collapse:collapse;"><thead>';
                htmls += '<tr><th>S.N.</th><th>Room Name</th><th>Customer Name</th><th>Phone</th><th>Booked From Date</th><th>Booked To Date</th><th>BookedDays</th><th>Rate</th><th>Total Amount</th><th>Advance Payment</th><th>Remarks</th></tr></thead><tbody>';
                if (CreditList.length > 0) {
                    //$("#btnPrint").show();
                    $.each(CreditList, function (index, value) {
                        htmls += '<tr><td>' + sn + '</td>';
                       // htmls += '<td>' + value.AddedOn.split(' ')[0] + '</td>';
                        htmls += '<td>' + value.restrotableTitle + '</td>';
                        htmls += '<td>' + value.CustomerName + '</td>';
                        htmls += '<td>' + value.PhoneNo + '</td>';
                        htmls += '<td>' + value.BookedFrom + '</td>';
                        htmls += '<td>' + value.BookedTo + '</td>';
                        htmls += '<td>' + value.BookedDays + '</td>';
                        htmls += '<td>' + value.Rate + '</td>';
                        htmls += '<td>' + value.TotalAmount + '</td>';
                        htmls += '<td>' + value.AdvancePayment + '</td>';
                        htmls += '<td>' + value.Remarks + '</td>';
                        htmls += '</tr>';
                        totalpaid += value.TotalAmount;
                        totalRate += value.Rate;
                        totalAdv += value.AdvancePayment;
                        sn++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='11' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += '</tbody><tfoot>';
                htmls += '<tr><th colspan=6 ></th><th style="text-align:right;font-weight: bold;">Total:</th>';
                htmls += '<th>' + totalRate + '</th>';
                htmls += '<th>' + totalpaid + '</th>';
                htmls += '<th>' + totalAdv + '</th>';
                htmls += '<th></th>';
                htmls += '</tr>';
                htmls += '</tfoot></table> ';

                $("#divForReport").html(htmls);
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
                        eventFunction.bindRoomBookingReport(data.d);
                        break;
                    case 2:
                        eventFunction.Bindmembership(data.d);
                        break;
                    case 3:
                        eventFunction.BindRoom(data.d);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

   

            GetCustomer: function () {
                eventFunction.config.method = "getCustomerNameFromRoomBooking";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },


            // txtName
            Bindmembership: function (result) {
                memberList = JSON.parse(result);
                member = [];
                if (memberList.length > 0) {
                    $.each(memberList, function (index, value) {
                        member.push({ label: value.CustomerName, id: value.CustomerName });
                    });
                }
                $("#txtName").autocomplete({
                    source: member,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#txtName").val(ids);
                    }

                });
            },


            GetRestroTable: function () {
                eventFunction.config.method = "getRestroTable";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },


            // txtName
            BindRoom: function (result) {
                RoomList = JSON.parse(result);
                Room = [];
                if (RoomList.length > 0) {
                    $.each(RoomList, function (index, value) {
                        Room.push({ label: value.restrotableTitle, id: value.restrotableTitle });
                    });
                }
                $("#txtRoomName").autocomplete({
                    source: Room,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#txtRoomName").val(ids);
                    }

                });
            },
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);
