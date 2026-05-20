(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/ChartOfAccount/verifyTransactionEntry/webService/'
            }, p);
        var selectedIndex = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsVerifyTransactionEntry.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0,
                transactionID: 0,
            },
            InitialSetup: function () {
                eventFunction.getVoucharTypeForDropDown();
                eventFunction.getFinancialAcName();
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnCancel").click(function () {
                    eventFunction.Reset();
                });

                $("#btnView").off('click').on('click', function () {
                    eventFunction.getTempTransactionList();
                });

                $("#btnViewVerified").off('click').on('click', function () {
                    eventFunction.getVerifiedTransactionList();
                });

                $('#btnverify').on('click', function () {

                    var voucherId = new Array;
                    if ($('.checkbox:checked').length > 0) {
                        $(".checkbox:checked").each(function () {
                            var Transaction = new Object;
                            Transaction.TransactionID = $(this).parents('tr').attr("val");
                            voucherId.push(Transaction);
                        });

                        // check if autopurchase transaction is verified
                        $.ajax({
                            type: "POST",
                            url: eventFunction.config.baseURL + "TempPurchaseDetailExists",
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {

                                var response = JSON.parse(response.d ?? '{}');
                                if (response['PuNo'] != '') {
                                    jAlert(`Please settle Purchase Voucher: ${response['PuNo']} to proceed!`, 'Information!!', function () { $.alerts.dialogClass = null; });
                                } else {
                                    jConfirm('Do you want to verify all selected Voucher?', 'Confirm!', function (confirm) {
                                        if (confirm) {
                                            eventFunction.config.method = "SaveVerifiedTransactionByID";
                                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                            eventFunction.config.data = JSON2.stringify({ Transaction: voucherId });
                                            eventFunction.config.ajaxCallMode = 2;
                                            eventFunction.ajaxCall(eventFunction.config);
                                        }
                                    });
                                }

                            },
                            error: function (msg) { FileManager.errorFn(); }
                        });
                        eventFunction.config.method = "TempPurchaseDetailExists";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = null;
                        eventFunction.config.ajaxCallMode = 13;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    else {
                        jAlert('Please Select Voucher first.', 'ALERT!!');
                    }
                });

                $(".AccountForm").on("click", ".addNewRow", function () {
                    $(".addNewRow").unbind('click');

                    if ($(".selFinancialAc").val() == null) {
                        jAlert("Please Select The Financial Account!", 'Information!!', function () { $.alerts.dialogClass = null; });
                    } else if ($(".txtAcDescription").val() == "") {
                        jAlert("Please Fill Acccount Description!", 'Information!!', function () { $.alerts.dialogClass = null; });
                    } else if ($(".txtDebit").val() == "") {
                        jAlert("Please Fill The Debit!", 'Information!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($(".txtCredit").val() == "") {
                        jAlert("Please Fill The Credit!", 'Information!!', function () { $.alerts.dialogClass = null; });

                    }
                    else {
                        var checkValid = eventFunction.ValidationForm();
                        if (checkValid) {
                            var htmls = "";
                            htmls += '<tr><td>' + $(".selFinancialAc").val() + '</td>';
                            htmls += '<td>' + $(".hdnFinancialAcID").val() + '</td>';
                            htmls += '<td>' + $(".txtAcDescription").val() + '</td>';
                            htmls += '<td>' + parseFloat($(".txtDebit").val()).toFixed(2) + '</td>';
                            htmls += '<td>' + parseFloat($(".txtCredit").val()).toFixed(2) + '</td>';
                            htmls += '<td>' + $(".txtChequeNo").val() + '</td>';
                            if ($(".txtChequeNo").val() == '') {
                                htmls += '<td></td>';
                            } else
                                htmls += '<td>' + $(".txtChequeDate").val() + '</td>';
                            htmls += '<td><label class="delete icon-delete" value="Delete"></label></td></tr>';
                            $(".tblForTempFinancialAc tbody").append(htmls);
                            var rowCount = $('.tblForTempFinancialAc tbody tr').length;
                            var sumDebit = 0;
                            var sumCredit = 0;
                            for (var i = 0; i < rowCount; i++) {
                                sumDebit += parseFloat($(".tblForTempFinancialAc tbody").find('tr:eq(' + i + ')').find('td:eq(3)').text());
                            }
                            $("#lblDebitTotal").text(sumDebit.toFixed(2));

                            for (var i = 0; i < rowCount; i++) {
                                sumCredit += parseFloat($(".tblForTempFinancialAc tbody").find('tr:eq(' + i + ')').find('td:eq(4)').text());
                            }
                            $("#lblCreditTotal").text(sumCredit.toFixed(2));

                            $(".selFinancialAc").val('');
                            $(".hdnFinancialAcID").val("");
                            $(".txtAcDescription").val("");
                            $(".txtDebit").val("");
                            $(".txtCredit").val("");
                            $(".bank").hide();
                            $(".txtChequeNo").val("");
                            $(".txtChequeDate").datepicker('setDate', new Date());
                            $(".tblForTempFinancialAc").show();
                        }
                    }
                });

                $(".tblForTempFinancialAc").on("click", ".edit", function () {
                    jAlert('You clicked row ' + ($(this).index() + 1), 'Information!!', function () { $.alerts.dialogClass = null; });
                    jAlert(this.rowIndex, 'Information!!', function () { $.alerts.dialogClass = null; });
                    jAlert($('tr').index(this), 'Information!!', function () { $.alerts.dialogClass = null; });
                });
                $(".tblForTempFinancialAc").on("click", ".delete", function () {
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            $("#lblDebitTotal").text(parseFloat(parseFloat($("#lblDebitTotal").text()) - parseFloat($(row).find('td:eq(3)').text())).toFixed(2));
                            $("#lblCreditTotal").text(parseFloat(parseFloat($("#lblCreditTotal").text()) - parseFloat($(row).find('td:eq(4)').text())).toFixed(2));
                            row.remove();
                        }
                    });
                });

                $(".tblForFinancialAc").on("change", ".txtDebit", function () {
                    $(".txtCredit").val(0);
                });

                $(".tblForFinancialAc").on("change", ".txtCredit", function () {
                    $(".txtDebit").val(0);
                });

                $("#selVoucharType").change(function () {
                    $(".Title").html($('#selVoucharType :selected').text());
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $(".AccountForm").show();
                    $(".tblForTempFinancialAc").hide();

                });
                $(".selFinancialAc").change(function () {
                    var ids = $('.hdnFinancialAcID').val();
                    if (ids != '') {
                        eventFunction.config.method = "CheckForDisplayChequeNo";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ FinancialAcID: ids });
                        eventFunction.config.ajaxCallMode = 7;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });

                $("#btnSave").click(function () {
                    var debits = parseFloat($("#lblDebitTotal").text());
                    var credits = parseFloat($("#lblCreditTotal").text());
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        if ($('.tblForTempFinancialAc tbody').find("tr").length != 0)
                            if (debits == credits)
                                eventFunction.SaveTransaction();
                            else
                                jAlert('Credit and Debit should be Equal', 'Error!!', function () { $.alerts.dialogClass = null; });
                        else
                            jAlert('Empty Transaction Details', 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#divForListingVerifiedTransaction").on("click", ".btnViewTransaction", function () {


                    var row = $(this).parents('tr');
                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.transactionID = id;
                    let htmls = '';
                    $("#divFinancialView").html(htmls);

                    var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                    htmls += `<label class="icon-print sfBtn restro-btn" id="btnPrintVerifiedTransaction">Print</label>
                        <style>
                           .popup-tblTop, #tableTransactionByIDInDialog {
                                border: 1px solid;
                                border-collapse: collapse;

                            }
                            .popup-tblTop tr,#tableTransactionByIDInDialog tr{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop tr,#tableTransactionByIDInDialog th{
                            border: 1px solid;
                                border-collapse: collapse;

                            }

                            .popup-tblTop td, #tableTransactionByIDInDialog td {
                            border: 1px solid;
                                border-collapse: collapse;

                            }
                                                    </style>
                            `;

                    htmls += `<table align="center" >
                                <tr>
                                    <td colspan="2" style="text-align: center; padding: 0px;">
                                        <img src="/Modules/ROCompanyInfo/logo/${companyInfo.Logo}" style="width:70px;"></td>
                                </tr>
                                <tr>
                                    <td colspan="7" style="font-size: 16px; text-align: center; font-weight: bold; padding: 0px;">${companyInfo.Name}</td>
                                </tr>
                                <tr>
                                    <td colspan="7" style="font-size: 12px; text-align: center; padding: 0px;">${companyInfo.Address} , ${(companyInfo.IsPan ? 'PAN' : 'VAT')} : ${companyInfo.PAN}</td>
                                </tr>
                                <tr><td colspan="7" style="font-size: 12px; text-align: center; padding: 0px;"></td></tr>
                              </table>`;
                    htmls += "<table class='popup-tblTop'><tr><td>Voucher No. : " + row.find('td:eq(1)').text() + "</td>";
                    htmls += "<td> Voucher : " + row.find('td:eq(2)').text() + "</td></tr>";
                    htmls += "<tr><td> Descriptions : " + row.find('td:eq(3)').text() + "</td>";
                    htmls += "<td>TransactionDate : " + row.find('td:eq(4)').text() + "</td></tr>";
                    htmls += "<tr><td>Total Debit : " + row.find('td:eq(5)').text() + "</td>";
                    htmls += "<td>Total Credit : " + row.find('td:eq(6)').text() + "</td></tr>";
                    htmls += '</table>';
                    //htmls += '</div>';
                    $("#divFinancialView").html(htmls);

                    eventFunction.config.method = "getVerifiedTransactionByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ transactionID: id, financialAccountId: 0 });
                    eventFunction.config.ajaxCallMode = 12;
                    eventFunction.ajaxCall(eventFunction.config);

                    let footerHtml = '';
                    footerHtml += `<table  style='margin-top:25px; float:right'>
                                        <tr><td colspan="7"><div style="width:225px;text-align:center;border-top:1px solid;float:right;">Verified By</div></td></tr>
                                    </table>`;
                    $("#divFinancialView").append(footerHtml);


                    $("#divFinancialView").dialog({
                        'title': 'Transaction',
                        width: 1024,
                        modal: true,
                        resizable: true,
                        dialogClass: 'popup-titlebg',
                    });

                    eventFunction.PrintFunction();

                });

                $("#btnPrintVerifiedVoucher").click(function () {

                    $("#lblVoucherType").text($("#selVoucharType option:selected").text());
                    $("#selVoucharType").hide();
                    $("#lblVoucherTypeDate").text($("#txtJEDate").val());
                    $("#txtJEDate").hide();

                    $("#lblVoucherTypeDescription").text($("#txtJEDescription").val());
                    $("#txtJEDescription").hide();

                    var contents = $('.printData').html();
                    $("#lblVoucherType").text('');
                    $("#selVoucharType").show();
                    $("#lblVoucherTypeDate").text('');
                    $("#txtJEDate").show();
                    $("#lblVoucherTypeDescription").text('');
                    $("#txtJEDescription").show();

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
                        $('#DialogOrderDetail').dialog('close');
                        //DashboardFunction.GetComplimentaryOccupiedTables(true);
                    }, 500);
                });




            },

            PrintFunction: function () {

                $('#btnPrintVerifiedTransaction').off('click').on('click', function () {
                    var $clone = $('#divFinancialView').clone();


                    $('#btnPrintVerifiedTransaction').remove();
                    $('.dataTables_filter').remove();

                    var contents = $('#divFinancialView').html();

                    $('#divFinancialView').html($clone.html());

                    eventFunction.PrintFunction();

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
                        $('#DialogOrderDetail').dialog('close');
                        //DashboardFunction.GetComplimentaryOccupiedTables(true);
                    }, 500);
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
                        eventFunction.bindFinancialAcName(data.d);
                        break;
                    case 1:
                        eventFunction.bindFinancialSysName(data);
                        break;
                    case 2:
                        jAlert('Verified Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.getTempTransactionList();
                        eventFunction.getVerifiedTransactionList();
                        break;
                    case 3:
                        eventFunction.bindAllFinancialAcForGrid(data.d);
                        break;
                    case 4:
                        jAlert('Deleted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.getTempTransactionList();
                        eventFunction.getVerifiedTransactionList();
                        break;
                    case 5:
                        jAlert('Updated Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.getTempTransactionList();
                        eventFunction.getVerifiedTransactionList();
                        break;
                    case 6:
                        eventFunction.bindVoucharTypeForDropDown(data.d);
                        break;
                    case 7:
                        eventFunction.ForDisplayChequeNo(data.d);
                        break;
                    case 8:
                        eventFunction.bindTempTransactionList(data.d);
                        break;
                    case 9:
                        eventFunction.bindTransactionByID(data.d);
                        break;
                    case 10:
                        eventFunction.bindVerifiedTransactionList(data.d);
                        break;
                    case 11:
                        jAlert('Deleted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getTempTransactionList();
                        break;
                    case 12:
                        eventFunction.getTransactionByIDInDialog(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
                switch (parseInt(eventFunction.config.ajaxFailureMode)) {
                    case 2:
                        jAlert("Error!" + console.log(error), 'Information!!', function () { $.alerts.dialogClass = null; });
                }
            },
            //<<-----------------------------Post & Get Here ---------------------------------------->>
            getTransactionByIDInDialog: function (datas) {
                //var datas = result.d;
                //$("#DivForViewItemByID").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableTransactionByIDInDialog' class='display dataTable no-footer'><thead><tr><th>S.N.</th><th>FinancialAc</th><th>FinancialAcID</th><th>Particulars</th><th>Debit</th><th>Credit</th><th>Cheque No.</th><th>Cheque Date</th></tr></thead><tbody>";
                    var valids = "";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.financialAcName + '</td>';
                        htmls += '<td>' + value.FinancialAcID + '</td>';
                        htmls += '<td>' + value.Particulars + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Debit).toFixed(2) + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Credit).toFixed(2) + '</td>';
                        htmls += '<td>' + value.ChequeNo + '</td>';
                        dates = value.ChequeDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        //htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '"></label></td></tr>';
                        $("#hdnPostedBy").val(value.PostedBy);
                        datess = value.PostedOn.split(" ");
                        $("#hdnPostedOn").val(datess[0]);
                        VoucherTypeID = value.VoucherTypeID;
                    });
                    htmls += "</tbody></table>";
                    $("#divFinancialView").append(htmls);
                    $("#tableTransactionByIDInDialog").dataTable({
                        search: false,
                        paging: false,
                        info: false,
                        ordering: false,
                        "jqueryUI": true
                    });
                }
                else {
                    $("#divFinancialView").append("<br/>  No Data");
                }
            },

            bindTransactionByID: function (data) {
                var htmls = "";
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<tr><td>' + value.financialAcName + '</td>';
                        htmls += '<td>' + value.FinancialAcID + '</td>';
                        htmls += '<td>' + value.Particulars + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Debit).toFixed(2) + '</td>';
                        htmls += '<td class="tdrate">' + parseFloat(value.Credit).toFixed(2) + '</td>';
                        htmls += '<td>' + value.ChequeNo + '</td>';
                        dates = value.ChequeDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '"></label></td></tr>';
                        $("#hdnPostedBy").val(value.PostedBy);
                        datess = value.PostedOn.split(" ");
                        $("#hdnPostedOn").val(datess[0]);
                        VoucherTypeID = value.VoucherTypeID;
                    });
                    $("#selVoucharType").val(VoucherTypeID);
                    $(".tblForTempFinancialAc").append(htmls);
                    //$("#DivForViewItemByID").append(htmls);

                    var rowCount = $('.tblForTempFinancialAc tbody tr').length;
                    var sumDebit = 0;
                    var sumCredit = 0;
                    for (var i = 0; i < rowCount; i++) {
                        sumDebit += parseFloat($(".tblForTempFinancialAc tbody").find('tr:eq(' + i + ')').find('td:eq(3)').text());
                    }
                    $("#lblDebitTotal").text(sumDebit.toFixed(2));

                    for (var i = 0; i < rowCount; i++) {
                        sumCredit += parseFloat($(".tblForTempFinancialAc tbody").find('tr:eq(' + i + ')').find('td:eq(4)').text());
                    }
                    $("#lblCreditTotal").text(sumCredit.toFixed(2));


                }
            },

            getTempTransactionList: function (isPurchase) {
                var startDate = $('#txtStartDate').val();
                var endDate = $('#txtEndDate').val();

                var data = JSON.stringify({ startDate: startDate, endDate: endDate });

                eventFunction.config.method = "getTempTransactionList";
                eventFunction.config.data = data;
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindTempTransactionList: function (result) {

                $("#divForListingTempTransaction").show();
                $("#divForListingTempTransaction").html("");
                var htmls = "";
                datas = JSON.parse(result);
                var i = 1;
                htmls += "<table id='tableForGroupListing'><thead><tr><th class='edit-heading tdcenter'><input name='select_all' value='1' id='select-all' type='checkbox' /></th><th>S.N.</th><th>Voucher</th><th>Descriptions</th><th>TransactionDate</th><th class='tdrate'>Total Debit</th><th class='tdrate'>Total Credit</th><th class='edit-heading tdcenter'>View</th><th class='delete-heading tdcenter'>Delete</th></tr></thead><tbody>"
                if (datas.length >= 0) {
                    $(datas).each(function (index, value) {
                        htmls += '<tr val="' + value.TransactionID + '">';
                        //if (value.totalDebit == value.totalCredit) {
                        htmls += "<td><input type='checkbox' class='checkbox' /></td>";
                        //}
                        //else {
                        //    htmls += "<td></td>";
                        //}
                        htmls += '<td>' + i + '</td>';
                        //htmls += '<td>' + value.VoucherNo + '</td>';
                        htmls += '<td>' + value.VoucherName + '</td>';
                        htmls += '<td>' + value.Descriptions + '</td>';
                        dates = value.TransactionDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td class="tdrate">' + value.totalDebit + '</td>';
                        htmls += '<td class="tdrate">' + value.totalCredit + '</td>';
                        htmls += '<td class="TransID"><label class="icon-preview btnViewTransaction" id="' + value.TransactionID + "+" + value.Descriptions + "+" + value.TransactionDate + '"></label></td>';
                        htmls += '<td class="tdcenter"><label value="Delete" class="delete icon-delete" id="' + value.TransactionID + '"></label></tr>';

                        i++;
                    });
                    htmls += '</tbody></table>';
                    $("#divForListingTempTransaction").html(htmls);
                    var table = $("#tableForGroupListing").dataTable({
                        "scrollCollapse": true,
                        "jQueryUI": true,
                        "pageLength": 20,
                        "bAutoWidth": false

                    });
                }
                else {
                    $("#divForListingTempTransaction").html("No Data..");
                }


                $('#select-all').on('click', function () {
                    if (this.checked) {
                        $('.checkbox').each(function () {
                            this.checked = true;
                        });
                    } else {
                        $('.checkbox').each(function () {
                            this.checked = false;
                        });
                    }
                });

                $('.checkbox').on('click', function () {
                    if ($('.checkbox:checked').length == $('.checkbox').length) {
                        $('#select_all').prop('checked', true);
                    } else {
                        $('#select_all').prop('checked', false);
                    }
                })

                $("#tableForGroupListing").on("click", ".delete", function () {
                    var ids = $(this).attr('id');
                    var username = SageFrameUserName;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.config.method = "DeleteTempTransactionByID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ transactionID: ids, username: username })
                            eventFunction.config.ajaxCallMode = 11;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    });
                });

                $("#tableForGroupListing").on("click", ".btnViewTransaction", function () {
                    //alert("ok");
                    var datas = $(this).attr('id');
                    var row = datas.split("+");
                    var id = row[0];
                    eventFunction.config.transactionID = id;
                    $("#selVoucharType").val(id);
                    $("#txtJEDescription").val(row[1]);
                    $("#txtJEDate").val(row[2]);

                    eventFunction.config.method = "getTransactionByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ transactionID: id });
                    eventFunction.config.ajaxCallMode = 9;
                    eventFunction.ajaxCall(eventFunction.config);

                    $(".Title").html($('#selVoucharType :selected').text());
                    $(".MainForm").show();
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $(".AccountForm").show();
                    $(".bank").hide();
                    $(".tabsForlist").hide();
                    $('.tblForTempFinancialAc').show();
                    $(".tabsForlist").hide();
                });
            },
            getVerifiedTransactionList: function () {

                var startDate = $('#txtStartDate_Verified').val();
                var endDate = $('#txtEndDate_Verified').val();

                var data = JSON.stringify({ startDate: startDate, endDate: endDate });

                eventFunction.config.data = data;
                eventFunction.config.method = "getVerifiedTransactionList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindVerifiedTransactionList: function (result) {
                $("#divForListingVerifiedTransaction").show();
                $("#divForListingVerifiedTransaction").html("");
                var htmls = "";
                verifiedlist = JSON.parse(result);
                var i = 1;
                htmls += "<table id='tableFortransactionListing'><thead><tr><th>S.N.</th><th>Voucher No.</th><th>Voucher</th><th>Descriptions</th><th>TransactionDate</th><th class='tdrate'>Total Debit</th><th class='tdrate'>Total Credit</th><th class='edit-heading tdcenter'>View</th></tr></thead><tbody>"
                if (verifiedlist.length >= 0) {
                    $(verifiedlist).each(function (index, value) {
                        htmls += '<tr>';
                        htmls += '<td>' + i + '</td>';
                        htmls += '<td>' + value.VoucherNo + '</td>';
                        htmls += '<td>' + value.VoucherName + '</td>';
                        htmls += '<td>' + value.Descriptions + '</td>';
                        dates = value.TransactionDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td class="tdrate">' + value.totalDebit + '</td>';
                        htmls += '<td class="tdrate">' + value.totalCredit + '</td>';
                        htmls += '<td class="tdcenter"><label class="icon-preview btnViewTransaction" id="' + value.TransactionID + '"></label></tr>';
                        i++;
                    });
                    htmls += '</tbody></table>';
                    $("#divForListingVerifiedTransaction").html(htmls);
                    $("#tableFortransactionListing").dataTable({
                        "pageLength": 20,
                        jQueryUI: true,
                    });
                }
                else {
                    $("#divForListingVerifiedTransaction").html("No Data..");
                }

            },

            SaveTransaction: function () {
                var Transaction = {
                    TransactionID: eventFunction.config.transactionID,
                    VoucherTypeID: parseInt($("#selVoucharType").val()),
                    //VoucherNo: $("#hdnVoucherNo").val(),
                    Descriptions: $("#txtJEDescription").val(),
                    TransactionDate: $("#txtJEDate").val(),
                    VerifiedBy: SageFrameUserName,
                    PostedBy: $("#hdnPostedBy").val() == "" ? SageFrameUserName : $("#hdnPostedBy").val(),
                    PostedOn: $("#txtJEDate").val(),
                }
                //var row = $(".tblForTempFinancialAc").parents('tbody');
                var rowCount = $('.tblForTempFinancialAc tbody tr').length;
                var ColCount = $('.tblForTempFinancialAc tbody tr td').length / rowCount;
                TransactionDetails = new Array;
                for (var i = 0; i < rowCount; i++) {
                    //for (var j = 0; j < ColCount; i++)
                    {
                        TransactionDetail = {
                            FinancialAcID: parseInt($('.tblForTempFinancialAc tbody').find('tr:eq(' + i + ')').find('td:eq(1)').text()),
                            Particulars: $('.tblForTempFinancialAc tbody').find('tr:eq(' + i + ')').find('td:eq(2)').text(),
                            Debit: parseFloat($('.tblForTempFinancialAc tbody').find('tr:eq(' + i + ')').find('td:eq(3)').text()),
                            Credit: parseFloat($('.tblForTempFinancialAc tbody').find('tr:eq(' + i + ')').find('td:eq(4)').text()),
                            ChequeNo: $('.tblForTempFinancialAc tbody').find('tr:eq(' + i + ')').find('td:eq(5)').text(),
                            ChequeDate: $('.tblForTempFinancialAc tbody').find('tr:eq(' + i + ')').find('td:eq(6)').text(),
                            MemberShipID: 0,
                        }
                        // row.find('td:eq(' + i + ')').text();
                    }
                    TransactionDetails.push(TransactionDetail);
                }
                Transaction.TransactionDetails = TransactionDetails;
                eventFunction.config.method = "SaveTransaction";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ Transaction: Transaction });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            ForDisplayChequeNo: function (data) {
                if (data == true) {
                    $(".bank").show();
                } else {
                    $(".bank").hide();
                }
            },

            getVoucharTypeForDropDown: function () {
                eventFunction.config.method = "getVoucharType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindVoucharTypeForDropDown: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                htmls += '<option disabled selected> -Select- </option>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<option value="' + value.VoucherTypeID + '">' + value.VoucherName + ' (' + value.Prefix + ')</option>';
                    });
                    $("#selVoucharType").html(htmls);
                } else {
                    $("#selVoucharType").html("No Data");
                }
            },

            getAllFinancialAcForGrid: function () {
                eventFunction.config.method = "getAllFinancialAcForGrid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindAllFinancialAcForGrid: function (data) {
                var htmls = "";
                htmls += '<table id="tblOfFinancialAc" class="sfGridwrapper display dataTable no-footer"><thead><tr><th>S.N.</th><th>Account Name</th><th>Parent Account</th><th>Financial System</th><th>Added On</th><th>Added By</th><th></th><th></th></tr></thead><tbody>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<tr><td>' + index + '</td>';
                        htmls += '<td>' + value.FinancialAcName + '</td>';
                        htmls += '<td>' + value.PFinancialAcName + '</td>';
                        htmls += '<td>' + value.FinancialSysName + '</td>';
                        var dates = value.AddedOn.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td>' + value.AddedBy + '</td>';
                        htmls += '<td><label value="Edit" class="edit icon-edit" id="' + value.FinancialAcID + '+' + value.PFinancialAcID + '+' + value.FinancialSysID + '"></label></td>';
                        htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '"></label></td></tr>';
                    });
                    htmls += '</tbody></table>';
                    $("#divForFinancialAc").html(htmls);
                } else {
                    $("#divForFinancialAc").html(htmls);
                }
                $("#tblOfFinancialAc").dataTable({
                    search: false,
                    paging: false,
                    //info: false,
                });
                $("#tblOfFinancialAc").on('click', '.delete', function () {

                    var datas = $(this).attr('id');
                    var username = SageFrameUserName;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {

                            eventFunction.config.method = "deleteFinancialAcByID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ id: datas, username: username });
                            eventFunction.config.ajaxCallMode = 4;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    });
                });
                $("#tblOfFinancialAc").on('click', '.edit', function () {
                    var row = $(this).parents('tr');
                    $("#txtName").val(row.find('td:eq(1)').text());

                    var datas = $(this).attr('id');
                    var word = datas.split("+");
                    jConfirm('Are You Sure  ?', 'Edit', function (confirmed) {
                        if (confirmed) {

                            $("#selPName").val(word[1]);
                            $("#selFinancialSys").val(word[2]);
                            eventFunction.config.FinancialAcID = word[0];
                            eventFunction.config.FinancialAcUpdate = 1;
                            var username = SageFrameUserName;
                            window.scrollTo(0, 0);

                            $("#btnSave").text("Update");
                            $("#divForFinancialAc").hide();
                            $("#btnAdd").hide();
                            $(".AccountForm").show();
                            $(".tabsForlist").hide();
                        }
                    });
                });
            },

            getFinancialAcName: function () {
                eventFunction.config.method = "getParentFinancialAcName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindFinancialAcName: function (result) {
                data = JSON.parse(result);
                var AutocompleteFinancialAc = [];
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        AutocompleteFinancialAc.push({ label: value.items, id: value.FinancialAcID });
                    });
                }

                $(".selFinancialAc").autocomplete({
                    source: AutocompleteFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnFinancialAcID').val(ui.item.id);
                    }
                });
            },

            getFinancialSysName: function () {
                eventFunction.config.method = "getFinancialSysName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindFinancialSysName: function (result) {
                var data = result.d;
                var htmls = "";
                htmls += '<option disabled selected> -Select- </option>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<option value="' + value.FinancialSysID + '">' + value.FinancialSysName + '</option>';
                    });
                    $("#selFinancialSys").html(htmls);
                } else {
                    $("#selFinancialSys").html("No Data");
                }
            },

            Reset: function () {
                // eventFunction.InitialSetup();
                $("#selVoucharType").val($("#selVoucharType option:first").val());
                $("#txtJEDescription").val("");
                $("#txtJEDate").datepicker('setDate', new Date());

                $(".tblForTempFinancialAc").hide();
                $('.tblForTempFinancialAc tbody tr').remove();

                $(".Title").html("");

                $("#divForFinancialAc").hide();
                $("#btnAdd").show();
                $(".AccountForm").hide();
                $(".MainForm").hide();
                $("#tabss").show();
                eventFunction.config.transactionID = 0;
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        JEDescription: {
                            required: true,
                        },
                        Debit: {
                            number: true,
                        },
                        Credit: {
                            number: true,
                        },
                    },
                    messages: {
                        JEDescription: {
                            required: 'Please Enter Description',
                        },
                        Debit: {
                            number: "Enter number",
                        },
                        Credit: {
                            number: "Enter number",
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
