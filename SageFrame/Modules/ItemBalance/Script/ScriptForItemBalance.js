(function ($) {
    var tabs = $("#tabs").tabs();
    var deletecount = 0;
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '',
                 Username: ''
             }, p);
        var v = 0;
        var AutocompleteItem = [];
        var DeleteArray = [];
        var name = [];
        var companyProf = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForItemBalance.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                CustomerId: 0,
                Customerupdate: 0,


            },
            InitialSetup: function () {


                //companyProf.GetItem();
                companyProf.GetStore();
                companyProf.GetItemBalance();
                companyProf.GetItemForAutocomplete();





            },
            init: function () {

                companyProf.InitialSetup();
                
                    $("#itemName").autocomplete({
                        source: AutocompleteItem,
                        delay: 0,
                        select: function (event, ui) {
                            var ids = ui.item.id;
                            $("#dd_itemName").val(ids);
                            companyProf.config.method = "GetUnitOfItemByID";
                            companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                            companyProf.config.data = JSON2.stringify({ ids: ids });
                            companyProf.config.ajaxCallMode = 8;
                            companyProf.ajaxCall(companyProf.config);
                        }
                    });

                $("#sotablebalance").on('click', '#checkall', function (event) {
                    // $("#checkall").click(function () {
                    $('input:checkbox').not(this).prop('checked', this.checked);


                    if ($("#checkall").not(this).prop('checked', this.checked)) {

                        var count = DeleteArray.length;
                        while (count > 0) {
                            DeleteArray.pop();
                            count--;
                        }
                    }

                    $('input:checkbox[id^="check_"]:checked').each(function () {
                        var data = $(this).attr('id');
                        var split = data.split("_");
                        var dta = parseInt(split[1]);
                        if ($(this).prop('checked') == true) {
                            if ($.inArray(dta, DeleteArray) == -1) {
                                DeleteArray.push(dta);
                            }
                        }
                        else {
                            var idx = $.inArray(dta, DeleteArray);
                            if (idx == -1) {

                            } else {
                                DeleteArray.splice(idx, 1);
                            }
                        }
                    });
                });

                $("#btnSave").off().on("click", function (event) {
                    $("#divForForm").dialog('close');
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SaveCustomer();
                        companyProf.GetItemBalance();
                        companyProf.ResetCustomerForm();

                    }
                });

                //$("#sotablebalance").on('click', '.CustomerDelete', function (event) {

                //   // companyProf.CustomerDelete(this);
                //    companyProf.GetCustomer();
                //    companyProf.ResetCustomerForm();
                //});
                $("#addCustomer").on('click', function () {
                    $("#customertable").show();
                    $(".customerBotton").show();
                    $("#addCustomer").hide();
                    $("#btnSaveCustomer").show();
                    $("#btnCancelCustomer").show();
                    $("#sotablebalance").hide();


                });
                $("#btnCancelCustomer").on('click', function () {
                    $("#customertable").hide();
                    $(".customerBotton").hide();
                    $("#addCustomer").show();
                    companyProf.ResetCustomerForm();
                    $("#sotablebalance").show();
                    var validator = $("#form1").validate();
                    validator.resetForm();
                    //var vali = companyProf.ValidationForm();
                    //vali.resetForm();
                    companyProf.ResetCustomerForm();
                    location.reload();
                });

                $("#sotablebalance").on('change', '#checkall', function (event) {
                    if (this.checked)
                        $('#btnDeleteSelected').fadeIn('slow');
                    else
                        $('#btnDeleteSelected').fadeOut('slow');

                });

                $("#sotablebalance").on('change', '.checkit', function (event) {
                    if (this.checked) {
                        $('#btnDeleteSelected').fadeIn('slow');
                        deletecount++;
                    }
                    else {
                        deletecount--;
                        if (deletecount < 2) {
                            $('#btnDeleteSelected').fadeOut('slow');
                        }
                    }
                });

                $('#txtCustomerCSINo').focusout(function () {
var CustomerCsiNo = $('#txtCustomerCSINo').val().toLowerCase();
                    var found = $.inArray(CustomerCsiNo, name);
                    if (found != -1) {
                        jAlert('CSI No Already Exists', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        $('#txtCustomerCSINo').val('');
                    }
                });


                //$('#txtCustomerCSINo').focusout(function () {
                //    var DepName = $('#txtCustomerCSINo').val().toLowerCase();
                //    var found = $.inArray(DepName, name);
                //    if (found != -1) {
                //        alert('CSI No Already Exists');
                //        $('#txtCustomerCSINo').val('');
                //    }
                //});

                $("#CancelItems").click(function () {
                    $("#divForForm").dialog('close');
                    companyProf.ResetCustomerForm();
                    //$("#btnAdd").show();
                    //$("#sotablebalance").show();
                    //$("#divForForm").hide();
                });
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: companyProf.config.type,
                    contentType: companyProf.config.contentType,
                    async: companyProf.config.async,
                    cache: companyProf.config.cache,
                    url: companyProf.config.url,
                    data: companyProf.config.data,
                    dataType: companyProf.config.dataType,
                    success: companyProf.ajaxSuccess,
                    error: companyProf.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        jAlert('Inserted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        companyProf.GetItemBalance(data);
                        companyProf.ResetCustomerForm();
                        $("#sotablebalance").show();
                        $("#customertable").hide();
                        $("#btnSaveCustomer").hide();
                        $("#btnCancelCustomer").hide();
                        $("#addCustomer").show();
                        break;
                    case 2:
                        jAlert('Updated successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("#customertable").hide();
                        $("#btnCancelCustomer").hide();
                        $("#btnSaveCustomer").hide();
                        $("#addCustomer").show();
                        break;
                    case 3:
                        //  alert("Deleted successfully")
                        break;
                    case 4:
                        companyProf.BindItem(data);
                        break;
                    case 5:
                        companyProf.BindStore(data);

                        break;
                    case 6:
                        companyProf.BindItemBalance(data);

                        break;
                    case 7:
                        companyProf.BindDropdwonItem(data);

                        break;
                    case 8:
                        companyProf.BindUnitOfItemByID(data);
                        break;

                }
            },
            ajaxFailure: function () {



            },

            GetItemForAutocomplete: function () {
                companyProf.config.method = "GetItemForSearch";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 7;
                companyProf.ajaxCall(companyProf.config);
            },
            BindDropdwonItem: function (result) {
                var datas = result.d;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                            //if (value.IsCategory == false && value.IsCategory!=null)
                        {
                        AutocompleteItem.push({ label: value.ITName, id: value.ITId });
                        }
                        //obj.AutocompleteItem.push({ 'ITId': value.ITId, 'ITName': value.ITName,'LargeUnit':value.LargeUnit,'UnitDescription':value.UnitDescription });
                        //htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });

                }
            },
            BindUnitOfItemByID: function (result) {
                //if (!result.data) return;
                //if (!result.d) return;
                //var datas = result.d;
                //if (datas.length > 0) {
                //    $.each(datas, function (index, value) {
                //        $("#itemUnit").val(value.Symbol);
                //    });
                //}

                var datas = result.d;
                var htmls = "";
                $("#itemUnit").html('');
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "' attr-conversion='" + value.Conversion + "'>" + value.Symbol + "</option>";
                    });
                }
                $("#itemUnit").html(htmls);
            },

            SaveCustomer: function () {
                var BalanceInfo = {};

                BalanceInfo.ITId = $('#dd_itemName').val();
                // BalanceInfo.PDId = $('#txtCustomerName').val();
                BalanceInfo.STId = $('#dd_store').val();
                BalanceInfo.OPBal = parseFloat($('#txtOpeningBalance').val())*parseFloat($("#itemUnit :selected").attr('attr-conversion'));
                BalanceInfo.OPRate = parseFloat($('#txtOpeningRate').val()) / parseFloat($("#itemUnit :selected").attr('attr-conversion'));




                companyProf.config.method = "SaveBalance";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ BalanceInfo: BalanceInfo });
                if (companyProf.config.Customerupdate == 1) {
                    companyProf.config.ajaxCallMode = 2;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }

                companyProf.ajaxCall(companyProf.config);
                companyProf.config.Customerupdate = 0;

            },



            GetItem: function () {
                companyProf.config.method = "GetItemDropDown";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },
            GetItemBalance: function () {
                companyProf.config.method = "GetItemBalance";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 6;
                companyProf.ajaxCall(companyProf.config);
            },

            GetStore: function () {
                companyProf.config.method = "GetStoreDropDown";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 5;
                companyProf.ajaxCall(companyProf.config);
            },


            BindStore: function (result) {
                //if (!result.data) return;
                if (!result.d) return;
                var datas = result.d;
                $("#dd_store").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>Select</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });

                    $("#dd_store").html(htmls);
                }

            },

            BindItem: function (result) {
                //if (!result.data) return;
                if (!result.d) return;
                var datas = result.d;
                $("#dd_itemName").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>Select</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ITId + "'>" + value.ITName + "</option>";
                    });

                    $("#dd_itemName").html(htmls);
                }

            },



            BindItemBalance: function (data) {
                $("#sotablebalance").show();
                $("#sotablebalance").html('');
                var totalOpeningStockValue = 0.00;
                
                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='custable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"

                    htmls += "<tr>"

                    htmls += " <th style='width:150px'>Item Name </th><th> Store Name </th><th> Opening Balance </th><th> Opening Rate </th><th> Opening Stock Value </th>";

                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {
                        debugger;
                        //var colorClass = null;
                        //if (value.statusTitle == "Not Started") colorClass = "stateNotStarted";
                        //else if (value.statusTitle == "WIP") colorClass = "stateWIP";
                        //else colorClass = "stateComplete";
                        if (value.OPBal != 0) {
                            htmls += "<tr class=table id=" + value.ItemBalID + "_>";
                            htmls += "<td>" + value.ITName + "</td>";
                            htmls += "<td>" + value.StName + "</td>";
                            htmls += "<td>" + value.OPBal + " (" + value.Symbol + ") </td>";
                            htmls += "<td>" + value.OPRate + "</td>";
                            htmls += "<td>" + value.TotalValue + "</td>"
                            //htmls += '<td><label value="Edit" class="openingEdit icon-edit" id="' + value.ItemBalID + '"></label></td>'
                            
                            htmls += "</tr>"

                            totalOpeningStockValue += value.TotalValue;
                        }

                    });
                    
                    htmls += "</tbody>";
                    htmls += "<tfooter>";
                    htmls += "<tr><td colspan='4' style='text-align:right;'><strong>Total Stock Value: </strong></td><td><strong>" + totalOpeningStockValue + " (Rs)</strong></td></tr>"
                    htmls += "</tfooter>";
                    htmls += "</table>";
                    $('#sotablebalance').html(htmls);
                    $('#custable').DataTable(
                         {

                             "jQueryUI": true,
                             "searching": true,
                             ordering : false,
                             //"scrollY": false,
                             //"scrollCollapse": false,


                         });

                } else {
                    $('#sotablebalance').html('No data');
                }



                $("#btnDeleteSelected").off().on("click", function (event) {
                    jConfirm('Are you sure you want to delete?', 'Confirmation Dialog', function (r) {
                        //jAlert('Confirmed: ' + r, 'Confirmation Results');
                        if (r) {
                            $.each(DeleteArray, function (index, value) {
                                companyProf.CustomerDelete(value);
                                companyProf.GetCustomer();
                            });
                        }
                        jAlert('Deleted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                    });

                });


                $("#sotablebalance").on('click', '.checkit', function (event) {
                    //   $(".checkit").on("change", function () {
                    var data = $(this).attr('id');
                    var split = data.split("_");
                    var dta = parseInt(split[1]);
                    //if ($("#isAgeSelected").is(':checked'))
                    if ($(this).prop('checked') == true) {
                        if ($.inArray(dta, DeleteArray) == -1) {
                            DeleteArray.push(dta);
                        }
                    }
                    else {
                        var idx = $.inArray(dta, DeleteArray);
                        if (idx == -1) {

                        } else {
                            DeleteArray.splice(idx, 1);
                        }
                    }

                });

                $("#sotablebalance").on('click', '.CustomerDelete', function (event) {

                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    jConfirm('Are You Sure You Want To Delete This?', 'Confirmation Dialog', function (r) {
                        //jAlert('Confirmed: ' + r, 'Confirmation Results');
                        if (r) {
                            companyProf.CustomerDelete(id);
                            companyProf.GetItemBalance();
                            companyProf.ResetCustomerForm();
                        }
                        jAlert('Deleted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                    });



                });
                $("#sotablebalance").on('click', '.CustomerEdit', function (event) {
                    // $(".CustomerEdit").off().on('click', function (event) {
                    $("#customertable").show();
                    $(".customerBotton").show();
                    $("#btnSaveCustomer").show();
                    $("#btnCancelCustomer").show();
                    $("#addCustomer").hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.CustomerId = words[0];
                    $("#txtCustomerName").val(words[1]);
                    $("#txtCustomerCSINo").val(words[2]);
                    $("#txtOfficeAddress").val(words[3]);
                    $("#txtSiteAddress").val(words[4]);
                    $("#txtContactName").val(words[5]);
                    $("#txtCustomerPosition").val(words[7]);
                    $("#txtCustomerPhone").val(words[6]);
                    $("#txtContactNameCom").val(words[8]);
                    $("#txtCustomerComPhone").val(words[9]);
                    $("#txtCustomerPositioncom").val(words[10]);
                    $("#txtCustomerFax").val(words[11]);
                    companyProf.config.Customerupdate = 1;

                });



            },



            CustomerDelete: function (id) {
                //var id = parseInt(item.id.split("_")[1])
                //$("#" + id + "_").remove();
                var ItemBalID = id;
                companyProf.config.method = "Deletebalance";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ ItemBalID: ItemBalID });
                companyProf.config.ajaxCallMode = 3;

                companyProf.ajaxCall(companyProf.config);



            },


            ResetCustomerForm: function () {
                $('#dd_itemName').val('');
                $('#itemName').val('');
                $('#itemUnit').val('');
                $('#dd_store').val('');
                $('#txtOpeningBalance').val('');
                $("#btnAdd").show();
                $("#sotablebalance").show();
                $("#divForForm").hide();
                $("#txtOpeningRate").val('');


            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {


                        Item: {
                            required: true,
                        },
                        Store: {
                            required: true,
                        },

                        OpeningBalance: {
                            required: true,
                            number: true,
                        },
                        OpeningRate: {
                            required: true,
                            number:  true,
                        }



                    },
                    DonorName: {

                        required: '*'

                    },


                });
                if (v.form()) {
                    return true;
                }
                else
                    return false;

            },

        };
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);


