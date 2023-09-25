
(function ($) {

    // var tabs = $("#tabs").tabs().addClass("ui-tabs-vertical ui-helper-clearfix");
    // var tabs = $("#tabs li").removeClass("ui-corner-top").addClass("ui-corner-left");

    $.companyProfcreate = function (p) {

        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ImsProject/'
             }, p);
        var v = 0;
        var companyProf = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ImsProjectService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                UnitId: 0,
                Unitupdate: 0,
                PostID: 0,
                PostidUpdate: 0,
                VendorID: 0,
                VendorIDUpdate: 0,
                ItemID: 0,
                ItemIDUpdate: 0,
                EmployeeID: 0,
                EmployeeIDUpdate: 0,
                LocationID: 0,
                LocationIDUpdate: 0,
                ProjectID: 0,
                ProjectIDUpdate: 0,
                storeItemId: 0,
                storeItemIdUpdate: 0
            },

            InitialSetup: function () {

                //StoreItem
                $("#StoreItem").hide();
                $(".StoreItemButton").hide();

                //Unite
                $('#UniteForm').hide();
                $('.LocationHideButton').hide();

                //Item
                $('#ItemTable').hide();
                $('.ItemButtonwrapper').hide();

                //Employee
                $('#EmployeeTable').hide();
                $('.EmployeeButtonwrapper').hide();

                //Location
                $('#Locationtable').hide();
                $('.LocationButtonwrapper').hide();

                //Project
                $('#ProjectTable').hide();
                $('.ProjectButtom').hide();

                //Post
                $('#PostTable').hide();
                $('.PostButton').hide();

                //Vendor
                $('#VendorTable').hide();
                $('.VendroButtonSave').hide();
                companyProf.StoreItemGet();
                companyProf.GetBrand();
                companyProf.GetLocationDropdown();
                companyProf.GetProjectDropdwon();
                companyProf.GetEmpNameDropDown();
                companyProf.GetDepartment();
                companyProf.GetItemListFromDatabs();
                companyProf.GetEmpFromDataBase();
                companyProf.GetLocationListFromDataBase();
                companyProf.GetProjectListFromDatabase();
                companyProf.GetPostFromDatabase();
                companyProf.GetUniteListFromDatabase();
                companyProf.GetVendorFromDataBase();
                companyProf.DropDownITemBind();
                companyProf.DropDownUniteBind();

                companyProf.DropDownPostToEmp();

                $("#txtStartDate").datepicker({
                    numberOfMonths: 1,
                    changeMonth: true,
                    changeYear: true,
                    onSelect: function (selected) {
                        var dt = new Date(selected);
                        dt.setDate(dt.getDate() + 1);
                        $("#txtEndDate").datepicker("option", "minDate", dt);
                    }
                });

                $("#txtEndDate").datepicker({
                    numberOfMonths: 1,
                    changeMonth: true,
                    changeYear: true,
                    onSelect: function (selected) {
                        var dt = new Date(selected);
                        dt.setDate(dt.getDate() - 1);
                        $("#txtStartDate").datepicker("option", "maxDate", dt);

                    }
                });

                $("#txtEndDate").keypress(function (event) { event.preventDefault(); });
                $("#txtStartDate").keypress(function (event) { event.preventDefault(); });
                $('#txtVoucherDate').datepicker();
                $('#assigndate').datepicker();
                $('#assigndate1').datepicker();
                $('#assigndate1').datepicker();
                $('#AmcStartDate').keypress(function (event) { event.preventDefault(); });
                $('#AmcEndDate').keypress(function (event) { event.preventDefault(); });
                $('#PurchaseDate').datepicker();

                $("#AmcStartDate").datepicker({
                    numberOfMonths: 1,
                    changeMonth: true,
                    changeYear: true,
                    onSelect: function (selected) {
                        var dt = new Date(selected); z
                        dt.setDate(dt.getDate() + 1);
                        $("#AmcEndDate").datepicker("option", "minDate", dt);
                    }
                });

                $("#AmcEndDate").datepicker({
                    numberOfMonths: 1,
                    changeMonth: true,
                    changeYear: true,
                    onSelect: function (selected) {
                        var dt = new Date(selected);
                        dt.setDate(dt.getDate() - 1);
                        $("#AmcStartDate").datepicker("option", "maxDate", dt);

                    }
                });

            },

            init: function () {
                companyProf.InitialSetup();

                //StoreItem
                $("#AddStoreItem").on('click', function (event) {
                    $("#StoreItem").show(1000);
                    $(".StoreItemButton").show(1000);
                    $("#AddStoreItem").hide(1000);
                }),
                $("#StoreItemCancel").on('click', function (event) {
                    $("#StoreItem").hide(1000);
                    $(".StoreItemButton").hide(1000)
                    $("#AddStoreItem").show(1000);
                    companyProf.ResetAllForm();
                }),
                $("#StoreItemSave").on('click', function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.StoreItemSave();
                        companyProf.StoreItemGet();
                        companyProf.ResetAllForm();
                    }
                });


                //Item
                $("#btnItemsSave").on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.ItemSave();
                        companyProf.ResetAllForm();
                        companyProf.GetItemListFromDatabs();
                    }

                });

                $("#AddItem").off().on("click", function (event) {
                    $('#ItemTable').show(1000);
                    $('.ItemButtonwrapper').show(1000);
                    $('.AddItemButton').hide(1000);
                    $('#AddItem').hide();

                });
                $("#btnItemsCancel").off().on("click", function (event) {
                    companyProf.ResetAllForm();
                    $('#ItemTable').hide(1000);
                    $('.ItemButtonwrapper').hide(1000);
                    $('.AddItemButton').show(1000);
                    $('#AddItem').show();
                });
                //ItemDetails
                var add_new_row = function (event) {
                    var me = $("tr.item-details-repeat-item").last();
                    var parent = $(".item-details-table");
                    var clone = me.clone();
                    clone.find("#btnAddItem").parent().remove();
                    parent.append(clone);

                    var add_btn = $(this);

                    parent.remove(add_btn.parent());
                    parent.find(".item-details-repeat-item").last().append(add_btn.parent());

                    var deleteButton = parent.find(".deleterow");
                    deleteButton.off().on("click", function (event) {
                        var table = ("tr.item-detaills-repeat-item").first().parent();

                        var me = $(this);
                        var count = $("tr.item-details-repeat-item").length;

                        if (count <= 1) event.preventDefault();
                        else {
                            var tr = me.parentsUntil("tr").parent();

                            var addBtnHolder = table.find("#btnAddItem").parent();

                            tr.remove();

                            addBtnHolder.find("#btnAddItem").off().on("click", add_new_row)

                            table.find("tr.item-details-repeat-item").last().append(addBtn);
                        }
                    })
                }
                $("#btnAddItem").on('click', add_new_row);
                var add_new_row = function (event) {
                    var me = $("tr.item-details-repeat-item").last();
                    var parent = $(".item-details-table");
                    var clone = me.clone();
                    clone.find("#btnAddItem1").parent().remove();
                    parent.append(clone);

                    var add_btn = $(this);

                    parent.remove(add_btn.parent());
                    parent.find(".item-details-repeat-item").last().append(add_btn.parent());

                    var deleteButton = parent.find(".deleterow");
                    deleteButton.off().on("click", function (event) {
                        var table = ("tr.item-detaills-repeat-item").first().parent();

                        var me = $(this);
                        var count = $("tr.item-details-repeat-item").length;

                        if (count <= 1) event.preventDefault();
                        else {
                            var tr = me.parentsUntil("tr").parent();

                            var addBtnHolder = table.find("#btnAddItem1").parent();

                            tr.remove();

                            addBtnHolder.find("#btnAddItem1").off().on("click", add_new_row)

                            table.find("tr.item-details-repeat-item").last().append(addBtn);
                        }
                    })
                }
                $("#btnAddItem1").on('click', add_new_row);

                //Employee
                $("#btnEmployeeSave").off().on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SaveEmployeeData();
                        companyProf.GetEmpFromDataBase();
                        companyProf.ResetAllForm();
                        companyProf.DropDownPostToEmp();

                    }
                });
                $('#AddEmployee').off().on('click', function (event) {
                    $('#EmployeeTable').show();
                    $('.EmployeeButtonwrapper').show();
                    $('#AddEmployee').hide();
                });
                $('#btnEmployeeCancel').off().on('click', function (event) {
                    companyProf.ResetAllForm();
                    $('#EmployeeTable').hide();
                    $('.EmployeeButtonwrapper').hide();
                    $('#AddEmployee').show();
                });

                //Location
                $("#btnSaveLocation").on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.LocationSave();
                        companyProf.GetLocationListFromDataBase();
                        companyProf.ResetAllForm();
                    }
                });
                $("#AddLocation").on('click', function (event) {
                    $('#Locationtable').show();
                    $('#AddLocation').hide();
                    $('.LocationButtonwrapper').show();

                });
                $("#btnCancelLocation").on('click', function (event) {
                    companyProf.ResetAllForm();
                    $('#Locationtable').hide();
                    $(".LocationButtonwrapper").hide();
                    $('#AddLocation').show();

                });

                //Project
                $('#AddProject').off().on('click', function (event) {
                    $('#ProjectTable').show();
                    $('.ProjectButtom').show();
                    $('#AddProject').hide();
                });
                $("#btnProjectName").off().on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SaveProject();
                        companyProf.ResetAllForm();
                        companyProf.GetProjectListFromDatabase();

                    }
                });
                $('#btnCancelProject').off().on('click', function (event) {
                    $('#ProjectTable').hide();
                    $('.ProjectButtom').hide();
                    $('#AddProject').show();
                    companyProf.ResetAllForm();
                });

                //Vendor
                $("#btnVendorSave").off().on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.VendorSave();
                        companyProf.GetVendorFromDataBase();
                        companyProf.ResetAllForm();
                        companyProf.ResetSaveAction();

                    }
                });
                $("#btnVendorCancel").on("click", function (event) {
                    companyProf.ResetAllForm();
                    $('#VendorTable').hide();
                    $('.VendroButtonSave').hide();
                    $('#AddVendor').show();

                });
                $("#AddVendor").on("click", function (event) {
                    $('#VendorTable').show();
                    $('.VendroButtonSave').show();
                    $('#AddVendor').hide();

                });

                //Unit
                $("#AddUnite").off().on("click", function (event) {
                    $('#UniteForm').show(1000);
                    $('.AddUniteButton').hide();
                    $('.LocationHideButton').show();
                });
                $("#btnUniteCancel").off().on("click", function (event) {
                    $('#UniteForm').hide(1000);
                    $('.AddUniteButton').show(1000);
                    $('.LocationHideButton').hide(1000);
                    $('#AddUnite').show(1000);

                });
                $("#btnUniteDesc").off().on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        $('.AddUniteButton').show();
                        $('.LocationHideButton').show();
                        $('#AddUnite').hide();
                        companyProf.UniteSave();
                        companyProf.GetUniteListFromDatabase();
                        companyProf.ResetAllForm();
                    }
                });
                //POSt
                $("#btnPostSave").off().on('click', function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SavePost();
                        companyProf.ResetAllForm();
                        companyProf.GetPostFromDatabase();
                    }
                });

                //Unit
                $('#AddPost').off().on('click', function (event) {
                    $('#PostTable').show();
                    $('.PostButton').show();
                    $('#AddPost').hide();

                });
                $('#btnCancelPost').off().on('click', function (event) {
                    $('#PostTable').hide();
                    $('.PostButton').hide();
                    $('#AddPost').show();
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
                        alert("Inserted successfully");
                        break;
                    case 2:
                        companyProf.BindIem(data);
                        break;
                    case 3:
                        alert("Updated successfully");
                        location.reload();
                        break;
                    case 4:

                        companyProf.DropDownPostToEmps(data);
                        break;
                    case 5:
                        companyProf.BindEmpTable(data);
                        break;
                    case 6:
                        companyProf.BindLocationTable(data);
                        break;
                    case 7:
                        companyProf.BindProjectTable(data);
                        break;
                    case 8:
                        companyProf.BindPostTable(data);
                        break;
                    case 9:
                        companyProf.BindUnit(data);
                        break;
                    case 10:
                        companyProf.BindVendorTable(data);
                        break;
                    case 11:
                        alert("Deleted successfully");
                        var id = companyProf.config.ID;
                        $("#" + id + "_").remove();
                        break;
                    case 12:
                        companyProf.BindDropdownItemtoDetails(data);
                        break;
                    case 13:
                        companyProf.DropDownUniteBindTabel(data);
                        break;
                    case 14:
                        companyProf.BindDeparmentDropdown(data);
                        break;
                    case 15:
                        companyProf.BindEmployeeDropdown(data);
                        break;
                    case 16:
                        companyProf.BindProjectDropDown(data);
                        break;
                    case 17:
                        companyProf.BindLocationDropdown(data);
                        break;
                    case 18:
                        companyProf.BindBrandtoItem(data);
                        break;
                    case 19:
                        companyProf.BindStoreItem(data);
                        break;
                }
            },

            ajaxFailure: function () {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 11:
                        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                        break;
                }
            },
            //StoreItem
            StoreItemSave: function () {
                var StoreInf = {};
                StoreInf.storeItemId = companyProf.config.storeItemId;
                StoreInf.itemId = parseInt($('#dropitem').val());
                StoreInf.Quantity = $('#StoreQuantity').val();
                StoreInf.IdentificationNo = $('#StoreIdentfyno').val();
                StoreInf.AMCStartDate = $('#AmcStartDate').val();
                StoreInf.AMCEndDate = $('#AmcEndDate').val();
                StoreInf.AMCAmount = parseFloat($('#AmcAmount').val());
                StoreInf.AMCFrequency = $('#AmcFrequency').val();
                StoreInf.PriorNotificationDays = $('#PriorNotifday').val();
                StoreInf.PurchasesDate = $('#PurchaseDate').val();
                StoreInf.PurchasesAmount = $('#purchaseAmount').val();
                StoreInf.Deprication_Percent = $('#DepricationPercent').val();
                StoreInf.Status = $('#txtStatus').val();

                companyProf.config.method = 'SaveStoreItem';
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ StoreInf: StoreInf });
                if (companyProf.config.storeItemIdUpdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                } else {
                    companyProf.config.ajaxCallMOde = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.storeItemIdUpdate = 0;

            },
            StoreItemGet: function () {
                companyProf.config.method = "GetStoreItem";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 19;
                companyProf.ajaxCall(companyProf.config);
            },

            //Item
            GetBrand: function () {
                companyProf.config.method = "GetBrandFromDatabase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 18;
                companyProf.ajaxCall(companyProf.config);
            },
            ItemSave: function () {
                var DepartInfo = {};
                DepartInfo.ItemID = companyProf.config.ItemID;
                DepartInfo.ItemName = $('#txtItemName').val();
                DepartInfo.ShortName = $('#txtShortName').val();
                DepartInfo.type = parseInt($('#txtType').val());
                DepartInfo.BrandID = parseInt($('#txtBrandId').val());
                DepartInfo.Remarks = $('#txtItemRemarks').val();
                DepartInfo.Depreciation = parseFloat($('#txtDepreciation').val());
                DepartInfo.SerialNo = parseInt($('#txtSerial').val());

                if (!DepartInfo.SerialNo) DepartInfo.SerialNo = 0;
                if (!DepartInfo.BrandID) DepartInfo.BrandID = 0;
                if (!DepartInfo.Depreciation) DepartInfo.Depreciation = 0.0;

                companyProf.config.method = "SaveItemToDatabase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ DepartInfo: DepartInfo });

                if (companyProf.config.ItemIDUpdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.ItemIDUpdate = 0;

            },
            GetItemListFromDatabs: function () {
                companyProf.config.method = "GetItemListFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 2;
                companyProf.ajaxCall(companyProf.config);

            },
            ItemDelete: function (item) {
                var id = parseInt(item.id.split("_")[1])

                var ItemID = id;

                companyProf.config.method = "DeleteItem";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ ItemID: ItemID });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;

                companyProf.ajaxCall(companyProf.config);
            },

            //Employee
            SaveEmployeeData: function () {
                var EmpInfo = {};
                EmpInfo.EmployeeID = companyProf.config.EmployeeID;
                EmpInfo.EmployeeFName = $('#txtEmpFn').val();
                EmpInfo.EmployeeMName = $('#txtMN').val();
                EmpInfo.EmployeeLName = $('#txtLN').val();
                EmpInfo.PostID = parseInt($('#txtPosttoEmp').val());
                EmpInfo.Address = $('#txtAddress').val();
                EmpInfo.PhoneNo = $('#txtPhone').val();
                EmpInfo.MobileNo = $('#txtMobile').val();

                companyProf.config.method = 'SaveEmployee';
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ EmpInfo: EmpInfo });
                if (companyProf.config.EmployeeIDUpdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                } else {
                    companyProf.config.ajaxCallMOde = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.EmployeeIDUpdate = 0;

            },
            GetEmpFromDataBase: function () {
                companyProf.config.method = "GetAllEmpListFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 5;
                companyProf.ajaxCall(companyProf.config);
            },
            DropDownPostToEmp: function () {
                companyProf.config.method = "DropdownForEmp";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },
            DeleteEmployee: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var EmployeeID = id;

                companyProf.config.method = "EmployeeDelete";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ EmployeeID: EmployeeID });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;
                companyProf.ajaxCall(companyProf.config);
            },

            //Location
            LocationSave: function () {
                var locinf = {};
                locinf.LocationID = companyProf.config.LocationID;
                locinf.Location = $('#txtLocationbox').val();
                companyProf.config.method = "LocationSaveToDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ locinf: locinf });
                if (companyProf.config.LocationIDUpdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.LocationIDUpdate = 0;
            },
            GetLocationListFromDataBase: function () {
                companyProf.config.method = "GetAllLocationList";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 6;
                companyProf.ajaxCall(companyProf.config);
            },
            LocationDelete: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var LocationID = id;

                companyProf.config.method = "DeleteLocation";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ LocationID: LocationID });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;

                companyProf.ajaxCall(companyProf.config);
            },

            //Porject
            SaveProject: function () {
                var projinf = {};
                projinf.ProjectID = companyProf.config.ProjectID;
                projinf.ProjectName = $('#txtProjectName').val();
                projinf.StartDate = $('#txtStartDate').val();
                projinf.EndDate = $('#txtEndDate').val();
                companyProf.config.method = "SaveProject";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ projinf: projinf });
                if (companyProf.config.ProjectIDUpdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.ProjectIDUpdate = 0;

            },
            GetProjectListFromDatabase: function () {
                companyProf.config.method = "GetProjectFromDatabase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 7;
                companyProf.ajaxCall(companyProf.config);
            },
            DeleteProject: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var ProjectID = id;
                companyProf.config.method = "DeleteProject";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ ProjectID: ProjectID });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;

                companyProf.ajaxCall(companyProf.config);
            },

            //Post
            SavePost: function () {
                var PostInfo = {};
                PostInfo.PostID = companyProf.config.PostID;
                PostInfo.Post = $('#txtPost').val();
                companyProf.config.method = "SavePostToDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ PostInfo: PostInfo });
                if (companyProf.config.PostidUpdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.PostidUpdate = 0;
            },
            GetPostFromDatabase: function () {
                companyProf.config.method = "GetPostFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 8;
                companyProf.ajaxCall(companyProf.config);
            },
            DeletePost: function (item) {
                var id = parseInt(item.id.split("_")[1])

                var PostID = id;
                companyProf.config.method = "DeletePost";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ PostID: PostID });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;
                companyProf.ajaxCall(companyProf.config);
            },

            //Unit
            UniteSave: function () {
                var UniteInf = {};
                UniteInf.UnitID = companyProf.config.UnitId;
                UniteInf.UnitDesc = $('#txtUniteDesc').val();
                companyProf.config.method = "SaveUnite";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ UniteInf: UniteInf });
                if (companyProf.config.Unitupdate == 1) {
                    companyProf.config.ajaxCallMode = 3;
                    companyProf.ResetAllForm();
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }

                companyProf.ajaxCall(companyProf.config);
                companyProf.config.Unitupdate = 0;
            },
            GetUniteListFromDatabase: function () {
                companyProf.config.method = "GetUniteData";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 9;
                companyProf.ajaxCall(companyProf.config);
            },
            DeleteUnit: function (item) {
                var id = parseInt(item.id.split("_")[1])
                // $("#" + id + "_").remove();
                var UnitID = id;
                companyProf.config.method = "UnitDelete";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ UnitID: UnitID });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;

                companyProf.ajaxCall(companyProf.config);
            },

            DeleteStore: function (item) {
                var id = parseInt(item.id.split("_")[1])
                //$("#" + id + "_").remove();
                var storeitemid = id;
                companyProf.config.method = "StoreItemDelete";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ storeitemid: storeitemid });
                companyProf.config.ajaxCallMode = 11;
                companyProf.config.ID = id;

                companyProf.ajaxCall(companyProf.config);
            },

            //Vendor
            VendorSave: function () {
                var VendorInf = {};
                VendorInf.VendorID = companyProf.config.VendorID;
                VendorInf.VendorFName = $('#txtVendorFName').val();
                VendorInf.VendorMName = $('#txtVendorMName').val();
                VendorInf.VendorLName = $('#txtVendorLName').val();
                VendorInf.Address = $('#txtVendorAddress').val();
                VendorInf.PhoneNO = $('#txtVendorPhone').val();
                VendorInf.MobileNo = $('#txtVendorMobNO').val()

                companyProf.config.method = "SaveVendor";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ VendorInf: VendorInf });

                if (companyProf.config.VendorIDUpdate != 1) {
                    companyProf.config.ajaxCallMode = 1;
                }
                else {
                    companyProf.config.ajaxCallMode = 3;
                }
                companyProf.ajaxCall(companyProf.config);

                companyProf.config.VendorIDUpdate = 0;
            },
            GetVendorFromDataBase: function () {
                companyProf.config.method = "GetVendorFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 10;
                companyProf.ajaxCall(companyProf.config);
            },
            DeleteVendor: function (item) {
                var id = parseInt(item.id.split("_")[1])

                var VendorID = id;
                companyProf.config.method = "DeleteVendor";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ VendorID: VendorID });
                companyProf.config.ajaxCallMode = 11;

                companyProf.ajaxCall(companyProf.config);
            },


            //itemassignmaster
            SaveItemAssign: function () {
                var itemAssign = {};
                itemAssign.DepartmentID = parseInt($('#txtDepartment').val());
                itemAssign.EmployeeID = parseInt($('#txtEmployee').val());
                itemAssign.ProjectID = parseInt($('#txtProject').val());
                itemAssign.assigndate = $('#assigndate').val();
                itemAssign.LocationID = parseInt($('#txtLocation').val());

                var itemAssigndetails = [];
                var form = document.forms['form1'];
                var listIem = form['ItemName[]'];
                var listUnit = form['UnitName[]'];
                var listidntf = form['Identityfication[]']
                var listQts = form['Quantity[]']
                for (var i = 0; i < listUnit.length; i++) {
                    itemAssigndetails.push({
                        "ItemName": listIem.item(i).value,
                        "UnitName": listUnit.item(i).value,
                        "Identityfication": listidntf.item(i).value,
                        "Quantity": listQts.item(i).value
                    })
                };
                itemAssign.itemAssigndetails = itemAssigndetails;

                companyProf.config.method = "postAssignItem";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ itemAssign: itemAssign });
                companyProf.config.ajaxCallMode = 1;
                companyProf.ajaxCall(companyProf.config);
            },

            DropDownITemBind: function () {
                companyProf.config.method = "GetDatatobind";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 12;
                companyProf.ajaxCall(companyProf.config);
            },
            DropDownUniteBind: function () {
                companyProf.config.method = "GetUniteData";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 13;
                companyProf.ajaxCall(companyProf.config);
            },

            //ItemDetailsMaster
            SaveItemDetailsMaster: function () {
                var ItmDetailsInf = {};
                ItmDetailsInf.ItemID = parseInt($('#txtDepartment').val());
                ItmDetailsInf.UnitID = parseInt($('#txtEmployee').val());
                ItmDetailsInf.type = parseInt($('#txtProject').val());
                ItmDetailsInf.type = parseInt($('#txtLocation').val());

                companyProf.config.method = "SaveItemDetailsMaster";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ ItmDetailsInf: ItmDetailsInf });
                companyProf.config.ajaxCallMode = 1;
                companyProf.ajaxCall(companyProf.config);
            },
            GetEmpNameDropDown: function () {
                companyProf.config.method = "GetAllEmpListFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 15;
                companyProf.ajaxCall(companyProf.config);
            },
            GetDepartment: function () {
                companyProf.config.method = "GetDepartmentFromDatabase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 14;
                companyProf.ajaxCall(companyProf.config);
            },
            GetProjectDropdwon: function () {
                companyProf.config.method = "GetProjectFromDatabase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 16;
                companyProf.ajaxCall(companyProf.config);
            },
            GetLocationDropdown: function () {
                companyProf.config.method = "GetAllLocationList";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 17;
                companyProf.ajaxCall(companyProf.config);
            },


            //<-----------------------------------------BindTable here--------------------------->
            //BindStoreITem

            BindStoreItem: function (data) {
                $("#ShortableStoreItem").show();
                $("#ShortableStoreItem").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='hamrotable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Item Name </th><th> Quantity </th><th>IdentificationNo</th><th>Purchase Amount </th><th>PurchaseDate </th><th>Status </th> <th class='edit-heading'> Edit </th><th class='delete-heading'> Delete </th>"
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.storeItemId + "_>";
                        htmls += "<td>" + value.ItemID + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.IdentificationNo + "</td>";
                        htmls += "<td>" + value.PurchasesAmount + "</td>";
                        htmls += "<td>" + value.PurchasesDate + "</td>";
                        htmls += "<td>" + value.Status + "</td>";

                        htmls += "<td>" + "<img src='/images/edit.png' class='StoreITemEdit' type='button'  id='" + value.storeItemId + "_" + value.ItemID + "_" + value.Quantity + "_" + value.IdentificationNo + "_" + value.AMCStartDate + "_" + value.AMCEndDate + "_" + value.AMCAmount + "_" + value.AMCFrequency + "_" + value.PriorNotificationDays + "_" + value.PurchasesDate + "_" + value.PurchasesAmount + "_" + value.Deprication_Percent + "_" + value.Status + " ' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='StoreITemDelete' type='button'  id=_" + value.storeItemId + " value='Delete' /></td>";
                        htmls += "</tr>"


                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#ShortableStoreItem').html(htmls);
                    $('#hamrotable').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });

                } else {
                    $('#ShortableStoreItem').html('No data');

                }

                $(".StoreITemEdit").on('click', function (event) {
                    $("#StoreItem").show();
                    $(".StoreItemButton").show()
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.storeItemId = words[0];
                    $("#dropitem").val(words[1]);
                    $("#StoreQuantity").val(words[2]);
                    $("#StoreIdentfyno").val(words[3]);
                    $("#AmcStartDate").val(words[4]);
                    $("#AmcEndDate").val(words[5]);
                    $("#AmcAmount").val(words[6]);
                    $("#AmcFrequency").val(words[7]);
                    $("#PriorNotifday").val(words[8]);
                    $("#PurchaseDate").val(words[9]);
                    $("#purchaseAmount").val(words[10]);
                    $("#DepricationPercent").val(words[11]);
                    $("#txtStatus").val(words[12]);

                    companyProf.config.storeItemIdUpdate = 1;
                });
                $(".StoreITemDelete").on("click", function (event) {
                    companyProf.DeleteStore(this);
                    companyProf.StoreItemGet();
                    // companyProf.GetVendorFromDataBase();
                    companyProf.ResetAllForm();

                });

            },
            //BindItem

            BindBrandtoItem: function (result) {
                var datas = result.d;
                $("#txtBrandId").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";

                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.BrandID + "'>" + value.Brand + "</option>";
                    });

                    $("#txtBrandId").html(htmls);
                }
            },
            BindIem: function (data) {
                $("#sortableComList").show();
                $("#sortableComList").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='hamrotablea' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Item Name </th><th> Short Name </th><th>Type</th><th>Brand </th><th>Remarks</th><th>Depreciation</th><th>Serial Number </th> <th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.ItemID + "_>";
                        htmls += "<td>" + value.ItemName + "</td>";
                        htmls += "<td>" + value.ShortName + "</td>";
                        htmls += "<td>" + value.type + "</td>";
                        htmls += "<td>" + value.BrandID + "</td>";
                        htmls += "<td>" + value.Remarks + "</td>";
                        htmls += "<td>" + value.Depreciation + "</td>";
                        htmls += "<td>" + value.SerialNo + "</td>";

                        htmls += "<td><img src='/images/edit.png' class='ItemEdit' id='" + value.ItemID + "_" + value.ItemName + "_" + value.ShortName + "_" + value.type + "_" + value.BrandID + "_" + value.Remarks + "_" + value.Depreciation + "_" + value.SerialNo + "' value='Edit'/></td>";
                        htmls += "<td><img src='/images/delete.png' class='ItemDelete' type='button'  id=_" + value.ItemID + " value='Delete'  /></td>";
                        htmls += "</tr>"

                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#sortableComList').html(htmls);
                    $('#hamrotablea').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });

                } else {
                    $('#sortableComList').html('No data');

                }
                (function () {
                    $(".ItemEdit").off().on("click", function (event) {
                        $('#ItemTable').show();
                        $('.ItemButtonwrapper').show();
                        $('.AddItemButton').hide();
                        var ids = $(this).attr('id');
                        var words = ids.split('_');
                        companyProf.config.ItemID = words[0];
                        $("#txtItemName").val(words[1]);
                        $("#txtShortName").val(words[2]);
                        $("#txtType").val(words[3]);
                        $("#txtBrandId").val(words[4]);
                        $("#txtItemRemarks").val(words[5]);
                        $("#txtDepreciation").val(words[6]);
                        $("#txtSerial").val(words[6]);
                        companyProf.config.ItemIDUpdate = 1;

                    });

                    $(".ItemDelete").on('click', function (event) {
                        companyProf.ItemDelete(this);
                    });
                })();
            },
          

            //BindEmployee
            BindEmpTable: function (result) {
                $("#sortableEmpList").show();
                $("#sortableEmpList").html('');
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = "<table class='sfGridwrapper'>";
                    htmls += "<th>First Name </th><th> Middle Names </th><th>Last Name</th><th>Post ID </th><th>Address</th><th>Phone</th><th>Mobile </th> <th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr class=tableItem id=" + value.EmployeeID + "_>";
                        htmls += "<td>" + value.EmployeeFName + "</td>";
                        htmls += "<td>" + value.EmployeeMName + "</td>";
                        htmls += "<td>" + value.EmployeeLName + "</td>";
                        htmls += "<td>" + value.PostID + "</td>";
                        htmls += "<td>" + value.Address + "</td>";
                        htmls += "<td>" + value.PhoneNo + "</td>";
                        htmls += "<td>" + value.MobileNo + "</td>";

                        htmls += "<td>" + "<img src='/images/edit.png' class='EmpEdit' id='" + value.EmployeeID + "_" + value.EmployeeFName + "_" + value.EmployeeMName + "_" + value.EmployeeLName + "_" + value.PostID + "_" + value.Address + "_" + value.PhoneNo + "_" + value.MobileNo + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='EmpDelete' type='button'  id=_" + value.EmployeeID + " value='Delete' /></td>";

                    });
                    htmls += "</table>";
                    $('#sortableEmpList').html(htmls);
                } else {
                    $('#sortableEmpList').html('No data');
                }
                $('.EmpEdit').off().on('click', function (event) {
                    $('#EmployeeTable').show();
                    $('.EmployeeButtonwrapper').show();
                    $('#AddEmployee').hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.EmployeeID = words[0];
                    $("#txtEmpFn").val(words[1]);
                    $("#txtMN").val(words[2]);
                    $("#txtLN").val(words[3]);
                    $("#txtPosttoEmp").val(words[4]);
                    $("#txtAddress").val(words[5]);
                    $("#txtPhone").val(words[6]);
                    $("#txtMobile").val(words[6]);
                    companyProf.config.EmployeeIDUpdate = 1;
                });
                $('.EmpDelete').off().on('click', function (event) {
                    companyProf.DeleteEmployee(this);
                    companyProf.DropDownPostToEmp();
                    companyProf.ResetAllForm();
                });
            },
            DropDownPostToEmps: function (result) {
                //if (!result.data) return;
                if (!result.d) return;
                var datas = result.d;
                $("#txtPosttoEmp").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.PostID + "'>" + value.Post + "</option>";
                    });

                    $("#txtPosttoEmp").html(htmls);
                }

            },


            //BindLocation
            BindLocationTable: function (result) {
                $("#sortableLocationList").show();
                $("#sortableLocationList").html();
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = "<table class='sfGridwrapper'>";
                    htmls += "<th> Location </th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr class=tableItem id=" + value.LocationID + "_>";
                        htmls += "<td>" + value.Location + "</td>";
                        //htmls += "<td><img src='/images/edit.png' class='LocationEdit' id='" + value.LocationID + "_" + value.Location + "' value='Edit'  /><span class='actionbuttonicon'><img src='/images/delete.png' class='LocationDelete' type='button'  id=_" + value.LocationID + " value='Delete'  /></span></td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='LocationEdit' type='button'  id='" + value.LocationID + "_" + value.Location + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='LocationDelete' type='button'  id=_" + value.LocationID + " value='Delete' /></td>";

                    });
                    htmls += "</table>";
                    $('#sortableLocationList').html(htmls);
                } else {
                    $('#sortableLocationList').html('No data');
                }
                $(".LocationEdit").off().on("click", function (event) {
                    $('#Locationtable').show();
                    $('#AddLocation').hide();
                    $('.LocationButtonwrapper').show();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.LocationID = words[0];
                    $("#txtLocationbox").val(words[1]);
                    companyProf.config.LocationIDUpdate = 1;
                });
                $(".LocationDelete").off().on("click", function (event) {
                    companyProf.LocationDelete(this);
                });
            },

            //BindProj
            BindProjectTable: function (result) {
                $("#ShortableProject").show();
                $("#ShortableProject").html();
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = "<table class='sfNotfound'>";
                    htmls += "<th>Project</th><th> Start Date </th><th>End Date</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    //  htmls += "<th>Project</th><th> Start Date </th><th>End Date</th><th>Edit</th><th>Delete</th>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr class=tableItem id=" + value.ProjectID + "_>";
                        htmls += "<td>" + value.ProjectName + "</td>";
                        htmls += "<td>" + value.StartDate + "</td>";
                        htmls += "<td>" + value.EndDate + "</td>";
                        //htmls += "<td><img src='/images/edit.png' class='ProjectEdit' id='" + value.ProjectID + "_" + value.ProjectName + "_" + value.StartDate + "_" + value.EndDate + "' value='Edit'  /><span class='actionbuttonicon'><img src='/images/delete.png' class='ProjectDelete' type='button'  id=_" + value.ProjectID + " value='Delete'  /></span></td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='ProjectEdit' type='button'  id='" + value.ProjectID + "_" + value.ProjectName + "_" + value.StartDate + "_" + value.EndDate + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='ProjectDelete' type='button'  id=_" + value.ProjectID + " value='Delete' /></td>";

                    });
                    htmls += "</table>";
                    $('#ShortableProject').html(htmls);
                } else {
                    $('#ShortableProject').html('No data');
                }
                $('.ProjectEdit').off().on('click', function (event) {
                    $('#ProjectTable').show();
                    $('.ProjectButtom').show();
                    $('#AddProject').hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.ProjectID = words[0];
                    $("#txtProjectName").val(words[1]);
                    $("#txtStartDate").val(words[2]);
                    $("#txtEndDate").val(words[3]);
                    companyProf.config.ProjectIDUpdate = 1;
                });
                $('.ProjectDelete').off().on('click', function (event) {
                    companyProf.DeleteProject(this);
                });

            },

            //BindPost
            BindPostTable: function (result) {
                $("#ShortablePOst").show();
                $("#ShortablePOst").html();
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = "<table class='sfGridwrapper'>";
                    htmls += "<th> Post </th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    // htmls += "<th>POST </th><th> Edit </th><th>Delete </th>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr class=tableItem id=" + value.PostID + "_>";
                        htmls += "<td>" + value.Post + "</td>";
                        //htmls += "<td><img src='/images/edit.png' class='PostEdit' id='" + value.PostID + "_" + value.Post + "' value='Edit'  /><span class='actionbuttonicon'><img src='/images/delete.png' class='PostDelete' type='button'  id=_" + value.PostID + " value='Delete'  /></span></td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='PostEdit' type='button'  id='" + value.PostID + "_" + value.Post + "'value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='PostDelete' type='button'  id=_" + value.PostID + " value='Delete' /></td>";

                    });
                    htmls += "</table>";
                    $('#ShortablePOst').html(htmls);
                } else {
                    $('#ShortablePOst').html('No data');
                }
                $(".PostEdit").off().on("click", function (event) {
                    $('#PostTable').show();
                    $('.PostButton').show();
                    $('#AddPost').hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.PostID = words[0];
                    $("#txtPost").val(words[1]);
                    companyProf.config.PostidUpdate = 1;
                });

                $(".PostDelete").on('click', function (event) {
                    companyProf.DeletePost(this);
                    companyProf.ResetAllForm();
                });
            },

            //BindUnit

            //BindUnitTable: function (result) {
            //    $("#ShortableUnitLIst").show();
            //    $("#ShortableUnitLIst").html('');
            //    var datas = result.d;
            //    if (datas.length > 0) {
            //        var htmls = "<table class='sfGridwrapper'>";
            //        htmls += "<th> Unit </th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
            //        // htmls += "<th> Unit </th><th>Edit</th> <th>Delete</th>";
            //        $.each(datas, function (index, value) {
            //            htmls += "<tr class=tableItem id=" + value.UnitID + "_>";
            //            htmls += "<td>" + value.UnitDesc + "</td>";
            //            //htmls += "<td><img src='/images/edit.png' class='UnitEdit' id='" + value.UnitID + "_" + value.UnitDesc + "' value='Edit'  /><span class='actionbuttonicon'><img src='/images/delete.png' class='UnitDelete' type='button'  id=_" + value.UnitID + " value='Delete'  /></span></td>";
            //            htmls += "<td>" + "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.UnitID + "_" + value.UnitDesc + "' value='Edit' /></td>";
            //            htmls += "<td>" + "<img src='/images/delete.png' class='UnitDelete' type='button'  id=_" + value.UnitID + " value='Delete' /></td></tr>";
            //        });
            //        htmls += "</table>";
            //        $('#ShortableUnitLIst').html(htmls);

            //    } else {
            //        $('#ShortableUnitLIst').html('No data');
            //    }
            //    $(".UnitEdit").off().on('click', function (event) {
            //        $('#UniteForm').show();
            //        $('.LocationHideButton').show();
            //        $('#AddUnite').hide();
            //        var ids = $(this).attr('id');
            //        var words = ids.split('_');
            //        companyProf.config.UnitId = words[0];
            //        $("#txtUniteDesc").val(words[1]);
            //        companyProf.config.Unitupdate = 1;

            //    });
            //    $(".UnitDelete").off().on('click', function (event) {
            //        companyProf.DeleteUnit(this);
            //    });

            //},

            BindUnit: function (data) {
                $("#ShortableUnitLIst").show();
                $("#ShortableUnitLIst").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='UnitTable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Unit </th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.UnitID + "_>";
                        htmls += "<td>" + value.UnitDesc + "</td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.UnitID + "_" + value.UnitDesc + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='UnitDelete' type='button'  id=_" + value.UnitID + " value='Delete' /></td></tr>";
                        htmls += "</tr>"

                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#ShortableUnitLIst').html(htmls);
                    $('#UnitTable').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });

                } else {
                    $('#ShortableUnitLIst').html('No data');

                }
                (function () {
                    $(".ItemEdit").off().on("click", function (event) {
                        $('#ItemTable').show();
                        $('.ItemButtonwrapper').show();
                        $('.AddItemButton').hide();
                        var ids = $(this).attr('id');
                        var words = ids.split('_');
                        companyProf.config.ItemID = words[0];
                        $("#txtItemName").val(words[1]);
                        $("#txtShortName").val(words[2]);
                        $("#txtType").val(words[3]);
                        $("#txtBrandId").val(words[4]);
                        $("#txtItemRemarks").val(words[5]);
                        $("#txtDepreciation").val(words[6]);
                        $("#txtSerial").val(words[6]);
                        companyProf.config.ItemIDUpdate = 1;

                    });

                    $(".ItemDelete").on('click', function (event) {
                        companyProf.ItemDelete(this);
                    });
                })();
            },

            //BindVendor
            BindVendorTable: function (result) {
                $("#ShortableVendorList").show();
                $("#ShortableVendorList").html('');
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = "<table class='sfGridwrapper'>";
                    htmls += "<th>First Name </th><th>Middle Name </th><th>Last Name</th><th>Address</th><th>Phone</th><th>Mobile<th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    // htmls += "<th>First Name </th><th>Middle Names </th><th>Last Name</th><th>ADDRESS</th><th>Phone</th><th>MObile<th>Edit</th><th>Delete</th>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr class=tableItem id=" + value.VendorID + "_>";
                        htmls += "<td>" + value.VendorFName + "</td>";
                        htmls += "<td>" + value.VendorMName + "</td>";
                        htmls += "<td>" + value.VendorLName + "</td>";
                        htmls += "<td>" + value.Address + "</td>";
                        htmls += "<td>" + value.PhoneNo + "</td>";
                        htmls += "<td>" + value.MobileNo + "</td>";
                        //htmls += "<td><img src='/images/edit.png' class='VendorEdit' id='" + value.VendorID + "_" + value.VendorFName + "_" + value.VendorMName + "_" + value.VendorLName + "_" + value.Address + "_" + value.PhoneNo + "_" + value.MobileNo + "' value='Edit'  /><span class='actionbuttonicon'><img src='/images/delete.png' class='VendorDelete' type='button'  id=_" + value.VendorID + " value='Delete'  /></span></td>";
                        htmls += "<td>" + "<img src='/images/edit.png' class='VendorEdit' type='button'  id='" + value.VendorID + "_" + value.VendorFName + "_" + value.VendorMName + "_" + value.VendorLName + "_" + value.Address + "_" + value.PhoneNo + "_" + value.MobileNo + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='VendorDelete' type='button'  id=_" + value.VendorID + " value='Delete' /></td>";
                    });
                    htmls += "</table>";
                    $('#ShortableVendorList').html(htmls);
                } else {
                    $('#ShortableVendorList').html('No data');
                }
                $(".VendorEdit").on("click", function (event) {
                    $('#VendorTable').show();
                    $('.VendroButtonSave').show();
                    $('#AddVendor').hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    companyProf.config.VendorID = words[0];
                    $("#txtVendorFName").val(words[1]);
                    $("#txtVendorMName").val(words[2]);
                    $("#txtVendorLName").val(words[3]);
                    $("#txtVendorAddress").val(words[4]);
                    $("#txtVendorPhone").val(words[5]);
                    $("#txtVendorMobNO").val(words[6]);
                    companyProf.config.VendorIDUpdate = 1;

                });
                $(".VendorDelete").on("click", function (event) {
                    companyProf.DeleteVendor(this);
                    companyProf.GetVendorFromDataBase();
                    companyProf.ResetAllForm();

                });
            },

            //BindItemDetails
            BindDropdownItemtoDetails: function (result) {
                var datas = result.d;
                $(".EmpItemName").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ItemID + "'>" + value.ItemName + "</option>";
                    });

                    $(".EmpItemName").html(htmls);
                }

            },
            DropDownUniteBindTabel: function (result) {
                var datas = result.d;
                $(".EmpUnite").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {

                        htmls += "<option value='" + value.UnitID + "'>" + value.UnitDesc + "</option>";
                    });

                    $(".EmpUnite").html(htmls);
                }
            },

            //ItemDetailsMaster
            BindDeparmentDropdown: function (result) {
                var datas = result.d;
                $(".txtDepartment").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.DepartmentID + "'>" + value.Department + "</option>";
                    });

                    $(".txtDepartment").html(htmls);
                }
            },
            BindEmployeeDropdown: function (result) {
                var datas = result.d;
                $(".txtEmployee").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.EmployeeID + "'>" + value.EmployeeFName + "</option>";
                    });

                    $(".txtEmployee").html(htmls);
                }
            },
            BindProjectDropDown: function (result) {
                var datas = result.d;
                $(".txtProject").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.ProjectID + "'>" + value.ProjectName + "</option>";
                    });
                    $(".txtProject").html(htmls);
                }
            },
            BindLocationDropdown: function (result) {
                var datas = result.d;
                $(".txtLocation").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {

                        htmls += "<option value='" + value.LocationID + "'>" + value.Location + "</option>";
                    });

                    $(".txtLocation").html(htmls);
                }
            },

            ResetAllForm: function () {
                //Item
                $('#txtItemName').val('');
                $('#txtShortName').val('');
                $('#txtType').val('');
                $('#txtBrandId').val('');
                $('#txtItemRemarks').val('');
                $('#txtDepreciation').val('');
                $('#txtSerial').val('');

                //Employee
                $('#txtEmpFn').val('');
                $('#txtMN').val('');
                $('#txtLN').val('');
                $('#txtPosttoEmp').val('');
                $('#txtAddress').val('');
                $('#txtPhone').val('');
                $('#txtMobile').val('');
                //Locatoin
                $('#txtLocationbox').val('');
                //Project
                $('#txtProjectName').val('');
                $('#txtStartDate').val('');
                $('#txtEndDate').val('');

                //Post
                $('#txtPost').val('');
                //Unit
                $('#txtUniteDesc').val('');
                //Vendor
                $('#txtVendorFName').val('');
                $('#txtVendorMName').val('');
                $('#txtVendorLName').val('');
                $('#txtVendorAddress').val('');
                $('#txtVendorPhone').val('');
                $('#txtVendorMobNO').val('');

                //StoreItem
                $('#dropitem').val('');
                $('#StoreQuantity').val('');
                $('#StoreIdentfyno').val('');

                $('#AmcStartDate').val('');
                $('#AmcEndDate').val('');

                $('#AmcAmount').val('');
                $('#AmcFrequency').val('');
                $('#PriorNotifday').val('');

                $('#PurchaseDate').val('');
                $('#purchaseAmount').val('');
                $('#txtStatus').val('');
                $('#DepricationPercent').val('');

            },


            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        dropitem: {
                            required: true,
                        },
                        StoreQuantity: {
                            required: true,
                            number: true,
                        },
                        StoreIdentfyno: {
                            required: true,
                        },
                        AmcStartDate: {
                            required: true,
                        },
                        AmcEndDate: {
                            requird: true,
                        },
                        AmcAmount: {
                            requird: true,
                            number: true,
                        },
                        AmcFrequency: {
                            required: true,
                            number: true,
                        },
                        PriorNotifday: {
                            required: true,
                            number: true,
                        },
                        PurchaseDate: {
                            requird: true,
                        },
                        purchaseAmount: {
                            requird: true,
                            number: true,
                        },
                        DepricationPercent: {
                            requird: true,
                            number: true,
                        },
                        txtStatus: {
                            requird: true,
                        },

                        //Item Validation
                        ItemNames: {
                            required: true,
                        },
                        ShortName: {
                            required: true,

                        },
                        ItemType: {
                            number: true,
                        },
                        BrandID: {
                            required: true,
                        },

                        SelectItemNameDropDown: {
                            required: false,
                        },
                        SerialNumber: {
                            required: false,
                            number: true,
                        },
                        Depreciation: {
                            required: false,
                            number: true,
                        },
                        ItemRemarks: {
                            required: false,
                        },
                        //EmpValidation
                        FormEmpFirstName: {
                            required: true,

                        },
                        FormEmpMiddleName: {
                            required: false,
                        },
                        FOrmEmpLastName: {
                            required: true,
                        },

                        FormEmpAddress: {
                            required: true,
                        },
                        FormEmpPhone: {
                            number: true,
                            minlength: 9,
                            maxlength: 10,
                        },
                        FormEmpNumber: {
                            phone: true,

                        },
                        //Location
                        Location: {
                            required: true,
                        },
                        //Project
                        ProjectName: {
                            required: true,
                        },
                        StartDate: {
                            required: true,
                        },

                        EndDate: {
                            required: true,
                        },
                        //Post
                        Post: {
                            required: true,
                        },
                        //UnitValidation
                        UnitDesc: {
                            required: true,
                        },
                        //VendroValidation
                        VendorFirstName: {
                            required: true,
                        },
                        VendorMiddleName: {
                            required: false,
                        },
                        VendorLasteName: {
                            required: true,
                        },
                        VendorAddress: {
                            required: true,
                        },
                        VendorPhone: {
                            number: true,
                            minlength: 9,
                            maxlength: 10,
                        },
                        VendorMobile: {
                            number: true,
                            minlength: 10
                        }

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

        companyProf.init();
    };

    $.fn.companyProfEDIT = function (p) {

        $.companyProfcreate(p);
    };
})(jQuery);
