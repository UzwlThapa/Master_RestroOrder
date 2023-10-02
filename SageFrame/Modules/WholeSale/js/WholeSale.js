var baseUrl = SageFrameHostURL + "/Modules/WholeSale/services/WholeSaleWebService.asmx/";
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
var OID = 0;
var TableId = 0;
var RoomId = 0;
var HostUrl = '';
var foodCourtOrder = false;
var wholesaleorder = true;
var OrderDelivery = false;
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
var discountAmount = 0.00;
var netAmount = 0.00;
var taxableAmount = 0.00;

//debugger;
//var urlParams = new URLSearchParams(window.location.search);
//var sectionName = urlParams.get('id'); }
//console.log(sectionName);


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
            $("#txtCusID").val(result[0].MembershipID);
            $("#txtCashCusName").val(result[0].Fname + " " + result[0].Lname);
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
    var lookUpName = 'wholesale';
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "GetItemForWholeSaleSearch",
        data: JSON2.stringify({ LookUpName: lookUpName }),
        //data: "",
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

            $("#txtCashCusName").val("");
            $("#txtCusAddress").val();
            $("#txtPan").val("");

            $("#txtCashCusName").prop('disabled', false);
            $("#txtCusAddress").prop('disabled', false);
            $("#txtPan").prop('disabled', false);

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
                    if (value.LookupName == "wholesale") {
                        if (value.ImagePath == "")
                            htmls += "<div><img id='menuimg_" + value.ItemId + "_" + value.LanguageMenuText + "' class='menuimg' src='/Modules/ROCompanyInfo/logo/" + companyInfo.Logo + "' width='150px' height='120px'>";
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
                $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
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
            htmls += '<div><img attr-type="i" attr-iscat=' + value.IsCategory + ' id="categoryimg_' + value.ItemId + '_' + value.LanguageMenuText + '_false_' + value.IsOutOfStock + '_' + value.SRate + '" class="categoryimg" src="/Modules/' + (value.ImagePath == "" ? "ROCompanyInfo/logo/" + companyInfo.Logo : "ROI_Item/ImageItem/" + value.ImagePath) + '" width="150px" height="120px">';
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
        $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
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
                    htmls += "<div><img attr-type='i' id='itemimg_" + value.ItemID + "_" + value.LanguageMenuText + "_false_" + value.IsCategory + "_" + value.IsOutOfStock + "_" + value.SRate + "' class='itemimg' src='/Modules/" + (value.ImagePath == "" ? 'ROCompanyInfo/logo/' + companyInfo.Logo : 'ROI_Item/ImageItem/' + value.ImagePath) + "' width='150px' height='120px'>";
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
        $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
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
                $(this).attr('src', '/Modules/ROCompanyInfo/logo/' + companyInfo.Logo);
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
function calculateSurpDefct(str)  //// str->1 for Tender, str->2 for Return amt
{

    var surpDfct = 0;
    var returnAmt = 0;
    if (str == 1) {
        if ($("#txtTenderAmount").val() > $("#txtTotalCalc").val()) {
            returnAmt = $("#txtTenderAmount").val() - $("#txtTotalCalc").val();
        }

        surpDfct = $("#txtTenderAmount").val() - returnAmt - $("#txtTotalCalc").val();
    } else {
        returnAmt = $("#txtReturnAmount").val();
        surpDfct = $("#txtTenderAmount").val() - returnAmt - $("#txtTotalCalc").val();
    }

    $("#lblSurpDefct").text(surpDfct.toFixed(2));
    if (surpDfct < 0) {
        $(".clsSurpDefct").css('color', 'red');
    } else if (surpDfct > 0) {
        $(".clsSurpDefct").css('color', 'green');
    } else {
        $(".clsSurpDefct").css('color', 'black');
    }

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
                            tableId: TableId
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
    var cakeOrderList = new Array();

    var orderDetailsList = new Array();
    for (var i = 0; i < OrderListArray.length; i++) {
        var orderDetail = new Object();
        orderDetail.Quantity = OrderListArray[i].Quantity,
            orderDetail.ItemId = OrderListArray[i].ItemId,
            orderDetail.ItemName = OrderListArray[i].ItemName,
            orderDetail.IsCombo = OrderListArray[i].IsCombo,
            orderDetail.AddedBy = SageFrameUserName,
            orderDetail.UpdatedBy = '',
            orderDetail.IsArchived = false,
            orderDetail.ArchivedBy = SageFrameUserName,
            orderDetail.Rate = 0.0,
            orderDetail.Note = OrderListArray[i].Note,
            orderDetail.SeatNo = OrderListArray[i].SeatNo;
        orderDetail.Amount = 0.0
        orderDetail.Waiter = SageFrameUserName;
        cakeOrderList.push(orderDetail);
    }
    var ordermaster = new Object();
    ordermaster.cakeOrderList = cakeOrderList;
    ordermaster.OrderMasterID = OrderMasterID;
    ordermaster.CancelReason = '';
    ordermaster.BasicAmount = 0.0;
    ordermaster.BillNo = "";
    ordermaster.PAN = '';
    ordermaster.IsCancelled = cancel;
    ordermaster.NetAmount = 0.0;
    ordermaster.UpdatedBy = $('#hdnPinBy').val();
    ordermaster.SalesType = "wholesale";
    ordermaster.UserName = $('#hdnPinBy').val();
    ordermaster.Remarks = "";
    ordermaster.IsSplit = splited;
    ordermaster.GuestNo = noOfGuest;
    ordermaster.BillPaid = false;
    ordermaster.AddedBy = $('#hdnPinBy').val();
    ordermaster.CustomerName = $('#txtCustName').val();
    ordermaster.Phone = $('#txtContactNo').val();
    ordermaster.CustomerId = $('#CustomerID').text() == "" ? -1 : $('#CustomerID').text();
    //ordermaster.TokenNo = $('#txtTokenNo').val() == "" ? 0 : $('#txtTokenNo').val();
    ordermaster.Address = $('#txtAddress').val() == null ? '' : $('#txtAddress').val();
    ordermaster.OrderTypeID = wholesaleorder == true ? 7 : (foodCourtOrder == true ? 3 : (TableId > 0 ? 1 : 2));
    ordermaster.DeliveryService = '';

    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "SaveWholeOrderIntoDataBase",
        data: JSON2.stringify({ cakeOrderMasterInfo: ordermaster, orderExtraItems: ExtraItems, wholesaleorder: wholesaleorder }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            var val = data.d.split("_");
            $.each(val, function (index, value) {
                if (index != 0) {
                    jAlert(value + " Printing Failed. Printer Not Found.", 'Alert!!');
                }
            });
            if (OrderDelivery == true) {
                jAlert("Ordered Saved successfully", "Information!!", function () {
                    parent.$.colorbox.close();
                });
            }
            else if (TableId == 0) {
                GetDataForSalesBill(val[0]);
                if (foodCourtAutoBillGenerate) {
                    $("#generateBill").click();
                }
            }
            else {
                $.alerts.dialogClass = "order-info";
                jAlert("Ordered Saved successfully", "Information!!", function () {
                    parent.$.colorbox.close();
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
        data: JSON2.stringify({ orderMasterId: orderMasterId, SalesType: 'wholesale' }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            isButtonClicked = true;
            var datas = JSON.parse(data.d);
            orderdetails = datas.CakeOrderList;
            billingterms = datas.billingTerm;
            var htmls = "";
            $('#DialogOrderDetail').html("");
            totalAmount = 0.00;
            var DialogWidth = '900';

            htmls += "<div id='dialogOrderOpen'>";
            htmls += ("<div class='dashboardmain'>");
            if (orderdetails.length > 0) {
                htmls += ("<div class='left-sec'><h4>WholeSales Details</h4>");
                htmls += ("<h5>Ordered Items Details</h5>");
                htmls += ("<div class='item_list_div'><table class='item-list-tbl'><thead><th>S.N.</th><th style='width:250px'>Item</th><th>Qty</th><th>Rate (Rs.)</th><th>Amt (Rs.)</th></thead><tbody>");

                var sn = 1;
                $.each(orderdetails, function (index, value) {
                    //htmls += ("<tr class='" + value.SeatNo + " allsplited'><td>" + sn + "</td><td class='" + value.ItemId + "+" + value.OrderDetailsID + "+" + "'>" + value.ITName + "</td>");
                    htmls += ("<tr class='allsplited'><td>" + sn + "</td><td class=''>" + value.ItemName + "</td>");
                    htmls += ("<td>" + value.Quantity + "</td>");
                    htmls += ("<td class='item-rate'>" + value.Rate + "</td>");
                    amt = parseFloat(value.Quantity) * parseFloat(value.Rate);
                    totalAmount += parseFloat(amt);
                    htmls += ("<td class='item-amount'>" + amt + "</td></tr>");

                    sn++;
                });
                htmls += ("</tbody><tfoot><tr class='Total_Amt'><td colspan='4'  style='text-align:right;'>Amount:</td><td colspan='1' style='text-align:left;'><span class='totle'>Rs. " + totalAmount + "</span></td></tr>");
                htmls += ("</tfoot></table></div>");
            } else {
                htmls += ("<div class='left-sec'><h4>Take Away </h4>");
            }

            htmls += ("<h4>Discount Method</h4><div class='dialogflex' style='border-top:1px solid gainsboro;border-bottom:none;'><div id='discountDiv'><table id='tblDiscount' style='display:block;'><tbody>");
            totaldis = 0;
            htmls += ("<tr>");
            htmls += ("<td>Discount Type</td><td><select id='selDiscountType' class='sfInputbox' style='width:100px;'><option value='1' selected>Percent</option><option value='2'>Flat</option></select></td>");
            htmls += ("<td> <input id='txtDiscount' type='text' onkeypress='return validateFloatKeyPress(this,event)' placeholder='0'  class='sfInputbox txtdiscount' style='width:100px;'/></td></tr>");
            htmls += ("</tbody></table></div>");

            htmls += '<div id="divBillingTerm"></div></div></div>';
            htmls += '<div class="right-sec"><div class="right-secA"><h4>Customer Info</h4><table><tbody>';
            htmls += '<tr><td>Is Customer : </td><td><input type="checkbox" class="customerForCash" /></div></td></tr>';
            htmls += '<tr><td>Card No. : </td><td><input type="text" id="txtCardNumber" class="txtnum sfInputbox"/></td></tr>';
            htmls += '<tr><td>Customer Name: </td><td><input type="text" id="txtCashCusName" class="sfInputbox" value="' + datas.CakeOrderList[0].CustomerName + '"/><input type="hidden" id="txtCusID" value="" /></td></tr>';
            htmls += '<tr><td>Phone No. : </td><td><input type="text" id="txtNumber" class="txtnum sfInputbox" value="' + datas.CakeOrderList[0].Phone + '"/></tr>';
            htmls += '<tr><td>Address : </td><td><input type="text" id="txtCusAddress" class="sfInputbox" value="' + datas.CakeOrderList[0].Address + '"/></td></tr>';
            htmls += '<tr><td>PAN : </td><td><input type="text" id="txtPan" class="sfInputbox"/></td></tr>';
            htmls += '</tbody></table></div>';

            if (foodCourtOrder) {
                htmls += '<div class="right-secB">';
                htmls += '<table runat="server" clientidmode="static" id="payBill"><tr>';

                htmls += '<td class="clsSurpDefct"><span style="font-weight:bold;font-size:15px;">Sur/Def</span> : </td>';
                htmls += '<td class="clsSurpDefct"><span style="font-weight:bold;font-size:15px;"><lable width="50px" id="lblSurpDefct">0</lable></span></td></tr><tr>';

                htmls += '<td>Change Pay Mode<span style="color:red;">*</span> : </td>';
                htmls += '<td><select id="selPayMode" name="Paymode" class="sfInputbox">';
                htmls += '<option selected value="1">CASH</option>';
                htmls += '<option value="3">SWIPE</option>';
                htmls += '<option value="2">CHEQUE</option>';
                htmls += '<option value="4">Credit</option>';
                htmls += '<option value="5">ESewa</option>';
                htmls += '<option value="6">Fonepay</option>';
                htmls += '</select></td></tr>';
                htmls += '<tr class="cashpay"><td>Total Amount :</td>';
                htmls += '<td><input type="text" class="txtnum sfInputbox" disabled id="txtTotalCalc" /></td></tr>';
                htmls += '<tr class="cashpay"><td>Tender Amount :</td>';
                htmls += '<td><input type="text" class="txtnum sfInputbox" onkeypress="return validateFloatKeyPress(this,event)" onkeyup="return calculateSurpDefct(1)" placeholder="0" id="txtTenderAmount" /></td></tr>';
                htmls += '<tr class="cashpay"><td>Return Amount :</td>';
                htmls += '<td><input type="text" class="txtnum sfInputbox"  onkeypress="return validateFloatKeyPress(this,event)" onkeyup="return calculateSurpDefct(2)" placeholder="0" id="txtReturnAmount" /></td>';
                htmls += '</tr><tr id="prov" clientidmode="static" style="display:none;">';
                htmls += '<td>Provider : </td>';
                htmls += '<td><select id="selProv"></select></td>';
                htmls += '</tr><tr id="cheq" clientidmode="static" style="display:none;">';
                htmls += '<td>Cheque No<span style="color:red;">*</span> : </td>';
                htmls += '<td><input type="text" name="Cheque" id="txtCheqNo" class="sfInputbox" /></td>';
                htmls += ' </tr><tr id="trans" clientidmode="static" style="display:none;">';
                htmls += '<td>Transaction No<span style="color:red;">*</span> : </td>';
                htmls += '<td><input type="text" name="Transaction" id="txtTransNo" class="sfInputbox" /></td>';
                htmls += '<tr class="cashpay"><td>Remarks :</td>';
                htmls += '<td><textarea class="sfInputbox txtRemarks"></textarea></td></tr>';
                htmls += '</tr></table></div>';
            }
            htmls += '<input id="generateBill" type="button"  class="sfBtn restro-btn" value="Generate Bill" style="margin-left:10px;"/></div></div>';

            //htmls += ("</div></div></div></div>");
            //htmls += ("<input id='Pay_TakeAway_" + orderdetails[0].OrderMasterId + "' type='button'  class='sfBtn paynows restro-btn' value='Generate Bill' style='margin-left:10px;display:none;'/></div></div></div></div>");
            var orderMasterId = orderdetails[0].OrderMasterId;
            $('#DialogOrderDetail').html(htmls);
            BindBillingTerm(totalAmount, totaldis, datas);

            $("#txtDiscount").on('keyup', function () {
                CalculateForDiscount();
            });
            $("#selDiscountType").on('change', function () {
                CalculateForDiscount();
            });

            function CalculateForDiscount() {

                if ($("#selDiscountType option:selected").text().toLowerCase() == 'flat') {
                    discountAmount = parseFloat($("#txtDiscount").val()).toFixed(2);
                }
                else if ($("#selDiscountType option:selected").text().toLowerCase() == 'percent') {
                    discountAmount = (parseFloat($("#txtDiscount").val()).toFixed(2)) / 100 * totalAmount;
                }
                if (isNaN(discountAmount)) {
                    discountAmount = 0.00;
                }
                if (discountAmount > totalAmount) {
                    jAlert("Discount Amount Too Big");
                    discountAmount = 0.00;
                    $('#txtDiscount').val('');
                }
                //$('.totalDiscount').val('Rs ' + discountAmount);
                //$('#txtTaxableAmt').val('Rs ' + parseFloat(totalAmount - discountAmount).toFixed(2));
                //$('#BTerm_54_true').val('Rs ' + parseFloat(datas.billingTerm[0].Rate / 100 * (totalAmount - discountAmount)).toFixed(2));
                //$('#txtNetAmt').val('Rs' + parseFloat(((totalAmount - discountAmount) + datas.billingTerm[0].Rate / 100 * (totalAmount - discountAmount))).toFixed(2));

                $("#lblSurpDefct").text(0.00);
                $(".clsSurpDefct").css('color', 'black');

                BindBillingTerm(totalAmount, discountAmount, datas)
            }

            $(".txtdiscount").on('click', function (event) {
                InitializeNumPin(this, $(this).val());
            });

            $(".txtnum").on('click', function (event) {
                InitializeNumPin(this, $(this).val());
            });

            $('#DialogOrderDetail').dialog(
                {
                    'title': 'Sales Bill',
                    width: DialogWidth,
                    modal: true,
                    dialogClass: 'CheckEnable unpaidd',
                    position: ['center', 'center']
                });

            //if (tokeninfo.length > 0) {
            //    if (tokeninfo[0].CustomerID > 0) {
            //        GetmembershiplistbyId(tokeninfo[0].CustomerID);
            //    }
            //}

            if (foodCourtOrder) {
                getProviderList();
                $("#selPayMode").on('change', function () {

                    CalculateForDiscount();
                    if ($("#selPayMode").val() == 1) {
                        $(".cashpay").show();
                        $("#prov").hide();
                        $("#trans").hide();
                        $("#cheq").hide();
                    }
                    else if ($("#selPayMode").val() == 2) {
                        $(".cashpay").hide();
                        $("#prov").show();
                        $("#trans").hide();
                        $("#cheq").show();
                    }
                    else if ($("#selPayMode").val() == 3) {
                        $(".cashpay").hide();
                        $("#prov").show();
                        $("#trans").show();
                        $("#cheq").hide();
                    }
                    else if ($("#selPayMode").val() == 5) {
                        $(".cashpay").hide();
                        $("#prov").show();
                        $("#trans").show();
                        $("#cheq").hide();
                    }
                    else if ($("#selPayMode").val() == 6) {
                        $(".cashpay").hide();
                        $("#prov").show();
                        $("#trans").show();
                        $("#cheq").hide();
                    }
                    else if ($("#selPayMode").val() == 4) {
                        if ($('.customerForCash').prop('checked') == true) {
                            $(".cashpay").hide();
                            $("#prov").hide();
                            $("#trans").hide();
                            $("#cheq").hide();
                            membershipfor = "payment";
                            if (custid > 0)
                                dashboardfunction.deleteitem(custid);
                            else
                                dashboardfunction.GetCustomeronCheck();
                            $("#cashpaid").hide();
                        } else {
                            jAlert("Please Select Customer First !!!", "Error!!");
                        }

                    }
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
                    $('#txtCusID').val(0);

                    $("#txtCashCusName").val("");
                    $("#txtCusAddress").val();
                    $("#txtPan").val("");
                    $("#txtNumber").val("");
                    $("#txtCashCusName").prop('disabled', false);
                    $("#txtCusAddress").prop('disabled', false);
                    $("#txtPan").prop('disabled', false);

                    $("#selDiscountType").val(1);
                    $("#txtLoyaltyDiscount").val(0);

                }
            })
            //$("#selDiscountType").on('change', function () {

            //    amt = 0.00;
            //    totalAmount = 0.00;
            //    totaldis = 0.00;

            //    $('.item-list-tbl tbody').html("");
            //    var sn = 1;
            //    $.each(bookingDtlsArray, function (index, value) {
            //        var itms = "";
            //        itms += ("<tr class='llsplited'><td>" + sn + "</td><td class=''>" + value.ItemName + "</td>");
            //        itms += ("<td>" + 1 + "</td>");

            //        itms += ("<td class='item-rate'>" + value.ItemRate + "</td>");
            //        amt = parseFloat(1) * parseFloat(value.ItemRate);

            //        totalAmount += parseFloat(amt);
            //        itms += ("<td class='item-amount'>" + amt.toFixed(2) + "</td></tr>");

            //        sn++;
            //        $('.item-list-tbl tbody').append(itms);
            //    });

            //    if ($('#txtDiscount').val() == '') {
            //        $('#txtDiscount').val(0);
            //    }

            //    if ($("#selDiscountType").val() == "1") {    //// discout type is percentage
            //        if ($('#txtDiscount').val() > 100 || $('#txtDiscount').val() < 0) {
            //            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtDiscount').val(0);
            //        }
            //        totaldis = (parseFloat(totalAmount) * (parseFloat($('#txtDiscount').val() / 100)));
            //    } else {        ////discount type is flat
            //        if ($('#txtDiscount').val() > totalAmount || $('#txtDiscount').val() < 0) {
            //            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtDiscount').val(0);
            //        }
            //        totaldis = parseFloat($('#txtDiscount').val());
            //    }

            //    BindBillingTerm(totalAmount, totaldis, datas);
            //});
            //$("#txtLoyaltyDiscount").on('change', function () {
            //    $('#txtKotDiscount').val(0);
            //    $('#txtBarDiscount').val(0);
            //    $('#txtBakeryDiscount').val(0);
            //    $('#txtPizzaDiscount').val(0);
            //    totaldis += (totalAmount * (parseFloat($("#txtLoyaltyDiscount").val()) / 100));
            //    BindBillingTerm((totalAmount - roomAmount), totaldis, datas);
            //})
            //$('#txtKotDiscount').on('keyup', function (event) {
            //    if ($("#selDiscountType").val() == "1") {
            //        if ($('#txtKotDiscount').val() > 100 || $('#txtKotDiscount').val() < 0) {
            //            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtKotDiscount').val(0);
            //        }
            //        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
            //    } else {
            //        if ($('#txtKotDiscount').val() > kotAmount || $('#txtKotDiscount').val() < 0) {
            //            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtKotDiscount').val(0);
            //        }
            //        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
            //    }
            //    BindBillingTerm(totalAmount, totaldis, datas);
            //});

            //$('#txtBarDiscount').on('keyup', function (event) {
            //    if ($("#selDiscountType").val() == "1") {
            //        if ($('#txtBarDiscount').val() > 100 || $('#txtBarDiscount').val() < 0) {
            //            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtBarDiscount').val(0);
            //        }
            //        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
            //    } else {
            //        if ($('#txtBarDiscount').val() > barAmount || $('#txtBarDiscount').val() < 0) {
            //            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtBarDiscount').val(0);
            //        }
            //        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
            //    }
            //    BindBillingTerm(totalAmount, totaldis, datas);
            //});
            //$('#txtBakeryDiscount').on('keyup', function (event) {
            //    if ($("#selDiscountType").val() == "1") {
            //        if ($('#txtBakeryDiscount').val() > 100 || $('#txtBakeryDiscount').val() < 0) {
            //            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtBakeryDiscount').val(0);
            //        }
            //        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
            //    } else {
            //        if ($('#txtBakeryDiscount').val() > bakeryAmount || $('#txtBakeryDiscount').val() < 0) {
            //            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtBakeryDiscount').val(0);
            //        }
            //        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
            //    }
            //    BindBillingTerm(totalAmount, totaldis, datas);
            //});

            //$('#txtPizzaDiscount').on('keyup', function (event) {
            //    if ($("#selDiscountType").val() == "1") {
            //        if ($('#txtPizzaDiscount').val() > 100 || $('#txtPizzaDiscount').val() < 0) {
            //            jAlert("Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtPizzaDiscount').val(0);
            //        }
            //        totaldis = (parseFloat(kotAmount) * (parseFloat($('#txtKotDiscount').val() / 100))) + (parseFloat(barAmount) * ($('#txtBarDiscount').val() / 100)) + (parseFloat(bakeryAmount) * (parseFloat($('#txtBakeryDiscount').val() / 100))) + (parseFloat(pizzaAmount) * (parseFloat($('#txtPizzaDiscount').val() / 100)));
            //    } else {
            //        if ($('#txtPizzaDiscount').val() > pizzaAmount || $('#txtPizzaDiscount').val() < 0) {
            //            jAlert(" Invalid Discount.", 'Alert!!', function () { $.alerts.dialogClass = null; });
            //            $('#txtPizzaDiscount').val(0);
            //        }
            //        totaldis = parseFloat($('#txtKotDiscount').val()) + parseFloat($('#txtBarDiscount').val()) + parseFloat($('#txtBakeryDiscount').val()) + parseFloat($('#txtPizzaDiscount').val());
            //    }
            //    BindBillingTerm(totalAmount, totaldis, datas);
            //});

            var roles = userRole.split(',');
            //if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
            //    $("#enablebtn").hide();
            //}
            //else {
            //    $("#selDiscountType").prop('disabled', true);
            //    $(".txtdiscount").prop('disabled', true);
            //    $("#enablebtn").show();
            //}

            $("#generateBill").on('click', function () {
                if (foodCourtOrder && foodCourtAutoBillGenerate) {
                    $('.paynows').click();
                } else {
                    $('#hdnPinFor').val('generateBill');
                    InitializePin();
                }
            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}


function BindBillingTerm(totalAmount, totaldis, datas) {

    if (totaldis == null || totaldis == "") {
        totaldis = 0;
    }
    var htmls = "";
    $("#divBillingTerm").html(htmls);
    amntAfterDisc = 0;
    htmls += ("<table id='billingTerm'>");
    htmls += ("<tr>");
    htmls += (" <td attr-term='Total Discount' attr-percent='0' ><strong>Total Discount : </strong><input type=\"text\" id='txttotaldiscount' value=\"Rs. " + parseFloat(totaldis).toFixed(2) + "\"  class=\"sfInputbox_bill totalDiscount\" disabled  attr-amount='" + parseFloat(totaldis).toFixed(2) + "'/></td></tr>");
    htmls += (" <td attr-term='Total' ><strong>Total : </strong><input type=\"text\" value=\"Rs. " + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "\"  class=\"sfInputbox_bill totalAfterDisc\" disabled  attr-amount='" + (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2) + "'/></td></tr>");
    amntAfterDisc = (parseFloat(totalAmount) - parseFloat(totaldis)).toFixed(2);
    netAmount = 0.00;

    //commented to remove service charge
    //$.each(datas.billingTerm, function (index, item) {
    //    //if (item.Name != "Service Charge") 
    //    {
    //        if (item.BillTerm != "Evening Discount") {
    //            if (item.BillTerm != "VAT") {
    //                htmls += ("<tr>");
    //                htmls += ("<td attr-term='" + item.BillTerm + "' attr-percent='" + item.Rate + "'  ><strong>" + item.BillTerm + " " + "(" + item.Rate + "%" + ")" + " : </strong>");
    //                htmls += ("<input type=\"text\" id=\"BTerm_" + item.ID + "_" + item.IsAdd + "\" value=\"" + (item.IsAdd ? "" : "-") + "Rs. " + (amntAfterDisc * item.Rate / 100).toFixed(2) + "\" class=\"sfInputbox_bill\" disabled  attr-amount='" + (amntAfterDisc * item.Rate / 100).toFixed(2) + "'/>");
    //                htmls += ("</td>");
    //                htmls += ("</tr>");
    //                if (item.IsAdd == 1)
    //                    netAmount += parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
    //                else
    //                    netAmount -= parseFloat((amntAfterDisc * item.Rate / 100).toFixed(2));
    //            }
    //        }
    //    }
    //});
    netAmount = parseFloat((parseFloat(netAmount) + parseFloat(amntAfterDisc)).toFixed(2));
    if (datas.VATforBill) {
        if (datas.billingTerm[datas.billingTerm.length - 1].BillTerm == "VAT") {
            htmls += ("<tr>");
            htmls += ("<td attr-term='Taxable Amount' attr-percent='0' ><strong>Taxable Amount : </strong><input type=\"text\" id=\"txtTaxableAmt\" value=\"Rs. " + netAmount.toFixed(2) + "\"  class=\"sfInputbox_bill afterdiscountAmt \" disabled attr-amount='" + netAmount.toFixed(2) + "'/></td>");
            htmls += ("</tr>");
            htmls += ("<tr>");
            var vat = parseFloat(netAmount * 0.13).toFixed(2);
            htmls += ("<td attr-term='VAT' attr-percent='13' ><strong>VAT(13%) : </strong><input type=\"text\" id=\"BTerm_" + datas.billingTerm[datas.billingTerm.length - 1].ID + "_true" + "\"  value=\"Rs. " + vat + "\"  class=\"sfInputbox_bill  \" disabled  attr-amount='" + vat + "'/></td>");
            netAmount = (parseFloat(netAmount) + parseFloat(vat)).toFixed(2);
            htmls += ("</tr>");
        }
    }
    htmls += ("<tr>");
    htmls += ("<td attr-term='Net Amount' attr-percent='0' ><strong>Net Amount : </strong>");
    htmls += ("<input type=\"text\" id=\"txtNetAmt\" value=\"Rs. " + netAmount + "\" class=\"sfInputbox_bill\" disabled attr-amount='" + netAmount + "'/>");
    htmls += ("</td>");
    htmls += ("</tr>");
    htmls += ("</table>");
    if (foodCourtOrder) {
        $('#txtTotalCalc').val(parseFloat(netAmount).toFixed(2));
        $('#txtTenderAmount').val(parseFloat(netAmount).toFixed(2));
        $('#txtTotalCalc').change();
    }
    $("#divBillingTerm").html(htmls);
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
                    // htmls += "<td>" + value.Occupation + "</td>";
                    // htmls += "<td>" + value.Company + "</td>";
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
                        //"scrollY": false,
                        //"scrollCollapse": false,
                        "jQueryUI": true,
                        // "scrollX" : true,

                    });

                $("#membeshipformlist").dialog({
                    'title': 'Customer',
                    width: 800,
                    modal: true,
                    resizable: true,
                    position: ['center', 'center']
                });


            } else {
                $('#membeshipformlist').html('No data');

            }
            $(".dataTables_scrollBody").css('height', '100%');

            //  $("#membeshipformlist").on('click', '.selectCust', function (event) {
            $("#membeshipformlist").on('click', '#customertable tr', function (event) {
                var deletedata = $(this).attr('id');
                var ids = deletedata.split('_');
                $('#CustomerID').text(ids[1]);
                $('#loyalityDiscount').text(ids[6]);
                $("#txtCustName").val(ids[2] + " " + ids[3]);
                $("#txtNumber").val(ids[7]);
                $("#txtAddress").val(ids[5]);

                $("#txtCusID").val(ids[1]);
                $("#txtCashCusName").val(ids[2] + " " + ids[3]);
                $("#txtCusAddress").val(ids[5]);
                $("#txtPan").val(ids[4]);

                $("#txtCashCusName").prop('disabled', true);
                $("#txtCusAddress").prop('disabled', true);
                $("#txtPan").prop('disabled', true);

                $("#txtLoyaltyDiscount").val(ids[6]);
                $("#membeshipformlist").dialog('close');
                $("#selDiscountType").change();

            });
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}
function saveCakeSalesBill(salesMaster, salesDetail, billingTerm, Payment, discount) {
    var customer = 1;
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "saveCakeSalesBill",
        data: JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, billingTerm: billingTerm, spm: Payment, flatorperdiscount: discount }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $('#DialogOrderDetail').dialog('close');

            getCakeBill(data.d, false, salesMaster.SalesType);
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
                savePrintCount((parseInt($('#hdfPrntCnt').val()) + 1), parseInt($('#hdfSMID').val()), SageFrameUserName, 'wholesale');
            });
            Print();

            $('#InvoiceType').html('INVOICE');
            Print();
            $('#BillingView').dialog('close');

            jAlert('Bill printed successfully', "Information!!", function () {
                window.location.reload();
            });
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
        url: baseUrl + "SaveFoodCourtSalesBill",
        data: JSON2.stringify({ salesMaster: salesMaster, salesDetail: salesDetail, splited: splited, billingTerm: billingTerm, flatorperdiscount: discount, payment: salesPayment }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            $('#DialogOrderDetail').dialog('close');

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
            $("#txtAddress").val('');
            $('#loyalityDiscount').text(0);
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
}

function savePrintCount(printcount, billNo, printedBy, salesType) {
    $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: baseUrl + "savePrintCount",
        data: JSON2.stringify({ Printcount: printcount, BillNo: billNo, PrintedBy: printedBy, SalesType: salesType }),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            //$('#printno').show();
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
        ordermaster.GuestNo = parseInt($('#splitNoCancel').text());
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

function initialSetup(tableId, oId, hostUrl, foodCourt, Delievery) {
    if (userRole == 'Super User') {
        $(".restrologo").css("display", "none");
        $(".iframeeClose").click(function () {
            $(".restrologo").css("display", "");
        });
    } else {
        $(".restrologo").css("display", "");
    }

    $('#hdnPinMatch').on('change', function () {
        if ($('#hdnPinMatch').val() == "true") {
            //$('#hdnPinMatch').unbind('change');
            var pinFor = $('#hdnPinFor').val();
            if (pinFor == 'generateBill') {
                //$('.paynows').click();
                paynows();
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
                    if (foodCourtOrder) {
                        SaveOrderedData();
                    } else {
                        bindForCancel(PreviousOrdersList);
                    }
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

    TableId = parseInt(oId) > 0 ? TableId : tableId;
    OID = oId;
    HostUrl = hostUrl;
    foodCourtOrder = foodCourt;
    OrderDelivery = Delievery;
    if (!isNaN(tableId) && tableId > 0) {
        $('#tableData').show();
    } else {
        $('#tableData').show();
        $('.tabledet td').hide();
        $('.tabledet .tbldet').show();
    }
    if (foodCourt) {
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: baseUrl + "IsFoodCourtAutoBilling",
            data: '',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                foodCourtAutoBillGenerate = (data.d == 'true' ? true : false);
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
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
        if (OrderDelivery == true) {
            if ($("#txtCustName").val().length < 3) {
                jAlert('Please Insert valid name', 'Alert!!');
            } else if ($("#txtContactNo").val().length < 9) {
                jAlert('Contact Number must at least be more than Nine character', 'Alert!!');
            } else if ($("#txtAddress").val().length < 5) {
                jAlert('Please Insert valid Address', 'Alert!!');
            }
            else {
                $('#hdnPinFor').val('SendOrder');
                InitializePin();
            }
        } else {
            $('#hdnPinFor').val('SendOrder');
            InitializePin();
        }

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

        $('.ExtraQuantity').on('change', function () {
            itemQnty = parseInt($('#qty_' + itemID + '_false').val());
            qnty = 0;
            $('.ExtraQuantity').each(function () {
                qnty += parseInt($(this).val());
                if (qnty > itemQnty) {
                    qnty -= parseInt($(this).val());
                    $(this).val(0);
                    jAlert('Extra Item Qunatity Cannot be greater than Item Quantity', 'Alert!!', function () { $.alerts.dialogClass = null; });
                }
            })
        });

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

function paynows() {
    var billingTerm = new Array();
    var salesMaster = new Object();
    var salesPayMode = new Object();
    var splited = 0;
    var salesDetail = new Array();

    //salesMaster.billNo = orderdetails[0].BillNo;
    salesMaster.BillNo = "";
    salesMaster.BillDate = new Intl.DateTimeFormat('en-US').format(new Date());
    salesMaster.OrderMasterId = orderdetails[0].OrderMasterId;
    salesMaster.CustomerId = $('#CustomerID').text() == "" ? -1 : $('#CustomerID').text();
    salesMaster.CustomerName = $('#txtCustName').val();
    salesMaster.ContactNumber = $('#txtContactNo').val();
    salesMaster.PAN = $('#txtPan').val();
    salesMaster.Address = $('#txtAddress').val() == null ? '' : $('#txtAddress').val();
    salesMaster.BasicAmount = (parseFloat($('.totalAfterDisc').val().split(' ')[1]));
    salesMaster.TermAmount = 0.00;
    salesMaster.NetAmount = $('#txtNetAmt').val().split(' ')[1];
    salesMaster.AdvancePayment = 0;
    salesMaster.Reasons = '';
    salesMaster.NepaliInvoiceDate = formatDate();
    salesMaster.AddedBy = $('#hdnPinBy').val();
    salesMaster.SalesType = 'wholesale';
    salesMaster.TenderAmount = 0.00;
    salesMaster.ReturnAmount = 0.00;

    //salesMaster.totaldiscount = totaldis;
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
        var sd = {
            ItemId: value.ItemId,
            ItemName: value.ItemName,
            Quantity: value.Quantity,
            Rate: value.Rate,
            //Rate: ($('#selDiscountType').val() == "4" ? 1 : value.Rate),
            Amount: value.Amount,
            //Amount: ($('#selDiscountType').val() == "4" ? (value.Quantity * 1) : value.Amount),
            NetAmount: value.Amount,
            CostCenterId: value.CostCenterId
        }
        salesDetail.push(sd);
    });

    var discount = new Object();
    discount.SalesMasterId = orderdetails[0].OrderMasterId;
    discount.DiscountValue = ($('#txtDiscount').val() == "" ? 0 : $('#txtDiscount').val());
    discount.IsFlatDis = ($('#selDiscountType').val() == "2" ? true : false);;
    discount.TotalDiscount = $('#txttotaldiscount').attr('attr-amount');
    discount.BasicAmount = $('#txtTaxableAmt').attr('attr-amount');

    //if (foodCourtOrder) {
    var Payment = {};
    Payment.SPMID = $('#selPayMode').val();
    Payment.ChequeNo = ($('#selPayMode').val() == 2 ? $('#txtCheqNo').val() : "");
    Payment.TransactionNo = ($('#selPayMode').val() == 3 ? $('#txtTransNo').val() : "");
    Payment.ProviderID = (($('#selPayMode').val() == 3 || $('#selPayMode').val() == 2) ? $('#selProv').val() : "");
    Payment.CusID = $('#CustomerID').text() == "" ? -1 : $('#CustomerID').text();
    Payment.Customer = $('#txtCustName').val();
    Payment.Address = $('#txtAddress').val() == null ? '' : $('#txtAddress').val();
    Payment.PAN = $('#txtPan').val();
    Payment.PayAmount = ($('#selPayMode').val() == 1 ? parseFloat($('#txtTenderAmount').val() - $('#txtReturnAmount').val()) : $('#txtNetAmt').val().split(' ')[1]);
    Payment.TenderAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtTenderAmount').val() == "" ? 0 : parseFloat($('#txtTenderAmount').val()))) : 0);
    Payment.ReturnAmount = ($('#selPayMode').val() == 1 ? parseFloat(($('#txtReturnAmount').val() == "" ? 0 : parseFloat($('#txtReturnAmount').val()))) : 0);
    Payment.ReturnPayment = 0.00;
    Payment.Remarks = $('.txtRemarks').val();
    Payment.SalesType = 'wholesale';


    jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
        if (confirmed) {
            saveCakeSalesBill(salesMaster, salesDetail, billingTerm, Payment, discount)
        }
    });

    //    if (foodCourtAutoBillGenerate) {
    //        SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPayment)
    //    } else {
    //        jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
    //            if (confirmed) {
    //                SaveFoodCourtSalesBill(salesMaster, salesDetail, splited, billingTerm, discount, salesPayment)
    //            }
    //        });
    //    }
    //} else {
    //    jConfirm('Are You Sure  ?', 'Pay', function (confirmed) {
    //        if (confirmed) {
    //SaveSalesBill(salesMaster, salesDetail, splited, billingTerm, discount)
    //    }
    //});
    //}
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
            {
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
                if (allOrders[0].CustomerID > 0) {
                    $('.customerForOrder').prop('checked', true);
                }
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
        },
        failure: function (response) {
            jAlert("Sorry some error occured. Contact the support team.", "Error!!");
        }
    });
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
        salesMaster.CusName = $('#txtCashCusName').val();
        salesMaster.Address = $('#txtCusAddress').val();
        salesMaster.PAN = $('#txtPan').val();
        salesMaster.ChequeNo = "";
        salesMaster.TransactionNo = "";
        salesMaster.CusID = ($('#txtCusID').val() == "" ? 0 : parseInt($('#txtCusID').val()));
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

            salesPayment.CusID = ($('#txtCusID').val() == "" ? 0 : parseInt($('#txtCusID').val()));
            salesPayment.Customer = ($('#txtCashCusName').val() == "" ? "" : $('#txtCashCusName').val());
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
            $("#txtCusID").val(datas[0].MembershipID);
            $("#txtCashCusName").val(datas[0].Name);
            $("#txtCusAddress").val(datas[0].Address);
            $("#txtPan").val(datas[0].PAN);
            $("#txtNumber").val(datas[0].TelMobile);
            $("#txtCardNumber").val(datas[0].CardNumber);

            $("#txtCashCusName").prop('disabled', true);
            $("#txtCusAddress").prop('disabled', true);

            $("#txtLoyaltyDiscount").val(datas[0].discount);
            var roles = userRole.split(',');

            if (roles.includes("Super User") || roles.includes("Billing_Discount")) {
                $("#selDiscountType").val(3);
                $("#selDiscountType").change();
            }
            else {
            }
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
    $('.totalamount').text('Total Amount: RS. ' + total);

}

