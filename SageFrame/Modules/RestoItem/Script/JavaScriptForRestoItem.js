(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '',
                 Username: ''
             }, p);
        var v = 0;
        var name = [];
        var companyProf = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceOfRestoItem.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,

                RId: 0,
                Brandupdate: 0,
            },

            InitialSetup: function () {
                companyProf.GetItem();
                companyProf.GetUnit();
                companyProf.GetRollerItem();
                $("#txtValidFrom").datepicker({
                    changeYear: true,
                    changeMonth:true,
                });
                $("#tblRestoItem").hide();
                $("#btnSaveItem").hide();
                $("#btnCancelItem").hide();               
            },



            init: function () {

                companyProf.InitialSetup();                
                //$('#txtBrand').focusout(function () {

                //    var DepName = $('#txtBrand').val().toLowerCase();
                //    var found = $.inArray(DepName, name);
                //    if (found != -1) {
                //        alert('Brand Already Exists');
                //        $('#txtBrand').val('');
                //    }
                //});

                $("#txtPurchaseRate, #txtSellingRate").on("keyup", function () {
                    var valid = /^\d{0,4}(\.\d{0,2})?$/.test(this.value),
                        val = this.value;

                    if (!valid) {
                        console.log("Invalid input!");
                        this.value = val.substring(0, val.length - 1);
                    }
                });


                $("#btnSaveItem").off().on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                   if (checkValid) {
                        companyProf.SaveRollerItem();
                        companyProf.ResetItemForm();
                        companyProf.InitialSetup();
                    }
                });

                $("#btnAddItem").off().on("click", function (event) {
                    $("#tblRestoItem").show();
                    $("#btnSaveItem").show();
                    $("#btnCancelItem").show();
                    $("#btnAddItem").hide();
                    $("#SortableRestoItem").hide();
                });

                $("#btnCancelItem").off().on("click", function (event) {
                    $("#tblRestoItem").hide();
                    $("#btnSaveItem").hide();
                    $("#btnCancelItem").hide();
                    $("#btnAddItem").show();
                    $("#SortableRestoItem").show();
                    var validator = $("#form1").validate();
                    validator.resetForm();
                    companyProf.ResetItemForm();
                });

                $("#SortableRestoItem").on('click', '.BrandDelete', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                        //jAlert('Confirmed: ' + r, 'Confirmation Results');
                        if (r) {
                            companyProf.DeleteItem(id);
                            companyProf.ResetItemForm();
                            companyProf.GetRollerItem();
                           

                        }
                    });
                });

                //$("#sortableBrandList").on('click', '.BrandDelete', function (event) {
                //    companyProf.DeleteBrand(this)
                //    companyProf.ResetBrandForm();
                //});

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
                        alert("Saved");
                        break;
                    case 2:
                        alert("Saved");
                        // companyProf.GetBrnd(data);
                        $("#tblRestoItem").hide();
                        $("#btnSaveItem").hide();
                        $("#btnCancelItem").hide();
                        $("#btnAddItem").show();
                        $("#SortableRestoItem").show();
                        break;
                    case 3:
                        companyProf.BindItemRateTable(data);
                        break;
                    case 4:
                        alert("Updated");
                        companyProf.GetRollerItem(data);
                        companyProf.ResetItemForm();
                        location.reload();
                        $("#tblRestoItem").hide();
                        $("#btnSaveItem").hide();
                        $("#btnCancelItem").hide();
                        $("#btnAddItem").show();
                        $("#SortableRestoItem").show();
                        break;
                    case 5:
                        alert("Deleted");
                        companyProf.GetRollerItem(data);
                        $("#tblRestoItem").hide();
                        $("#btnSaveItem").hide();
                        $("#btnCancelItem").hide();
                        $("#btnAddItem").show();
                        $("#SortableRestoItem").show();
                        break;
                    case 6:
                        companyProf.BindItem(data);
                        break;
                    case 7:
                        companyProf.BindUnit(data);
                        break;
                }
            },
            ajaxFailure: function () {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 5:
                        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                        break;
                }
            },

            SaveRollerItem: function () {
                var ItemInfoobj = {};
                ItemInfoobj.RId = companyProf.config.RId;
                ItemInfoobj.ITId = parseInt($('#dd_itemName').val());
                ItemInfoobj.UnitId = parseInt($('#dd_unitName').val());
                ItemInfoobj.PRate = parseFloat($('#txtPurchaseRate').val());
                ItemInfoobj.SRate = parseFloat($('#txtSellingRate').val());
                ItemInfoobj.ValidFrom = $('#txtValidFrom').val();
                ItemInfoobj.PostedBy = p.Username;
              
                companyProf.config.method = "SaveRestoItem";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ ItemInfoobj: ItemInfoobj });
                if (companyProf.config.Brandupdate == 1) {
                    companyProf.config.ajaxCallMode = 4;
                } else {
                    companyProf.config.ajaxCallMode = 2;
                }

                companyProf.ajaxCall(companyProf.config);
                companyProf.config.Brandupdate = 0;


            },


            GetRollerItem: function () {
                companyProf.config.method = "GetRollerItemFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 3;
                companyProf.ajaxCall(companyProf.config);
            },

            GetItem: function () {
                companyProf.config.method = "GetItemDropDown";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 6;
                companyProf.ajaxCall(companyProf.config);
            },

            GetUnit: function () {
                companyProf.config.method = "GetUnitDropDown";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 7;
                companyProf.ajaxCall(companyProf.config);
            },


            BindUnit: function (result) {
                //if (!result.data) return;
                if (!result.d) return;
                var datas = result.d;
                $("#dd_unitName").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>Select</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitId + "'>" + value.Particulars + "</option>";
                    });

                    $("#dd_unitName").html(htmls);
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


            BindItemRateTable: function (data) {
                $("#SortableRestoItem").show();
                $("#SortableRestoItem").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Item </th><th> Unit </th><th> Buying Rate </th><th> Selling Rate </th><th> Valid From </th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.RId + "_>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Particulars + "</td>";
                        htmls += "<td>" + value.PRate + "</td>";
                        htmls += "<td>" + value.SRate + "</td>";
                        var p = value.ValidFrom.split(' ')[0];
                        htmls += "<td>" + p + "</td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.ItemRateID + "_" + value.ItemId + "_" + value.UnitId + "_" + value.PRate + "_" + value.SRate + "_" + value.ValidFrom + "' value='Edit'  /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.ItemRateID + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#SortableRestoItem').html(htmls);
                    $('#Brandtable').DataTable(
                         {
                             "scrollY": false,
                             "scrollCollapse": false,
                             "jQueryUI": true,

                         });

                } else {
                    $('#SortableRestoItem').html('No data');

                }
                $("#SortableRestoItem").on('click', '.BrandEdit', function (event) {
                    $("#tblRestoItem").show();
                    $("#btnSaveItem").show();
                    $("#btnCancelItem").show();
                    $("#btnAddItem").hide();
                    $("#SortableRestoItem").hide();

                    $("#brandtable").show();
                    $(".brandButton").show();
                    $("#addbrand").hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.RId = words[0];
                    $("#dd_itemName").val(words[1]);
                    $("#dd_unitName").val(words[2]);
                    $("#txtPurchaseRate").val(words[3]);
                    $("#txtSellingRate").val(words[4]);
                    var d = words[5].split(" ")[0];
                    $("#txtValidFrom").val(d);
                    companyProf.config.Brandupdate = 1;

                });
                $(".dataTables_scrollBody").css('height', '100%');

            },


            DeleteItem: function (id) {
                //var id = parseInt(item.id.split("_")[1])
                //$("#" + id + "_").remove();
                var RId = id;
                companyProf.config.method = "DeleteItem";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ RId: RId });
                companyProf.config.ajaxCallMode = 5;

                companyProf.ajaxCall(companyProf.config);
            },


            
            ResetItemForm: function () {
                $('#dd_itemName').val('');
                $('#dd_unitName').val('');
                $('#txtPurchaseRate').val('');
                $('#txtSellingRate').val('');
                $('#txtValidFrom').val('');

            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        ValidFrom: {
                            required: true,
                        },

                        ItemName: {
                            required: true,
                        },

                        UnitName: {
                            required: true,
                        },

                        PurchaseRate: {
                            required: true,
                            number:true
                        },

                        SellingRate: {
                            required: true,
                            number: true
                        }


                    },
                    DonorName: {

                        required: '*'

                    },
                    Brand: {
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