
var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));

var disLimitBasicAmt = 0.00;
var baseUrl = SageFrameHostURL + "/Services/OrderWebservice.asmx/";
var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
var AutocompleteItem = new Array();
var PreviousOrdersList = new Array();
var completedOrders = new Array();
var inprogressOrders = new Array();
var OrderListArray = new Array();
var ExtraItemsByItem = new Array();
var ExtraItems = new Array();
var selectedBillNo = 1;
var pinMatch = "";
//var pinfor = "";
var noOfGuest = 1;
var iscancelling = false;
var OrderMasterID = 0;
var TotalNetAmount = 0.00;
var OID = 0;
var TableId = 0;
var RoomId = 0;
var HostUrl = '';
var foodCourtOrder = false;
var OrderDelivery = false;

//Avata Change
//var yogaOrder = false;
//var spaOrder = false;

var foodCourtAutoBillGenerate = false;
var checks = [];
var isButtonClicked = false;
var orderdetails = null;
var billingterms = null;
var costcenters = null;
var tokeninfo = null;
var barAmount = 0.00;
var kotAmount = 0.00;
var totalAmount = 0.00;
var nonTaxableAmount = 0.00;
var kotdis = 0.00;
var bevdis = 0.00;
var roomAmount = 0.00;
var roomdis = 0.00;
var bakeryAmount = 0.00;
var bakerydis = 0.00;
var pizzaAmount = 0.00;
var pizzadis = 0.00;
var sNo = 1;
var userRole = "";
var IsEnableDiscount = false;
var orderlistviewtype = JSON.parse(localStorage.getItem("ordermenulisttype"));
var OrdermenuImageshow = JSON.parse(localStorage.getItem("OrdermenuImageshow"));
var AddItemInMenuSearch = JSON.parse(localStorage.getItem("AddItemInMenuSearch"));
var menuID = 0;

var creditLimit = (localStorage.getItem("creditLimit"));



