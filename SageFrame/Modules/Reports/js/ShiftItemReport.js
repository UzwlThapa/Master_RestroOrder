
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
        var items = [];
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

             
                eventFunction.GetTable();
                eventFunction.GetShiftedBy();
                eventFunction.GetItem();

            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnView").click(function () {
                    $('.report-view').show();
                    eventFunction.GetItemShiftReport();
                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();

                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);

                    let file = new Blob([$('#ItemShiftReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ItemsShiftReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#ItemShiftReport').html();
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
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);

                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#ItemShiftReport"), 0, 0, options, function () {
                        pdf.save('ItemsShiftReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
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
                        eventFunction.BindTable(data.d);
                        break;

                    case 1:
                        eventFunction.BindShiftedBy(data.d);
                        break;

   
                    case 3:
                        eventFunction.BindItemShiftReport(data.d);
                        break;
                    case 4:
                        eventFunction.BindItem(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            GetItem: function () {
                eventFunction.config.method = "GetItemsfromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetTable: function () {
                eventFunction.config.method = "getRestroTable";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },


            GetShiftedBy: function () {
                eventFunction.config.method = "GetWaiterForReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetItemShiftReport: function () {
                var itemname = $("#txtItem").val();
                var fromtable = $("#seltableFrom").val();
                var totable = $("#selTableTo").val();
                var shiftedby = $("#selShiftedBy").val();
                var fromdate = $("#txtStartDate").val();
                var todate = $("#txtEndDate").val();
               

                eventFunction.config.method = "getItemShiftReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    itemname:itemname, fromtable:fromtable, totable:totable, shiftedby:shiftedby, fromdate:fromdate, todate:todate
                });
                eventFunction.config.ajaxCallMode = 3
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------Bind Here ---------------------------------------->>

            BindItem: function (result) {
                var datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, v) {


                        items.push({ label: v.ItemName, value: v.ItemID, rate: v.PRate });
                    });
                    $("#txtItem").autocomplete({

                        source: items,

                        focus: function (event, ui) {
                  
                            event.preventDefault();
                           
                            $(this).parents("tr").find('#txtItem').val(ui.item.label);
                        },
                        select: function (event, ui) {
                         
                            event.preventDefault();
                           
                            $(this).parents("tr").find('#txtItem').val(ui.item.label);
                         

                        }

                    });
                }

                //else 
                //{
                //    $("#txtItem").val('');
                //}

            },
            BindItemShiftReport: function (result) {               
                itemlist = JSON.parse(result);

                $("#ItemShiftReport").html('');
                var htmls = "";
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Item Shift Report </p> <p style="text-align:center;margin:0;">From : ' + $('#txtStartDate').val() + ' To : ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;"">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:left;border:1px solid #575757;padding:2px;'> Item Name</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Table From</th><th style='text-align:center;border:1px solid #575757;padding:2px;'> From SplitNo. </th><th style='text-align:center;border:1px solid #575757;padding:2px;'> Table To </th><th style='text-align:center;border:1px solid #575757;padding:2px;'> To SplitNo. </th><th style='text-align:left;border:1px solid #575757;padding:2px;'> Shifted By</th><th style='text-align:center;border:1px solid #575757;padding:2px;'> Quantity</th><th style='text-align:center;border:1px solid #575757;padding:2px;'> IsCombo</th><th style='text-align:center;border:1px solid #575757;padding:2px;'> Shifted On</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (itemlist.length > 0) {                       
                        $.each(itemlist, function (index, value) {

                            htmls += "<tr>";
                            htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ITName + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.FromTable + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.FromSplitNo + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ToTable + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ToSplitNo + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ShiftedBy + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Quantity + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.IsCombo + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ShiftedOn + "</td>";
                            htmls += "</tr>"
                        });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                        htmls += "</tbody>";
                        htmls += "</table>";
                        $('#ItemShiftReport').html(htmls);
                        $('#Brandtable').DataTable(
                             {
                                 "bJQueryUI": true,
                                 dom: 'Bfrtip',

                                 buttons: [

                                     'print', 'excel', 'pdf'
                                 ],

                             });              
                
            },

         
            BindTable: function (result) {
                tablelist = JSON.parse(result);               
                $("#seltableFrom").html('');
                $("#selTableTo").html('');
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(tablelist, function (index, value) {
                        htmls += "<option value='" + value.restrotableTitle + "'>" + value.restrotableTitle + "</option>";
                    });

                    $("#seltableFrom").html(htmls);
                    $("#selTableTo").html(htmls);
                
            },

            BindShiftedBy: function (result) {
                waiterlist = JSON.parse(result);
             
                $("#selShiftedBy").html('');
                    var htmls = "";
                    htmls += "<option value='' selected>All</option>";
                    $.each(waiterlist, function (index, value) {
                        htmls += "<option value='" + value.Waiter + "'>" + value.Waiter + "</option>";
                    });

                    $("#selShiftedBy").html(htmls);
                
            },


            BindItemName: function (result) {
                itemlist = JSON.parse(result);
                $("#selItemName").html('');
                var htmls = "";
                htmls += "<option value='' selected>All</option>";
                $.each(itemlist, function (index, value) {
                    htmls += "<option value='" + value.ITName + "'>" + value.ITName + "</option>";
                });

                $("#selItemName").html(htmls);

            },

          


        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);