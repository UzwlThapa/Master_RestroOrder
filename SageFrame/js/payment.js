var custName = '';
var phoneNumber = '';
var discount = 0;
function payment(salesMasterid) {

    getSalesMasterDtls(salesMasterid);
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/OrderWebservice.asmx/GetPaymentModesAndProviders",
        data: JSON.stringify({ salesMasterId: salesMasterid }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            var cardProviders = result.providers;
            var paymentModes = result.paymentModes;
            var billInfo = result.billInfo;
            var htmls = '';
            $('#payment').html(htmls);
            htmls += '<div id="divNamePhone" style="display:"><span style="text-align:left; display:inline-block;">Customer name<span style="color:red;">*</span>: <input type="text" id="txtCustName" class="sfInputbox" value="' + custName + '" /></span><span style="float:right; display:inline-block;">Phone<span style="color:red;">*</span>: <input type="text" id="txtPhoneNumber" class="txtNum sfInputbox" value="' + phoneNumber + '" /></span></div>';
            htmls += '<div class="unpaidbill_ttl" style="display:flex;justify-content:space-between;"><h4>Total Amount : Rs.' + billInfo.TotalAmount + '</h4>';
            htmls += '<h4 id="surplusDeficit" style="text-align:right;">Surplus/Deficit : Rs.<span id="txtsurplus">0</span></h4></div>';
            htmls += '<table id="tblPayment" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';
            $.each(paymentModes, function (index, mode) {
                htmls += '<tr>';
                htmls += '<td><input type="checkbox" class="pmntCheck" id="chkBox_' + mode.PaymentModeID + '" ' + (mode.PaymentModeID == 1 ? 'checked' : '') + ' /><label for="chkBox_' + mode.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + mode.PaymentMode + ' : </label></td>';
                htmls += '<td></td>';
                htmls += '<td>';
                if (mode.PaymentModeID == 1) {
                    htmls += 'Tender Amount <input type="text" id="txtTenderAmount" class="pmt txtNum sfInputbox" value="' + billInfo.TotalAmount + '" />';
                    htmls += '</td>';
                    htmls += '<td>Return Amount <input type="text" id="txtReturnAmount" class="pmt txtNum sfInputbox" value="0"/></td>';
                    htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" disabled value="' + billInfo.TotalAmount + '"/></td>';
                } else if (mode.PaymentModeID == 4) {
                    htmls += '<input type="hidden" id="hdfCusID" class="sfInputbox" value="' + billInfo.CustomerID + '" />';
                    htmls += '<input type="hidden" id="hdfAddress" class="sfInputbox" />';
                    htmls += 'Customer <input type="text" disabled id="txtCustomerName" class="sfInputbox"/>';
                    htmls += '</td>';
                    htmls += '<td>PAN <input type="textbox" disabled id="txtPAN" class="sfInputbox"/></td>';
                    htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" /></td>';

                }
                //else if (mode.PaymentModeID == 5 || mode.PaymentModeID == 6) {
                //    htmls += 'Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" /></td>';
                //    htmls += '<td colspan="2"></td>';

                //}
                else {
                    htmls += 'Provider<select class="sfInputbox selPaymentMode">';
                    $.each(cardProviders, function (index, provider) {
                        htmls += '<option value="' + provider.ProviderID + '">' + provider.ProviderName + '</option>';
                    });
                    htmls += '</select>';
                    htmls += '</td>';
                    htmls += '<td># <input type="text" class="pmt sfInputbox txtTransaction" placeholder="' + (mode.PaymentModeID == 2 ? 'Cheque No.' : 'Transaction No.') + '" /></td>';
                    htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" /></td>';
                }

                htmls += '</tr>';
            });
            htmls += '</table>';
            htmls += '<table id="tblReturn" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';
            htmls += '<td><label style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">CASH : </label></td>';
            htmls += '<td>Return Amount <input type="text" id="txtAmount" class="sfInputbox txtAmount" value="' + (billInfo.TotalAmount > 0 ? 0 : -(parseFloat(billInfo.TotalAmount))) + '"/></td>';
            htmls += '</table>';
            htmls += '<div class="txtRem" >Remarks: <textarea class="sfInputbox txtRemarks"></textarea></div>';
            htmls += '<div class="clearfix"><input type="button" class="sfBtn restro-btn" id="paymentBtn" value="Pay" style="float:right;"/></div>';
            $('#payment').html(htmls);
            if (billInfo.TotalAmount >= 0) {
                $('#tblPayment').show();
                $('#tblReturn').hide();
            } else {
                $('#tblPayment').hide();
                $('#tblReturn').show();
            }
            if (billInfo.CustomerID > 0) {
                GetCustomeronChange(billInfo.CustomerID);
            }
            $('#payment').dialog({
                'title': 'Pay Bill : ' + billInfo.InvoiceNo,
                width: 600,
                modal: true,
                dialogClass: 'unpaidd',
                position: ['center', 'center'],
                close: function () {
                    $(this).dialog("destroy");
                }
            });

            //$('#tblPayment').on('click', "#txtTenderAmount, #txtReturnAmount, .txtPayAmount", function () {
            //    $(this).val('');
            //});
            //$('#tblReturn').on('click', "#txtAmount", function () {
            //    $(this).val('');
            //});

            // $('.ui-dialog ').mouseup(function(){
            //     if($(".txtNum, .txtPayAmount, .PINbutton, #numbox, .del, #NumPad ").is(':focus')){

            //     }else{
            //         $("#NumPad").hide();
            //     }
            // });

            $("#tblPayment").on('click', ".txtNum, .txtPayAmount", function (event) {
                InitializeNumPin(this, $(this).val());
            });

            $('#tblPayment').on('keyup keydown', "#txtTenderAmount", function () {
                var row = $(this).closest('tr');
                var returnAmnt = (Number($("#txtTenderAmount").val()) - Number(billInfo.TotalAmount)).toFixed(2);
                //$("#txtReturnAmount").val((parseFloat(returnAmnt) > 0 ? parseFloat(returnAmnt) : 0));
                //var payAmnt = (Number($("#txtTenderAmount").val()) - $("#txtReturnAmount").val() > 0 ? (Number($("#txtTenderAmount").val()) - $("#txtReturnAmount").val()) : Number($("#txtTenderAmount").val()));
                $("#txtReturnAmount").val(parseFloat(returnAmnt) > 0 ? parseFloat(returnAmnt) : 0);
                var payAmnt = (Number($("#txtTenderAmount").val()) - $("#txtReturnAmount").val());
                $(row).find('.txtPayAmount').val(payAmnt.toFixed(2));
                $('.txtPayAmount').change();
            });
            $('#tblPayment').on('keyup keydown', "#txtReturnAmount", function () {
                var row = $(this).closest('tr');
                var returnAmnt = Number($("#txtReturnAmount").val()).toFixed(2);
                //var payAmnt = (Number($("#txtTenderAmount").val()) - returnAmnt > 0 ? (Number($("#txtTenderAmount").val()) - returnAmnt) : Number($("#txtTenderAmount").val()));
                var payAmnt = (Number($("#txtTenderAmount").val()) - returnAmnt);
                $(row).find('.txtPayAmount').val(payAmnt.toFixed(2));
                $('.txtPayAmount').change();
            });
            $('.txtPayAmount').on('change', function () {
                totalPayAmnt = 0.00;
                $('.txtPayAmount').each(function () {
                    if ($(this).closest('tr').find('.pmntCheck').is(':checked')) {
                        totalPayAmnt += parseFloat($(this).val());
                    }
                })
                $('#txtsurplus').html((totalPayAmnt - billInfo.TotalAmount).toFixed(2));
                if (totalPayAmnt > billInfo.TotalAmount) {
                    document.getElementById("surplusDeficit").setAttribute("style", "color:green !important");
                } else if (totalPayAmnt < billInfo.TotalAmount) {
                    document.getElementById("surplusDeficit").setAttribute("style", "color:red !important");
                } else {
                    document.getElementById("surplusDeficit").setAttribute("style", "color:black !important");
                }
            });
            $('.pmntCheck').on('change', function () {
                //$(this).closest('tr').find('.txtPayAmount').val(Math.abs(parseFloat($('#txtsurplus').text())));
                //$('.txtPayAmount').change()
                if ($(this).attr('id').split('_')[1] == "4" && $(this).is(':checked') && billInfo.CustomerID < 1) {
                    $(this).prop('checked', false);
                    GetCustomeronChange(billInfo.CustomerID, this);
                }
                else if ($(this).attr('id').split('_')[1] == "4" && $(this).is(':checked') && billInfo.CustomerID > 1) {
                    $(".txtRem").show();
                }
                else {
                    $(".txtRem").hide();
                }
                if (!$(this).is(':checked')) {
                    $(this).closest('tr').find('.txtPayAmount').val(0);
                    $('.txtPayAmount').change();
                    if ($(this).attr('id').split('_')[1] == "4" && parseInt($("#hdfCusID").val()) != billInfo.CustomerID) {
                        $("#hdfCusID").val('');
                        $("#txtCustomerName").val('');
                        $("#txtPAN").val('');
                        $("#hdfAddress").val('');
                        $(".txtRemarks").val('');
                        $(".txtRem").hide();

                    }
                } else {
                    var surplusDef = parseFloat($('#txtsurplus').html());
                    if (surplusDef < 0) {
                        if ($(this).attr('id').split('_')[1] == "1") {
                            $("#txtTenderAmount").val(Math.abs(surplusDef));
                            $("#txtReturnAmount").val('0');
                        }
                        $(this).closest('tr').find('.txtPayAmount').val(Math.abs(surplusDef));
                        $('.txtPayAmount').change();
                    } else {
                        if ($(this).attr('id').split('_')[1] == "1") {
                            $("#txtTenderAmount").val('0');
                            $("#txtReturnAmount").val('0');
                        }
                    }
                }
            });
            $('.txtAmount').on('change', function () {
                totalPayAmnt = $(this).val();
                $('#txtsurplus').html(-(parseFloat(totalPayAmnt) + parseFloat(billInfo.TotalAmount)).toFixed(2));
                if (Math.abs(totalPayAmnt) < Math.abs(billInfo.TotalAmount)) {
                    document.getElementById("surplusDeficit").setAttribute("style", "color:green !important");
                } else if (Math.abs(totalPayAmnt) > Math.abs(billInfo.TotalAmount)) {
                    document.getElementById("surplusDeficit").setAttribute("style", "color:red !important");
                } else {
                    document.getElementById("surplusDeficit").setAttribute("style", "color:black !important");
                }
            });

            $('#paymentBtn').unbind('click').on('click', function () {
                console.log('Discount: ' + discount);
                if (discount > 0) {
                    if ($('#txtCustName').val() == '' || $('#txtPhoneNumber').val() == '') {
                        alert('Please enter Name and phone number');
                        if ($('#txtCustName').val() == '') {
                            $('#txtCustName').focus();
                            return
                        }
                        if ($('#txtPhoneNumber').val() == '') {
                            $('#txtPhoneNumber').focus();
                            return
                        }

                    }
                }
                if (parseFloat(billInfo.TotalAmount) > 0) {
                    if ($("#tblPayment input:checkbox:checked").length > 0) {
                        var valid = validPayForm();
                        if (valid == 'transaction') {
                            valid = 'true';
                        }

                        if (valid == 'true') {
                            if (parseFloat($('#txtsurplus').html()) != 0) {
                                if (parseFloat($('#txtsurplus').html()) > 250 || parseFloat($('#txtsurplus').html()) < -250) {
                                    jAlert('Surplus/Deficit cannot be more than Rs. 250.', 'Alert!!');
                                    $('#paymentBtn').bind('click');
                                } else {
                                    jConfirm('There is Surplus/Deficit of Rs.' + parseFloat($('#txtsurplus').html()) + '. Do You want to save the payment?', (parseFloat($('#txtsurplus').html()) > 0 ? 'Surplus : Rs.' + parseFloat($('#txtsurplus').html()) : 'Deficit : Rs.' + parseFloat($('#txtsurplus').html())), function (confirmed) {
                                        if (confirmed) {
                                            SavePayment(salesMasterid, billInfo.TotalAmount);
                                        } else {
                                            $('#paymentBtn').bind('click');
                                        }
                                    });
                                }
                            } else {
                                jConfirm('Do You want to confirm the payment?', 'Payment Confirmation!!', function (confirmed) {
                                    if (confirmed) {
                                        SavePayment(salesMasterid, billInfo.TotalAmount);
                                    }
                                });
                            }
                        } else {
                            if (valid == 'payamount') {
                                jAlert('PayAmount must be greater than 0 for checked payment mode.', 'Alert!!');
                            }
                            //else {
                            //    jAlert('Transactions No is mandatory for checked payment mode.', 'Alert!!');
                            //}
                            $('#paymentBtn').bind('click');
                        }
                    } else {
                        jAlert('Select Atleast One Payment Mode.', 'Alert!!');
                        $('#paymentBtn').bind('click');
                    }
                } else {
                    var salesPaymentList = new Array();
                    var spmid = $(this).attr('id').split('_')[1];
                    var salesPayment = new Object();
                    salesPayment.salesMasterId = salesMasterid;
                    salesPayment.SPMID = spmid;
                    salesPayment.ChequeNo = '';
                    salesPayment.TransactionNo = '';
                    salesPayment.ProviderID = '';
                    salesPayment.CusID = $('#hdfCusID').val();
                    salesPayment.Customer = $('#txtCustomerName').val();
                    salesPayment.Address = $('#hdfAddress').val();
                    salesPayment.PAN = $('#txtPAN').val();
                    if (parseFloat(billInfo.TotalAmount) < 0) {
                        salesPayment.PayAmount = -parseFloat($('.txtAmount').val());
                        salesPayment.TenderAmount = -parseFloat($('.txtAmount').val());
                        salesPayment.ReturnAmount = 0;
                    } else {
                        salesPayment.PayAmount = 0;
                        salesPayment.TenderAmount = 0;
                        salesPayment.ReturnAmount = 0;
                    }
                    salesPayment.BillAmount = billInfo.TotalAmount;
                    salesPayment.Remarks = $('.txtRemarks').val();
                    salesPaymentList.push(salesPayment);
                    var data = JSON2.stringify({ salesPaymentList: salesPaymentList });

                    if (parseFloat($('#txtsurplus').html()) != 0) {
                        jConfirm('There is Surplus/Deficit of Rs.' + parseFloat($('#txtsurplus').html()) + '. Do You want to save the payment?', (parseFloat($('#txtsurplus').html()) > 0 ? 'Surplus : Rs.' + parseFloat($('#txtsurplus').html()) : 'Deficit : Rs.' + parseFloat($('#txtsurplus').html())), function (confirmed) {
                            if (confirmed) {
                                saveReturnPayment(data);
                            } else {
                                $('#paymentBtn').bind('click');
                            }
                        });
                    } else {
                        jConfirm('Do You want to confirm the payment?', 'Payment Confirmation!!', function (confirmed) {
                            if (confirmed) {
                                saveReturnPayment(data);
                            }
                        });
                    }
                }
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });

    if (discount <= 0) {
        $('#divNamePhone').css('display', 'none')
    }
}
function validPayForm() {
    var valid = 'true';
    $('.pmntCheck').each(function () {
        if (valid) {
            if ($(this).is(':checked')) {
                var row = $(this).closest('tr');
                if (parseFloat($(row).find('.txtPayAmount').val()) > 0) {
                    var textBox = $(row).find('.pmt').filter(function () {
                        return $.trim($(this).val()) == '';
                    }).length;

                    if (textBox > 0) {
                        valid = 'transaction';
                    } else {
                        valid = 'true';
                    }
                } else {
                    valid = 'payamount';
                }
            }
        }

    });
    return valid;
}
function SavePayment(salesMasterid, totalAmount) {

    var salesPaymentList = new Array();
    $('.pmntCheck').each(function () {
        if ($(this).is(':checked')) {
            var row = $(this).closest('tr');
            var spmid = $(this).attr('id').split('_')[1];
            var salesPayment = new Object();
            salesPayment.salesMasterId = salesMasterid;
            salesPayment.SPMID = spmid;
            salesPayment.ChequeNo = (spmid == 2 ? $(row).find('.txtTransaction').val() : '');
            salesPayment.TransactionNo = (spmid == 3 || spmid == 5 || spmid == 6 ? $(row).find('.txtTransaction').val() : '');
            salesPayment.ProviderID = (spmid == 2 || spmid == 3 || spmid == 5 || spmid == 6 ? $(row).find('.selPaymentMode').val() : '');
            salesPayment.CusID = $('#hdfCusID').val();
            salesPayment.Customer = $('#txtCustomerName').val();
            salesPayment.Address = $('#hdfAddress').val();
            salesPayment.PAN = $('#txtPAN').val();
            salesPayment.PayAmount = $(row).find('.txtPayAmount').val();
            salesPayment.TenderAmount = (spmid == 1 ? $(row).find('#txtTenderAmount').val() : 0);
            salesPayment.ReturnAmount = (spmid == 1 ? $(row).find('#txtReturnAmount').val() : 0);
            salesPayment.Remarks = $('.txtRem > .txtRemarks').val();
            salesPayment.BillAmount = totalAmount;
            salesPaymentList.push(salesPayment);
        }
    });
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/OrderWebservice.asmx/SavePayment",
        data: JSON2.stringify({ salesPaymentList: salesPaymentList }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            jAlert('Bill Successfully Paid.', 'Information!!', function () {
                location.reload();
            });
            $(".ui-dialog-content").dialog("close");

        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function saveReturnPayment(data) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/OrderWebservice.asmx/SavePayment",
        data: data,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            jAlert('Bill Successfully Paid.', 'Information!!', function () {
                location.reload();
            });
            $(".ui-dialog-content").dialog("close");

        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function GetCustomeronChange(customerID, pmntMode) {
    var customer = 1;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/OrderWebservice.asmx/GetCustomerDatas",
        data: JSON2.stringify({ customer: customer }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var datas = JSON.parse(data.d);
            if (customerID > 0) {
                $.each(datas, function (index, value) {
                    if (value.MembershipID == customerID) {
                        $("#txtCustomerName").val(value.Fname + " " + value.Lname);
                        $("#txtPAN").val(value.PAN);
                        $("#hdfAddress").val(value.Address);
                        $(pmntMode).prop('checked', true);
                        return false;
                    }
                });
            } else {
                $("#memberList").show();
                $("#memberList").html('');
                if (datas.length > 0) {
                    var htmls = "<table id='membertable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th><th>Paid</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "'>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        htmls += "<td>" + "<img src='/images/completed.png' class='selectCust' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                        htmls += "</tr>"
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#memberList').html(htmls);
                    $('#membertable').DataTable(
                        {

                            "jQueryUI": true,

                        });
                    $("#memberList").dialog({
                        'title': 'Customer',
                        width: 800,
                        modal: true,
                        resizable: true,
                    });
                } else {
                    $('#memberList').html('No data');

                }

                $(".dataTables_scrollBody").css('height', '100%');
                $("#memberList").on('click', '#membertable tr', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    $("#hdfCusID").val(ids[1]);
                    $("#txtCustomerName").val(ids[2] + " " + ids[3]);
                    $("#txtPAN").val(ids[4]);
                    $("#hdfAddress").val(ids[5]);
                    $("#memberList").dialog('close');
                    $(".txtRem").show();
                    $(pmntMode).prop('checked', true);
                    var surplusDef = parseFloat($('#txtsurplus').html());
                    if (surplusDef < 0) {
                        $(pmntMode).closest('tr').find('.txtPayAmount').val(Math.abs(surplusDef));
                        $('.txtPayAmount').change();
                    }
                });
            }
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function getSalesMasterDtls(salesMasterid) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/OrderWebservice.asmx/GetSalesMasterDtll",
        data: JSON.stringify({ salesMasterId: salesMasterid }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            custName = result.CusName;
            phoneNumber = result.PhoneNumber;
            discount = result.totaldiscount;
            //console.log(custName + ' - ' + phoneNumber + ' - ' + discount);
        }
    });
}