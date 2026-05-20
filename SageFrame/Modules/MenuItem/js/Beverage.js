function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;
    return true;
}
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
    $('#tabs').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROI_Item/',
                 userName: ''
             }, p);
        var v = 0;
        var i = 2;
        var AutocompleteItem = [];
        var AutocompleteIngredient = [];
        var htmls = "";
        var number = 0;
        var numbers = 0;
        var PurchaseArray = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "RoiItem.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0,
                ItemID: 0,
                updateGroup: 0,
                groupID: 0,
                countExtra: 0,
            },
            InitialSetup: function () {
                eventFunction.GetItemList();
                eventFunction.GetInventoryItem();
                
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnAdd").click(function () {
                    $("#btnAdd").hide();
                    $("#DivForItemlist").hide();
                    $("#roiitemtable").show();
                    eventFunction.GetCostCenter();
                    eventFunction.GetSmallUNIT();
                    eventFunction.GetExtraItemsList();
                    eventFunction.GetCategoryName();
                });


                $("#saveItems").on('click', function () {
                 
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                      
                        var value = $('.txtMenuSub').filter(function () {
                            return $(this).val() == '';
                        });
                        var ml = $('.txtMilliliter').filter(function () {
                            return $(this).val() == '';
                        });
                        var rate = $('.txtRate').filter(function () {
                            return $(this).val() == '';
                        });

                        if (value.length > 0) {
                            jAlert("Please! Fill all the field of the Sub Menu.", 'Alert!!');
                        }

                        else if (ml.length > 0) {
                            jAlert("Please! Fill all the ML field of the Sub Menu .", 'Alert!!');
                        }
                        else if (rate.length > 0) {
                            jAlert("Please! Fill all the Rate field of the Sub Menu.", 'Alert!!');
                        }
                        else {
                            eventFunction.uploadImage();
                            eventFunction.saveItems();
                           
                        }
                    }
                  
                });
            

                $("#CancelItems").click(function () {
                    eventFunction.ResetAll();
                    $("#btnAdd").show();
                    $("#roiitemtable").hide();
                });


                $("#txtItemName").change(function () {
                    var item = $("#txtItemName").val();
                    var category = $("#SelCategoryName").val();
                    eventFunction.config.method = "CheckItemExistence";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ item: item, categoryid: category });
                    eventFunction.config.ajaxCallMode = 6;
                    eventFunction.ajaxCall(eventFunction.config);
                });

               
                $("#tableForIngredient").on("click", ".addTextboxIngredient", function () {
                    if ($(this).closest('tr').find('td .txtIngredient').val() != "" && $(this).closest('tr').find('td .txtIngredientQuantity').val()) {
                        $(".addTextboxIngredient").removeClass('icon-addnew addTextboxIngredient').addClass('icon-close removeTextboxIngredient');
                        //var input = '<tr><td> <input type="text" class="txtIngredient" style="width: 154px;" /><input type="hidden" class="hdnIngredientID" /></td> <td class="unit"><select id="selIngredientUnit" class="sfInputbox" name="quentity" style="width: 100px;"></select></td><td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>';
                        var input = '<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>';
                        $("#tableForIngredient").append(input);
                        $('.txtIngredient').each(function () {
                            $(this).autocomplete({
                                source: AutocompleteIngredient,
                                delay: 0,
                                select: function (event, ui) {
                                    $(this).siblings('.hdnIngredientID').val(ui.item.id);
                                    eventFunction.GetUnitOfItemByID(ui.item.id);
                                }
                            });
                        });
                    } else {
                        jAlert('Empty textbox!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#tableForSubMenu").on("click", ".addSubMenu", function () {
                    if ($(this).closest('tr').find('td .txtMenuSub').val() != "" && $(this).closest('tr').find('td .txtMilliliter').val() && $(this).closest('tr').find('td .txtRate').val()) {
                        $(".addSubMenu").removeClass('icon-addnew addSubMenu').addClass('icon-close removeSubMenu');
           
                        var input = '<tr><td> <input type="text" class="sfInputbox txtMenuSub" style="width: 300px;" /></td><td><input type="text" class="sfInputbox txtMilliliter" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;"/></td> <td><input type="text" class="sfInputbox txtRate" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" /></td><td><label class="sfLocale icon-addnew sfBtn addSubMenu restro-btn"></label></td></tr>';
                        $("#tableForSubMenu").append(input);
                 
                    } else {
                        jAlert('Empty textbox!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#tableForSubMenu").on("click", ".removeSubMenu", function (x, y) {
                    var IngredientID = $(this).closest('tr').find('td .txtMenuSub').val();
                    
                    $(this).closest('tr').remove();
                });


                $("#tableForIngredient").on("click", ".removeTextboxIngredient", function (x, y) {
                    var IngredientID = $(this).closest('tr').find('td .hdnIngredientID').val();
                    var ItemID = $(this).closest('tr').find('td .hdnItemID').val();
                    if (ItemID != "") {
                        eventFunction.config.method = "DeleteIngredientItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ IngredientID: IngredientID, ItemID: ItemID });
                        eventFunction.config.ajaxCallMode = 12;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    $(this).closest('tr').remove();
                });


                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
                    
                        var ids = ui.item.id;
                        eventFunction.GetUnitOfItemByID(ids);
                    }
                });
            

                $("#fileImage").change(function () {
                    var path = $('input[type=file]').val();
                    var filename = path.replace(/^.*\\/, "");
                    $("#txtImage").val(filename);

                    eventFunction.readURL(this);
                });

                $("#btnAddItems").on('click', function () {
                    $("#SelStoreName").val('');
                    $("#txtValue").val('');

                    $("#DivStoreItem").dialog({
                        'title': 'Add Items',
                        width: 400,
                        modal: true,
                        dialogClass: 'headingbg',
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                    $("#btnPurchaseAdd").val("Add");

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
                        eventFunction.BindItemList(data.d);
                        break;
                    case 1:
                        eventFunction.BindSmalUNIT(data.d);
                        break;
                    case 2:
                        eventFunction.BindCategoryName(data.d);
                        break;
                    case 3:
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 4:
                        eventFunction.BindinventoryItem(data.d);
                        break;
                    case 5:
                        eventFunction.BindExtraItemsList(data.d);
                        break;
                    case 6:
                        eventFunction.BindCheckItemExistence(data.d);
                        break;
                    case 7:
                        eventFunction.BindDropdwonUnit(data.d);
                        break;
                    case 8:                       
                        jAlert('Deleted Successfully!', 'Information!!');
                        eventFunction.GetItemList();
                        break;
                    case 9:
                        eventFunction.BindViewItemByID(data.d);
                        break;
                    case 10:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ReloadMenu();
                        break;
                    case 11:                      
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ReloadMenu();
                        break;
                    case 12:
                       
                        break;

                }
            },
            ajaxFailure: function () {
    
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>


       

            GetExtraItemsList: function () {
                eventFunction.config.method = "GetExtraItemsList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);

            },
            GetUnitOfItemByID: function (ids) {
                eventFunction.config.method = "GetUnitOfItemByID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ ids: ids });
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindDropdwonUnit: function (result) {
                datas = JSON.parse(result);
                var htmls = "";
                $("#selIngredientUnit").html('');
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "' attr-conversion='" + value.Conversion + "'>" + value.Symbol + "</option>";
                    });
                    $(".unit").show();
                }
                $("#selIngredientUnit").html(htmls);
            },

            BindIngredientByID: function (result) {

                $(".unit").show();
                var datas = result;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        if (index == 0) {
                            $('#tableForIngredient tbody tr:eq(0)').find('td:eq(0) input[type=text]').val(value.ITName);
                            $('#tableForIngredient tbody tr:eq(0)').find('td:eq(0) input[type=hidden]').val(value.Ingredient);
                            
                            $('#tableForIngredient tbody tr:eq(0)').find('td:eq(1) input[type=text]').val(value.Quantity);
                            $('#tableForIngredient tbody tr:eq(0)').find('td:eq(1) input[type=hidden]').val(value.ItemId);
                        }
                        else {
                            $("#roiitemtable .addTextboxIngredient").click();
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(0) input[type=text]').val(value.ITName);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(0) input[type=hidden]').val(value.Ingredient);
                            //eventFunction.GetUnitOfItemByID(value.Ingredient);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(1) input[type=text]').val(value.Quantity);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(1) input[type=hidden]').val(value.ItemId);
                        }
                    });
                }
            },

            GetInventoryItem: function () {
                eventFunction.config.method = "GetInventoryItemWithSmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindinventoryItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        AutocompleteIngredient.push({ label: value.ITName + ", " + value.Symbol, id: value.ITId });
                       
                    });
                }
            },
       
     
            BindDropdwonItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {

                    $.each(datas, function (index, value) {                 
                        AutocompleteItem.push({ label: value.ITName, id: value.ITId });                  
                    });
               
                }
            },


            BindCheckItemExistence: function (result) {

                debugger;
                datas = JSON.parse(result);
                var htmls = '';
                if (datas.length > 0) {
                    jAlert("Alert! Item Name: " + $("#txtItemName").val() + " is Already Saved", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    $("#txtItemName").val("");
                    $('#txtItemName').focus();
                }
                else {
                    $("#txtItemCode").attr("placeholder", $("#txtItemName").val());
                }
            },

            DeleteItem: function (id) {
                username = SageFrameUserName;
                eventFunction.config.method = "DeleteItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ Itemid: id, userName: username });
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetItemList: function () {
                eventFunction.config.method = "GetItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

           

            BindItemList: function (result) {
                datas = JSON.parse(result);
                $("#DivForItemlist").html('');
                var htmls = '';
                htmls += "<table id='tableForItemList' class='sfGridwrapper display' cellspacing='0'><thead><tr><th style='width:40px;'>S.N.</th><th>Item Name</th><th>Category Name</th><th>Item Code</th><th>Cost Center</th><th style='display:none;'>Is Menu</th><th>Is Expirable</th><th style='display:none;'>Is Inventory</th><th class='edit-heading'>View</th><th class='delete-heading'>Delete</th></tr></thead><tbody>";
                if (datas.length > 0) {   
                    var a = 0;
                    $.each(datas, function (index, value) {
                        if (value.IsMenu == true && value.ItemCostCentreID == 2) {
                            a++;
                            htmls += '<tr><td>' + a + '</td>';
                            htmls += '<td>' + value.ItemName + '</td>';
                            htmls += '<td>' + value.ParentItem + '</td>';
                            htmls += '<td>' + value.ITCode + '</td>';
                            if (value.IsCategory == false) {
                                htmls += '<td>' + value.CostCenterName + '</td>';
                                htmls += '<td style="display:none;">' + value.IsMenu + '</td>';
                                htmls += '<td>' + value.IsExpirable + '</td>';
                                htmls += '<td style="display:none;">' + value.IsProdMaterial + '</td>';
                                htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="view icon-preview"/></td>';
                                //htmls += '<td><label id="' + value.ITId + '+' + value.ITCode + '+' + value.ImagePath + '+' + value.IsMenu + '+' + value.IsExpirable + '+' + value.IsProdMaterial + '+' + value.IsUnitWiseRate + '+' + value.ItemCostCentreID + '+' + value.IsActive + '+' + value.SmallUnit + '+' + value.PITId + '+' + value.LargeUnit + '+' + value.Conversion + '+' + value.IsDefaultPurchaseUnit + '+' + value.IsDefaultSalesUnit + '+' + value.SRate + '+' + value.ValidFrom + '+' + value.Details + '+' + value.IsExtra + '"   class="edit icon-edit" value="Edit"/></td>';
                                htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="delete icon-delete"  value="Delete"/></td>';
                            }
                            else {
                                htmls += '<td></td>';
                                htmls += '<td></td>';
                                htmls += '<td></td>';
                                htmls += '<td></td>';
                                htmls += '<td></td>';
                                htmls += '<td></td>';                         
                            }
                            htmls += '</tr>';
                        }
                    });
                } else {
                    $('#DivForItemlist').html('No Data Available');

                }
                    htmls += "</tbody></table>";
                    $("#DivForItemlist").html(htmls);
                    $("#tableForItemList").dataTable({
                        "bJQueryUI": true,
                        "lengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                        "pageLength": 20,
                        columnDefs: [{ orderable: false, targets: [1, 3, 4, 5, 6, 7, 8, 9] }]
                    });
                
                $("#tableForItemList").on('click', '.view', function () {
                    var ids = $(this).attr('id');
                    var row = $(this).parents('tr');
                    htmls = "";

                    $("#DivForViewItemByID").html(htmls);
                    htmls += "<p style='margin:0;'>Item Name : " + row.find('td:eq(1)').text();
                    htmls += "</p> <p style='margin:0;'>Category Name : " + row.find('td:eq(2)').text();
                    htmls += "</p><p style='margin:0;'>Item Code : " + row.find('td:eq(3)').text();
                    htmls += "</p><p style='border-bottom:1px solid gainsboro;margin:0;'>Cost Center :</b> " + row.find('td:eq(4)').text();
                    htmls += "</p>"
                    $("#DivForViewItemByID").css('margin-top', '0');
                    $("#DivForViewItemByID").html(htmls);
                    //console.log(ids);
                    eventFunction.config.method = "ViewItemByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ ids: ids });
                    eventFunction.config.ajaxCallMode = 9;
                    eventFunction.ajaxCall(eventFunction.config);
                    $('#DivForViewItemByID').dialog(
                        {
                            'title': 'Item Rate with Valid Date',
                            "resize": "auto",
                            modal: true,
                            width: 400,
                            dialogClass: 'popup-titlebg',
                        });
                });
         

                $("#tableForItemList").on('click', '.delete', function () {
                    var ids = $(this).attr('id');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.DeleteItem(ids);
                        }
                    });
                });

     
            },

          
            BindViewItemByID: function (result) {

                datas = JSON.parse(result);
                //$("#DivForViewItemByID").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableForViewItemByID' class='sfGridwrapper display'><thead><tr><th>S.N.</th><th>Valid From</th><th>Sale Rate</th></tr></thead><tbody>";
                    var valids = "";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        valids = value.ValidFrom.split(" ");
                        htmls += '<td>' + valids[0] + '</td>';
                        htmls += '<td>' + value.SRate + '</td>';
                        htmls += '</tr>';
                    });
                    htmls += "</tbody></table>";
                    $("#DivForViewItemByID").append(htmls);
                    //$("#DivGetInventoryByID").append(htmls);
                    $("#tableForViewItemByID").dataTable({
                        searching: false,
                        paging: false,
                        info: false,
                        ordering: false,
                    });
                }
                else {
                    $("#DivForViewItemByID").append("<br/>  No Data");
                    //$("#DivGetInventoryByID").append("<br/>  No Data");
                }
            },


            Bindstoreitem: function (result) {

                $("#purchaseTempTable tbody").html('');
                var datas = result;
                var htmls = '';
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += '<tr>';
                        htmls += '<td value ="' + value.StoreId + '">' + value.StName + '</td>';
                        htmls += '<td value ="' + value.Unit + '">' + value.UnitDescription + '</td>';
                        htmls += '<td>' + value.Value + '</td>';
                        htmls += '<td>' + "<img src='/images/delete.png' class='PurchaseDelete'  id='" + value.StoreItemId + "' value='Delete'/>" + "</td>";

                        htmls += '</tr>';
                    });
                    $("#purchaseTempTable tbody").append(htmls);

                }

             
                $(".PurchaseDelete").unbind('click').on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    row.remove();
                });

            },
            saveItems: function () {             
                var itemArray = new Array;
                var itemObject = new Object;
                var itemlist = new Array;

                var costcenter = $("#SelCategoryName").find(':selected').attr('costCenter');

                $("#tableForSubMenu tbody tr").each(function (x, y) {                  
                    var item = new Object;
                    item.ITId = eventFunction.config.ItemID;
                    item.PITId = $("#SelCategoryName").val() == null ? 0 : $("#SelCategoryName").val();
                    item.ITName = $(".txtItemName").val() + " " + $(this).find(".txtMenuSub").val();
                    item.ITCode = $(".txtItemCode").val() + " " + $(this).find(".txtMenuSub").val() == "" ? $("#txtItemName").val() + " " + $(this).find(".txtMenuSub").val() : $("#txtItemCode").val() + " " + $(this).find(".txtMenuSub").val();
                    item.ImagePath = $("#txtImage").val();
                    item.IsMenu = true;
                    item.IsExpirable = $("#chkbxIsExpirable").is(':checked')
                    item.IsProdMaterial = false;
                    item.IsUnitWiseRate = false;
                    item.ItemCostCentreID = $("#SelCostCenter").val();
                    item.Details = $("#txtDetails").val();
                    item.IsActive = $("#chkbxIsActive").is(':checked');
                    item.SmallUnit = $("#SelSmallunit").val();
                    item.AddedBy = SageFrameUserName;
                    item.IsExtra = $("#chkbxIsExtra").is(':checked');
                    item.SRate = parseFloat($(this).find(".txtRate").val() == "" ? 0 : $(this).find(".txtRate").val());
                    if ($(".hdnIngredientID").val() != "") {
                        item.Ingredient = $(".hdnIngredientID").val();
                        item.Quantity = $(this).find(".txtMilliliter").val();
                    }
                    itemlist.push(item);

                 
                  
                });

                var extraItems = new Array;
                $('.ckbxExtraItem').each(function (i, obj) {
                    if ($(this).is(':checked')) {
                        var extra = new Object;
                        extra.ExtraItemID = $(this).attr('id').split('_')[0];
                        extraItems.push(extra);
                    }
                });

           

                eventFunction.config.method = "saveBevearge";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
              
                eventFunction.config.data = JSON2.stringify({ itemlist: itemlist, extraItemList: extraItems });
                if (eventFunction.config.ItemIDUpdate == 1)
                    eventFunction.config.ajaxCallMode = 11;
                else
                    eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ItemIDUpdate = 0;
                eventFunction.config.ItemID = 0;
                eventFunction.ResetAll();

            },

     

            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            AddPurchase: function () {

                var table = $("#purchaseTempTable");
                var rows = table.find("tr.tableItem");

                var htmls = '';
                $("#AddTempTable").show();
                $("#btnPurchaseSave").show();
                number += 1;
                htmls += "<tr class='tableItem'>";
                //htmls += "<td class='itemID' style='text-align:left;'>" + $('#DdlItemid').val() + "</td>";
                htmls += "<td class='storeId' value='" + $("#SelStoreName").val() + "'>" + $("#SelStoreName :selected").text() + "</td>";
                htmls += "<td class='Unit' value='" + $("#SelUnit").val() + "'>" + $("#SelUnit :selected").text() + "</td>";
                htmls += "<td class='Value'>" + $("#txtValue").val() + "</td>";

                // htmls += "<td>" + "<img src='/images/edit.png' class='PurchaseEdit' id='" + $("#SelStoreName").val() + '+' + $("#SelStoreName :selected").text() + '+' + $("#SelUnit").val() + '+' + $("#SelUnit :selected").text() + '+' + $("#txtValue").val() + "' value='Edit'/>" + "_" + "<img src='/images/delete.png' class='PurchaseDelete'  id='PurchaseDelete_" + number + "' value='Delete'/>" + "</td>";
                htmls += "<td>" + "<img src='/images/delete.png' class='PurchaseDelete'  id='PurchaseDelete_" + number + "' value='Delete'/>" + "</td>";
                $("#purchaseTempTable tbody").append(htmls);

            

                $(".PurchaseDelete").unbind('click').on('click', function () {

                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            row.remove();

                        }
                    });

                });
            },

            BindCostCenter: function (result) {
                datas = JSON.parse(result);
                $("#SelCostCenter").html('');
           
                if (datas.length > 0) {
                    var htmls = '';
                     htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        if (value.CostCenterID == 2)
                            htmls += "<option value='" + value.CostCenterID + "' selected='selected'>" + value.CostCenterName + "</option>";
                        else
                            htmls += "<option value='" + value.CostCenterID + "'>" + value.CostCenterName + "</option>";
                    });
                    $("#SelCostCenter").html(htmls);
                 
                }
            },

            GetCategoryName: function () {
                eventFunction.config.method = "GetCategoryName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ IsMenu: true });;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindCategoryName: function (result) {
                datas = JSON.parse(result);
                $("#SelCategoryName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "' costCenter='" + value.ItemCostCentreID + "'>" + value.ITName + "</option>";
                    });
                    $("#SelCategoryName").html(htmls);
                }
            },


            BindStore: function (result) {
                datas = JSON.parse(result);
                $("#SelStoreName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });
                    $("#SelStoreName").html(htmls);
                }
            },


            GetSmallUNIT: function () {
                eventFunction.config.method = "getOnlySmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindSmalUNIT: function (result) {
                datas = JSON.parse(result);
                $("#SelSmallunit").html('');
   
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });
                    $("#SelSmallunit").html(htmls);
                    
                   
                }

            },
       

       

          
            uploadImage: function () {
                var fileUpload = $("#fileImage").get(0);
                var files = fileUpload.files;

                var data = new FormData();
                for (var i = 0; i < files.length; i++) {
                    data.append(files[i].name, files[i]);
                }

                $.ajax({
                    url: "/Modules/ROI_Item/FileUploadHandler.ashx",
                    type: "POST",
                    data: data,
                    contentType: false,
                    processData: false,
                    success: function (result) { },
                    error: function (err) {
                        jAlert(err.statusText, 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });
                //success: function (result) { alert(result); },
            },


            readURL: function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#ImgPrvs').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>


           
         
            BindExtraItemsList: function (result) {
                datas = JSON.parse(result);
                $("#extraLists").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    $.each(datas, function (index, value) {
                        htmls += "<div class='extra-listtype' style='width:25%;display:inline-block;'><input type='checkbox' class='ckbxExtraItem' id='" + value.ExtraItemID + "_" + value.ExtraPrice + "'> <label for='" + value.ExtraItemID + "_" + value.ExtraPrice + "'>" + value.ExtraItem + "(Rs. " + value.ExtraPrice + ")</label></div>";
                    });

                    $("#extraLists").html(htmls);
                }
            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                eventFunction.config.ItemID = 0;
                $("#SelCategoryName").val("");
                $("#txtItemName").val("");
                $("#txtItemCode").val("");
                $("#txtImage").val("");
                $("#fileImage").val("");
                $("#ImgPrvs").removeAttr('src');
                $("#SelInvCategoryName").val("");

                $("#chkbxInvIsExpirable").attr("checked", false);
                $("#SelInvCostCenter").val("");
                $("#txtInvDetails").val("");
                $("#chkbxInvIsActive").attr('checked', true);
                $("#SelSmallunit").val("");
                $("#txtMinStkQnty").val("")
                $("#SeltMinStkQnty").val("")
                $(".ajax-file-upload").show();
                $(".ajax-file-upload-statusbar").hide();
        
                $('.ckbxExtraItem').prop("checked", false);

                $("#chkbxIsExpirable").attr("checked", false);

                $("#SelCostCenter").val("");
                $("#txtDetails").val("");
                $("#chkbxIsActive").attr('checked', true);

                unitArray = [];
                unitObject = {};
                $(".selLargeUnit").val("");
                $(".txtConversion").val("");
                $('.CbxDefaultPurchaseUnit').prop('checked', true);
                $('.CbxDefaultSaleUnit').prop('checked', true);
                $(".sritemrate").val("");

                $(".Vitemrate").datepicker({ minDate: 0 }).datepicker("setDate", new Date());
                $(".txtExtraItemName").val("");
                $(".txtExtraIPrice").val("");
                $(".txtExtraIsActive").prop('checked', false);
                extraArray = [];
                extraObject = {};
                $("#roiitemtable").hide();
                $("#btnAdd").show();
                $("#DivForItemlist").show();
                var cnt = eventFunction.config.countExtra;
                for (i = cnt; i > 0; i--)
                    $("#btnForRemoveRowExtra").click();
                eventFunction.config.countExtra = 0;
                eventFunction.config.ItemIDUpdate = 0;
                eventFunction.config.ItemID = 0;
                $("#tableForIngredient tbody tr").remove();
                $("#tableForIngredient").append('<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td><input type="hidden" class="hdnItemID" value="" /></tr>');
                $("#tableForSubMenu tbody tr").remove();
                $("#tableForSubMenu").append('<tr><td><input type="text" class="sfInputbox txtMenuSub" style="width: 300px;" /><input type="hidden" class="hdnMenuSubID" /></td><td> <input type="text" class="sfInputbox txtMilliliter" onkeypress="return isNumber(event);" style="width: 100px;" /></td><td> <input type="text" class="sfInputbox txtRate" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px" />  </td><td><label class="sfLocale icon-addnew sfBtn addSubMenu restro-btn"></label></td></tr>');
                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
                    }
                });

            },
        
            ReloadMenu: function () {
                eventFunction.ResetAll();
                $("#btnAdd").show();
                $("#roiitemtable").hide();
                eventFunction.GetItemList();
                eventFunction.config.ItemID = 0;
                eventFunction.config.ItemIDUpdate = 0;
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        //StoreItem

                        SelCategoryName: {
                            required: true
                        },
                        txtItemName: {
                            required: true,
                        },

                        //txtItemCode: {
                        //    required: true,
                        //},
                        SelCostCenter:
                            {
                                required: true,
                            },

                        SelSmallunit: {
                            required: true,
                        },
                        selLargeUnit: {
                            required: true,
                        },

                        SelInvCategoryName: {
                            required: true
                        },
                        txtInvItemName: {
                            required: true,
                        },

                        SelInvCostCenter:
                            {
                                required: true,
                            },

                        SellSmallunit: {
                            required: true,
                        },


                        Vitemrate: {
                            required: false,
                        },
                    },
                    messages: {

                        txtType: {
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