function GetmembershiplistbyId(memberid) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "getmembershiplistbyId",
        data: JSON2.stringify({ memberid: memberid }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            $('.customerForCash').prop('checked', true);
            $("#CustomerID").val(result[0].MembershipID);
            $("#txtCustName").val(result[0].Fname + " " + result[0].Lname);
            $("#txtNumber").val(result[0].TelMobile == "" ? $("#txtNumber").val() : result[0].TelMobile);
            $("#txtLoyaltyDiscount").val(result[0].discount);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function GetGlobalizedMenu() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "getLanguage",
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var datas = JSON.parse(data.d);
            $("#selLanguage").html('');
            var htmls = '';
            // htmls = "<option value='0' disabled selected>-All-</option>";
            $.each(datas, function (index, value) {
                htmls += "<option value='" + value.LanguageID + "'>" + value.CultureName + "</option>";
            });

            $("#selLanguage").html(htmls);

        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function GetItemForSearch() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetItemForSearch",
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            AutocompleteItem = [];
            $.each(JSON.parse(data.d), function (index, value) {
                AutocompleteItem.push(value.ITName);
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });

    $("#selLanguage").on('change', function () {
        var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
        GetMenuforOrder(languageid);
        //if (OrdermenuImageshow == false) {
        //    $('img.menuimg').remove();
        //    $('.restaurant-part-menu').click(function () {
        //        $('img.categoryimg , img.itemimg').remove();
        //    });
        //}

    });

    $('.customerForOrder').on('change', function () {
        if ($('.customerForOrder').prop('checked') == true) {
            GetCustomeronCheck();
        }
        else {
            $('#CustomerID').text("");
            $("#txtContactNo").val("");
            $("#txtAddress").val("");
            $("#txtCustName").val("");

            $("#txtCustName").val("");
            $("#txtCusAddress").val();
            $("#txtPanNo").val("");

            $("#txtCustName").prop('disabled', false);
            $("#txtCusAddress").prop('disabled', false);
            $("#txtPanNo").prop('disabled', false);

            $("#selDiscountType").val(1);
            $("#txtLoyaltyDiscount").val(0);
        }
    });
}
function GetMenuforOrder(languageid) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "getGlobalizedMenu",
        data: JSON2.stringify({ languageid: languageid }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var datas = JSON.parse(data.d);
            var htmls = [];
            $('#Menushow').html("");
            htmls += "<h4>Main Menus</h4>";
            if (datas.length > 0) {
                htmls += "<div class='menus'>";
                $.each(datas, function (index, value) {
                    if (value.LookupName == "") {
                        if (value.ImagePath == "")
                            htmls += "<div><img id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "' class='menuimg' src='/Modules/ROCompanyInfo/logo/logo.png' width='150px' height='120px'>";
                        else
                            htmls += "<div><img id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "' class='menuimg' src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' width='150px' height='120px' alt='Image not found'>";
                        htmls += "<div class='itmname menuimg' id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "'>" + value.LanguageMenuText + "</div></div>";
                    }
                });
                htmls += "</div>";
                $('#Menushow').html(htmls);

            } else {
                htmls += "<h6>No Menu Available </h6>";
                $('#Menushow').html(htmls);
            }

            if (OrdermenuImageshow == false) {
                $('img.menuimg').remove();
                $('.restaurant-part-menu').click(function () {
                    $('img.categoryimg , img.itemimg').remove();
                });
            }
            if (!orderlistviewtype) {
                $('.menus').owlCarousel({
                    navigation: true,
                    addClassActive: true
                });
            }

            $(".menuimg").on("error", function () {
                $(this).attr('src', '/Modules/ROCompanyInfo/logo/logo.png');
            });

            $('.menuimg').on('click', function () {

                var data = $(this).attr('id');
                var values = data.split('_');
                var categoryName = values[2];
                menuID = parseInt(values[1]);
                GetCategoriesBymenuID(parseInt(values[1]), categoryName, languageid);

                if (orderlistviewtype) {
                    $('#Menushow').hide();
                    $('#Categoryshow , #Itemshow2, #Itemshow2').show();
                }
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function GetCategoriesBymenuID(menuid, categoryName, languageid) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetCategoriesBymenuID",
        data: JSON2.stringify({ MenuId: menuid, languageid: languageid }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            BindCategoriesByMenu(result, categoryName);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function BindCategoriesByMenu(result, categoryName) {
    var htmls = [];
    $('#Categoryshow').html("");
    $('#Itemshow').html("");
    $('#Itemshow2').html("");
    var datas = result;
    if (orderlistviewtype) {
        htmls += "<img src='/images/back.png' class='orderbackA'/><h4>" + categoryName + " Items</h4>";
    } else {
        htmls += "<h4>" + categoryName + " Items</h4>";
    }
    if (datas.length > 0) {
        htmls += "<div class='category menus'>";
        $.each(datas, function (index, value) {
            //htmls += "<div><img attr-type='i' attr-iscat=" + value.IsCategory + " id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.IsOutOfStock + "_" + value.SRate + "' class='categoryimg' src='/Modules/" + (value.ImagePath == "" ? 'ROCompanyInfo/logo/' + companyInfo.Logo : 'ROI_Item/ImageItem/' + value.ImagePath) + "' width='150px' height='120px'>";
            htmls += '<div><img attr-type="i" attr-iscat=' + value.IsCategory + ' id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.IsOutOfStock + '_' + value.SRate + '" class="categoryimg" src="/Modules/' + (value.ImagePath == "" ? "'/Modules/ROCompanyInfo/logo/logo.png'" : "ROI_Item/ImageItem/" + value.ImagePath) + '" width="150px" height="120px">';
            if (value.SRate == '0')
                //htmls += "<div class='itmname categoryimg' id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.IsOutOfStock + "_" + value.SRate + "' attr-iscat=" + value.IsCategory + ">" + value.LanguageMenuText + (value.IsOutOfStock ? '(Out Of Stock)' : '') + "</div></div>";
                htmls += '<div class="itmname categoryimg" id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.IsOutOfStock + '_' + value.SRate + '" attr-iscat=' + value.IsCategory + '>' + value.LanguageMenuText + (value.IsOutOfStock ? "(Out Of Stock)" : '') + '</div></div>';
            else
                //htmls += "<div class='itmname categoryimg' id='categoryimg_" + value.ItemId + "_" + value.LanguageMenuText + "_false_" + value.IsOutOfStock + "_" + value.SRate + "' attr-iscat=" + value.IsCategory + ">" + value.LanguageMenuText + (value.IsOutOfStock ? '(Out Of Stock)' : '(Rs. ' + value.SRate + ')') + "</div></div>";
                htmls += '<div class="itmname categoryimg" id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.IsOutOfStock + '_' + value.SRate + '" attr-iscat=' + value.IsCategory + '>' + value.LanguageMenuText + (value.IsOutOfStock ? "(Out Of Stock)" : "(Rs. " + value.SRate + ")") + '</div></div>';
        });
        htmls += "</div>";
        $('#Categoryshow').html(htmls);
    } else {
        htmls += "<h6>No category Available in this Section</h6>";
        $('#Categoryshow').html(htmls);
    }
    $(".categoryimg").on("error", function () {
        $(this).attr('src', '/Modules/ROCompanyInfo/logo/logo.png');
    });
    if (orderlistviewtype) {
        $('.orderbackA').on('click', function () {
            //menuID = 0;
            $('#Categoryshow').hide();
            $('#Itemshow , #Itemshow2 ').hide();
            $('#Menushow').show();
            // if (IsCat) {
            //        $('#Categoryshow').show();
            //    } else {
            //        $('#Categoryshow').hide();
            //    }

        });
    } else {
        $('.category').owlCarousel({

            navigation: true,
            addClassActive: true
        });
    }

    $('.categoryimg').on('click', function () {
        $('#Itemshow').html("");
        var data = $(this).attr('id');
        var values = data.split('_');
        var NpitemID = values[1];
        var NpitemName = values[2];
        var Nprate = values[5];
        var IsCombo = $(this).attr('attr-type') == 'c' ? true : false;
        var IsCat = $(this).attr('attr-iscat') == "true" ? true : false;
        if (orderlistviewtype) {
            $('#Itemshow').show();
            if (IsCat) {
                $('#Categoryshow').hide();
            } else {
                $('#Categoryshow').show();
            }
        }
        var currentVal = $('#qty_' + values[1] + '_' + IsCombo).val();
        if (currentVal == undefined) {
            currentVal = 0;
        }
        var prevQuantity = 0;
        $.each(PreviousOrdersList, function (i, item) {
            if (item.ItemID == NpitemID && item.IsCombo == IsCombo && item.SeatNo == selectedBillNo) {
                prevQuantity = item.Quantity;
                return false;
            }
        })
        if (currentVal >= prevQuantity && values[4] == 'true') {
            jAlert('Item Out Of Stock!!', 'Information!!');
        } else {
            if (IsCat) {
                var subItem = false;
                var categoryName = values[2];
                GetItemByCategoryID(parseInt(values[1]), subItem, categoryName);
                $('html, body').animate({
                    scrollTop: $("#Itemshow").offset().top - 100
                }, 200);
            }
            else {
                BindItemsToOrder(NpitemID, NpitemName, IsCombo, values[4], Nprate);
            }
        }
    });
}
function GetItemByCategoryID(categoryId, subItem, categoryName) {
    var LanguageID = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetItemByCategoryID",
        data: JSON2.stringify({ CategoriesID: categoryId, LanguageID: LanguageID }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var datas = JSON.parse(data.d);
            var htmls = [];
            if (subItem) {
                $('#Itemshow2').html("");
            } else {
                $('#Itemshow').html("");
                $('#Itemshow2').html("");
            }

            if (orderlistviewtype) {
                htmls += "<img src='/images/back.png' class='orderbackB'/><h4>" + categoryName + " Items </h4>";
            } else {
                htmls += "<h4>" + categoryName + " Items </h4>";
            }
            if (datas.length > 0) {
                htmls += "<div class='" + (subItem ? "items" : "itemsss") + "'>";
                $.each(datas, function (index, value) {
                    htmls += "<div><img attr-type='i' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.IsOutOfStock + "_" + value.SRate + "' class='itemimg' src='/Modules/" + (value.ImagePath == "" ? src = '/Modules/ROCompanyInfo/logo/logo.png' : 'ROI_Item/ImageItem/' + value.ImagePath) + "' width='150px' height='120px'>";
                    if (value.SRate == '0')
                        htmls += "<div class='itmname itemimg' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.IsOutOfStock + "_" + value.SRate + "'>" + value.LanguageMenuText + (value.IsOutOfStock ? '(Out Of Stock)' : '') + "</div></div>";
                    else
                        htmls += "<div class='itmname itemimg' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.IsOutOfStock + "_" + value.SRate + "'>" + value.LanguageMenuText + (value.IsOutOfStock ? '(Out Of Stock)' : '(Rs. ' + value.SRate + ')') + "</div></div>";
                });
                htmls += "</div>";
            }
            else {
                htmls += "<h6>No Item Available in this Section.</h6>"
            }
            if (subItem) {
                $('#Itemshow2').html(htmls);
                if (!orderlistviewtype) {
                    $('.items').owlCarousel({
                        navigation: true,
                        addClassActive: true
                    });
                }
            }

            else {
                $('#Itemshow').html(htmls);
                if (!orderlistviewtype) {
                    $('.itemsss').owlCarousel({
                        navigation: true,
                        addClassActive: true
                    });
                }
            }
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
    $(".itemimg").on("error", function () {
        $(this).attr('src', src = '/Modules/ROCompanyInfo/logo/logo.png');
    });
    if (orderlistviewtype) {
        $('#Itemshow').on('click', '.orderbackB', function () {
            if (subItem) {
                $('#Itemshow2').hide();
                $('#Itemshow').hide();
            }

            else {
                $('#Categoryshow').show();
                $('#Itemshow').hide();

            }
        });
    }

}
function getcomboformenu() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "getitemforcumbo",
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var datas = JSON.parse(data.d);
            if (datas.length > 0) {
                $('#tabs ul').show();
            }
            var htmls = [];
            $('#ComboMenu').html("");
            htmls += "<h4>Main Menus</h4>";
            if (datas.length > 0) {
                htmls += "<div class='menuss'>";
                $.each(datas, function (index, value) {
                    if (value.ImagePath == "")
                        htmls += "<div><img attr-type='c' id='menuimg_" + value.ComboID + "_" + value.Name + "_true_" + value.SalesPrice + "' class='menuimgg' src='/Modules/ROCompanyInfo/logo/" + companyInfo.Logo + "' width='150px' height='120px'>";
                    else
                        htmls += "<div><img attr-type='c' id='menuimg_" + value.ComboID + "_" + value.Name + "_true_" + value.SalesPrice + "' class='menuimgg' src='/Modules/ROCumboPack/images/" + value.ImagePath + "' width='150px' height='120px' alt='Image not found'>";
                    htmls += "<div attr-type='c' class='itmname menuimgg' id='menuimg_" + value.ComboID + "_" + value.Name + "_true_" + value.SalesPrice + "' >" + value.Name + " (Rs. " + value.SalesPrice + ")</div></div>";

                });
                htmls += "</div>";
                $('#ComboMenu').html(htmls);


            } else {
                htmls += "<h6>No Menu Available </h6>";
                $('#ComboMenu').html(htmls);
            }
            if (!orderlistviewtype) {
                $('.menuss').owlCarousel({

                    navigation: true,
                    addClassActive: true
                });
            }

            $(".menuimg").on("error", function () {
                $(this).attr('src', '/Modules/ROCompanyInfo/logo/logo.png');
            });
            $('.menuimgg').on('click', function () {
                if (!orderlistviewtype) {
                    $('#Categoryshow').show();
                }
                var data = $(this).attr('id');
                var values = data.split('_');
                var NpitemID = values[1];
                var NpitemName = values[2];
                var Nprate = values[4];
                var IsCombo = $(this).attr('attr-type') == 'c' ? true : false;
                BindItemsToOrder(NpitemID, NpitemName, IsCombo, false, Nprate);
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function GetExtraItemsByItem() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetExtraItemsByItem",
        data: "",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            $.each(result, function (index, value) {
                var extItm = new Object();
                extItm.ItemID = value.ItemID;
                extItm.ExtraItemID = value.ExtraItemID;
                extItm.ExtraPrice = value.ExtraPrice;
                extItm.ExtraItem = value.ExtraItem;

                ExtraItemsByItem.push(extItm);
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function BindItemsToOrder(NpitemID, NpitemName, IsCombo, IsOutOfStock, Nprate) {
    var ispresent = 1;
    var result = 0;
    $.each(OrderListArray, function (index, item) {
        if (item.ItemId == parseInt(NpitemID) && item.IsCombo == IsCombo && item.SeatNo == selectedBillNo) {
            ispresent = 0;
            result = 1;
        }
    });
    if (result == 0) {
        var order = new Object();
        order.ItemId = parseInt(NpitemID);
        order.ItemName = NpitemName;
        order.IsCombo = IsCombo;
        order.Quantity = 1;
        order.Note = "";
        order.ExtraCharge = 0.0;
        order.IsHomeDelivery = false;
        order.HomeDeliveyNumber = 0;
        order.SeatNo = selectedBillNo;
        order.GuestNo = 1;
        order.IsSplit = 0;
        order.RoomId = RoomId;
        order.TableId = TableId;
        order.Remarks = "";
        order.IsCancelled = 0;
        order.Status = 'Ordered'
        order.OrderDetailsID = 0;
        order.IsOutOfStock = IsOutOfStock;
        order.Rate = Nprate;
        OrderListArray.push(order);

        BindItemsToList();
    }
    else {
        //alert('Item Already Entered Please increase the Quantity');
        $('#qty_' + NpitemID + '_' + IsCombo).val((parseInt($('#qty_' + NpitemID + '_' + IsCombo).val()) + 1));
        $('#qty_' + NpitemID + '_' + IsCombo).keyup();

    }
}
function BindItemsToList() {
    $(".bindorderlist").html('');
    $(".bindorderlistfoot").html('');
    var htmls;
    var i = 1;
    var total = 0;
    var roles = userRole.split(',');
    //if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
    $.each(OrderListArray, function (index, item) {
        if (item.SeatNo == selectedBillNo) {
            htmls += "<tr catr='c' id='tr_" + item.ItemId + "_" + item.IsCombo + "_" + item.IsOutOfStock + "'>";
            htmls += "<td>" + i + "</td>";
            htmls += "<td>" + item.ItemName + "</td>";
            htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' />";
            htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemId + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemId + "_" + item.IsCombo + "'/>";
            htmls += "<input type='button' value='+' id='plus_" + index + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemId + "_" + item.IsCombo + "' /></td>";
            htmls += "<td class='rate'>" + item.Rate + "</td>";
            htmls += "<td class='total' style='display:none;'></td>";
            htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "_" + item.ItemId + "_" + item.ItemName + "' src='/images/extra.png' class='extra' width='30px' height='30px'/></td>";
            htmls += "</tr>";
            i = i + 1;
        }
    });
    $(".bindorderlist").html(htmls);
    CalculateTotal();

}
function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}
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
function getSelectionStart(o) {
    if (o.createTextRange) {
        var r = document.selection.createRange().duplicate()
        r.moveEnd('character', o.value.length)
        if (r.text == '') return o.value.length
        return o.value.lastIndexOf(r.text)
    } else return o.selectionStart
}
function bindForCancel(result) {
    if (result.length > 0) {
        $('.saveCanceledItem').bind('click');
        $("#tblforcancelitem tbody").html("");
        var array = [];
        $.each(OrderListArray, function (index, item) {
            array.push({ "id": item.ItemId + '_' + item.IsCombo + '_' + item.SeatNo, "qty": item.Quantity, "seatNo": item.SeatNo });
        });

        $.each(result, function (index, item) {
            var found = false;
            var qnty = 0;
            var execute = false;
            for (var i = 0; i < array.length; i++) {
                if (item.ItemID.toString() == parseInt(array[i].id.split('_')[0]) && item.SeatNo == array[i].seatNo) {
                    if (item.IsCombo.toString() == array[i].id.split('_')[1]) {
                        found = true;
                        qnty = array[i].qty;
                        execute = true;
                        break;
                    }
                }
            }
            if (!array.includes(item.ItemID + "_" + item.IsCombo + "_" + item.SeatNo)) {
                execute = true;
            }
            if (execute) {
                if ((found && qnty < item.Quantity) || !found) {
                    var htmls = "";
                    htmls += ("<tr>");
                    htmls += ("<td>" + item.ItemName + "</td>");
                    htmls += ("<td>" + (item.Quantity - qnty) + "</td>");
                    htmls += ("<td>" + item.Waiter + "</td>");
                    htmls += ("<td><textarea class='txtreason sfInputbox'></textarea></td>");
                    htmls += ("<td><select class='selResponsible sfInputbox'><option value='Waiter'>Waiter</option><option value='Customer'>Customer</option><option value='Chef'>Chef</option></select></td>");
                    htmls += ("</tr>");

                    $(htmls).appendTo("#tblforcancelitem tbody");
                }
            }
        });
        if ($('#tblforcancelitem tbody tr').length > 0) {
            $('#canceledOrderItem').dialog({
                'title': 'Canceled Items',
                width: 800,
                modal: true,
            });

            $('.saveCanceledItem').unbind('click').on('click', function () {
                var myStr = $(".txtreason").val();
                var newStr = myStr.replace(/  +/g, ' ');
                if (newStr.length <= 4) {
                    //if ($(".txtreason").val() == null || $(".txtreason").val() == "" || $(".txtreason").val() == " ") {
                    jAlert('Please Insert Cancel Reason more than 4 words.', "Alert!!", function () { $.alerts.dialogClass = null; });
                }
                else {
                    var rcount = $('#tblforcancelitem tbody tr').length;
                    var cancelobjs = new Array();
                    for (var i = 0; i < rcount; i++) {
                        cancelobj = {
                            Item: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('td:eq(0)').text(),
                            Quantity: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('td:eq(1)').text(),
                            OrderBy: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('td:eq(2)').text(),
                            CanceledBy: $('#hdnPinBy').val(),
                            Reason: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('.txtreason').val(),
                            Responsible: $('#tblforcancelitem tbody').find('tr:eq(' + i + ')').find('.selResponsible option:selected').text(),
                            tableId: TableId,
                            orderMasterID: OrderMasterID,
                        }
                        cancelobjs.push(cancelobj); 67
                    }

                    SaveCanceledItems(cancelobjs);
                }

            });
        }
        else {
            SaveOrderedData();
        }
    }
    else {
        SaveOrderedData();
    }
}
function SaveCanceledItems(cancelobjs) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "SaveCanceledItems",
        data: JSON2.stringify({ CancelItems: cancelobjs }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            SaveOrderedData();
            $('#canceledOrderItem').dialog('close');
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function SaveOrderedData() {
    var splited = false;
    var cancel = false;
    var orders = [];
    var orderDetailsList = new Array();
    for (var i = 0; i < OrderListArray.length; i++) {
        var orderDetail = new Object();
        orderDetail.Quantity = OrderListArray[i].Quantity,
            orderDetail.ItemId = OrderListArray[i].ItemId,
            orderDetail.IsCombo = OrderListArray[i].IsCombo,
            orderDetail.Rate = 0.0,
            orderDetail.Note = OrderListArray[i].Note,
            orderDetail.SeatNo = OrderListArray[i].SeatNo;
        orderDetail.Amount = 0.0
        orderDetail.Waiter = SageFrameUserName;
        orderDetailsList.push(orderDetail);

    }

    let guestNo = 1;
    if ($('#txtNoOfPax').length > 0) {

        let noOfPax = $('#txtNoOfPax').val();
        if (noOfPax.length == 0)
            noOfPax = "1";
        guestNo = parseInt(noOfPax);
    }
    var ordermaster = new Object();
    ordermaster.orderDetailsList = orderDetailsList,
        ordermaster.OrderMasterID = OrderMasterID
    ordermaster.TableId = TableId
    ordermaster.RoomId = RoomId
    ordermaster.BasicAmount = 0.0,
        ordermaster.BillNo = "",
        ordermaster.Date = Date.now,
        ordermaster.IsCancelled = cancel,
        ordermaster.TermAmount = 0.0,
        ordermaster.NetAmount = 0.0,
        ordermaster.UserName = $('#hdnPinBy').val(),
        ordermaster.Remarks = "",
        ordermaster.IsSplit = splited,
        ordermaster.GuestNo = guestNo,
        ordermaster.BillPaid = 0,
        ordermaster.ArchivedBy = $('#hdnPinBy').val();
    ordermaster.names = $('#txtCustName').val();
    ordermaster.phoneNo = $('#txtContactNo').val();
    ordermaster.membershipId = $('#CustomerID').text() == "" ? -1 : $('#CustomerID').text();
    ordermaster.TokenNo = $('#txtTokenNo').val() == "" ? 0 : $('#txtTokenNo').val();
    ordermaster.OrderTypeID = OrderDelivery == true ? 4 : (foodCourtOrder == true ? 3 : (TableId > 0 ? 1 : 2));

    //Avata Change
    ordermaster.Address = $('#txtAddress').val() == null ? '' : $('#txtAddress').val();
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "SaveOrderIntoDataBase",
        data: JSON2.stringify({ orderMasterInfo: ordermaster, orderExtraItem: ExtraItems, foodCourtOrder: foodCourtOrder }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            var val = data.d.split("_");
            var orderid = val[0];
            $.each(val, function (index, value) {
                if (index != 0) {
                    jAlert(value + " Printing Failed. Printer Not Found.", 'Alert!!');
                }
            });
            // Food Delivery
            if (OrderDelivery == true) {
                jAlert("Ordered Saved successfully", "Information!!", function () {
                    parent.$.colorbox.close();
                });
            }
            //Takeaway or Foodcourt
            else if (TableId == 0) {

                var url = SageFrameHostURL + "/POS.aspx?OID=" + val[0];
                window.location.href = url;

            }
            // Dining 
            else {
                $.alerts.dialogClass = "order-info";
                jAlert("Ordered Saved successfully", "Information!!", function () {
                    var url = SageFrameHostURL + "/Dining.aspx";
                    window.location.href = url;
                    // window.location=location.search.split("ReturnUrl=")[1];
                    //parent.$.colorbox.close();
                });
            }
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function GetDataForSalesBill(orderMasterId) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetDataForSalesBill",
        data: JSON2.stringify({ orderMasterId: orderMasterId }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            //Bind Sales Bill
            var isab = companyInfo.IsAbbreviated;

            isButtonClicked = true;
            var datas = JSON.parse(data.d);
            orderdetails = datas.orderDetail;
            console.log(orderdetails);
            billingterms = datas.billingTerm;
            costcenters = datas.cuscenter;
            var costCenterGroup = datas.costCenterGroups;
            console.log(JSON.parse(data.d));
            tokeninfo = datas.Token;
            var htmls = "";
            $('#DialogOrderDetail').html("");
            barAmount = 0.00;
            kotAmount = 0.00;
            totalAmount = 0.00;
            nonTaxableAmount = 0.00;
            kotdis = 0.00;
            bevdis = 0.00;
            roomAmount = 0.00;
            roomdis = 0.00;
            bakeryAmount = 0.00;
            bakerydis = 0.00;
            pizzaAmount = 0.00;
            pizzadis = 0.00;
            var qnty = 0.00;
            var DialogWidth = '900';

            htmls += "<div style='display: flex; justify-content: flex-end;'><input class='sfBtn restro-btn' id='btnBillClose' type='button' value='Close' /></div>"
            htmls += "<div id='dialogOrderOpen''>";
            htmls += ("<div class='dashboardmain'>");

            //Abb Changes
            if (isab) {

                totalAmount = 0;
                $.each(orderdetails, function (index, value) {
                    amt = parseFloat(value.Quantity) * parseFloat(value.Rate);

                    totalAmount += value.IsTaxable ? parseFloat(amt) : 0.00;
                    nonTaxableAmount += value.IsTaxable ? 0 : parseFloat(amt);

                    if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                        qnty = 0;
                        rate = 0.00;
                        $.each(value.orderExtraItem, function (index, value) {
                            htmls += (value.ExtraItem) + "(" + value.Quantity + ", Rs." + value.ExtraPrice + "); ";
                            qnty += value.Quantity;
                            rate += parseFloat(value.ExtraPrice * value.Quantity);
                        });
                        amt = parseFloat(rate);

                        totalAmount += parseFloat(amt);
                    }
                });

                totaldis = 0;

                //Check
                totaldis += (parseFloat(kotAmount) * (parseFloat(costcenters[0].coDiscount) / 100));

                totaldis += (parseFloat(barAmount) * (parseFloat(costcenters[1].coDiscount) / 100));

                totaldis += (parseFloat(bakeryAmount) * (parseFloat(costcenters[2].coDiscount) / 100));

                totaldis += (parseFloat(pizzaAmount) * (parseFloat(costcenters[4].coDiscount) / 100));
                //Check


                if (totaldis == null || totaldis == "") {
                    totaldis = 0;
                }

                amntAfterDisc = 0;
                amntAfterDisc = (parseFloat(totalAmount) + parseFloat(nonTaxableAmount) - parseFloat(totaldis)).toFixed(2);
                netAmount = 0.00;
                $.each(datas.billingTerm, function (index, item) {

                    if (item.BillTerm != "Home Delivery") {
                        if (item.BillTerm != "Evening Discount") {
                            if (item.BillTerm != "VAT") {
                                if (item.IsAdd == 1)
                                    netAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                                else
                                    netAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                            }
                        }
                    }
                });
                netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc)).toFixed(2));
                if (datas.VATforBill) {
                    if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {

                        var vat = parseFloat(netAmount * 0.13).toFixed(2);
                        netAmount = (parseFloat(netAmount) + parseFloat(vat)).toFixed(2);
                    }
                }

                isAbbreviated = true;

                var v_rate = companyInfo.VATRate;

                if (netAmount > companyInfo.AbbreviatedValue) {
                    isAbbreviated = false;
                    v_rate = 0.0;
                }
            }


            //AddChanges 

            if (orderdetails.length > 0) {
                htmls += ("<div class='left-sec'><h4>POS/ CASHIER: " + orderdetails[0].Waiter + "</h4>");
                htmls += ("<h5>Ordered Items Details</h5>");
                htmls += ("<div class='item_list_div'><table class='item-list-tbl'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody id='salesDetailsTbl'>");

                var sn = 1;
                $.each(orderdetails, function (index, value) {
                    htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                    htmls += ("<td>" + value.Quantity + "</td>");

                    if (!isab) {
                        htmls += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' data-taxable='" + value.IsTaxable + "' >" + value.Rate + "</td>");
                    }
                    else {
                        if (isAbbreviated) {
                            htmls += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' data-taxable='" + value.IsTaxable + "'>" + (value.Rate * (1 + v_rate / 100.0)).toFixed(2) + "</td>");

                        }
                        else {
                            htmls += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' data-taxable='" + value.IsTaxable + "'>" + value.Rate + "</td>");
                        }
                    }
                    qnty += parseFloat(value.Quantity);
                    amt = parseFloat(value.Quantity) * parseFloat(value.Rate);

                    if (!isab) {
                        totalAmount += value.IsTaxable ? parseFloat(amt) : 0.00;
                        nonTaxableAmount += value.IsTaxable ? 0 : parseFloat(amt);
                    }

                    if (!isab)
                        htmls += ("<td class='item-amount'>" + amt + "</td></tr>");
                    else
                        htmls += ("<td class='item-amount'>" + (amt * (1 + v_rate / 100.0)).toFixed(2) + "</td></tr>");

                    const group = costCenterGroup.filter(x => x.GroupId === value.GroupId)
                    if (group.length > 0) {
                        const i = costCenterGroup.findIndex(x => x.GroupId === value.GroupId);

                        costCenterGroup[i].TotalAmt += value.IsTaxable ? parseFloat(amt) : 0.00;
                        costCenterGroup[i].NonTaxableAmt += value.IsTaxable ? 0 : parseFloat(amt);
                    }


                    if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                        htmls += ("<tr class='allsplited' style='font-size: 10px;font-style: italic;'><td></td><td colspan=3>");
                        qnty = 0;
                        rate = 0.00;
                        $.each(value.orderExtraItem, function (index, value) {
                            htmls += (value.ExtraItem) + "(" + value.Quantity + ", Rs." + value.ExtraPrice + "); ";
                            qnty += value.Quantity;
                            rate += parseFloat(value.ExtraPrice * value.Quantity);
                        });
                        htmls += "</td>";
                        //htmls += ("</td><td>" + qnty + "</td>");
                        //htmls += ("<td class='item-rate'>" + (rate/qnty) + "</td>");
                        amt = parseFloat(rate);


                        totalAmount += value.IsTaxable ? parseFloat(amt) : 0.00;
                        nonTaxableAmount += value.IsTaxable ? 0 : parseFloat(amt);



                        if (!isab)
                            htmls += ("<td class='item-amount'>" + amt + "</td></tr>");
                        else
                            htmls += ("<td class='item-amount'>" + (amt * (1 + v_rate / 100.0)).toFixed(2) + "</td></tr>");

                        const group = costCenterGroup.filter(x => x.GroupId === value.GroupId)
                        if (group.length > 0) {
                            const i = costCenterGroup.findIndex(x => x.GroupId === value.GroupId);
                            costCenterGroup[i].TotalAmt += amt;
                        }


                    }
                    sn++;
                });

                if (isab) {
                    if (isAbbreviated) {
                        htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : Rs.<span class='totle'> " + ((totalAmount * (1 + v_rate / 100.0)) + nonTaxableAmount).toFixed(2) + "</span></td></tr>");
                    }
                    else {
                        htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + (totalAmount + nonTaxableAmount).toFixed(2) + "</span></td></tr>");
                    }
                }
                else {
                    htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='3'  style='text-align:right;font-weight:bold;'>Total Qnty : " + qnty.toFixed(2) + "</td><td colspan='2'  style='text-align:right;font-weight:bold;'>Amount : <span class='totle'>Rs. " + (totalAmount + nonTaxableAmount).toFixed(2) + "</span></td></tr>");
                }
                htmls += ("</tfoot></table></div>");


            } else {
                htmls += ("<div class='left-sec'><h4>Take Away </h4>");
            }

            htmls += ("<h4>Discount Method</h4><div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'><div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");

            //Change For Dis Limit
            disLimitBasicAmt = totalAmount + nonTaxableAmount;
            totaldis = 0;

            htmls += ("<tr>");
            htmls += ("<td>Discount Type : </td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option><option value='3'>Loyalty</option></select> </td>");
            htmls += ("<td> <input id='enablebtn' type='button'  class='sfBtn restro-btn' value='Enable' style='width:50px;'/></td></tr>");

            $.each(costCenterGroup, function (index, item) {
                htmls += "<tr class='disc' style='" + ((orderdetails.length > 0) ? "" : "display:none") + "'><td>" + item.GroupName + " ( Rs. " + (item.TotalAmt + item.NonTaxableAmt).toFixed(2) + " ) </td><td>";
                htmls += "<input type='text' class='sfInputbox txtdiscount txt_dis' data-groupId='" + item.GroupId + "' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='index_" + index + "' value='" + 0 + "' /></td>";
            });
            htmls += "<tr class='loyaltydisc' style='display:none;'><td>Loyalty Discount : </td><td>";
            htmls += "<input type='text' class='sfInputbox txtdiscount' style='width:100px;' onkeypress='return IntegerAndDecimal(event,this);' id='txtLoyaltyDiscount' value='" + 0 + "' disabled /></td>";
            htmls += "</tr>";
            htmls += ("</tbody></table></div>");

            htmls += '<div id="divBillingTerm"></div></div></div>';

            htmls += '<div class="right-sec"><div class="right-secA"><h4>Customer Info</h4><table><tbody>';
            htmls += '<div id="divPaymentModes"></div>';
            htmls += '</tbody></table></div>';
            htmls += '<input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/>';

            htmls += '<div id="divPaymentModes"></div>';

            htmls += '</div ></div >';
            htmls += ("</div></div></div></div>");
            htmls += ("<input id='Pay_TakeAway_" + orderdetails[0].OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
            var orderMasterId = orderdetails[0].OrderMasterId;
            $('#DialogOrderDetail').html(htmls);
            $('#DialogOrderDetail').show();
            $('#OrderMenu').hide();

            BindBillingTerm(totalAmount, nonTaxableAmount, totaldis, 0, 0, datas);

            $("#btnBillClose").on('click', function () {
                $('#DialogOrderDetail').html('');
                $('#DialogOrderDetail').hide();
                $('#OrderMenu').show();
            });


            $(".txtdiscount").on('click', function (event) {
                InitializeNumPin(this, $(this).val());
            });

            $(".txtnum").on('click', function (event) {
                InitializeNumPin(this, $(this).val());
            });

            $(".ui-dialog-titlebar-close").click(function () {
                window.parent.location.reload();
            });

            if (tokeninfo.length > 0) {
                if (tokeninfo[0].CustomerID > 0) {
                    GetmembershiplistbyId(tokeninfo[0].CustomerID);
                }
            }

            if (foodCourtOrder) {
                getProviderList();
                $("#selPayMode").on('change', function () {
                    let val = $("#selPayMode").val();
                    if (val == 1) { //for cash
                        //$("#calculator").show();
                        $(".cashpay").show();
                        $("#prov").hide();
                        $("#trans").hide();
                        $("#cheq").hide();
                    }
                    if (val == 2) {
                        //$("#calculator").hide();
                        $(".cashpay").hide();
                        $("#prov").show();
                        $("#trans").hide();
                        $("#cheq").show();
                        //$("#btnPay").show();
                    }
                    if (val == 3 || val == 5 || val == 6) {
                        //$("#calculator").hide();
                        $(".cashpay").hide();
                        $("#prov").show();
                        $("#trans").show();
                        $("#cheq").hide();
                        //$("#btnPay").show();
                    }
                    //if ($("#selPayMode").val() == 4) {
                    //    //$("#calculator").hide();
                    //    $(".cashpay").hide();
                    //    $("#prov").hide();
                    //    $("#trans").hide();
                    //    $("#cheq").hide();
                    //    //$("#btnPay").show();
                    //    membershipfor = "payment";
                    //    if (CustID > 0)
                    //        DashboardFunction.DeleteItem(CustID);
                    //    else
                    //        DashboardFunction.GetCustomeronChange();
                    //    $("#CashPaid").hide();
                    //}
                });
                $("#txtTenderAmount, #txtReturnAmount").on('click', function () {
                    $(this).val('');
                });
                $("#txtTotalCalc, #txtTenderAmount").on("keydown keyup change", function () {
                    var returnAmnt = (Number($("#txtTenderAmount").val()) - Number($("#txtTotalCalc").val())).toFixed(2);
                    $("#txtReturnAmount").val((parseFloat(returnAmnt) > 0 ? parseFloat(returnAmnt) : 0));
                });
            }

            $("#txtCardNumber").on('change', function () {
                var info = $("#txtCardNumber").val();
                if (info != "") {
                    getMemberDetailsbyinfo(info);
                }
            });

            $("#txtNumber").on('change', function () {
                var info = $("#txtNumber").val();
                if (info != "") {
                    getMemberDetailsbyinfo(info);
                }
            });

            $('.customerForCash').on('change', function () {
                if ($('.customerForCash').prop('checked') == true) {
                    GetCustomeronCheck();
                    $("#membeshipformlist").dialog({
                        'title': 'Customer',
                        width: 800,
                        modal: true,
                        resizable: true,
                        position: ['center', 'center']
                    });
                } else {
                    $('#CustomerID').val(0);

                    $("#txtCustName").val("");
                    $("#txtCusAddress").val();
                    $("#txtPanNo").val("");

                    $("#txtCustName").prop('disabled', false);
                    $("#txtCusAddress").prop('disabled', false);
                    $("#txtPanNo").prop('disabled', false);

                    /* $("#selDiscountType").val(1);*/
                    $("#txtLoyaltyDiscount").val(0);
                }
            })
            $("#selDiscountType").on('change', function () {
                $('#txtKotDiscount').prop('disabled', false);
                $('#txtBarDiscount').prop('disabled', false);
                $('#txtRoomDiscount').prop('disabled', false);
                $('#txtBakeryDiscount').prop('disabled', false);
                $('#txtPizzaDiscount').prop('disabled', false);

                $('#txtKotDiscount').val(0);
                $('#txtBarDiscount').val(0);
                $('#txtRoomDiscount').val(0);
                $('#txtBakeryDiscount').val(0);
                $('#txtPizzaDiscount').val(0);

                $(".txt_dis").val(0);

                barAmount = 0.00;
                kotAmount = 0.00;
                totalAmount = 0.00;
                nonTaxableAmount = 0.00;
                var totalAmountN = 0.00;
                kotdis = 0.00;
                bevdis = 0.00;
                totaldis = 0;
                bakeryAmount = 0.00;
                bakerydis = 0.00;
                pizzaAmount = 0.00;
                pizzadis = 0.00;
                $('.item-list-tbl tbody').html("");
                var sn = 1;
                $.each(orderdetails, function (index, value) {
                    var itms = "";

                    itms += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ROI_ItemId + "+" + value.CostCenterId + "+" + value.IsCombo + "+" + value.OrderDetailsID + "+" + value.RoomBookDetailID + "'>" + value.ITName + "</td>");
                    itms += ("<td>" + value.Quantity + "</td>");

                    if (!isab)
                        itms += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + value.Rate + "</td>");
                    else {
                        if (isAbbreviated) {
                            itms += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + (value.Rate * (1 + v_rate / 100.0)).toFixed(2) + "</td>");

                        }
                        else {
                            itms += ("<td class='item-rate' data-groupId='" + value.GroupId + "' data-rate='" + value.Rate + "' >" + value.Rate + "</td>");
                        }
                    }
                    amt = parseFloat(value.Quantity) * parseFloat(value.Rate);

                    //if (!isab) {
                    totalAmount += value.IsTaxable ? parseFloat(amt) : 0.00;
                    nonTaxableAmount += value.IsTaxable ? 0 : parseFloat(amt);

                    //}

                    if (!isab)
                        itms += ("<td class='item-amount'>" + amt + "</td></tr>");
                    else
                        itms += ("<td class='item-amount'>" + (amt * (1 + v_rate / 100.0)).toFixed(2) + "</td></tr>");



                    if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                        itms += ("<tr class='allsplited' style='font-size: 10px;font-style: italic;'><td></td><td colspan=3>");
                        qnty = 0;
                        rate = 0.00;
                        $.each(value.orderExtraItem, function (index, value) {
                            itms += (value.ExtraItem) + "(" + value.Quantity + ", Rs." + ($("#selDiscountType").val() == "4" ? '1' : value.ExtraPrice) + "); ";
                            qnty += value.Quantity;
                            rate += parseFloat(value.Quantity * value.ExtraPrice);
                        });
                        itms += ("</td>");
                        //itms += ("</td><td>" + qnty + "</td>");
                        if ($("#selDiscountType").val() == "4") {
                            //itms += ("<td class='item-rate'>" + 1 + "</td>");
                            amt = parseFloat(qnty);
                        } else {
                            //itms += ("<td class='item-rate'>" + rate + "</td>");
                            amt = parseFloat(rate);
                        }
                        totalAmount += parseFloat(amt);

                        //console.log('totalAmount: ' + totalAmount);

                        itms += ("<td class='item-amount'>" + amt + "</td></tr>");


                    }
                    sn++;
                    $('.item-list-tbl tbody').append(itms);
                });

                totalAmount += roomAmount;

                if (isab) {
                    if (isAbbreviated) {
                        totalAmountN = totalAmount * (1 + v_rate / 100);
                        $('.totle').text((totalAmountN).toFixed(2));

                    } else {
                        $('.totle').text((totalAmount - roomAmount).toFixed(2));
                    }
                } else {

                    $('.totle').text((totalAmount + nonTaxableAmount - roomAmount).toFixed(2));
                }


                $('.roomtotle').text('Rs. ' + (totalAmount).toFixed(2));

                if ($("#selDiscountType").val() == "3") {
                    if ($("#CustomerID").val() != "" && parseInt($("#CustomerID").val()) == 0) {
                        $('.customerForCash').prop('checked', true);
                        $('.customerForCash').change();
                    }
                    $("#txtLoyaltyDiscount").change();
                    $(".disc").hide();
                    $(".roomdisc").hide();
                    $(".loyaltydisc").show();
                } else {
                    $(".disc").show();
                    //if (tableinfo.RoomBookDetailsID > 0) {
                    //    $(".roomdisc").show();
                    //}
                    $(".loyaltydisc").hide();
                }


                BindBillingTerm(totalAmount, nonTaxableAmount, totaldis, 0, 0, datas);
            });
            $("#txtLoyaltyDiscount").on('change', function () {
                $('#txtKotDiscount').val(0);
                $('#txtBarDiscount').val(0);
                $('#txtRoomDiscount').val(0);
                $('#txtBakeryDiscount').val(0);
                $('#txtPizzaDiscount').val(0);
                var lolDisRate = parseFloat($("#txtLoyaltyDiscount").val());
                var totalAmountN = 0.00;

                if (isab) {
                    if (isAbbreviated) {
                        var itemrow = $('#salesDetailsTbl').find('tr');
                        $.each(itemrow, function (index, value) {
                            _this = $(this);
                            var qty = parseFloat(_this.find('td').eq(2).text());
                            var rate = _this.find('td').eq(3);
                            var itemGroupId = rate.data('groupid');
                            var rateInt = parseFloat(rate.data('rate'));
                            var disAbb = parseFloat((rateInt * (100 - lolDisRate) / 100) * (1 + v_rate / 100));
                            rate.text(disAbb.toFixed(2))
                            _this.find('td').eq(4).text((qty * disAbb).toFixed(2))
                            totalAmountN += parseFloat(_this.find('td').eq(4).text());

                        });
                        // cgGroup.TotalDis = disRate;
                        $('.totle').text((totalAmountN).toFixed(2));
                    }
                }

                totaldis += ((totalAmount + nonTaxableAmount) * (lolDisRate) / 100);


                BindBillingTerm(totalAmount, nonTaxableAmount, totaldis, 0, 0, datas);
            });

            $('.txt_dis').on('keyup', function () {

                debugger;
                totalAmount = 0.00;
                nonTaxableAmount = 0.00
                $.each(costCenterGroup, (i, v) => {
                    totalAmount += v.TotalAmt;
                    nonTaxableAmount += v.NonTaxableAmt;
                });

                var totalAmountN = 0.00;
                var currGroupId = $(this).data('groupid');
                var currIndex = $(this).attr('id').split('_')[1];
                var cgGroup = costCenterGroup.find(x => x.GroupId == currGroupId);

                if ($("#selDiscountType").val() == "1") {
                    if (($(this).val()) > 100 || ($(this).val()) < 0) {
                        jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                        $(this).val(0);
                    }

                    var disRate = parseFloat($(this).val() == "" ? 0 : $(this).val());
                    var dis = 0
                    var disNonTax = 0

                    //Bishal Added
                    if (isab) {
                        if (isAbbreviated) {
                            var itemrow = $('#salesDetailsTbl').find('tr');
                            $.each(itemrow, function (index, value) {
                                _this = $(this);
                                var qty = parseFloat(_this.find('td').eq(2).text());
                                var rate = _this.find('td').eq(3);
                                var itemGroupId = rate.data('groupid');
                                var rateInt = parseFloat(rate.data('rate'));
                                if (itemGroupId == currGroupId) {
                                    var disAbb = parseFloat((rateInt * (100 - disRate) / 100) * (1 + v_rate / 100));
                                    rate.text(disAbb.toFixed(2))
                                    _this.find('td').eq(4).text((qty * disAbb).toFixed(2))
                                }
                                totalAmountN += parseFloat(_this.find('td').eq(4).text());

                            });
                            // cgGroup.TotalDis = disRate;
                            $('.totle').text((totalAmountN).toFixed(2));

                        } //else {
                        $(".txt_dis").each(function () {
                            var keyIndex = $(this).attr('id').split('_')[1];
                            dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat($(this).val() / 100)));
                            costCenterGroup[keyIndex].TotalDis = parseFloat($(this).val());
                        })

                        totaldis = dis;
                        //}
                    } else {
                        $(".txt_dis").each(function () {
                            var keyIndex = $(this).attr('id').split('_')[1];
                            dis += (parseFloat(costCenterGroup[keyIndex].TotalAmt) * (parseFloat($(this).val() / 100)));
                            disNonTax += (parseFloat(costCenterGroup[keyIndex].NonTaxableAmt) * (parseFloat($(this).val() / 100)));
                            costCenterGroup[keyIndex].TotalDis = parseFloat($(this).val());

                        })
                        totaldis = dis + disNonTax;
                    }

                }
                else {

                    if ($(this).val() > (costCenterGroup[currIndex].TotalAmt + costCenterGroup[currIndex].NonTaxableAmt) || $(this).val() < 0) {
                        jAlert('Invalid Discount.', "Alert!!", function () { $.alerts.dialogClass = null; });
                        $(this).val(0);
                    }

                    var dis = 0
                    var disNonTax = 0

                    if (isab) {
                        if (isAbbreviated) {
                            var ttldis = parseFloat($(this).val() == "" ? 0 : $(this).val());
                            var ttl = cgGroup.TotalAmt == "" ? 0 : (cgGroup.TotalAmt + cgGroup.NonTaxableAmt);
                            var disPercent = 0.00;
                            if (ttldis > 0) {
                                disPercent = (ttldis * 100) / ttl;
                            }
                            var itemrow = $('#salesDetailsTbl').find('tr');
                            $.each(itemrow, function (index, value) {
                                _this = $(this);
                                var qty = parseFloat(_this.find('td').eq(2).text());
                                var rate = _this.find('td').eq(3);
                                var itemGroupId = rate.data('groupid');
                                var rateInt = parseFloat(rate.data('rate'));
                                if (itemGroupId == currGroupId) {
                                    var disAbb = parseFloat((rateInt * (100 - disPercent) / 100) * (1 + v_rate / 100));
                                    rate.text(disAbb.toFixed(2))
                                    _this.find('td').eq(4).text((qty * disAbb).toFixed(2))

                                }
                                totalAmountN += parseFloat(_this.find('td').eq(4).text());

                            });
                            //cgGroup.TotalDis = ttldis;
                            $('.totle').text((totalAmountN).toFixed(2));

                        }

                        $(".txt_dis").each(function () {
                            var keyIndex = $(this).attr('id').split('_')[1];
                            dis += parseFloat($(this).val());
                            costCenterGroup[keyIndex].TotalDis = dis;
                        })

                        totaldis = dis;


                    } else {
                        $(".txt_dis").each(function () {
                            var _this = $(this);
                            var keyIndex = _this.attr('id').split('_')[1];
                            var nonTaxTotal = costCenterGroup[keyIndex].NonTaxableAmt == "" ? 0 : costCenterGroup[keyIndex].NonTaxableAmt;
                            var taxableTotal = costCenterGroup[keyIndex].TotalAmt == "" ? 0 : costCenterGroup[keyIndex].TotalAmt;
                            var total = nonTaxTotal + taxableTotal;
                            if (total > 0) {
                                dis += (taxableTotal / total) * parseFloat(_this.val());
                                disNonTax += (nonTaxTotal / total) * parseFloat(_this.val());

                            }
                            costCenterGroup[keyIndex].TotalDis = parseFloat(_this.val());
                        })
                        totaldis = dis + disNonTax;

                    }

                }

                console.log(costCenterGroup);
                BindBillingTerm(totalAmount, nonTaxableAmount, totaldis, dis, disNonTax, datas);
            })

            var roles = userRole.split(',');
            if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                $("#enablebtn").hide();
            }
            else {
                $("#selDiscountType").prop('disabled', true);
                $(".txtdiscount").prop('disabled', true);
                $("#enablebtn").show();
            }

            $("#generateBill").on('click', function () {


                //alert(creditLimit);
                if ($('.customerForCash').prop('checked') == false) {

                    var basicAmt = parseFloat(disLimitBasicAmt);
                    //var tempDis = $('.totalDiscount').val().split('.');
                    var ttlDis = parseFloat($('.totalDiscount').attr('attr-amount'));

                    var disper = parseFloat((ttlDis * 100) / basicAmt);

                    // Check for discount limit
                    var creditlimit = creditLimit; //Percentage
                    if (creditlimit >= disper) {
                        $('#hdnPinFor').val('generateBill');
                        InitializePin();
                    }
                    else {
                        jAlert('Discount limit exceed. Please contact admin or higher authority !!!!', "Alert !!!", function () { $.alerts.dialogClass = null; });
                    }
                }
                else {

                    if (foodCourtOrder && foodCourtAutoBillGenerate) {
                        $('.paynows').click();
                    } else {
                        $('#hdnPinFor').val('generateBill');
                        InitializePin();
                    }
                }


            });

            $('#enablebtn').on('click', function () {
                $('#hdnPinFor').val('enablebtn');
                InitializePin();
            });
            $('.paynows').unbind('click').on('click', function () {
                console.log($('#txtNonTaxableAmt').val().split(' ')[1])
                console.log($('#txtTaxableAmt').val().split(' ')[1])
                var billingTerm = new Array();
                var salesMaster = new Object();
                var splited = 0;
                var salesDetail = new Array();

                salesMaster.billNo = orderdetails[0].BillNo;
                salesMaster.BillDate = new Intl.DateTimeFormat('en-US').format(new Date());
                salesMaster.NepaliInvoiceDate = formatDate();
                salesMaster.NonTaxable = parseFloat($('#txtNonTaxableAmt').val().split(' ')[1])
                salesMaster.BasicAmount = (parseFloat($('#txtTaxableAmt').val().split(' ')[1]));
                salesMaster.RoomId = 0;
                salesMaster.TableId = parseInt(0);
                salesMaster.OrderMasterId = orderdetails[0].OrderMasterId;
                salesMaster.totaldiscount = totaldis;
                salesMaster.TermAmount = 0.00;
                salesMaster.NetAmount = parseFloat($('#txtNetAmt').val().split(' ')[1]);
                salesMaster.CusName = $('#txtCustName').val();
                salesMaster.Address = $('#txtCusAddress').val();
                salesMaster.PAN = $('#txtPanNo').val();
                salesMaster.ChequeNo = "";
                salesMaster.TransactionNo = "";
                salesMaster.CusID = ($('#CustomerID').val() == "" ? 0 : parseInt($('#CustomerID').val()));
                salesMaster.sumKot = kotAmount;
                salesMaster.sumBev = barAmount;
                salesMaster.Waiter = orderdetails[0].Waiter;
                salesMaster.SPMID = 0;
                salesMaster.IsSplit = 0;
                salesMaster.SeatNo = 1;
                salesMaster.AddedBy = $('#hdnPinBy').val();;
                salesMaster.RoomRate = 0;
                salesMaster.BookedDays = 0;
                salesMaster.RoomCharge = 0;
                salesMaster.AdvancePayment = 0;
                salesMaster.sumBakery = bakeryAmount;
                salesMaster.sumPizza = pizzaAmount;
                salesMaster.DeliveryCharge = 0;
                salesMaster.DeliveredBy = "";

                $.each(billingterms, function (index, value) {
                    if (document.getElementById('BTerm_' + value.ID + '_' + value.IsAdd) != null) {
                        var bt = {
                            ID: value.ID,
                            Rate: value.Rate,
                            IsAdd: value.IsAdd,
                            Amount: $('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]
                        }
                        salesMaster.TermAmount += parseFloat($('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]);
                        billingTerm.push(bt);
                    }
                });

                var bt = {
                    ID: 1,
                    Rate: 0,
                    IsAdd: false,
                    Amount: $('#txtNetAmt').val().split(' ')[1]
                }
                billingTerm.push(bt);

                $.each(orderdetails, function (index, value) {
                    var extra = [];
                    if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                        $.each(value.orderExtraItem, function (index, item) {
                            var ext = {
                                ItemID: value.ROI_ItemId,
                                ExtraItemID: item.ExtraItemID,
                                ExtraItem: item.ExtraItem,
                                Quantity: item.Quantity,
                                Rate: ($('#selDiscountType').val() == "4" ? 1 : item.ExtraPrice),
                                Amount: ($('#selDiscountType').val() == "4" ? (item.Quantity * 1) : (item.Quantity * item.ExtraPrice))
                            }
                            extra.push(ext);
                        });
                    };
                    var sd = {
                        ItemId: value.ROI_ItemId,
                        qty: value.Quantity,
                        rate: ($('#selDiscountType').val() == "4" ? 1 : value.Rate),
                        Amount: ($('#selDiscountType').val() == "4" ? (value.Quantity * 1) : value.Amount),
                        NetAmount: value.Amount,
                        OrderDetailsID: value.OrderDetailsID,
                        CostCenterId: value.CostCenterId,
                        IsCombo: value.IsCombo,
                        extraSales: extra
                    }
                    salesDetail.push(sd);
                });

                var discount = new Object();
                discount.orderMasterId = orderdetails[0].OrderMasterId;
                discount.kotdis = $('#txtKotDiscount').val();
                discount.bardis = $('#txtBarDiscount').val();
                discount.roomdis = 0;
                discount.isflatdis = ($('#selDiscountType').val() == "2" ? true : false);
                discount.isLoyalty = ($('#selDiscountType').val() == "3" ? true : false);
                discount.loyaltydis = $('#txtLoyaltyDiscount').val();
                discount.bakerydis = $('#txtBakeryDiscount').val();
                discount.pizzadis = $('#txtPizzaDiscount').val();
                discount.CCGroup = costCenterGroup;

                //if (foodCourtOrder) {
                var salesPaymentList = new Array();
                $('.pmntCheck').each(function () {
                    if ($(this).is(':checked')) {
                        var row = $(this).closest('tr');
                        var spmid = $(this).attr('id').split('_')[1];
                        var salesPayment = new Object();
                        salesPayment.SPMID = spmid;
                        salesPayment.ChequeNo = 000000;
                        salesPayment.TransactionNo = 00000;
                        salesPayment.ProviderID = 1;
                        salesPayment.CusID = $('#CustomerID').val();
                        salesPayment.Customer = $('#txtCustName').val();
                        salesPayment.Address = $('#txtCusAddress').val();
                        salesPayment.PAN = $('#txtPanNo').val();
                        salesPayment.PayAmount = $(row).find('.txtPayAmount').val();
                        salesPayment.TenderAmount = TotalNetAmount;
                        salesPayment.ReturnAmount = 0;
                        salesPayment.BillAmount = TotalNetAmount;
                        salesPayment.Remarks = "Paid";
                        salesPaymentList.push(salesPayment);
                    }
                });

                jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
                    if (confirmed) {
                        SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPaymentList)
                    }
                });
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function InitEvents() {
    $('body').off('keyup').on('keyup', function (e) {
        e.preventDefault();
        var key = e.key.toLowerCase();

        if (e.altKey && key == "o") {
            $('#SendOrder').trigger('click');
        }
        if (e.altKey && key == "b") {
            $('#generateBill').trigger('click');
        }
        if (e.altKey && key == "n") {
            var url = SageFrameHostURL + "/POS.aspx";
            window.location.href = url;
        }

    });
}
function BindPaymentModes() {
    $("#divPaymentModes").html("");
    var htmls = "";

    $.ajax({
        type: "POST",
        url: "/Modules/AdvanceReport/AdvanceReportService.asmx/GetPaymentModes",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {

            htmls += '<div class="unpaidbill_ttl" style="display:flex;justify-content:space-between;"><h6>Total Amount : Rs. ' + TotalNetAmount + '</h6>';
            htmls += '<h6 id="surplusDeficit" style="text-align:right;">Surplus/Deficit : Rs. <span id="txtsurplus">0</span></h6></div>';
            htmls += '<table id="tblPayment" style="background:#F3F3F3;border-radius: 3px 3px 0px 0px;padding: 10px;">';

            var response = JSON.parse(response.d ?? '{}');
            if (response != null && response.length > 0) {
                $.each(response, function (index, item) {
                    htmls += '<tr>';
                    if (index == 0) {
                        htmls += '<td><input type="checkbox" checked="checked"  class="pmntCheck" id="chkBox_' + item.PaymentModeID + '" /><label for="chkBox_' + item.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + item.PaymentMode + ' : </label></td>';

                    } else {
                        htmls += '<td><input type="checkbox"  class="pmntCheck" id="chkBox_' + item.PaymentModeID + '" /><label for="chkBox_' + item.PaymentModeID + '" style="margin:0;margin-left:5px;font-weight:bold;cursor:pointer;">' + item.PaymentMode + ' : </label></td>';
                    }
                    if (index == 0) {
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" value="' + TotalNetAmount + '" /></td>';
                    } else {
                        htmls += '<td>Pay Amount <input type="text" class="pmt sfInputbox txtPayAmount" value="0" /></td>';
                    }
                    htmls += '</tr>';
                });

                htmls += '</table>';
                $("#divPaymentModes").html(htmls);
            }
        },
        error: function (msg) { FileManager.errorFn(); }
    });


    $('.txtPayAmount').on('change', function () {
        //debugger;
        totalPayAmnt = 0.00;
        $('.txtPayAmount').each(function () {
            if ($(this).closest('tr').find('.pmntCheck').is(':checked')) {
                totalPayAmnt += parseFloat($(this).val());
            }
        })
        $('#txtsurplus').html((totalPayAmnt - TotalNetAmount).toFixed(2));
        if (totalPayAmnt > TotalNetAmount) {
            document.getElementById("surplusDeficit").setAttribute("style", "color:green !important");
        } else if (totalPayAmnt < TotalNetAmount) {
            document.getElementById("surplusDeficit").setAttribute("style", "color:red !important");
        } else {
            document.getElementById("surplusDeficit").setAttribute("style", "color:black !important");
        }
    });
    $('.pmntCheck').on('change', function () {
        _this = $(this);
        var totalChecked = $(".pmntCheck:checked").size();
        if (totalChecked < 1) {
            $('#generateBill').prop('disabled', true);
        } else {
            $('#generateBill').prop('disabled', false);
        }

        if (_this.attr('id').split('_')[1] == "4" && _this.is(':checked') && !$("#chkcustomerForCash").is(':checked')) {
            _this.prop('checked', false);
            jAlert('Please Select Customer First !!!', "Information!!", function () {
            });
        } else {
            if (!_this.is(':checked')) {
                _this.closest('tr').find('.txtPayAmount').val(0);
                $('.txtPayAmount').change();
            } else {
                var surplusDef = parseFloat($('#txtsurplus').html());
                if (surplusDef < 0) {
                    if (_this.attr('id').split('_')[1] == "1") {
                        $("#txtTenderAmount").val(Math.abs(surplusDef));
                        $("#txtReturnAmount").val('0');
                    }
                    _this.closest('tr').find('.txtPayAmount').val(Math.abs(surplusDef));
                    $('.txtPayAmount').change();
                } else {
                    if (_this.attr('id').split('_')[1] == "1") {
                        $("#txtTenderAmount").val('0');
                        $("#txtReturnAmount").val('0');
                    }
                }
            }
        }


    });
};
function BindBillingTerm(totalAmount, nonTaxableAmount, totaldis, disTax, disNonTax, datas) {
    //Abb Change
    var isab = companyInfo.IsAbbreviated;
    let v_rate = companyInfo.VATRate;



    if (isab) {
        if (!isAbbreviated) {
            v_rate = 0.0;
        }

        if (totaldis == null || totaldis == "") {
            totaldis = 0;
        }
    }
    //Abb Change
    var htmls = "";

    $("#divBillingTerm").html(htmls);
    amntAfterDisc = 0;
    htmls += ("<table id='billingTerm' style='border-top: 1px solid gainsboro;'>");
    htmls += ("<tr>");
    if (!isab) {
        htmls += (" <td attr-term='Total Discount' attr-percent='0' ><strong>Total Discount : </strong><input type=\"text\" value=\"Rs. " + parseFloat(totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
        htmls += (" <tr style='border-bottom: 1px solid black;'><td attr-term='Total' ><strong>Total : </strong><input type=\"text\" value=\"Rs. " + (parseFloat(totalAmount + nonTaxableAmount) - parseFloat(disTax + disNonTax)).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "'/></td></tr>");
    }
    else {
        if (isAbbreviated) {
            htmls += (" <td attr-term='Total Discount' attr-percent='0' style='display: none;'><strong>Total Discount : </strong><input type=\"text\" value=\"Rs." + (totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
            htmls += (" <tr style='border-bottom: 1px solid black;'><td attr-term='Total' style='display: none;'><strong>Total : </strong><input type=\"text\" value=\"Rs. " + (totalAmount - totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (totalAmount - totaldis) + "'/></td></tr>");
        } else {
            htmls += (" <td attr-term='Total Discount' attr-percent='0' ><strong>Total Discount : </strong><input type=\"text\" value=\"Rs. " + (totaldis * (1 + v_rate / 100.0)).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
            htmls += (" <tr style='border-bottom: 1px solid black;'><td attr-term='Total' ><strong>Total : </strong><input type=\"text\" value=\"Rs. " + ((parseFloat(totalAmount) - parseFloat(totaldis)) * (1 + v_rate / 100.0)).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "'/></td></tr>");

        }
    }

    amntAfterDisc = (parseFloat(totalAmount - disTax) + parseFloat(nonTaxableAmount - disNonTax)).toFixed(2);
    netAmount = 0.00;


    $.each(datas.billingTerm, function (index, item) {
        //if (item.Name != "Service Charge") 
        {
            if (item.BillTerm != "Evening Discount") {
                if (item.BillTerm != "VAT") {
                    htmls += ("<tr>");
                    htmls += ("<td attr-term='" + item.BillTerm + "' attr-percent='" + item.Rate + "'  ><strong>" + item.BillTerm + " " + "(" + item.Rate + "%" + ")" + " : </strong>");
                    htmls += ("<input type=\"text\" id=\"BTerm_" + item.ID + "_" + item.IsAdd + "\" value=\"Rs. " + (amntAfterDisc * item.Rate / 100).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled  attr-amount='" + (amntAfterDisc * item.Rate / 100).toFixed(2) + "'/>");
                    htmls += ("</td>");
                    htmls += ("</tr>");
                    if (item.IsAdd == 1)
                        netAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                    else
                        netAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
                }
            }
        }
    });
    netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc)).toFixed(2));
    if (datas.VATforBill) {
        if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {
            if (!isab) {
                htmls += ("<tr>");
            }
            else {
                if (!isAbbreviated) {
                    htmls += ("<tr>");
                }
                else {
                    htmls += ("<tr style='display: none;'>");

                }
            }

            //htmls += ("<tr>");
            htmls += ("<td attr-term='Non Taxable Amount' attr-percent='0' ><strong>Non Taxable : </strong><input type=\"text\" id=\"txtNonTaxableAmt\" value=\"Rs. " + (nonTaxableAmount - disNonTax).toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + (nonTaxableAmount - disNonTax).toFixed(2) + "'/></td>");
            htmls += ("</tr>");
            if (!isab) {
                htmls += ("<tr>");
            }
            else {
                if (!isAbbreviated) {
                    htmls += ("<tr>");
                }
                else {
                    htmls += ("<tr style='display: none;'>");

                }
            }

            //htmls += ("<tr>");
            htmls += ("<td attr-term='Taxable Amount' attr-percent='0' ><strong>Taxable Amount : </strong><input type=\"text\" id=\"txtTaxableAmt\" value=\"Rs. " + (totalAmount - disTax).toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + (netAmount - disTax).toFixed(2) + "'/></td>");
            htmls += ("</tr>");
            if (!isab) {
                htmls += ("<tr>");
            }
            else {
                if (!isAbbreviated) {
                    htmls += ("<tr>");
                }
                else {
                    htmls += ("<tr style='display: none;'>");

                }
            }

            var vat = parseFloat((totalAmount - disTax) * 0.13).toFixed(2);
            htmls += ("<td attr-term='VAT' attr-percent='13'><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + datas.billingTerm[datas.billingTerm.length - 1].ID + "_true" + "\"  value=\"Rs. " + vat + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + vat + "'/></td>");
            netAmount = (parseFloat(netAmount) + parseFloat(vat)).toFixed(2);
            htmls += ("</tr>");
        }
    }

    if (!isab) {
        htmls += ("<tr>");
    }
    else {
        if (!isAbbreviated) {
            htmls += ("<tr>");
        }
        else {
            htmls += ("<tr>");

        }
    }

    htmls += ("<td attr-term='Net Amount' attr-percent='0' ><strong>Net Amount : </strong>");
    htmls += ("<input type=\"text\" id=\"txtNetAmt\" value=\"Rs. " + (parseFloat(netAmount)).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled attr-amount='" + netAmount + "'/>");
    htmls += ("</td>");
    htmls += ("</tr>");
    //htmls += ("</table>");


    if (datas.RoomBooking.RoomBookDetailsID > 0) {
        htmls += ("<tr>");
        htmls += ("<td attr-term='Advance Payment' ><strong>Advance Payment : </strong>");
        htmls += ("<input type=\"text\" id=\"txtAdvancePay\" value=\"Rs. " + datas.RoomBooking.AdvancePayment.toFixed(2) + "\" class=\"sfInputbox_bill\" disabled />");
        htmls += ("</td>");
        htmls += ("</tr>");
        htmls += ("<tr>");
        htmls += ("<td attr-term='Remaining Amount' ><strong>Remaining Amount : </strong>");
        htmls += ("<input type=\"text\" id=\"txtRemaining\" value=\"Rs. " + (netAmount - datas.RoomBooking.AdvancePayment).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled />");
        htmls += ("</td>");
        htmls += ("</tr>");
    }
    htmls += ("</table>");
    if (foodCourtOrder) {
        $('#txtTotalCalc').val(parseFloat(netAmount).toFixed(2));
        $('#txtTenderAmount').val(parseFloat(netAmount).toFixed(2));
        $('#txtTotalCalc').change();
    }
    $("#divBillingTerm").html(htmls);
    TotalNetAmount = netAmount;
    BindPaymentModes();
}
function GetCustomeronCheck() {
    var customer = 1;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetCustomerDatas",
        data: JSON2.stringify({ customer: customer }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {

            $("#membeshipformlist").show();
            $("#membeshipformlist").html('');
            var datas = JSON.parse(data.d);
            if (datas.length > 0) {
                var htmls = "<table id='customertable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Name </th><th>PAN</th><th> Address </th><th> ContactNo.</th><th> Discount(%) </th><th>Paid</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"

                $.each(datas, function (index, value) {

                    htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "'>";
                    htmls += "<td>" + value.Name + "</td>";
                    htmls += "<td>" + value.PAN + "</td>";
                    htmls += "<td>" + value.Addresss + "</td>";
                    htmls += "<td>" + value.TelMobile + "</td>";
                    htmls += "<td>" + value.discount + "</td>";
                    htmls += "<td>" + "<img src='/images/completed.png' class='selectCust' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "' value='Delete'  /></td>";
                    htmls += "</tr>"
                    checks.push(value.CardNumber);
                });
                htmls += "</tbody>";
                htmls += "</table>";
                $('#membeshipformlist').html(htmls);
                $('#customertable').DataTable(
                    {
                        "jQueryUI": true,
                    });

                $("#membeshipformlist").dialog({
                    'title': 'Customer',
                    width: 800,
                    modal: true,
                    resizable: true,
                    position: ['center', 'center']
                });
            } else {
                jAlert("No Any Customer to Show !!!");
                $('.customerForOrder').prop('checked', false);

            }
            $(".dataTables_scrollBody").css('height', '100%');

            $("#membeshipformlist").on('click', '#customertable tr', function (event) {
                var deletedata = $(this).attr('id');
                var ids = deletedata.split('_');
                $('#CustomerID').text(ids[1]);
                $('#loyalityDiscount').text(ids[6]);
                $("#txtCustName").val(ids[2] + " " + ids[3]);
                $("#txtContactNo").val(ids[7]);
                $("#txtAddress").val(ids[5]);

                $("#CustomerID").val(ids[1]);
                $("#txtCustName").val(ids[2] + " " + ids[3]);
                $("#txtCusAddress").val(ids[5]);
                $("#txtPanNo").val(ids[4]);

                $("#txtCustName").prop('disabled', true);
                $("#txtCusAddress").prop('disabled', true);
                $("#txtPanNo").prop('disabled', true);

                $("#txtLoyaltyDiscount").val(ids[6]);
                $("#membeshipformlist").dialog('close');
                //$("#selDiscountType").change(); 
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function SaveSalesBill(salesMaster, salesDetail, splited, billingTerm, discount) {
    var customer = 1;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "SaveSalesBill",
        data: JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            //$('#DialogOrderDetail').dialog('close');

            $('#DialogOrderDetail').hide();

            getBill(data.d, false);

            $('#BillingView').dialog({
                'title': 'Vat Bill',
                width: '900',
                height: 'auto',
                modal: true,
                position: ['center', 'top'],
                dialogClass: 'popup-titlebg'
            });
            $('#btnPrints').unbind('click').on('click', function () {
                $('#divPrintedOn').text(formatAMPM());
                savePrintCount((parseInt($('#hdfPrntCnt').val()) + 1), parseInt($('#hdfSMID').val()), SageFrameUserName);
            });

            Print();
            $('#InvoiceType').html('INVOICE');
            $('#btnPrints').click();

        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPayment) {
    var customer = 1;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "SaveFoodCourtSalesPOSBillWithPayment",
        data: JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount, salesPaymentList: salesPayment }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            //$('#DialogOrderDetail').dialog('close');
            $('#DialogOrderDetail').hide();

            getBill(data.d, true);

            $('#BillingView').dialog({
                'title': 'Vat Bill',
                width: '900',
                height: 'auto',
                modal: true,
                position: ['center', 'center'],
                dialogClass: 'popup-titlebg'
            });
            $('#btnPrints').unbind('click').on('click', function () {
                $('#divPrintedOn').text(formatAMPM());
                savePrintCount((parseInt($('#hdfPrntCnt').val()) + 1), parseInt($('#hdfSMID').val()), SageFrameUserName);
            });

            Print();
            $('#InvoiceType').html('INVOICE');
            $('#btnPrints').click();

            $('#txtCustName').val('');
            $('#txtContactNo').val('');
            $('#CustomerID').text(0);
            $('#txtTokenNo').val('');
            $('#txtNoOfPax').val('1');
            $("#txtAddress").val('');
            $('#loyalityDiscount').text(0);

        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function savePrintCount(printcount, billNo, printedBy) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "savePrintCount",
        data: JSON2.stringify({ Printcount: printcount, BillNo: billNo, PrintedBy: printedBy }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            //$('#printno').show();
            Print();
            $('#BillingView').dialog('close');
            jAlert("Bill successfully Generated", "Information!!", function () {
                var url = SageFrameHostURL + "/POS.aspx";
                window.location.href = url;
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function Print() {
    var contents = $('#customer-bill').html();
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    frameDoc.document.write('<html><head><title></title>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body>');
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
}
function CancelOrderedData() {

    var id = OrderMasterID;
    var cancel = false;
    var ordermaster = new Object();
    ordermaster.TableId = TableId,
        ordermaster.RoomId = RoomId,
        ordermaster.OID = parseInt(OID);
    ordermaster.OrderMasterID = OrderMasterID,
        ordermaster.GuestNo = parseInt($('#splitNoCancel').text() == '' ? '1' : $('#splitNoCancel').text());
    ordermaster.CancelReason = $("#canceltextarea").val();
    ordermaster.CancelBy = $('#hdnPinBy').val();
    ordermaster.UserName = $('#hdnPinBy').val();
    ordermaster.IsCancelled = true,
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: baseUrl + "CancelOrderIntoDataBase",
            data: JSON2.stringify({ orderMasterInfo: ordermaster }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                jAlert('Ordered Cancelled successfully', 'Information!!', function () {
                    parent.$.colorbox.close();
                });
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
}

//Avata Change
//function initialSetup(tableId, oId, hostUrl, foodCourt, Delievery, yoga = false, spa = false) {
function initialSetup(tableId, oId, hostUrl, foodCourt, Delievery) {
    //document.onkeydown = BillShortcutKey;
    $('#hdnPinMatch').on('change', function () {
        if ($('#hdnPinMatch').val() == "true") {
            debugger;
            var pinFor = $('#hdnPinFor').val();
            if (pinFor == 'generateBill') {
                $('.paynows').click();
            } else if (pinFor == 'enablebtn') {
                var pin = $("#PINbox").val();
                CheckRolesFromPin(pin);
                if (IsEnableDiscount) {
                    $("#selDiscountType").prop('disabled', false);
                    $(".txtdiscount").prop('disabled', false);
                    $("#enablebtn").hide();
                }
                else {
                    jAlert('Discount is not Allowed', "Information!!", function () {
                    });
                }

            } else if (pinFor == 'SendOrder') {
                if (($("#orderlist-table tbody tr").length) > 0) {
                    bindForCancel(PreviousOrdersList);
                }
                else {
                    jAlert('No Item Selected', 'Alert!!');
                }
            } else if (pinFor == 'CancelOrder') {
                $('#btnSumbit').bind('click');
                $('#DisplayCancel').dialog();
            }
        }
    });
    PinCodeSetup();
    NumCodeSetup();
    InitEvents();
    TableId = parseInt(oId) > 0 ? TableId : tableId;
    OID = oId;
    HostUrl = hostUrl;
    foodCourtOrder = foodCourt;
    OrderDelivery = Delievery;

    $("#txtSearch").focus();

    if (!isNaN(tableId) && tableId > 0) {
        $('#tableData').show();
    } else {
        $('#tableData').show();
        $('.tabledet td').hide();
        $('.tabledet .tbldet').show();
    }



    $(".bindorderlist").on('click', '.qtyplus', function (e) {

        e.preventDefault();
        if (e.handled !== true) { //Checking for the event whether it has occurred or not.
            e.handled = true; // Basically setting value that the current event has occurred.
            var fieldName = $(this).attr('field');
            var index = $(this).attr('id');
            var splitindex = index.split('_');
            var currentVal = parseInt($('#' + fieldName).val());
            var IsCombo = fieldName.split('_')[2] == 'true' ? true : false;
            var trId = $(this).closest('tr').attr('id');
            if (trId.split('_')[3] == 'true') {
                var prevQuantity = 0;
                $.each(PreviousOrdersList, function (i, item) {
                    if (item.ItemID == fieldName.split('_')[1] && item.IsCombo == IsCombo && item.SeatNo == selectedBillNo) {
                        prevQuantity = item.Quantity;
                        return false;
                    }
                })
                if (currentVal >= prevQuantity) {
                    jAlert('Item Out Of Stock!!', 'Information!!');
                    return false;
                }
            }

            if (!isNaN(currentVal)) {
                $('#' + fieldName).val(currentVal + 1);
            } else {
                $('#' + fieldName).val(0);
            }
            var last = $('#' + fieldName).val();

            OrderListArray[parseInt(splitindex[1])].Quantity = last;
            OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(selectedBillNo);
            OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
            CalculateTotal();
        }
    });
    $(".bindorderlist").on('keyup', '.qty', function () {
        var fieldName = $(this).attr('field');
        var index = $(this).attr('index');
        var splitindex = index.split('_')
        var currentVal = parseFloat($('#' + fieldName).val());
        var last = $('#' + fieldName).val();

        var IsCombo = fieldName.split('_')[2] == 'true' ? true : false;
        var trId = $(this).closest('tr').attr('id');
        if (trId.split('_')[3] == 'true') {
            var prevQuantity = 0;
            $.each(PreviousOrdersList, function (i, item) {
                if (item.ItemID == fieldName.split('_')[1] && item.IsCombo == IsCombo && item.SeatNo == selectedBillNo) {
                    prevQuantity = item.Quantity;
                    return false;
                }
            })
            if (currentVal >= prevQuantity) {
                jAlert('Item Out Of Stock!!', 'Information!!');
                last = prevQuantity;
                $('#' + fieldName).val(prevQuantity);
                //return false;
            }
        }

        OrderListArray[parseFloat(splitindex[0])].Quantity = last;

        OrderListArray[parseInt(splitindex[0])].SeatNo = parseInt(selectedBillNo);
        OrderListArray[parseInt(splitindex[0])].GuestNo = parseInt(splitindex[1]);

        CalculateTotal();
    });
    $(".bindorderlist").on('click', '.qtyminus', function (e) {
        e.preventDefault();
        if (e.handled !== true) { //Checking for the event whether it has occurred or not.
            e.handled = true; // Basically setting value that the current event has occurred.
            fieldName = $(this).attr('field');
            var index = $(this).attr('id');
            var fieldsplit = fieldName.split('_');
            var splitindex = index.split('_')
            var currentVal = parseInt($('#' + fieldName).val());
            if (!isNaN(currentVal) && currentVal > 0) {
                $('#' + fieldName).val(currentVal - 1);
            } else {
                $('#' + fieldName).val(0);
            }
            if (currentVal == 1) {
                var itemrow = fieldName.split('_');
                var row = itemrow[1];
                $("#tr_" + row + "_" + itemrow[2]).remove();
                $.each(OrderListArray, function (i) {
                    if (OrderListArray[i].ItemId == parseInt(row) && OrderListArray[i].IsCombo.toString() == itemrow[2]) {
                        OrderListArray.splice(i, 1);
                        return false;
                    }
                });

                BindItemsToList();
            }
            else {
                var last = $('#' + fieldName).val();
                OrderListArray[parseInt(splitindex[1])].Quantity = last;
                OrderListArray[parseInt(splitindex[1])].SeatNo = parseInt(selectedBillNo);
                OrderListArray[parseInt(splitindex[1])].GuestNo = parseInt(splitindex[2]);
            }
            CalculateTotal();
            return;
        }
    });

    $(".sfCol_13").hide();

    $('#SendOrder').on('click', function () {
        $('#hdnPinFor').val('SendOrder');
        InitializePin();
        $('#PINbox').focus()
    });

    $('#CancelOrder').on('click', function () {
        if (OrderMasterID == 0) {
            jConfirm('Are You Sure  ?', 'Cancel', function (confirmed) {
                if (confirmed) {
                    parent.$.colorbox.close();
                }
            });
        } else {
            $('#splitNoCancel').text($('#billno').val());
            $('#hdnPinFor').val('CancelOrder');
            InitializePin();
        }
    });

    $('#btnSumbit').unbind('click').on('click', function () {
        var myStr = $("#canceltextarea").val();
        var newStr = myStr.replace(/  +/g, ' ');
        if (newStr.length <= 4) {
            // if ($("#canceltextarea").val() == null || $("#canceltextarea").val() == "" || $("#canceltextarea").val() == " ") {
            jAlert('Please Insert Cancel Reason more than 4 words.', "Alert!!", function () { $.alerts.dialogClass = null; });
        } else {
            CancelOrderedData();
        }


    });

    $('#billno').change(function () {
        selectedBillNo = parseInt($('#billno').val());
        BindItemsToList();
        if (completedOrders.length > 0) {
            var phtm = "";
            $("#bindCompOrders").html(phtm);
            $.each(completedOrders, function (index, item) {
                if (item.SeatNo == $("#billno").val()) {
                    phtm += "<tr><td>" + (index + 1) + "</td>";
                    phtm += "<td>" + item.ItemName + "</td>";
                    phtm += "<td>" + item.Quantity + "</td>";
                }
            });
            $("#bindCompOrders").html(phtm);
        }
        if (inprogressOrders.length > 0) {
            var phtm = "";
            $("#bindInPrgOrders").html(phtm);
            $.each(inprogressOrders, function (index, item) {
                if (item.SeatNo == $("#billno").val()) {
                    phtm += "<tr><td>" + (index + 1) + "</td>";
                    phtm += "<td>" + item.ItemName + "</td>";
                    phtm += "<td>" + item.Quantity + "</td>";
                }
            });
            $("#bindInPrgOrders").html(phtm);
        }
    });

    $('#orderlist-table').on('click', '.extra', function () {
        var index = $(this).attr('id');
        var splitindex = index.split('_');
        var itemsextra;
        var itemID = splitindex[3];

        $('.extradiv').html('');
        var htmls = '';

        htmls += '<form>';
        htmls += '<fieldset>';
        htmls += '<label for="name">Note:</label>';
        htmls += '<textarea class="ddlSpicy sfInputbox" style="width:100%;">';
        htmls += '</textarea><br>'

        htmls += "<table><thead><tr><th>Extra</th><th>Extra Item</th><th width='15px'>Quantity</th></tr><tbody>";
        $.each(ExtraItemsByItem, function (index, value) {
            if (value.ItemID == itemID) {
                var ordered = false;
                var qnty = 0;
                $.each(ExtraItems, function (index, data) {
                    if (data.ItemID == value.ItemID && data.SeatNo == selectedBillNo && data.ExtraItemID == value.ExtraItemID) {
                        ordered = true;
                        qnty = data.Quantity;
                    }
                });

                htmls += "<tr><td><input type='checkbox' class='ckbxExtraItem' id='" + value.ExtraItemID + "_" + value.ExtraItem + "_" + value.ExtraPrice + "' " + (ordered ? 'Checked' : '') + "> </td>";
                htmls += "<td><label for='" + value.ExtraItemID + "_" + value.ExtraItem + "_" + value.ExtraPrice + "'>" + value.ExtraItem + "(Rs. " + value.ExtraPrice + ")</label></td>";
                htmls += "<td><input type='text' id='Qnty_" + value.ExtraItemID + "' onkeypress='return isNumber(event)' style='width:80%;' value='" + (ordered ? qnty : '0') + "' class='ExtraQuantity qty' /></td></tr>";
            }
        });
        htmls += "</tbody></table>";


        htmls += '<label for="name"style="display:none;">Home Delivery</label>';
        htmls += '<input type="checkbox" id="chkbox_' + parseInt(splitindex[3]) + '" class="ChkboxHomedelivery"style="display:none;" value="Home Delivery" />';
        htmls += '<select id="selectboxHomeDeliveryQuantity_' + parseInt(splitindex[3]) + '" class="sele"></select>';
        htmls += '</fieldset>';
        htmls += '</form>';
        $('.extradiv').html(htmls);

        $('.ckbxExtraItem').on('change', function () {
            if ($(this).is(':checked')) {
                $('#Qnty_' + $(this).attr('id').split('_')[0]).val(1);
                $('#Qnty_' + $(this).attr('id').split('_')[0]).change();
            } else {
                $('#Qnty_' + $(this).attr('id').split('_')[0]).val(0);
                $('#Qnty_' + $(this).attr('id').split('_')[0]).change();
            }
        });

        //$('.ExtraQuantity').on('change', function () {
        //    itemQnty = parseInt($('#qty_' + itemID + '_false').val());
        //    qnty = 0;
        //    $('.ExtraQuantity').each(function () {
        //        qnty += parseInt($(this).val());
        //        if (qnty > itemQnty) {
        //            qnty -= parseInt($(this).val());
        //            $(this).val(0);
        //            jAlert('Extra Item Qunatity Cannot be greater than Item Quantity', 'Alert!!', function () { $.alerts.dialogClass = null; });
        //        }
        //    })
        //});

        $('.ddlSpicy').val(OrderListArray[parseInt(splitindex[1])].Note);
        $('.HomeDelivs').val(OrderListArray[parseInt(splitindex[1])].ExtraCharge);
        $(".sele").css("display", "none");

        $('.extradiv').dialog(
            {
                'title': splitindex[4],
                "resize": "auto",
                width: 300,
                buttons: {
                    "Submit": function () {
                        var arrlength = ExtraItems.length;
                        for (var i = arrlength - 1; i >= 0; i--) {
                            if (itemID == ExtraItems[i].ItemID && selectedBillNo == ExtraItems[i].SeatNo) {
                                ExtraItems.splice(i, 1);
                            }
                        }

                        $('.ckbxExtraItem').each(function (i, obj) {
                            if ($(this).is(':checked')) {
                                //$('.ddlSpicy').val($('.ddlSpicy').val() + ', ' + $(this).attr('id').split('_')[1]);
                                var word = $(this).attr('id').split("_");
                                var extra = new Object;
                                extra.ItemID = parseInt(itemID);
                                extra.ExtraItemID = parseInt(word[0]);
                                extra.ExtraItem = word[1];
                                extra.ExtraPrice = parseFloat(word[2]);
                                extra.Quantity = parseInt($('#Qnty_' + parseInt(word[0])).val());
                                extra.SeatNo = parseInt(selectedBillNo);
                                ExtraItems.push(extra);
                            }

                        });
                        if ($('.ChkboxHomedelivery').is(':checked')) {
                            OrderListArray[parseInt(splitindex[1])].IsHomeDelivery = true;
                            OrderListArray[parseInt(splitindex[1])].HomeDeliveyNumber = $('.sele').val();
                        } else {
                            OrderListArray[parseInt(splitindex[1])].IsHomeDelivery = false;
                            OrderListArray[parseInt(splitindex[1])].HomeDeliveyNumber = 0;
                        }
                        OrderListArray[parseInt(splitindex[1])].Note = $('.ddlSpicy').val();
                        OrderListArray[parseInt(splitindex[1])].ExtraItem = "";
                        //OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('.HomeDelivs').val());
                        OrderListArray[parseInt(splitindex[1])].ExtraCharge = parseFloat($('.HomeDelivs').val());

                        CalculateTotal();
                        $(this).dialog('close');
                    },
                    Cancel: function () {
                        $('.ddlSpicy').val('');
                        $('.HomeDelivs').val('');
                        $(this).dialog('close');
                    }
                }
            });

        $('.ChkboxHomedelivery').on('click', function () {
            var index = $(this).attr('id');
            var splitindex = index.split('_');

            if ($(this).is(':checked')) {

                $("#" + "selectboxHomeDeliveryQuantity_" + parseInt(splitindex[1])).html('');
                var newhtml = '';
                var quantitynumber = parseInt($("#" + "qty_" + parseInt(splitindex[1])).val());
                for (var i = 1; i <= quantitynumber; i++) {
                    newhtml += "<option value=" + i + ">" + i + "</option>";
                }
                $("#" + "selectboxHomeDeliveryQuantity_" + parseInt(splitindex[1])).html(newhtml);
                $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).toggle();
                $(".sele").css("display", "block");

            } else {
                $("#" + "selectboxHomeDeliveryQuantity_" + splitindex[1]).toggle();
            }
        });
    });

    $('#NoOfBill').on('click', function () {
        var newhtml = '';
        newhtml += "<option value=" + (noOfGuest + 1) + ">" + (noOfGuest + 1) + "</option>";
        noOfGuest = (noOfGuest + 1);
        $('#billno').append(newhtml);

        jAlert("New Split Added. Split No : " + noOfGuest, "Information!!", function () {
            $('#billno').val(noOfGuest);
            $('#billno').change();
        });
    });




    $("#txtSearch").autocomplete({
        source: AutocompleteItem,
        delay: 0,
        select: function (event, ui) {

            $.scrollTo(200);
            var name = ui.item.value;
            var languageid = $("#selLanguage").val() == null ? 1 : $("#selLanguage").val();
            $.ajax({
                type: "POST",
                async: false,
                cache: false,
                url: baseUrl + "txtSearchForItem",
                data: JSON2.stringify({ ItemName: name, languageid: languageid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var result = JSON.parse(data.d);
                    BindCategoriesByMenu(result, name);

                    $.each(result, function (index, value) {
                        var NpitemID = value.ItemId;
                        var NpitemName = value.ItemName;
                        var IsCombo = false;
                        var IsCat = value.IsCategory;
                        var Nprate = value.SRate;
                        var currentVal = $('#qty_' + value.ItemId + '_' + IsCombo).val();
                        if (currentVal == undefined) {
                            currentVal = 0;
                        }
                        var prevQuantity = 0;
                        $.each(PreviousOrdersList, function (i, item) {
                            if (item.ItemID == NpitemID && item.IsCombo == IsCombo && item.SeatNo == selectedBillNo) {
                                prevQuantity = item.Quantity;
                                return false;
                            }
                        })

                        //Out Of Stock Item
                        if (currentVal >= prevQuantity && value.IsOutOfStock) {
                            jAlert('Item Out Of Stock!!', 'Information!!');
                        } else {
                            if (IsCat) {
                                var subItem = false;
                                var categoryName = value.ItemName;
                                GetItemByCategoryID(parseInt(value.ItemId), subItem, categoryName);
                                if (orderlistviewtype) {
                                    $('#Menushow').hide();
                                    $('#Categoryshow , #Itemshow, #Itemshow2').show();
                                }
                                $('html, body').animate({
                                    scrollTop: $("#Itemshow").offset().top - 100
                                }, 200);
                            }
                            else {
                                if (orderlistviewtype) {
                                    $('#Menushow').hide();
                                }
                                $('#Categoryshow').show();
                                if (AddItemInMenuSearch != false) {
                                    BindItemsToOrder(NpitemID, NpitemName, IsCombo, value.IsOutOfStock, Nprate);

                                }

                            }
                        }
                    });



                },
                failure: function (response) {
                    jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                }
            });


            $(".categoryimg").first().trigger('click');
            //var st = cls.split(' ');
            //var firstClass = st[0];
            //firstClass.trigger('click');
            $(this).val(''); return false;
        },
        change: function (event) {
            $("#txtSearch").val('');
            $("#txtSearch").focus();
        },
    });

    $("#btnSearch").click(function () {
        $("#txtSearch").val("");
        $("#Menushow").show();
        GetMenuforOrder();
        $("#btnSearch").hide();
    });
    if (orderlistviewtype) {
        $('#Itemshow2').on('click', '.orderbackB', function () {
            $('#Itemshow2').hide();
            $('#Itemshow').show();
        });
    }

    $('#Itemshow,#Itemshow2 ').on('click', '.itemimg', function () {
        if (orderlistviewtype) {
            $('#Itemshow2').show();
        }
        var data = $(this).attr('id');
        var values = data.split('_');
        var IsCombo = $(this).attr('attr-type') == 'c' ? true : false;
        var IsOutOfStock = values[5];
        var Nprate = values[6];
        var currentVal = $('#qty_' + values[1] + '_' + IsCombo).val();
        if (currentVal == undefined) {
            currentVal = 0;
        }
        var prevQuantity = 0;
        $.each(PreviousOrdersList, function (i, item) {
            if (item.ItemID == values[1] && item.IsCombo == IsCombo && item.SeatNo == selectedBillNo) {
                prevQuantity = item.Quantity;
                return false;
            }
        })
        if (currentVal >= prevQuantity && values[5] == 'true') {
            jAlert('Item Out Of Stock!!', 'Information!!');
        } else {
            if (values[4] == "true") {
                var subItem = true;
                var categoryName = values[2];
                GetItemByCategoryID(parseInt(values[1]), subItem, categoryName);
                if (orderlistviewtype) {
                    $('#Itemshow').hide();
                }
            } else {
                var subItem = false;
                BindItemsToOrder(values[1], values[2], IsCombo, IsOutOfStock, Nprate);

            }
        }
    });
    if (orderlistviewtype) {
        $('#Itemshow').on('click', '.itemimg', function () {

            $('#Itemshow2').show();
        });
    }


    var winheight = 0.85 * window.outerHeight;
    parent.$.colorbox.resize({
        height: winheight + 'px'
    });
}
function GetPreviousItemByID(Id, OID) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetPreviousItemByID",
        data: JSON2.stringify({ Id: parseInt(Id), OID: parseInt(OID) }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            completedOrders = data.d.CompOrders;
            inprogressOrders = data.d.InPrgOrders;
            var allOrders = data.d.AllOrders;
            var datas = data.d.OrderedOrders;
            PreviousOrdersList = data.d.OrderedOrders;
            var htmls = "";
            var i = 1;

            $('#OLroomname').text((allOrders[0].room == null ? "" : allOrders[0].room));
            $('#OLTablename').text((allOrders[0].restrotableTitle == null ? "" : allOrders[0].restrotableTitle));
            RoomId = allOrders[0].RoomId;
            TableId = allOrders[0].TableId;
            OrderMasterID = allOrders[0].OrderMasterId;
            noOfGuest = (allOrders[0].GuestNo == 0 ? 1 : allOrders[0].GuestNo);
            $('#txtCustName').val((allOrders[0].CustomerName == null ? "" : allOrders[0].CustomerName));
            $('#txtContactNo').val((allOrders[0].Phone == null ? "" : allOrders[0].Phone));
            $('#CustomerID').text((allOrders[0].CustomerID == null ? 0 : allOrders[0].CustomerID));
            $('#txtTokenNo').val((allOrders[0].TokenNo == -1 ? "" : allOrders[0].TokenNo));
            $("#txtAddress").val(allOrders[0].Address == null ? "" : allOrders[0].Address);
            $("#txtNoOfPax").val(allOrders[0].GuestNo == null ? "" : allOrders[0].GuestNo);



            if (allOrders[0].CustomerID > 0) {
                $('.customerForOrder').prop('checked', true);
            }

            i = 1;
            if (datas.length > 0) {
                var itmlst = new Array();
                $.each(datas, function (index, item) {

                    if (item.ItemID != 0) {
                        if (item.BillPaid != 1) {
                            if (item.SeatNo > noOfGuest) {
                                noOfGuest = item.SeatNo;
                            }
                            var order = new Object();
                            order.ItemId = item.ItemID
                            order.ItemName = item.ItemName;
                            order.Quantity = item.Quantity;
                            order.Note = item.Note;
                            order.ExtraCharge = parseFloat(item.ExtraCharge);
                            order.IsHomeDelivery = item.IsHomeDelivery;
                            order.HomeDeliveyNumber = item.HomeDeliveyNumber;
                            order.SeatNo = item.SeatNo;
                            order.GuestNo = item.GuestNo;
                            order.IsSplit = item.IsSplit;
                            order.RoomId = item.RoomId;
                            order.TableID = item.TableId;
                            order.Remarks = item.Remarks;
                            order.IsCancelled = item.IsCancelled;
                            order.Status = item.ItemStatus;
                            order.IsCombo = item.IsCombo;
                            order.OrderDetailsID = item.OrderDetailsID;
                            order.IsOutOfStock = item.IsOutOfStock;
                            order.Rate = item.SRate;
                            OrderListArray.push(order);
                            itmlst.push(order.ItemId);
                            if ($('#billno').val() != 0) {
                                selectedBillNo = $('#billno').val();
                            }
                            else {
                                selectedBillNo = 1;
                            }
                            Note = "";
                            ExtraCharge = 0.0;
                            IsCanceled = 0;
                            status = "";
                            var roles = userRole.split(',');
                            $(".bindorderlist").html('');
                            if (item.SeatNo == $("#billno").val()) {
                                htmls += "<tr attr-type='i' catr='c' id='tr_" + item.ItemID + "_" + item.IsCombo + "_" + item.IsOutOfStock + "'>";
                                htmls += "<td>" + i + "</td>";
                                htmls += "<td>" + item.ItemName + "</td>";
                                htmls += "<td><input type='button' value='-' id='minus_" + index + "_" + selectedBillNo + "' class='qtyminus' field='qty_" + item.ItemID + "_" + item.IsCombo + "' />";

                                htmls += "<input type='text' onkeypress='return validateFloatKeyPress(this,event)' id='qty_" + item.ItemID + "_" + item.IsCombo + "' value='" + item.Quantity + "' class='qty' index='" + index + "_" + selectedBillNo + "' width='20px' field='qty_" + item.ItemID + "_" + item.IsCombo + "'/>";
                                htmls += "<input type='button' value='+' id='plus_" + index + "_" + selectedBillNo + "' class='qtyplus' field='qty_" + item.ItemID + "_" + item.IsCombo + "' /></td>";
                                htmls += "<td class='rate'>" + item.SRate + "</td>";
                                htmls += "<td class='total' style='display:none;'></td>";
                                htmls += "<td><img id='extra_" + index + "_" + selectedBillNo + "_" + item.ItemID + "_" + item.ItemName + "' src='/images/extra.png' class='extra' width='30px' height='30px' /></td>";
                                htmls += "</tr>";
                                i = i + 1;
                            }
                        }
                    }
                });

            }
            else {
                htmls += "<td colspan='4' style='font-size:13px;'>Please click the Left Side menus list to Order Items.</td>";
            }
            if (noOfGuest > 1) {

                var htmlss = "";
                for (i = 2; i <= noOfGuest; i++) {
                    htmlss += (" <option value='" + i + "'>" + i + "</option> ");
                }
                $("#billno").append(htmlss);
            }
            $(".bindorderlist").html(htmls);

            if (completedOrders.length > 0) {
                var phtm = "";
                $("#bindCompOrders").html(phtm);
                i = 0;
                $.each(completedOrders, function (index, item) {
                    if (item.SeatNo == $("#billno").val()) {
                        phtm += "<tr><td>" + (i + 1) + "</td>";
                        phtm += "<td>" + item.ItemName + "</td>";
                        phtm += "<td>" + item.Quantity + "</td>";
                        i++;
                    }
                });
                $("#bindCompOrders").html(phtm);
            }
            if (inprogressOrders.length > 0) {
                var phtm = "";
                $("#bindInPrgOrders").html(phtm);
                i = 0;
                $.each(inprogressOrders, function (index, item) {
                    if (item.SeatNo == $("#billno").val()) {
                        phtm += "<tr><td>" + (i + 1) + "</td>";
                        phtm += "<td>" + item.ItemName + "</td>";
                        phtm += "<td>" + item.Quantity + "</td>";
                        i++;
                    }
                });
                $("#bindInPrgOrders").html(phtm);
            }


            if (data.d.orderedExtraItems != null && data.d.orderedExtraItems.length > 0) {
                $.each(data.d.orderedExtraItems, function (index, value) {
                    var extItm = new Object();
                    extItm.ItemID = value.ItemID;
                    extItm.ExtraItemID = value.ExtraItemID;
                    extItm.ExtraPrice = value.ExtraPrice;
                    extItm.ExtraItem = value.ExtraItem;
                    extItm.Quantity = value.Quantity;
                    extItm.SeatNo = value.SeatNo;

                    ExtraItems.push(extItm);
                });
            }
            CalculateTotal();
            if (TableId <= 0 && OrderMasterID > 0) {
                ShowOrderPayView();
            }
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function ShowOrderPayView() {
    GetDataForSalesBill(OrderMasterID);
}


function getProviderList() {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetProviderList",
        data: '',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = JSON.parse(data.d);
            var htmls = "";
            $('#selProv').html(htmls);
            $.each(result, function (index, value) {
                htmls += '<option value="' + value.ProviderID + '">' + value.ProviderName + '</option>';
            });
            $('#selProv').html(htmls);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function Reset() {
    PreviousOrdersList = [];
    completedOrders = [];
    inprogressOrders = [];
    OrderListArray = [];
    ExtraItems = [];
    selectedBillNo = 1;
    pinMatch = "";
    //pinfor = "";
    noOfGuest = 1;
    iscancelling = false;
    OrderMasterID = 0;
    OID = 0;
    TableId = 0;
    RoomId = 0;
}
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&
        (charCode < 48 || charCode > 57)) {
        return false;
    }
    if ($(element).val().indexOf('.') != -1 && $(element).val().split('.')[1].length >= 2) {
        return false;
    }

    return true;
}
function BillShortcutKey(e) {
    var evtobj = window.event ? event : e
    if (evtobj.keyCode == 66 && evtobj.altKey && evtobj.ctrlKey && isButtonClicked) {
        isButtonClicked = false;
        //alert('pressed Ctrl+Alt+b');
        var billingTerm = new Array();
        var salesMaster = new Object();
        var splited = 0;
        var salesDetail = new Array();

        salesMaster.billNo = '1234';
        salesMaster.BillDate = new Intl.DateTimeFormat('en-US').format(new Date());
        salesMaster.NepaliInvoiceDate = formatDate();
        salesMaster.BasicAmount = (parseFloat($('.totalAfterDisc').val().split(' ')[1]));
        salesMaster.RoomId = 0;
        salesMaster.TableId = parseInt(0);
        salesMaster.OrderMasterId = orderdetails[0].OrderMasterId;
        salesMaster.totaldiscount = totaldis;
        salesMaster.TermAmount = 0.00;
        salesMaster.NetAmount = $('#txtNetAmt').val().split(' ')[1];
        salesMaster.CusName = $('#txtCustName').val();
        salesMaster.Address = $('#txtCusAddress').val();
        salesMaster.PAN = $('#txtPanNo').val();
        salesMaster.ChequeNo = "";
        salesMaster.TransactionNo = "";
        salesMaster.CusID = ($('#CustomerID').val() == "" ? 0 : parseInt($('#CustomerID').val()));
        salesMaster.sumKot = kotAmount;
        salesMaster.sumBev = barAmount;
        salesMaster.Waiter = orderdetails[0].Waiter;
        salesMaster.SPMID = 0;
        salesMaster.IsSplit = 0;
        salesMaster.SeatNo = 1;
        salesMaster.AddedBy = $('#hdnPinBy').val();;
        salesMaster.RoomRate = 0;
        salesMaster.BookedDays = 0;
        salesMaster.RoomCharge = 0;
        salesMaster.AdvancePayment = 0;
        salesMaster.sumBakery = bakeryAmount;
        salesMaster.sumPizza = pizzaAmount;
        salesMaster.DeliveryCharge = 0;
        salesMaster.DeliveredBy = "";

        $.each(billingterms, function (index, value) {
            if (document.getElementById('BTerm_' + value.ID + '_' + value.IsAdd) != null) {
                var bt = {
                    ID: value.ID,
                    Rate: value.Rate,
                    IsAdd: value.IsAdd,
                    Amount: $('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]
                }
                salesMaster.TermAmount += parseFloat($('#BTerm_' + value.ID + '_' + value.IsAdd).val().split(' ')[1]);
                billingTerm.push(bt);
            }
        });
        var bt = {
            ID: 1,
            Rate: 0,
            IsAdd: false,
            Amount: $('#txtNetAmt').val().split(' ')[1]
        }
        billingTerm.push(bt);

        $.each(orderdetails, function (index, value) {
            var extra = [];
            if (value.orderExtraItem != undefined && value.orderExtraItem.length > 0) {
                $.each(value.orderExtraItem, function (index, item) {
                    var ext = {
                        ItemID: value.ROI_ItemId,
                        ExtraItemID: item.ExtraItemID,
                        ExtraItem: item.ExtraItem,
                        Quantity: item.Quantity,
                        Rate: ($('#selDiscountType').val() == "4" ? 1 : item.ExtraPrice),
                        Amount: ($('#selDiscountType').val() == "4" ? (item.Quantity * 1) : (item.Quantity * item.ExtraPrice))
                    }
                    extra.push(ext);
                });
            };
            var sd = {
                ItemId: value.ROI_ItemId,
                qty: value.Quantity,
                rate: ($('#selDiscountType').val() == "4" ? 1 : value.Rate),
                Amount: ($('#selDiscountType').val() == "4" ? (value.Quantity * 1) : value.Amount),
                NetAmount: value.Amount,
                OrderDetailsID: value.OrderDetailsID,
                CostCenterId: value.CostCenterId,
                IsCombo: value.IsCombo,
                extraSales: extra
            }
            salesDetail.push(sd);
        });

        var discount = new Object();
        discount.orderMasterId = orderdetails[0].OrderMasterId;
        discount.kotdis = $('#txtKotDiscount').val();
        discount.bardis = $('#txtBarDiscount').val();
        discount.roomdis = 0;
        discount.isflatdis = ($('#selDiscountType').val() == "2" ? true : false);
        discount.isLoyalty = ($('#selDiscountType').val() == "3" ? true : false);
        discount.loyaltydis = $('#txtLoyaltyDiscount').val();
        discount.bakerydis = $('#txtBakeryDiscount').val();
        discount.pizzadis = $('#txtPizzaDiscount').val();


        var salesPayment = {};
        if (foodCourtOrder) {
            salesPayment.SPMID = $('#selPayMode').val();
            salesPayment.ChequeNo = ($('#selPayMode').val() == 2 ? $('#txtCheqNo').val() : "");
            salesPayment.TransactionNo = ($('#selPayMode').val() == 3 ? $('#txtTransNo').val() : "");
            salesPayment.ProviderID = (($('#selPayMode').val() == 3 || $('#selPayMode').val() == 2) ? $('#selProv').val() : "");
            salesPayment.TenderAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtTenderAmount').val() == "" ? 0 : $('#txtTenderAmount').val())) : 0);
            salesPayment.ReturnAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtReturnAmount').val() == "" ? 0 : $('#txtReturnAmount').val())) : 0);
            salesPayment.PayAmount = ($('#selPayMode').val() == 1 ? parseFloat($('#txtTenderAmount').val() - $('#txtReturnAmount').val()) : $('#txtNetAmt').val().split(' ')[1]);

            salesPayment.CusID = '';
            salesPayment.Customer = '';
            salesPayment.Address = '';
            salesPayment.PAN = '';
            var data = JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount, payment: salesPayment, isFoodCourt: foodCourtOrder });
            saveSales(data);

        } else {
            var data = JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount, payment: salesPayment, isFoodCourt: foodCourtOrder });
            saveSales(data);
        }
        //alert(JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount }));
    }
}
function saveSales(data, isFoodCourt) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Services/RestroWebservice.asmx/SaveSales",
        data: data,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $('#DialogOrderDetail').dialog('close');
            getBill(data.d, false);
            $('#BillingView').dialog({
                'title': 'Vat Bill',
                width: '350',
                height: 'auto',
                modal: true,
                position: ['center', 'top']
            });
            Print();
            //$('#printno').show();
            $('#InvoiceType').html('INVOICE');
            Print();
            $('#BillingView').dialog('close');
            jAlert("Bill successfully Generated", "Information!!", function () {
                if (foodCourtOrder) {
                    $('.bindorderlist').html('');
                    Reset();
                } else {
                    parent.$.colorbox.close();
                }
            });
            //$('#btnPrints').click();
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });


}
function getMemberDetailsbyinfo(info) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "getMemberDetailsbyinfo",
        data: JSON2.stringify({ info: info }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var datas = JSON.parse(data.d);
            $("#CustomerID").val(datas[0].MembershipID);
            $("#txtCustName").val(datas[0].Name);
            $("#txtCusAddress").val(datas[0].Address);
            $("#txtPanNo").val(datas[0].PAN);
            $("#txtNumber").val(datas[0].TelMobile);
            $("#txtCardNumber").val(datas[0].CardNumber);

            $("#txtCustName").prop('disabled', true);
            $("#txtCusAddress").prop('disabled', true);

            $("#txtLoyaltyDiscount").val(datas[0].discount);
            //var roles = userRole.split(',');

            //if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
            //    $("#selDiscountType").val(3);
            //    $("#selDiscountType").change();
            //}
            //else {
            //}
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function CheckRolesFromPin(pin) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RestroDashboard/services/DashboardWebService.asmx/CheckPin",
        data: JSON.stringify({ pin: pin }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var result = data.d;
            var roles = result.Roles.split(',');

            if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                IsEnableDiscount = true;
            }

            else {
                IsEnableDiscount = false;
            }
            userRole = data.d.Roles;
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function GetUserName(username) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: SageFrameHostURL + "/Modules/RestroDashboard/services/DashboardWebService.asmx/GetRolesByUsername",
        data: JSON.stringify({ username: username }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var role = data.d;
            userRole = role.Roles;
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function CalculateTotal() {
    var amount = 0;
    var extraRate = 0;
    $.each(ExtraItems, function (index, value) {
        extraRate += parseFloat(value.Quantity) * parseFloat(value.ExtraPrice);
    });
    $("#orderlist-table>.bindorderlist>tr").each(function (index, value) {
        var qty = $(value).find(".qty").val();
        var rate = $(value).find(".rate").text();
        var result = parseFloat(qty) * parseFloat(rate);
        $(value).find('.total').text(result.toFixed(1));
    });
    var MyRows = $('#orderlist-table').find('.bindorderlist').find('tr');
    for (var i = 0; i < MyRows.length; i++) {
        amount += parseFloat($(MyRows[i]).find('.total').text());
    }
    var total = amount + extraRate;
    $('.totalamount').text('Total Amount: Rs. ' + total);

}

