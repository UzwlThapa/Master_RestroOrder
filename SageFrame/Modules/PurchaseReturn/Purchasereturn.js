function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;
    return true;
}



function print() {
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


(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/PurchaseReturn/'
             }, p);
        var v = 0;
        var TotalAmount = 0;
        var PuNoArray = [];
        var AutoPoNoo = [];
        var receivedlist = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "PurchaseReturnService.asmx/",

                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.GetGoodsReceiveMainList();
                eventFunction.GetPurchaseReturnAutoNumber();
                eventFunction.GetPurchaseReturnMainList();
            },
            init: function () {
                eventFunction.InitialSetup();

                $('#txtSearch').on('keyup', function () {
                    eventFunction.BindGetPurchaseReturnMainList();
                });

                $("#btnView").on("click", function () {
                    if ($("#txtGmNo").val() == '')
                    {
                        jAlert('Please Enter GMNo.', 'Information!!', function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        eventFunction.GetGoodsReceiveListByGMNo();
                        $("#divForViewList").hide();
                    }
                   
                })
                $("#btnSave").on("click", function () {
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.SaveGoodsReceive();
                        }
                    });

                });

                $("#btnCancel").on("click", function () {
                   
                    eventFunction.ResetAll();
                });

                $("#txtGmNo").autocomplete({

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
                        eventFunction.BindGoodsMainDetails(data.d);
                        break;
                    case 1:
                        eventFunction.BindGoodsDetails(data.d);
                        break;
                    case 2:
                        var result = eval(data.d);
                        $('#txtPRNo').val(result[0].PRNo);
                        break;
                    case 3:
                        jAlert('Successfully Inserted!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        break;
                    case 4:
                        receivedlist = JSON.parse(data.d);
                        eventFunction.BindGetPurchaseReturnMainList();
                        break;
                    case 5:
                        eventFunction.BindPurchaseReturnDetailsReport(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },
            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetGoodsReceiveMainList: function () {
                eventFunction.config.method = "GetGoodsReceiveMainList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetGoodsReceiveListByGMNo: function () {
                var GMNo = $("#txtGmNo").val();
                eventFunction.config.method = "GetGoodsDetailsbyGMNo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    GMNo: GMNo
                });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPurchaseReturnAutoNumber: function () {
                eventFunction.config.method = "PurchaseReturnAutoNumber";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify();
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPurchaseReturnMainList: function () {
                eventFunction.config.method = "GetPurchaseReturnMainList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetPurchaseReturnDetailsbyPRNo: function (PRNo) {
                eventFunction.config.method = "GetPurchaseReturnDetailsbyPRNo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    PRNo: PRNo
                });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },


            BindGoodsMainDetails: function (result) {
               datas = JSON.parse(result);
                AutoPoNoo = [];
                if (datas.length > 0) {
                    var htmls = '';
                    $.each(datas, function (index, v) {
                        //AutoPoNoo.push(value.PuNo);
                        AutoPoNoo.push({ label: v.GMNo, value: v.GMId});
                    });
                }
            },

            BindGetPurchaseReturnMainList: function () {
                $("#divForViewList").show();
                $("#divForViewList").html('');
                mainList = receivedlist;
                var i = 0;
                if (!mainList) return;
                var htmls = "";
                htmls += "<table id='tableForViewList' class='reportsprint' cellspacing='0'><thead><tr><th>S.N.</th><th>Purchase Return Number</th><th>GoodReceive Number</th><th>Purchase Number</th><th>PostedOn</th><th class='view-heading tdcenter'>View</th></tr></thead><tbody>";
                if (mainList.length > 0) {
                    $.each(mainList, function (index, value) {
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.PRNo.toLowerCase().includes(search) || value.GMNo.toLowerCase().includes(search) || value.PuNo.toLowerCase().includes(search) || search == '') {
                            i++;
                            var date = value.PostedOn;
                            var word = date.split("T");
                            htmls += "<tr class='tableItem'><td>" + i + ".</td><td>" + value.PRNo + "</td>";
                            htmls += "<td>" + value.GMNo + "</td>";
                            htmls += "<td>" + value.PuNo + "</td>";
                            htmls += "<td>" + word[0] + "</td>";
                            htmls += "<td class='tdcenter'><img src='/images/view.png' class='PurchaseView preview-icon' type='button'  id=" + value.PRNo + " value='View'  /></td>";
                            htmls += "</tr>";
                        }
                });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='6' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody></table>";
                $("#divForViewList").html(htmls);
           
                $(".PurchaseView").on("click", function () {
                    var PRNo = $(this).attr('id');
                    eventFunction.GetPurchaseReturnDetailsbyPRNo(PRNo);
                    $('#PurchaseReturnViewReport').dialog({
                        'title': 'Purchase Return',
                        width: '400',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'top']
                    });
                });
            },

            //BindPurchaseReturnDetailsReport: function (result) {
            //    $("#PurchaseReturnViewReport").show();
            //    $("#PurchaseReturnViewReport").html('');
            //    datas = JSON.parse(result);
            //    if (datas.length > 0) {
            //        var htmls = "<table id='ReportTable' cellspacing='0'>"
            //        htmls += "<thead>"
            //        htmls += "<tr>"
            //        htmls += "<th>Item Name</th><th>Quantity </th> <th>Unit </th>"
            //        htmls += "</tr>"
            //        htmls += "</thead>"
            //        htmls += "<tbody>"

            //        $.each(datas, function (index, value) {
            //            htmls += "<tr class='tableItem'>";
            //            htmls += "<td>" + value.ItemName + "</td>";
            //            htmls += "<td>" + value.Qnty + "</td>";
            //            htmls += "<td>" + value.Symbol + "</td>";

            //            htmls += "</tr>"
              
            //        });
            //    } else {
            //        htmls += "<tr>";
            //        htmls += "<td colspan='3' style='text-align:center;'> No Data </td>";
            //        htmls += '</tr>';

            //    }
            //        htmls += "</tbody>";
            //        htmls += "</table>";
            //        $('#PurchaseReturnViewReport').html(htmls);
                 
            //},

            BindPurchaseReturnDetailsReport: function (data) {
                $("#PurchaseReturnViewReport").show();
                $("#PurchaseReturnViewReport").html('');
                var datas         = JSON.parse(data);
                var companyInfo   = datas.companyInfo;   // RESTAURANT (the buyer / issuer of debit note)
                var purchaseReturn = datas.returnDetails; // supplier details + items
                var htmls         = '';
                TotalAmount       = 0;

                // ── Null-safe helpers ──
                var ci       = companyInfo[0];
                var pr       = purchaseReturn[0];
                var safe     = function(v) { return (v !== null && v !== undefined && String(v) !== 'undefined' && String(v).trim() !== '') ? v : '-'; };
                var safeB    = function(v) { return (v !== null && v !== undefined && String(v) !== 'undefined') ? v : ''; };

                // ── AD date from PostedOn ──
                var rawDate  = safeB(pr.PostedOn);
                var dateAD   = rawDate ? rawDate.split('T')[0] : '-';

                // ── AD to BS conversion (approximate: BS = AD + 56 years 8.5 months, use offset table) ──
                // Reliable lightweight conversion: add 56 years then month-adjust with lookup
                var adToBS = function(adStr) {
                    if (!adStr || adStr === '-') return '-';
                    var parts = adStr.split('-');
                    if (parts.length < 3) return adStr;
                    var y = parseInt(parts[0]), m = parseInt(parts[1]), d = parseInt(parts[2]);
                    // BS year starts mid-April; months 1-3 of AD map to BS year = AD+56, months 4-12 = AD+57
                    // More precise: if AD month >= 4 and day >= 14 (approx Baisakh 1), use AD+57; else AD+56
                    var bsYear = (m > 4 || (m === 4 && d >= 14)) ? y + 57 : y + 56;
                    // BS month mapping (approximate, sufficient for display)
                    var bsMonths = [9,10,11,12,1,2,3,4,5,6,7,8]; // AD Jan=BS Poush(9)...AD Dec=BS Mangh(10) approx
                    var bsMonth  = bsMonths[m - 1];
                    var dd       = d < 10 ? '0' + d : d;
                    var mm       = bsMonth < 10 ? '0' + bsMonth : bsMonth;
                    return bsYear + '-' + mm + '-' + dd;
                };
                var dateBS = adToBS(dateAD);

                // IRD: PAN or VAT label based on registration type
                var panLabel = (ci.IsPan ? 'PAN No.' : 'VAT No.');

                htmls += '<button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right:2px;margin-bottom:8px;">Print</button>';
                htmls += '<div id="ViewDetailsReport" style="margin-top:6px;font-family:Arial,sans-serif;font-size:12px;width:100%;padding:12px;box-sizing:border-box;">';

                // ══════════════════════════════════════════════
                // SECTION 1 — HEADER
                // Issuer = RESTAURANT (the one returning goods)
                // IRD mandatory: issuer name, address, PAN/VAT
                // ══════════════════════════════════════════════
                htmls += "<div style='text-align:center;line-height:1.6;margin-bottom:6px;'>";
                htmls += "<div style='font-size:17px;font-weight:bold;'>" + safe(ci.Name) + "</div>";
                htmls += "<div style='font-size:11px;'>" + safe(ci.Address) + "</div>";
                htmls += "<div style='font-size:11px;'>Tel.: " + safe(ci.PhoneNo) + "</div>";
                if (safeB(ci.Email)) { htmls += "<div style='font-size:11px;'>Email: " + ci.Email + "</div>"; }
                htmls += "<div style='font-size:14px;font-weight:bold;text-decoration:underline;margin-top:5px;letter-spacing:1px;'>DEBIT NOTE</div>";
                htmls += "</div>";
                htmls += "<hr style='border:none;border-top:2px solid black;margin:4px 0;'/>";

                // ══════════════════════════════════════════════
                // SECTION 2 — DOCUMENT INFO
                // IRD mandatory fields: PAN, sequential bill no,
                // date in BS, supplier (to party) name & address,
                // reference to original purchase invoice
                // ══════════════════════════════════════════════
                htmls += "<table style='width:100%;border-collapse:collapse;font-size:11px;margin-bottom:4px;'>";

                htmls += "<tr>";
                htmls += "<td style='width:20%;padding:2px 4px;font-weight:bold;white-space:nowrap;'>" + panLabel + "</td>";
                htmls += "<td style='width:30%;padding:2px 4px;'>: " + safe(ci.PAN) + "</td>";
                htmls += "<td style='width:50%;padding:2px 4px;'></td>";
                htmls += "</tr>";

                // IRD: sequential debit note number | bill date in BS (mandatory by IRD)
                htmls += "<tr>";
                htmls += "<td style='padding:2px 4px;font-weight:bold;white-space:nowrap;'>Debit Note No.</td>";
                htmls += "<td style='padding:2px 4px;'>: <b>" + safe(pr.PRNo) + "</b></td>";
                htmls += "<td style='padding:2px 4px;'>Bill Date (BS) : <b>" + dateBS + "</b></td>";
                htmls += "</tr>";

                // Supplier = the party goods are being RETURNED TO
                htmls += "<tr>";
                htmls += "<td style='padding:2px 4px;font-weight:bold;white-space:nowrap;'>Supplier Name</td>";
                htmls += "<td style='padding:2px 4px;'>: " + safe(pr.Fname) + "</td>";
                htmls += "<td style='padding:2px 4px;'>Trans. Date (AD): " + dateAD + "</td>";
                htmls += "</tr>";

                htmls += "<tr>";
                htmls += "<td style='padding:2px 4px;font-weight:bold;white-space:nowrap;'>Address</td>";
                htmls += "<td style='padding:2px 4px;'>: " + safe(pr.Address) + "</td>";
                // IRD: reference to original invoice number (GMNo = goods receive number)
                htmls += "<td style='padding:2px 4px;'>Ref. Invoice No. : " + safe(pr.GMNo) + "</td>";
                htmls += "</tr>";

                htmls += "<tr>";
                htmls += "<td style='padding:2px 4px;font-weight:bold;white-space:nowrap;'>Contact No.</td>";
                htmls += "<td style='padding:2px 4px;'>: " + safeB(pr.ContactNo) + "</td>";
                htmls += "<td style='padding:2px 4px;'></td>";
                htmls += "</tr>";

                htmls += "</table>";

                // ── Supplier PAN bar (IRD: counterparty PAN mandatory for B2B above Rs.1 lakh) ──
                htmls += "<table style='width:100%;border-collapse:collapse;font-size:11px;margin-bottom:4px;'><tr>";
                htmls += "<td style='border:1px solid black;padding:4px 6px;'>";
                htmls += "<b>Supplier PAN</b> : " + safeB(pr.BuyerPAN);
                htmls += " &nbsp;&nbsp;&nbsp;&nbsp; ";
                htmls += "<b>Mode of Payment</b> : " + safe(pr.PaymentMode || 'Credit');
                htmls += "</td></tr></table>";

                // ══════════════════════════════════════════════
                // SECTION 3 — ITEMS TABLE
                // IRD mandatory: HS Code, description, qty, unit,
                // rate, taxable amount per line
                // ══════════════════════════════════════════════
                htmls += "<table id='tableForPurchaseDetailsReport' cellspacing='0' style='width:100%;border-collapse:collapse;border:1px solid black;font-size:11px;'>";
                htmls += "<thead><tr style='background-color:#eeeeee;'>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:center;width:5%;'>S.N.</th>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:center;width:10%;'>H.S. Code</th>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:left;width:33%;'>Description</th>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:center;width:10%;'>Qty</th>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:center;width:8%;'>Unit</th>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:right;width:12%;'>Rate (Rs.)</th>";
                htmls += "<th style='border:1px solid black;padding:5px 3px;text-align:right;width:22%;'>Amount (Rs.)</th>";
                htmls += "</tr></thead>";
                htmls += "<tbody>";

                var count    = 1;
                var totalQty = 0;
                $.each(purchaseReturn, function (index, value) {
                    TotalAmount = TotalAmount + parseFloat(value.Total);
                    totalQty    = totalQty + parseFloat(value.Qnty);
                    htmls += "<tr>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:center;'>" + count + "</td>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:center;'>" + safeB(value.HSCode) + "</td>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;'>" + safe(value.ItemName) + "</td>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:right;'>" + safe(value.Qnty) + "</td>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:center;'>" + safe(value.Symbol) + "</td>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:right;'>" + parseFloat(value.Rate).toFixed(2) + "</td>";
                    htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:right;'>" + parseFloat(value.Total).toFixed(2) + "</td>";
                    htmls += "</tr>";
                    count++;
                });

                htmls += "<tr style='font-weight:bold;background-color:#f5f5f5;'>";
                htmls += "<td colspan='3' style='border:1px solid black;padding:4px 3px;text-align:right;'>Total</td>";
                htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:right;'>" + totalQty + "</td>";
                htmls += "<td colspan='2' style='border:1px solid black;padding:4px 3px;'></td>";
                htmls += "<td style='border:1px solid black;padding:4px 3px;text-align:right;'>" + TotalAmount.toFixed(2) + "</td>";
                htmls += "</tr>";
                htmls += "</tbody>";

                // ══════════════════════════════════════════════
                // SECTION 4 — AMOUNT SUMMARY
                // IRD mandatory: taxable amount, VAT 13%, net amount
                // In Words: net amount (VAT-inclusive)
                // ══════════════════════════════════════════════
                var vatAmt = parseFloat((TotalAmount * 13 / 100).toFixed(2));
                var netAmt = parseFloat((TotalAmount + vatAmt).toFixed(2));

                htmls += "<tfoot>";
                htmls += "<tr>";

                // Left: In Words
                htmls += "<td colspan='4' style='border:1px solid black;padding:6px;vertical-align:top;font-size:11px;'>";
                htmls += "<b>In Words (Rs.):</b><br/>" + convertNumberToWords(netAmt) + " Only /.";
                htmls += "</td>";

                // Right: Amount breakdown — inner table keeps columns perfectly aligned
                htmls += "<td colspan='3' style='border:1px solid black;padding:5px;vertical-align:top;'>";
                htmls += "<table style='width:100%;border-collapse:collapse;font-size:11px;'>";
                htmls += "<tr><td style='padding:2px 3px;'>Discount</td><td style='padding:2px 2px;text-align:center;'>:</td><td style='padding:2px 3px;text-align:right;'>0.00</td></tr>";
                htmls += "<tr><td style='padding:2px 3px;'>Taxable Amount</td><td style='padding:2px 2px;text-align:center;'>:</td><td style='padding:2px 3px;text-align:right;'>" + TotalAmount.toFixed(2) + "</td></tr>";
                htmls += "<tr><td style='padding:2px 3px;'>VAT 13%</td><td style='padding:2px 2px;text-align:center;'>:</td><td style='padding:2px 3px;text-align:right;'>" + vatAmt.toFixed(2) + "</td></tr>";
                htmls += "<tr style='font-weight:bold;border-top:1px solid black;'>";
                htmls += "<td style='padding:3px 3px;'>Net Amount</td><td style='padding:3px 2px;text-align:center;'>:</td><td style='padding:3px 3px;text-align:right;'>" + netAmt.toFixed(2) + "</td>";
                htmls += "</tr></table>";
                htmls += "</td>";
                htmls += "</tr>";

                // ══════════════════════════════════════════════
                // SECTION 5 — FOOTER
                // Left : E&OE, Remarks, Received By (supplier signs here — they received the returned goods)
                // Right: "For [RESTAURANT NAME]" — the restaurant issued this debit note, so their authorised
                //         signatory signs on the right
                // ══════════════════════════════════════════════
                htmls += "<tr>";
                htmls += "<td colspan='4' style='border:1px solid black;padding:6px;font-size:11px;vertical-align:top;'>";
                //htmls += "E. &amp; O.E<br/>";
                //htmls += "Goods once returned will not be taken back back.<br/><br/>";
                htmls += "<b>Remarks :</b> " + safeB(pr.Remarks) + "<br/><br/><br/>";
                htmls += "<b>Received By (Supplier) :</b> _______________________";
                htmls += "</td>";

                // Authorised signatory = RESTAURANT (the issuer of this debit note)
                htmls += "<td colspan='3' style='border:1px solid black;padding:6px;text-align:center;vertical-align:bottom;font-size:11px;'>";
                htmls += "For <b>" + safe(ci.Name) + "</b><br/><br/><br/><br/>";
                htmls += "________________________<br/>";
                htmls += "Authorised Signatory";
                htmls += "</td>";
                htmls += "</tr>";

                htmls += "</tfoot>";
                htmls += "</table>";
                htmls += "</div>";

                TotalAmount = 0;
                $('#PurchaseReturnViewReport').html(htmls);

                $("#btnPrints").click(function () {
                    print();
                });

            },

            BindGoodsDetails: function (result) {
                
                $("#goodsReceiveList").show();
                $("#btnSave").show();
                $("#btnCancel").show();
                $("#goodsReceiveList").html('');
                datas = JSON.parse(result);
                var htmls = "<table id='goodsRecevetable' class='reportsprint tablee-section' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Item Name</th><th>Qty</th><th>Returning Qty</th><th>Rate</th><th>Total</th><th style='width:200px;'>Store</th><th>Delete</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $("#hdfVendorId").val(datas[0].vendorId);
                    var count = 1
                    $.each(datas, function (index, value) {
                        if (value.RemainingQnty != 0) {
                            var total = value.RemainingQnty * value.Rate;
                            htmls += "<tr>";
                            htmls += "<td>" + count + "</td>";
                            htmls += "<td>" + value.ItemName + "</td>";
                            htmls += "<td>" + value.RemainingQnty + " " + value.Symbol + "</td>";                         
                            htmls += "<td>" + "<input type='text' style='width:100px;display:inherit;' id='txtQnty' max='" + value.RemainingQnty + "' onkeypress='return IntegerAndDecimal(event,this);' class='sfInputbox txtQnty required' value='" + value.RemainingQnty + "'/> " + value.Symbol + "</td>";
                            htmls += "<td class = 'rate'>" + value.Rate + "</td>";
                            htmls += "<td class='total'>" + total + "</td>";
                            if (value.StName == '') {
                                htmls += "<td>" + value.StoreName + "</td>";
                            } else {
                                htmls += "<td>" + value.StName + "</td>";
                            }
                            htmls += "<td>" + "<img src='/images/delete.png' class='Delete'  id='Delete_" + count + "' value='Delete'/>" + "</td>";
                            htmls += "<td class='ItemID' style='display:none;'>" + value.ItemID + "</td>";
                            htmls += "<td class='GDId' style='display:none;'>" + value.GDId + "</td>";
                            htmls += "<td class='Conversion' style='display:none;'>" + value.Conversion + "</td>";
                            htmls += "<td class='vendorId' style='display:none;'>" + value.vendorId + "</td>";
                            htmls += "<td class='usedunitId' style='display:none;'>" + value.UsedUnitID + "</td>";
                            htmls += "<td class='storeid' style='display:none;'>" + value.STId + "</td>";

                            htmls += "</tr>"
                            count++;
                        }
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='11' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';

                }
                    htmls += "</tbody>";
  
                    htmls += "</table>";
                    $('#goodsReceiveList').html(htmls);
          
              
                
                
                $(".Delete").unbind('click').on('click', function () {

                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            row.remove();
                        }
                    });

                });

                $('#goodsRecevetable').on('keyup', '.txtQnty', function () {

                    if (parseFloat($(this).val()) > parseFloat($(this).attr('max'))) {
                        jAlert('Returned Quantity cannot be greater than Received Quantity.', 'Information!!', function () { $.alerts.dialogClass = null; });

                        $(this).val(parseFloat($(this).attr('max')));
                    }

                    $("#goodsRecevetable>tbody>tr").each(function (index, value) {
                        var qty = $(value).find('.txtQnty').val();                 
                        var rate = $(value).find('.rate').text();
                     
                        var result = rate * qty;
                        $(value).find('.total').text(result.toFixed(1));

                    });


       
                });

            
       
            },
           
            SaveGoodsReceive: function () {
                
                var goodReceiveDetails = new Array();
                var PurchaseObjItemBal = new Array();
                var MyRows = $('table#goodsRecevetable').find('tbody').find('tr');
                for (var i = 0; i < MyRows.length; i++) {           
                    var goodReceiveDetailsObj = new Object();
                    goodReceiveDetailsObj.GDId = parseFloat($(MyRows[i]).find(".GDId").text());
                    goodReceiveDetailsObj.STId = parseFloat($(MyRows[i]).find(".storeid").text());
                    goodReceiveDetailsObj.ItemID = parseFloat($(MyRows[i]).find(".ItemID").text());
                    goodReceiveDetailsObj.Qnty = parseFloat($(MyRows[i]).find("#txtQnty").val());
                    goodReceiveDetailsObj.UsedUnitId = parseFloat($(MyRows[i]).find(".usedunitId").text());
                    goodReceiveDetailsObj.Rate = parseFloat($(MyRows[i]).find('.rate').text());
                    goodReceiveDetailsObj.Total = parseFloat($(MyRows[i]).find('.total').text());
                    goodReceiveDetails.push(goodReceiveDetailsObj);
                }
                for (var i = 0; i < MyRows.length; i++) {
                    var PurchaseObjItemBalObj = new Object();
                    PurchaseObjItemBalObj.STId = parseFloat($(MyRows[i]).find(".storeid").text());
                    PurchaseObjItemBalObj.ITId = parseFloat($(MyRows[i]).find(".ItemID").text());
                    PurchaseObjItemBalObj.CLBal = parseFloat($(MyRows[i]).find("#txtQnty").val()) * parseFloat($(MyRows[i]).find(".Conversion").text());
                    PurchaseObjItemBalObj.OPBal = 0;
                    PurchaseObjItemBal.push(PurchaseObjItemBalObj);
                }

                PurchaseReturn = new Object();
                PurchaseReturn.goodReceiveDetails = goodReceiveDetails;
                PurchaseReturn.PurchaseObjItemBal = PurchaseObjItemBal;
                PurchaseReturn.PRNo = $('#txtPRNo').val();
                PurchaseReturn.PostedBy = SageFrameUserName;
                PurchaseReturn.vendorId = $('#hdfVendorId').val() == null ? 0 : $('#hdfVendorId').val();
       
  
                var jsonText = JSON2.stringify({ PurchaseReturn: PurchaseReturn });
                eventFunction.config.method = "PurchaseReturn";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);

            
            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                eventFunction.GetPurchaseReturnMainList();
                eventFunction.GetPurchaseReturnAutoNumber();
                $("#divForViewList").show();
                $("#goodsReceiveList").hide();
                $("#btnSave").hide();
                $("#btnCancel").hide();
                $("#txtQnty").val('0'); 
                $("#txtGmNo").val('');
            },

        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);