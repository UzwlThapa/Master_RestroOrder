function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#OrderItemCancelReport').html();
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
                 ModulePath: '/Modules/Reports/'
             }, p);
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var selectedIndex = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "AllReports.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
            },
            InitialSetup: function () {
                eventFunction.GetRoom();
                eventFunction.GetTable();
                eventFunction.GetOrderCancelResponsible();
                eventFunction.GetOrderBy();
                eventFunction.GetCancelledBY();

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
                $("#StartEndReportView").click(function () {
                    $('.report-view').show();
                    //var checkValid = eventFunction.ValidationForm();
                    //if (checkValid)
                    //    eventFunction.saveAmnities();
                    eventFunction.StartEndDateByReport();
                });
                $("#selroom").on('change', function () {
                    if ($("#selroom").val() == '0') {
                        eventFunction.GetTable();
                    }
                    else {
                        var restroRoomId = $("#selroom").val();

                        eventFunction.config.method = "getRestroTableByRoomID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({
                            restroRoomId: restroRoomId
                        });
                        eventFunction.config.ajaxCallMode = 2;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#OrderItemCancelReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "OrderItemCancelReport_" + $('#startDate').val() + '-' + $("#EndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#F7F9F9',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#OrderItemCancelReport"), 5, 5, options, function () {
                        pdf.save('OrderItemCancelReport_' + $('#startDate').val() + '-' + $("#EndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
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
                        eventFunction.BindOrderItemCancelReport(data.d);
                        break;
                    case 1:
                        eventFunction.BindRoom(data.d);
                        break;
                    case 2:
                        eventFunction.BindTable(data.d);
                        break;
                    case 3:
                        eventFunction.BindOrderCancelledBY(data.d);
                        break;
                    case 4:
                        eventFunction.BindCancelledOrderBY(data.d);
                        break;
                    case 5:
                        eventFunction.BindOrderCancelResponsible(data.d);
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
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetTable: function () {
                eventFunction.config.method = "getRestroTable";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCancelledBY: function () {

                eventFunction.config.method = "GetOrderCancelledBY";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetOrderBy: function () {
                eventFunction.config.method = "GetCancelledOrderBY";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetOrderCancelResponsible: function () {
                eventFunction.config.method = "GetOrderCancelResponsible";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },


            StartEndDateByReport: function () {
               
                var startDate = $("#startDate").val();
                var Sdate = startDate + " " + "00:00";
                var EndDate = $("#EndDate").val();
                var EDate = EndDate + " " + "23:59";
                var cancelledby = $("#selCancelledBy").val();
                var orderby = $("#selOrderedBy").val();
                var roomid = $("#selroom").val();
                var tableid = $("#seltable").val();
                var responsible = $("#selResponsible").val();
                var itemname = $("#txtItem").val();
                eventFunction.config.method = "getOrderItemCancelReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: Sdate, endDate: EDate, cancelledby: cancelledby, orderby: orderby, roomid: roomid, tableid: tableid, responsible: responsible, itemname: itemname});
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //---------------------------------------------BindData-------------------------------------------\\
            BindOrderCancelResponsible: function (result) {
                roomlist = JSON.parse(result);
                var htmls = "";
                htmls += "<option value='' selected>All</option>";
                if (roomlist.length > 0) {
             
                    $.each(roomlist, function (index, value) {
                        htmls += "<option value='" + value.Responsible + "'>" + value.Responsible + "</option>";
                    });
                }
                $("#selResponsible").html(htmls);
            },


            BindOrderCancelledBY: function (result) {
                roomlist = JSON.parse(result);
                var htmls = "";
                htmls += "<option value='' selected>All</option>";
                if (roomlist.length > 0) {
                  
                    $.each(roomlist, function (index, value) {
                        htmls += "<option value='" + value.CanceledBy + "'>" + value.CanceledBy + "</option>";
                    });
                }
                $("#selCancelledBy").html(htmls);
            },


            BindCancelledOrderBY: function (result) {
                roomlist = JSON.parse(result);
                var htmls = "";
                htmls += "<option value='' selected>All</option>";
                if (roomlist.length > 0) {
                    $.each(roomlist, function (index, value) {
                        htmls += "<option value='" + value.OrderBy + "'>" + value.OrderBy + "</option>";
                    });
                }
                $("#selOrderedBy").html(htmls);
            },


            BindRoom: function (result) {
                roomlist = JSON.parse(result);
                var htmls = "";
                htmls += "<option value='0' selected>All</option>";
                if (roomlist.length > 0) {
                  
                    $.each(roomlist, function (index, value) {
                        htmls += "<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>";
                    });
                }
                $("#selroom").html(htmls);
            },


            BindTable: function (result) {
                tablelist = JSON.parse(result);
                $("#seltable").html('');
                var htmls = "";
                htmls += "<option value='0' selected>All</option>";
                if (tablelist.length > 0) {
                   
                    $.each(tablelist, function (index, value) {
                        htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                    });
                }
                $("#seltable").html(htmls);
            },

            BindOrderItemCancelReport: function (result) {
                cancelList = JSON.parse(result);
                $("#OrderItemCancelReport").show();
                $("#filter").show();
                $("#OrderItemCancelReport").html('');
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Order Canceled Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#EndDate').val() + '</p>';
                htmls += '<p id="printedDate"  style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='salseReport' class='sfGridwrapper display reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>SN</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Canceled By</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Ordered By</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Item</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Quantity</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Reason</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Cancel Date</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Responsible</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Room</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Table</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (cancelList.length > 0) {
                    var count = 1;
                    $.each(cancelList, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + count + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.CanceledBy + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.OrderBy + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.Item + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Quantity + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.Reason + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Date + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.Responsible + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.restroRoom + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.restrotableTitle + "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='10' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#OrderItemCancelReport').html(htmls);

              
                //$('#selResponsible').on('keyup', function () {
                //    table.columns(7).search(this.value).draw();
                //});
                //$('#txtItem').on('keyup', function () {
                //    table.columns(3).search(this.value).draw();
                //});
                //$('#txtCancelled').on('keyup', function () {
                //    table.columns(1).search(this.value).draw();
                //});
                //$('#txtOrderBy').on('keyup', function () {
                //    table.columns(2).search(this.value).draw();
                //});
                //$('#txtRoom').on('keyup', function () {
                //    table.columns(8).search(this.value).draw();
                //});
                //$('#txtTable').on('keyup', function () {
                //    table.columns(9).search(this.value).draw();
                //});

            },
            Reset: function () {
                window.location.reload();

                //eventFunction.InitialSetup();
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        Amnities: {
                            required: true,
                        }
                    },
                    messages: {
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