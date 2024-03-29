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
                async: false,
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
                eventFunction.GetUNIT();
                eventFunction.GetSmallUNIT();
                eventFunction.GetCategoryName();
                eventFunction.GetInventoryItem();
                eventFunction.GetCostCenter();
                eventFunction.GetItem();
                eventFunction.GetExtraItemsList();
                eventFunction.GetInventoryList();
                eventFunction.GetStore();
               
                $('#txtCompanyLogo').attr('readonly', 'true');

           
                $(".unit").hide();

            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnPurchaseAdd").on('click', function () {

                    // if ($("#btnPurchaseAdd").val() == "Add") {
                    var store = $("#SelStoreName").val();
                    var unit = $("#SelUnit").val();
                    var quantity = $("#txtValue").val();


                    if (store == "") {
                        jAlert("Please Fill The Item Name", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    } else if (unit == null) {
                        jAlert("Please Fill The Unit", 'Alert!!', function () { $.alerts.dialogClass = null; });

                    } else if (quantity == "") {
                        jAlert("Please Fill The Quantity", 'Alert!!', function () { $.alerts.dialogClass = null; });

                    } else {

                        if (numbers != 100 || txtID == 0) {
                            eventFunction.AddPurchase();

                            $("#SelStoreName").val('');
                            $("#SelUnit").val('');
                            $("#txtValue").val('');

                            numbers = 0

                        }
                        else {

                            var MyRows = $("#AddTempTable tbody").find("tr");
                            $(MyRows[selectedIndex - 1]).find('td:eq(0)').html($("#SelStoreName").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(1)').html($("#SelUnit").val());
                            $(MyRows[selectedIndex - 1]).find('td:eq(2)').html($("#txtValue").val());

                        }


                    }
                    $("#tblAddItem").dialog("close");
               
                });



                $("#btnPurchaseClose").on('click', function () {
                    $("#tblAddItem").dialog("close");
                });

            
                $("#CancelGroupItem").on('click', function () {
                    {
                        eventFunction.ResetGroup();
                    }
                });
                
                $("#saveGroupItem").on('click', function () {
                    {
                        eventFunction.saveGroupItem();
                        eventFunction.ResetGroup();
                    }
                });

                $("#saveItems").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.uploadImage();
                        eventFunction.saveItems();
                    }
                    // return false;
                });
                $("#saveInvItems").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.uploadInvImage();
                        eventFunction.saveInventoryItems();
                    }
                    return false;

                });

                $("#saveStore").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                    }
                });
                $("#SelSmallunit").change(function () {
                    eventFunction.GetLargeUNIT($("#SelSmallunit").val());
                });
                $("#SelInvSmallunit").change(function () {
                    eventFunction.GetLargeUNIT($("#SelInvSmallunit").val());
                });
                $("#CancelInvItems").click(function () {

                    eventFunction.ResetAll();
                    $("#btnInventoryAdd").show();
                    $("#DivGetInventoryList").show();
                    $("#addInventoryTable").hide();
                    $("#purchaseTempTable tbody tr").remove();
                    var row = $("#purchaseTempTable tbody").closest('tr');
                    row.remove();
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
                    eventFunction.config.ajaxCallMode = 12;
                    eventFunction.ajaxCall(eventFunction.config);
                });

                $("#divForAdd").on("click", ".removeTextbox", function (x, y) {
                    var ids = $(this).siblings('.hdnItemID').val();
                    if (ids != "" && eventFunction.config.updateGroup == 1) {
                        eventFunction.config.method = "DeleteGroupItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ ids: ids });
                        //eventFunction.config.ajaxCallMode = 12;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    //console.log(p);
                    $(this).closest('tr').remove();
                });

                $("#divForAdd").on("click", ".addTextbox", function () {
                
                    if ($(this).siblings('.txtItem').val() != "") {
                        $(".addTextbox").removeClass('icon-addnew addTextbox').addClass('icon-close removeTextbox');
                        var input = "<tr><td><input type='text' class='txtItem'/><input type='hidden' class='hdnItemID'/>&nbsp&nbsp<label class='sfLocale sfBtn icon-addnew  addTextbox'></label></td></tr>";
                        $("#divForAdd").append(input);
                        $('.txtItem').each(function () {
                            $(this).autocomplete({
                                source: AutocompleteItem,
                                delay: 0,
                                select: function (event, ui) {
                                    //var ids = $(this).parent().find('.hdnItemID').val() + ',';
                                    $(this).siblings('.hdnItemID').val(ui.item.id);
                                  
                                }
                            });
                        });
                    } else {
                        jAlert('Empty textbox!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#tableForIngredient").on("click", ".addTextboxIngredient", function () {
                    if ($(this).closest('tr').find('td .txtIngredient').val() != "" && $(this).closest('tr').find('td .txtIngredientQuantity').val()) {
                        $(".addTextboxIngredient").removeClass('icon-addnew addTextboxIngredient').addClass('icon-close removeTextboxIngredient');
                        //var input = '<tr><td> <input type="text" class="txtIngredient" style="width: 154px;" /><input type="hidden" class="hdnIngredientID" /></td> <td class="unit"><select id="selIngredientUnit" class="sfInputbox" name="quentity" style="width: 100px;"></select></td><td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>';
                        var input = '<tr><td> <input type="text" class="txtIngredient sfInputbox" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>';
                        $("#tableForIngredient").append(input);
                        $('.txtIngredient').each(function () {
                            $(this).autocomplete({
                                source: AutocompleteIngredient,
                                delay: 0,
                                select: function (event, ui) {
                                    $(this).siblings('.hdnIngredientID').val(ui.item.id);
                                    //$(this).siblings('.lblIngredientUnit').text(ui.item.unit);
                                    eventFunction.GetUnitOfItemByID(ui.item.id);
                                }
                            });
                        });
                    } else {
                        jAlert('Empty textbox!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#tableForIngredient").on("click", ".removeTextboxIngredient", function (x, y) {
                    var IngredientID = $(this).closest('tr').find('td .hdnIngredientID').val();
                    var ItemID = $(this).closest('tr').find('td .hdnItemID').val();
                    if (ItemID != "") {
                        eventFunction.config.method = "DeleteIngredientItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ IngredientID: IngredientID, ItemID: ItemID });
                        eventFunction.config.ajaxCallMode = 0;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    $(this).closest('tr').remove();
                });


                $(".txtItem").autocomplete({
                    source: AutocompleteItem,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnItemID').val(ui.item.id);
                    }
                });

                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
                        // $(this).siblings('.lblIngredientUnit').text(ui.item.unit);
                        var ids = ui.item.id;
                        eventFunction.GetUnitOfItemByID(ids);
                    }
                });
                $("#btnUpload").click(function (evt) {


                    evt.preventDefault();
                });

                $("#fileImage").change(function () {
                    var path = $('input[type=file]').val();
                    var filename = path.replace(/^.*\\/, "");
                    $("#txtImage").val(filename);
                    // $("#txtImage").val("~/Modules/ROI_Item/ImageItem/" + $('input[type=file]').val());
                    // alert($("#txtImage").val());

                    eventFunction.readURL(this);
                });


                $("#fileInvImage").change(function () {
                    var path = $('input[type=file]').val();
                    var filename = path.replace(/^.*\\/, "");
                    $("#txtInvImage").val(filename);
                    eventFunction.readinvURL(this);
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
                        break;
                    case 1:
                        eventFunction.BindDropdownUnit(data);
                        break;
                    case 2:
                        eventFunction.BindDropdownItem(data);
                        break;
                    case 3:
                        eventFunction.BindSmalUNIT(data.d);
                        break;
                    case 4:
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 5:
                        eventFunction.BindCategoryName(data.d);
                        break;
                    case 6:
                        eventFunction.BindLargeUNIT(data.d);
                        //eventFunction.BindLargeUnit(data);
                        break;
                    case 7:
                        eventFunction.ResetAll();
                        jAlert('Saved Successfully!', 'Information!!');
                        //eventFunction.ResetAll();
                        eventFunction.GetItemList();
                        //eventFunction.InitialSetup();
                        eventFunction.Reload();


                        break;
                    case 8:
                        eventFunction.BindItemList(data.d);
                        break;
                    case 9:
                        eventFunction.ResetAll();
                        jAlert('Deleted Successfully!', 'Information!!');
                        eventFunction.ReloadMenu();
                        eventFunction.Reload();
                        //eventFunction.GetItemList();
                        break;
                    case 10:
                        // eventFunction.BindItemWithUnitList(data.d.units);
                        eventFunction.BindExtraItem(data.d.extra);
                        eventFunction.Bindstoreitem(data.d.storeitemstock);

                        break;
                    case 11:
                        eventFunction.ResetAll();
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reload();
                        break;
                    case 12:
                        eventFunction.BindCheckItemExistence(data.d);
                        break;
                    case 13:
                        eventFunction.BindDropdwonItem(data.d);
                        break;
                    case 14:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getGroupList();
                        break;
                    case 15:
                        eventFunction.BindGroupList(data);
                        break;
                    case 16:
                        eventFunction.BindGroupListByID(data);
                        break;
                    case 17:
                        eventFunction.BindViewItemByID(data.d);
                        break;
                    case 18:
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetGroup();
                        eventFunction.ResetAll();
                        break;
                    case 19:
                        jAlert('Deleted Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getGroupList();
                        eventFunction.ResetAll();
                        break;
                    case 20:
                        eventFunction.BindinventoryItem(data.d);
                        break;
                    case 21:
                        eventFunction.BindIngredientByID(data.d);
                        break;
                    case 22:
                        eventFunction.BindDropdwonUnit(data.d);
                        break;
                    case 23:
                        eventFunction.BindExtraItemsList(data.d);
                        break;
                    case 24:
                        if (data.d.length > 0) {
                            $.each(data.d, function (index, value) {
                                $('#' + value.ExtraItemID + '_' + value.ExtraPrice).prop('checked', true);
                            });
                        }
                        break;
                    case 25:
                        eventFunction.BindInventoryList(data.d);
                        break;
                    case 26:
                        eventFunction.BindStore(data.d);
                        break;
                    case 27:
                        eventFunction.ResetAll();
                        jAlert('Saved Successfully!', 'Information!!');
                        eventFunction.GetInventoryItem();
                        eventFunction.GetInventoryList();
                        break;

                    case 29:
                        eventFunction.ResetAll();
                        eventFunction.ReloadMenu();
                        eventFunction.Reload();
                        break;

                    case 30:
                        eventFunction.BindViewStockItem(data.d);
                        break;

                    case 31:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        eventFunction.ReloadMenu();
                        break;

                    case 32:
                        eventFunction.ResetAll();
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ReloadMenu();
                        break; 
                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>


            GetStore: function () {
                eventFunction.config.method = "getIssueToDDlHirerchy";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 26;
                eventFunction.ajaxCall(eventFunction.config);

            },

            GetExtraItemsList: function () {
                eventFunction.config.method = "GetExtraItemsList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 23;
                eventFunction.ajaxCall(eventFunction.config);

            },
            GetUnitOfItemByID: function (ids) {
                eventFunction.config.method = "GetUnitOfItemByID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ ids: ids });
                eventFunction.config.ajaxCallMode = 22;
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
                datas = JSON.parse(result);
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
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(1) input[type=text]').val(value.Quantity);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(1) input[type=hidden]').val(value.ItemId);
                        }
                    });
                }
            },
            GetInventoryItem: function () {
                eventFunction.config.method = "GetInventoryItemWithSmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 20;
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
            getGroupList: function () {
                eventFunction.config.method = "getGroupList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 15;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindGroupList: function (result) {
                var htmls = "";
                var datas = result.d;
                var i = 1;
                htmls += "<table id='tableForGroupListing' class='sfGridwrapper display dataTable no-footer'><thead><tr><th>S.N.</th><th>Group Name</th><th>Group Code</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th></tr></thead><tbody>"
                if (datas.length >= 0) {
                    $(datas).each(function (index, value) {
                        htmls += '<tr><td>' + i + '</td>';
                        htmls += '<td>' + value.GroupName + '</td>';
                        htmls += '<td>' + value.GroupCode + '</td>';
                        htmls += '<td><label class="edit icon-edit" id=' + value.GroupID + '/></td>'; 
                        htmls += '<td><label class="delete icon-delete" id=' + value.GroupID + '/></td></tr>';
                        i++;
                    });
                    htmls += '</tbody></table>';
                    $("#divForListing").html(htmls);
                    $("#tableForGroupListing").dataTable({
                    });

                }
                else {
                    $("divForListing").html("No Data..");
                }

                $("#tableForGroupListing").on("click", ".edit", function () {
                    debugger;
                    eventFunction.ResetGroup();
                    eventFunction.config.updateGroup = 1;
                    var row = $(this).parents('tr');
                    $('#txtGroupName').val(row.find('td:eq(1)').text());
                    $('#txtGroupCode').val(row.find('td:eq(2)').text());
                    var ids = $(this).attr('id');
                    eventFunction.config.groupID = ids; 
                    eventFunction.config.method = "getGroupByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ ids: ids });
                    eventFunction.config.ajaxCallMode = 16;
                    eventFunction.ajaxCall(eventFunction.config); 
                });
                $("#tableForGroupListing").on("click", ".delete", function () {
                    var ids = $(this).attr('id');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.config.method = "deleteGroupByID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ ids: ids });
                            eventFunction.config.ajaxCallMode = 19;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    });
                }); 
            },

            BindGroupListByID: function (result) {
                var htmls = "";
                var datas = result.d;
                var i = 1;
                var len = datas.length - 1;
                debugger;
                $(datas).each(function (index, value) {
                    if (datas.length == 1) {
                        $(".removeTextbox").removeClass('icon-close removeTextbox').addClass('icon-addnew addTextbox');
                        $('#divForAdd tr:eq(0)').find('td:eq(0) input.txtItem').val(value.ITName);
                        $('#divForAdd tr:eq(0)').find('td:eq(0) input.hdnItemID').val(value.ItemID);
                    } else {

                        var ind = index;
                        if (index == 0) { 
                            $('#divForAdd tr:eq(0)').find('td:eq(0) input.txtItem').val(value.ITName);
                            $('#divForAdd tr:eq(0)').find('td:eq(0) input.hdnItemID').val(value.ItemID);
                        } else {
                            if (index == len) {
                                $("#divForAdd").append("<tr><td><input type='text' class='txtItem'/><input type='hidden' class='hdnItemID'/><label class='sfLocale icon-addnew sfBtn addTextbox'/></td></tr>");
                                $('#divForAdd tr:eq(' + index + ')').find('td:eq(0) input.txtItem').val(value.ITName);
                                $('#divForAdd tr:eq(' + index + ')').find('td:eq(0) input.hdnItemID').val(value.ItemID);
                            } else {
                                $("#divForAdd").append("<tr><td><input type='text' class='txtItem'/><input type='hidden' class='hdnItemID'/><label class='sfLocale icon-close removeTextbox sfBtn '/></td></tr>");
                                $('#divForAdd tr:eq(' + index + ')').find('td:eq(0) input.txtItem').val(value.ITName);
                                $('#divForAdd tr:eq(' + index + ')').find('td:eq(0) input.hdnItemID').val(value.ItemID);
                            }
                        }
                    }
                });
            },

            saveGroupItem: function () {
                //var groupItem = new Array;
                var group = new Object;
                group.groupID = eventFunction.config.groupID;
                group.GroupName = $("#txtGroupName").val();
                group.GroupCode = $("#txtGroupCode").val();
                group.groupWithItem = [];
                $('#divForAdd tr').each(function () {
                    var ItemID = $(this).find('td').find('.hdnItemID').val();
                    group.groupWithItem.push({ 'ItemID': ItemID });
                });
                group.userName = p.userName;
                eventFunction.config.method = "saveGroupItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ group: group });
                if (eventFunction.config.updateGroup == 1)
                    eventFunction.config.ajaxCallMode = 18;
                else
                    eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.updateGroup = 0;
                eventFunction.config.groupID = 0;
            },


            GetItem: function () {
                eventFunction.config.method = "GetItemForSearch";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 13;
                eventFunction.ajaxCall(eventFunction.config);
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
                eventFunction.config.ajaxCallMode = 9;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetItemList: function () {
                eventFunction.config.method = "GetItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetInventoryList: function () {
                eventFunction.config.method = "GetItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 25;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindItemList: function (result) {
               datas = JSON.parse(result);
                $("#DivForItemlist").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableForItemList' class='sfGridwrapper display' cellspacing='0'><thead><tr><th style='width:40px;'>S.N.</th><th>Item Name</th><th>Category Name</th><th>Item Code</th><th>Cost Center</th><th style='display:none;'>Is Menu</th><th>Is Expirable</th><th style='display:none;'>Is Inventory</th><th class='edit-heading tdcenter'>View</th><th class='edit-heading tdcenter'>Edit</th><th class='delete-heading tdcenter'>Delete</th></tr></thead><tbody>";
                    $.each(datas, function (index, value) {
                        if (value.IsMenu == true) {
                            a++;
                            htmls += '<tr><td>' + a + '</td>';
                            htmls += '<td>' + value.ITName + '</td>';
                            htmls += '<td>' + value.ParentItem + '</td>';
                            htmls += '<td>' + value.ITCode + '</td>';
                            htmls += '<td>' + value.CostCenterName + '</td>';
                            htmls += '<td style="display:none;">' + value.IsMenu + '</td>';
                            htmls += '<td>' + value.IsExpirable + '</td>';
                            htmls += '<td style="display:none;">' + value.IsProdMaterial + '</td>';
                            htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="view icon-preview"/></td>';
                            //htmls += '<td>' + value.Details + '</td>';
                            //htmls += '<td><input type="button" id="' + value.ITId + '" class="ItemWithUnits" value="ItemWithUnits"/></td>';
                            htmls += '<td class="tdcenter"><label id="' + value.ITId + '+' + value.ITCode + '+' + value.ImagePath + '+' + value.IsMenu + '+' + value.IsExpirable + '+' + value.IsProdMaterial + '+' + value.IsUnitWiseRate + '+' + value.ItemCostCentreID + '+' + value.IsActive + '+' + value.SmallUnit + '+' + value.PITId + '+' + value.LargeUnit + '+' + value.Conversion + '+' + value.IsDefaultPurchaseUnit + '+' + value.IsDefaultSalesUnit + '+' + value.SRate + '+' + value.ValidFrom + '+' + value.Details + '+' + value.IsExtra + '"   class="edit icon-edit" value="Edit"/></td>';
                            htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="delete icon-delete"  value="Delete"/></td>';
                            htmls += '</tr>';
                        }
                    });
                    htmls += "</tbody></table>";
                    $("#DivForItemlist").html(htmls);
                    $("#tableForItemList").dataTable({
                        "bJQueryUI" : true,

                        columnDefs: [{ orderable: false, targets: [1, 3, 4, 5, 6, 7, 8, 9, 10] }]
                    });
                }
                $("#tableForItemList").on('click', '.view', function () {
                    var ids = $(this).attr('id');
                    var row = $(this).parents('tr');
                    htmls = "";

                    $("#DivForViewItemByID").html(htmls);
                    htmls += "<h5>Item Name : " + row.find('td:eq(1)').text();
                    htmls += "</h5> <h5>Category Name : " + row.find('td:eq(2)').text();
                    htmls += "</h5><h5>Item Code : " + row.find('td:eq(3)').text();
                    htmls += "</h5><h5 style='border-bottom:1px solid gainsboro;'>Cost Center :</b> " + row.find('td:eq(4)').text();
                    htmls += "</h5>"
                     $("#DivForViewItemByID").css('margin-top','0');
                    $("#DivForViewItemByID").html(htmls);
                    //console.log(ids);
                    eventFunction.config.method = "ViewItemByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ ids: ids });
                    eventFunction.config.ajaxCallMode = 17;
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

                $("#tableForItemList").on('click', '.edit', function () {

                    $("#btnAdd").hide();
                    $("#DivForItemlist").hide();
                    eventFunction.config.ItemIDUpdate = 1;
                    var row = $(this).parents('tr');
                    $('#txtItemName').val(row.find('td:eq(1)').text());

                    $('#SelCostCenter').val(row.find('td:eq(3)').text().split(' ')[0]);

                    var ids = $(this).attr('id');
                    var word = ids.split("+");

                    $("#txtItemCode").val(word[1]); 
                    $("#ImgPrvs").attr("src", "/Modules/ROI_Item/ImageItem/" + word[2]);
                    $("#txtImage").val(word[2]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();
                    $("#chkbxIsMenu").prop('checked', word[3] == "true" ? true : false);
                    if (word[3] == 'false')
                        $("#divForIngredient").hide();
                    $("#chkbxIsExpirable").prop('checked', word[4] == "true" ? true : false);
                    $("#chkbxIsProductMaterial").prop('checked', word[5] == "true" ? true : false);

                    $("#SelCostCenter").val(word[7]);
                    $("#chkbxIsActive").prop('checked', word[8] == "true" ? true : false);
                    $("#SelInvSmallunit").val(word[9]);
                    eventFunction.GetLargeUNIT(word[9]); 
                    $("#SelCategoryName").val(parseInt(word[10]));
             
                    $('#tableForSubtable tbody tr:eq(0)').find('td:eq(0) input').val(word[15]);
                    var valids = word[16].split(" ");
                    $('#tableForSubtable tbody tr:eq(0)').find('td:eq(1) input').val(valids[0]);
                    $('#txtDetails').val(word[17]);
                    $("#chkbxIsExtra").prop('checked', word[18] == "true" ? true : false);
                    if (word[18] == "true") {
                        $(".ForExtra").show();
                    } else {
                        $(".ForExtra").hide();
                    }

                    eventFunction.config.ItemID = word[0];
                    var ids = word[0];
                    eventFunction.config.method = "getDetails";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 10;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.method = "getIngredientByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 21;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.method = "getExtraItemByItemID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 24;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#roiitemtable').show(); 
                });
            },

            BindInventoryList: function (result) {
                datas = JSON.parse(result);
                $("#DivGetInventoryList").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableForInventoryList' class='sfGridwrapper display dataTable no-footer'><thead><tr><th style='width:40px;'>S.N.</th><th>Item Name</th><th>Category Name</th><th>Item Code</th><th>Cost Center</th><th>Is Expirable</th><th class='edit-heading'>View</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th></tr></thead><tbody>";
                    $.each(datas, function (index, value) {
                        if (value.IsProdMaterial == true) {
                            a++;
                            htmls += '<tr><td>' + a + '</td>';
                            htmls += '<td>' + value.ITName + '</td>';
                            htmls += '<td>' + value.ParentItem + '</td>';
                            htmls += '<td>' + value.ITCode + '</td>';
                            htmls += '<td>' + value.CostCenterName + '</td>';
                            htmls += '<td>' + value.IsExpirable + '</td>';
                            htmls += '<td><label id="' + value.ITId + '" class="view icon-preview"/></td>';
                            htmls += '<td><label id="' + value.ITId + '+' + value.ITCode + '+' + value.ImagePath + '+' + value.IsMenu + '+' + value.IsExpirable + '+' + value.IsProdMaterial + '+' + value.IsUnitWiseRate + '+' + value.ItemCostCentreID + '+' + value.IsActive + '+' + value.SmallUnit + '+' + value.PITId + '+' + value.LargeUnit + '+' + value.Conversion + '+' + value.IsDefaultPurchaseUnit + '+' + value.IsDefaultSalesUnit + '+' + value.SRate + '+' + value.ValidFrom + '+' + value.Details + '+' + value.IsExtra + '"   class="edit icon-edit" value="Edit"/></td>';
                            htmls += '<td><label id="' + value.ITId + '" class="delete icon-delete"  value="Delete"/></td>';
                            htmls += '</tr>';
                        }
                    });
                    htmls += "</tbody></table>";
                    $("#DivGetInventoryList").html(htmls);
                    $("#tableForInventoryList").dataTable({
                        "bJQueryUI": true,
                        columnDefs: [{ orderable: false, targets: [1, 3, 4, 5, 6, 7, 8] }]
                    });
                }
                $("#tableForInventoryList").on('click', '.view', function () {

                    var ids = $(this).attr('id');
                    var row = $(this).parents('tr');
                    htmls = "";

                    $("#DivForViewItemByID").html(htmls);
                    htmls += "<h5>Item Name : " + row.find('td:eq(1)').text();
                    htmls += "</h5> <h5>Category Name : " + row.find('td:eq(2)').text();
                    htmls += "</h5><h5>Item Code : " + row.find('td:eq(3)').text();
                    htmls += "</h5><h5>Cost Center :</b> " + row.find('td:eq(4)').text();
                    htmls += "</h5>"
                    $("#DivForViewItemByID").html(htmls);
                    eventFunction.config.method = "ViewItemByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ ids: ids });
                    eventFunction.config.ajaxCallMode = 17;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.method = "getstoreitemforstock";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 30;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#DivForViewItemByID').dialog(
                        {
                            'title': 'Item Rate with Valid Date',
                            "resize": "auto",
                            width: 400,
                            dialogClass: 'popup-titlebg',
                        });
                });

                $("#tableForInventoryList").on('click', '.delete', function () {
                    var ids = $(this).attr('id');

                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.DeleteItem(ids);
                        }
                    });
                });

                $("#tableForInventoryList").on('click', '.edit', function () {

                    $("#btnInventoryAdd").hide();
                    $("#DivGetInventoryList").hide();

                    eventFunction.config.ItemIDUpdate = 1;
                    var row = $(this).parents('tr');
                    $('#txtInvItemName').val(row.find('td:eq(1)').text());

                    $('#SelInvCostCenter').val(row.find('td:eq(3)').text().split(' ')[0]);

                    var ids = $(this).attr('id');
                    var word = ids.split("+");

                    $("#txtInvItemCode").val(word[1]);
                    $("#InvImgPrvs").attr("src", "/Modules/ROI_Item/ImageItem/" + word[2]);
                    $("#txtInvImage").val(word[2]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();
                    //$("#chkbxIsMenu").prop('checked', word[3] == "true" ? true : false);
                    //if (word[3] == 'false')
                    //    $("#divForIngredient").hide();
                    $("#chkbxInvIsExpirable").prop('checked', word[4] == "true" ? true : false);
                    //$("#chkbxIsProductMaterial").prop('checked', word[5] == "true" ? true : false);

                    $("#SelInvCostCenter").val(word[7]);
                    $("#chkbxInvIsActive").prop('checked', word[8] == "true" ? true : false);
                    $("#SelSmallunit").val(word[9]);
                    eventFunction.GetLargeUNIT(word[9]);
                    $("#SelInvCategoryName").val(parseInt(word[10]));
                    $('#tableForSubtable tbody tr:eq(0)').find('td:eq(0) input').val(word[15]);
                    var valids = word[16].split(" ");
                    $('#tableForSubtable tbody tr:eq(0)').find('td:eq(1) input').val(valids[0]);
                    $('#txtInvDetails').val(word[17]);
                    $("#chkbxIsExtra").prop('checked', word[18] == "true" ? true : false);
                    $("#txtMinStkQnty").val(word[19]);
                    if (word[18] == "true") {
                        $(".ForExtra").show();
                    } else {
                        $(".ForExtra").hide();
                    }

                    eventFunction.config.ItemID = word[0];
                    var ids = word[0];
                    eventFunction.config.method = "getDetails";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 10;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.method = "getIngredientByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 21;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.method = "getExtraItemByItemID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 24;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#addInventoryTable').show();
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

            BindViewStockItem: function (result) {

                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableForStockView' class='sfGridwrapper display dataTable no-footer'><thead><tr><th>S.N.</th><th>StoreName</th><th>Unit</th><th>Value</th></tr></thead><tbody>";
                    var valids = "";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.StName + '</td>';
                        htmls += '<td>' + value.UnitDescription + '</td>';
                        htmls += '<td>' + value.Value + '</td>';
                        htmls += '</tr>';
                    });
                    htmls += "</tbody></table>";
                    $("#DivForViewItemByID").append(htmls);
                    //$("#DivGetInventoryByID").append(htmls);
                    $("#tableForStockView").dataTable({
                        searching: false,
                        paging: false,
                        info: false,
                        ordering: false,
                    });
                }
                else {
                    $("#DivForViewItemByID").append("<br/>  No Data");

                }
            },

            BindItemWithUnitList: function (result) {
                var datas = result;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        eventFunction.config.countExtra++;
                        if (index == 0) {
                            $('#tableForSubtable tbody tr:eq(0)').find('td:eq(0) select').val(value.LargeUnit);
                            $('#tableForSubtable tbody tr:eq(0)').find('td:eq(1) input').val(value.Conversion);
                            $('#tableForSubtable tbody tr:eq(0)').find('td:eq(2) input').val(value.IsDefaultPurchaseUnit);
                            $('#tableForSubtable tbody tr:eq(0)').find('td:eq(3) input').val(value.IsDefaultSalesUnit);
                            $('#tableForSubtable tbody tr:eq(0)').find('td:eq(4) input').val(value.SalesRate);
                            $('#tableForSubtable tbody tr:eq(0)').find('td:eq(5) input').val(value.ValidFrom);
                        }
                        else {
                            $("#btnForNewRow").click();
                            $('#tableForSubtable tbody tr:eq(' + index + ')').find('td:eq(0) select').val(value.LargeUnit);
                            $('#tableForSubtable tbody tr:eq(' + index + ')').find('td:eq(1) input').val(value.Conversion);
                            $('#tableForSubtable tbody tr:eq(' + index + ')').find('td:eq(2) input').val(value.IsDefaultPurchaseUnit);
                            $('#tableForSubtable tbody tr:eq(' + index + ')').find('td:eq(3) input').val(value.IsDefaultSalesUnit);
                            $('#tableForSubtable tbody tr:eq(' + index + ')').find('td:eq(4) input').val(value.SalesRate);
                            $('#tableForSubtable tbody tr:eq(' + index + ')').find('td:eq(5) input').val(value.ValidFrom);
                        }
                    });
                }
            },

            BindExtraItem: function (result) {
                var datas = result;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {

                        if (index == 0) {
                            $('#tableForExtra tbody tr:eq(0)').find('td:eq(0) input').val(value.ExtraItem);
                            $('#tableForExtra tbody tr:eq(0)').find('td:eq(1) input').val(value.ExtraPrice);
                            $('#tableForExtra tbody tr:eq(0)').find('td:eq(2) input').prop('checked', value.IsActive);
                        }
                        else {
                            $("#btnForNewRowExtra").click();
                            $('#tableForExtra tbody tr:eq(' + index + ')').find('td:eq(0) input').val(value.ExtraItem);
                            $('#tableForExtra tbody tr:eq(' + index + ')').find('td:eq(1) input').val(value.ExtraPrice);
                            $('#tableForExtra tbody tr:eq(' + index + ')').find('td:eq(2) input').prop('checked', value.IsActive);
                        }
                    });
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
                        //htmls += '<td>' + "<img src='/images/edit.png' class='PurchaseEdit' id='" + value.StoreItemId + '+' + value.StName + '+' + value.UnitDescription + '+' + value.Value + '+' + value.StoreId + '+' + value.Unit + "' value='Edit'/>" + "_" + "<img src='/images/delete.png' class='PurchaseDelete'  id='" + value.StoreItemId + "' value='Delete'/>" + "</td>";
                        htmls += '<td>' + "<img src='/images/delete.png' class='PurchaseDelete'  id='" + value.StoreItemId + "' value='Delete'/>" + "</td>";

                        htmls += '</tr>';
                    });
                    $("#purchaseTempTable tbody").append(htmls);

                }

                //$(".PurchaseEdit").unbind('click').on('click', function () {

                //    $("#DivStoreItem").dialog({
                //        'title': 'Edit Items',
                //        width: 400,
                //        modal: true,
                //        dialogClass: 'headingbg',
                //        resizable: true,
                //        dialogClass: 'popup-titlebg'
                //    });
                //    var ids = $(this).attr('id');
                //    var word = ids.split("+"); 
                //    $("#SelStoreName").val(word[1]);
                //    $("#SelStoreName").attr(word[4]);

                //    $("#SelUnit").val(word[2]);
                //    $("#SelUnit").attr(word[5]);
                //    $("#txtValue").val(word[3]);
                //    $("#btnPurchaseAdd").val("Update");
                //    var row = $(this).closest('tr');
                //    row.remove();
                //});

                $(".PurchaseDelete").unbind('click').on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    row.remove();
                });

            },
            saveItems: function () {
                var itemArray = new Array;
                var itemObject = new Object;
                var costcenter = $("#SelCategoryName").find(':selected').attr('costCenter');
                itemObject.ITId = eventFunction.config.ItemID;
                itemObject.PITId = $("#SelCategoryName").val() == null ? 0 : $("#SelCategoryName").val();
                itemObject.ITName = $("#txtItemName").val();
                itemObject.ITCode = $("#txtItemCode").val() == "" ? $("#txtItemName").val() : $("#txtItemCode").val();
                itemObject.ImagePath = $("#txtImage").val();
                //itemObject.IsMenu = $("#chkbxIsMenu").is(":checked");
                itemObject.IsMenu = true;
                itemObject.IsExpirable = $("#chkbxIsExpirable").is(':checked');
                //itemObject.IsProdMaterial = $("#chkbxIsProductMaterial").is(':checked');
                itemObject.IsProdMaterial = false;
                itemObject.IsUnitWiseRate = false;
                itemObject.ItemCostCentreID = $("#SelCostCenter").val();
                //itemObject.ItemCostCentreID = parseInt(costcenter);
                itemObject.Details = $("#txtDetails").val();
                itemObject.IsActive = $("#chkbxIsActive").is(':checked');
                itemObject.SmallUnit = $("#SelInvSmallunit").val();
                //itemObject.IsExtra = $("#chkbxIsExtra").is(':checked');
                itemObject.AddedBy = SageFrameUserName;
                itemObject.IsExtra = $("#chkbxIsExtra").is(':checked');
                var unitArray = new Array;
                var unitObject = new Object;
                $("#tableForSubtable tbody tr").each(function (x, y) {
                    //unitObject.LargeUnit = $(this).find(".selLargeUnit").val();
                    //unitObject.Conversion = $(this).find(".txtConversion").val() == "" ? 1 : $(this).find(".txtConversion").val();
                    //var returnRequired = $(this).find('.CbxDefaultPurchaseUnit').is(':checked');
                    //unitObject.IsDefaultPurchaseUnit = $(this).find('.rdoDefaultPurchaseUnit').is(':checked');
                    //unitObject.IsDefaultSalesUnit = $(this).find('.rdoDefaultSaleUnit').is(':checked');
                    unitObject.SalesRate = parseFloat($(this).find(".sritemrate").val() == "" ? 0 : $(this).find(".sritemrate").val());
                    unitObject.ValidFrom = $(this).find(".Vitemrate").val();
                    unitObject.AddedBy = SageFrameUserName;

                    unitArray.push(unitObject);
                });
                var extra = $("#chkbxIsExtra").is(':checked');
                if ($("#chkbxIsExtra").is(':checked') == true) {
                    var extraArray = new Array;
                    var extraObject = new Object;

                    $("#tableForExtra tbody tr").each(function (x, y) {
                        extraObject.ExtraItem = $(this).find(".txtExtraItemName").val();
                        extraObject.ExtraPrice = $(this).find(".txtExtraIPrice").val();
                        extraObject.IsActive = $(".txtExtraIsActive").is(':checked');
                        extraObject.AddedBy = SageFrameUserName;
                        extraArray.push(extraObject);
                    });
                    itemObject.extradata = extraArray;
                }

                var extraItems = new Array;
                $('.ckbxExtraItem').each(function (i, obj) {
                    if ($(this).is(':checked')) {
                        var extra = new Object;
                        extra.ExtraItemID = $(this).attr('id').split('_')[0];
                        extraItems.push(extra);
                    }
                });



                var IngredientArray = new Array;
                $("#tableForIngredient tbody tr").each(function (x, y) {
                    if ($(this).find(".hdnIngredientID").val() != "") {
                        var IngredientObject = new Object;
                        IngredientObject.Ingredient = $(this).find(".hdnIngredientID").val();
                        IngredientObject.Quantity = $(this).find(".txtIngredientQuantity").val();
                        //
                        //IngredientObject.Quantity = $(this).find(".selIngredientUnit :selected").val();
                        //IngredientObject.Quantity = $(this).find(".selIngredientUnit :selected").attr('attr-conversion');
                        IngredientArray.push(IngredientObject);
                    }
                });
                itemObject.Ingredientdata = IngredientArray;

                itemObject.ItemWithUnit = unitArray;
                //console.log(itemObject);
                eventFunction.config.method = "saveItems";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ itemObject: itemObject, extraItemList: JSON.stringify(extraItems) });
                if (eventFunction.config.ItemIDUpdate == 1)
                    eventFunction.config.ajaxCallMode = 32;
                else
                    eventFunction.config.ajaxCallMode = 31;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ItemIDUpdate = 0;
                eventFunction.config.ItemID = 0;
                eventFunction.ResetAll();

            },

            saveInventoryItems: function () {

                var itemArray = new Array;
                var itemObject = new Object;
                var costcenter = $("#SelInvCategoryName").find(':selected').attr('costCenter');
                itemObject.ITId = eventFunction.config.ItemID;
                itemObject.PITId = $("#SelInvCategoryName").val() == null ? 0 : $("#SelInvCategoryName").val();
                itemObject.ITName = $("#txtInvItemName").val();
                itemObject.ITCode = $("#txtInvItemCode").val() == "" ? $("#txtInvItemName").val() : $("#txtInvItemCode").val();
                itemObject.ImagePath = $("#txtInvImage").val();
                //itemObject.IsMenu = $("#chkbxIsMenu").is(":checked");
                itemObject.IsMenu = false;
                itemObject.IsExpirable = $("#chkbxInvIsExpirable").is(':checked');
                //itemObject.IsProdMaterial = $("#chkbxIsProductMaterial").is(':checked');
                itemObject.IsProdMaterial = true;
                itemObject.IsUnitWiseRate = false;
                itemObject.ItemCostCentreID = $("#SelInvCostCenter").val();
                //itemObject.ItemCostCentreID = parseInt(costcenter);
                itemObject.Details = $("#txtInvDetails").val();
                itemObject.IsActive = $("#chkbxInvIsActive").is(':checked');
                itemObject.SmallUnit = $("#SelSmallunit").val();
                //itemObject.IsExtra = $("#chkbxIsExtra").is(':checked');
                itemObject.AddedBy = SageFrameUserName;
                itemObject.IsExtra = $("#chkbxIsExtra").is(':checked');


                var StoreItemArray = new Array;

                var MyRows = $('table#purchaseTempTable').find('tbody').find('tr');

                $('#purchaseTempTable tbody tr').each(function (x, y) {

                    var StoreItemObject = new Object;
                    StoreItemObject.StoreId = ($(y).find('td:eq(0)').attr('value'));
                    StoreItemObject.Unit = ($(y).find('td:eq(1)').attr('value'));
                    StoreItemObject.Value = ($(y).find('td:eq(2)').text());

                    StoreItemArray.push(StoreItemObject);
                });

                itemObject.storeitemstock = StoreItemArray;

                var unitArray = new Array;
                var unitObject = new Object;
                $("#tableForSubtable tbody tr").each(function (x, y) {

                    unitObject.SalesRate = parseFloat($(this).find(".sritemrate").val() == "" ? 0 : $(this).find(".sritemrate").val());
                    unitObject.ValidFrom = $(this).find(".Vitemrate").val();
                    unitObject.AddedBy = SageFrameUserName;

                    unitArray.push(unitObject);
                });



                var extra = $("#chkbxIsExtra").is(':checked');
                if ($("#chkbxIsExtra").is(':checked') == true) {
                    var extraArray = new Array;
                    var extraObject = new Object;

                    $("#tableForExtra tbody tr").each(function (x, y) {
                        extraObject.ExtraItem = $(this).find(".txtExtraItemName").val();
                        extraObject.ExtraPrice = $(this).find(".txtExtraIPrice").val();
                        extraObject.IsActive = $(".txtExtraIsActive").is(':checked');
                        extraObject.AddedBy = SageFrameUserName;
                        extraArray.push(extraObject);
                    });
                    itemObject.extradata = extraArray;
                }

                var extraItems = new Array;
                $('.ckbxExtraItem').each(function (i, obj) {
                    if ($(this).is(':checked')) {
                        var extra = new Object;
                        extra.ExtraItemID = $(this).attr('id').split('_')[0];
                        extraItems.push(extra);
                    }
                });



                var IngredientArray = new Array;
                $("#tableForIngredient tbody tr").each(function (x, y) {
                    if ($(this).find(".hdnIngredientID").val() != "") {
                        var IngredientObject = new Object;
                        IngredientObject.Ingredient = $(this).find(".hdnIngredientID").val();
                        IngredientObject.Quantity = $(this).find(".txtIngredientQuantity").val();


                        IngredientArray.push(IngredientObject);
                    }
                });
                itemObject.Ingredientdata = IngredientArray;

                itemObject.ItemWithUnit = unitArray;



                eventFunction.config.method = "saveInventoryItems";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ itemObject: itemObject, extraItemList: JSON.stringify(extraItems) });
                if (eventFunction.config.ItemIDUpdate == 1)
                    eventFunction.config.ajaxCallMode = 11;
                else
                    eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ItemIDUpdate = 0;
                eventFunction.config.ItemID = 0;
                eventFunction.ResetAll();

            },

            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
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

                //$(".PurchaseEdit").unbind('click').on('click', function () {                
                //    $("#DivStoreItem").dialog({
                //        'title': 'Edit Items',
                //        width: 400,
                //        modal: true,
                //        dialogClass: 'headingbg',
                //        resizable: true,
                //        dialogClass: 'popup-titlebg'
                //    });
                //    var ids = $(this).attr('id');
                //    var word = ids.split("+");
                //    $("#SelStoreName").val(word[1]);
                //    $("#SelStoreName").attr(word[0]);

                //    $("#SelUnit").val(word[3]);
                //    $("#SelUnit").attr(word[2]);
                //    $("#txtValue").val(word[4]);
                //    $("#btnPurchaseAdd").val("Update");
                //    var row = $(this).closest('tr');
                //        row.remove();

                //});

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
                $("#SelInvCostCenter").html('');
                if (datas.length > 0) {
                    var htmls = '';
                   htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        if (value.CostCenterID == 1)
                            htmls += "<option value='" + value.CostCenterID + "' selected='selected'>" + value.CostCenterName + "</option>";
                        else
                            htmls += "<option value='" + value.CostCenterID + "'>" + value.CostCenterName + "</option>";
                    });
                    $("#SelCostCenter").html(htmls);
                    $("#SelInvCostCenter").html(htmls);
                }
            },

            GetCategoryName: function () {
                eventFunction.config.method = "GetCategoryName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ IsMenu: true });;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindCategoryName: function (result) {
                datas = JSON.parse(result);
                $("#SelCategoryName").html('');
                $("#SelInvCategoryName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "' costCenter='" + value.ItemCostCentreID + "'>" + value.ITName + "</option>";
                    });
                    $("#SelCategoryName").html(htmls);
                    $("#SelInvCategoryName").html(htmls);
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
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindSmalUNIT: function (result) {
                datas = JSON.parse(result);
                $("#SelSmallunit").html('');
                $("#SelInvSmallunit").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });
                    $("#SelSmallunit").html(htmls);
                    $("#SelInvSmallunit").html(htmls);
                    //eventFunction.GetLargeUNIT();
                }

            },
            GetLargeUNIT: function (unit) {
                eventFunction.config.method = "GetUNITbySmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ unit: unit });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindLargeUNIT: function (result) {
                datas = JSON.parse(result);
                var htmls = "";
                $(".selLargeUnit").html('');
                $("#SelUnit").html('');
                // htmls = "<option value='' disabled selected>-Select-</option>";
                htmls += '<option value="' + $("#SelSmallunit").val() + '"> ' + $("#SelSmallunit option:selected").text() + ' </option>';
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });
                }
                $(".selLargeUnit").html(htmls);
                $("#SelUnit").html(htmls);

            },

            GetUNIT: function () {
                eventFunction.config.method = "GetAllUnitforItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            Getitem: function () {
                eventFunction.config.method = "GetPareintItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
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

            uploadInvImage: function () {
                var fileUpload = $("#fileInvImage").get(0);
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
                        alert(err.statusText)
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

            readinvURL: function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#InvImgPrvs').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>


            //BindItemDetails
            BindDropdownUnit: function (result) {
                var datas = result.d;

                $(".DropdownUnit").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });

                    $(".DropdownUnit").html(htmls);
                }

            },
            BindDropdownItem: function (result) {
                var datas = result.d;

                $("#ddlParentITem").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });

                    $("#ddlParentITem").html(htmls);
                }

            },
            BindExtraItemsList: function (result) {
                datas = JSON.parse(result);
                $("#extraLists").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    $.each(datas, function (index, value) {
                        htmls += "<div class='extra-listtype' style='width:20%;display:inline-block;'><input type='checkbox' class='ckbxExtraItem' id='" + value.ExtraItemID + "_" + value.ExtraPrice + "'> <label for='" + value.ExtraItemID + "_" + value.ExtraPrice + "'>" + value.ExtraItem + "(Rs. " + value.ExtraPrice + ")</label></div>";
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
                $("#txtInvItemName").val("");
                $("#txtInvItemCode").val("");
                $("#txtInvImage").val("");
                $("#fileInvImage").val("");
                $("#InvImgPrvs").removeAttr('src');
                $("#chkbxInvIsExpirable").attr("checked", false);
                $("#SelInvCostCenter").val("");
                $("#txtInvDetails").val("");
                $("#chkbxInvIsActive").attr('checked', true);
                $("#SelInvSmallunit").val("");
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
                debugger;
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
                $("#tableForIngredient").append('<tr><td> <input type="text" class="txtIngredient sfInputbox" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td><td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>');
                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
                    }
                }); 
            },
            ResetGroup: function () {
                eventFunction.config.updateGroup = 0;
                eventFunction.config.groupID = 0;
                $("#txtGroupName").val("");
                $("#txtGroupCode").val("");
                $("#divForAdd tr").remove();
                $("#divForAdd").append("<tr><td><input type='text' class='txtItem'/><input type='hidden' class='hdnItemID' /><label class='icon-close sfBtn removeTextbox'/></td></tr>");
                $(".txtItem").autocomplete({
                    source: AutocompleteItem,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnItemID').val(ui.item.id);
                    }
                });
            },
            Reload: function () {
                $("#btnInventoryAdd").show();
                eventFunction.GetInventoryList();
                eventFunction.ResetAll();
                $("#btnInventoryAdd").show();
                $("#DivGetInventoryList").show();
                $("#addInventoryTable").hide();
                $("#purchaseTempTable tbody tr").remove();
                var row = $("#purchaseTempTable tbody").closest('tr');
                row.remove();
                eventFunction.config.ItemID = 0;
                eventFunction.config.ItemIDUpdate = 0;

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

                        SelInvSmallunit: {
                            required: true,
                        },

                        //txtConversion: {
                        //    required: true,
                        //},

                        //sritemrate: {
                        //    required: true,
                        //    number: true
                        //},

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