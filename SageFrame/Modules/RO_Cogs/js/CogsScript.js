function validateFloatKeyPress(el, evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    var number = el.value.split('.');
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    //just one dot (thanks ddlab)
    if (number.length > 1 && charCode == 46) {
        return false;
    }
    //get the carat position
    var caratPos = getSelectionStart(el);
    var dotPos = el.value.indexOf(".");
    if (caratPos > dotPos && dotPos > -1 && (number[1].length > 1)) {
        return false;
    }
    return true;
}
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RO_Cogs/service/'
             }, p);
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "CogsService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0
            },
            InitialSetup: function () {
                eventFunction.getItemList();
                eventFunction.GetCategoryName();
                eventFunction.GetCostCenter();
                //$("#selCostCenter").on('change', function () {
                //    eventFunction.getItemList();
                //});
            },
            init: function () {
                eventFunction.InitialSetup();

                $('#btnViewItemCogs').on('click', function () {
                    eventFunction.getItemCogs();
                });

              

                $('#btnViewItemIngreident').on('click', function () {
                    var option = $("#btnOption").val();
                    if (option == "Table") {
                        eventFunction.getItemIngreident();
                    }
                    else {
                        eventFunction.getItemIngreidentForReceipe();
                    }
                });
                $("#SelCategoryName").on('change', function ()
                {
                    
                    var pitid = $("#SelCategoryName").val();
                    if (pitid == "")
                    {
                        eventFunction.getItemList();
                    }
                    else {
                        eventFunction.config.method = "GetItemNameByCatgeoryID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.ajaxCallMode = 2;
                        eventFunction.config.data = JSON2.stringify({
                            pitid: pitid
                        })
                        eventFunction.ajaxCall(eventFunction.config);
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
                        eventFunction.bindItemIngreident(data.d);
                        break;
                    case 1:
                        eventFunction.bindItemCogs(data.d);
                        break;
                    case 2:
                        eventFunction.bindItemList(data.d);
                        break;
                    case 3:
                        eventFunction.BindCategoryName(data.d);
                        break;
                    case 4:
                        eventFunction.bindItemIngreidentForReceipe(data.d);
                        break;
                    case 5:                      
                        eventFunction.BindCostCenter(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetCategoryName: function () {
                eventFunction.config.method = "GetCategoryName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ IsMenu: true });;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },


            GetCostCenter: function (){
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getItemList: function () {
                var costCenter = $("#selCostCenter").val() == null ? 0 : $("#selCostCenter").val();
                eventFunction.config.method = "getItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.config.data = JSON2.stringify({ costCenter: costCenter });
                eventFunction.ajaxCall(eventFunction.config);
            },
            getItemIngreident: function () {
                var costCenter = $("#selCostCenter").val() == null ? 0 : $("#selCostCenter").val();
                var item = parseInt($("#selItem").val());
                var categoryID = $("#SelCategoryName").val() == "" ? 0 : $("#SelCategoryName").val();
                eventFunction.config.method = "getItemIngreident";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.config.data = JSON2.stringify({ costCenter: costCenter, itemID: item, categoryID: categoryID });
                eventFunction.ajaxCall(eventFunction.config);
            },

            getItemIngreidentForReceipe: function () {
                var costCenter = $("#selCostCenter").val() == null ? 0 : $("#selCostCenter").val();
                var item = parseInt($("#selItem").val());
                var categoryID = $("#SelCategoryName").val() == "" ? 0 : $("#SelCategoryName").val();
                eventFunction.config.method = "getItemIngreident";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.config.data = JSON2.stringify({ costCenter: costCenter, itemID: item, categoryID: categoryID });
                eventFunction.ajaxCall(eventFunction.config);
            },


            getItemCogs: function () {
                var costCenter = $("#selCostCenter").val() == null ? 0 : $("#selCostCenter").val();
                var item = parseInt($("#selItem").val());
                var categoryID = 0;
                var minCogs = parseInt($("#txtMinCogs").val());
                var maxCogs = parseInt($("#txtMaxCogs").val());
                eventFunction.config.method = "getItemCogs";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.config.data = JSON2.stringify({ costCenter: costCenter, itemID: item, minCogs: minCogs, maxCogs: maxCogs, categoryID: categoryID });
                eventFunction.ajaxCall(eventFunction.config);
            },

            BindCostCenter: function (result) {
               
                costlist = JSON.parse(result);
                $('#selCostCenter').html("");
                var htmls = "";
                
                htmls += "<option value='0' selected>--ALL--</option>";
                $.each(costlist, function (index, item) {
                    htmls += "<option value='" + item.CostCenterId + "'>" + item.CostCenterName + "</option>";
                });
                $('#selCostCenter').html(htmls);
            },


            bindItemList: function (result) {
            
                itemlist = JSON.parse(result);
                $('#selItem').html("");
                var htmls = "";
              
                htmls += "<option value='0' selected>--ALL--</option>";
                $.each(itemlist, function (index, item) {
                    htmls += "<option value='" + item.ITId + "'>" + item.ITName + "</option>";
                });
                $('#selItem').html(htmls);
            },

            BindCategoryName: function (result) {
             
                datas = JSON.parse(result);
                $("#SelCategoryName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' selected>-All-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "' costCenter='" + value.ItemCostCentreID + "'>" + value.ITName + "</option>";
                    });
                    $("#SelCategoryName").html(htmls);
                }

            },
            bindItemIngreident: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                $('#divItemIngreident').html(htmls);
                htmls += "<table id='tblItemIngredient' class='reportsprint'><thead>";
                //htmls += "<tr><th style='text-align:left;'>S.N.</th><th style='text-align:left;width:50%;'>Item Name</th><th style='text-align:left;'><span style='float:left;'>Ingredient </span><span style='float:right;'> Quantity</span></th></tr></thead>";
                htmls += "<tr><th>S.N.</th><th>Item Name</th><th>Ingredient</th><th>Quantity</th></tr></thead>";
                htmls += "<tbody>";
                if (data.length > 0) {
                $.each(data, function (index, value) {
                    htmls += "<tr>";
                    htmls += "<td style='vertical-align:top;' rowspan=" + value.Ingredientdata.length + ">" + (index + 1) + "</td>";
                    htmls += "<td style='vertical-align:top;' rowspan=" + value.Ingredientdata.length + ">" + value.ITName + "</td>";
                    htmls += "<td >" + value.Ingredientdata[0].ITName.split(",")[0] + "</td>";
                    htmls += "<td>" + value.Ingredientdata[0].Quantity + value.Ingredientdata[0].ITName.split(",")[1] + "</td>";
                    htmls += "</tr>";
                    $.each(value.Ingredientdata, function (i, item) {
                        if (i != 0) {
                            htmls += "<tr>";
                            htmls += "<td style='display: none;'></td>";
                            htmls += "<td style='display: none;'></td>";
                            htmls += "<td style='border: 0px solid black;'>" + item.ITName.split(",")[0] + "</td>";
                            htmls += "<td style='border: 0px solid black;'>" + item.Quantity + item.ITName.split(",")[1] + "</td>";
                            htmls += "</tr>";
                        }
                    });
                });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='4' style='text-align:center;'> No Data Available</td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody></table>";
                $('#divItemIngreident').html(htmls);
                //$("#tblItemIngredient").dataTable({
                //    jQueryUI : true,
                //    pageLength: 100,
                //    searching:false,
                //    dom: 'Bfrtip',
                //    autoWidth: false,
                //    ordering: false,
                //    scrollX: true,
                //    buttons: [
                //        'print', 'excel', 'pdf'
                //    ],
                //    columnDefs: [{ orderable: false },
                //    { width: 40, targets: 0 }
                //    ]

                //});
            },
            bindItemCogs: function (data) {
                var htmls = "";
                $('#divItemCogs').html(htmls);
                htmls += "<table id='tblItemCogs' class='reportsprint'><thead>";
                htmls += "<tr><th>S.N.</th><th>Item Name</th><th>Ingredient</th><th>Quantity</th><th>Amount</th><th>W/C/G (5%)</th><th>Total Cost</th><th>MRP</th><th>COGS</th></tr></thead>";
                htmls += "<tbody>";
                itemTotal = 0.00;
                $.each(data, function (index, value) {
                    var hh = "";
                    htmls += "<tr>";
                    htmls += "<td style='vertical-align:top;' rowspan=" + value.Ingredientdata.length + ">" + (index + 1) + "</td>";
                    htmls += "<td style='vertical-align:top;' rowspan=" + value.Ingredientdata.length + ">" + value.ITName + "</td>";
                    htmls += "<td>" + value.Ingredientdata[0].ITName.split(",")[0] + "</td>";
                    htmls += "<td>" + value.Ingredientdata[0].Quantity + value.Ingredientdata[0].ITName.split(",")[1] + "</td>";
                    htmls += "<td>" + (parseFloat(value.Ingredientdata[0].Amount) * parseFloat(value.Ingredientdata[0].Quantity)).toFixed(2) + "</td>";
                    itemTotal = (parseFloat(value.Ingredientdata[0].Amount) * parseFloat(value.Ingredientdata[0].Quantity));
                    $.each(value.Ingredientdata, function (i, item) {
                        if (i != 0) {
                            hh += "<tr>";
                            hh += "<td style='display: none;'></td>";
                            hh += "<td style='display: none;'></td>";
                            hh += "<td style='border: 0px solid black;'>" + item.ITName.split(",")[0] + "</td>";
                            hh += "<td style='border: 0px solid black;'>" + item.Quantity + item.ITName.split(",")[1] + "</td>";
                            hh += "<td style='border: 0px solid black;'>" + (parseFloat(item.Amount) * parseFloat(item.Quantity)).toFixed(2) + "</td>";
                            itemTotal += (parseFloat(item.Amount) * parseFloat(item.Quantity));
                            hh += "<td style='display: none;'></td>";
                            hh += "<td style='display: none;'></td>";
                            hh += "<td style='display: none;'></td>";
                            hh += "<td style='display: none;'></td>";
                            hh += "</tr>";
                        }
                    });

                    htmls += "<td rowspan=" + value.Ingredientdata.length + ">" + (parseFloat(itemTotal) * 0.05).toFixed(2) + "</td>";
                    htmls += "<td rowspan=" + value.Ingredientdata.length + ">" + (parseFloat(itemTotal) + (parseFloat(itemTotal) * 0.05)).toFixed(2) + "</td>";
                    htmls += "<td rowspan=" + value.Ingredientdata.length + ">" + value.SRate + "</td>";
                    htmls += "<td rowspan=" + value.Ingredientdata.length + ">" + (((parseFloat(itemTotal) + (parseFloat(itemTotal) * 0.05)) / parseFloat(value.SRate)) * 100).toFixed(2) + "</td>";
                    htmls += "</tr>";
                    htmls += hh;
                });
                htmls += "</tbody></table>";
                $('#divItemCogs').html(htmls);
                $("#tblItemCogs").dataTable({
                    jQueryUI : true,
                    pageLength: 100,
                    searching: false,
                    dom: 'Bfrtip',
                    autoWidth: false,
                    ordering: false,
                    scrollX: true,
                    buttons: [
                        'print', 'excel', 'pdf'
                    ],
                    columnDefs: [{ orderable: false },
                    { width: 40, targets: 0 }
                    ]

                });
            },

            bindItemIngreidentForReceipe: function (result) {
                
                var recipeClass = 'ItemIngrediantReceipe' + Math.floor((Math.random() * 100) + 1);
                $('#divItemIngreident').html("");
                data = JSON.parse(result);
                var htmls = "";
                if (data.length > 0) {
            
                    htmls += "<div class='ItemIngrediantReceipe'>";
                    $.each(data, function (index, value) {
                        var image = value.ImagePath;
                        htmls += "<div class='receipe'>";
                        htmls += "<div class='receipeTitle'><h3>" + value.ITName + "</h3></div>";
                        htmls += "<div class='receipe-sec'>";
                        htmls += "<div class='Topreceipe'>";
                        htmls += "<div class='receipeimg'>";
                        if (image == "") {
                            htmls += "<img id='menuimg_" + value.ItemID + "' class='menuimg'  src='/Modules/ROI_Item/ImageItem/noImage.jpg' width='150px' height='120px' alt='Item_Image'>";
                             htmls += "</div>";
                        }
                        else {
                            htmls += "<img id='menuimg_" + value.ItemID + "' class='menuimg'  src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' width='150px' height='120px' alt='Item_Image'>";
                            
                            htmls += "</div>";
                        }
   
                        htmls += "<div class='receipeingrediant'>";
                        htmls += "<h4>Ingrediants</h4>";
                        htmls += "<ul>";
                        $.each(value.Ingredientdata, function (i, item) {
                      
                            var Name = item.ITName;
                            var word = Name.split(",");
                                htmls += "<li>";
                                htmls += item.Quantity + " " + word[1] + " " + word[0];
                                htmls += "</li>";
                        
                        });
                        htmls += "</ul>";
                        htmls += "</div>";
                        htmls += "</div>";
                        htmls += "<div class='Bottomreceipe'>";
                        htmls += "<h4>Directions</h4>";
                        if (value.Details == "") {
                            htmls += "No Procedure Availabale";
                        }
                        else {
                            htmls += value.Details;
                        }
                        
                        htmls += "</div></div></div>";
                    });
                    htmls += "</div>";
                }
                $('#divItemIngreident').html(htmls);
                recipeClass = '.' + recipeClass;
                $('.ItemIngrediantReceipe').owlCarousel({

                    navigation: true,
                    addClassActive: true, slideSpeed: 300,
                    paginationSpeed: 400,

                    items: 1,
                    itemsDesktop: false,
                    itemsDesktopSmall: false,
                    itemsTablet: false,
                    itemsMobile: false
                });
            },


            Reset: function () {
                window.location.reload();
            },

        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);