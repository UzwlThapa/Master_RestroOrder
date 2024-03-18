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

(function ($) {
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
        var numbers = 0;
        var selectedIndex = 0;
        var number = 0;
        var result;
        var PurchaseArray = [];
        var ArrayData = [];
        var arraycount = 0;
        var AutoPoNoo = [];
        var receivedlist = [];      
        var Amount = 0;
        var VAT = 0;
        var VATAmount = 0;       
        var Discount = 0;
        var IsVat = 0;
        var VatItemTotal = 0;
        var NonVatItemTotal = 0;
        var TotalDiscount = 0;
        var ExtraDiscount = 0;
        var TaxAmount = 0;
        var TotalAmount = 0;
        var Paymode = [];
        var vendorlist = [];
        var Autonumberitem = new Array();
        //var PurchaseObjectDetails = new Array();
        //var PurchaseObjectDetailsLot = new Array();
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
                Unit2IDUpdate: 0
            },
            InitialSetup: function () {
            },
            init: function () {
                eventFunction.getVender();
                eventFunction.GetStore();
                eventFunction.GetPurchaseDetials();
                eventFunction.ReceivedList();
                eventFunction.GetPaymentModesAndProviders();
                $("#AddTempTable").hide();
                $("#btnPurchaseSave").hide();
                $("#btnPurchaseCancel").hide();
                $("#lblid").hide();
                $("#lblItemID").hide();

                $('#txtSearch').on('keyup', function () {
                    eventFunction.bindGoodsReceivedList();
                });

                $("#txtStartDate").datepicker({ changeMonth: true, changeYear: true });
                $("#txtEndDate").datepicker({ changeMonth: true, changeYear: true });

                $("#ddlStore").on('change', function () {
                    var value = $('#ddlStore').val();
                    $(".Store").val(value);
                })
                $("#txtPoNO").autocomplete({

                    source: AutoPoNoo,

                    focus: function (event, ui) {
                        // prevent autocomplete from updating the textbox
                        event.preventDefault();
                        // manually update the textbox
                        $(this).val(ui.item.label);
                    },
                    select: function (event, ui) {
                        // prevent autocomplete from updating the textbox
                        event.preventDefault();
                        // manually update the textbox and hidden field
                        var PoNO = ui.item.label;
                        eventFunction.config.method = "getGoodsReceive";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ PoNO: PoNO });
                        eventFunction.config.ajaxCallMode = 5;
                        eventFunction.ajaxCall(eventFunction.config);

                    }



                });

                $("#txtItem").autocomplete({
                    source: Autonumberitem,
                    delay: 0,
                    change: function () {
                        var name = $("#txtItem").val();
                        eventFunction.config.method = "getitemidbyname";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ itemname: name });
                        eventFunction.config.ajaxCallMode = 4;
                        eventFunction.ajaxCall(eventFunction.config);
                    },
                });

                $("#btnView").on("click", function () {
                    eventFunction.GoodReceiveReport();
                })

                $("#chkISVAT").change(function () {
                    if ($(this).is(":checked")) {
                        $('.vatValue').show();
                    }
                    else
                        $(".vatValue").hide();
                });


                $("#btnPurchaseAdd").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        if (numbers != 100) {
                            eventFunction.AddPurchase();
                            eventFunction.ResetAll();
                            numbers = 0
                        }
                        else {
                            var MyRows = $("#AddTempTable tbody").find("tr");
                            //for (var i = 0; i < MyRows.length; i++) {
                            $(MyRows[selectedIndex]).find('td:eq(0)').html($("#txtItem").val());
                            $(MyRows[selectedIndex]).find('td:eq(1)').html($("#ddlItem").val());
                            $(MyRows[selectedIndex]).find('td:eq(2)').html($("#txtQts").val());
                            selectedIndex = 0;
                            numbers = 0;

                        }
                    }
                    $('#txtItem').val('');
                    //$('#DdUnit').html('');
                    $('#txtQts').val('');
                    $('#lblid').text('');


                });


                $("#btnPurchaseCancel").on('click', function () {
                    eventFunction.ResetAll();
                    $("#btnPurchaseSave").hide();
                    $("#btnPurchaseCancel").hide();
                    $('.report-filter').show();
                    $("#divForViewList").show();
                });

                $("#btnPurchaseSave").on('click', function () {
                    var errCnt = 0;
                    $('#goodsRecevetable>tbody>tr').each(function (index, row) {
                        debugger;
                        var qnty = parseFloat($(this).find('.txtQnty').val());
                        if (!isNaN(qnty) && qnty > 0) {
                            var rate = parseFloat($(this).find('.txtRate').val());
                            if (isNaN(rate) || !rate > 0) {
                                errCnt += 1;
                            } else if ($(this).find('.Store').val() == "" || $(this).find('.Store').val() == null) {
                                errCnt += 1;
                            }
                        }
                    });
                    if (errCnt > 0) {
                        jAlert("Please! If Quantity is Greater than 0 then Rate must be greater than 0 and Store must be selected.", 'Alert!!');
                    }
                    else if ($('#txtInvoiceno').val() == "" || $('#txtInvoiceno').val() == null) {
                        jAlert("Please! Enter Invoice Number.", 'Alert!!');
                    }

                    else {
                        var MembershipID = parseInt($("#hdfVendorId").val() == "" ? 0 : $("#hdfVendorId").val());
                        eventFunction.BindPaymentModesAndProviders();

                        if ($("#hdfVendorId").val() != 0) {
                            eventFunction.config.method = "GetCusOnChange";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON.stringify({ MembershipID: MembershipID });
                            eventFunction.config.ajaxCallMode = 16;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                           
                      
                        
                        //$('#rdoPayOptionCash').prop('checked', true);
                        //$('#rdoPayOptionCredit').show();
                        //$('#lblPayOptionCredit').show();
                        //if (parseInt($('#hdfVendorId').val()) == 0) {
                        //    $('#rdoPayOptionCredit').hide();
                        //    $('#lblPayOptionCredit').hide();
                        //}
                        //$("#payOption").dialog({
                        //    'title': 'Choose Pay Option',
                        //    width: 300,
                        //    modal: true,
                        //    dialogClass: 'headingbg',
                        //    resizable: true,
                        //    dialogClass: 'popup-titlebg'
                        //});
                        //$("#btnPayOption").unbind('click').on("click", function () {
                        //    option = $('input[name="PayOption"]:checked').val();

                        //    $("#payOption").dialog("close");

                        //    if (option == 4) {
                        //        var MembershipID = $("#hdfVendorId").val();
                        //        eventFunction.config.method = "GetCusOnChange";
                        //        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        //        eventFunction.config.data = JSON.stringify({ MembershipID: MembershipID });
                        //        eventFunction.config.ajaxCallMode = 13;
                        //        eventFunction.ajaxCall(eventFunction.config);

                        //        $("#membeshipformlist").dialog('open');
                        //        $("#membeshipformlist2").dialog({
                        //            'title': 'Vendor Balance',
                        //            width: 800,
                        //            modal: true,
                        //            resizable: true,
                        //            dialogClass: 'popup-titlebg',
                        //        });
                        //    } else {
                        //        var MemberInfo = {};
                        //        eventFunction.SaveGoodsReceive(MemberInfo);
                        //        eventFunction.ReceivedList();
                        //    }
                        //});

                    }
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
                        $('#txtGmNo').val(data.d);
                        break;
                    case 1:
                        jAlert('Successfully Inserted!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        //  window.open('/Modules/ROIGoodsReceive/Goods-Recieved.aspx?ID=' + eval(data.d), '_blank');
                        var gmid = eval(data.d);                       
                        eventFunction.GetPurchaseDetailsbygmID(parseInt(gmid));
                        $('#GoodsViewReport').dialog({
                            'title': 'Purchase order',
                            width: '600',
                            height: 'auto',
                            modal: true,
                            position: ['center', 'top']
                        });
                        eventFunction.ResetAll();
                        $('#payment').dialog("close");
                        $("#btnPurchaseSave").hide();
                        $("#btnPurchaseCancel").hide();
                        $('.report-filter').show();
                        $("#divForViewList").show();
                        eventFunction.GetPurchaseDetials();
                        break;
                    case 2:
                        result = data.d;
                        $(".Store").html('');
                        $(".Store").html(eventFunction.BindStore(data.d));
                        break;
                    case 3:
                        eventFunction.BindPurchaseDetails(data);
                        break;
                    case 4:
                        eventFunction.BindItemID(data);
                        break;
                    case 5:
                        eventFunction.BndGoodReveive(data.d);
                        $('#divForViewList').hide();
                        $('.report-filter').hide();

                        break;
                    case 6:
                        eventFunction.BindGoodReceiveReport(data);
                        break;
                    case 7:
                        receivedlist = JSON.parse(data.d);
                        eventFunction.bindGoodsReceivedList();
                        break;
                    case 8:
                        eventFunction.BindGoodReveived(data.d);
                        break;
                    case 13:
                        eventFunction.Bindmember(data.d);
                        break;
                    case 14:
                        eventFunction.BindGoodsDetailsReport(data.d);
                        break;
                    case 15:
                        Paymode = data.d;
                        break;
                    case 16:
                        eventFunction.BindVendor(data.d);
                        break;
                    case 17:
                        vendorlist = JSON.parse(data.d);
                        break;
                }
            },
            ajaxFailure: function (e) {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 1:
                        jAlert(JSON2.parse(e.responseText).Message, 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("#goodsRecevetable").hide();
                        $("#btnPurchaseSave").hide();
                        $("#btnPurchaseCancel").hide();
                        $('#payment').dialog("close");
                        eventFunction.ResetAll();
                        break;


                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            getVender: function () {
                eventFunction.config.method = "getVender";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 17;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPaymentModesAndProviders: function () {
                var loggername = SageFrameUserName;
                eventFunction.config.method = "GetPaymentModesAndProvider";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 15;
                eventFunction.ajaxCall(eventFunction.config);
            },
            ReceivedList: function () {
                eventFunction.config.method = "GetGoodReceivedPO";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPurchaseDetailsbygmID: function (gmID) {
                eventFunction.config.method = "GetGoodsDetailsbygmID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    gmID: gmID
                });
                eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindGoodsDetailsReport: function (data) {
                $("#GoodsViewReport").show();
                $("#GoodsViewReport").html();
                var datas = JSON.parse(data);
                var companyInfo = datas.companyInfo;
                var purchaseMain = datas.goodsMain;
                var htmls = '';
                var date = purchaseMain[0] ? purchaseMain[0].InvoiceDate.split("T") : '';
                htmls += '<button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right:2px;">Print</button>';

                htmls += '<div id="ViewReport" style="margin-top:10px;">';
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
                htmls += "<th style='font-size:12px;padding-bottom:5px;border-right:1px solid;border-bottom:1px solid;width:5%;'>SN</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:45%;'>ItemName</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Quantity</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:10%;'>Rate</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:20%;'>Total</th><th style='font-size:12px;padding-bottom:5px;border-bottom:1px solid;width:10%;'>Dist</th>";
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
                    htmls += "<td style='font-size:11px;padding-bottom:5px;border-right:1px solid;width:20%;'>" + value.Total + "</td>";
                    htmls += "<td style='font-size:11px;padding-bottom:5px;width:10%;'>" + value.Discount + "</td>";
                   // htmls += "<td style='padding-bottom:5px;text-align:right;width:5%;'>" + (value.IsVat ? 'T' : 'N') + "</td>";

                    if (value.IsVat == true)
                    {
                        VatItemTotal += parseFloat(value.Total);
                        VAT = VatItemTotal - parseFloat(value.Discount);
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
                $('#GoodsViewReport').html(htmls);

                $("#btnPrints").click(function () {
                    print();
                });

            },
            bindGoodsReceivedList: function () {
                $("#divForViewList").show();
                goodreceivedlist = receivedlist;
                var i = 0;
                if (!goodreceivedlist) return;
                var htmls = "";
                htmls += "<table id='tableForViewList' class='reportsprint' cellspacing='0'><thead><tr><th>S.N.</th><th>GoodReceive Number</th><th>Purchase Number</th><th>InvoiceNo</th><th class='view-heading tdcenter'>View</th><th class='view-heading tdcenter'>View Bill</th></tr></thead><tbody>";
                $.each(goodreceivedlist, function (index, value) {
                    var search = $('#txtSearch').val().toLowerCase();
                    if (value.GMNo.toLowerCase().includes(search) || value.PuNo.toLowerCase().includes(search) || value.InvoiceNo.toLowerCase().includes(search) || search == '') {
                        i++;
                        htmls += "<tr class='tableItem'><td>" + i + ".</td><td>" + value.GMNo + "</td>";
                        htmls += "<td>" + value.PuNo + "</td>";
                        htmls += "<td>" + value.InvoiceNo + "</td>";
                        htmls += "<td class='tdcenter'><img src='/images/view.png' class='PurchaseView preview-icon' type='button'  id=" + value.PuNo + " value='View'  /></td>";
                        htmls += "<td class='tdcenter'><img src='/images/view.png' class='PurchaseBillView preview-icon' type='button'  id=" + value.GMId + " value='View'  /></td>";
                        htmls += "</tr>";
                    }
                });
                htmls += "</tbody></table>";
                $("#divForViewList").html(htmls);
                //$("#tableForViewList").DataTable({
                //    "jQueryUI": true,

                //});



                $("#tableForViewList").on('click', '.PurchaseView', function () {
                    var PoNO = $(this).attr('id');
                    eventFunction.config.method = "getGoodsReceive";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ PoNO: PoNO });
                    eventFunction.config.ajaxCallMode = 8;
                    eventFunction.ajaxCall(eventFunction.config);

                });

                $("#tableForViewList").on('click', '.PurchaseBillView', function () {
                    var gmID = $(this).attr('id');
                    eventFunction.GetPurchaseDetailsbygmID(gmID);
                    $('#GoodsViewReport').dialog({
                        'title': 'Purchase order',
                        width: '400',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top']
                    });

                });
            },

            GoodReceiveReport: function () {

                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtEndDate").val();
                eventFunction.config.method = "GetGoodReceiveReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ StartDate: StartDate, EndDate: EndDate })
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindGoodReceiveReport: function (data) {
                $("#GoodReceiveReportDisplay").show();
                $("#GoodReceiveReportDisplay").html('');
                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='ReportTable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Item Name</th><th>Quantity  </th> <th>Total </th>"
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {


                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";


                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Quentity + "</td>";

                        // htmls += "<td>" + value.PbDate + "</td>";
                        htmls += "<td>" + value.Total + "</td>";

                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());


                    });
                } else {
                    $('#reportDisplay').html('No data');

                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#GoodReceiveReportDisplay').html(htmls);
                //$('#ReportTable').DataTable(
                //     {
                //         dom: 'Bfrtip',
                //         buttons: [
                //             'copy', 'csv', 'excel', 'pdf', 'print'
                //         ]

                //     });




            },

            DeleteGoods: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var GMId = id;
                eventFunction.config.method = "GoodsDelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ GMId: GMId });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetStore: function () {
                eventFunction.config.method = "getIssueToDDl";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetPurchaseDetials: function () {
                eventFunction.config.method = "getPurchaseDetails";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            AddPurchase: function () {
                var table = $("#purchaseTempTable");
                var rows = table.find("tr.tableItem")
                for (var i = 0; i < rows.length; i++) {
                    var item = $(rows[i]);
                    PurchaseArray.push({
                        "PDId": parseInt(item.find(".itemname").text()),
                        //"ItemID": parseInt(item.find(".itemname").text()),
                        "Qnty": item.find(".Quenity").text(),

                    })
                };

                var htmls = '';
                $("#AddTempTable").show();
                htmls += "<tr class='tableItem'>";
                //var vasl = $("#DdlItemid option:selected").text();
                htmls += "<td class='ItemName' style='text-align:left'>" + $('#txtItem').val() + "</td>";
                htmls += "<td class='ItemId' style='display:none;'>" + $('#lblid').text() + "</td>";
                htmls += "<td class='Quenity'>" + $('#txtQts').val() + "</td>";
                htmls += "<td class='Itemiforbal' style='display:none;'>" + $('#lblItemID').text() + "</td>";
                var val = $('#expirable').is(':checked');
                htmls += "<td class='Expireable'>" + val + "</td>";
                htmls += "<td>" + "<img src='/images/edit.png' type='button' class='PurchaseEdit BrandEdit'  id='PurchaseEdit_" + number + "' value='Edit'/>" + "</td>";
                htmls += "<td>" + "<img src='/images/delete.png' type='button' class='PurchaseDelete BrandDelete'  id='PurchaseDelete_" + number + "' value='Delete'/>" + "</td>";
                htmls += "</tr>"
                number += 1;
                $("#purchaseTempTable tbody").append(htmls);
                $(".PurchaseEdit").on('click', function () {
                    var data = $(this).attr('id');
                    var splicedata = data.split('_');

                    var index = parseInt(splicedata[1]);
                    selectedIndex = index;
                    numbers = 100;

                    var table = $("#purchaseTempTable");
                    var rows = table.find("tr.tableItem")

                    $('#txtItem').val($(this).closest('tr').find(".ItemName").html());
                    $('#lblid').val($(this).closest('tr').find(".ItemId").html());
                    $('#txtQts').val($(this).closest('tr').find(".Quenity").html());


                    //var table = $("#purchaseTempTable");
                    //var rows = table.find("tr.tableItem")

                    //for (var i = 0; i < rows.length; i++) {
                    //    var item = $(rows[i]);

                    //    $('#ddlItem').val(item.find(".ItemId").text());
                    //    $('#txtQts').val(item.find(".Quenity").text());
                    //};

                });
                $(".PurchaseDelete").on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            var splicedata = data.split('_');
                            var index = parseInt(splicedata[1]);
                            row.remove();
                        }
                    });

                });
            },

            SaveGoodsReceive: function (MemberInfo) {
                var SuperMainlist = new Array();
                var PurchaseObjectDetails = new Array();
                var PurchaseObjItemBal = new Array();
                var RecquistionObjectDetails = new Array();
                var GoodReived = new Object();

                var MyRows = $('#goodsReceiveList > table#goodsRecevetable').find('tbody').find('tr');
                for (var i = 0; i < MyRows.length; i++) {
                    var PurchaseObjItemBalObj = new Object();
                    PurchaseObjItemBalObj.ITId = parseInt($(MyRows[i]).find('td:eq(1)').html());
                    PurchaseObjItemBalObj.PDId = parseFloat($(MyRows[i]).find('td:eq(2)').html());
                    PurchaseObjItemBalObj.STId = parseFloat($(MyRows[i]).find(".Store").val());
                    PurchaseObjItemBalObj.CLBal = 0;//parseFloat($(MyRows[i]).find(".txtQnty").val()) * parseFloat($(MyRows[i]).find('.conversion').text());

                    PurchaseObjItemBalObj.Qnty = parseFloat($(MyRows[i]).find(".txtQnty").val());
                    PurchaseObjItemBalObj.Rate = parseFloat($(MyRows[i]).find(".txtRate").val());
                    PurchaseObjItemBalObj.Total = parseFloat($(MyRows[i]).find(".amount").val());
                    PurchaseObjItemBalObj.Discount = parseFloat($(MyRows[i]).find(".discount").val());
                    PurchaseObjItemBalObj.IsVat = $(MyRows[i]).find('.chkISVAT').is(":checked");
                    PurchaseObjItemBalObj.OPBal = 0;
                    PurchaseObjItemBal.push(PurchaseObjItemBalObj);
                }

                for (var i = 0; i < MyRows.length; i++) {
                    var PurchaseObjectRecq = new Object();
                    PurchaseObjectRecq.RecqDetailId = parseFloat($(MyRows[i]).find(".Recq").text());
                    PurchaseObjectRecq.RecqId = parseFloat($(MyRows[i]).find(".RecqId").text());
                    PurchaseObjectRecq.IssueQuantity = parseFloat($(MyRows[i]).find(".txtQnty").val());
                    RecquistionObjectDetails.push(PurchaseObjectRecq);
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
                superss.PurchaseObjItemBal = PurchaseObjItemBal;
                superss.RecquistionObjectDetails = RecquistionObjectDetails;

                superss.GMNo = $('#txtGmNo').val();
                superss.vendorId = $('#hdfVendorId').val();
                superss.paymentMode = $('input[name="PayOption"]:checked').val();
                superss.STId = $('#ddlStore').val() == null ? 0 : $('#ddlStore').val();
                superss.PostedBy = p.Username;
                superss.InvoiceNo = $('#txtInvoiceno').val();
                superss.InvoiceDate = $('#txtDate').val();
                superss.ExtraDiscount = 0;//$("#txtdiscount").val() == "" ? 0 : $("#txtdiscount").val();
                debugger;
                var jsonText = JSON2.stringify({ GoodReived: superss, memberInfo: MemberInfo, purchasePayment: PurchasePaymentList })
                //var jsonText = JSON2.stringify({ memberInfo: MemberInfo });
                eventFunction.config.method = "GoodsReceivedss";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },



            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            BindGoodReveived: function (data) {
                $("#divForView").html('');

                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<div class='dataTables_wrapper no-footer'><table id='goodsRecevetable' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th style='display:none;'>ItemID</th><th style='display:none;'>PDID </th><th>Item Name</th> <th>Purchase Qty</th><th>Remaining Qty</th>";
                    //   htmls += "<th>Action</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.GMId + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td style='display:none;'>" + value.ItemID + "</td>";
                        htmls += "<td style='display:none;'>" + value.PurchaseDetailsID + "</td>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Quentity + " " + value.Symbol + "</td>";
                        htmls += "<td>" + value.RemainingQnty + " " + value.Symbol + "</td>";

                        htmls += "</tr>"
                        count++;
                    });
                } else {
                    $('#divForView').html('No data');
                }

                htmls += "</tbody>";
                htmls += "</table></div>";
                $('#divForView').html(htmls);
                $("#divForView").dialog({
                    'title': 'Purchase No: ' + datas[0].PuNo,
                    'width': 700,
                    modal: true,
                    dialogClass: 'popup-titlebg',
                    "jQueryUI": true
                });



            },

            BndGoodReveive: function (data) {
                $("#goodsReceiveList").show();
                $("#goodsReceiveList").html('');
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    $("#hdfIsVat").val(datas[0].IsVat);
                    $("#hdfVendorId").val(datas[0].vendorId);
                    var htmls = "<table id='goodsRecevetable' class='reportsprint' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th style='display:none;'>ItemID</th><th style='display:none;'>PDID </th><th>Item Name</th> <th>Purchase Qty</th><th>Remaning Qty</th><th style='width:200px;'>Store</th><th style='width:120px;'>Qty</th><th style='width:130px;'>Rate</th><th style='width:130px;'>Total</th><th>Discount</th><th>IsVAT</th><th style='display:none;'></th>";
                    //htmls += "<th>SN</th><th style='display:none;'>ItemID</th><th style='display:none;'>PDID </th><th>Item Name</th> <th>Purchase Qty</th><th>Remaning Qty</th><th style='width:200px;'>Store</th><th style='width:120px;'>Qty</th><th style='width:130px;'>Rate</th><th style='width:130px;'>Total</th><th>Discount</th>";
                    //   htmls += "<th>Action</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    var tempTotal = 0.00;
                    var taxAmt = 0.00;
                    var totaldiscount = 0.00;
                    var discount = 0.00;
                    var tot = 0.00;
                    var nonamount = 0.00;
                    var vatamount = 0.00;
                    var totalAmt = 0.00;
                    $.each(datas, function (index, value) {
                        var qnty = value.RemainingQnty;
                        if (qnty > 0) {
                            $("#txtInvoiceno").val(value.InvoiceNo);
                            var amt = (value.Total);
                            totalAmt += amt - value.Discount;
                            if (value.IsVat) {
                                vatamount += amt
                            } else {

                                nonamount += amt;
                            }
                            htmls += "<tr class='tableItem' id=" + value.GMId + "_>";
                            htmls += "<td>" + count + "</td>";
                            htmls += "<td style='display:none;'>" + value.ItemID + "</td>";
                            htmls += "<td style='display:none;'>" + value.PurchaseDetailsID + "</td>";
                            htmls += "<td>" + value.ITName + "</td>";
                            htmls += "<td>" + value.Quentity + " " + value.Symbol + "</td>";
                            htmls += "<td>" + value.RemainingQnty + " " + value.Symbol + "</td>";
                            htmls += "<td>" + "<select class='Store sfInputbox required' name='store' style='width:200px;'>" + eventFunction.BindStore() + " </select>" + "</td>";
                            htmls += "<td>" + "<input type='text' style='width:100px;' class='sfInputbox qty required txtQnty' onkeypress='return IntegerAndDecimal(event,this);' max='" + value.RemainingQnty + "' value='" + value.RemainingQnty + "' name='Qty'/>" + "</td>";
                            htmls += "<td>" + "<input type='text' style='width:100px;' class='sfInputbox rate required txtRate' onkeypress='return IntegerAndDecimal(event,this);'  name='Rate' value='" + value.UnitRate + "'/>" + "</td>";

                            htmls += "<td>" + "<input type='text' style='width:100px;' class='sfInputbox amt required amount' onkeypress='return IntegerAndDecimal(event,this);' name='amount' value='" + amt + "'/>" + "</td>";

                            htmls += "<td>" + "<input type='text' disabled style='width:100px;'class='sfInputbox discount' onkeypress='return IntegerAndDecimal(event,this);' value='" + value.Discount + "'/>" + "</td>";
                            if (value.IsVat) {

                                htmls += "<td>" + "<input type='checkbox' checked disabled class='chkISVAT' />" + "</td>";
                            } else {
                                htmls += "<td>" + "<input type='checkbox' disabled class='chkISVAT' />" + "</td>";
                            }
                            htmls += "<td class='vat' style='display:none;'>" + tot + " </td>";
                            htmls += "<td class='amount' style='display:none;'>" + amt + "</td>";
                            htmls += "<td class='conversion'style='display:none;'>" + value.Conversion + "</td>";
                            htmls += "<td class='Recq' style='display:none;'>" + value.RecqDetailId + "</td>";
                            htmls += "<td class='RecqId' style='display:none;'>" + value.RecqId + "</td>";
                            htmls += "</tr>"
                            count++;
                            totaldiscount += value.Discount;
                            if (value.IsVat) {
                                taxAmt += (value.Total - value.Discount) * 0.13;
                            }
                        }
                    });
                    totalAmt = totalAmt + taxAmt;
                    htmls += "</tbody>";
                    htmls += "</table>";
                    htmls += "<table id='goodsRecevetablefoot'>";
                    htmls += '<tr class="discountValue"><td style="text-align:right;">VAT Item Total: </td><td class="vatamount" style="text-align:right;">Rs. <label id="txtvatAmt">' + vatamount.toFixed(2) + '</label></td></tr>';
                    htmls += '<tr class="discountValue"><td style="text-align:right;">Non-VAT Total : </td><td class="nonamount" style="text-align:right;">Rs. <label id="txtnonAmt">' + nonamount.toFixed(2) + '</label></td></tr>';
                    htmls += '<tr class="discountValue"><td style="text-align:right;">Non-VAT Total : </td><td class="nonamount" style="text-align:right;">Rs. <label id="txtBasicAmt">' + (nonamount + vatamount).toFixed(2) + '</label></td></tr>';
                    htmls += '<tr class="discountValue"><td style="text-align:right;width:90%;">Total Discount : </td><td style="text-align:right;">Rs. <label id="totaldiscount">' + totaldiscount.toFixed(2) + '</label></td></tr>';
                    htmls += '<tr class="discountValue"  style="display: none;"><td style="text-align:right;">Extra Discount: </td><td><input type="textbox" class="sfInputbox txtdiscount" id="txtdiscount" onkeypress="return IntegerAndDecimal(event,this);" value="0" style="width:80px;text-align:right; float:right;"/></td></tr>';
                    htmls += '<tr class="discountValue"><td style="text-align:right;">Tax Amount : </td><td class="taxamount" style="text-align:right;">Rs. <label id="txttaxAmt">' + taxAmt.toFixed(2) + '</label></td></tr>';
                    htmls += '<tr class="discountValue"><td style="text-align:right;">Total Amount : </td><td class="totalamount" style="text-align:right;">Rs. <label id="txttotalAmt">' + totalAmt.toFixed(2) + '</label></td></tr>';
                    htmls += "</table>";

                    $('#goodsReceiveList').html(htmls);
                    $("#btnPurchaseSave").show();
                    $("#btnPurchaseCancel").show();

                } else {
                    $('#goodsReceiveList').html('No data');
                }

                $('#goodsRecevetable').on('change', 'input[type=checkbox]', function () {
                    $("#goodsRecevetable>tbody>tr").each(function (index, value) {

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = parseFloat($(value).find('.amount').val());
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



                $('#goodsRecevetable').on('keyup', '.discount', function () {
                    $("#goodsRecevetable>tbody>tr").each(function (index, value) {

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = parseFloat($(value).find('.amount').val());
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

                $('#goodsRecevetable').on('keyup', '.txtQnty', function () {

                    if (parseFloat($(this).val()) > parseFloat($(this).attr('max'))) {
                        jAlert('Received Quantity cannot be greater than Ordered Quantity.', 'Information!!', function () { $.alerts.dialogClass = null; });

                        $(this).val(parseFloat($(this).attr('max')));
                    }
                    $("#goodsRecevetable>tbody>tr").each(function (index, value) {
                        var qty = parseFloat($(value).find('.txtQnty').val());
                        if (isNaN(qty)) {
                            qty = 0;
                        }
                        var rate = parseFloat($(value).find('.txtRate').val());
                        if (isNaN(rate)) {
                            rate = 0;
                        }
                        var result = rate * qty;
                        if (isNaN(result)) {
                            result = 0;
                        }
                        $(value).find('.amount').val(result.toFixed(1));

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = parseFloat($(value).find('.amount').val());
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
                $('#goodsRecevetable').on('keyup', '.txtRate', function () {
                    $("#goodsRecevetable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find('.txtQnty').val();
                        if (isNaN(qty)) {
                            qty = 0;
                        }
                        var rate = parseFloat($(value).find('.txtRate').val());
                        if (isNaN(rate)) {
                            rate = 0;
                        }
                        var result = rate * qty;
                        if (isNaN(result)) {
                            result = 0;
                        }
                        $(value).find('.amount').val(result.toFixed(1));

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = parseFloat($(value).find('.amount').val());
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

                $('#goodsRecevetablefoot').on('keyup', '.txtdiscount', function () {

                    eventFunction.CalculateTotal();
                });

                $('#goodsRecevetable').on('keyup', '.amount', function () {

                    $("#goodsRecevetable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find('.txtQnty').val();
                        if (isNaN(qty)) {
                            qty = 0;
                        }
                        var total = $(value).find('.amount').val();
                        if (isNaN(total)) {
                            total = 0;
                        }
                        var result = (total / qty).toFixed(2);
                        if (isNaN(result)) {
                            result = 0;
                        }
                        $(value).find('.txtRate').val(result);

                        var tot = 0.00;
                        var isvat = $(value).find('.chkISVAT').is(":checked");
                        if (isvat == true) {
                            var total = parseFloat($(value).find('.amount').val());
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


                $(".UnitDelete").on('click', function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.DeleteGoods(item);
                            eventFunction.ResetAll();
                        }
                    });
                    return false;
                });

            },

            CalculateTotal: function () {


                var tempTotal = 0.00;
                var totaldiscount = 0.00;
                var temp = 0.00;
                var allChecked = true;
                var nonamount = 0.00;
                var vatamount = 0.00;

                $('.discount').each(function () {
                    var dist = parseFloat($(this).val())
                    totaldiscount += (isNaN(dist) ? 0 : dist)
                });
                $('#totaldiscount').text((totaldiscount).toFixed(2));

                var MyRows = $('#goodsReceiveList > table#goodsRecevetable').find('tbody').find('tr');
                for (var i = 0; i < MyRows.length; i++) {
                    var allchecked = $(MyRows[i]).find('.chkISVAT').is(":checked");
                    if (allchecked == true) {
                        vatamount += parseFloat($(MyRows[i]).find(".amount").val() == "" ? 0 : $(MyRows[i]).find(".amount").val());
                        if (isNaN(vatamount)) {
                            vatamount = 0;
                        }
                    }
                    else {
                        nonamount += parseFloat($(MyRows[i]).find(".amount").val() == "" ? 0 : $(MyRows[i]).find(".amount").val());
                        if (isNaN(nonamount)) {
                            nonamount = 0;
                        }
                    }

         
                }

                $('#txtvatAmt').text((vatamount).toFixed(2));
                $('#txtnonAmt').text((nonamount).toFixed(2));

                $('.vat').each(function () {
                    var vt = parseFloat($(this).text())
                    temp += (isNaN(vt) ? 0 : vt)
                });
                $('#txttaxAmt').text((temp).toFixed(2));
                var total = (vatamount + nonamount + temp) - (totaldiscount + parseFloat($("#txtdiscount").val() == "" ? 0 : $("#txtdiscount").val()));

                $('#txttotalAmt').text((total).toFixed(2));
            },

            BindStore: function () {
                datas = JSON.parse(result);
                var x = new Array();
                //$(".Store").html('');
                if (datas.length > 0) {
                    var htmls = "";
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });

                    //$(".Store").html(htmls);

                }
                return htmls;

            },
            BindPurchaseDetails: function (result) {
                var datas = result.d;
                Autonumberitem = [];
                AutoPoNoo = [];
                if (datas.length > 0) {
                    var htmls = '';

                    $.each(datas, function (index, v) {
                        Autonumberitem.push(v.ITName);
                        //AutoPoNoo.push(value.PuNo);
                        AutoPoNoo.push({ label: v.PuNo, value: v.PurchaseMainID });
                    });
                }
            },

            BindItemID: function (result) {
                var datas = result.d;
                //var dat = datas[0].PurchaseDetailsID;
                $("#lblid").text(datas[0].PurchaseDetailsID);
                $("#lblItemID").text(datas[0].ItemID);


            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>
            GetGoodReceiveAutoNumber: function () {
                eventFunction.config.method = "ReceiptNo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify();
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            ResetAll: function () {
                //Unit
                eventFunction.GetGoodReceiveAutoNumber();
                eventFunction.GetPurchaseDetials();
                $("#chkISVAT").prop("checked", false);
                $('#txtPoNO').val('');
                $('#goodsReceiveList').html('');
                $('#ddlStore').val('');
                $('#txtInvoiceno').val('');
                $("#txtPoNO").autocomplete({

                    source: AutoPoNoo,

                    focus: function (event, ui) {
                        // prevent autocomplete from updating the textbox
                        event.preventDefault();
                        // manually update the textbox
                        $(this).val(ui.item.label);
                    },
                    select: function (event, ui) {
                        // prevent autocomplete from updating the textbox
                        event.preventDefault();
                        // manually update the textbox and hidden field
                        var PoNO = ui.item.label;
                        eventFunction.config.method = "getGoodsReceive";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ PoNO: PoNO });
                        eventFunction.config.ajaxCallMode = 5;
                        eventFunction.ajaxCall(eventFunction.config);

                    }
                });
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        store: {
                            required: true,
                        },

                        Qty: {
                            required: true,

                        },

                        txtInvoiceno: {
                            required: true,
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
                        var sum = parseFloat(($("#goodsRecevetablefoot tbody #txttotalAmt").text())).toFixed(2);
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
            UpdateCustomerName: function (id) {
                var MembershipID = id;
                var MemberInfo = {};
                MemberInfo.MembershipID = MembershipID;
                MemberInfo.RemainingBalance = parseFloat($('#txtCalRemainingAmount').val() == "" ? 0 : $('#txtCalRemainingAmount').val());
                MemberInfo.PayAmount = parseFloat($('#txtCalPaidAmount').val() == "" ? 0 : $('#txtCalPaidAmount').val());
                MemberInfo.AddedBy = SageFrameUserName;
                eventFunction.SaveGoodsReceive(MemberInfo);
                eventFunction.ReceivedList();
            },

            BindPaymentModesAndProviders: function () {
                var result = JSON.parse(Paymode);
                var cardProviders = result.providers;
                var paymentModes = result.paymentModes;
                var vendorId = $('#hdfVendorId').val() == "" ? 0 : $('#hdfVendorId').val();
                var htmls = '';
                $('#payment').html(htmls);
                htmls += '<div class="unpaidbill_ttl" style="display:flex;justify-content:space-between;"><h4>Total Amount: Rs.' + $('#txttotalAmt').text() + '</h4>';
                htmls += '<h4 id="surplusDeficit" style="text-align:right;">Surplus/Deficit : Rs.<span id="txtsurplus">0</span></h4></div>';
                htmls += '<table id="tblPayment" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';
                $.each(paymentModes, function (index, mode) {
                    htmls += '<tr>';
                    htmls += '<td><input type="checkbox" class="pmntCheck" id="chkBox_' + mode.PaymentModeID + '" ' + (mode.PaymentModeID == 1 ? 'checked' : '') + ' /><label for="chkBox_' + mode.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + mode.PaymentMode + ' : </label></td>';
                    htmls += '<td></td>';
                    htmls += '<td>';
                    if (mode.PaymentModeID == 1) {
                        htmls += 'Tender Amount <input type="text" id="txtTenderAmount" class="pmt txtNum sfInputbox" value="' + $('#txttotalAmt').text() + '"  />';
                        htmls += '</td>';
                        htmls += '<td>Return Amount <input type="text" id="txtReturnAmount" class="pmt txtNum sfInputbox" value="0" /></td>';
                        //htmls += '<td></td>';
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" disabled value="' + $('#txttotalAmt').text() + '"/></td>';
                    } else if (mode.PaymentModeID == 4) {
                        htmls += '<input type="hidden" id="hdfCusID" class="sfInputbox" value="0" />';
                        htmls += 'Vendor <input type="text" disabled id="txtName" class="sfInputbox" value=""/>';
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
                    width: 600,
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
                                                eventFunction.SaveGoodsReceive(MemberInfo);
                                            } else {
                                                $('#paymentBtn').bind('click');
                                            }
                                        });
                                    }
                                } else {
                                    jConfirm('Do You want to confirm the payment?', 'Payment Confirmation!!', function (confirmed) {
                                        if (confirmed) {
                                            eventFunction.SaveGoodsReceive(MemberInfo);
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
                    htmls += "<th>Vendor Name </th><th style='width:200px'> Address </th><th> Date Of Issue </th><th> PAN </th><th> IsVAT.</th><th class='delete-heading'>Select</th>";
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
                    htmls += "<tr>";
                    htmls += "<td colspan=6> No Data Available</td>";
                    htmls += "</tr>"
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
                    $('#hdfVendorId').val(word[1]);
                    $(pmntMode).prop('checked', true);
                });
            },


            BindVendor: function (data) {
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    $("#hdfCusID").val(datas[0].MembershipID);
                    $("#txtName").val(datas[0].Name);
                    $("#txtPAN").val(datas[0].PAN);
                } 
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
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);