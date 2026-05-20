(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Reports/'
             }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0;
        
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "AllReports.asmx/",
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

                $(".DatePick").datepicker({
                    dateFormat: "yy-mm-dd",
                    changeMonth: true,
                    changeYear: true,
                }).datepicker("setDate", "0");

                for (i = new Date().getFullYear() ; i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }


                for (var i = 0; i < 60; i++) {
                    $('.Min').append($('<option/>').val(i).html(i));
                }
                for (var i = 0; i < 24; i++) {
                    $('.Hour').append($('<option/>').val(i).html(i));
                }

                for (i = new Date().getFullYear() ; i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }


                $("#EndHour").val(23);
                $("#EndMin").val(59);
                


               

            },
            init: function () {

                eventFunction.InitialSetup();
                $("#StartEndReportView").on('click', function () {
                    eventFunction.StartEndDateByReport();
                });
                //----------------------------------------Master----------------
                //$("#waiter").on('click', function () {
                //    if (waiter == 0) {
                //        waiter = 1;
                //    }
                //    else {
                //        waiter = 0;
                //    }
                //});
                //$("#table").on('click', function () {

                //    if (table == 0) {
                //        table = 1;
                //    }
                //    else {
                //        table = 0;
                //    }
                //});
                //$("#room").on('click', function () {

                //    if (room == 0) {
                //        room = 1;
                //    }
                //    else {
                //        room = 0;
                //    }


                //});
                $("#ReportingDays").on('change', function () {
                    var values = parseInt($('#ReportingDays').val());
                    if(values ==1)
                    {
                        $(".todate").hide();
                        $("#btnView").show();
                        $("#btnViewWeekly").hide();
                        $(".span2").hide();
                        $("#btnViewYearly").hide();
                        $("#btnViewMonthly").hide();
                        $(".hide").show();
                        $("#txtStartDate").show();
                        $("#txtStartDate").val("");
                        $("#txtToDate").hide();
                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);
                        $("#btnViewRange").hide();
                        //location.reload();
                    }
                    else if(values ==2)
                    {
                        $(".todate").show();
                        $("#btnView").hide();
                        $("#btnViewWeekly").show();
                        $("#btnViewMonthly").hide();
                        $(".span2").hide();
                        $("#btnViewYearly").hide();
                        $(".hide").show();
                        $("#txtToDate").hide();
                        $("#txtStartDate").show();
                        $("#btnViewRange").hide();

                        $("#txtStartDate").val("");
                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);

                    }
                    else if(values ==3)
                    {
                        $("#txtStartDate").hide();
                        $("#btnViewWeekly").hide();
                        $(".span2").show();
                        $("#btnViewMonthly").show();
                        $("#btnView").hide();
                        $("#txtToDate").hide();
                        $("#btnViewYearly").hide();
                        $(".hide").show();
                        $("#btnViewRange").hide();

                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);
                    }
                    else if (values == 4) {
                        
                        $("#btnViewMonthly").hide();
                        $("#month").hide();
                        $("#txtStartDate").hide();
                        $("#btnViewWeekly").hide();
                        $("#btnView").hide();
                        $("#txtToDate").hide();
                        $("#btnViewYearly").show();
                        $(".hide").show();
                        $("#seit").show();
                        $("#btnViewRange").hide();
                        //$("select option[value*='Sold Out']").prop('disabled', true); disabled
                        //$("#seit").html("");
                        $("#waiter").prop("checked", false);
                        $("#room").prop("checked", false);
                        $("#table").prop("checked", false);
                    }
                    else if (values ==5){
                        $("#txtStartDate").show();
                        $("#btnViewRange").show();
                        $("#txtToDate").show();
                        $("#month").hide();
                        $("#seit").hide();
                        $("#btnViewYearly").hide();
                        $("#btnView").hide();
                        $("#btnViewMonthly").hide();
                        $("#btnViewWeekly").hide();
                        
                        $(".hide").show();
                        
                    }

                  
                });
                //----------------------------------------Daily----------------
                $("#btnView").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (checkValid) {
                        if (reportnumber == 1) {
                            eventFunction.GetDailyReport();
                            $(".e").hide();
                            $(".table").hide();
                            $(".d").hide();
                            $(".c").hide();
                            //$("#btnView").hide();
                            //$("#btnViewWeekly").show();
                        }
                        else if (reportnumber == 2) {
                            eventFunction.GetDailyReport();
                            $(".e").hide();
                            $(".table").hide();
                            $(".d").hide();
                            $(".room").hide();
                        }
                        else if (reportnumber == 3) {
                            eventFunction.GetDailyReport();
                            $(".waiter").hide();
                            $(".c").hide();
                            $(".e").hide();
                            $(".table").hide();
                        }
                        else {

                        }
                     
                    }
                });
                //----------------------------------------Wekly----------------
                $("#btnViewWeekly").on('click', function () {
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (reportnumber == 1) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                        //$("#btnView").hide();
                        //$("#btnViewWeekly").show();
                    }
                    else if (reportnumber == 2) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    else if (reportnumber == 3) {
                        eventFunction.GetDailyReportByWeekly();
                        $(".waiter").hide();
                        $(".c").hide();
                        $(".e").hide();
                        $(".table").hide();
                    }
              
                });
                //----------------------------------------Monthly----------------
                $("#btnViewMonthly").on('click', function () {
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (reportnumber == 1) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (reportnumber == 2) {

                        eventFunction.GetDailyReportByMonthly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    else if (reportnumber == 3) {
                        eventFunction.GetDailyReportByMonthly();
                        $(".waiter").hide();
                        $(".c").hide();
                        $(".e").hide();
                        $(".table").hide();
                    }
                 
                });

                //----------------------------------------Yearly----------------

                $("#btnViewYearly").on('click', function () {
                    var reportnumber = parseInt($('#HiddenField1').val());
                    if (reportnumber == 1) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                    else if (reportnumber == 2) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                    }
                    else if (reportnumber == 3) {
                        eventFunction.GetDailyReportByYearly();
                        $(".waiter").hide();
                        $(".c").hide();
                        $(".e").hide();
                        $(".table").hide();
                    }
                  
                });
                //------------------------------------
                $("#btnViewRange").on('click', function () {
                    if (waiter == 0 && room == 0 && table == 0) {
                        eventFunction.GetDailyReportByYearly();
                        $(".e").hide();
                        $(".table").hide();
                        $(".d").hide();
                        $(".room").hide();
                        $(".waiter").hide();
                        $(".c").hide();
                    }
                });
                //--------------------------Export To PDF----------------

                var doc = new jsPDF();
                var specialElementHandlers = {
                    '#editor': function (element, renderer) {
                        return true;
                    }
                };

                $('#exportToPDF').click(function () {
                    doc.fromHTML($('#DailyReport').html(), 15, 15, {
                        'width': 170,
                        'elementHandlers': specialElementHandlers
                    });
                    doc.save('sample-file.pdf');
                    location.reload();
                });

                
                //--------------------------Print PDF----------------
                $("#btnPrint").on('click', function () {
                    var contents = document.getElementById("DailyReport").innerHTML;
                    var frame1 = document.createElement('iframe');
                    frame1.name = "frame1";
                    //frame1.style.position = "absolute";
                    //frame1.css({ "position": "absolute", "top": "-1000000px" });
                    //$("body").append(frame1);
                    //frame1.style.top = "-1000000px";
                    document.body.appendChild(frame1);
                    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
                    frameDoc.document.open();
                    frameDoc.document.write('<html><head><title></title>');
                    frameDoc.document.write('</head><body>');
                    //frameDoc.document.write('<link href="../../Core/Template/css/custom.css" rel="stylesheet" type="text/css" />');
                    frameDoc.document.write(contents);
                    frameDoc.document.write('</body></html>');
                    frameDoc.document.close();
                    setTimeout(function () {
                        window.frames["frame1"].focus();
                        window.frames["frame1"].print();
                        document.body.removeChild(frame1);
                    }, 500);
                    return false;
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
                        eventFunction.BindSalesDaily(data.d);
                        break;
                    case 1:
                        eventFunction.BindDaily(data.d);
                        break;
                    case 2:
                        eventFunction.BindOrderVoidReport(data.d);
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

            StartEndDateByReport: function () {
                var startDate = $("#startDate").val();
                var StartHour = $("#StartHour").val();
                var StartMin = $("#StartMin").val();
                var Sdate = startDate + " " + StartHour + ":" + StartMin
                var EndDate = $("#EndDate").val();
                var EndHour = $("#EndHour").val();
                var EndMin = $("#EndMin").val();
                var EDate = EndDate + " " + EndHour + ":" + EndMin
                var PaymentMode = $("#sltPayMode").val();
                eventFunction.config.method = "getOrderVoidReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: Sdate, endDate: EDate});
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindOrderVoidReport: function (result) {
                $("#DailyReport").show();
                $("#DailyReport").html('');
              
                voidlist = JSON.parse(result);

                    var htmls = "<table id='salseReport' class='sfGridwrapper display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Cancel Date</th><th>Time</th><th>Table</th><th>Reason</th><th>Cancelled By</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    if (voidlist.length > 0) {
                    var count = 1;
                    $.each(voidlist, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.CancelDate.split(' ')[0] + "</td>";
                        htmls += "<td>" + value.CancelDate.split(' ')[1] +" "+ value.CancelDate.split(' ')[2] + "</td>";
                        //htmls += "<td>" + value.restroRoom + "</td>";
                        htmls += "<td>" + value.restrotableTitle + "</td>";
                        htmls += "<td>" + value.CancelReason + "</td>";
                        htmls += "<td>" + value.CancelBy + "</td>";
                        //htmls += "<td class='f'>" + value.NetAmount + "</td>";
                        htmls += "</tr>"
                        count++;
                        TotalAmount = TotalAmount + value.NetAmount;
                    });
                    //htmls += "<tfoot>"
                    //htmls += "<tr>";
                    //htmls += "<th colspan='4' class='tot-rig f'>Total Amount :" + TotalAmount.toFixed(2) + "</th>";
                    //htmls += "</tr>"
                    //htmls += "</tfoot>"

                    //$("#SumAmount").text(TotalAmount);
                    //TotalAmount = 0;


                } else {
                    $('#DailyReport').html('No data');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#DailyReport').html(htmls);

                    $('#salseReport').DataTable({

                        dom: 'Bfrtip',

                        buttons: [

                            'print', 'excel', 'pdf'
                        ]
                    });


            },
            
            GetDailyReport: function () {
                var todaydate = $("#txtStartDate").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dateTime: todaydate, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = (reportNumber == 1?0:1);
                eventFunction.ajaxCall(eventFunction.config);
            },
          

            GetDailyReportByWeekly: function () {
                var todaydate = $("#txtStartDate").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReportByWeekly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ dateTime: todaydate, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode =( reportNumber == 1 ? 0 : 1);
                eventFunction.ajaxCall(eventFunction.config);
            },
            
            GetDailyReportByMonthly: function () {
                var year = $("#seit").val();
                var month = $("#month").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReportByMonthly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, month: month, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = reportNumber == 1 ? 0 : 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetDailyReportByYearly: function () {
                var year = $("#seit").val();
                var reportNumber = parseInt($('#HiddenField1').val());
                eventFunction.config.method = "getdailyReportByYearly";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ year: year, ReportNum: reportNumber });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = reportNumber == 1 ? 0 : 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            BindSalesDaily: function (result) {
                $("#DailyReport").show();
                $("#DailyReport").html('');

                salesList = JSON.parse(result);
                
                if (salesList.length > 0) {
                    var htmls = "<table id='salseReport' class='sfGridwrapper display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Date</th><th>Time</th><th class='waiter'>Waiter</th><th class='room'>Room </th><th class='table'>Table</th><th>Amount</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(salesList, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td class='a'>" + count + "</td>";
                        htmls += "<td class='b'>" + value.BillDate.split(' ')[0] + "</td>";
                        htmls += "<td class='b'>" + value.BillDate.split(' ')[1] + "</td>";
                        //htmls += "<td>" + value.billNo + "</td>";
                        htmls += "<td class='c'>" + value.Waiter + "</td>";
                        htmls += "<td class='d'>" + value.restroRoom + "</td>";
                        htmls += "<td class='e'>" + value.restrotableTitle + "</td>";
                        htmls += "<td class='f'>" + value.NetAmount + "</td>";
                        //htmls += '<td><input type="button" id="' + value.OrderMasterId + '" class="btnViewBill sfBtn" value="View Bill"/></td>';
                        htmls += "</tr>"
                        count++;
                        TotalAmount = TotalAmount + value.NetAmount;
                    });
                    htmls += "<tfoot>"
                    htmls += "<tr>";
                    htmls += "<th colspan='4' class='tot-rig f'>Total Amount :" + TotalAmount.toFixed(2) + "</th>";
                    htmls += "</tr>"
                    htmls += "</tfoot>"

                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);

                    $('#salseReport').DataTable({

                        dom: 'Bfrtip',

                        buttons: [

                            'print', 'excel', 'pdf'
                        ]
                    });
                    $("#salseReport").on("click", ".btnViewBill", function () {
                        var ids = $(this).attr('id');
                        //var word = ids.split('_');
                        // alert(ids);
                         window.open('/CustomerBill.aspx?MID=' + ids, '_blank');
                         //window.location = '/CustomerBill.aspx?MID=' + ids;
                    });

                    

                } else { 
                    $('#DailyReport').html('No data');
                }


            },
            BindDaily: function (result) {
                var billt = parseInt($('#HiddenField1').val());
                var CheckTerm = "";
                $("#DailyReport").show();
                $("#DailyReport").html('');

                dailyList = JSON.parse(result);

                if (dailyList.length > 0) {
                    var htmls = "<table id='salseReport' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Date</th><th>Time</th><th>Waiter</th>";
                    if (billt == 2) {
                        htmls += "<th>Vat</th><th>Vat Amount</th>";
                        CheckTerm = "VAT";
                    } else if (billt == 3){
                        htmls += "<th>Service Charge</th><th>Service Amount</th>";
                        CheckTerm ="Service Charge";
                    }
                  
               
                        htmls += "<th>Amount</th><th></th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    var previousitem = 0;
                    $.each(dailyList, function (index, value) {
                        var p = value.BillTerm;
                        
                        if (p == CheckTerm && value.BilingID != 1)
                            {
                            htmls += "<tr>";
                            htmls += "<td class='a'>" + count + "</td>";
                            htmls += "<td class='b'>" + value.BillDate.split(' ')[0] + "</td>";
                            htmls += "<td class='b'>" + value.BillDate.split(' ')[1] + "</td>";
                           // htmls += "<td>" + value.billNo + "</td>";
                            htmls += "<td>" + value.Waiter + "</td>";
                            //htmls += "<td class='d'>" + value.restroRoom + "</td>";

                            //for (var i = index; i < datas.length; i++) {

                            //    if (previousitem != datas[i].billNo)
                            //    {
                            //        index = i;
                            //        var last = datas.length;
                            //        if ((i - 1) <= datas.length)
                            //        {
                            //            previousitem = datas[i - 1].billNo;
                            //            break;
                            //        } else {
                            //            break;
                            //        }

                            //    }
                            //    if (datas[i].BillTerm != "")
                            //    {
                            //        htmls += "<td >" + datas[i].Amount + "</td>";

                            //    }
                            //}
                            //htmls += "<td class='e'>" + value.restrotableTitle + "</td>";
                            htmls += "<td >" + value.BillTerm + "</td>";
                            htmls += "<td >" + value.Amount + "</td>";
                            htmls += "<td class='f'>" + value.NetAmount + "</td>";
                            htmls += '<td><input type="button" id="' + value.OrderMasterId + '" class="btnViewBill sfBtn" value="View Bill"/></td>';
                            htmls += "</tr>"
                            count++;
                            TotalAmount = TotalAmount + value.NetAmount;
                            previousitem = value.billNo;
                            }
                        
                    
                    });
                    htmls += "<thead class='Sales-total_amount'>"
                    htmls += "<tr>";
                    htmls += "<th colspan='3' class='a' style='text-align:right;'>" + "Total Amount :" + "</th>";
                    htmls += "<th class='f'>" + TotalAmount.toFixed(2) + "</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"

                    $("#SumAmount").text(TotalAmount);
                    TotalAmount = 0;
                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#DailyReport').html(htmls);

                    $('#salseReport').DataTable({

                        dom: 'Bfrtip',

                        buttons: [

                            'print', 'excel', 'pdf'
                        ]
                    });
                    $("#salseReport").on("click", ".btnViewBill", function () {
                        var ids = $(this).attr('id');
                        //var word = ids.split('_');
                        // alert(ids);
                        window.open('/CustomerBill.aspx?MID=' + ids, '_blank');
                        //window.location = '/CustomerBill.aspx?MID=' + ids;
                    });



                } else {
                    $('#DailyReport').html('No data');
                }


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
