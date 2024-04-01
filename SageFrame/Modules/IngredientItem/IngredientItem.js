function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;
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
                eventFunction.GetInventoryList();
                eventFunction.GetCategoryName();
                eventFunction.GetCostCenter();
                eventFunction.GetSmallUNIT();
                eventFunction.GetStore();
            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnInventoryAdd").click(function () {
                    $("#btnInventoryAdd").hide();
                    $("#DivGetInventoryList").hide();
                    $("#addInventoryTable").show();
                    
                });

                $("#txtInvItemName").change(function () {                
                    var item = $("#txtInvItemName").val();
                    eventFunction.config.method = "CheckItemExistenceForInventory";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ item: item });
                    eventFunction.config.ajaxCallMode = 4;
                    eventFunction.ajaxCall(eventFunction.config);
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
                        width: 300,
                        modal: true,
                        dialogClass: 'headingbg',
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                    $("#btnPurchaseAdd").val("Add");

                });

                $("#SelSmallunit").change(function () {
                    eventFunction.GetLargeUNIT($("#SelSmallunit").val());
                });

                $("#btnPurchaseAdd").on('click', function () {
                    var store = $("#SelStoreName").val();
                    var unit = $("#SelUnit").val();
                    var quantity = $("#txtValue").val();

                    if (store == null) {
                        jAlert("Please Fill The Store Name", 'Alert!!', function () { $.alerts.dialogClass = null; });
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
                $("#saveInvItems").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.uploadInvImage();
                        eventFunction.saveInventoryItems();
                    }
                });

                $("#CancelInvItems").click(function () {
                  
                    eventFunction.ResetAll();
                    $("#DivGetInventoryList").show();
                   
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
                        window.localStorage.setItem('ingredientsList', data.d);
                        eventFunction.BindInventoryList(data.d);
                        break;
                    case 1:
                        eventFunction.BindCategoryName(data.d);
                        break;
                    case 2:
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 3:
                        eventFunction.BindSmalUNIT(data.d);
                        break;
                    case 4:
                        eventFunction.BindCheckItemExistence(data.d);
                        break;
                    case 5:
                        eventFunction.BindStore(data.d);
                        break;
                    case 6:
                        eventFunction.BindLargeUNIT(data.d);
                        break;
                    case 7:
                        jAlert('Saved Successfully!', 'Information!!');
                        eventFunction.ResetAll();
                        eventFunction.GetInventoryList();
                        break;
                    case 8:  
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        eventFunction.GetInventoryList();
                        break;

                    case 9:
                        eventFunction.BindViewStockItem(data);
                        break;
                    case 10:
                        jAlert('Deleted Successfully!', 'Information!!');
                        eventFunction.GetInventoryList();
                        break;
                    case 11:
                   
                        eventFunction.BindExtraItem(data.d.extra);
                        eventFunction.Bindstoreitem(data.d.storeitemstock);

                        break;
                }
            },
            //<<-----------------------------Post & Get Here ---------------------------------------->>
            DeleteItem: function (id) {
                username = SageFrameUserName;
                eventFunction.config.method = "DeleteItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ Itemid: id, userName: username });
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetLargeUNIT: function (unit) {
                eventFunction.config.method = "GetUNITbySmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ unit: unit });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetStore: function () {
                eventFunction.config.method = "getIssueToDDlHirerchy";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);

            },
            GetSmallUNIT: function () {
                eventFunction.config.method = "getOnlySmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCategoryName: function () {
                eventFunction.config.method = "GetCategoryName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ IsMenu: false });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetInventoryList: function () {
                eventFunction.config.method = "GetInventoryItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
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
                itemObject.IsMenu = false;
                itemObject.IsExpirable = $("#chkbxInvIsExpirable").is(':checked');
                itemObject.IsProdMaterial = true;
                itemObject.IsUnitWiseRate = false;
                itemObject.ItemCostCentreID = $("#SelInvCostCenter").val();
                itemObject.Details = $("#txtInvDetails").val();
                itemObject.IsActive = $("#chkbxInvIsActive").is(':checked');
                itemObject.SmallUnit = $("#SelSmallunit").val();
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
                eventFunction.config.data = JSON2.stringify({ itemObject: itemObject, extraItemList: extraItems });
                if (eventFunction.config.ItemIDUpdate == 1)
                    eventFunction.config.ajaxCallMode = 8;
                else
                    eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ItemIDUpdate = 0;
                eventFunction.config.ItemID = 0;
                

            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>>
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

                $(".PurchaseDelete").unbind('click').on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    row.remove();
                });

            },

            BindLargeUNIT: function (result) {
                datas = JSON.parse(result);
                var htmls = "";
                $("#SelUnit").html('');
                htmls += '<option value="' + $("#SelSmallunit").val() + '"> ' + $("#SelSmallunit option:selected").text() + ' </option>';
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });
                }
                $("#SelUnit").html(htmls);

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

            BindCheckItemExistence: function (result) {
           
                datas = JSON.parse(result);
                var htmls = '';
                if (datas.length > 0) {
                    jAlert("Alert! Item Name: " + $("#txtInvItemName").val() + " is Already Saved", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    $("#txtInvItemName").val("");
                    $('#txtInvItemName').focus();
                }
                else {
                    $("#txtInvItemCode").attr("placeholder", $("#txtInvItemName").val());
                }
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

            BindCostCenter: function (result) {
                datas = JSON.parse(result);
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
                    $("#SelInvCostCenter").html(htmls);
                }
            },


            BindCategoryName: function (result) {
      
                datas = JSON.parse(result);
                $("#SelInvCategoryName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "' costCenter='" + value.ItemCostCentreID + "'>" + value.ITName + "</option>";
                    });
                    $("#SelInvCategoryName").html(htmls);
                }
            },


            BindInventoryList: function (result) {
                datas = JSON.parse(result);
                $("#DivGetInventoryList").show();
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
                        "lengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                        "pageLength": 20,
                        columnDefs: [{ orderable: false, targets: [1, 3, 4, 5, 6, 7, 8] }]
                    });
                }
                $("#tableForInventoryList").on('click', '.view', function () {

                    var ids = $(this).attr('id');
                    var row = $(this).parents('tr');
                    htmls = "";

                    $("#DivForViewItemByID").html(htmls);
                    htmls += "<p style='margin:0;'>Item Name : " + row.find('td:eq(1)').text();
                    htmls += "</p> <p style='margin:0;'>Category Name : " + row.find('td:eq(2)').text();
                    htmls += "</p><p style='margin:0;'> Item Code : " + row.find('td:eq(3)').text();
                    htmls += "</p><p style='border-bottom:1px solid gainsboro;margin:0;'>Cost Center :</b> " + row.find('td:eq(4)').text();
                    htmls += "</p>"
                    $("#DivForViewItemByID").html(htmls);


                    eventFunction.config.method = "getstoreitemforstock";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 9;
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

                    $('#SelInvCategoryName').val(row.find('td:eq(3)').text().split(' ')[0]);

                    var ids = $(this).attr('id');
                    var word = ids.split("+");

                    $("#txtInvItemCode").val(word[1]);
                    $("#InvImgPrvs").attr("src", "/Modules/ROI_Item/ImageItem/" + word[2]);
                    $("#txtInvImage").val(word[2]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();
                 
                    $("#chkbxInvIsExpirable").prop('checked', word[4] == "true" ? true : false);
                 
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
              

                    eventFunction.config.ItemID = word[0];
                    var ids = word[0];
                    eventFunction.config.method = "getDetails";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 11;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#addInventoryTable').show();
                });
            },


            BindViewStockItem: function (result) {

                var datas = result.d;
                var htmls = '';
                var a = 0;
                htmls += "<table id='tableForStockView' class='sfGridwrapper display dataTable no-footer'><thead><tr><th>S.N.</th><th>StoreName</th><th>Unit</th><th>Value</th></tr></thead><tbody>";
                if (datas.length > 0) {

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
            AddPurchase: function () {

                var table = $("#purchaseTempTable");
                var rows = table.find("tr.tableItem");

                var htmls = '';
                $("#AddTempTable").show();
                $("#btnPurchaseSave").show();
                number += 1;
                htmls += "<tr class='tableItem'>";
                htmls += "<td class='storeId' value='" + $("#SelStoreName").val() + "'>" + $("#SelStoreName :selected").text() + "</td>";
                htmls += "<td class='Unit' value='" + $("#SelUnit").val() + "'>" + $("#SelUnit :selected").text() + "</td>";
                htmls += "<td class='Value'>" + $("#txtValue").val() + "</td>";            
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
            //<<-----------------------------------Reset & Validation ------------------------------------->>>
            ResetAll: function () {
               
                eventFunction.config.ItemID = 0;
                eventFunction.config.ItemIDUpdate = 0;
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
                $("#SelSmallunit").val("");
             
                $(".ajax-file-upload").show();
                $(".ajax-file-upload-statusbar").hide();
  
                $('.ckbxExtraItem').prop("checked", false);
            
                $("#chkbxIsExpirable").attr("checked", false);
             
                $("#chkbxIsActive").attr('checked', true);

                unitArray = [];
                unitObject = {};
                $(".selLargeUnit").val("");
                $(".txtConversion").val("");
              
                $(".sritemrate").val("");

                $("#btnInventoryAdd").show();

                $("#DivGetInventoryList").show();
                $("#addInventoryTable").hide();
                $("#purchaseTempTable tbody tr").remove();
                var row = $("#purchaseTempTable tbody").closest('tr');
                row.remove();
                
          
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                    
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