(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROI_ExtraItems/webservice/',
                 userName: ''
             }, p);
        var AutocompleteIngredient = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ExtraItemWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ExtraItemIDUpdate: 0,
                ExtraItemID: 0,
            },
            InitialSetup: function () {
                eventFunction.GetExtraItemList();
                eventFunction.GetInventoryItem();
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnAdd").on('click', function () {
                    $("#btnAdd").hide();
                    $("#extraItemForm").show();
                    $("#divForExtraItemList").hide();

                });
                $("#btnSave").on('click', function () {
                    var check = eventFunction.ValidationForm();

                    if (check) {
                        eventFunction.SaveExtraItem();
                    }
                });
                $("#btnCancel").on('click', function () {
                    eventFunction.ResetAll() 
                });
                $("#tableForIngredient").on("click", ".addTextboxIngredient", function () {
                    if ($(this).closest('tr').find('td .txtIngredient').val() != "" && $(this).closest('tr').find('td .txtIngredientQuantity').val()) {
                        $(".addTextboxIngredient").removeClass('icon-addnew addTextboxIngredient').addClass('icon-close removeTextboxIngredient');
                        //var input = '<tr><td> <input type="text" class="txtIngredient" style="width: 154px;" /><input type="hidden" class="hdnIngredientID" /></td> <td class="unit"><select id="selIngredientUnit" class="sfInputbox" name="quentity" style="width: 100px;"></select></td><td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn addTextboxIngredient"></label></td></tr>';
                        var input = '<tr><td> <input type="text" class="txtIngredient sfInputbox" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td> <td><input type="text" class="txtIngredientQuantity sfInputbox" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn restro-btn addTextboxIngredient"></label></td></tr>';
                        $("#tableForIngredient").append(input);
                        $('.txtIngredient').each(function () {
                            $(this).autocomplete({
                                source: AutocompleteIngredient,
                                delay: 0,
                                select: function (event, ui) {
                                    $(this).siblings('.hdnIngredientID').val(ui.item.id);
                                }
                            });
                        });
                    } else {
                        jAlert('Empty textbox!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });
                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
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
                        eventFunction.BindExtraItemList(data.d);
                        break;
                    
                    case 1:
                        jAlert('Inserted Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.GetExtraItemList();
                        eventFunction.ResetAll();
                        break;
                    case 2:
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.GetExtraItemList();
                        eventFunction.ResetAll();
                        break;
                    case 3:
                        jAlert('Successfully Deleted!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.GetExtraItemList();
                        break;
                    case 4:
                        eventFunction.BindinventoryItem(data.d);
                        break;
                    case 5:
                        eventFunction.BindIngredientByID(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetInventoryItem: function () {
                eventFunction.config.method = "GetInventoryItemWithSmallUnit";
                eventFunction.config.url = '/Modules/ROI_Item/RoiItem.asmx/' + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetExtraItemList: function () {
                eventFunction.config.method = "GetExtraItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SaveExtraItem: function () {

                var extraItem = new Object;
                extraItem.ExtraItemID = eventFunction.config.ExtraItemID;
                extraItem.ExtraItem = $("#txtExtraItemName").val();
                extraItem.ExtraPrice = parseFloat($("#txtPrice").val());
                extraItem.IsActive = $("#chkActive").is(":checked");
                extraItem.AddedBy = SageFrameUserName;

                var IngredientArray = new Array;
                $("#tableForIngredient tbody tr").each(function (x, y) {
                    if ($(this).find(".hdnIngredientID").val() != "") {
                        var IngredientObject = new Object;
                        IngredientObject.IngredientID = $(this).find(".hdnIngredientID").val();
                        IngredientObject.Quantity = $(this).find(".txtIngredientQuantity").val();
                        IngredientArray.push(IngredientObject);
                    }
                });
                extraItem.Ingredientdata = IngredientArray;

                eventFunction.config.method = "SaveExtraItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ extraItem: extraItem });
                if (eventFunction.config.ExtraItemIDUpdate == 0)
                    eventFunction.config.ajaxCallMode = 1;
                else
                    eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteExtraItem: function(extraItemId){
                eventFunction.config.method = "DeleteExtraItem";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ extraItemId: extraItemId, deletedBy: SageFrameUserName });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);

            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            BindinventoryItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        AutocompleteIngredient.push({ label: value.ITName + ", " + value.Symbol, id: value.ITId });
                        //AutocompleteIngredient.push({ label: value.ITName, id: value.ITId });
                        //alert(value.Symbol);
                    });
                }
            },
          
            BindExtraItemList: function (result) {
                datas = JSON.parse(result);
                $("#divForExtraItemList").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableForExtraItemList' class='reportsprint'><thead><tr><th style='width:40px;'>S.N.</th><th>Extra Item Name</th><th>Price</th><th>Is Active</th><th class='edit-heading tdcenter' style='width:20px;'>Edit</th><th class='delete-heading tdcenter' style='width:20px;'>Delete</th></tr></thead><tbody>";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.ExtraItem + '</td>';
                        htmls += '<td>' + value.ExtraPrice + '</td>';
                        htmls += '<td>' + value.IsActive + '</td>';
                        htmls += '<td class="tdcenter"><label id="' + value.ExtraItemID + '+' + value.ExtraItem + '+' + value.ExtraPrice + '+' + value.IsActive + '"   class="edit icon-edit" value="Edit"/></td>';
                        htmls += '<td class="tdcenter"><label id="' + value.ExtraItemID + '" class="delete icon-delete"  value="Delete"/></td>';
                        htmls += '</tr>';
                    });
                    htmls += "</tbody></table>";
                    $("#divForExtraItemList").html(htmls);
                    $("#tableForExtraItemList").dataTable({
                        "jQueryUI" : true,
                        "lengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                        "pageLength": 20,
                        columnDefs: [{ orderable: false, targets: [0,4,5] }],
                    });
                }

                $("#tableForExtraItemList").on('click', '.delete', function () {
                    var ids = $(this).attr('id');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.DeleteExtraItem(ids);
                        }
                    });
                });

                $("#tableForExtraItemList").on('click', '.edit', function () {
                    $("#btnAdd").hide();
                    $("#extraItemForm").show();
                    $("#divForExtraItemList").hide();

                    var datas = $(this).attr('id').split('+');
                    $("#txtExtraItemName").val(datas[1]);
                    $("#txtPrice").val(datas[2]);
                    $("#chkActive").prop('checked', (datas[3] == 'true' ? true : false));

                    eventFunction.config.method = "getIngredientByExtraItemID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: datas[0] });
                    eventFunction.config.ajaxCallMode = 5;
                    eventFunction.ajaxCall(eventFunction.config);

                    eventFunction.config.ExtraItemID = datas[0];
                    eventFunction.config.ExtraItemIDUpdate = 1;


                });
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
                            $("#tableForIngredient .addTextboxIngredient").click();
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(0) input[type=text]').val(value.ITName);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(0) input[type=hidden]').val(value.Ingredient);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(1) input[type=text]').val(value.Quantity);
                            $('#tableForIngredient tbody tr:eq(' + index + ')').find('td:eq(1) input[type=hidden]').val(value.ItemId);
                        }
                    });
                }
            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $("#btnAdd").show();
                $("#extraItemForm").hide();
                $("#divForExtraItemList").show();

                eventFunction.config.ExtraItemID = 0;
                eventFunction.config.ExtraItemIDUpdate = 0;

                $("#txtExtraItemName").val('');
                $("#txtPrice").val('');
                $("#chkActive").prop('checked', true);

                $("#tableForIngredient tbody tr").remove();
                $("#tableForIngredient").append('<tr><td> <input type="text" class="txtIngredient" style="width: 300px;" /><input type="hidden" class="hdnIngredientID" /></td><td><input type="text" class="txtIngredientQuantity" style="width: 100px;" /><input type="hidden" class="hdnItemID" value="" /></td><td><label class="sfLocale icon-addnew sfBtn restro-btn addTextboxIngredient"></label></td></tr>');
                $(".txtIngredient").autocomplete({
                    source: AutocompleteIngredient,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnIngredientID').val(ui.item.id);
                    }
                });

              //  v.resetForm();
            },
           


            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        //StoreItem

                        ExtraItemName: {
                            required: true
                        },
                        Price: {
                            required: true,
                            number:true
                        },
                    },
                    messages: {

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