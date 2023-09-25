(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_CancelledBillReport/service/'
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
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForCancelledBill.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },

            InitialSetup: function () {
                eventFunction.GetCancelledBY();
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
                //----------------------------------------Daily----------------
                $("#btnView").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {

                        $('.report-view').show();
                        eventFunction.GetDailyReport();

                    }
                });

                //--------------------------Print PDF----------------
                $("#btnPrint").on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#DailyReport').clone();
                    contents.find('tr th:nth-child(9), tr td:nth-child(9)').remove();
                    $('#printedDate').hide();
                    var frame1 = document.createElement('iframe');
                    frame1.name = "frame1";
                    document.body.appendChild(frame1);
                    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
                    frameDoc.document.open();
                    frameDoc.document.write('<html><head><title></title>');
                    frameDoc.document.write('</head><body>');
                    frameDoc.document.write(contents.get(0).innerHTML);
                    frameDoc.document.write('</body></html>');
                    frameDoc.document.close();
                    setTimeout(function () {
                        window.frames["frame1"].focus();
                        window.frames["frame1"].print();
                        document.body.removeChild(frame1);
                    }, 500);
               
                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var contents = $('#DailyReport').clone();
                    contents.find('tr th:nth-child(9), tr td:nth-child(9)').remove();
                    let file = new Blob([contents.get(0).innerHTML], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "CancelledBillReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });
           
                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var contents = $('#DailyReport');
                    contents.find('tr th:nth-child(9), tr td:nth-child(9)').hide();
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.2;
                    pdf.addHTML($("#DailyReport"), 0, 0, options, function () {
                        pdf.save('CancelledBillReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    contents.find('tr th:nth-child(9), tr td:nth-child(9)').show();
                    $('#printedDate').hide();
                });
                //--------------------------Export To EXCEL----------------
                $("#exportToXCEl").click(function (e) {
                    var data_type = 'data:application/vnd.ms-excel';
                    var table_div = document.getElementById('DailyReport');
                    var table_html = table_div.outerHTML.replace(/ /g, '%20');
                    window.open(data_type + ', ' + table_html);
                    e.preventDefault();
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
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 3:
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 4:
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 5:
                        eventFunction.bindSumDaily(data);
                        break;
                    case 6:
                        jAlert('Saved Reason successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        location.reload();
                        break;
                    case 10:
                        //eventFunction.bindBillBody(data.d);
                        break;
                    case 13:
                        eventFunction.print();
                        $('#BillingView').dialog('close');
                        break;
                    case 14:
                        eventFunction.BindOrderCancelledBY(data);
                        break;
                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },
            GetCancelledBY: function () {

                eventFunction.config.method = "GetAllUsers";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
            },


            BindOrderCancelledBY: function (result) {

                var datas = result.d;
                var htmls = "";
                $("#selcancelledby").html('');
                htmls = "<option value='' selected>-All-</option>";
                if (datas.UserList.length > 0) {
                    $.each(datas.UserList, function (index, value) {
                        htmls += "<option value='" + value.UserName + "'>" + value.UserName + "</option>";
                    });

                }
                $("#selcancelledby").html(htmls);

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
                $('#btnPrints').unbind('click').on('click', function () {
                    $('#divPrintedOn').text(formatAMPM());
                    eventFunction.config.method = "savePrintCount";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                    });
                    eventFunction.config.ajaxCallMode = 13;
                    eventFunction.ajaxCall(eventFunction.config);
                });
            },
            GetDailyReport: function () {
                var startdate = $("#txtStartDate").val() + ' 0:0';
                var enddate = $("#txtEndDate").val() + ' 23:59';
                var cancelledby = $("#selcancelledby").val();
                eventFunction.config.method = "getdailyReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate, cancelledby: cancelledby });
                //eventFunction.config.data = JSON2.stringify({ dateTime: todaydate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByWeekly: function () {
                var todaydate = $("#txtStartDate").val();
                eventFunction.config.method = "getdailyReportByWeekly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dateTime: todaydate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByMonthly: function () {
                var year = $("#seit").val();
                var month = $("#month").val();
                eventFunction.config.method = "getdailyReportByMonthly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, month: month });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByYearly: function () {
                var year = $("#seit").val();
                eventFunction.config.method = "getdailyReportByYearly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            BindSalesDaily: function (result) {
                $("#DailyReport").show();
                $("#DailyReport").html('');
                
                reportlist = JSON.parse(result);
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Cancelled Bills Report </p> <p style="text-align:center;margin:0;"> From : ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='salseReport' class='sfGridwrapper nowrap display reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>SN</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Bill No.</th><th class='waiter' style='text-align:center;border:1px solid #575757;padding:2px;'>Waiter</th><th class='room' style='text-align:center;border:1px solid #575757;padding:2px;'>Room </th><th class='table' style='text-align:center;border:1px solid #575757;padding:2px;'>Table</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Reason</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>CancelledBy</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>CancelledOn</th><th class='sort_disable tdcenter '>View</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (reportlist.length > 0) {
                    var count = 1;
                    TotalAmount = 0;
                    $.each(reportlist, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td class='a' style='text-align:center;border:1px solid #575757;padding:2px;'>" + count + "</td>";
                        //htmls += "<td class='b' style='width:100px;'>" + value.BillDate.split(' ')[0] + "</td>";
                        //htmls += "<td class='b' style='width:80px;'>" + value.BillDate.split(' ')[1] + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.billNo + "</td>";
                        htmls += "<td class='c' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Waiter + "</td>";
                        htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.restroRoom + "</td>";
                        htmls += "<td class='e' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.restrotableTitle + "</td>";
                       // htmls += "<td class='f'>" + value.NetAmount + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.Reasons + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ArchivedBy + "</td>";
                        //var dates = value.ArchivedOn.split(" ");
                        //htmls += "<td>" + dates[0] + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ArchivedOn + "</td>";
                        htmls += '<td class="tdcenter" ><img id="' + value.salesMasterId + '" class="btnViewBill preview-icon" value="View" type="button" src="/images/view.png"></td>';
                       // htmls += '<td><input type="button" id="' + value.salesMasterId + '" class="btnViewBill sfBtn" value="View Bill"/></td>';
                        //htmls += '<td><input type="button" id="' + value.salesMasterId + '" class="btnCancelBill sfBtn" value="Cancel Bill"/></td>';
                        htmls += "</tr>"
                        count++;
                        TotalAmount += value.NetAmount;
                    });

                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                   

                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);

                    //$('#salseReport').DataTable({
                    //    "jQueryUI" : true,
                    //    dom: 'Bfrtip',
                    //    order:false,

                    //    buttons: [

                    //        'print', 'excel', 'pdf'
                    //    ]
                    //});

                    $(".btnCancelBill").on("click", function () {
                        var ids = $(this).attr('id');
                        var userName = SageFrameUserName;
                        //alert(ids);
                        //var reason = $("#txtCancelWithReason").val();
                        $('.CancelWithReason').dialog(
                        {
                            'title': 'Give Reasons',
                            "resize": "auto",
                            width: 300,
                            buttons: {
                                "Submit": function () {
                                    var reason = $("#txtCancelWithReason").val();
                                    eventFunction.config.method = "CancelBillWithReason";
                                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                    eventFunction.config.data = JSON2.stringify({ id: ids, userName: userName, reason: reason });
                                    eventFunction.config.data = eventFunction.config.data;
                                    eventFunction.config.ajaxCallMode = 6;
                                    jAlert(ids + " " + userName + " " + reason, 'Information!!', function () { $.alerts.dialogClass = null; });
                                    eventFunction.ajaxCall(eventFunction.config);
                                    $(this).dialog('close');
                                },
                                Cancel: function () {
                                    $(this).dialog('close');
                                }
                            }
                        });
                    });


                    $("#salseReport").on("click", ".btnViewBill", function () {
                        var ids = $(this).attr('id');
                        //var word = ids.split('_');
                        eventFunction.GetBill(ids)
                        // alert(ids);
                        //window.open('/CustomerBill.aspx?MID=' + ids, '_blank');
                        //window.location = '/CustomerBill.aspx?MID=' + ids;
                    });



              


            },
            
            print: function () {
                var contents = $('#customer-bill').html();
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
            },

            //bindSumDaily: function (data) {
            //    var datas = data.d;

            //     $("#SumAmount").text(datas[0].sumAmount);

            //},
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