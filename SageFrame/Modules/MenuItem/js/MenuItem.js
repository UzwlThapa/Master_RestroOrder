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
        var AutocompleteIngredient = [];
        var htmls = "";
        var number = 0;
        var numbers = 0;
        var PurchaseArray = [];
        var itemlist = '';
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
                eventFunction.GetInventoryItem();
                eventFunction.GetCategoryName();
                eventFunction.GetCostCenter();
                eventFunction.GetSmallUNIT();
                eventFunction.GetExtraItemsList();
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnAdd").click(function () {
                    $("#btnAdd, #btnExcel").hide();
                    $("#DivForItemlist").hide();
                    $("#roiitemtable").show();                                    
                });

                $("#SelCategoryName").on('change', function () {
                    if ($("#txtItemName").val().length > 2) {
                        $("#txtItemName").change();
                    }
                });

                $("#txtItemName").on('change',function () {
                    var item = $("#txtItemName").val();
                    var category = $("#SelCategoryName").val();
                    eventFunction.config.method = "CheckItemExistence";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ item: item, categoryid: category });
                    eventFunction.config.ajaxCallMode = 4;
                    eventFunction.ajaxCall(eventFunction.config);
                });

                $("#fileImage").change(function () {
                    var path = $('input[type=file]').val();
                    var filename = path.replace(/^.*\\/, "");
                    $("#txtImage").val(filename);
                    eventFunction.readURL(this);
                });


                $("#saveItems").on('click', function () {
                    $('#btnExcel').show();
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.uploadImage();
                        eventFunction.saveItems();
                    }          
                });
                $("#CancelItems").click(function () {
                    eventFunction.ResetAll();
                    $("#DivForItemlist , #btnExcel").show();
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

                $("#tableForIngredient").on("click", ".addTextboxIngredient", function () {
                    $(".addTextboxIngredient").unbind('click');
                    if ($(this).closest('tr').find('td .txtIngredient').val() != "" && $(this).closest('tr').find('td .txtIngredientQuantity').val()) {
                        $(".addTextboxIngredient").removeClass('icon-addnew addTextboxIngredient').addClass('icon-close removeTextboxIngredient');
                        var input = '<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="sfInputbox txtIngredientQuantity" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient restro-btn"></label></td></tr>';
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

                $("#tableForIngredient").on("click", ".removeTextboxIngredient", function (x, y) {
                    var IngredientID = $(this).closest('tr').find('td .hdnIngredientID').val();
                    var ItemID = $(this).closest('tr').find('td .hdnItemID').val();
                    if (ItemID != "") {
                        eventFunction.config.method = "DeleteIngredientItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ IngredientID: IngredientID, ItemID: ItemID });
                        eventFunction.config.ajaxCallMode = 9;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    $(this).closest('tr').remove();
                });
                $('#btnExcel').on('click', function () {
                    if (itemlist.length > 0) {
                        var items = JSON.parse(itemlist);
                        var htmls = '';
                        htmls += "<table><thead><tr><th>Item</th><th>Category</th><th>Rate</th><th>Unit</th><th>UnitSymbol</th><th>CostCenter</th></tr></thead><tbody>";
                        for (var i = 0; i < items.length;i++){
                            if (items[i].IsMenu == true) {
                                htmls += '<tr>';
                                htmls += '<td>' + items[i].ITName + '</td>';
                                htmls += '<td>' + items[i].ParentItem + '</td>';
                                htmls += '<td>' + items[i].SRate + '</td>';
                                htmls += '<td>' + items[i].dsunitparticular + '</td>';
                                htmls += '<td>' + items[i].MunitParticulars + '</td>';
                                htmls += '<td>' + items[i].CostCenterName + '</td>';
                                //htmls += '<td style="display:none;">' + value.IsProdMaterial + '</td>';
                                //htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="view icon-preview"/></td>';
                                //htmls += '<td class="tdcenter"><label id="' + value.ITId + '+' + value.ITCode + '+' + value.ImagePath + '+' + value.IsMenu + '+' + value.IsExpirable + '+' + value.IsProdMaterial + '+' + value.IsUnitWiseRate + '+' + value.ItemCostCentreID + '+' + value.IsActive + '+' + value.SmallUnit + '+' + value.PITId + '+' + value.LargeUnit + '+' + value.Conversion + '+' + value.IsDefaultPurchaseUnit + '+' + value.IsDefaultSalesUnit + '+' + value.SRate + '+' + value.ValidFrom + '+' + value.Details + '+' + value.IsExtra + '"   class="edit icon-edit" value="Edit"/></td>';
                                //htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="delete icon-delete"  value="Delete"/></td>';
                                htmls += '</tr>';
                            }

                        }
                        htmls += "</tbody></table>";
                        let file = new Blob([htmls], { type: "application/vnd.ms-excel" });
                        let url = URL.createObjectURL(file);
                        let a = $("<a />", {
                            href: url,
                            download: "Items.xls"
                        }).appendTo("body").get(0).click();
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
                        itemlist = data.d;
                        eventFunction.BindItemList(data.d);
                        break;
                    case 1:
                        eventFunction.BindViewItemByID(data.d);
                        break;
                    case 2:                
                        jAlert('Deleted Successfully!', 'Information!!');
                        eventFunction.GetItemList();
                        break;
                    case 3:
                        eventFunction.BindCategoryName(data.d);
                        break;
                    case 4:
                        eventFunction.BindCheckItemExistence(data.d);
                        break;
                    case 5:
                        eventFunction.BindCostCenter(data.d);
                        break;

                    case 6:
                        eventFunction.BindSmalUNIT(data.d);
                        break;
                    case 7:
                        eventFunction.BindDropdwonUnit(data.d);
                        break;
                    case 8:
                        eventFunction.BindinventoryItem(data.d);
                        break;
                    case 9:
                        break;
                    case 10:
                        eventFunction.BindExtraItemsList(data.d);
                        break;
                    case 11:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        eventFunction.GetItemList();
                        break;
                    case 12:
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        eventFunction.GetItemList();
                        break;
                    case 13:
                        eventFunction.BindIngredientByID(data.d);
                        break;
                    case 14:
                        if (data.d.length > 0) {
                            $.each(data.d, function (index, value) {
                                $('#' + value.ExtraItemID + '_' + value.ExtraPrice).prop('checked', true);
                            });
                        }
                        break;
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            GetItemList: function () {
                eventFunction.config.method = "GetItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            DeleteItem: function (id) {
                username = SageFrameUserName;
                eventFunction.config.method = "DeleteItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ Itemid: id, userName: username });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCategoryName: function () {
                eventFunction.config.method = "GetCategoryName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetSmallUNIT: function () {
                eventFunction.config.method = "getOnlySmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetUnitOfItemByID: function (ids) {
                eventFunction.config.method = "GetUnitOfItemByID";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ ids: ids });
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetInventoryItem: function () {
                eventFunction.config.method = "GetInventoryItemWithSmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetExtraItemsList: function () {
                eventFunction.config.method = "GetExtraItemsList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);

            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

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

            BindinventoryItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        AutocompleteIngredient.push({ label: value.ITName + ", " + value.Symbol, id: value.ITId });
                    });
                }
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

            BindCostCenter: function (result) {
                datas = JSON.parse(result);
                $("#SelCostCenter").html('');
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
                   
                }
            },

            BindSmalUNIT: function (result) {
                datas = JSON.parse(result);
                $("#SelInvSmallunit").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });                
                    $("#SelInvSmallunit").html(htmls);
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

            BindItemList: function (result) {
                datas = JSON.parse(result);
                $("#DivForItemlist").show();
                $("#DivForItemlist").html('');
                var htmls = '';
                htmls += "<table id='tableForItemList' class='sfGridwrapper display' cellspacing='0'><thead><tr><th style='width:40px;'>S.N.</th><th>Item Name</th><th>Item Code</th><th>Cost Center</th><th style='display:none;'>Is Menu</th><th>Is Expirable</th><th>Rate</th><th style='display:none;'>Is Inventory</th><th class='edit-heading tdcenter'>View</th><th class='edit-heading tdcenter'>Edit</th><th class='delete-heading tdcenter'>Delete</th></tr></thead><tbody>";
                if (datas.length > 0) {                   
                    var a = 0;
                    $.each(datas, function (index, value) {
                        if (value.IsMenu == true) {
                            a++;
                            htmls += '<tr><td>' + a + '</td>';
                            htmls += '<td>' + value.ItemName + '</td>';
                            // htmls += '<td>' + value.ParentItem + '</td>';                       
                            htmls += '<td>' + value.ITCode + '</td>';
                            htmls += '<td>' + value.CostCenterName + '</td>';
                            if (value.IsCategory == false) {                          
                            htmls += '<td style="display:none;">' + value.IsMenu + '</td>';
                            htmls += '<td>' + value.IsExpirable + '</td>';
                            htmls += '<td>' + value.SRate + '</td>';
                            htmls += '<td style="display:none;">' + value.IsProdMaterial + '</td>';
                                htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="view icon-preview"/></td>';
                                htmls += '<td class="tdcenter"><label id="' + value.ITId + '+' + value.ITCode + '+' + value.ImagePath + '+' + value.IsMenu + '+' + value.IsExpirable + '+' + value.IsProdMaterial + '+' + value.IsUnitWiseRate + '+' + value.ItemCostCentreID + '+' + value.IsActive + '+' + value.SmallUnit + '+' + value.PITId + '+' + value.LargeUnit + '+' + value.Conversion + '+' + value.IsDefaultPurchaseUnit + '+' + value.IsDefaultSalesUnit + '+' + value.SRate + '+' + value.ValidFrom + '+' + value.Details + '+' + value.IsExtra + '+' + value.ITName + '+' + value.CostCenterName + '+' + value.IsTaxable + '" class="edit icon-edit" value="Edit"/></td>';
                            htmls += '<td class="tdcenter"><label id="' + value.ITId + '" class="delete icon-delete"  value="Delete"/></td>';
                            }
                            else {
                                htmls += '<td></td>';
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
                        columnDefs: [{ orderable: false, targets: [1, 3, 4, 5, 6, 7, 8, 9, 10] }]
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
                    eventFunction.config.method = "ViewItemByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ ids: ids });
                    eventFunction.config.ajaxCallMode = 1;
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
                    $("#btnAdd ,#btnExcel").hide();
                    $("#DivForItemlist").hide();
                    eventFunction.config.ItemIDUpdate = 1;
                    var row = $(this).parents('tr');
                   // $('#SelCostCenter').val(row.find('td:eq(3)').text().split(' ')[0]);
                    var ids = $(this).attr('id');
                    var word = ids.split("+");
                    $('#SelCostCenter').val(word[20].split(' ')[0]);
                    $('#txtItemName').val(word[19]);
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
                    $("#chkbxIsTaxable").prop('checked', word[21] == "true" ? true : false);
                    $("#SelInvSmallunit").val(word[9]);
                    $("#SelCategoryName").val(parseInt(word[10]));

                    $('#tableForSubtable tbody tr:eq(0)').find('td:eq(0) input').val(word[15]);
                    var valids = word[16].split(" ");
                    $('#tableForSubtable tbody tr:eq(0)').find('td:eq(1) input').val(valids[0]);
                    //$('#txtDetails').val(word[17]);
                    CKEDITOR.instances['txtDetails'].setData(word[17]);
                    $("#chkbxIsExtra").prop('checked', word[18] == "true" ? true : false);
                    if (word[18] == "true") {
                        $(".ForExtra").show();
                    } else {
                        $(".ForExtra").hide();
                    }

                    eventFunction.config.ItemID = word[0];
                    var ids = word[0];
           
                    eventFunction.config.method = "getIngredientByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 13;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.method = "getExtraItemByItemID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.ajaxCallMode = 14;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#roiitemtable').show();
            
                });
            },

            BindViewItemByID: function (result) {
                datas = JSON.parse(result);
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
                    $("#tableForViewItemByID").dataTable({
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
            saveItems: function () {
                var itemArray = new Array;
                var itemObject = new Object;
                var costcenter = $("#SelCategoryName").find(':selected').attr('costCenter');
                itemObject.ITId = eventFunction.config.ItemID;
                itemObject.PITId = $("#SelCategoryName").val() == null ? 0 : $("#SelCategoryName").val();
                itemObject.ITName = $("#txtItemName").val();
                itemObject.ITCode = $("#txtItemCode").val() == "" ? $("#txtItemName").val() : $("#txtItemCode").val();
                itemObject.ImagePath = $("#txtImage").val();
                itemObject.IsMenu = true;
                itemObject.IsExpirable = $("#chkbxIsExpirable").is(':checked');
                itemObject.IsProdMaterial = false;
                itemObject.IsUnitWiseRate = false;
                itemObject.ItemCostCentreID = $("#SelCostCenter").val();
                itemObject.Details = CKEDITOR.instances['txtDetails'].getData();
                itemObject.IsActive = $("#chkbxIsActive").is(':checked');
                itemObject.IsTaxable = $("#chkbxIsTaxable").is(':checked');
                itemObject.SmallUnit = $("#SelInvSmallunit").val();
                itemObject.AddedBy = SageFrameUserName;
                itemObject.IsExtra = $("#chkbxIsExtra").is(':checked');
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

                eventFunction.config.method = "saveItems";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ itemObject: itemObject, extraItemList: extraItems });
                if (eventFunction.config.ItemIDUpdate == 1)
                    eventFunction.config.ajaxCallMode = 12;
                else
                    eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ItemIDUpdate = 0;
                eventFunction.config.ItemID = 0;
               

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
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>
            ResetAll: function () {
               
                eventFunction.config.ItemID = 0;
                eventFunction.config.ItemIDUpdate = 0;
                $("#SelCategoryName").val("");
                $("#txtItemName").val("");
                $("#txtItemCode").val("");
                $("#txtImage").val("");
                $("#fileImage").val("");
                $("#ImgPrvs").removeAttr('src');
             
                $(".ajax-file-upload").show();
                $(".ajax-file-upload-statusbar").hide();
                CKEDITOR.instances['txtDetails'].setData("");
                $("#chkbxIsExpirable").attr("checked", false);
                $("#SelCostCenter").val("");
                $(".sritemrate").val('0');
                $("#chkbxIsActive").attr('checked', true);
                $("#chkbxIsTaxable").attr('checked', true);
                $("#btnAdd").show();
                $("#roiitemtable").hide();
                $("#tableForIngredient tbody tr").remove();
                $("#tableForIngredient").append('<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td><td><input type="text" class="sfInputbox txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew restro-btn sfBtn addTextboxIngredient"></label></td></tr>');
                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
                    }
                });
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
                        SelCostCenter:
                            {
                                required: true,
                            },

                        SelSmallunit: {
                            required: true,
                        },

                        sritemrate: {
                            required: true,
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