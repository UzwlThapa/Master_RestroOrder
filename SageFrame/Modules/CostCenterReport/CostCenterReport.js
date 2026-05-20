function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#DailyReport').clone();
    contents.find('tr th:nth-child(14), tr td:nth-child(14)').remove();
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
}
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/RoReport/',
                CompanyName: '',
                Pan: ''

            }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0;
        var IsPaid = false;
        var d = 0;
        var inWord = "";
        var logoInfo = "";
        var body = "";
        var checks = [];
        var companyNames = "";
        var terms = 0;
        var netAmount = 0;
        var totalamount = 0;
        var salesReport = [];
        var salesId = 0;
        var userRole = "";
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "SalesReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {


                $("#btnviewreport").on('click', function () {
                    d = -1;
                    eventFunction.SalesRecord();
                });
                $("#btnviewreportR").on('click', function () {
                    d = 1;
                    eventFunction.SalesRecord();
                });
                $("#DailyReport").on("click", ".btnViewBill", function () {

                    var ids = $(this).attr('id').split("_");

                    eventFunction.GetBill(ids[0]);

                    $('#InvoiceType').html('INVOICE');

                });

                $(".DatePick").datepicker({
                    dateFormat: "yy-mm-dd",
                    maxDate: "+0D"
                }).datepicker("setDate", "0");
                


                $("#txtMonthlyDate").datepicker({
                    dateFormat: 'yy-m',
                });

                $(".hide").hide();

                for (i = new Date().getFullYear(); i > 1900; i--) {
                    $('#seit').append($('<option/>').val(i).html(i));
                }



            },
            init: function () {

                eventFunction.InitialSetup();


                $("#StartEndReportView").on('click', function () {
                    eventFunction.StartEndDateByReport();
                    $('.report-view').show();

                });

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

                $('#btnPrint').on('click', function () {
                    Print();
                });

                //--------------------------Export To EXCEL----------------

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var contents = $('#DailyReport').clone();
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').remove();
                    let file = new Blob([contents.get(0).innerHTML], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "SalesReport_" + $('#startDate').val() + '_' + $("#EndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    var contents = $('#DailyReport');
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').hide();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML(contents, 0, 0, options, function () {
                        pdf.save('SalesReport_' + $('#startDate').val() + '_' + $("#EndDate").val() + '.pdf');
                    });
                    contents.find('tr th:nth-child(14), tr td:nth-child(14)').show();
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

                    case 1:
                        salesReport = JSON.parse(data.d);
                        eventFunction.BindSalesDaily();
                        break;

                }
            },
            ajaxFailure: function () {

            },


            GetBill: function (salesMasterId) {
                getBill(salesMasterId);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg',
                });
            },


            StartEndDateByReport: function () {
                var startDate = $("#startDate").val();

                var EndDate = $("#EndDate").val();
                eventFunction.config.method = "GetCostCenterDiscountReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: EndDate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>



            BindSalesDaily: function () {
                $("#DailyReport").show();
                $("#DailyReport").html('');
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

                dailyList = salesReport.Table;
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Sales Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#startDate').val() + ' To :  ' + $('#EndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';

                htmls += "<table id='salseReport' class='reportsprint report_L' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"

                //htmls += "<th style='width:100px;'>SN</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th>";
                //htmls+="<th>Time</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Bill No.</th>";
                //htmls+="<th class='waiter'>Waiter</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>Mode</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Total</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Bar Discount</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>KOT Discount</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Pizza Discount</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Bakery Discount</th>";
				htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Loyality Discount</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Basic Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Serv Chrg</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Taxable Amt</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>VAT</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tdrate'>Net Amt</th>";
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;' class='sort_disable tdcenter' >Action (Bill)</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                var Su = 0;
                var brto = 0;
                var kto = 0;
                var pto = 0;
                var bato = 0;
				var ltto = 0;
                var Ba = 0;
                var Se = 0;
                var Va = 0;
                var Taxable = 0;
                var Ne = 0;
                var Ra = 0;
                var SD = 0;
                var count = 1;
                var roomTable = "";
                if (dailyList.length > 0) {
                    $.each(dailyList, function (index, value) {
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.billNo.toLowerCase().includes(search) || value.restroRoom.toLowerCase().includes(search) || value.restrotableTitle.toLowerCase().includes(search) || search == '') {
                            htmls += "<tr>";
                            //htmls += "<td class='a'>" + count + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;' class='b'>" + value.BillDate.split(' ')[0] + "</td>";
                            //htmls += "<td class='b' style='width:80px;'>" + value.BillDate.split(' ')[1] + "</td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.billNo + "</td>";
                            //htmls += "<td class='c'>" + value.Waiter + "</td>";
                            if (value.restrotableTitle == "" || value.restrotableTitle == null) {
                                roomTable = value.restroRoom;
                            } else if (value.restrotableTitle != "" || value.restrotableTitle != null) {
                                roomTable = value.restroRoom + "/" + value.restrotableTitle;
                            }

                            htmls += "<td class='d' style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.PaymentModes + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.SubTotal.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.BarDiscount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.KOTDiscount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.PizzaDiscount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.BakeryDiscount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.LoyaltyDiscount.toFixed(2) + "</td>";
							htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.BasicAmount.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.ServiceCharge.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + (value.NetAmount - value.Vat).toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.Vat.toFixed(2) + "</td>";
                            htmls += "<td class='f' style='text-align:right;border:1px solid #575757;padding:2px;'>" + value.NetAmount.toFixed(2) + "</td>";

                            htmls += '<td class="tdcenter"><label id="' + value.salesMasterId + "_" + value.SPMID + "_" + value.Status + "_" + value.SalesType + '" class="icon-preview btnViewBill" />';

                            htmls += '</td>';
                            count++;
                            Su += value.SubTotal;
                            brto += value.BarDiscount;
                            kto += value.KOTDiscount;
                            pto += value.PizzaDiscount;
                            bato += value.BakeryDiscount;
							ltto += value.LoyaltyDiscount;
							
                            Ba += value.BasicAmount;
                            Se += value.ServiceCharge;
                            Va += value.Vat;
                            Taxable += (value.NetAmount - value.Vat);
                            Ne += value.NetAmount;
                            TotalAmount = TotalAmount + value.NetAmount;
                            htmls += "</tr>"
                        }
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='14' style='text-align:center;'> No Data </td>";
                    htmls += '</tr></tbody>';
                }
                htmls += "<tfoot>"
                htmls += "<tr>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='f' colspan='3' style='text-align:right;'>Total </th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Su.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + brto.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + kto.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + pto.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + bato.toFixed(2) + "</th>";
				htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + ltto.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ba.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Se.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Taxable.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Va.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + Ne.toFixed(2) + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' colspan=2></th>";
                htmls += "</tr>"
                htmls += "</tfoot>"
                TotalAmount = 0;
                // htmls += "</tbody>";
                htmls += "</table>";

                $('#DailyReport').html(htmls);

                //$('#salseReport').DataTable({

                //    dom:  '<"wrapper"Bfrtip>',
                //    "order": [[ 1, "desc" ]],

                //    autoWidth: true,
                //    ordering: false,
                //    scrollX: true,
                //    buttons: [
                //        { extend: 'print', footer: true },
                //        { extend: 'excel', footer: true },
                //        { extend: 'pdf', footer: true }
                //    ],
                //    columnDefs: [{ orderable: false},
                //    { width: 40, targets: 0 }
                //    ],
                //     "bJQueryUI": true,
                //});


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
            Bindmembership: function (data) {
                $("#membeshipformlist").dialog({
                    'title': 'Customer',
                    width: 800,
                    modal: true,
                    resizable: true,
                });

                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th><th>Paid</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.Occupation + "</td>";
                        htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        htmls += "<td>" + "<img src='/images/completed.png' class='BrandDelete' style='width:30px' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                        // htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                        {
                            "scrollY": false,
                            "scrollCollapse": false,
                            "bJQueryUI": true,

                        });

                } else {
                    $('#membeshipformlist').html('No data');

                }

                $(".dataTables_scrollBody").css('height', '100%');
                $("#membeshipformlist").on('click', '.BrandDelete', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    var rows = $(this).closest('tr');
                    CustID = id;
                    CustName = rows.find('td:eq(0)').text();
                    CustAddress = rows.find('td:eq(2)').text();
                    CustPAN = rows.find('td:eq(1)').text();

                    //$("#chkCus").prop("checked", true);

                    //totamount = $("#bindtotalamount").val();
                    eventFunction.GetCusOnChange(id);

                });

            },
            Bindmember: function (data) {
                $("#membeshipformlist2").show();
                $("#membeshipformlist2").html('');

                var datas = data.d;

                if (datas.length > 0) {
                    var htmls = "<table id='MemberTable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th style='width:200px'> Address </th><th> Phone </th><th> Card Number </th><th> Remaining Balance </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:200px'>" + value.Address + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td>" + value.CardNumber + "</td>";
                        htmls += "<td>" + value.RemainingBalance + "</td>";

                        //  htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        // htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        htmls += "<tr>"
                        //var sum = (parseFloat(value.RemainingBalance) + parseFloat(totamount)).toFixed(2);
                        var sum = parseFloat(totalamount).toFixed(2);

                        //htmls += "<td>" + value.RemainingBalance + "</td>";
                        htmls += "<table style='display:block;margin-top:10px;background:#e6e6e6;'>"
                        htmls += "<tr>"
                        htmls += "<td style='font-weight:bold;font-size:17px;text-align:center;'>Balance</td>"
                        htmls += "<td style='text-align:center;'><input type='textbox' disable value='" + sum + " ' placeholder='Total Amt' class='sfInputbox total' id='txtCalTotalAmount' style='width:120px;' readonly='readonly'/></td>";
                        htmls += "<td style='text-align:center;'><input type='textbox' placeholder='Paid Amt' class='sfInputbox total' id='txtCalPaidAmount' name='PaidAmount'  style='width:120px;'/></td>";
                        htmls += "<td style='text-align:center;'><input type='textbox' placeholder='" + sum + "' class='sfInputbox total' id='txtCalRemainingAmount' style='width:120px;' readonly='readonly' value='" + sum + "'/></td>";

                        htmls += "<td style='text-align:center;'>" + "<input class='sfBtn restro-btn updatemember' type='button'  id=_" + value.MembershipID + " value='Pay the Bill'  /></td>";
                        htmls += "</tr>"
                        htmls += "</table>"


                    });

                    htmls += "</tbody>";
                    htmls += "</table>";

                    $('#membeshipformlist2').html(htmls);
                    //$('#MemberTable').DataTable(
                    //     {
                    //         "scrollY": false,
                    //         "scrollCollapse": false,
                    //         "jQueryUI": true,

                    //     });

                } else {
                    $('#membeshipformlist2').html('No data');

                }
                $("#membeshipformlist2").dialog({
                    'title': 'Customer Balance',
                    width: 800,
                    modal: true,
                    resizable: true,
                });

                $("#membeshipformlist2").on('keyup', '#txtCalPaidAmount', function (event) {

                    var TotalAmount = parseFloat($("#txtCalTotalAmount").val());

                    var paidamount = parseFloat($("#txtCalPaidAmount").val());


                    var totalsum = TotalAmount;
                    if (paidamount > 0 && paidamount <= TotalAmount) {
                        totalsum = TotalAmount - paidamount
                    } else {
                        $("#txtCalPaidAmount").val("");
                    }


                    $("#txtCalRemainingAmount").val(totalsum.toFixed(2));
                });
                $("#membeshipformlist2").unbind('click').on('click', '.updatemember', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    eventFunction.UpdateCustomerName(ids[1]);


                });

                $(".dataTables_scrollBody").css('height', '100%');

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
