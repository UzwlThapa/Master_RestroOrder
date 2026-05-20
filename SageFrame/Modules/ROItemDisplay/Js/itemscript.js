(function ($) {
    var tabs = $("#tabs").tabs();
    var arrItemListType = new Array();
   
    currentPage = 0;
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROItemDisplay/',
                 RowTotal: ''
             }, p);
        var v = 0;
        rowTotal = p.RowTotal;
        offset = 0;
        limit = 9;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ROItemWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ItemId: 0,
                Itemupdate: 0


            },
            InitialSetup: function () {

                $("#itemTable").hide();
                $("#ItemButton").hide();
                //eventFunction.GetItem();
                //eventFunction.DropdownBindCategory();
                //eventFunction.DropdownBindUnit();
                eventFunction.Pagination();

            },
            Pagination: function () {
                if (parseInt(rowTotal) <= parseInt(limit)) {
                     
                    $('#Pagination').hide();
                }
                else {
                    $("#Pagination").pagination(rowTotal, {
                        items_per_page: limit,
                        current_page: 0,
                        callfunction: true,
                        function_name: { name: eventFunction.LoadItemPaginatedList, limit: 9 },
                        prev_text: "<<",
                        next_text: ">>"

                    });
                }
            
            },

            //Search: function()
            //{
            //    $.fn.tableSearch = function (options) {
            //        if (!$(this).is('table')) {
            //            return;
            //        }
            //        var tableObj = $(this),
            //            searchText = (options.searchText) ? options.searchText : 'Search: ',
            //            searchPlaceHolder = (options.searchPlaceHolder) ? options.searchPlaceHolder : '',
            //            divObj = $('<div style="float:right;">' + searchText + '</div><br /><br />'),
            //            inputObj = $('<input type="text" placeholder="' + searchPlaceHolder + '" />'),
            //            //caseSensitive = (options.caseSensitive === true) ? true : false,
            //            caseSensitive = false,
            //            searchFieldVal = '',
            //            pattern = '';
            //        inputObj.off('keyup').on('keyup', function () {
            //            searchFieldVal = $(this).val();
            //            pattern = (caseSensitive) ? RegExp(searchFieldVal) : RegExp(searchFieldVal, 'i');
            //            tableObj.find('tbody tr').hide().each(function () {
            //                var currentRow = $(this);
            //                currentRow.find('td').each(function () {
            //                    if (pattern.test($(this).html())) {
            //                        currentRow.show();
            //                        return false;
            //                    }
            //                });
            //            });
            //        });
            //        tableObj.before(divObj.append(inputObj));
            //        return tableObj;
            //    }
            
            //},

            init: function () {

                eventFunction.InitialSetup();

                $('#textItemName').focusout(function () {
                    var name = $('#textItemName').val();
                    $('#itemtable td').filter(function () {
                        if ($(this).text() == name) {
                            jAlert('Item Name not Unique', 'Alert!!', function () { $.alerts.dialogClass = null; });

                            $('#textItemName').val('');
                            uniqueproduct = 1;
                        }
                        else {
                            uniqueproduct = 0;

                        }

                    });
                });


                $("#AddItem").on('click', function () {
                    $("#itemTable").show(1000);
                    $("#ItemButton").show(1000);
                    $("#AddItem").hide(1000);

                });
                $("#btnItemCancel").on('click', function () {
                    $("#itemTable").hide(1000);
                    $("#ItemButton").hide(1000);
                    $("#AddItem").show(1000);
                    eventFunction.ResetAll();
                });
                $("#btnItemSave").on('click', function () {

                    //var checkValid = eventFunction.ValidationForm();
                    //if (checkValid) {
                    eventFunction.ItemSave();
                    eventFunction.GetItem();
                    eventFunction.ResetAll();
                    $("#itemTable").hide(1000);
                    $("#ItemButton").hide(1000);
                    $("#AddItem").show(1000);
                    //    }
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

                    break;
                case 2:
                    jAlert('Updated successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                    location.reload();
                    break;
                case 3:
                    jAlert('Delete successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                    var id = eventFunction.config.ID;
                    $("#" + id + "_").remove();
                    break;
                case 4:
                    eventFunction.BindItem(data);
                    break;
                case 5:
                    eventFunction.BindDropdownCategory(data);
                    break;
                case 6:
                    eventFunction.BindDropdownUnit(data);
                    break;
                case 7:
                    eventFunction.BindItemPaginatedList(data);
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

        LoadItemPaginatedList: function (offset, limit, current) {

            currentPage = current;
            eventFunction.config.method = "GetItemPaginatedList";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = JSON2.stringify({ offset: offset, limit: limit });
            eventFunction.config.ajaxCallMode = 7;
            eventFunction.ajaxCall(eventFunction.config);

        },




        //<<-----------------------------Post & Get Here ---------------------------------------->>

        ItemSave: function () {
            var ItemsInf = {};
            ItemsInf.ItemID = eventFunction.config.ItemId;
            ItemsInf.ItemName = $('#textItemName').val();
            ItemsInf.ItemDescription = $('#textItemDescription').val();
            ItemsInf.PhotoPath = $('#txtFile').val();
            ItemsInf.Price = $('#textItemPrice').val();
            ItemsInf.ItemCode = $('#textItemCode').val();
            ItemsInf.UnitID = parseInt($('#ddlUnit').val());
            ItemsInf.CategoryID = parseInt($('#ddlCategory').val());

            eventFunction.config.method = "ItemSaveTodatabase";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = JSON2.stringify({ ItemsInf: ItemsInf });

            if (eventFunction.config.Itemupdate == 1) {
                eventFunction.config.ajaxCallMode = 2;
            } else {
                eventFunction.config.ajaxCallMode = 1;
            }

            eventFunction.ajaxCall(eventFunction.config);
            eventFunction.config.Itemupdate = 0;
        },
        GetItem: function () {
            eventFunction.config.method = "GetItemsfromDatabase";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = eventFunction.config.data;
            eventFunction.config.ajaxCallMode = 4;
           
            eventFunction.ajaxCall(eventFunction.config);
        },
        DeleteItem: function (item) {
            var id = parseInt(item.id.split("_")[1])
            var ItemID = id;
            eventFunction.config.method = "ItemDelete";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = JSON.stringify({ ItemID: ItemID });
            eventFunction.config.ajaxCallMode = 3;
            eventFunction.config.ID = id;
            eventFunction.ajaxCall(eventFunction.config);
        },
        DropdownBindCategory: function () {
            eventFunction.config.method = "getCategory";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = eventFunction.config.data;
            eventFunction.config.ajaxCallMode = 5;
            eventFunction.ajaxCall(eventFunction.config);
        },
        DropdownBindUnit: function () {
            eventFunction.config.method = "getUnit";
            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            eventFunction.config.data = eventFunction.config.data;
            eventFunction.config.ajaxCallMode = 6;
            eventFunction.ajaxCall(eventFunction.config);
        },


        //<<-----------------------------------BindTable Herere ------------------------------------->>>
        BindItemPaginatedList: function (data) {
            var HTML = "";
           
            $('#RoImageGallery table tbody').html('');
            HTML += ("<table id='item-display-pagination'>");
            HTML += ("<tr>");
            var count = 1;
            arrItemListType = new Array();
            arrItemListType.length = 0;

            $.each(data.d, function (index, item) {
                if ((item.PhotoPath) != '')
                {
                    arrItemListType.push(item.ItemID);
                    HTML += ("<td><a href='#'> <img src='/Modules/ROItem/images/" + item.PhotoPath + "' height='200px' width='300px'/></a><br/>");
                    HTML += ("<h4 class='item-name'> " + item.ItemName + "</h4></td>");
                    if (count == 3)
                    {
                        HTML += ("</tr><tr>");
                        count = 0;
                    }
                    count++;

                }
            });

            HTML += ("</tr>");
            HTML += ("</table>");
            $('#RoImageGallery').html(HTML);

            $("#Pagination").show();
                if (arrItemListType.length > 0) {
                    $("#Pagination").pagination(rowTotal, {
                        items_per_page: 9,
                        current_page: currentPage,
                        callfunction: true,
                        function_name: { name: eventFunction.LoadItemPaginatedList, limit: 9},
                        prev_text: "<<",
                        next_text: ">>",
                        prev_show_always: false,
                        next_show_always: false
                    });
                }
                else {
                    $("#Pagination").hide();
                }
            
        },


        //BindItem: function (data) {
        //    $("#itemdata").show();
        //    $("#itemdata").html('');

        //    console.log(data);
        //    var datas = data.d;
        //    if (datas.length > 0) {
        //        var htmls = "<table id='itemtable' class='sfGridwrapper display' cellspacing='0'>"
        //        htmls += "<thead>"
        //        htmls += "<tr>"
        //        htmls += "<th>Name</th><th>Description</th><th>Image</th><th>Price</th><th>Code</th><th>Unit</th><th>Category</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
        //        htmls += "</tr>"
        //        htmls += "</thead>"
        //        htmls += "<tbody>"

        //        $.each(datas, function (index, value) {
        //            htmls += "<tr class='tableItem' id=" + value.ItemID + "_>";
        //            htmls += "<td>" + value.ItemName + "</td>";
        //            htmls += "<td>" + value.ItemDescription + "</td>";
        //            htmls += "<td>" + value.PhotoPath + "</td>";
        //            htmls += "<td>" + value.Price + "</td>";
        //            htmls += "<td>" + value.ItemCode + "</td>";
        //            htmls += "<td>" + value.UnitName + "</td>";
        //            htmls += "<td>" + value.CategoriesName + "</td>";
        //            htmls += "<td>" + "<img src='/images/edit.png' class='ItemEdit'  type='button'  id='" + value.ItemID + "_" + value.ItemName + "_" + value.ItemDescription + "_" + value.PhotoPath + "_" + value.Price + "_" + value.ItemCode + "_" + value.UnitID + "_" + value.CategoryID + "' value='Edit' /></td>";
        //            htmls += "<td>" + "<img src='/images/delete.png' class='ItemDelete' type='button'  id=_" + value.ItemID + " value='Delete' /></td></tr>";
        //            htmls += "</tr>"

        //        });
        //        htmls += "</tbody>";
        //        htmls += "</table>";
        //        $('#itemdata').html(htmls);
        //        $('#itemtable').DataTable(
        //             {
        //                 "scrollY": 200,
        //                 "scrollCollapse": true,
        //                 "jQueryUI": true
        //             });

        //    } else {
        //        $('#itemdata').html('No data');
        //    }
        //    $(".ItemEdit").on('click', function () {
        //        $("#itemTable").show();
        //        $("#ItemButton").show();
        //        var ids = $(this).attr('id');
        //        var words = ids.split('_');
        //        eventFunction.config.ItemId = words[0];
        //        $("#textItemName").val(words[1]);
        //        $("#textItemDescription").val(words[2]);
        //        $("#fileupload").val(words[3]);
        //        $("#textItemPrice").val(words[4]);
        //        $("#textItemCode").val(words[5]);
        //        $("#ddlUnit").val(words[6]);
        //        $("#ddlCategory").val(words[7]);
        //        eventFunction.config.Itemupdate = 1;
        //    });
        //    $(".ItemDelete").on('click', function () {
        //        eventFunction.DeleteItem(this);
        //        eventFunction.ResetAll();
        //    });

        //},

        //BindItemCategory
        BindDropdownCategory: function (result) {
            var datas = result.d;
            var x = new Array();
            $("#ddlCategory").html('');

            if (datas.length > 0) {
                var htmls = '';
                htmls = "<option value='' disabled selected>-Select-</option>";
                $.each(datas, function (index, value) {
                    htmls += "<option value='" + value.CategoryID + "'>" + value.CategoryName + "</option>";
                });

                $("#ddlCategory").html(htmls);
            }

        },

        //BindItemDetails
        BindDropdownUnit: function (result) {
            var datas = result.d;
            var x = new Array();
            $("#ddlUnit").html('');

            if (datas.length > 0) {
                var htmls = '';
                htmls = "<option value='' disabled selected>-Select-</option>";
                $.each(datas, function (index, value) {
                    htmls += "<option value='" + value.UnitID + "'>" + value.UnitName + "</option>";
                });

                $("#ddlUnit").html(htmls);
            }

        },
        //<<-----------------------------------Reset & Validation ------------------------------------->>>

        ResetAll: function () {
            //Unit
            $('#textItemName').val(null);
            $('#textItemCode').val(null);
            $('#textItemPrice').val(null);
            $('#ddlUnit').val(null);
            $('#ddlCategory').val(null);
        },

        //ValidationForm: function () {
        //    v = $('#form1').validate({
        //        rules: {

        //            //StoreItem
        //            textItemName: {
        //                required: true,
        //            },

        //        },
        //        messages: {
        //            textItemPrice: {
        //                number: '*'
        //            },
        //        },
        //    });
        //    if (v.form()) {
        //        return true;
        //    }
        //    else
        //        return false;
        //},


        };
    eventFunction.init();
};
    $.fn.companyProfEDIT = function (p) {
    $.companyProfcreate(p);
};
})(jQuery);
