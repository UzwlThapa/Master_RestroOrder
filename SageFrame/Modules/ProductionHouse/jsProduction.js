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
                ModulePath: '/Modules/ProductionHouse/',
                userName: ''
            }, p);
        var v = 0;
        var i = 2;
        var AutocompleteIngredient = [];
        var PreviousProduction = [];
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
                baseURL: p.ModulePath + "ProductionHouse.asmx/",
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

                eventFunction.GetInventoryItem();
                eventFunction.GetStore();
                eventFunction.GetPreviousProduction();
            },
            init: function () {

                eventFunction.InitialSetup();



                $('#btnSave').on('click', function () {

                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        var value = $('.txtIngredient').filter(function () {
                            return $(this).val() == '';
                        });
                        var quantity = $('.txtIngredientQuantity').filter(function () {
                            return $(this).val() == '';
                        });
                        var unit = $('.txtiUnit').filter(function () {
                            return $(this).val() == '';
                        });


                        if (value.length > 0) {
                            jAlert("Please! Fill Add ingredient.", 'Alert!!');
                        }

                        else if (quantity.length > 0) {
                            jAlert("Please! Fill quantity .", 'Alert!!');
                        }
                        else if (unit.length > 0) {
                            jAlert("Please! Fill valid item .", 'Alert!!');
                        }

                        else {
                            eventFunction.SaveProduction();
                        }
                    }
                });



                $('#btnCancel').on('click', function () {
                    eventFunction.ResetAll();
                });

                $("#tableForIngredient").on("click", ".addTextboxIngredient", function () {
                    if ($(this).closest('tr').find('td .txtIngredient').val() != "" && $(this).closest('tr').find('td .txtIngredientQuantity').val()) {
                        $(".addTextboxIngredient").removeClass('icon-addnew addTextboxIngredient').addClass('icon-close removeTextboxIngredient');
                        var input = '<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 200px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="sfInputbox txtIngredientQuantity" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td> <td><input type="text" class="sfInputbox txtiUnit" style="width: 100px;" readonly/><input type="hidden" class="sfInputbox hdUnit" /></td><td><label class="sfLocale icon-addnew sfBtn restro-btn  addTextboxIngredient"></label></td></tr>';
                        $("#tableForIngredient").append(input);
                        $('.txtIngredient').each(function () {
                            $(this).autocomplete({
                                source: AutocompleteIngredient,
                                delay: 0,
                                select: function (event, ui) {
                                    event.preventDefault();
                                    $(this).parents("tr").find('.txtIngredient').val(ui.item.label);
                                    $(this).parents("tr").find('.hdnIngredientID').val(ui.item.id);
                                    $(this).parents("tr").find('.txtiUnit').val(ui.item.unit);
                                    $(this).parents("tr").find('.hdUnit').val(ui.item.unitid);

                                }
                            });
                        });
                    } else {
                        jAlert('Please! Fill the empty box!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#tableForIngredient").on("click", ".removeTextboxIngredient", function (x, y) {
                    var IngredientID = $(this).closest('tr').find('td .hdnIngredientID').val();
                    var ItemID = $(this).closest('tr').find('td .hdnItemID').val();
                    if (ItemID != "") {
                        eventFunction.config.method = "DeleteIngredientItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ IngredientID: IngredientID, ItemID: ItemID });
                        eventFunction.config.ajaxCallMode = 1;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                    $(this).closest('tr').remove();
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
                        eventFunction.BindinventoryItem(data.d);
                        break;
                    case 1:

                        break;
                    case 2:
                        eventFunction.BindStore(data.d);
                        break;
                    case 3:
                        jAlert('Item Produced Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.ResetAll();
                        break;
                    case 4:
                        eventFunction.BindPreviousProduction(data.d);
                        break;
                    case 5:
                        eventFunction.BindPreviousProductionDetailsById(data.d);
                        break;
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetPreviousProduction: function () {

                eventFunction.config.method = "getPreviousProduction";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);

            },
            GetPreviousProdIngredients: function (d) {
                eventFunction.config.method = "getPreviousProductionDetails";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ ProductionId: d });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetInventoryItem: function () {
                eventFunction.config.method = "GetInventoryItemWithSmallUnit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetStore: function () {
                eventFunction.config.method = "getIssueToDDlHirerchy";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);

            },
          

            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindStore: function (result) {
                datas = JSON.parse(result);
                $("#SelStoreName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select Store-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });
                    $("#SelStoreName").html(htmls);
                }

            },

            BindPreviousProductionDetailsById: function (datas) {
                result = JSON.parse(datas);
                if (result.length > 0) {             
                    var htm = '';
                    htm += '<thead>< tr > <td colspan="4"> <h4 style="margin: 0;">Input</h4></td></tr ><tr><th>Ingredient</th><th>Quantity</th><th>Unit</th><th>Action</th> </tr></thead > '
                    $.each(result, function (index, value) {
                        htm += '<tr><td>';
                        htm += '<input type="text" class="sfInputbox txtIngredient" style="width: 200px;" value="'+value.ITName+'" />';
                        htm += '<input type = "hidden" class="hdnIngredientID" value="' + value.ItemId +'"  /></td>';
                        htm += '<td><input type="text" class="sfInputbox txtIngredientQuantity" value="' + value.Quantity +'" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" /></td>';
                        //htm += '<input type = "hidden" class="hdnItemID" />';
                        htm += '<td><input type="text" class="sfInputbox txtiUnit" value="' + value.Symbol + '" style="width: 100px;" readonly />';
                        htm += '<input type = "hidden" class="sfInputbox hdUnit" value="' + value.SmallUnit + '" /></td >'; 
                        htm += '<td><label class="sfLocale icon-addnew sfBtn restro-btn  addTextboxIngredient"></label></td ></tr > ';
                    });
                    //htm += '<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 200px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="sfInputbox txtIngredientQuantity" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td> <td><input type="text" class="sfInputbox txtiUnit" style="width: 100px;" readonly /><input type="hidden" class="sfInputbox hdUnit" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>';
                    $("#tableForIngredient").html(htm);
                }
            },

           

            BindPreviousProduction: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        var  prodate = new Date(value.AddedOn);

                        PreviousProduction.push({
                            label: value.ITName + ' (' + prodate.toLocaleDateString() + ')-' + value.Quantity + value.Symbol,
                            qty: value.Quantity,
                            unit: value.Symbol,
                            store: value.StoreId,
                            id: value.ProductionMainId,
                            itemid: value.ItemId,
                            unitId: value.SmallUnit,
                        });
                    });
                    $("#OldProductionDetails").autocomplete({

                        source: PreviousProduction,
                        focus: function (event, ui) {
                            event.preventDefault();
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).parents("tr").find('.OldProductionDetails').val(ui.item.label);
                            $('#hditemName').val(ui.item.itemid);
                            $('#hdtxtUnit').val(ui.item.unitId);
                            $('#itemName').val(ui.item.label);
                            $('#txtQuantity').val(ui.item.qty);
                            $('#txtUnit').val(ui.item.unit);
                            $('#SelStoreName').val(ui.item.store);
                            eventFunction.GetPreviousProdIngredients(ui.item.id);
                          
                        }
                    });

                  
                }

            },


            BindinventoryItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        AutocompleteIngredient.push({ label: value.ITName, unit: value.Symbol, unitid: value.SmallUnit, id: value.ITId });
                    });
                    $(".itemName").autocomplete({

                        source: AutocompleteIngredient,
                        focus: function (event, ui) {
                            event.preventDefault();
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).parents("tr").find('.itemName').val(ui.item.label);
                            $(this).parents("tr").find('.hditemName').val(ui.item.id);
                            $(this).parents("tr").find('.txtUnit').val(ui.item.unit);
                            $(this).parents("tr").find('.hdtxtUnit').val(ui.item.unitid);

                        }
                    });

                    $(".txtIngredient").autocomplete({

                        source: AutocompleteIngredient,
                        focus: function (event, ui) {
                            event.preventDefault();
                        },
                        select: function (event, ui) {
                            event.preventDefault();
                            $(this).parents("tr").find('.txtIngredient').val(ui.item.label);
                            $(this).parents("tr").find('.hdnIngredientID').val(ui.item.id);
                            $(this).parents("tr").find('.txtiUnit').val(ui.item.unit);
                            $(this).parents("tr").find('.hdUnit').val(ui.item.unitid);

                        }
                    });
                }
            },

            SaveProduction: function () {
                var production = new Object();
                production.ItemId = $("#hditemName").val();
                production.UnitId = $("#hdtxtUnit").val();
                production.StoreId = $("#SelStoreName").val();
                production.Quantity = $("#txtQuantity").val();
                production.AddedBy = p.userName;
                var ProductionDetails = new Array();

                $.each($('#tableForIngredient>tbody>tr'), function (index, row) {

                    var obj = new Object();
                    obj.ItemId = $(row).find('.hdnIngredientID').val();
                    obj.ItemUnitId = $(row).find('.hdUnit').val();
                    obj.Quantity = $(row).find('.txtIngredientQuantity').val();
                    obj.StoreID = $("#SelStoreName").val();

                    ProductionDetails.push(obj)

                });

                production.ProductItems = ProductionDetails;

                jConfirm('Do you want to send request?', 'Confirm!', function (confirm) {
                    if (confirm) {
                        eventFunction.config.method = "SaveProduction";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ production: production });
                        eventFunction.config.ajaxCallMode = 3;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });

            },
            //<<-----------------------------------Reset & Validation ------------------------------------->>>
            ResetAll: function () {
                $("#hditemName").val('');
                $("#itemName").val('');
                $("#hditemName").val('');
                $("#txtUnit").val('');
                $("#hdtxtUnit").val('');
                $("#SelStoreName").val('');
                $("#txtQuantity").val('');
                $("#tableForIngredient tbody tr").remove();
                $("#tableForIngredient").append('<tr><td> <input type="text" class="sfInputbox txtIngredient" style="width: 200px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="sfInputbox txtIngredientQuantity" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td> <td><input type="text" class="sfInputbox txtiUnit" style="width: 100px;" readonly/><input type="hidden" class="sfInputbox hdUnit" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>');
                eventFunction.GetInventoryItem();

            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        //StoreItem\

                        itemName: {
                            required: true
                        },
                        txtQuantity: {
                            required: true,
                        },
                        txtUnit: {
                            required: true,
                        },
                        SelStoreName: {
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