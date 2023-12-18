function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function print() {
    var contents = $('#ViewReport').html();
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

(function
    ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                Username: '',
                ModulePath: '/Modules/RoiPurchase/'
            }, p);
        var v = 0;
        var count = 0;
        var number = 0;
        var numbers = 0;
        var PurchaseArray = [];
        var ArrayData = [];
        var arraycount = 0;
        var items = [];
        var TotalAmount = 0;
        var Amount = 0;
        var VAT = 0;
        var VATAmount = 0;
        var selectedIndex = 0;
        var TempTotal = '';
        var vat = false;
        var option = 0;
        var receivedlist = [];
        var IsVat = false;
        var VatItemTotal = 0;
        var NonVatItemTotal = 0;
        var TotalDiscount = 0;
        var ExtraDiscount = 0;
        var BasicAmount = 0;
        var TaxAmount = 0;
        var TotalAmount = 0;
        var Paymode = [];
        var vendorlist = [];
        var revDisPer = 0.00;
        var disPercent = 0.00;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "PurchaseWebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                UnitId: 0,
                Unitupdate: 0,
                Unit1Id: 0,
                Unit1IdUpdate: 0,
                Unit2ID: 0,
                Unit2IDUpdate: 0,
                PurchaseMainID: 0,
                PurchaseDetailsID: 0,
                PurchaseUpdate: 0,
                MemberIDUpdate: 0,
            },
            InitialSetup: function () {
                eventFunction.getVender();
                //eventFunction.getPurchaseList();
                eventFunction.GetPaymentModesAndProviders();

                $('#btnPurchaseCancel').hide();
                $('#VendorBox').hide();
                $('.unit').hide();
                $('#txtvatAmt').text('0');
                $('#txtnonAmt').text('0');
                $('#totaldiscount').val('0');
                $('#txtdiscount').val('0');
                $('#txttaxableAmt').text('0');
                $('#txttaxAmt').text('0');
                $('#txttotalAmt').text('0');

            },
            init: function () {
                eventFunction.GetItem();
                eventFunction.InitialSetup();
                $(".po").hide();
                $("#btnPurchaseSave").hide();
                $(".unclick_show").hide();
                $('#tblAddItem').hide();
                $("#txtBillDate").datepicker({ dateFormat: "yy/mm/dd" }).datepicker("setDate", new Date());
                $("#txtExpDate").datepicker({
                    minDate: 0,
                    changeMonth: true,
                    changeYear: true,
                    yearRange: '2017:2020',
                });

                eventFunction.getTodayFiscalYr();
                $("#CheckBoxGoodReceived").change(function () {
                    eventFunction.GetStore();
                    if ($(this).is(":checked")) {
                        $("#checkStore").show();
                    }
                    else {
                        $("#checkStore").hide();
                    }

                });



                $('#txtSearch').on('keyup', function () {
                    eventFunction.bindPurchaseList();
                });

                $("#btnView").off('click').on('click', function () {
                    eventFunction.getPurchaseList();
                });

                $('#tblAddItem').on('keyup', '#txtTotal', function () {
                    var qty = $('#txtQuentity').val();
                    var total = $('#txtTotal').val();
                    var rate = (total / qty).toFixed(2);
                    $('#txtRate').val(rate);
                });

                $('#purchaseTempTable').on('keyup', '.Quenity', function () {

                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find(".Quenity").val();
                        var rate = $(value).find(".UnitRate").val();
                        var result = rate * qty;
                        $(value).find('.Total').val(result.toFixed(1));

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            var disc = parseFloat($(value).find('.discount').val());
                            var tt = total - disc;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();
                });

                $('#purchaseTempTable').on('keyup', '.UnitRate', function () {
                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find(".Quenity").val();
                        var rate = $(value).find(".UnitRate").val();
                        var result = rate * qty;
                        $(value).find('.Total').val(result.toFixed(1));

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            var disc = parseFloat($(value).find('.discount').val());
                            var tt = total - disc;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();
                });

                $('#purchaseTempTable').on('change', 'input[type=checkbox]', function () {
                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            var disc = parseFloat($(value).find('.discount').val());
                            var tt = total - disc;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();
                });

                $('#purchaseTempTable').on('keyup', '.Total', function () {
                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find(".Quenity").val();
                        var total = $(value).find(".Total").val() == "" ? 0 : $(value).find(".Total").val();
                        var result = total / qty;
                        $(value).find('.UnitRate').val(result.toFixed(1));
                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            var disc = parseFloat($(value).find('.discount').val());
                            var tt = total - disc;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();
                });


                $('#purchaseTempTable').on('keyup', '.discount', function () {
                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            var disc = parseFloat($(value).find('.discount').val());
                            var tt = total - disc;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();

                });

                $('#purchaseTempTablefoot').on('change', '#totaldiscount', function () {
                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            var disc = parseFloat($(value).find('.discount').val());
                            var tt = total - disc;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();

                });

                $('#divForForm').on('click', '#chkBoxTotalDis', function () {
                    if ($('#chkBoxTotalDis').prop('checked')) {
                        //Individual Discount Needed
                        $('.divDis').show();
                        $('.discount').show();
                        $('#totaldiscount').prop('disabled', true);

                    } else {
                        //Summary Discount Needed
                        $('.divDis').hide();
                        $('.discount').hide();
                        $('#totaldiscount').prop('disabled', false);
                    }
                });


                $('#purchaseTempTablefoot').on('keyup', '.txtdiscount', function () {

                    eventFunction.CalculateTotal();
                });




                $("#btnPurchaseAdd").on('click', function () {
                    var item = $("#DdlItemid").val();
                    var unit = $("#DdUnitFortextbx").val();
                    var qts = $("#txtQuentity").val();
                    var qtstext = $("#txtQuentityText").val();
                    var txtRate = $("#txtRate").val();
                    var txtID = $("#txtID").val();
                    var txtTotal = $("#txtTotal").val();

                    if (item == "") {
                        jAlert("Please Fill The Item Name", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    } else if (unit == null) {
                        jAlert("Please Fill The Unit", 'Alert!!', function () { $.alerts.dialogClass = null; });

                    } else if (qts == "") {
                        jAlert("Please Fill The Quantity", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    } else if (qtstext == "") {
                        jAlert("Please Fill The Quantity in Text", 'Alert!!', function () { $.alerts.dialogClass = null; });

                    }
                    else if (txtRate == "") {
                        jAlert("Please Fill The Rate", 'Alert!!', function () { $.alerts.dialogClass = null; });

                    }
                    else {
                        if (numbers != 100 || txtID == 0) {
                            eventFunction.AddPurchase();
                            $('#DdlItemid').val('');
                            $('#DdlItemid').html('');

                            $('#textUnit').val('');
                            $('#DdUnit').html('');

                            $('#txtQuentity').val('');
                            $('#txtQuentityText').val('');
                            $('#txtRate').val('0');
                            $('#txtTotal').val('');
                            $('#DdUnitFortextbx').val('');

                            numbers = 0
                        }
                        else {

                            var MyRows = $("#AddTempTable tbody").find("tr");
                            $(MyRows[selectedIndex - 1]).find('td:eq(0)').html($("#DdlItemid").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(1)').html($("#lblItemid").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(2)').html($("#DdUnitFortextbx").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(3)').html($("#DdUnit").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(4)').html($("#txtQuentity").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(5)').html($("#txtRate").val());
                            //$(MyRows[selectedIndex - 1]).find('td:eq(6)').html($("#txtLotNNo").val());
                            //$(MyRows[selectedIndex - 1]).find('td:eq(7)').html($("#txtBatchNo").val());
                            //$(MyRows[selectedIndex - 1]).find('td:eq(8)').html($("#txtExpDate").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(6)').html($("#txtTotal").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(6)').html($("#txtTotal").attr('attr-conversion'));

                        }
                    }

                });

                $("#btnAddItems").on('click', function () {
                    eventFunction.GetItem();
                    $("#tblAddItem").dialog({
                        'title': 'Add Items',
                        width: 600,
                        modal: true,
                        dialogClass: 'headingbg',
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                });

                $("#btnPurchaseClose").on('click', function () {
                    $("#tblAddItem").dialog("close");
                });

                $("#btnPurchaseSave").unbind('click').on('click', function () {
                    var checkValid = $('.itemname').text();

                    var quantity = $('.Quenity').filter(function () {
                        return $(this).val() == '0';
                    });

                    var value = $('.UnitRate').filter(function () {
                        return $(this).val() == "";
                    });

                    if (checkValid == "") {
                        jAlert("Please Add Items", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if (value.quantity > 0) {
                        jAlert("Please! Quantity must be greater than 0.", 'Alert!!');
                    }
                    else if (value.length > 0) {
                        jAlert("Please! Insert Rate.", 'Alert!!');
                    }
                    else if ($("#CheckBoxGoodReceived").is(":checked")) {
                        //$("#payOption").dialog({
                        //    'title': 'Choose Pay Option',
                        //    width: 300,
                        //    modal: true,
                        //    dialogClass: 'headingbg',
                        //    resizable: true,
                        //    dialogClass: 'popup-titlebg'
                        //});
                        var Stid = $("#ddlStore").val();
                        var inv = $("#txtIvNo").val();
                        var value = $('.UnitRate').filter(function () {
                            return $(this).val() == '0';
                        });
                        if (Stid == null || Stid == "") {
                            jAlert("Please! Select STore", 'Alert!!');
                        } else if (inv == "") {
                            jAlert("Please! Insert Invoice no", 'Alert!!');
                        } else if (value.length > 0) {
                            jAlert("Please! Rate must be greater than 0.", 'Alert!!');
                        }
                        else {
                            eventFunction.BindPaymentModesAndProviders();
                        }

                    } else {
                        jConfirm('Do You want to save the purchase?', 'Confirmation!!', function (confirm) {
                            if (confirm) {
                                var MemberInfo = {};
                                var checkGoods = false;
                                var Stid = 0;
                                eventFunction.SavePurchase(checkGoods, Stid, MemberInfo);
                            }
                        });
                    }


                });


                $("#btnPurchaseCancel").on('click', function () {
                    location.reload();
                    $('#btnPurchaseCancel').hide();


                    $(".po").hide();
                    $("#btnPurchaseSave").hide();
                    $(".unclick_show").hide();

                    $("#divForPurchaseList").show();

                    eventFunction.ResetAll();


                });

                $("#txtRate").keyup(function () {

                    var qty = $('#txtQuentity').val();
                    var rate = $('#txtRate').val();

                    $('#txtTotal').val((qty * rate).toFixed(2));

                });

                $("#txtQuentity").keyup(function () {
                    var qty = $('#txtQuentity').val();
                    var rate = $('#txtRate').val();
                    var total = $('#txtTotal').val();
                    $('#txtTotal').val((qty * rate).toFixed(2));



                });

                $("#chkVendorBox").change(function () {
                    if ($(this).prop('checked') == true) {
                        eventFunction.bindVendorBox();
                    }
                    else {
                        $("#VendorBox").hide();
                        $("#txtVendorName").hide();
                        $("#txtVendorName").val('');
                        $('#txtVendorNameID').val(0);
                    }
                });

                $("#expirable").on('click', function () {
                    if ($('#expirable').is(':checked')) {
                        $(".unclick_show").show();
                    }
                    else {
                        $(".unclick_show").hide();
                    }
                });

                $('#txtQuentity').keypress(function (event) {
                    if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57) && event.which != 8) {
                        event.preventDefault();
                    }
                });

                $("#CancelItems").click(function () {
                    eventFunction.ResetAll();
                });
            },


            CalculateTotal: function () {
                var totaldiscount = 0.00;
                var temp = 0.00;
                var DisAmt = 0.00;
                var allChecked = true;
                var nonamount = 0.00;
                var vatamount = 0.00;
                $('.discount').each(function () {
                    var dist = parseFloat($(this).val())
                    totaldiscount += (isNaN(dist) ? 0 : dist)
                });
                totaldiscount += parseFloat($('#totaldiscount').val());

                $('#totaldiscount').val((totaldiscount).toFixed(2));

                var MyRows = $('#purchaseTempTable').find('tbody').find('tr');
                for (var i = 0; i < MyRows.length; i++) {
                    var allchecked = $(MyRows[i]).find('.chkISVAT').is(":checked");
                    if (allchecked == true) {
                        vatamount += parseFloat($(MyRows[i]).find(".Total").val() == "" ? 0 : $(MyRows[i]).find(".Total").val());
                    }
                    else {
                        nonamount += parseFloat($(MyRows[i]).find(".Total").val());
                    }
                }

                BasicAmount = vatamount + nonamount;

                disPercent = Math.trunc(((totaldiscount * 100) / BasicAmount) * 100) / 100;
                revDisPer = Math.trunc((100 - disPercent) * 100) / 100;

                $('#txtBasicAmt').text(BasicAmount);
                $('#txtvatAmt').text(Math.trunc(vatamount * 100) / 100);
                $('#txtnonAmt').text(Math.trunc(nonamount * 100) / 100);
                //Getting Tax Amount

                $('.vat').each(function () {

                    var vt = parseFloat($(this).text())
                    var DisAmt = Math.trunc(((vt * revDisPer) / 100) * 100) / 100;
                    temp += (isNaN(DisAmt) ? 0 : DisAmt)
                });
                //if (temp > 0) {
                //    temp = temp - totaldiscount;
                //}

                $('#txttaxAmt').text((temp).toFixed(2));
                var total = (vatamount + nonamount + temp) - (totaldiscount + parseFloat($("#txtdiscount").val() == "" ? 0 : $("#txtdiscount").val()));

                $('#txttotalAmt').text(Math.trunc(total * 100) / 100);



            },



            UpdateCustomerName: function (id) {
                var MembershipID = id;
                var MemberInfo = {};
                MemberInfo.MembershipID = MembershipID;
                MemberInfo.RemainingBalance = parseFloat($('#txtCalRemainingAmount').val() == "" ? 0 : $('#txtCalRemainingAmount').val());
                MemberInfo.PayAmount = parseFloat($('#txtCalPaidAmount').val() == "" ? 0 : $('#txtCalPaidAmount').val());
                MemberInfo.AddedBy = SageFrameUserName;
                var checkGoods = $("#CheckBoxGoodReceived").is(":checked");
                var Stid = checkGoods ? $("#ddlStore").val() : 0;
                eventFunction.SavePurchase(checkGoods, Stid, MemberInfo);
            },



            getTodayFiscalYr: function () {
                eventFunction.config.method = "getTodayFiscalYr";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 9;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetStore: function () {
                eventFunction.config.method = "getIssueToDDl";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 15;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getPurchaseList: function () {

                var startDate = $('#txtStartDate').val();
                var endDate = $('#txtEndDate').val();

                var data = JSON.stringify({ startDate: startDate, endDate: endDate });

                eventFunction.config.method = "getPurchaseList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = data;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindPurchaseList: function () {

                purchaselist = receivedlist;
                var i = 0;
                if (!purchaselist) return;
                var htmls = "";
                htmls += "<table id='tableForPurchaseList' class='reportsprint' cellspacing='0'><thead><tr><th>S.N.</th><th>Purchase Number</th><th>Purchase Date</th><th>Vendor Name</th><th>Remarks</th><th>Posted Date</th><th colspan='2'>Action</th></tr></thead><tbody>";
                $.each(purchaselist, function (index, value) {
                    var search = $('#txtSearch').val().toLowerCase();
                    if (value.Fname.toLowerCase().includes(search) || value.PuNo.toLowerCase().includes(search) || value.Lname.toLowerCase().includes(search) || search == '') {
                        var tempvat = value.IsVat;
                        i++;
                        htmls += "<tr class='tableItem'><td>" + i + ".</td><td>" + value.PuNo + ".</td><td>" + value.PbDate + "</td><td>" + value.Fname + " " + value.Lname + "</td><td>" + value.Remarks + "</td><td>" + value.PostedOn + "</td>";
                        htmls += "<td class='tdcenter'>";
                        if (value.GoodReceived == 0) {

                            htmls += "<img src='/images/edit.png' input type='button' id='" + value.PurchaseMainID + "_" + value.PuNo + "_" + value.Remarks + "_" + value.IvNo + "_" + value.vender + "_" + value.Fname + "_" + value.Conversion + "_" + value.IsVat + "' class='PurchaseEdit edit-icon' value='Edit'>";
                            htmls += " | <img src='/images/delete.png' class='PurchaseDelete delete-icon' type='button'  id=_" + value.PurchaseMainID + "_" + value.PurchaseDetailsID + " value='Delete'/>";
                        }
                        htmls += "</td>";
                        htmls += "</tr>";
                    }
                });
                htmls += "</tbody></table>";
                $("#divForPurchaseList").html(htmls);
                //$("#tableForPurchaseList").DataTable({
                //    "jQueryUI": true,
                //    columnDefs: [{ orderable: false, targets: [3, 4] }]
                //});


                $('#tableForPurchaseList').on('click', '.PurchaseEdit', function () {
                    $("#tblCheckGoods").hide();
                    $('.report-filter').hide();
                    $("#btnAdd").hide();
                    $("#divForPurchaseList").hide();
                    $("#divForForm").show();
                    $("#btnPurchaseSave").show();
                    $('#btnPurchaseCancel').show();
                    var id = $(this).attr('id');
                    var word = id.split("_");
                    $('#txtID').val(word[0]);
                    $('#txtPuno').val(word[1] + "_" + word[2]);
                    $('#txtRemarks').val(word[3]);
                    $('#txtIvNo').val(word[4]);
                    if (word[5] != 0) {
                        $('#txtVendorName').show();
                        $("#txtVendorName").css('display', "inherit");
                        $('#txtVendorName').val(word[6]);
                        $('#txtVendorNameID').val(word[5] + '_' + word[8]);
                        $("#chkVendorBox").attr('checked', true);
                    }
                    else if (word[5] == 0) {
                        $('#txtVendorName').hide();
                    }




                    eventFunction.config.ItemID = word[0];
                    var ids = word[0];
                    eventFunction.config.method = "getPurchaseDetailsFor";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ purchaseid: ids });

                    eventFunction.config.ajaxCallMode = 17;
                    eventFunction.ajaxCall(eventFunction.config);



                });
                $("#tableForPurchaseList").on('click', '.PurchaseDelete', function () {
                    var ids = $(this).attr('id');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            var word = ids.split("_");
                            var mainId = word[1];
                            var detailsId = word[2];
                            eventFunction.deletePurchase(mainId, detailsId);
                        }
                    });
                });
            },

            deletePurchase: function (mainId, detailsId) {
                eventFunction.config.method = "deletePurchase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ mainId: mainId, detailsId: detailsId });
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
            deleteAfterEdit: function (idForDelete, MainIdForDelete) {
                eventFunction.config.method = "deleteAfterEdit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ idForDelete: idForDelete, MainIdForDelete: MainIdForDelete });
                eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);
            },
            getPurchaseDetailsbyID: function (mainId) {
                eventFunction.config.method = "getPurchaseDetailsbyID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ mainId: mainId });
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },
            getPurchaseLotNobyID: function (mainId) {
                eventFunction.config.method = "getPurchaseLotNobyID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ mainId: mainId });
                eventFunction.ajaxCall(eventFunction.config);
            },


            getVender: function () {
                eventFunction.config.method = "getVender";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 12;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindVender: function (result) {
                data = result.d;
                if (!data) return;
                html = "";
                html += "<option selected diabled> -Select- </option>"
                $.each(data, function (index, value) {
                    var tempvat = value.IsVat;

                    html += "<option value='" + value.MembershipID + "_" + tempvat + "'>" + value.Fname + " " + value.Lname + "</option>"
                });

                $("#ddlvendorID").html(html);
            },

            getQuentityinText: function () {
                var numb = $("#txtQuentity").val();
                eventFunction.config.method = "changeCurrencyToWords";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ numb: numb });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindText: function (result) {
                var datas = result.d;
                $("#txtQuentityText").val(datas);
            },


            BindStore: function (result) {
                datas = JSON.parse(result);
                var x = new Array();
                if (datas.length > 0) {
                    var htmls = "";
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });
                }
                return htmls;

            },

            bindPDetailsbyID: function (result) {
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = '';
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem'>";
                        htmls += "<td class='itemID' style='text-align:left;'>" + value.ITName + "</td>";
                        htmls += "<td class='itemname acc'>" + value.ITId + "</td>";
                        htmls += "<td class='itemIDClass' >" + value.UnitName + "</td>";
                        htmls += "<td class='unitDescri acc'>" + value.UnitID + "</td>";
                        //htmls += "<td class='Quenity'>" + value.Quentity + "</td>";
                        htmls += "<td value='" + value.Quentity + "'><input type='text' class='sfInputbox Quenity' style='width: 100px;border:none;' value='" + value.Quentity + "'></td>";
                        htmls += "<td value='" + value.Rate + "'><input type='text' class='sfInputbox UnitRate' style='width: 100px;border:none;' value='" + value.Rate + "'></td>";
                        htmls += "<td class='LotNo'>" + value.LotNo + "</td>";
                        htmls += "<td class='BatchNo'>" + value.BatchNo + "</td>";
                        htmls += "<td class='ExpDate'>" + value.ExpDate + "</td>";
                        htmls += "<td class='Total'>" + value.Total + "</td>";

                        htmls += "<td>" + "<img src='/images/delete.png' class='PdDelete'  id='PdDelete_" + number + "_" + value.PurchaseDetailsID + "_" + value.PurchaseMainID + "' value='Delete'/>" + "</td>";


                        htmls += "</tr>"
                        count++;

                        $("#purchaseTempTable tbody").html(htmls);
                        $("#AddTempTable").show();
                        $("#btnPurchaseSave").show();


                        $("#purchaseTempTable").on('click', '.PdEdit', function () {
                            var data = $(this).attr('id');
                            var splicedata = data.split('_');
                            var table = $("#purchaseTempTable");
                            var rows = table.find("tr.tableItem");
                            var index = parseInt(splicedata[1]);
                            selectedIndex = parseInt(index);
                            numbers = 100;
                            var table = $("#IssueTempTable");
                            var rows = table.find("tr.tableItem");
                            var UnitName = splicedata[3];
                            $('#DdlItemid').val($(this).closest('tr').find(".itemID").html());
                            $('#lblItemid').val($(this).closest('tr').find(".itemname").html());
                            $('#DdUnitFortextbx').val($(this).closest('tr').find(".itemIDClass").html());
                            $('#DdUnit').val($(this).closest('tr').find(".unitDescri").html());
                            // $('#txtQuentity').val($(this).closest('tr').find(".Quenity").html());
                            $('#txtQuentity').val($(this).closest('tr').find(".Quenity").val());
                            $('#txtRate').val($(this).closest('tr').find(".UnitRate").html());
                            $('#txtRate').val($(this).closest('tr').find(".UnitRate").val());
                            $('#txtLotNNo').val($(this).closest('tr').find(".LotNo").html());
                            $('#txtBatchNo').val($(this).closest('tr').find(".BatchNo").html());
                            $('#txtExpDate').val($(this).closest('tr').find(".ExpDate").html());
                            $('#txtTotal').val($(this).closest('tr').find(".Total").html());
                            $('#txtTotal').val($(this).closest('tr').find(".Total").val());
                            var value = ($(this).closest('tr').find(".LotNo").html());

                            if (value != "") {
                                $("#expirable").prop("checked", true);
                                $(".unclick_show").css("display", "block");
                            }
                            numbers = 100;

                        });
                        $("#purchaseTempTable").on('click', '.PdDelete', function () {
                            var data = $(this).attr('id');
                            var splicedata = data.split('_');
                            var idForDelete = splicedata[2];
                            var MainIdForDelete = splicedata[3];
                            eventFunction.deleteAfterEdit(idForDelete, MainIdForDelete);
                        });

                    });
                }
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
                        jAlert("Inserted successfully. Your Purchase No is: " + $('#txtPuno').val(), 'Information!!', function () { $.alerts.dialogClass = null; });
                        //window.open('/Modules/RoiPurchase/Purchase-Order.aspx?ID=' + eval(data.d), '_blank');
                        var PoNO = eval(data.d);
                        if ($("#CheckBoxGoodReceived").is(":checked")) {
                            $('#payment').dialog("close");
                            eventFunction.GetPurchaseDetailsbypurchaseID(parseInt(PoNO));
                            $('#PurchaseViewReport').dialog({
                                'title': 'Purchase order',
                                width: '400',
                                modal: true,
                                dialogClass: 'unpaidd',
                                position: ['center', 'center']
                            });
                        }
                        eventFunction.ResetAll();
                        break;
                    case 3:

                        eventFunction.BindDropdwonUnit(data.d);
                        break;
                    case 4:
                        eventFunction.bindVender(data);
                        break;
                    case 5:
                        eventFunction.BindText(data);
                        break;
                    case 6:
                        receivedlist = JSON.parse(data.d);
                        eventFunction.bindPurchaseList();
                        break;
                    case 7:
                        jAlert('Successfully Deleted', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        eventFunction.InitialSetup();
                        break;
                    case 8:
                        eventFunction.BindStore(data.d);
                        break;
                    case 9:
                        var html = "";
                        $.each(data.d, function (index, value) {
                            html += "<option value='" + value.fyId + "'>" + value.fyName + "</option>"
                        });
                        $("#txtFyid").html(html);
                        break;
                    case 10:
                        eventFunction.bindPDetailsbyID(data);
                        break;
                    case 11:
                        jAlert('Successfully Deleted', 'Information!!', function () { $.alerts.dialogClass = null; });
                        // window.open('/Modules/RoiPurchase/Purchase-Order.aspx?ID=' + eval(data.d), '_blank');
                        var PoNO = eval(data.d);
                        eventFunction.GetPurchaseDetailsbypurchaseID(parseInt(PoNO));
                        $('#PurchaseViewReport').dialog({
                            'title': 'Purchase order',
                            width: '350',
                            height: 'auto',
                            modal: true,
                            dialogClass: 'unpaidd',
                            position: ['center', 'center']
                        });
                        value = $('#txtID').val();
                        eventFunction.getPurchaseDetailsbyID(value);
                        break;

                    case 12:
                        vendorlist = JSON.parse(data.d);
                        break;
                    case 13:
                        eventFunction.Bindmember(data.d);
                        $("#membeshipformlist").dialog('open');
                        $("#membeshipformlist2").dialog({
                            'title': 'Customer Balance',
                            width: 800,
                            modal: true,
                            dialogClass: 'headingbg',
                            resizable: true,
                        });
                        break;
                    case 15:
                        result = data.d;
                        $(".Store").html('');
                        $(".Store").html(eventFunction.BindStore(data.d));
                        break;
                    case 16:
                        eventFunction.BindPo(data);
                        break;

                    case 17:

                        eventFunction.bindDetailsFor(data.d);
                        break;

                    case 18:
                        jAlert("Inserted Updated. Your Purchase No is: " + $('#txtPuno').val(), 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        break;
                    case 19:
                        eventFunction.BindPurchaseDetailsReport(data.d);
                        break;
                    case 20:
                        Paymode = data.d;
                        break;

                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetPaymentModesAndProviders: function () {
                var loggername = SageFrameUserName;
                eventFunction.config.method = "GetPaymentModesAndProvider";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 20;
                eventFunction.ajaxCall(eventFunction.config);
            },


            BindPo: function (result) {

                var datas = result.d;

                $("#txtPuno").val(datas[0].PuNo);
            },


            GetPurchaseDetailsbypurchaseID: function (purchasemainID) {
                eventFunction.config.method = "GetGoodsRecieveFromPurchaseID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    purchasemainID: purchasemainID
                });
                eventFunction.config.ajaxCallMode = 19;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindPurchaseDetailsReport: function (data) {
                $("#PurchaseViewReport").html();
                var datas = JSON.parse(data);
                var companyInfo = datas.companyInfo;
                var purchaseMain = datas.goodsMain;
                var htmls = '';
                var date = purchaseMain[0].InvoiceDate.split("T");
                htmls += '<input type="button" id="btnPrints" value="Print" class="sfBtn restro-btn">';

                htmls += '<div id="ViewDetailsReport" style="margin-top:10px;">';
                htmls += "<table style='width:100%;border:1px solid;padding-bottom:5px;padding-right:5px;margin:0;'>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align:center;padding-top:10px;padding-bottom:10px;border-bottom:1px solid;'><b id='InvoiceType'>INVOICE</b></td></tr>";
                htmls += "<tr><td rowspan='4' colspan='1' style='font-size:22px;font-weight:bold;border-right:1px solid;border-bottom:1px solid;text-align:center;'> Purchase Order </td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:16px;font-weight:bold;border-bottom:1px solid;'>" + companyInfo[0].Name + "</td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:12px;border-bottom:1px solid;'>" + companyInfo[0].Address + "</td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:12px;border-bottom:1px solid;'>" + companyInfo[0].PhoneNo + "</td></tr>";

                htmls += "<tr><td style='font-size:11px;text-align:left;'> InvoiceNo : " + purchaseMain[0].InvoiceNo + "</td>";
                htmls += "<td style='font-size:11px;text-align:right;'> Purchase No : " + purchaseMain[0].PuNo + "</td></tr>";
                htmls += "<tr><td style='font-size:11px;text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>";
                htmls += "<td style='font-size:11px;text-align:right;'> Date : " + date[0] + "</td></tr>";
                htmls += "<tr><td style='font-size:11px;text-align:left;'> Seller's Name. : " + purchaseMain[0].Fname + "</td>";
                htmls += "<td style='font-size:11px;text-align:right;'> Payment Mode : " + purchaseMain[0].PayMode + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Address. : " + purchaseMain[0].Address + "</td>";
                htmls += "</tr></table>";

                htmls += "<table id='tableForPurchaseDetailsReport' class='sfGridwrapper display' cellspacing='0' style='width:100%;text-align:left;border:1px solid;border-top:none;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:5%;'>SN</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:45%;'>ItemName</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Quantity</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Rate</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:20%;'>Total</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:12%;'>Disc</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                var count = 1;
                $.each(purchaseMain, function (index, value) {
                    htmls += "<tbody style='border-bottom:1px solid;'>"
                    htmls += "<tr>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:5%;'>" + count + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:45%;'>" + (value.IsVat ? '' : '*') + "" + value.ITName + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.Quentity + ' ' + value.Symbol + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.UnitRate + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:15%;'>" + value.Total + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:10%;'>" + value.Discount + "</td>";

                    if (value.IsVat == true) {
                        VatItemTotal += parseFloat(value.Total);
                        VAT += parseFloat(value.Total) - parseFloat(value.Discount);
                    } else {
                        NonVatItemTotal += parseFloat(value.Total);
                    }
                    TotalDiscount += parseFloat(value.Discount);
                    htmls += "</tr>"
                    count++;
                });
                ExtraDiscount = parseFloat(purchaseMain[0].ExtraDiscount);

                TaxAmount = VAT * 0.13;
                TotalAmount = (VatItemTotal + NonVatItemTotal + TaxAmount) - (TotalDiscount + ExtraDiscount);
                htmls += "</tbody>";
                htmls += "<tfoot>"
                htmls += "<tr><td rowspan='7' colspan='3' style='font-size:12px;border-top:1px solid;border-right:1px solid;'>In Words Rs. " + convertNumberToWords(TotalAmount) + " only.</td></tr>"
                htmls += "<tr>"

                htmls += "<td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Taxable Total</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + VatItemTotal.toFixed(2) + "</td></tr>";
                htmls += "<td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Nontaxable Total</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + NonVatItemTotal.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Total Discount </td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalDiscount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Extra Discount </td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + ExtraDiscount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>13 % VAT</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TaxAmount.toFixed(2) + "</td></tr>";
                // htmls += "<tr><td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>13 % VAT </td><td colspan='2'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + VAT.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align: right;border-right:1px solid;border-top:1px solid;'>Net Amount</td><td colspan='2'style='font-size:12px;text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalAmount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td colspan='7' style='font-size:12px;border-top:1px solid;text-align:left;padding-top:5px;'>Note:- (*) Sign Before Product Name is Non Taxable Items.</td></tr>"
                htmls += "</tr><tr><td colspan='7' ><div style='width:100px;text-align:center;border-top:1px solid;float:right;'>Signature</div></td></tr>"
                htmls += "</tfoot>"
                TotalAmount = 0;
                VAT = 0;
                VatItemTotal = 0;
                NonVatItemTotal = 0;
                TotalDiscount = 0;
                ExtraDiscount = 0;
                TaxAmount = 0;

                htmls += "</table>";
                htmls += "</div>";
                $('#PurchaseViewReport').html(htmls);

                $("#btnPrints").click(function () {
                    prints();
                });

            },
            bindDetailsFor: function (result) {
                $("#purchaseTempTable tbody").html();
                var vendorSplit = $('#txtVendorNameID').val();
                var splicedata = vendorSplit.split('_');
                var IsVat = splicedata[1];
                var vat = 0;
                var Discount = 0;
                var datas = JSON.parse(result);

                if (datas.length > 0) {
                    var htmls = '';
                    var count = 1;
                    var totalpoint = 0;
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem'>";

                        htmls += "<td class='itemID' style='text-align:left;'>" + value.ITName + "</td>";
                        htmls += "<td class='itemname acc'>" + value.ItemID + "</td>";
                        htmls += "<td class='itemIDClass' >" + value.UnitName + "</td>";
                        htmls += "<td class='unitDescri acc'>" + value.UnitID + "</td>";
                        htmls += "<td><input type='text' onkeypress='return IntegerAndDecimal(event,this);' class='sfInputbox Quenity' style='width: 100px;' value='" + value.Quentity + "' /></td>";

                        htmls += "<td><input type='text' onkeypress='return IntegerAndDecimal(event,this);' class='sfInputbox UnitRate' style='width: 100px;' value='" + value.Rate + "' /></td>";
                        if (value.Rate == 0) {
                            htmls += "<td><input type='text' onkeypress='return IntegerAndDecimal(event,this);' class='sfInputbox Total' style='width: 100px;' value='" + 0 + "' /></td>";
                        } else {
                            htmls += "<td><input type='text' onkeypress='return IntegerAndDecimal(event,this);' class='sfInputbox Total' style='width: 100px;' value='" + (value.Total) + "' /></td>";
                        }
                        htmls += "<td class='divDis' style='display: none;'><input type='text' class='sfInputbox discount' onkeypress='return IntegerAndDecimal(event,this);' style='width: 100px;background:transparent;' value='" + value.Discount + "'></td>";
                        if (value.IsVat == true) {
                            htmls += "<td><input type='checkbox' class='chkISVAT' checked/> </td>";
                        }
                        else {
                            htmls += "<td><input type='checkbox' class='chkISVAT' unchecked/> </td>";
                        }

                        htmls += "<td class='vat' style='display:none;' >" + vat + "</td>";
                        htmls += "<td class='tdcenter'><img src='/images/delete.png' class='PurchaseDelete'  id='PurchaseDelete_" + count + "' value='Delete'/></td>";
                        htmls += "<td class='ddunit' style='display:none;'>" + value.UnitID + "</td>";
                        htmls += "<td class='conversion' style='display:none;'>" + value.Conversion + "</td>";
                        htmls += "<td class='Recq' style='display:none;'>" + value.RecqDetailId + "</td>";
                        htmls += "<td class='RecqId' style='display:none;'>" + value.RecqId + "</td>";
                        htmls += "</tr>"
                        count++;

                    });

                    $("#purchaseTempTable tbody").html(htmls);

                    $("#AddTempTable").show();
                    $("#btnPurchaseSave").show();
                    $("#purchaseTempTable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find(".Quenity").val();
                        var total = $(value).find(".Total").val();
                        var result = total / qty;
                        $(value).find('.UnitRate').val(result.toFixed(1));
                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = $(value).find(".Total").val();
                            //var disc = parseFloat($(value).find('.discount').val());
                            var tt = total;
                            tot = tt * 0.13;
                        }
                        else {
                            tot = 0.00;
                        }
                        $(value).find('.vat').text(tot.toFixed(1));
                    });
                    eventFunction.CalculateTotal();
                }


                $(".PurchaseDelete").unbind('click').on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            var splicedata = data.split('_');
                            var index = parseInt(splicedata[1]);
                            TempTotal -= parseFloat(row.find(".Total").val());
                            row.remove();

                            $("#purchaseTempTable>tbody>tr").each(function (index, value) {
                                var qty = $(value).find(".Quenity").val();
                                var total = $(value).find(".Total").val();
                                var result = total / qty;
                                $(value).find('.UnitRate').val(result.toFixed(1));
                                var tot = 0.00;
                                var isvat = $(value).find('.chkISVAT').is(":checked");
                                if (isvat == true) {
                                    var total = $(value).find(".Total").val();
                                    var disc = parseFloat($(value).find('.discount').val());
                                    var tt = total - disc;
                                    tot = tt * 0.13;
                                }
                                else {
                                    tot = 0.00;
                                }
                                $(value).find('.vat').text(tot.toFixed(1));
                            });
                            eventFunction.CalculateTotal();
                        }
                    });

                });

            },

            Bindmember: function (data) {
                $("#membeshipformlist2").show();
                $("#membeshipformlist2").html('');

                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<div class='dataTables_wrapper no-footer' style='border-top:none;'><table id='MemberTable' class='sfGridwrapper display tablee-section' cellspacing='0'>"
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

                        htmls += "</tr>"
                        htmls += "<tr>"

                        var rowCount = $('#purchaseTempTable tbody tr').length;
                        var rowtdCount = $("#purchaseTempTable tbody").find('tr:eq(' + (rowCount - 1) + ')').find('td').length;
                        var sum = parseFloat(($("#purchaseTempTablefoot tbody #txttotalAmt").text())).toFixed(2);

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
                    htmls += "</table></div>";

                    $('#membeshipformlist2').html(htmls);
                } else {
                    $('#membeshipformlist2').html('No data');

                }

                $("#membeshipformlist2").on('keyup', '#txtCalPaidAmount', function (event) {

                    var TotalAmount = parseFloat($("#txtCalTotalAmount").val());

                    var paidamount = parseFloat($("#txtCalPaidAmount").val());


                    var totalsum = TotalAmount;
                    if (paidamount > 0 && paidamount <= TotalAmount) {
                        totalsum = TotalAmount - paidamount
                    } else {
                        $("#txtCalPaidAmount").val("");
                    }


                    $("#txtCalRemainingAmount").val(totalsum);
                })

                $("#membeshipformlist2").unbind('click').on('click', '.updatemember', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);
                    var checkValid = eventFunction.ValidationForm();
                    {
                        eventFunction.UpdateCustomerName(id);
                    }
                    $("#membeshipformlist2").dialog("close");
                });
            },

            GetItem: function () {
                items = [];
                datas = JSON.parse(window.localStorage.getItem('ingredientsList'));
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        if (value.PITId != 0) {
                            // if (value.IsProdMaterial == true) {
                            items.push({ label: value.ITName, id: value.ITId, o_rate: value.LastPurchaseRate, });
                        }
                    });
                }

                $("#DdlItemid").autocomplete({
                    source: items,
                    delay: 0,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#lblItemid").val(ids);
                        $("#txtOldRate").val(ui.item.o_rate);
                        //$("#txtRate").val(ui.item.o_rate);
                        eventFunction.config.method = "GetUnitOfItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ ids: ids });
                        eventFunction.config.ajaxCallMode = 3;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });

            },


            GetAutoNumber: function () {

                eventFunction.config.method = "getAutoNumber";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 16;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SavePurchase: function (checkGoods, Stid, MemberInfo) {
                var vendorSplit = $('#txtVendorNameID').val();
                var SuperMainlist = new Array();
                var PurchaseObjectDetails = new Array();
                var RecquistionObjectDetails = new Array();
                var PurchaseObjectDetailsLot = new Array();
                var PurchaseObject = new Object();
                var splicedata = vendorSplit.split('_');
                var vendorValue = parseInt(splicedata[0]);
                var IsVat = splicedata[1];

                var MyRows = $('#purchaseTempTable').find('tbody').find('tr');
                for (var i = 0; i < MyRows.length; i++) {
                    var PurchaseObjectItem = new Object();
                    PurchaseObjectItem.ItemID = parseInt($(MyRows[i]).find('td:eq(1)').html());
                    PurchaseObjectItem.Quentity = parseFloat($(MyRows[i]).find('.Quenity').val());
                    PurchaseObjectItem.QuentityText = "";
                    PurchaseObjectItem.Rate = parseFloat($(MyRows[i]).find('.UnitRate').val());
                    PurchaseObjectItem.Total = parseFloat($(MyRows[i]).find('.Total').val());
                    PurchaseObjectItem.UnitID = parseInt($(MyRows[i]).find('.ddunit').text());
                    PurchaseObjectItem.Conversion = parseFloat($(MyRows[i]).find(".conversion").text());
                    PurchaseObjectItem.RecqDetailId = parseFloat($(MyRows[i]).find(".Recq").text());
                    PurchaseObjectItem.VendorPurchaseId = parseInt(splicedata[0]);
                    PurchaseObjectItem.IsVat = $(MyRows[i]).find('.chkISVAT').is(":checked");
                    if ($('#chkBoxTotalDis').prop('checked')) {
                        PurchaseObjectItem.Discount = parseFloat($(MyRows[i]).find(".discount").val());
                    } else {
                        var ttl = parseFloat($(MyRows[i]).find('.Total').val());
                        PurchaseObjectItem.Discount = Math.trunc(((ttl * disPercent) / 100) * 100) / 100;
                    }
                    PurchaseObjectDetails.push(PurchaseObjectItem);
                }

                var PurchasePaymentList = new Array();
                $('.pmntCheck').each(function () {
                    if ($(this).is(':checked')) {
                        var row = $(this).closest('tr');
                        var spmid = $(this).attr('id').split('_')[1];
                        var purchasePayment = new Object();
                        purchasePayment.paymentModeID = spmid;
                        purchasePayment.ChequeNo = (spmid == 2 ? $(row).find('.txtTransaction').val() : '');
                        purchasePayment.TransactionNo = (spmid == 3 ? $(row).find('.txtTransaction').val() : '');
                        purchasePayment.ProviderID = (spmid == 2 || spmid == 3 ? $(row).find('.selPaymentMode').val() : '');
                        purchasePayment.VendorID = $('#hdfCusID').val();
                        purchasePayment.VendorName = $('#txtName').val();
                        purchasePayment.PayAmount = $(row).find('.txtPayAmount').val();
                        purchasePayment.Remarks = $('.txtRemarks').val();
                        purchasePayment.PAN = $('#txtPAN').val();
                        PurchasePaymentList.push(purchasePayment);
                    }
                });

                superss = new Object();
                superss.PurchaseObjectDetails = PurchaseObjectDetails;
                superss.PurchaseMainID = $('#txtID').val();
                superss.PuNo = $('#txtPuno').val();
                superss.PbDate = $('#txtBillDate').val();
                superss.IvNo = $('#txtIvNo').val();
                var option = $('input[name="PayOption"]:checked').val();
                superss.Vid = vendorValue;
                if (checkGoods) {
                    superss.SPMID = (option == 4 ? 4 : 1);

                } else {
                    superss.SPMID = 0;
                }

                superss.Remarks = $('#txtRemarks').val();
                superss.FyId = $('#txtFyid option:selected').val();
                superss.PostedBy = p.Username;
                var extradiscount = $("#txtdiscount").val() == "" ? 0 : $("#txtdiscount").val();
                var Puno = $('#txtPuno').val();

                var jsonText = JSON2.stringify({ PurchaseObject: superss, goodReceived: checkGoods, PoNO: Puno, StID: Stid, memberInfo: MemberInfo, extradiscount: extradiscount, purchasePayment: PurchasePaymentList });
                eventFunction.config.method = "RestroPurchaseOrder";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                if (eventFunction.config.PurchaseUpdate == 1)
                    eventFunction.config.ajaxCallMode = 18;
                else
                    eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.PurchaseUpdate = 0;
            },

            AddPurchase: function () {

                var table = $("#purchaseTempTable");
                var rows = table.find("tr.tableItem");

                var vendorSplit = $('#txtVendorNameID').val();

                var splicedata = vendorSplit.split('_');
                IsVat = splicedata[1];


                for (var i = 0; i < rows.length; i++) {
                    var item = $(rows[i]);
                    PurchaseArray.push({
                        "ItemID": parseInt(item.find(".itemname").text()),
                        "Quentity": item.find(".Quenity").val(),
                        "QuentityText": parseFloat(item.find(".QuentityText").text()),
                        "Rate": parseInt(item.find(".UnitRate").val()),
                        "Total": parseFloat(item.find(".Total").val()).toFixed(2)
                    })
                };

                var recq = 0;
                var vat = 0;
                var Discount = 0;
                var taxAmt = 0.00;
                var totaldiscount = 0.00;
                var discount = 0.00;
                var tot = 0.00;
                var nonamount = 0.00;
                var vatamount = 0.00;
                var totalAmt = 0.00;

                var htmls = '';
                $('.deleteTotal').remove();
                $('.vatValue').remove();
                $('.discountValue').remove();
                $("#AddTempTable").show();
                $("#btnPurchaseSave").show();
                number += 1;
                htmls += "<tr class='tableItem'>";
                htmls += "<td class='itemID' style='text-align:left;'>" + $('#DdlItemid').val() + "</td>";
                htmls += "<td class='itemname acc'>" + $('#lblItemid').val() + "</td>";
                htmls += "<td class='itemIDClass' >" + $('#DdUnitFortextbx :selected').text() + "</td>";
                htmls += "<td class='unitDescri acc'>" + $("#DdUnitFortextbx").val() + "</td>";
                htmls += "<td><input type='text' class='sfInputbox Quenity' onkeypress='return IntegerAndDecimal(event,this);' style='width: 100px;background:transparent;' value='" + $('#txtQuentity').val() + "'></td>";
                htmls += "<td><input type='text' class='sfInputbox UnitRate' onkeypress='return IntegerAndDecimal(event,this);' style='width: 100px;background:transparent;' value='" + $('#txtRate').val() + "'></td>";
                htmls += "<td><input type='text' class='sfInputbox Total' onkeypress='return IntegerAndDecimal(event,this);' style='width: 100px;background:transparent;' value='" + $('#txtTotal').val() + "'></td>";
                htmls += "<td class='divDis' style='display: none;'><input type='text' class='sfInputbox discount' onkeypress='return IntegerAndDecimal(event,this);' style='width: 100px;background:transparent;' value='" + Discount + "'></td>";
                htmls += "<td><input type='checkbox' class='chkISVAT' /></td>";
                htmls += "<td class='vat' style='display:none;' >" + vat + "</td>";
                htmls += "<td style='text-align:center;'><img src='/images/delete.png' class='PurchaseDelete'  id='PurchaseDelete_" + number + "' value='Delete'/></td>";
                htmls += "<td class='ddunit' style='display:none;'>" + $('#DdUnitFortextbx :selected').val() + "</td>";
                htmls += "<td class='conversion' style='display:none;'>" + $('#DdUnitFortextbx :selected').attr('attr-conversion') + "</td>";
                htmls += "<td class='Recq' style='display:none;'>" + recq + "</td>";
                htmls += "<td class='RecqId' style='display:none;'>" + recq + "</td>";
                htmls += "</tr>"
                $("#purchaseTempTable tbody").append(htmls);
                eventFunction.CalculateTotal();


                $(".PurchaseEdit").on('click', function () {
                    $("#tblAddItem").dialog({
                        'title': 'Add Items',
                        width: 500,
                        modal: true,
                        dialogClass: 'headingbg',
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                    var data = $(this).attr('id');
                    var splicedata = data.split('_');
                    var table = $("#purchaseTempTable");
                    var rows = table.find("tr.tableItem");
                    var index = parseInt(splicedata[1]);
                    selectedIndex = parseInt(index);
                    numbers = 100;
                    var table = $("#IssueTempTable");
                    var rows = table.find("tr.tableItem");
                    $('#DdlItemid').val($(this).closest('tr').find(".itemID").html());
                    //$('#txtQuentity').val($(this).closest('tr').find(".Quenity").html());
                    $('#txtQuentity').val($(this).closest('tr').find(".Quenity").val());
                    $('#txtRate').val($(this).closest('tr').find(".UnitRate").html());
                    $('#txtRate').val($(this).closest('tr').find(".UnitRate").val());
                    $('#txtLotNNo').val($(this).closest('tr').find(".LotNo").html());
                    $('#txtBatchNo').val($(this).closest('tr').find(".BatchNo").html());
                    $('#txtExpDate').val($(this).closest('tr').find(".ExpDate").html());
                    $('#txtTotal').val($(this).closest('tr').find(".Total").val());


                    var value = ($(this).closest('tr').find(".LotNo").html());
                    if (value != "") {
                        $("#expirable").prop("checked", true);
                        $(".unclick_show").css("display", "block");
                    }

                });
                $(".PurchaseDelete").unbind('click').on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            var splicedata = data.split('_');
                            var index = parseInt(splicedata[1]);
                            TempTotal -= parseFloat(row.find(".Total").val());
                            row.remove();

                            $("#purchaseTempTable>tbody>tr").each(function (index, value) {
                                var qty = $(value).find(".Quenity").val();
                                var total = $(value).find(".Total").val();
                                var result = total / qty;
                                $(value).find('.UnitRate').val(result.toFixed(1));
                                var tot = 0.00;
                                var isvat = $(value).find('.chkISVAT').is(":checked");
                                if (isvat == true) {
                                    var total = $(value).find(".Total").val();
                                    var disc = parseFloat($(value).find('.discount').val());
                                    var tt = total - disc;
                                    tot = tt * 0.13;
                                }
                                else {
                                    tot = 0.00;
                                }
                                $(value).find('.vat').text(tot.toFixed(1));
                            });
                            eventFunction.CalculateTotal();
                        }
                    });

                });


            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>>


            bindVendorBox: function () {
                $("#VendorBox").show();
                $("#VendorBox").html('');
                //vendorlist = JSON.parse(data);
                if (vendorlist.length > 0) {
                    var htmls = "<table id='VendorBoxtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    //htmls += "<tr>"
                    htmls += "<th>Vendor Name </th><th style='width:200px'> Address </th><th> Date Of Issue </th><th> PAN </th><th> IsVAT.</th><th class='delete-heading'>Select</th>";
                    //htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(vendorlist, function (index, value) {
                        var tempvat = value.IsVat;
                        htmls += "<tr class='tableItem' id=+" + value.MembershipID + "+" + value.IsVat + "+" + value.Fname + "+" + value.Lname + "+" + value.PAN + "+" + value.Address + "'>";
                        htmls += "<td>" + value.Fname + " " + value.Lname + "</td>";
                        htmls += "<td style='width:200px'>" + value.Address + "</td>";
                        htmls += "<td>" + value.DateOfIssue + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td>" + value.IsVat + "</td>";
                        htmls += "<td>" + "<img src='/images/completed.png' style='width:20px;height:20px' class='CusSelect' type='button'  id=+" + value.MembershipID + "+" + value.IsVat + "+" + value.Fname + "+" + value.Lname + "+" + value.PAN + "+" + value.Address + " value='Delete'  /></td>";
                        htmls += "</tr>"

                    });
                } else {
                    $('#VendorBox').html('No data');
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#VendorBox').html(htmls);
                $('#VendorBoxtable').dataTable(
                    {
                        "scrollY": false,
                        "scrollCollapse": false,
                        "jQueryUI": true,
                    });

                $("#VendorBox").dialog({
                    'title': 'Vendor List',
                    width: 800,
                    modal: true,
                    resizable: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg'
                });
                //$("#VendorBox").on('click', '.CusSelect', function (event) {
                $("#VendorBox").on('click', '.tableItem', function (event) {
                    if ($("#txtVendorNameID").val() != 0) {
                        $("#purchaseTempTable tbody").html('');
                    }
                    var rows = $(this).closest('tr');
                    var customer = rows.find('td:eq(0)').text();
                    var ids = $(this).attr('id');
                    var word = ids.split("+");
                    var vendorid = word[1];
                    $("#txtVendorName").val(customer);
                    $("#txtVendorName").attr('attr-id', word[1]);
                    $("#txtVendorNameID").val(word[1] + "_" + word[2]);
                    $("#txtVendorName").show();
                    $("#txtVendorName").css('display', "inherit");
                    $("#chkVendorBox").prop("checked", true);
                    $("#VendorBox").hide();
                    $("#VendorBox").dialog("close");

                    eventFunction.config.method = "getPoDetailsFromVendor";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ vendorid: vendorid });
                    eventFunction.config.ajaxCallMode = 17;
                    eventFunction.ajaxCall(eventFunction.config);

                });
            },
            BindDropdwonUnit: function (result) {
                //if (!result.d) return;
                var datas = JSON.parse(result);
                var htmls = "";
                $("#DdUnitFortextbx").html('');
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "' attr-conversion='" + value.Conversion + "'>" + value.Symbol + "</option>";
                    });
                    $(".unit").show();
                }
                $("#DdUnitFortextbx").html(htmls);
                if (datas[0].IsExpirable == 1) {
                    $(".unclick_show").show();
                } else {
                    $(".unclick_show").hide();
                }
            },
            BindPaymentModesAndProviders: function () {
                var result = JSON.parse(Paymode);
                var cardProviders = result.providers;
                var paymentModes = result.paymentModes;

                var vendorSplit = $('#txtVendorNameID').val();
                var splicedata = vendorSplit.split('_');
                var vendorId = splicedata[0] == null ? 0 : splicedata[0];
                var IsVat = splicedata[1] == null ? false : splicedata[1];

                var htmls = '';
                $('#payment').html(htmls);
                htmls += '<div class="unpaidbill_ttl" style="display:flex;justify-content:space-between;"><h4>Total Amount: Rs.' + $('#txttotalAmt').text() + '</h4>';
                htmls += '<h4 id="surplusDeficit" style="text-align:right;">Surplus/Deficit : Rs.<span id="txtsurplus">0</span></h4></div>';
                // htmls += '</div>';
                htmls += '<table id="tblPayment" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';
                $.each(paymentModes, function (index, mode) {
                    htmls += '<tr>';
                    // if (mode.PaymentModeID != 4) {
                    htmls += '<td><input type="checkbox" class="pmntCheck" id="chkBox_' + mode.PaymentModeID + '" ' + (mode.PaymentModeID == 1 ? 'checked' : '') + ' /><label for="chkBox_' + mode.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + mode.PaymentMode + ' : </label></td>';
                    //}
                    htmls += '<td></td>';
                    htmls += '<td>';
                    if (mode.PaymentModeID == 1) {
                        htmls += 'Tender Amount <input type="text" id="txtTenderAmount" class="pmt txtNum sfInputbox" value="' + $('#txttotalAmt').text() + '"  />';
                        htmls += '</td>';
                        htmls += '<td>Return Amount <input type="text" id="txtReturnAmount" class="pmt txtNum sfInputbox" value="0" /></td>';
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" disabled  value="' + $('#txttotalAmt').text() + '"/></td>';
                    } else if (mode.PaymentModeID == 4) {
                        htmls += '<input type="hidden" id="hdfCusID" class="sfInputbox" value="' + vendorId + '" />';
                        htmls += 'Vendor <input type="text" disabled id="txtName" class="sfInputbox" value="' + $("#txtVendorName").val() + '"/>';
                        htmls += '</td>';
                        htmls += '<td>PAN <input type="textbox" disabled id="txtPAN" class="sfInputbox"/></td>';
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" /></td>';

                    } else {
                        htmls += 'Provider<select class="sfInputbox selPaymentMode">';
                        $.each(cardProviders, function (index, provider) {
                            htmls += '<option value="' + provider.ProviderID + '">' + provider.ProviderName + '</option>';
                        });
                        htmls += '</select>';
                        htmls += '</td>';
                        htmls += '<td># <input type="text" class="pmt sfInputbox txtTransaction" placeholder="' + (mode.PaymentModeID == 2 ? 'Cheque No.' : 'Transaction No.') + '" /></td>';
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount"  value="0"/></td>';
                    }
                    htmls += '</tr>';
                });
                htmls += '</table>';
                htmls += '<div class="txtRem">Remarks: <textarea class="sfInputbox txtRemarks"></textarea></div>';
                htmls += '<input type="button" class="sfBtn restro-btn" id="paymentBtn" value="Pay" style="float:right;"/>';
                $('#payment').html(htmls);

                $('#payment').dialog({
                    'title': 'Purchase Bill',
                    width: 650,
                    modal: false,
                    dialogClass: 'unpaidd',
                    position: ['center', 'center'],
                    close: function () {
                        $(this).dialog("destroy");
                    }
                });

                $('#tblPayment').on('keyup keydown', "#txtTenderAmount", function () {
                    var row = $(this).closest('tr');
                    var returnAmnt = (Number($("#txtTenderAmount").val()) - Number($("#txtReturnAmount").val()));
                    var payAmnt = (Number($("#txtTenderAmount").val()) - $("#txtReturnAmount").val());
                    $(row).find('.txtPayAmount').val(payAmnt.toFixed(2));
                    $('.txtPayAmount').change();

                });
                $('#tblPayment').on('keyup keydown', "#txtReturnAmount", function () {
                    var row = $(this).closest('tr');
                    var returnAmnt = Number($("#txtReturnAmount").val()).toFixed(2);
                    var payAmnt = (Number($("#txtTenderAmount").val()) - returnAmnt);
                    $(row).find('.txtPayAmount').val(payAmnt.toFixed(2));
                    $('.txtPayAmount').change();
                });

                $('.txtPayAmount').on('change', function () {
                    totalPayAmnt = 0.00;
                    $('.txtPayAmount').each(function () {
                        if ($(this).closest('tr').find('.pmntCheck').is(':checked')) {
                            totalPayAmnt += parseFloat($(this).val() == "" ? 0 : $(this).val());
                        }
                    })

                    $('#txtsurplus').html((totalPayAmnt - Number($('#txttotalAmt').text())).toFixed(2));
                    if (totalPayAmnt > $('#txttotalAmt').text()) {
                        document.getElementById("surplusDeficit").setAttribute("style", "color:red !important");
                    } else if (totalPayAmnt < $('#txttotalAmt').text()) {
                        document.getElementById("surplusDeficit").setAttribute("style", "color:green !important");
                    } else {
                        document.getElementById("surplusDeficit").setAttribute("style", "color:black !important");
                    }
                });
                $('.pmntCheck').on('change', function () {
                    if ($(this).attr('id').split('_')[1] == "4" && $(this).is(':checked') && parseInt(vendorId) < 1) {
                        $(this).prop('checked', false);
                        eventFunction.BindVendorforpayment(parseInt(vendorId), this);
                    }

                    if (!$(this).is(':checked')) {
                        $(this).closest('tr').find('.txtPayAmount').val(0);
                        $('.txtPayAmount').change();

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

                $('#paymentBtn').unbind('click').on('click', function () {
                    var Stid = $("#ddlStore").val();
                    var MemberInfo = {};
                    if (parseFloat($('#txttotalAmt').text()) > 0) {
                        if ($("#tblPayment input:checkbox:checked").length > 0) {
                            var valid = validPayForm();
                            if (valid == 'true') {
                                if (parseFloat($('#txtsurplus').html()) != 0) {
                                    if (parseFloat($('#txtsurplus').html()) > 250 || parseFloat($('#txtsurplus').html()) < -250) {
                                        jAlert('Surplus/Deficit cannot be more than Rs. 250.', 'Alert!!');
                                        $('#paymentBtn').bind('click');
                                    } else {
                                        jConfirm('There is Surplus/Deficit of Rs.' + parseFloat($('#txtsurplus').html()) + '. Do You want to save the payment?', (parseFloat($('#txtsurplus').html()) > 0 ? 'Surplus : Rs.' + parseFloat($('#txtsurplus').html()) : 'Deficit : Rs.' + parseFloat($('#txtsurplus').html())), function (confirmed) {
                                            if (confirmed) {
                                                //  SavePayment(salesMasterid, billInfo.TotalAmount);
                                                eventFunction.SavePurchase(true, Stid, MemberInfo);
                                            } else {
                                                $('#paymentBtn').bind('click');
                                            }
                                        });
                                    }
                                } else {
                                    jConfirm('Do You want to confirm the payment?', 'Payment Confirmation!!', function (confirmed) {
                                        if (confirmed) {
                                            // SavePayment(salesMasterid, billInfo.TotalAmount);
                                            eventFunction.SavePurchase(true, Stid, MemberInfo);
                                        }
                                    });
                                }
                            } else {
                                if (valid == 'payamount') {
                                    jAlert('PayAmount must be greater than 0 for checked payment mode.', 'Alert!!');
                                } else {
                                    jAlert('Transactions No is mandatory for checked payment mode.', 'Alert!!');
                                }
                                $('#paymentBtn').bind('click');
                            }
                        } else {
                            jAlert('Select Atleast One Payment Mode.', 'Alert!!');
                            $('#paymentBtn').bind('click');
                        }
                    } else {
                    }
                });


            },

            BindVendorforpayment: function (vendorId, pmntMode) {
                $("#VendorBox").show();
                $("#VendorBox").html('');
                if (vendorlist.length > 0) {
                    var htmls = "<table id='VendorBoxtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    //htmls += "<tr>"
                    htmls += "<th>Vendor Name </th><th style='width:200px'> Address </th><th> Date Of Issue </th><th> PAN </th><th> IsVAT.</th><th class='delete-heading'>Select</th>";
                    //htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    $.each(vendorlist, function (index, value) {
                        var tempvat = value.IsVat;
                        htmls += "<tr class='VendortableItem' id=+" + value.MembershipID + "+" + value.PAN + "+" + value.Fname + "'>";
                        htmls += "<td>" + value.Fname + " " + value.Lname + "</td>";
                        htmls += "<td style='width:200px'>" + value.Address + "</td>";
                        htmls += "<td>" + value.DateOfIssue + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td>" + value.IsVat + "</td>";
                        htmls += "<td>" + "<img src='/images/completed.png' style='width:20px;height:20px' class='CusSelect' type='button'  id=+" + value.MembershipID + "+" + value.IsVat + "+" + value.Fname + "+" + value.Lname + "+" + value.PAN + "+" + value.Address + " value='Delete'  /></td>";
                        htmls += "</tr>"

                    });
                } else {
                    $('#VendorBox').html('No data');
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#VendorBox').html(htmls);
                $('#VendorBoxtable').dataTable(
                    {
                        "scrollY": false,
                        "scrollCollapse": false,
                        "jQueryUI": true,
                    });

                $("#VendorBox").dialog({
                    'title': 'Vendor List',
                    width: 800,
                    modal: true,
                    resizable: true,
                    position: ['center', 'top'],
                    dialogClass: 'popup-titlebg'
                });

                $("#VendorBox").on('click', '.VendortableItem', function (event) {
                    var rows = $(this).closest('tr');
                    var customer = rows.find('td:eq(0)').text();
                    $("#txtVendorName").val(customer);
                    $("#txtName").val(customer);

                    var ids = $(this).attr('id');
                    var word = ids.split("+");
                    $("#hdfCusID").val(word[1]);
                    $("#txtPAN").val(word[2]);
                    $("#txtVendorName").show();
                    $("#VendorBox").hide();
                    $("#VendorBox").dialog("close");
                    $("#txtVendorNameID").val(word[1] + "_" + word[2]);
                    $("#chkVendorBox").prop("checked", true);
                    $(pmntMode).prop('checked', true);
                });



            },

            validPayForm: function () {
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
            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $('#txtID').val(0);
                $('#DdlItemid').val('');
                $('#textUnit').val('');
                $('#DdlItemid').html('');
                $('#DdUnit').html('');
                $('#txtQuentity').val('');
                $('#txtQuentityText').val('');
                $('#txtRate').val('');
                $('#txtLotNNo').val('');
                $('#txtBatchNo').val('');
                $('#txtExpDate').val('');
                $('#txtTotal').val('');
                $('#txtIvNo').val('');
                $('#txtRemarks').val('');
                $(".unit").hide();
                $("#btnAdd").show();
                $("#txtVendorName").val('');
                $('#txtVendorNameID').val('0');
                $("#txtVendorName").css('display', "inherit");
                $("#checkStore").hide();
                $("#divForPurchaseList").show();
                $("#divForForm").hide();
                $("#purchaseTempTable tbody").html('');
                $("#txtPurchaseTempTotal").text('');
                $(".Total").val('');
                $('#txtPuno').val('');
                $("#chkVendorBox").prop("checked", false);
                $("#chkISVAT").prop("checked", false);
                $("#CheckBoxGoodReceived").prop("checked", false);
                TempTotal = 0;
                IsVat = false;
                TotalAmount = 0;
                VAT = 0;
                VatItemTotal = 0;
                NonVatItemTotal = 0;
                TotalDiscount = 0;
                ExtraDiscount = 0;
                TaxAmount = 0;
                $("#ddlStore").val('');

                $('.report-filter').show();
                $("#tblCheckGoods").show();
                $("#txtVendorName").hide();
                $('#txtvatAmt').text('0');
                $('#txtnonAmt').text('0');
                $('#totaldiscount').val('0');
                $('#txtdiscount').val('0');
                $('#txttaxAmt').text('0');
                $('#txttotalAmt').text('0');
                $(".chkISVAT").prop("checked", false);

                eventFunction.getPurchaseList();
                eventFunction.GetAutoNumber();
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        textUnit: {
                            required: false,
                        }
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