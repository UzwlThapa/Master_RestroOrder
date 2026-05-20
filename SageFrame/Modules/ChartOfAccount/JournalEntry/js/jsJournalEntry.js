(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/ChartOfAccount/JournalEntry/webService/'
            }, p);
        var selectedIndex = 0;
        var checkValid = false;
        var htmls = '';
        var rowCount = 0;
        var sumDebit = 0;
        var sumCredit = 0;
        var AutoCompleteBank = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsJournalEntry.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0,
                transactionID: 0,
                transactionUpdate: 0,
                transactionDetailID: 0

            },
            InitialSetup: function () {
                
                eventFunction.getVoucharTypeForDropDown();
                eventFunction.getFinancialAcName();
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnAdd").click(function () {

                    $(".MainForm").show();
                    $(".PaymentReceiveForm").hide();
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $('#btnAddPaymentReceive').hide();

                    $(".bank").hide();
                    $("#div1").hide();

                });

               
                $("#btnView").off('click').on('click', function () {
                    eventFunction.getTempTransactionList();
                });

                $("#btnCancel").click(function () {
                    eventFunction.Reset();
                });

                //$(".tblForFinancialAc").on("change", ".selFinancialAc", function () {
                //    $(".hdnFinancialAcID").val($(this).val());
                //});

                $(".AccountForm").on("click", ".addNewRow", function () {
                    $(".addNewRow").unbind('click');
                    if ($(".selFinancialAc").val() == null) {
                        jAlert("Please Select The Financial Account!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    } else if ($(".txtAcDescription").val() == "") {
                        jAlert("Please Fill Acccount Description!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    } else if ($(".txtDebit").val() == "") {
                        jAlert("Please Fill The Debit!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($(".txtCredit").val() == "") {
                        jAlert("Please Fill The Credit!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        checkValid = eventFunction.ValidationForm();
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
                            //htmls += '<td><label id="" class="edit icon-edit" value="Edit"></label><label id="" class="delete icon-delete" value="Delete"></label></td></tr>';
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
                            //$(".selFinancialAc").val("");
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


                $(".tblForTempFinancialAc").on("click", ".delete", function () {
                    var row = $(this).closest('tr');
                    //$(row).find('td:eq(3)').text();
                    //$(row).find('td:eq(4)').text();
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {

                        if (confirmed) {
                            $("#lblDebitTotal").text(parseFloat(parseFloat($("#lblDebitTotal").text()) - parseFloat($(row).find('td:eq(3)').text())).toFixed(2));
                            $("#lblCreditTotal").text(parseFloat(parseFloat($("#lblCreditTotal").text()) - parseFloat($(row).find('td:eq(4)').text())).toFixed(2));
                            row.remove();
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
                    $("#div1").hide();
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
                                jAlert("Credit and Debit should be Equal!", 'Error!!', function () { $.alerts.dialogClass = null; });
                        else
                            jAlert("Empty Transaction Details!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                });


                //Payment & Receive Voucher Updated by Bishal Raj Parajuli
                $("#btnAddPaymentReceive").on('click',function () {

                    $(".PaymentReceiveForm").show();
                    $(".MainForm").hide();
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $('#btnAddPaymentReceive').hide();

                    $(".bank").hide();
                    $("#div1").hide();

                    eventFunction.GetPaymentMethod();

                });

                $('#divPaymentModes').on('change', '#selPayModes', function () {
                    var payId = $(this).val();
                    if (payId == 1) {
                        $('.PayModeBank').hide();
                        $('.PayModebankCheque').hide();
                    } else if (payId == 2) {
                        $('.PayModeBank').show();
                        $('.PayModebankCheque').show();
                    }
                    else if (payId == 3) {
                        $('.PayModeBank').show();
                        $('.PayModebankCheque').hide();
                    } else if (payId == 5) {
                        $('.PayModeBank').show();
                        $('.PayModebankCheque').hide();
                    } else if (payId == 2) {
                        $('.PayModeBank').show();
                        $('.PayModebankCheque').hide();
                    }
                });

                $('#btnPRSave').on('click', function () {
                    if ($('.hdnselPRFinancialAc').val() == "") {
                        jAlert("Please Select The Financial Account!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($(".txtPRDescription").val() == "") {
                        jAlert("Please Fill Acccount Description!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($(".txtPRAmount").val() == "") {
                        jAlert("Please Fill Amount!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($(".txtPRParticulars").val() == "") {
                        jAlert("Please Fill Particulars!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($('#selPayModes').val() != 1 && $('.hdnBankFinancialAcID').val() == "") {
                        jAlert("Please select Bank Account !", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        var obj = {}
                        obj.VoucherDescription = $('#txtPRDescription').val();
                        obj.VoucherDate = $('#txtPRDate').val();
                        obj.VoucherTypeId = $('#selVoucherType').val();
                        obj.FinancialAcID = parseInt($('.hdnselPRFinancialAc').val());
                        obj.Particulars = $('.txtPRParticulars').val();
                        obj.Amount = parseFloat($('.txtPRAmount').val());
                        var bankid = $('.hdnBankFinancialAcID').val()
                        obj.BankAccId = ((bankid == "") ? -1 : parseInt(bankid));
                        obj.PaymodeId = parseInt($('#selPayModes').val());
                        obj.ChequeNo = $('.txtPRChequeNo').val();
                        obj.ChequeDate = $('.txtPRChequeDate').val();
                        obj.UserName = SageFrameUserName;
                        
                        jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {

                            if (confirmed) {
                                eventFunction.config.method = "SavePaymentReceiveVoucher";
                                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                eventFunction.config.data = JSON2.stringify({ obj: obj })
                                eventFunction.config.ajaxCallMode = 13;
                                eventFunction.ajaxCall(eventFunction.config);
                            }
                        });
                    }
                });

                $('#btnPRCancel').on('click', function () {
                    eventFunction.Reset();
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
                        eventFunction.BindBankDetails(data.d);
                        break;
                    case 1:
                        eventFunction.bindFinancialSysName(data);
                        break;
                    case 2:
                        jAlert("Saved Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.getTempTransactionList();
                        break;
                    case 3:
                        eventFunction.bindAllFinancialAcForGrid(data.d);
                        break;
                    case 4:
                        jAlert("Deleted Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        break;
                    case 5:
                        jAlert("Updated Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
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
                        jAlert("Deleted Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getTempTransactionList();
                        break;
                    case 10:
                        eventFunction.bindTransactionByID(data.d);
                        break;
                    case 11:
                        jAlert("Updated Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getTempTransactionList();
                        eventFunction.Reset();
                        break;
                    case 12:
                        eventFunction.BindPaymentModes(data.d);
                        break;
                    case 13:
                        jAlert("Voucher Added Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getTempTransactionList();
                        eventFunction.Reset();
                        break;
                }
            },
            ajaxFailure: function () {
                switch (parseInt(eventFunction.config.ajaxFailureMode)) {
                    case 2:
                        jAlert("Error!" + console.log(error), 'Error!!', function () { $.alerts.dialogClass = null; });
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            bindTransactionByID: function (data) {
                htmls = "";
                var VoucherTypeID = "";
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<tr><td>' + value.financialAcName + '</td>';
                        htmls += '<td>' + value.FinancialAcID + '</td>';
                        htmls += '<td>' + value.Particulars + '</td>';
                        htmls += '<td>' + parseFloat(value.Debit).toFixed(2) + '</td>';
                        htmls += '<td>' + parseFloat(value.Credit).toFixed(2) + '</td>';
                        htmls += '<td>' + value.ChequeNo + '</td>';
                        dates = value.ChequeDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        // htmls += '<td><label id="' + value.FinancialAcID + '" class="edit icon-edit" value="Edit"></td>';
                        htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '"></label></td></tr>';
                        $("#hdnPostedBy").val(value.PostedBy);
                        datess = value.PostedOn.split(" ");
                        $("#hdnPostedOn").val(datess[0]);
                        eventFunction.config.transactionDetailID = value.transactionDetailID;
                        VoucherTypeID = value.VoucherTypeID;
                    });
                    $("#selVoucharType").val(VoucherTypeID);
                    $(".tblForTempFinancialAc").append(htmls);
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
                    $(".Title").html($('#selVoucharType :selected').text());
                    $(".MainForm").show();
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $(".AccountForm").show();
                    $(".bank").hide();
                    $("#div1").hide();
                    $('.tblForTempFinancialAc').show();
                    $(".tabsForlist").hide();
                }
            },

            getTempTransactionList: function () {

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
                htmls = "";
                var i = 1;
                datas = JSON.parse(result);
                htmls += "<table id='tableForGroupListing'><thead><tr><th>S.N.</th><th>Voucher</th><th>Descriptions</th><th>TransactionDate</th><th class='tdrate'>Total Debit</th><th class='tdrate'>Total Credit</th><th class='edit-heading tdcenter'>Edit</th><th class='delete-heading tdcenter'>Delete</th></tr></thead><tbody>"
                if (datas.length >= 0) {
                    $(datas).each(function (index, value) {
                        htmls += '<tr><td>' + i + '</td>';
                        //htmls += '<td>' + value.VoucherNo + '</td>';
                        htmls += '<td>' + value.VoucherName + '</td>';
                        htmls += '<td>' + value.Descriptions + '</td>';
                        dates = value.TransactionDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td class="tdrate">' + value.totalDebit + '</td>';
                        htmls += '<td class="tdrate">' + value.totalCredit + '</td>';
                        htmls += '<td class="tdcenter"><label id="' + value.TransactionID + '" class="edit icon-edit" value="Edit"></label></td><td class="tdcenter"><label id="' + value.TransactionID + '" class="delete icon-delete" value="Delete"></label></td>';
                        i++;
                    });
                    htmls += '</tbody></table>';
                    $("#divForListingTempTransaction").html(htmls);
                    $("#tableForGroupListing").dataTable({
                        "scrollCollapse": true,
                        "jQueryUI": true,
                        "pageLength": 20,
                        "bAutoWidth": false
                    });
                }
                else {
                    $("#divForListingTempTransaction").html("No Data..");
                }

                $("#tableForGroupListing").on("click", ".delete", function () {
                    var ids = $(this).attr('id');
                    var username = SageFrameUserName;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {

                        if (confirmed) {
                            eventFunction.config.method = "DeleteTempTransactionByID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ transactionID: ids, username: username })
                            eventFunction.config.ajaxCallMode = 9;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    });
                });

                $("#tableForGroupListing").on("click", ".edit", function (e) {

                    e.preventDefault();
                    //if (confirm("Edit! Are You Sure?")) 
                    {
                        eventFunction.config.transactionUpdate = 1;
                        var row = $(this).parents('tr');
                        var id = parseInt($(this).attr('id'));
                        eventFunction.config.transactionID = id;

                        $("#txtJEDescription").val(row.find('td:eq(2)').text());
                        $("#txtJEDate").val(row.find('td:eq(3)').text());

                        eventFunction.config.method = "getTransactionByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ transactionID: id });
                        eventFunction.config.ajaxCallMode = 10;
                        eventFunction.ajaxCall(eventFunction.config);
                    };
                });
            },

            SaveTransaction: function () {
                var Transaction = {
                    TransactionID: eventFunction.config.transactionID,
                    VoucherTypeID: parseInt($("#selVoucharType").val()),
                    //VoucherNo: $("#hdnVoucherNo").val(),
                    Descriptions: $("#txtJEDescription").val(),
                    TransactionDate: $("#txtJEDate").val(),
                    PostedBy: SageFrameUserName,
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
                            transactionDetail: eventFunction.config.transactionDetailID,
                        }
                        // row.find('td:eq(' + i + ')').text();
                    }
                    TransactionDetails.push(TransactionDetail);
                }
                Transaction.TransactionDetails = TransactionDetails;
                eventFunction.config.method = "SaveTransaction";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ Transaction: Transaction });
                if (eventFunction.config.transactionUpdate == 1)
                    eventFunction.config.ajaxCallMode = 11;
                else
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
                htmls = "";
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
                htmls = "";
                htmls += '<table id="tblOfFinancialAc"><thead><tr><th>S.N.</th><th>Account Name</th><th>Parent Account</th><th>Financial System</th><th>Added On</th><th>Added By</th><th></th><th></th></tr></thead><tbody>';
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
                    "pageLength": 20,
                    paging: false
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
                        }
                    });
                });
            },

            getFinancialAcName: function () {
                eventFunction.config.method = "getFinancialAc";
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

                //data = JSON.parse(result);
                //htmls = "";
                //htmls += '<option disabled selected> -Select- </option>';
                //if (data.length > 0) {
                //    var pid = 0;
                //    $.each(data, function (index, value) {
                //        if (value.isGroup == 0) {
                //            htmls += '<option value="' + value.FinancialAcID + '">' + value.items + '</option>';
                //            }
                //        else {
                //            htmls += '<optgroup label="' + value.items + '" value="' + value.FinancialAcID + '"></optgroup>';
                //            pid = value.FinancialAcID;
                //        }
                //    });
                //    $(".selFinancialAc").html(htmls);
                //} else {
                //    $(".selFinancialAc").html("No Data");
                //}
            },

            getFinancialSysName: function () {
                eventFunction.config.method = "getFinancialSysName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindFinancialSysName: function (result) {
                var data = result.d;
                htmls = "";
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
                $("#selVoucharType").val($("#selVoucharType option:first").val());
                $("#txtJEDescription").val("");
                $("#txtJEDate").datepicker('setDate', new Date());
                $("#txtPRDate").datepicker('setDate', new Date());
                $(".txtPRChequeDate").datepicker('setDate', new Date());
                $(".txtChequeDate").datepicker('setDate', new Date());
                $(".PaymentReceiveForm").hide();
                $("#btnAddPaymentReceive").show();
                $(".tblForTempFinancialAc").hide();
                $('.tblForTempFinancialAc tbody tr').remove();
                $(".Title").html("");
                $("#div1").show();
                $("#btnAdd").show();
                $(".AccountForm").hide();
                $(".MainForm").hide();
                $("#divForListingTempTransaction").show();
                eventFunction.config.transactionID = 0;
                eventFunction.config.transactionUpdate = 0;
            },


            //Payment Receive Voucher Function Updated by Bishal Raj Parajuli
            GetPaymentMethod: function () {
                eventFunction.config.method = "getPaymentMethods";
                //eventFunction.config.data = data;
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 12;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindPaymentModes: function (data) {
                var payData = JSON.parse(data);
                var htm = ''
                htm += '<select id="selPayModes" name="FinancialSys" class="sfInputbox" style="width:200px;">';
                $.each(payData, function (index, value) {
                    if (value.PaymentModeID != 4) {
                        htm += '<option value="' + value.PaymentModeID + '">' + value.PaymentMode + ' </option>';
                    }
                });
                htm += '</select>';
                $("#divPaymentModes").html(htm);
            },

            BindBankDetails: function (data) {
                data = JSON.parse(data);
                //Bind Auto Complete for Bank
                var AutocompleteBankFinancialAc = [];
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        if (value.PFinancialAcID == 11) {
                            AutocompleteBankFinancialAc.push({ label: value.items, id: value.FinancialAcID });
                        }
                    });
                }
                $(".selBankFinancialAc").autocomplete({
                    source: AutocompleteBankFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                            $('.hdnBankFinancialAcID').val(ui.item.id);
                    }
                });
                //Bind Auto Complete For Accounts
                var AutocompletePRFinancialAc = [];
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        AutocompletePRFinancialAc.push({ label: value.items, id: value.FinancialAcID });

                    });
                }

                $(".selPRFinancialAc").autocomplete({
                    source: AutocompletePRFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnselPRFinancialAc').val(ui.item.id);
                    }
                });
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
