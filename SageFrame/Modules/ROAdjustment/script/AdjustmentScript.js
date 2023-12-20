function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
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
        var indexs = 0;
        var number = 0;
        var numbers = 0;
        var selectedIndex = 0;
        var IssueArray = [];
        var selectedTypeId = 0;
        var AutocompleteItem = new Array();
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

                eventFunction.InitialSetup();
                eventFunction.GetStore();
                eventFunction.GetItem();
                eventFunction.adjustmentget();
                //eventFunction.BindType();
                eventFunction.adjustmentTypeget();
                eventFunction.getTodayFiscalYr();


                $(".hiden").hide();
                $("#AdjustmentTempTable").show();
               // $(".unitclass").hide();
                $("#btnSave").show();
                $("#btnSave").prop("disabled", true);
                $("#tblAddItem").hide();
                $("#adjustmentTable").hide();
                $(".cancel").hide();
                $(".cancel").on('click', function () {
                    $(this).hide()
                    eventFunction.ResetAll();
                    $('#ddlSTId').val('');

                   // eventFunction.Reload();
                    
                });
                $("#lblid").hide();
              
                

                $("#btnTypeSave").on('click', function () {
                    if ($('#TxtTypeName').val() == "") {
                        jAlert('Empty Adjusment Type!', 'Alert!!');
                    }
                    else {
                        eventFunction.Save2();
                        $('#TxtTypeName').val('');
                    }
                    return false;

                });


                $('#edittype').on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.config.method = "EditAdjustmentType";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ TypeId: selectedTypeId, Name: $('#TxtTypeName').val(), IsActive: $('#chktype').is(":checked"), Username: p.Username });
                        eventFunction.config.ajaxCallMode = 9;
                        eventFunction.ajaxCall(eventFunction.config);
                    }



                });

                $("#btnAddAdjustment").on('click', function () {
                    $("#adjustmentTable").show();
                    $("#btnAddAdjustment , #AdjustmentAdd").hide();
                    $("#unitTableSS").hide();
                    $("#btnCancel").show();
                   

                });

                $("#btnCancel").on('click', function () {
                    $("#adjustmentTable").hide();
                    $("#btnAddAdjustment , #AdjustmentAdd").hide();
                    eventFunction.ResetAll();
                    $('#ddlSTId').val('');
                    eventFunction.adjustmentget();
                    $("#btnAddAdjustment").show();
                });

                    $("#ddlItem").autocomplete({
                        source: AutocompleteItem,
                        delay: 0,
                        select: function (event, ui) {
                            var ids = ui.item.id;
                            $("#lblItemid").val(ids);
                            $('#lblid').text(ids);
                            eventFunction.config.method = "GetUnitOfItemByID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ ids: ids });
                            eventFunction.config.ajaxCallMode = 4;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    });


                    $("#btnSave").on('click', function () {
                
                       if ($('#ddlSTId').val() == null) {
                    
                            jAlert('Please select store!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        }
                        else {
                            eventFunction.SaveAdjsments();
                            
                            $("#adjustmentTable").hide();
                            $('#txtAMNo').val('');
                            eventFunction.ResetAll();
                            eventFunction.Reload();
                            $("#btnAddAdjustment").show();
                            
                         }

               });

                $('#txtQuentity').on('keypress input change', function () {

                    var dotLength = $(this).val().match(/\.+/ig);
                    if (dotLength == null) {
                        var value = $('#ddlUserUnitId').children('[value="' + ArrayData[0] + '"]');
                        value.attr('disabled', false);
                    }
                    else {
                        var value = $('#ddlUserUnitId').children('[value="' + ArrayData[(dotLength.length - 1)] + '"]');
                        value.attr('disabled', true);
                        var value1 = $('#ddlUserUnitId').children('[value="' + ArrayData[(dotLength.length)] + '"]');
                        value1.attr('disabled', false);
                    }
                });
            
                $('#txtQnty').on('change', function () {
                    $("#txtQntyInText").val($("#txtQnty").val() + " " + $("#ddlUserUnit :selected").text().trim());
                })

                $('#ddlUserUnit').on('change', function () {
                    $("#txtQntyInText").val($("#txtQnty").val() + " " + $("#ddlUserUnit :selected").text().trim());
                })

                $("#btnadd").on('click', function () {
                    var item = $('#ddlItem').val();
                    var qts = $('#txtQnty').val();
                    var unit = $('#ddlUserUnitId').val();
                    var qtsintext = $('#txtQntyInText').val();
                    var adtype = $('#txtAdType').val() == null ? 0 : $('#txtAdType').val();

                    if (item == "") {
                        jAlert('Item Name Required', 'Alert!!', function () { $.alerts.dialogClass = null; });;
                    }
                    else if (unit == null) {
                        jAlert('Unit Required', 'Alert!!', function () { $.alerts.dialogClass = null; });;
                    }
                    else if (qts == "") {
                        jAlert('Quantity Required', 'Alert!!', function () { $.alerts.dialogClass = null; });;
                    }
                    else if (qtsintext == "") {
                        jAlert('Quantity in text Required', 'Alert!!', function () { $.alerts.dialogClass = null; });;
                    }
                    else if (adtype == "") {
                        jAlert('Adtype Required', 'Alert!!', function () { $.alerts.dialogClass = null; });;
                    }
                    else {
                        if (numbers != 100) {
                            eventFunction.AddPurchase();
                            eventFunction.ResetAll();
                            numbers = 0
                        }
                        else {
                            var MyRows = $("#AdjustmentTempTable tbody").find("tr");
                            $(MyRows[selectedIndex]).find('td:eq(0)').html($("#ddlItem").val());
                            $(MyRows[selectedIndex]).find('td:eq(1)').html($("#lblid").val());
                            $(MyRows[selectedIndex]).find('td:eq(2)').html($("#txtQnty").val());

                            $(MyRows[selectedIndex]).find('td:eq(3)').html($("#ddlUserUnitId").val());
                            $(MyRows[selectedIndex]).find('td:eq(4)').html($("#ddlUserUnit").val());
                            $(MyRows[selectedIndex]).find('td:eq(5)').html($("#txtQntyInText").val());
                            
                            $(MyRows[selectedIndex]).find('td:eq(6)').html($("# ").val());
                            $(MyRows[selectedIndex]).find('td:eq(7)').html(""+$("#chkAdd").is(':checked'));
                            selectedIndex = 0;
                            numbers = 0;

                        }
                        eventFunction.ResetAll();
                        //$("#tblAddItem").dialog("close");

                    }


                })

                $("#btnAddItems").on('click', function () {
                    $("#tblAddItem").dialog({
                        'title': 'Add Items',
                        width: 500,
                        modal: true,
                        dialogClass: 'headingbg',
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                });

                $("#btnPurchaseClose").on('click', function () {
                    $("#tblAddItem").dialog("close");
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
                        $('#ddlSTId').val('');
                        eventFunction.ResetAll();
                        eventFunction.Reload();
                        break;
                    case 2:
                        eventFunction.BindStore(data.d);
                        break;
                    case 3:
                        eventFunction.BindDropdwonItem(data.d);
                        break;
                    case 4:
                        eventFunction.BindDropdwonUnit(data.d);
                        break;
                    case 5:
                        eventFunction.BindText(data);
                        break;
                    case 6:
                        eventFunction.BindAdjustment(data);
                        break;
                    case 7:
                        eventFunction.BindAdjustmentType(data);
                        $('#txtAdType').html('');
                        var htmls = '';
                        $.each(data.d, function (index, value) {
                            if (value.IsActive == true) {
                                htmls += ("<option value='" + value.AdjustmentTypeID + "'>" + value.AdjustmentTypeName + "</option>");
                            }

                        });
                        $('#txtAdType').html(htmls);
                        break;
                    case 8:
                        $('#TxtTypeName').val(data.d.AdjustmentTypeName);
                        $('#chktype').prop('checked', data.d.IsActive);
                        $('#edittype').show();
                        $('#btnTypeSave').hide();
                        break;
                    case 9:
                        $('#edittype').hide();
                        $('#btnTypeSave').show();
                        eventFunction.adjustmentTypeget();
                        $('#TxtTypeName').val('');
                        $('#chktype').attr('checked', false);
                        break;
                    case 10:
                        
                        break;
                    case 11:

                        eventFunction.BindDataGetbyAdjustmentId(data);
                        break;
                    case 12:
                        
                        var html = "";
                        $.each(data.d, function (index, value) {
                            html += "<option value='" + value.fyId + "'>" + value.fyName + "</option>"
                        });
                        $("#ddlFYId").html(html);
                        break;
                    case 13:
                        eventFunction.BindPo(data);
                        break;
                    case 14:
                        jAlert('Inserted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                      
                        $('#btnTypeSave').show();
                        eventFunction.adjustmentTypeget();
                        $('#TxtTypeName').val('');
                        $('#chktype').attr('checked', false);

                        break;
                       
                }



            },
            GetAutoNumber: function () {

                eventFunction.config.method = "getAdjustmentAutoNumber";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 13;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindPo: function (result) {
      
                var datas = result.d;
               
                $("#txtAMNo").val(datas[0].AMNo);
            },
            Save2: function () {
                var type = {};
                type.AdjustmentTypeName = $('#TxtTypeName').val();
                type.IsActive = $("#chktype").is(':checked');
                type.AddedBy = p.Username;
              
                eventFunction.config.method = "SaveAdjustmentType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ type: type });
                eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
   
            },
    
            getTodayFiscalYr: function () {
            
                eventFunction.config.method = "getTodayFiscalYr";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 12;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteAdjust: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var AMId = id;
                eventFunction.config.method = "ajustdelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ AMId: AMId });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },
            adjustmentget: function () {
                eventFunction.config.method = "getadjustment";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },
            adjustmentTypeget: function () {
                eventFunction.config.method = "getadjustmentType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindType: function () {
                eventFunction.config.method = "getadjustmentType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SaveAdjsments: function () {
                var SuperMainlist = new Array();
                var AdjstmentObjectDetails = new Array();
                var AdjObject = new Object();

                var MyRows = $('#AdjustmentTempTable').find('tbody').find('tr');
           
                for (var i = 0; i < MyRows.length; i++) {
                    var AdjsmentDetailsObject = new Object();
                    AdjsmentDetailsObject.ITId = parseInt($(MyRows[i]).find('td:eq(1)').html());
                    AdjsmentDetailsObject.Qnty = parseFloat($(MyRows[i]).find('td:eq(2)').html()) * parseFloat($(MyRows[i]).find('td:eq(9)').html());
                    AdjsmentDetailsObject.UsedUnitId = parseInt($(MyRows[i]).find('td:eq(3)').html());
                    AdjsmentDetailsObject.QntyInText = $(MyRows[i]).find('td:eq(5)').html();
                    AdjsmentDetailsObject.IsAdd = $(MyRows[i]).find('td:eq(7)').html();
                    AdjsmentDetailsObject.AdType = parseInt($(MyRows[i]).find('td:eq(8)').html());
                    AdjstmentObjectDetails.push(AdjsmentDetailsObject);
                }
                AdjObject = new Object();
                AdjObject.AdjstmentObjectDetails = AdjstmentObjectDetails;
                AdjObject.AMNo = $('#txtAMNo').val();
                AdjObject.STId = parseInt($('#ddlSTId').val());
                AdjObject.FYId = parseInt($('#ddlFYId').val());
                AdjObject.Remarks = $('#txtarearemarks').val();
                //AdjObject.QntyInText = $('#txtQntyInText').val();

                //AdjObject.PostedOn = "";
                AdjObject.PostedBy = p.Username;
                var jsonText = JSON2.stringify({ AdjustMain: AdjObject });
                eventFunction.config.method = "SaveAdjsment";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            AddPurchase: function () {
                var htmls = '';
                $("#AdjustmentTempTable").show();
                $("#AdjustmentTempTable").show();
                
                $("#tempFooter").hide();

                htmls += "<tr class='tableItem'>";
                htmls += "<td class='ItemName' style='text-align:left'>" + $('#ddlItem').val() + "</td>";
                htmls += "<td class='ItemID' style='text-align:left;display:none;' >" + $('#lblid').text() + "</td>";

                htmls += "<td class='Quentity'>" + $('#txtQnty').val() + "</td>";

                htmls += "<td class='UnitID' style='text-align:left;display:none;'>" + $('#ddlUserUnit').val() + "</td>";
                //htmls += "<td class='UnitID' style='text-align:left;display:none;'>" + $('#ddlUserUnitId').val() + "</td>";
                htmls += "<td class='UnitName' style='text-align:left'>" + $('#ddlUserUnit :selected').text().trim() + "</td>";

                htmls += "<td class='QuentityInText'>" + $('#txtQntyInText').val() + "</td>";

                htmls += "<td class='AdType'>" + $('#txtAdType :selected').text() + "</td>";

                htmls += "<td class='IsAdd'>" + $('#chkAdd').is(':checked') + "</td>";
                htmls += "<td class='AdType' style='display:none;'>" + $('#txtAdType').val() + "</td>";

                htmls += "<td class='AdType' style='display:none;'>" + $('#ddlUserUnit :selected').attr('attr-conversion') + "</td>";

                htmls += "<td class='tdcenter'>" + "<img src='/images/edit.png' class='AdjustmentEdit'  id='AdjustmentEdit_" + number + "' value='Edit'/>" + "</td>";
                htmls += "<td class='tdcenter'>" + "<img src='/images/delete.png' class='AdjustmentDelete'  id='AdjustmentDelete_" + number + "' value='Delete'/>" + "</td>";
                htmls += "</tr>"
                number += 1;
                $("#AdjustmentTempTable tbody").append(htmls);

                //$("#btnSave").show();
                $("#btnSave").prop("disabled", false);
                $(".AdjustmentEdit").on('click', function () {

                    $("#tblAddItem").dialog("open");
                    var data = $(this).attr('id');
                    var splicedata = data.split('_');

                    var index = parseInt(splicedata[1]);
                    selectedIndex = index;
                    numbers = 100;


                    var itemid = $(this).closest('tr').find(".ItemID").html();
                    indexs = parseInt(itemid);
                    var table = $("#AdjustmentTempTable");
                    var rows = table.find("tr.tableItem")

                    $("#lblid").val($(this).closest('tr').find(".ItemID").html());
                    //$("#podetailsID").val($(this).closest('tr').find(".PD").html());

                    $('#ddlItem').val($(this).closest('tr').find(".ItemName").html());
                    $('#lblid').text($(this).closest('tr').find(".ItemID").html());
                    $('#txtQnty').val($(this).closest('tr').find(".Quentity").html());
                    $('#ddlUserUnitId').val($(this).closest('tr').find(".UnitID").html());

                    $('#txtQntyInText').val($(this).closest('tr').find(".QuentityInText").html());
                    $('#txtAdType').val($(this).closest('tr').find(".AdType").html());
                    //$('#chkAdd').prop('checked', false);
                    if ($(this).closest('tr').find(".IsAdd").html() == "true") {
                        $('#chkAdd').prop('checked', true);
                    }
                    else {
                        $('#chkAdd').prop('checked', false);
                    }
                    //$('#chkAdd').prop('checked', $(this).closest('tr').find(".IsAdd").html());
                    $(".unit").show();
                });

                $(".AdjustmentDelete").on('click', function () {
                    var data = $(this).attr('id');
                    var splicedata = data.split('_');
                    var index = parseInt(splicedata[1]);
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            row.remove();

                        }
                    });

                });
            },
            DeleteAdjustmentType: function (index) {
                eventFunction.config.method = "DeleteAdjustmentType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ id: parseInt(index), Username: p.Username });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetItem: function () {
                eventFunction.config.method = "getitemfromdatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetStore: function () {
                eventFunction.config.method = "getIssueToDDl";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            getQuentityinText: function () {
                var numb = $("#txtQnty").val();
                eventFunction.config.method = "changeCurrencyToWords";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ numb: numb });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetdataByPurchaseOrderId: function (id) {
                eventFunction.config.method = "GetdataByPurchaseOrderId";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ Id: id });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindAdjustment: function (data) {
                $("#AdjustmentAdd").show();
                $("#AdjustmentAdd").html('');
                var datas = data.d;
                var htmls = "<table id='unitTableSS' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Adjustment No </th><th>StoreName </th><th>Remarks</th><th class='edit-heading tdcenter' style='width:20px;'>View</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    var count = 1
                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.AMId + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.AMNo + "</td>";
                        htmls += "<td>" + value.StName + "</td>";
                        htmls += "<td>" + value.Remarks + "</td>";
                        htmls += "<td class='tdcenter'>" + "<label class='view icon-preview UnitView' type='button'  id='Purch+" + value.AMId + '+' + value.AMNo + '+' + value.StName + '+' + value.Remarks + "'/></td>";
                        //htmls += "<td>" + "<img src='/images/delete.png' class='UnitDelete' type='button'  id=_" + value.AMId + " value='Delete' /></td></tr>";
                        htmls += "</tr>"
                        count++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan=4 style='text-align:center;'>No Data Available</td>";
                    htmls += "</tr>";
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#AdjustmentAdd').html(htmls);
          
                $("#unitTableSS").on('click', '.UnitView', function () {

                    //$("#btnadd").hide();
                    var arr = $(this).attr('id');
                    var splited = arr.split('+');
                    selectedTypeId = parseInt(splited[1]);
                    var htmls = "";
                    
                    htmls += "<table><tr><td>Adjustment No: " + splited[2];
                    htmls += "</td><td>Store Name: " + splited[3];
                    htmls += "</td><tr></tr><td colspan='2'>Remarks: " + splited[4];
                    htmls += "</td></tr></table>";
                    $('#divForAdjustmentView').html(htmls);

                    $("#divForAdjustmentView").dialog({
                        'title': 'Adjustment Details',
                        width: 900,
                        modal: true,
                        resizable: true,
                        dialogClass: 'popup-titlebg',
                    });
                    eventFunction.GetdataByPurchaseOrderId(selectedTypeId);

                    //$("#AdjustmentAdd").dialog();
                    //$('#AdjustmentAdd').modal('show');
                });
                $(".UnitDelete").on('click', function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.DeleteAdjust(item);
                            eventFunction.ResetAll();
                        }
                    });
                    return false;
                });

            },
            BindAdjustmentType: function (data) {
                $("#AdjustmentTypes").show();
                $("#AdjustmentTypes").html('');
                var datas = data.d;
                var htmls = "<table id='TableSSType' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Type Name </th><th>IsActive </th><th class='sfEdit tdcenter'>Edit</th><th class='sfDelete tdcenter'>Delete</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.AdjustmentTypeID + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.AdjustmentTypeName + "</td>";
                        htmls += "<td>" + value.IsActive + "</td>";

                        htmls += "<td class='tdcenter'>" + "<img src='/images/edit.png' class='TypeEdit' type='button'  id=' edit_" + value.AdjustmentTypeID + "' value='Edit' /></td>";
                        htmls += "<td class='tdcenter'>" + "<img src='/images/delete.png' class='TypeDelete' type='button'  id='delete_" + value.AdjustmentTypeID + "' value='Delete' /></td></tr>";
                        htmls += "</tr>"
                        count++;
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan=5 style='text-align:center;'>No Data Available</td>";
                    htmls += "</tr>";
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#AdjustmentTypes').html(htmls);

                $('#TableSSType').on('click', '.TypeEdit', function () {
                    var arr = $(this).attr('id');
                    var splited = arr.split('_');
                    selectedTypeId = parseInt(splited[1]);
                    eventFunction.GettypedatabyId(splited[1]);

                    $('#edittype').show();
                    $('#btnTypeSave').hide();
                });
                $('#TableSSType').on('click', '.TypeDelete', function () {
                    var arr = $(this).attr('id');
                    var splited = arr.split('_');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            selectedTypeId = parseInt(splited[1]);
                            eventFunction.DeleteAdjustmentType(splited[1]);
                            eventFunction.adjustmentTypeget();
                        }
                    });
                    return false;



                });
                //$(".UnitDelete").on('click', function () {
                //    if (confirm("ARE YOU SURE YOU WANT TO DELETE ??")) {
                //        eventFunction.DeleteAdjust(this);
                //        eventFunction.ResetAll();
                //    }
                //    return false;
                //});

            },
            GettypedatabyId: function (typeid) {
                eventFunction.config.method = "GettypedatabyId";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ TypeId: typeid });
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindText: function (result) {
                var datas = result.d;
                $("#txtQntyInText").val(datas);

            },
            BindStore: function (result) {
                datas = JSON.parse(result);
                var x = new Array();
                $("#ddlSTId").html('');

                if (datas.length > 0) {
                    var htmls = "";
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });

                    $("#ddlSTId").html(htmls);
                }

            },
            BindDropdwonItem: function (result) {
                datas = JSON.parse(result);

                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        AutocompleteItem.push({ label: value.ITName, id: value.ITId });
                        //AutocompleteItem.push(value.ITName);
                        //$("#ddlItem").autocomplete({
                        //    source: AutocompleteItem
                        //});
                        //htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });

                }

            },
            //BindDropdwonUnit: function (result) {
            //    var datas = result.d;
            //    $("#ddlUserUnitId").html('');
            //    if (datas.length > 0) {
            //        var htmls = '';
            //        //htmls = "<option value='' disabled selected>-Select-</option>";
            //        $.each(datas, function (index, value) {
            //            $("#lblid").text(value.ITId);
            //            $("#podetailsID").text(value.PurchaseDetailsID);
            //            htmls += "<option value='" + value.UnitID + "'>" + value.UnitName + "</option>";
            //        });
            //        $(".unitclass").show();
            //        $("#ddlUserUnitId").html(htmls);


            //    }
            //},
            BindDropdwonUnit: function (result) {
           
                datas = JSON.parse(result);
                var htmls = "";
                $("#ddlUserUnit").html('');
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "' attr-conversion='" + value.Conversion + "'>" + value.Symbol + "</option>";
                    });
                    $(".unit").show();
                }
                $("#ddlUserUnit").html(htmls);
            },
            BindDataGetbyAdjustmentId: function (data) {
                if (data.d.length > 0) {
                    var htmls = '';
                    htmls += "<table id='tableInDialog' class='sfGridwrapper display' border='1'><thead><tr><th>Item Name</th><th>Quantity</th><th>Unit</th><th>Quantity in Text</th><th>Add Type</th><th>IsAdd</th></tr></thead><tbody>";
                    $.each(data.d, function (index, value) {
                        htmls += "<tr class='tableItem'>";
                        htmls += "<td class='ItemName' style='text-align:left'>" + value.ItName + "</td>";
                        //htmls += "<td class='ItemID' style='text-align:left'>" + value.ITId + "</td>";

                        htmls += "<td class='Quentity'>" + value.Qnty + "</td>";

                        //htmls += "<td class='UnitID' style='text-align:left'>" + value.UsedUnitId + "</td>";
                        htmls += "<td class='UnitName' style='text-align:left'>" + value.unitName + "</td>";

                        htmls += "<td class='QuentityInText'>" + value.QntyInText + "</td>";

                        htmls += "<td class='AdType'>" + value.AdName + "</td>";
                        htmls += "<td class='IsAdd'>" + value.IsAdd + "</td>";

                       // htmls += "<td class='PD'>" + value.PDId + "</td>";

                        //htmls += "<td>" + "<input type='button' class='AdjustmentEdit other'  id='AdjustmentEdit_" + number + "' value='Edit'/>" + "</td>";
                        //htmls += "<td>" + "<input type='button' class='AdjustmentDelete other'  id='AdjustmentDelete_" + number + "' value='Delete'/>" + "</td>";
                        htmls += "</tr>"
                        number += 1;
                      
                    });
                    htmls += "</tbody></table>";
                    $("#divForAdjustmentView").append(htmls);
                    //$("#tableInDialog").dataTable({
                    //    "jQueryUI" : true,
                    //    search: false,
                    //    ordering: false,
                    //    // paging: false,
                    //    //info: false,
                    //});
                }
            },
            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            Reload: function () {
               
                eventFunction.GetStore();
                eventFunction.GetItem();
                eventFunction.adjustmentget();
                eventFunction.BindType();
                eventFunction.adjustmentTypeget();
                eventFunction.getTodayFiscalYr();
                eventFunction.GetAutoNumber();
                $("#AdjustmentTempTable tbody tr").remove();
            },

            ResetAll: function () {
                //Unit
                $('#ddlItem').val('');
                $('#txtQnty').val('');
                $('#ddlUserUnitId').val('');
                $('#ddlUserUnitId').text('');
                $('#txtQntyInText').val('');
                $('#txtAdType').val('');
                $('#chkAdd').prop('checked',false);
              //
               // $('#podetailsID').text('');
                $('#lblid').text('');
                $(".unit").hide();



            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        STId: {
                            required: true,

                        },
                        FYId: {
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