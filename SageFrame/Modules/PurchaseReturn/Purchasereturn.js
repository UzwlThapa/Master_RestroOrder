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
                async: true,
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
                var datas = JSON.parse(data);
                var companyInfo = datas.companyInfo;
                var purchaseReturn = datas.returnDetails;
                var htmls = '';
                var date = purchaseReturn[0].PostedOn.split("T");
                htmls += '<button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right:2px;">Print</button>';

                htmls += '<div id="ViewDetailsReport" style="margin-top:10px;">';
                htmls += "<table style='width:100%;border:1px solid;padding-bottom:5px;padding-right:5px;margin:0;'>";
                htmls += "<tr><td colspan='2' style='font-size:12px;text-align:center;padding-top:10px;padding-bottom:10px;border-bottom:1px solid;'><b id='InvoiceType'>INVOICE</b></td></tr>";
                htmls += "<tr><td rowspan='4' colspan='1' style='font-size:22px;font-weight:bold;border-right:1px solid;border-bottom:1px solid;text-align:center;'> Purchase Order </td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:16px;font-weight:bold;border-bottom:1px solid;'>" + companyInfo[0].Name + "</td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:12px;border-bottom:1px solid;'>" + companyInfo[0].Address + "</td></tr>";
                htmls += "<tr><td colspan='1' style='font-size:12px;border-bottom:1px solid;'>" + companyInfo[0].PhoneNo + "</td></tr>";

                htmls += "<tr><td style='font-size:11px;text-align:left;'> InvoiceNo : </td>";
                htmls += "<td style='font-size:11px;text-align:right;'> Date : " + date[0] + "</td></tr>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'>" + (companyInfo[0].IsPan ? "PAN" : "VAT") + " No. : " + companyInfo[0].PAN + "</td>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Name. : " + purchaseReturn[0].Fname + "</td>";
                htmls += "<tr><td colspan='2' style='font-size:11px;text-align:left;'> Address. : " + purchaseReturn[0].Address + "</td>";
                htmls += "</tr></table>";

                htmls += "<table id='tableForPurchaseDetailsReport' class='sfGridwrapper display' cellspacing='0' style='width:100%;text-align:left;border:1px solid;border-top:none;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:6%;'>SN</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:50%;'>ItemName</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:12%;'>Quantity</th><th style='padding-bottom:5px;border-bottom:1px solid;border-right:1px solid;width:12%;'>Rate</th><th style='text-align:right;padding-bottom:5px;border-bottom:1px solid;width:20%;'>Total</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                var count = 1;
                $.each(purchaseReturn, function (index, value) {
                    htmls += "<tbody style='border-bottom:1px solid;'>"
                    htmls += "<tr>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:6%;'>" + count + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:50%;'>" + value.ItemName + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:12%;'>" + value.Qnty + ' ' + value.Symbol + "</td>";
                    htmls += "<td style='padding-bottom:5px;border-right:1px solid;width:12%;'>" + value.Rate + "</td>";
                    htmls += "<td style='padding-bottom:5px;text-align:right;width:20%;'>" + value.Total + "</td>";
                    TotalAmount = TotalAmount + parseFloat(value.Total);
                    htmls += "</tr>"
                    count++;
                });

                htmls += "</tbody>";
                htmls += "<tfoot>"
                htmls += "<tr>"
                htmls += "<td colspan='2' style='border-top:1px solid;border-right:1px solid;'>In Words Rs. " + convertNumberToWords(TotalAmount) + " only /. </td>"
                htmls += "<td colspan='2' style='text-align: right;border-right:1px solid;border-top:1px solid;'>Sub Total</td><td colspan='1'style='text-align: right;border-top:1px solid;' class='tot-rig'>Rs. " + TotalAmount + "</td>";
                htmls += "</tr><tr><td colspan='5' style='border-top:1px solid;text-align:right;padding-top:50px;'><div style='width:150px;text-align:center;border-top:1px solid;float:right;'>Signature</div></td></tr>"
                htmls += "</tfoot>"
                TotalAmount = 0;
        

                htmls += "</table>";
                htmls += "</div>";
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
