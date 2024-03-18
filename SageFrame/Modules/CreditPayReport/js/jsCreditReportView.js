(function ($) {
    $.CReport = function (p) {
        var arrayNote = [];
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/CreditPayReport/service/',
                master: '0',
            }, p);
        var v = 0;
        var DiffAmount = 0;
        var Statement = "";
        var SalesStatement = "";
        var getClosingReport_StateWisegetClosingReport_StateWise = "";
        var StatementCategoryWise = "";
        var StatementBillWiseSales = "";
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var stat = 0;
        var member = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WSforCredit.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0
            },

            init: function () {
                $("#btnView").click(function () {
                    $('.report-view').show();
                    if ($('#selPaymentType').val() == -1) {
                        eventFunction.getMixedPayReportByDates();
                    }
                    else if ($('#selPaymentType').val() == 0) {
                        eventFunction.getCreditPayReportByDates();
                    }
                    else {
                        eventFunction.getCreditPay();
                    }
                });

                $('#selMembershipType').on('change', function () {
                    eventFunction.GetItem();
                });


                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#divForCreditPayReport').clone();
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

                $('#getReceiptbill').on('click', '#btnPrintReceipt', function () {
                    $('#btnPrintReceipt').hide();
                    var contents = $('#getReceiptbill').clone();
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

                    $('#btnPrintReceipt').show();
                });

                //--------------------------Export To EXCEL----------------

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    let file = new Blob([$('#divForCreditPayReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "CreditPayReport_" + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    var contents = $('#divForCreditPayReport');
                    var options = {
                        background: '#FFFFFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.22;
                    pdf.addHTML(contents, 0, 0, options, function () {
                        pdf.save('CreditPayReport_' + $('#txtStartDate').val() + '_' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();

                });
            },
            getCreditPayReportByDates: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                var membershipType = $("#selMembershipType").val() == -1 ? null : $("#selMembershipType").val();
                var customer = $("#txtName").val() == '' ? null : $("#txtName").val();
                eventFunction.config.method = "getCreditPayReportByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ sdate: startdate, edate: enddate, customer: customer, isCustomer: membershipType });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getMixedPayReportByDates: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                var membershipType = $("#selMembershipType").val() == -1 ? null : $("#selMembershipType").val();
                var customer = $("#txtName").val() == '' ? null : $("#txtName").val();
                eventFunction.config.method = "getMixedPayReportByDates";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ sdate: startdate, edate: enddate, customer: customer, isCustomer: membershipType });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
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
                        eventFunction.bindCreditPayReport(data.d);
                        break;
                    case 2:
                        eventFunction.Bindmembership(data.d);
                        break;
                    case 3:
                        eventFunction.bindCreditReport(data.d);
                        break;
                    case 4:
                        eventFunction.bindGoodsReceivedDetails(data.d);
                        break;
                    case 5:
                        eventFunction.PrintReceipt(data.d);
                        break;
                    case 6:
                        eventFunction.bindMixedCreditReport(data.d);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            GetGoodsReceivedDetailsByGMId: function (gmid) {
                eventFunction.config.method = "GetGoodsReceivedDetailsByGMId";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ gmid: gmid });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getCreditPay: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                var membershipType = $("#selMembershipType").val() == -1 ? "true" : $("#selMembershipType").val();
                var customer = $("#txtName").val() == '' ? null : $("#txtName").val();
                eventFunction.config.method = "getCreditReports";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ sdate: startdate, edate: enddate, customer: customer, isCustomer: membershipType });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCustomer: function () {
                var IsCustomer = parseInt($("#hdIsCustomer").val());
                eventFunction.config.method = "getCusName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ IsCustomer: IsCustomer });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetItem: function () {
                var customer = $("#selMembershipType").val() == "true" ? 1 : 0;
                eventFunction.config.method = "getmembershiplist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ customer: customer });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            // txtName
            Bindmembership: function (result) {
                memberList = JSON.parse(result);
                member = [];
                if (memberList.length > 0) {
                    $.each(memberList, function (index, value) {
                        member.push({ label: value.Name, id: value.MembershipID });
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

            bindCreditReport: function (result) {

                CreditList = JSON.parse(result);
                $("#divForCreditPayReport").html('');
                var htmls = "";
                var sn = 1;
                var totalpaid = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Credit Pay Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += '<table class="tableforlisting reportsprint" cellspacing="0" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Date</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Bill no. / GMNo.</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Customer Name</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Membership</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Paid Amount (Rs.)</th></tr></thead><tbody>';
                if (CreditList.length > 0) {
                    $.each(CreditList, function (index, value) {
                        htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                        if (value.iscustomer == 0) {
                            htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;'><a target='_blank' id='" + value.salesMasterId + "' class='goodreceiveView' >" + value.billNo + "</a></td>";
                        }
                        else {
                            htmls += "<td style='text-align:right;border:1px solid #575757;padding:2px;'><a target='_blank' id='" + value.salesMasterId + "' class='billView' >" + value.billNo + "</a></td>";
                        }
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';

                        htmls += '</tr>';
                        totalpaid = totalpaid + value.PayAmount;
                        sn++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='5' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += '</tbody><tfoot>';
                htmls += '<tr><th colspan=5 ></th><th style="text-align:right;font-weight: bold;">Total:  Rs. ' + totalpaid.toFixed(2) + '</th></tr>';
                htmls += '</tfoot></table> ';

                $("#divForCreditPayReport").html(htmls);


                $('#divForCreditPayReport').on('click', '.billView', function () {
                    var salesmasterid = $(this).attr('id');
                    getBill(salesmasterid, false);

                    $("#customer-bill").dialog({
                        'title': 'Vat Bill',
                        width: '350',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top'],
                        dialogClass: 'popup-titlebg',
                    });
                });

                $('#divForCreditPayReport').on('click', '.goodreceiveView', function () {
                    var gmid = $(this).attr('id');
                    eventFunction.GetGoodsReceivedDetailsByGMId(gmid);
                    $("#goodReveivedDiv").dialog({
                        'title': 'Goods Received Details',
                        width: '500',
                        height: 'auto',
                    });
                });

            },

            bindCreditPayReport: function (result) {
                CreditList = JSON.parse(result);
                $("#divForCreditPayReport").html('');
                var htmls = "";
                var sn = 1;
                var totalpaid = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Credit Pay Report </p> <p style="text-align:center;margin:0;"> From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += '<table class="tableforlisting reportsprint" cellspacing="0" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Date</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Customer Name</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Membership</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Paid Amount (Rs.)</th><th style="text-align:center;border:1px solid #575757;padding:2px;">View</th></tr></thead><tbody>';
                if (CreditList.length > 0) {
                    //$("#btnPrint").show();
                    $.each(CreditList, function (index, value) {
                        if ($("#selMembershipType").val() == -1) {
                            htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';
                            htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MemberPayId + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                            htmls += '</tr>';
                            totalpaid = totalpaid + value.PayAmount;
                        }
                        else if ($("#selMembershipType").val() == "true") {
                            if (value.CustType == "Customer")
                                htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';
                            htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MemberPayId + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                            htmls += '</tr>';
                            totalpaid = totalpaid + value.PayAmount;
                        } else {
                            if (value.CustType == "Vendor") {
                                htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';
                                htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MemberPayId + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                                htmls += '</tr>';
                                totalpaid = totalpaid + value.PayAmount;
                            }
                        }

                        sn++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='5' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += '</tbody><tfoot>';
                htmls += '<tr><th colspan=4 ></th><th style="text-align:right;font-weight: bold;">Total:  Rs. ' + totalpaid.toFixed(2) + '</th></tr>';
                htmls += '</tfoot></table> ';

                $("#divForCreditPayReport").html(htmls);

                $('.btnViewCustomerTransaction').on('click', function (event) {
                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.method = "getcustomerbalanceReceipt";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ memberpayid: id });
                    eventFunction.config.ajaxCallMode = 5;
                    eventFunction.ajaxCall(eventFunction.config);

                });
            },

            bindMixedCreditReport: function (result) {

                CreditList = JSON.parse(result);
                $("#divForCreditPayReport").html('');
                var htmls = "";
                var sn = 1;
                var totalpaid = 0;
                var totalCredit = 0;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Credit Pay Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += `<table class="tableforlisting reportsprint" cellspacing="0" style="border:none;width:100%;border-collapse:collapse;">
	                        <thead>
		                        <tr>
			                        <th style="text-align:center;border:1px solid #575757;padding:2px;">S.N.</th>
			                        <th style="text-align:center;border:1px solid #575757;padding:2px;">Date</th>
			                        <th class="tdrate" style="text-align:center;border:1px solid #575757;padding:2px;">Bill no./GMNo.</th>
			                        <th style="text-align:center;border:1px solid #575757;padding:2px;">Customer Name</th>
			                        <th style="text-align:center;border:1px solid #575757;padding:2px;">Membership</th>
			                        <th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Credit Amount (Rs.)</th>
			                        <th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Paid Amount (Rs.)</th>
		                        </tr>
	                        </thead>
	                        <tbody>`;
                if (CreditList.length > 0) {
                    $.each(CreditList, function (index, value) {
                        if (value.TrType == 1) {
                            htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                            if (value.TrType == 1) {
                                if (value.iscustomer == 0) {
                                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'><a target='_blank' id='" + value.salesMasterId + "' class='goodreceiveView' >" + value.billNo + "</a></td>";
                                }
                                else {
                                    htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'><a target='_blank' id='" + value.salesMasterId + "' class='billView' >" + value.billNo + "</a></td>";
                                }
                            }
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                            htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.CreditAmount + '</td>';
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';

                            htmls += '</tr>';

                        }
                        else {

                            if ($("#selMembershipType").val() == -1) {
                                htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">-</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.CreditAmount + '</td>';
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';
                                htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MemberPayId + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                                htmls += '</tr>';
                                //totalpaid = totalpaid + value.PayAmount;
                            }
                            else if ($("#selMembershipType").val() == "true") {
                                if (value.CustType == "Customer")
                                    htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">-</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                                htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.CreditAmount + '</td>';
                                htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';
                                htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MemberPayId + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                                htmls += '</tr>';
                                //totalpaid = totalpaid + value.PayAmount;
                            } else {
                                if (value.CustType == "Vendor") {
                                    htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + sn + '</td>';
                                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.AddedOn.split(' ')[0] + '</td>';
                                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">-</td>';
                                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustName + '</td>';
                                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + value.CustType + '</td>';
                                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.CreditAmount + '</td>';
                                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"> Rs. ' + value.PayAmount + '</td>';
                                    htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MemberPayId + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                                    htmls += '</tr>';
                                    //totalpaid = totalpaid + value.PayAmount;
                                }
                            }

                        }
                        totalCredit += value.CreditAmount;
                        totalpaid += value.PayAmount;
                        sn++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='5' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += '</tbody><tfoot>';
                htmls += '<tr><th colspan=4 ></th><th style="text-align:right;font-weight: bold;">Total: </th><th style="text-align:right;font-weight: bold;">Rs. ' + totalCredit.toFixed(2) + '</th><th style="text-align:right;font-weight: bold;">Rs. ' + totalpaid.toFixed(2) + '</th></tr>';
                htmls += '</tfoot></table> ';

                $("#divForCreditPayReport").html(htmls);


                $('#divForCreditPayReport').on('click', '.billView', function () {
                    var salesmasterid = $(this).attr('id');
                    getBill(salesmasterid, false);

                    $("#customer-bill").dialog({
                        'title': 'Vat Bill',
                        width: '350',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top'],
                        dialogClass: 'popup-titlebg',
                    });
                });

                $('#divForCreditPayReport').on('click', '.goodreceiveView', function () {
                    var gmid = $(this).attr('id');
                    eventFunction.GetGoodsReceivedDetailsByGMId(gmid);
                    $("#goodReveivedDiv").dialog({
                        'title': 'Goods Received Details',
                        width: '500',
                        height: 'auto',
                    });
                });

                
                $('.btnViewCustomerTransaction').on('click', function (event) {
                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.method = "getcustomerbalanceReceipt";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ memberpayid: id });
                    eventFunction.config.ajaxCallMode = 5;
                    eventFunction.ajaxCall(eventFunction.config);

                });

            },


            bindGoodsReceivedDetails: function (result) {
                var datas = JSON.parse(result);
                var htmls = '';
                $('#goodReveivedDiv').html(htmls);
                htmls += '<table id="goodReceiveTable">';
                htmls += '<thead><tr><th>SN</th><th>Item Name</th><th>Quantity</th><th>Rate</th><th>Total</th></tr></thead>';
                htmls += '<tbody>';
                $.each(datas, function (index, value) {
                    htmls += '<tr>';
                    htmls += '<td>' + (index + 1) + '</td>';
                    htmls += '<td>' + value.ItemName + '</td>';
                    htmls += '<td>' + value.Qnty + ' ' + value.Symbol + '</td>';
                    htmls += '<td>' + value.Rate + '</td>';
                    htmls += '<td>' + value.Total + '</td>';
                    htmls += '</tr>';
                });
                htmls += '</tbody>';
                htmls += '</table>';
                $('#goodReveivedDiv').html(htmls);
            },


            PrintReceipt: function (result) {
                debugger;
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var paymentInfo = JSON.parse(result);
                $('#getReceiptbill').html('');
                var comphtmls = "";
                //htmls += "<div id='customer-bill' style='text-align:center;width:100%;'>";
                comphtmls += '<button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrintReceipt" style="margin-right:2px;">Print</button>';
                comphtmls += ("<table style='width:300px;padding-bottom:5px;text-align:center;border-bottom:1px dotted;'>");
                comphtmls += ("<tr><td colspan='2' style='font-size:18px;text-align:center;font-weight:bold;padding-top:15px;'>" + companyInfo.Name + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:14px;text-align:center;'>" + companyInfo.Address + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:14px;text-align:center;'>" + companyInfo.PhoneNo + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:center;'><b id='InvoiceType'>Credit Payment Receipt</b></td></tr>");
                var date = paymentInfo[0].AddedOn.split(' ');
                comphtmls += ("<tr><td style='font-size:16px;text-align:left;border-bottom:1px dotted;'>Date:" + date[0] + "</td>")
                comphtmls += ("<td style='font-size:16px;text-align:right;border-bottom:1px dotted;'>Time:" + date[1] + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Received From : </span><span style='font-style:italic;'>M/S " + paymentInfo[0].CustomerName + "</span> </td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Amount : </span><span style='font-style:italic;'>Rs." + paymentInfo[0].PayAmount + "</span> /-</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;border-bottom:1px dotted;'><span style='font-weight: bold;'>In Words : </span><span style='font-style:italic;'>" + convertNumberToWords(paymentInfo[0].PayAmount) + " Only </span></td></tr> ");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;padding-top:5px;'><span style='font-weight: bold;'>Paid By : </span><span style='font-style:italic;'>");
                if (paymentInfo[0].PaymentModeID == 1) {
                    comphtmls += "CASH</span></td></tr>"
                } else {
                    comphtmls += (paymentInfo[0].PaymentModeID == 2 ? 'CHEQUE ' : 'CARD ');
                    comphtmls += '# ' + paymentInfo[0].TransactionNo + '</span> </td></tr>';
                    comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Provided By : </span><span style='font-style:italic;'>" + paymentInfo[0].ProviderName + "</span></td></tr>");
                }
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Pay Amount :</span><span style='font-style:italic;'> Rs. " + paymentInfo[0].PayAmount + "</span> /-</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Settlement : </span><span style='font-style:italic;'>Rs. " + paymentInfo[0].SettlementAmount + "</span> /-</td></tr>");

                comphtmls += ("<tr>");
                comphtmls += ("<td style='text-align:left;font-size:14px;padding-top:10px;padding-bottom:10px;'>");
                comphtmls += ("<div style='text-align:center;border-top:1px solid;width:150px;padding-top:10px;padding-bottom:10px;margin-top:50px;'>Payee Signature</div>");
                comphtmls += ("</td>");
                comphtmls += ("<td style='text-align:right;font-size:14px;padding-top:10px;padding-bottom:10px;'>");
                comphtmls += ("<div style='float:right;text-align:center;border-top:1px solid;width:150px;padding-top:10px;margin-top:50px;padding-bottom:10px;'>Signature (" + SageFrameUserName + ")</div>");
                comphtmls += ("</td>");
                comphtmls += ("</tr>");
                comphtmls += ("<td colspan=2 style='text-align:center;font-size:12px;'>");
                comphtmls += ("**Thank You**");
                comphtmls += ("</td>");
                comphtmls += ("</tr>");
                comphtmls += ("</table>");
                $('#getReceiptbill').html(comphtmls);

                $('#getReceiptbill').dialog({
                    'title': 'Credit Payment Receipt',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'center']
                });


            },
        };
        eventFunction.init();
    };
    $.fn.CReports = function (p) {
        $.CReport(p);
    };
})(jQuery);