(function ($) {
   var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 Username: '',
                 ModulePath: '/Modules/Admin/ExtraBilling/'
             }, p);
        var v = 0;
        var count = 0;
        var numbers = 0;
        var selectedIndex = 0;
        var number = 0;
        var PurchaseArray = [];
        var ArrayData = [];
        var arraycount = 0;
        var Autonumberitem = new Array();
        //var PurchaseObjectDetails = new Array();
        //var PurchaseObjectDetailsLot = new Array();
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForExtraBilling.asmx/",
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
                eventFunction.GetStore();
                eventFunction.GetPurchaseDetials();
                eventFunction.InitialSetup();
                $("#AddTempTable").hide();
                $("#btnPurchaseSave").hide();
                $("#lblid").hide();
                $("#lblItemID").hide();
                $("#membeshipformlist").hide();
                $("#txtIssueDate").datepicker();

                eventFunction.getgoodsRevceive();
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

                
                $("#btnAddCus").click(function () {
                    eventFunction.getmember();
                    $("#membeshipformlist").dialog({
                        'title': 'Customer',
                        "resize": "auto",
                        width: 900,
                    });
                });


           
                $("#txtDiscount").keyup(function () {
                  
                    // function sum() {
                    var NetTotal = parseInt($('#txtSubTotal').val());
                    //  var total = $("#txtAllTotal").val() * Number($("#txtVat").val());
                    var total = parseInt($('#txtSubTotal').val()) * parseInt($('#txtDiscount').val());
                    var aftervat = total / 100;
                    var sum = +NetTotal - aftervat;
                     
                    $("#txtAllTotal").val(sum);



                    var NetTotal2 = parseInt($('#txtAllTotal').val());
                    //  var total = $("#txtAllTotal").val() * Number($("#txtVat").val());
                    var total = parseInt($('#txtAllTotal').val()) * parseInt($('#txtVat').val());
                    var aftervat = total / 100;
                    var sum = aftervat + NetTotal2;

                    $("#txtGrandTotal").val(sum);

                   
                  //  }

                });
                


                $("#btnAddItem").on('click', function () {

                 //   var checkValid = eventFunction.ValidationForm();
                 //   if (checkValid) {
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

                   //    }
                        }
                        var Total = 0;
                        $('#purchaseTempTable tbody tr').each(function (x, y) {
                            Total += parseInt($(this).find('td.Total').text());
                        });
                       // alert(Total);
                        $('#txtSubTotal').val(Total);





                    $('#txtItem').val('');
                    //$('#DdUnit').html('');
                    $('#txtQts').val('');
                    $('#lblid').text('');
                    



                    var NetTotal = parseInt($('#txtSubTotal').val());
                    //  var total = $("#txtAllTotal").val() * Number($("#txtVat").val());
                    var total = parseInt($('#txtAllTotal').val()) * parseInt($('#txtVat').val());
                    var aftervat = total / 100;
                    var sum = aftervat + NetTotal;

                    parseInt$("#txtGrandTotal").val(sum);

                });



                $("#membeshipformlist").on('click', '.CusSelect', function (event) {
                    var values = $(this).attr('id');
                    var splitdata = values.split('_');

                    var id = parseInt(splitdata[1]);

                    var Fname = splitdata[2];
                    var Lname = splitdata[3];

                    var fullName = Fname + " " + Lname;
                    $("#txtCusName").val(fullName);
                 //   $("#txtCashCusID").val(id);


                 //   companyProf.UpdateTotalCashPaid(id);
                    $("#membeshipformlist").hide();
                    $("#membeshipformlist").dialog("close");


                });




                $("#btnPurchaseSave").on('click', function () {
                  //  var checkValid = eventFunction.ValidationForm();
                  //  if (checkValid) {
                        eventFunction.SavePurchase();
                 //   }
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
                        jAlert('Inserted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });

                      //  location.reload();
                        var results = data.d;
                        window.open('/Admin/Restro-Billing-res.aspx?eID=' + results, '_blank');
                        break;
                    case 2:
                        eventFunction.BindStore(data);
                        break;
                    case 3:
                        eventFunction.BindPurchaseDetails(data);
                        break;
                    case 4:
                        eventFunction.BindItemID(data);
                        break;
                    case 5:
                        eventFunction.BndGoodReveive(data);
                        break;
                    case 6:
                        eventFunction.Bindmember(data);
                        break;

                }
            },
            ajaxFailure: function () {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    //case 1:
                    //    alert("Duplicate UnitName   Not Valid", "fail");
                    //    break;


                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

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
            getgoodsRevceive: function () {
                eventFunction.config.method = "getGoodsReceive";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getmember: function () {
                var customer = 1;
                eventFunction.config.method = "getsdatass";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ customer: customer });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },



            Bindmember: function (data) {
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th> Address </th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.Occupation + "</td>";
                        htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        //htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        //htmls += "<td style='width:90px'>" + value.RemainingBalance + "</td>";
                        //htmls += "<td style='width:90px'>" + value.UptoNowPaid + "</td>";

                       // htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                        htmls += "<td>" + "<img src='/images/completed.png' class='CusSelect' type='button'  id=_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        //checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                         {
                             "scrollY": false,
                             "scrollCollapse": false,
                             "jQueryUI": true,

                         });

                } else {
                    $('#membeshipformlist').html('No data');

                }
               
                $(".dataTables_scrollBody").css('height', '100%');

            },


            AddPurchase: function () {
                var table = $("#purchaseTempTable");
                var rows = table.find("tr.tableItem")
                for (var i = 0; i < rows.length; i++) {
                    var item = $(rows[i]);
                    PurchaseArray.push({
                        "PDId": parseInt(item.find(".itemname").text()),
                        //"ItemID": parseInt(item.find(".itemname").text()),
                        "Rate": item.find(".Rate").text(),
                        "Qnty": item.find(".Quenity").text(),
                        "Total": item.find(".Total").text(),
                       

                    })
                };

                var htmls = '';
                $("#AddTempTable").show();
                $("#btnPurchaseSave").show();

                htmls += "<tr class='tableItem'>";
                //var vasl = $("#DdlItemid option:selected").text();
                htmls += "<td class='ItemName' style='text-align:left'>" + $('#txtItem').val() + "</td>";
                htmls += "<td class='ItemId' style='display:none;'>" + $('#lblid').text() + "</td>";
                htmls += "<td class='Rate'>" + $('#txtRate').val() + "</td>";
                htmls += "<td class='Quenity'>" + $('#txtQts').val() + "</td>";
                htmls += "<td class='Total'>" + $('#txtTotal').val() + "</td>";
                htmls += "<td class='Itemiforbal' style='display:none;'>" + $('#lblItemID').text() + "</td>";
                //var val = $('#expirable').is(':checked');
                //htmls += "<td class='Expireable'>" + val + "</td>";
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
                    $('#txtRate').val($(this).closest('tr').find(".Rate").html());
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
                    if (confirm("ARE YOU SURE YOU WANT TO DELETE ?")) {
                        var data = $(this).attr('id');
                        var splicedata = data.split('_');
                        var index = parseInt(splicedata[1]);
                        $(this).closest('tr').remove();
                    }
                    var Total = 0;
                    $('#purchaseTempTable tbody tr').each(function (x, y) {
                        Total += parseInt($(this).find('td.Total').text());
                    });
                    // alert(Total);
                    $('#txtSubTotal').val(Total);
                });
            },
            //SavePurchase: function () {

            //    var SuperMainlist = new Array();
            //    var PurchaseObjectDetails = new Array();
            //    var PurchaseObjItemBal = new Array();
            //    var GoodReived = new Object();

            //    var MyRows = $('table#purchaseTempTable').find('tbody').find('tr');

            //    for (var i = 0; i < MyRows.length; i++) {
            //        var PurchaseObjectItem = new Object();
            //        PurchaseObjectItem.PDId = parseInt($(MyRows[i]).find('td:eq(1)').html());
            //        PurchaseObjectItem.Qnty = parseFloat($(MyRows[i]).find('td:eq(2)').html());
            //        PurchaseObjectDetails.push(PurchaseObjectItem);
            //    }
            //    console.log(PurchaseObjectDetails);
            //    var MyRows = $('table#purchaseTempTable').find('tbody').find('tr');

            //    for (var i = 0; i < MyRows.length; i++) {
            //        var checked = $(MyRows[i]).find('td:eq(4)').html();
            //        var PurchaseObjItemBalObj = new Object();
            //        if (checked == "true") {
            //            PurchaseObjItemBalObj.PurchaseDetailsID = parseFloat($(MyRows[i]).find('td:eq(1)').html());
            //            PurchaseObjItemBalObj.ITId = parseInt($(MyRows[i]).find('td:eq(3)').html());
            //            PurchaseObjItemBalObj.STId = parseInt($("#ddlStore").val());
            //            PurchaseObjItemBalObj.CLBal = parseFloat($(MyRows[i]).find('td:eq(2)').html());
            //            PurchaseObjItemBalObj.OPBal = 0;
            //            PurchaseObjItemBal.push(PurchaseObjItemBalObj);
            //        }
            //        else {
            //            PurchaseObjItemBalObj.PurchaseDetailsID = 0;
            //            PurchaseObjItemBalObj.ITId = parseInt($(MyRows[i]).find('td:eq(3)').html());
            //            PurchaseObjItemBalObj.STId = parseInt($("#ddlStore").val());
            //            PurchaseObjItemBalObj.CLBal = parseFloat($(MyRows[i]).find('td:eq(2)').html());
            //            PurchaseObjItemBalObj.OPBal = 0;
            //            PurchaseObjItemBal.push(PurchaseObjItemBalObj);
            //        }


            //    }

            //    superss = new Object();
            //    superss.PurchaseObjectDetails = PurchaseObjectDetails;
            //    superss.PurchaseObjItemBal = PurchaseObjItemBal;
            //    superss.GMNo = $('#txtGmNo').val();
            //    superss.STId = $('#ddlStore').val();
            //    superss.PostedBy = p.Username;
            //    var jsonText = JSON2.stringify({ GoodReived: superss });
            //    eventFunction.config.method = "GoodsReceivedss";
            //    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            //    eventFunction.config.data = jsonText;
            //    eventFunction.config.ajaxCallMode = 1;
            //    eventFunction.ajaxCall(eventFunction.config);


            //},

            //PDId": parseInt(item.find(".itemname").text()),
            //            //"ItemID": parseInt(item.find(".itemname").text()),
            //            "Rate": item.find(".Rate").text(),
            //            "Qnty": item.find(".Quenity").text(),


            SavePurchase: function () {
                var ExtrabillingObjectDetails = new Array();
                var MyRows = $('table#purchaseTempTable').find('tbody').find('tr');
                var PurchaseObjectItem = new Object();
                for (var i = 0; i < MyRows.length; i++) {
                    PurchaseObjectItem.Item = $(MyRows[i]).find('td:eq(0)').html();
                    PurchaseObjectItem.Rate = parseInt($(MyRows[i]).find('td:eq(2)').html());
                    PurchaseObjectItem.Quantity = parseFloat($(MyRows[i]).find('td:eq(3)').html());
                    PurchaseObjectItem.Total = parseFloat($(MyRows[i]).find('td:eq(4)').html());
                   
                    ExtrabillingObjectDetails.push(PurchaseObjectItem);
                }

                

                superss = new Object();
                superss.ExtrabillingObjectDetails = ExtrabillingObjectDetails;

                superss.CustomerName = $('#txtCusName').val();
                superss.IssueDate = $('#txtIssueDate').val();
                superss.Pan = $('#txtPan').val();
                superss.NetTotal = $('#txtAllTotal').val();
                superss.Discount = $('#txtDiscount').val();
                superss.Vat = $('#txtVat').val();
                superss.GrandTotal = $('#txtGrandTotal').val();
                              
                //superss.AddedBy = p.Username;
               // superss.CumboID = 0;
                var jsonText = JSON2.stringify({ PurchaseObjectItem: superss });
                eventFunction.config.method = "SaveExtraBilling";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },




            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BndGoodReveive: function (data) {
                $("#goodsReceiveList").show();
                $("#goodsReceiveList").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='unitTableSS' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>ReceiveNo </th><th>StoreName </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.GMId + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.GMNo + "</td>";
                        htmls += "<td>" + value.StName + "</td>";
                        //htmls += "<td>" + "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.UnitID + "_" + value.UnitDesc + "' value='Edit' /></td>";
                        //htmls += "<td>" + "<img src='/images/delete.png' class='UnitDelete' type='button'  id=_" + value.GMId + " value='Delete' /></td></tr>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#goodsReceiveList').html(htmls);
                    $('#unitTableSS').DataTable({
                        "jQueryUI": true,
                    });

                } else {
                    $('#goodsReceiveList').html('No data');
                }

                $(".UnitDelete").on('click', function () {
                    if (confirm("ARE YOU SURE YOU WANT TO DELETE ??")) {
                        eventFunction.DeleteGoods(this);
                        eventFunction.ResetAll();
                    }
                    return false;
                });

            },

            BindStore: function (result) {
                var datas = result.d;
                var x = new Array();
                $("#ddlStore").html('');

                if (datas.length > 0) {
                    var htmls = "";
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });

                    $("#ddlStore").html(htmls);
                }

            },
            BindPurchaseDetails: function (result) {
                var datas = result.d;

                if (datas.length > 0) {
                    var htmls = '';

                    $.each(datas, function (index, value) {
                        //htmls += "<option value='" + value.PurchaseMainID + "'>" + value.ITName + "</option>";
                        //ArrayData.push(value.UnitID);
                        Autonumberitem.push(value.ITName);
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

            ResetAll: function () {
                //Unit

                $('#ddlUserUnitId').val('');
                $('#ddlUserUnitId').text('');
                //$('#expirable').prop('checked', false);
                $('#Item').val('');
                $('#ddlItem').val('');
                //$('#DdUnit').html('');
                $('#txtQts').val('');
                $('#txtQuentityText').val('');
                $('#txtRate').val('');
                $('#txtLotNNo').val('');
                $('#txtBatchNo').val('');
                $('#txtExpDate').val('');

            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        Item: {
                            required: true,
                        },

                        Rate: {
                            required: true,

                        },
                        Quantity: {
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
