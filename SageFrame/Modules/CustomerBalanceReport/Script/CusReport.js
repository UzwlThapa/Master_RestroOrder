function formatAMPM() {
    var date = new Date();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0' + minutes : minutes;
    var strDateTime = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1) + '/' + (date.getDate() < 10 ? '0' : '') + date.getDate() + '/' + date.getFullYear() + "   " + hours + ':' + minutes + ' ' + ampm;
    return strDateTime;
}

function prints() {
    var contents = $('#ViewDetailsReport').html();
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
                ModulePath: '/Modules/CustomerBalanceRport/',
                numpin: ''
            }, p);
        var v = 0;
        var waiter = 0;
        var room = 0;
        var table = 0;
        var year = 0;
        var month = 0;
        var TotalAmount = 0;
        var totamount = 0;
        var htmls = "";
        var remainingbal = 0;
        var openingBalance = 0;
        var providers = [];
        var Custlist = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForCusBalanceReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {

                eventFunction.GetCustomer();
                eventFunction.GetProviderList();

                //$("#txtMonthlyDate").datepicker({
                //    dateFormat: 'yy-m',
                //    changeMonth: true,
                //    changeYear: true,
                //});

                //$(".hide").hide();

                //for (i = new Date().getFullYear() ; i > 1900; i--) {
                //    $('#seit').append($('<option/>').val(i).html(i));
                //}
            },
            init: function () {

                eventFunction.InitialSetup();

                $('#txtSearch').on('keyup', function () {
                    eventFunction.Bindmembership();
                });

                //$("#membeshipformlist2").on('click', '.total', function (event) {
                //    InitializeNumPin(this, $(this).val());
                //});

                $("#btnExport").click(function (e) {
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#membeshipformlist').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "Balance" + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();

                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#membeshipformlist"), 0, 0, options, function () {
                        pdf.save('Balance' + '.pdf');
                    });
                });



                $("#membeshipformlist2").on('click', '.updatemember', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);
                    if ($('#txtCalPaidAmount').val() == "" || parseFloat($('#txtCalPaidAmount').val()) == 0) {
                        jAlert('Please Enter Amount To Pay.', 'ALERT!!');
                    } else {
                        if ($('#selPmntMode').val() == 2 || $('#selPmntMode').val() == 3) {
                            if ($('#txtTransNo').val() == "") {
                                jAlert('Please Enter Transaction/Cheque No.', 'ALERT!!');
                            } else {
                                eventFunction.UpdateCustomerName(id);
                                $("#membeshipformlist2").dialog("close");
                                jAlert('Paid Successfully', 'Information!!');
                            }
                        } else {
                            eventFunction.UpdateCustomerName(id);
                            $("#membeshipformlist2").dialog("close");
                            jAlert('Paid Successfully', 'Information!!');
                        }
                    }
                });

                $('#membeshipformlist2').on('keypress', '#txtCalPaidAmount', function (eve) {
                    if ((eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0)) {
                        eve.preventDefault();
                    }
                    if ($(this).val().indexOf('.') != -1) {
                        if ($(this).val().split('.')[1].length >= 2) {
                            eve.preventDefault();
                        }
                    }
                    $("#membeshipformlist2").on('keyup', '#txtCalPaidAmount', function (event) {
                        $("#txtSettlementAmnt").val("");
                        var TotalAmount = parseFloat($("#txtCalTotalAmount").val());
                        var paidamount = parseFloat($("#txtCalPaidAmount").val());
                        if ($("#txtCalPaidAmount").val() == '') {
                            paidamount = 0;
                        }
                        var totalsum = TotalAmount;
                        //if (paidamount > 0 && paidamount <= TotalAmount) {
                        totalsum = TotalAmount - paidamount
                        //} else {
                        //    $("#txtCalPaidAmount").val("");
                        //}
                        $("#txtCalRemainingAmount").val(totalsum.toFixed(2));
                    });
                });
                $('#membeshipformlist2').on('keypress', '#txtSettlementAmnt', function (eve) {
                    if ((eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0)) {
                        eve.preventDefault();
                    }
                    if ($(this).val().indexOf('.') != -1) {
                        if ($(this).val().split('.')[1].length >= 2) {
                            eve.preventDefault();
                        }
                    }
                    $("#membeshipformlist2").on('keyup', '#txtSettlementAmnt', function (event) {
                        var TotalAmount = parseFloat($("#txtCalTotalAmount").val());
                        var paidamount = parseFloat($("#txtCalPaidAmount").val());
                        if ($("#txtCalPaidAmount").val() == '') {
                            paidamount = 0;
                        }
                        var settlementAmnt = $("#txtSettlementAmnt").val();
                        if ($("#txtSettlementAmnt").val() == '') {
                            settlementAmnt = 0;
                        }
                        var totalsum = TotalAmount;
                        //if (paidamount > 0 && paidamount <= TotalAmount) {
                        totalsum = TotalAmount - paidamount - settlementAmnt;
                        //} else {
                        //    $("#txtCalPaidAmount").val("");
                        //}
                        $("#txtCalRemainingAmount").val(totalsum.toFixed(2));
                    });
                });
                $('#btnCancel').on('click', function () {
                    $('#mobileNumber').val('');
                    $('#smsMessage').val('');
                    $("#sendSmsDialog").dialog('close');
                });

                $("#btnSend").on('click', function () {
                    eventFunction.SendSMS();
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
                        providers = JSON.parse(data.d);
                        break;
                    case 2:
                        receivedlist = data.d;
                        eventFunction.Bindmembership();
                        break;
                    case 3:
                        eventFunction.Bindmember(data);
                        break;
                    case 10:
                        if (data.d != "") {
                            eventFunction.PrintReceipt(data.d);
                            eventFunction.PrintReceipt(data.d);
                        }
                        eventFunction.ResetForm();
                        eventFunction.InitialSetup();
                        break;
                    case 11:

                        console.log(data);
                        eventFunction.bindCustomerTransactionbyID(data);
                        break;
                    case 12:
                        jAlert(data.d, "INFORMATION");
                        $('#mobileNumber').val('');
                        $('#smsMessage').val('');
                        $("#sendSmsDialog").dialog('close');
                        eventFunction.InitialSetup();
                        break;
                    case 13:
                        eventFunction.bindGoodsReceivedDetails(data);
                        break;
                    case 14:
                        $('#printno').show();
                        eventFunction.print();
                        $('#BillingView').dialog('close');
                        break;
                    case 15:
                        var info = JSON.parse(data.d);
                        if (info.length > 0) {

                            eventFunction.PrintCreditReceipt(data.d);
                        } else {
                            jAlert('No data found', 'Information!!', function () { $.alerts.dialogClass = null; });
                        }
                        break;
                    case 16:
                        jAlert('Saved Reason successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        //$("#StartEndReportView").click();
                        //location.reload();
                        break;
                }
            },
            ajaxFailure: function () {

            },


            GetCustomer: function () {
                var IsCustomer = parseInt($("#hdIsCustomer").val());
                eventFunction.config.method = "getCusName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ IsCustomer: IsCustomer });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetProviderList: function () {
                eventFunction.config.method = "GetProviderList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetGoodsReceivedDetailsByGMId: function (gmid) {
                eventFunction.config.method = "GetGoodsReceivedDetailsByGMId";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ gmid: gmid });
                eventFunction.config.ajaxCallMode = 13;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SendSMS: function () {
                var toNumber = $('#mobileNumber').val();
                var textMessage = $('#smsMessage').val();
                eventFunction.config.method = "sendSMS";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ to: toNumber, text: textMessage });
                eventFunction.config.ajaxCallMode = 12;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            Bindmembership: function () {
                debugger;
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var IsCus = parseInt($("#hdIsCustomer").val());
                var datas = receivedlist;
                var total = 0.0;
                var opening = 0.0;
                var openingBalance = 0.0;
                var htmls = "<table id='Brandtable' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Name </th><th>Address </th><th> Contact No. </th><th> Card No. </th><th> Date Of Issue</th><th> Date Of Expire</th><th> PAN</th><th class='tdrate' style='display:none'> Opening Balance (Rs.)</th><th class='tdrate'> Rem Balance (Rs.)</th><th class='tdcenter'> Pay </th><th class='tdcenter'> View </th>";
                // htmls += "<th> Name </th><th>Address </th><th> Contact No. </th><th> Card No. </th><th> Date Of Issue</th><th> Date Of Expire</th><th> PAN</th><th class='tdrate'> Rem Balance (Rs.)</th><th class='tdcenter'> Pay </th><th class='tdcenter'> View </th>";
                if (IsCus == 1) {
                    htmls += "<th class='tdcenter'> SMS </th>";
                };
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.Fname.toLowerCase().includes(search) || value.TelMobile.toLowerCase().includes(search) || value.Lname.toLowerCase().includes(search) || search == '') {
                            htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                            htmls += "<td>" + value.Fname + " " + value.Lname + "</td>";
                            htmls += "<td>" + value.Address + " " + value.City + " " + value.Country + "</td>";
                            //if (value.TelHome != "") {
                            var test = value.TelHome + ", " + value.TelWork + ", " + value.TelMobile
                            //var edited = test.replace(/^,|,$/g, '');
                            var edited = test.replace(/[, ]+/g, "  ").trim();
                            //var edited = test;
                            if (IsCus == 1) {
                                htmls += "<td>" + value.TelMobile + "</td>";
                            }
                            else {
                                htmls += "<td>" + edited + "</td>";
                            }
                            htmls += "<td>" + value.CardNumber + "</td>";
                            var Issue = value.DateOfIssue.split(" ");
                            htmls += "<td>" + Issue[0] + "</td>";
                            var Expire = value.DateOfExpire.split(" ");
                            htmls += "<td>" + Expire[0] + "</td>";
                            htmls += "<td>" + value.PAN + "</td>";
                            htmls += "<td class='tdrate' style='display:none'> Rs. " + value.OpeningBalance + "</td>";
                            htmls += "<td class='tdrate'> Rs. " + value.RemainingBalance + "</td>";
                            //htmls += "<td class='tdrate'> Rs. " + value.RemainingBalance + "</td>";
                            htmls += '<td class="tdcenter"><img id="' + value.MembershipID + '" class="preview-icon PayBalance" type="button" src="/images/pay.png" style="width:20px;"></td>';
                            htmls += '<td class="tdcenter"><img src="/images/view.png" id="' + value.MembershipID + '" class="preview-icon btnViewCustomerTransaction"></label></td>';
                            if (IsCus == 1) {
                                htmls += '<td class="tdcenter"><img src="/images/message.png" id="' + value.MembershipID + '" class="preview-icon btnSendSMS"></label></td>';
                            };
                            htmls += "</tr>"

                            total += value.RemainingBalance;
                            openingBalance += value.OpeningBalance;
                        }
                    });
                } else {

                    htmls += "<tr>";
                    htmls += "<td colspan=11 style='text-align:center;' > No data Available</td>";
                    htmls += "</tr>";

                }
                htmls += "</tbody>";

                htmls += `<tfoot><tr class="tableItem"">
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th></th>
                            <th>Total: </th>
                            <th class="tdrate"> Rs. ${total.toFixed(2)}</th>
                            <th class="tdrate"></th>
                            <th class="tdcenter"></th>
                            <th class="tdcenter"></th>
                            <th class="tdcenter"></th>
                        </tr></tfoot>`;

                htmls += "</table>";
                $('#membeshipformlist').html(htmls);


                $("#Brandtable").on('click', '.PayBalance', function (event) {
                    var id = parseInt($(this).attr('id'));
                    eventFunction.GetCustomerBalance(id);

                });


                $("#BalanceTransactionlist").on('click', '.btnCancelCredit', function (event) {

                    var Username = SageFrameUserName;

                    var nepaliDate = formatDate();

                    var id = $(this).attr('id');
                    var idValues = id.split(',');

                    var id = parseInt(idValues[0]);
                    var MemberID = parseInt(idValues[1]);


                    //eventFunction.GetCustomerBalance(id);
                    var row = $(this).parents('tr');
                    // var name = row.find('td:eq(0)').text();

                    $('.cancelCreditAmount').dialog(
                        {
                            'title': 'Give Reasons',
                            'dialogClass': 'giveReason',
                            "resize": "auto",
                            width: 350,
                            modal: true,
                            buttons: {
                                "Credit Cancel": function () {
                                    var myStr = $("#txtCancelWithReason").val();
                                    var newStr = myStr.replace(/  +/g, ' ');
                                    if (newStr.length <= 4) {
                                        jAlert('Please Insert Valid Cancel Reason.', "Alert!!", function () { $.alerts.dialogClass = null; });
                                    }
                                    else {
                                        var reason = $("#txtCancelWithReason").val();
                                        eventFunction.config.method = "CreditCancelWithReason";
                                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                        eventFunction.config.data = JSON2.stringify({ id: id, memberId: MemberID, userName: Username, reason: reason, date: nepaliDate, restoreOrder: false });
                                        eventFunction.config.data = eventFunction.config.data;
                                        eventFunction.config.ajaxCallMode = 16;
                                        eventFunction.ajaxCall(eventFunction.config);
                                        $(this).dialog('close');

                                    }
                                },
                                Cancel: function () {
                                    $(this).dialog('close');
                                }
                            }
                        }
                    )
                });


                $("#Brandtable").on('click', '.btnViewCustomerTransaction', function (event) {

                    var id = parseInt($(this).attr('id'));
                    var row = $(this).parents('tr');
                    var name = row.find('td:eq(0)').text();
                    var address = row.find('td:eq(1)').text();
                    var Contact = row.find('td:eq(2)').text();
                    var issue = row.find('td:eq(4)').text();
                    var expire = row.find('td:eq(5)').text();
                    var pan = row.find('td:eq(6)').text();
                    var opening = row.find('td:eq(7)').text();
                    var balance = row.find('td:eq(8)').text();

                    remainingbal = parseFloat(balance.split(" ")[2]);
                    openingBalance = parseFloat(opening.split(" ")[2]);
                    htmls = "";
                    htmls += '    <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right:2px;">Print</button>';
                    htmls += '<div id="ViewDetailsReport" style="margin-top:10px;">';
                    htmls += '<table class="popupprint"><tr colspan="2"><th>Name:</th><td>' + name + '</td>';
                    htmls += '<tr><th>Address:</th><td>' + address + '</td><th>Contact:</th><td>' + Contact + '</td></tr>';
                    htmls += '<tr><th>IssueDate:</th><td>' + issue + '</td><th>ExpireDate:</th><td>' + expire + '</td></tr>';
                    htmls += '<tr><th>PAN:</th><td>' + pan + '</td></tr>';
                    htmls += '<tr><th>Opening Balance:</th><td>' + opening + '</td><th>RemainingBalance:</th><td>' + balance + '</td></tr>';
                    htmls += '</table>';
                    htmls += "</div>";
                    $("#BalanceTransactionlist").html(htmls);
                    eventFunction.getCustomerTransactionbyID(id);
                    $("#BalanceTransactionlist").dialog({
                        'title': 'Balance Transaction Record',
                        width: 1024,
                        modal: true,
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                });

                $("#Brandtable").on('click', '.btnSendSMS', function (event) {
                    var id = parseInt($(this).attr('id'));
                    var row = $(this).parents('tr');
                    var name = row.find('td:eq(0)').text();
                    var Contact = row.find('td:eq(2)').text();
                    var balance = row.find('td:eq(8)').text();
                    remainingbal = parseFloat(balance.split(" ")[2]);
                    var message = 'Dear, ' + name + '. Your remaining balance to pay is Rs. ' + remainingbal + '. Pay this credit on time. Thank you!';
                    if (Contact.length > 0) {
                        $("#sendSmsDialog").dialog({
                            'title': 'Send SMS',
                            width: 500,
                            modal: true,
                            resizable: true,
                            dialogClass: 'popup-titlebg'
                        });

                        $('#mobileNumber').val(Contact);
                        $('#smsMessage').val(message);
                    }
                    else {
                        jAlert('Add mobile number before sending message.', 'ALERT!!');
                    }
                });
                $(".dataTables_scrollBody").css('height', '100%');

            },

            getCustomerTransactionbyID: function (id) {

                var MembershipID = id;
                eventFunction.config.method = "getCustomerTransactionbyID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ MembershipID: MembershipID });
                eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);
                // $("#membeshipformlist").dialog('open');
            },

            bindCustomerTransactionbyID: function (result) {
                debugger;

                var data = result.d;
                htmls = "";
                var sn = 1;
                var totalCredit = 0.0, totalPaid = 0.0, totalSettlement = 0.0;
                var currentBal = parseFloat(remainingbal);
                currentBal = 0;
                htmls = '<table id=tblForCustomerTransaction class="reportsprint" cellspacing="0" style="border:none;width:100%;border-collapse:collapse;"><thead>';
                htmls += '<tr><th style="text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Date</th><th style="width:200px;text-align:center;border:1px solid #575757;padding:2px;">Remarks</th><th style="text-align:center;border:1px solid #575757;padding:2px;">Status</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Received By</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Credited Amnt</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Paid Amnt</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Settlement Amnt</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Is Cancelled</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Current Balance</th><th class="tdrate" style="text-align:right;border:1px solid #575757;padding:2px;">Action</th></tr></thead><tbody>';

                let increment = 1;
                if (openingBalance > 0) {
                    increment = 2;
                    currentBal += parseFloat(openingBalance);
                    totalCredit += parseFloat(openingBalance);
                    htmls += `<tr>
                                <td style="text-align:center;border:1px solid #575757;padding:2px;">1</td>
                                <td style="text-align:center;border:1px solid #575757;padding:2px;"></td>
                                <td style="text-align:center;border:1px solid #575757;padding:2px;">Opening Balance</td>
                                <td style="text-align:center;border:1px solid #575757;padding:2px"></td>
                                <td style="text-align:left;border:1px solid #575757;padding:2px;"></td>
                                <td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate"> Rs.${openingBalance.toFixed(2)} </td>
                                <td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>
                                <td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>
                                <td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>
                                <td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">${parseFloat(currentBal).toFixed(2)}</td>
                                <td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>

                                </tr>`;
                }

                var billnoCount = {};

                $.each(data, function (index, value) {
                    var billno = value.billNo;

                    if (billnoCount[billno] === undefined) {
                        billnoCount[billno] = { count: 1, billNo: billno };
                    } else {
                        billnoCount[billno].count++;
                    }
                });

                $.each(data, function (index, value) {

                    //debugger;
                    htmls += '<tr><td style="text-align:center;border:1px solid #575757;padding:2px;">' + (index + increment) + '</td>';
                    if (value.billNo != "") {
                        var ids = value.MemberPayID;
                        if (value.iscustomer == 0) {
                            htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.AddedOn + " <a target='_blank' id='" + value.salesMasterId + "' class='goodreceiveView' >(" + value.billNo + ")</a></td>";
                            htmls += "<td></td>";
                        }
                        else {
                            htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.AddedOn + " <a target='_blank' id='" + value.salesMasterId + "_" + value.SalesType + "' class='billView' >(" + value.billNo + ")</a></td>";
                            htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Remarks + "</td>";
                        }
                    }
                    else {
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.AddedOn + " <a target='_blank' id='" + value.MemberPayID + "' class='                 ' >(CreditPay -" + sn + ")</a></td>";
                        htmls += "<td></td>";
                    }
                    var bal = parseFloat(currentBal);

                    totalPaid += value.PayAmount;
                    totalCredit += value.CreditAmount;
                    totalSettlement += value.SettlementAmount;



                    if (value.CreditAmount == 0) {
                        //debugger;
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;"> Paid </td>';
                        currentBal -= (parseFloat(value.PayAmount) + parseFloat(value.SettlementAmount));
                        htmls += '<td style="text-align:left;border:1px solid #575757;padding:2px;">' + value.AddedBy + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate"> Rs. ' + value.PayAmount + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate"> Rs. ' + value.SettlementAmount + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>';

                    } else {
                        htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;color:red;">Credit</td>';
                        currentBal += parseFloat(value.CreditAmount);
                        htmls += '<td style="text-align:left;border:1px solid #575757;padding:2px;">' + value.AddedBy + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate"> Rs. ' + value.CreditAmount + '</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>';
                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>';
                        if (value.IsCancelled == true) {
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">' + value.IsCancelled + '</td>';
                        } else {
                            htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate"> -</td>';

                        }
                    }


                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;"class="tdrate">' + parseFloat(currentBal).toFixed(2) + '</td>';
                    if (value.CreditAmount > 0 && value.IsCancelled != true && billnoCount[value.billNo].count <= 1) {
                        // Check if the bill count is 1
                        htmls += '<td class="tdcenter"><label id="' + value.MemberPayID + "," + value.MemberID + '" class="icon-close btnCancelCredit"></label></td>';

                    } else {

                        htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;" class="tdrate">-</td>';
                        // htmls += '<td class="tdcenter">-</td>';
                    }
                    htmls += '</tr>';
                    // totalBalance += value.PayAmount;
                    sn++;
                });
                // htmls += '<tr><td></td><td>Total : </td><td>' + totalBalance + '</td><td></td><td></td></tr>';

                htmls += '</tbody>';

                htmls += `<tfoot>
                                <tr>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td style="text-align:left;border:1px solid #575757;padding:2px;">Total : </td>
                                    <td style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ${totalCredit.toFixed(2)}</td>
                                    <td style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ${totalPaid.toFixed(2)}</td>
                                    <td style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ${totalSettlement.toFixed(2)}</td>
                                    <td style="text-align:left;border:1px solid #575757;padding:2px;">-</td>
                                    <td style="text-align:right;border:1px solid #575757;padding:2px;">Rs. ${(totalCredit - totalPaid - totalSettlement).toFixed(2)}</td>
                                    <td style="text-align:left;border:1px solid #575757;padding:2px;">-</td>

                                </tr>
                            </tfoot>`;
                htmls += '</table>';
                $("#ViewDetailsReport").append(htmls);

                $('#tblForCustomerTransaction').on('click', '.billView', function () {

                    var ids = $(this).attr('id').split("_");

                    if (!["", "null", null, undefined].includes(ids[1])) {
                        getSalesReport_CakeBill(ids[0], ids[1])
                    }
                    else {
                        var salesmasterid = ids[0];
                        getBill(salesmasterid, false);
                    }

                    $("#BillingView").dialog({
                        'title': 'Vat Bill',
                        width: '350',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top'],
                        dialogClass: 'popup-titlebg',
                    });

                    $('#btnPrintsBill').unbind('click').on('click', function () {
                        $('#divPrintedOn').text(formatAMPM());
                        eventFunction.config.method = "savePrintCount";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({
                            Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                        });
                        eventFunction.config.ajaxCallMode = 14;
                        eventFunction.ajaxCall(eventFunction.config);
                    });
                });

                $('#tblForCustomerTransaction').on('click', '.CreditView', function () {

                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.method = "getcustomerbalanceReceipt";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ memberpayid: id });
                    eventFunction.config.ajaxCallMode = 15;
                    eventFunction.ajaxCall(eventFunction.config);
                });

                $('#tblForCustomerTransaction').on('click', '.goodreceiveView', function () {
                    var gmid = $(this).attr('id');
                    eventFunction.GetGoodsReceivedDetailsByGMId(gmid);
                    $("#goodReveivedDiv").dialog({
                        'title': 'Goods Received Details',
                        width: '500',
                        height: 'auto',
                        //modal: true,
                        //position: ['center', 'top'],
                        //dialogClass: 'popup-titlebg',
                    });
                });
                $('#tblForCustomerTransaction').DataTable(
                    {
                        "bJQueryUI": true,
                        ordering: false,
                        searching: false,
                        paging: false,
                        bFilter: false
                    });

                // var spoff = 
                $("#btnPrints").click(function () {
                    $('.popupprint').css('width', '100%');
                    $('.popupprint td , .popupprint th ').css('text-align', 'left');
                    prints();
                });
            },

            GetCustomerBalance: function (id) {
                var MembershipID = id;
                eventFunction.config.method = "GetCusOnChange";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ MembershipID: MembershipID });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
                // $("#membeshipformlist").dialog('open');
            },

            Bindmember: function (data) {
                $("#membeshipformlist2").show();
                $("#membeshipformlist2").html('');

                var value = data.d;
                debugger;
                var htmls = '';
                $.ajax({
                    type: "POST",
                    url: "/Modules/AdvanceReport/AdvanceReportService.asmx/GetPaymentModes",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {

                        debugger;
                        htmls += "<table style='display:block;'>"
                        htmls += "<tr>"
                        htmls += "<td style='font-size:17px;'>Balance (Rs.)</td>"
                        htmls += "<td style='font-size:17px;'>Payment Mode</td>"
                        htmls += "</tr>"
                        htmls += "<tr>"
                        htmls += "<td><input type='textbox' disable value='" + value.RemainingBalance + " ' placeholder='Total Amt' class='sfInputbox total' id='txtCalTotalAmount' style='width:120px;' readonly='readonly'/></td>";
                        htmls += "<td><select id='selPmntMode' class='sfInputbox' style='width:120px;'>";

                        var response = JSON.parse(response.d ?? '{}');
                        if (response != null && response.length > 0) {
                            $.each(response, function (index, item) {
                                htmls += "<option value='" + item.PaymentModeID + "'>" + item.PaymentMode + "</option>FonePay</option>";
                            });
                        }

                        htmls += "</select></td>";
                        htmls += "</tr>"
                        htmls += "<tr>"
                        htmls += "<td><input type='textbox' placeholder='Paid Amt' class='sfInputbox total' id='txtCalPaidAmount' name='PaidAmount'  style='width:120px;'/></td>";
                        htmls += "<td class='pmntTransaction' style='text-align:left;display:none;'><select id='selProvider' class='sfInputbox' style='width:auto;'>";
                        $.each(providers, function (index, item) {
                            htmls += "<option value='" + item.ProviderID + "'>" + item.ProviderName + "</option>";
                        });
                        htmls += "</select></td>";
                        htmls += "</tr>"
                        htmls += "<tr>"
                        htmls += "<td><input type='textbox' placeholder='Settlement Amt' class='sfInputbox total' id='txtSettlementAmnt' style='width:120px;'/></td>";
                        htmls += "<td class='pmntTransaction' style='text-align:left;display:none;'><input type='textbox' placeholder='Transac./Cheque No' class='sfInputbox' id='txtTransNo' style='width:auto;'/></td>";
                        htmls += "</tr>"
                        htmls += "<tr>"
                        htmls += "<td><input type='textbox' placeholder='RMNG Amt' class='sfInputbox total' id='txtCalRemainingAmount' style='width:120px;' readonly='readonly'/></td>";
                        htmls += "<td></td>";
                        htmls += "</tr>"

                        htmls += "<tr>"

                        htmls += "<td>" + "<input class='sfBtn restro-btn updatemember' type='button'  id=_" + value.MembershipID + " value='Pay the Bill'  /></td>";
                        htmls += "</tr>"
                        htmls += "</table>"


                        $('#membeshipformlist2').html(htmls);

                        $("#membeshipformlist2").dialog({
                            'title': (value.IsCustomer ? 'Customer Pay : ' : 'Vendor Pay : ') + value.Name,
                            width: 400,
                            modal: true,
                            resizable: true,
                            dialogClass: 'popup-titlebg',
                        });

                    },
                    error: function (msg) { FileManager.errorFn(); }
                });

                $('#selPmntMode').on('change', function () {

                    if ($(this).val() == 1 || $(this).val() == 5 || $(this).val() == 6) {
                        $('.pmntTransaction').hide();
                    } else {
                        $('.pmntTransaction').show();
                    }

                });

            },

            UpdateCustomerName: function (id) {
                debugger;
                var MembershipID = id;
                var MemberInfo = {};
                var payment = {};

                MemberInfo.MembershipID = MembershipID;
                MemberInfo.RemainingBalance = $('#txtCalRemainingAmount').val();
                MemberInfo.PayAmount = $('#txtCalPaidAmount').val();
                MemberInfo.SettlementAmount = ($('#txtSettlementAmnt').val() == '' ? 0 : $('#txtSettlementAmnt').val());
                MemberInfo.AddedBy = SageFrameUserName;

                payment.PaymentModeID = $('#selPmntMode').val();
                payment.PaymentMode = $('#selPmntMode option:selected').text();
                payment.MemberID = MembershipID;
                payment.ProviderID = ($('#selPmntMode').val() == 1 ? 0 : $('#selProvider').val());
                payment.TransactionNo = ($('#selPmntMode').val() == 1 ? '' : $('#txtTransNo').val());
                eventFunction.config.method = "SaveCustomerAmount";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ MemberInfo: MemberInfo, payment: payment });

                eventFunction.config.ajaxCallMode = 10;
                {
                    $("#membeshipformlist2").hide();
                }

                eventFunction.ajaxCall(eventFunction.config);
            },


            PrintReceipt: function (result) {
                debugger;
                var data = JSON.parse(result);
                var companyInfo = data.company;
                var memberInfo = data.member;
                var paymentInfo = data.paymentMode;
                var comphtmls = "";
                //htmls += "<div id='customer-bill' style='text-align:center;width:100%;'>";
                comphtmls += ("<table style='width:300px;padding-bottom:5px;text-align:center;border-bottom:1px dotted;'>");
                comphtmls += ("<tr><td colspan='2' style='font-size:18px;text-align:center;font-weight:bold;'>" + companyInfo.Name + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:14px;text-align:center;'>" + companyInfo.Address + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:14px;text-align:center;'>" + companyInfo.PhoneNo + "</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:center;'><b id='InvoiceType'>Credit Payment Receipt</b></td></tr>");
                var date = formatAMPM().split(' ');
                comphtmls += ("<tr><td style='font-size:16px;text-align:left;border-bottom:1px dotted;'>Date:" + date[0] + "</td>")
                comphtmls += ("<td style='font-size:16px;text-align:right;border-bottom:1px dotted;'>Time:" + date[3] + ' ' + date[4] + "</td></tr>");

                //comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;padding-top:5px;'><span style='font-weight: bold;'>Recieipt No : </span><span style='font-style:italic;'>" + paymentInfo.VoucherNo + "</span></td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Received From : </span><span style='font-style:italic;'>M/S " + memberInfo.Name + "</span> </td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Amount : </span><span style='font-style:italic;'>Rs." + memberInfo.PayAmount + "</span> /-</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;border-bottom:1px dotted;'><span style='font-weight: bold;'>In Words : </span><span style='font-style:italic;'>" + data.amountInWords + " Only </span></td></tr> ");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;padding-top:5px;'><span style='font-weight: bold;'>Paid By : </span><span style='font-style:italic;'>");
                if (paymentInfo.PaymentModeID == 1) {
                    comphtmls += "CASH</span></td></tr>"
                } else {
                    comphtmls += paymentInfo.PaymentMode;
                    comphtmls += '# ' + paymentInfo.TransactionNo + '</span> </td></tr>';
                    comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Provided By : </span><span style='font-style:italic;'>");
                    $.each(providers, function (index, item) {
                        if (item.ProviderID == paymentInfo.ProviderID) {
                            comphtmls += item.ProviderName;
                            return false;
                        }
                    });
                    comphtmls += ("</span></td></tr>");
                }
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;padding-top:5px;border-top:1px dotted;'><span style='font-weight: bold;'>Current Balance : </span><span style='font-style:italic;'>Rs. " + parseFloat(memberInfo.RemainingBalance + memberInfo.PayAmount + memberInfo.SettlementAmount).toFixed(2) + "</span> /-</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Pay Amount :</span><span style='font-style:italic;'> Rs. " + memberInfo.PayAmount + "</span> /-</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Settlement : </span><span style='font-style:italic;'>Rs. " + memberInfo.SettlementAmount + "</span> /-</td></tr>");
                comphtmls += ("<tr><td colspan='2' style='font-size:16px;text-align:left;'><span style='font-weight: bold;'>Balance Due : </span><span style='font-style:italic;'>Rs. " + memberInfo.RemainingBalance + "</span> /-</td></tr> ");

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
                var logoInfo = comphtmls;

                var contents = logoInfo;
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
            bindGoodsReceivedDetails: function (result) {
                var datas = JSON.parse(result.d);

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

                $('#goodReceiveTable').DataTable({
                    "bJQueryUI": true,
                    ordering: false,
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

            PrintCreditReceipt: function (result) {
                debugger;
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var paymentInfo = JSON.parse(result);
                $('#getReceiptbill').html('');
                var comphtmls = "";
                //htmls += "<div id='customer-bill' style='text-align:center;width:100%;'>";
                comphtmls += '<button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrintReceipt" style="margin-right:2px;">Print</button>';
                comphtmls += "<div id='dialogOrderOpen'>";
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
                comphtmls += "</div>";
                $('#getReceiptbill').html(comphtmls);

                $('#getReceiptbill').dialog({
                    'title': 'Credit Payment Receipt',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'center']
                });

                $("#btnPrintReceipt").click(function () {
                    var id = paymentInfo[0].MemberPayId;
                    var contents = $('#dialogOrderOpen').html();
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

                        //// refresh complimentary orders
                        //alert('Print successfull');
                        $('#getReceiptbill').dialog('close');

                        //eventFunction.getCustomerTransactionbyID(id);
                    }, 500);

                });
            },
            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#textUnit').val('');
            },
            ResetForm: function () {
                //eventFunction.GetCustomer();
                $('#txtTotalAmount').val('');
                $('#txtTenderAmount').val('');
                $('#txtReturnAmount').val('');
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        PaidAmount: {
                            required: true,
                            number: true,
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