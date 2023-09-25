(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROCategory/'
             }, p);
        var v = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ROCategoryWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                CategoriesId: 0,
                Categoriesupdate: 0


            },
            InitialSetup: function () {
                $('.showimage').hide();
                $("#categoriesTable").hide();
                $("#CategoriesButton").hide();
                eventFunction.GetCategories();
                eventFunction.DropdownBindMenu();
                
                $("#fileuploaderMain").uploadFile({
                    url: SageFrameHostURL + "/Modules/ROCategory/UploadHandler.ashx",
                    dragDrop: false,
                    fileName: "myfile",
                    showDelete: true,
                    showDownload: true,
                    statusBarWidth: 600,
                    maxFileCount: 1,
                    onSuccess: function (files, data, xhr) {

                        var filename = (data);
                        $("#txtFile").val(filename);
                        $("#ImgPreview").prop('src', SageFrameHostURL + '/Modules/ROCategory/images/' + data);

                        $('.showimage').show();
                        //console.log(filename);

                    },
                    deleteCallback: function (data, pd) {
                        $('.showimage').hide();

                    }
                });





            },
            init: function () {
                alert(1);

                eventFunction.InitialSetup();

                $("#AddCategories").on('click', function () {
                    $("#categoriesTable").show(1000);
                    $("#CategoriesButton").show(1000);
                    $("#AddCategories").hide(1000);

                });
                $("#btnCategoriesCancel").on('click', function () {
                    $("#categoriesTable").hide(1000);
                    $("#CategoriesButton").hide(1000);
                    $("#AddCategories").show(1000);
                    eventFunction.ResetAll();
                });
                $("#btnCategoriesSave").on('click', function () {

                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                    eventFunction.CategoriesSave();
                    eventFunction.GetCategories();
                    eventFunction.ResetAll();
                    $("#categoriesTable").hide(1000);
                    $("#CategoriesButton").hide(1000);
                    $("#AddCategories").show(1000);
                        }
                });


                $("#categoriestable").on('click', '.CategoriesEdit', function () {
                    $('.showimage').show();
                    $("#categoriesTable").show();
                    $("#CategoriesButton").show();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    eventFunction.config.CategoriesId = words[0];
                    $("#textCategoriesName").val(words[1]);
                    $("#ddlMenu").val(words[2]);
                    $("#txtFile").val(words[3]);
                    eventFunction.config.Categoriesupdate = 1;

                    $("#ImgPreview").prop('src', SageFrameHostURL + '/Modules/ROCategory/images/' + words[3]);

                });
                $("#categoriestable").on('click', '.CategoriesDelete', function () {
                    eventFunction.DeleteCategories(this);
                    eventFunction.ResetAll();
                    location.reload();
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
                        location.reload();
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
                        eventFunction.BindCategories(data);
                        break;
                    case 5:
                        eventFunction.BindDropdownItem(data);
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

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            CategoriesSave: function () {
                var CategoriesInf = {};
                CategoriesInf.CategoriesID = eventFunction.config.CategoriesId;
                CategoriesInf.CategoriesName = $('#textCategoriesName').val();
                
               // CategoriesInf.ItemID = parseInt($('#ddlItem').val());
                CategoriesInf.MenuID = parseInt($('#ddlMenu').val());
                CategoriesInf.PhotoPath = $('#txtFile').val();
                eventFunction.config.method = "CategoriesSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ CategoriesInf: CategoriesInf });

                if (eventFunction.config.Categoriesupdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.Categoriesupdate = 0;
            },
            GetCategories: function () {
                eventFunction.config.method = "GetCategoriesfromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteCategories: function (categories) {
                var id = parseInt(categories.id.split("_")[1])
                var CategoriesID = id;
                eventFunction.config.method = "CategoriesDelete";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ CategoriesID: CategoriesID });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DropdownBindMenu: function () {
                eventFunction.config.method = "getMenu";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
       

            //<<-----------------------------------BindTable Herere ------------------------------------->>>


            BindCategories: function (data) {
                $("#categoriesdata").show();
                $("#categoriesdata").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='categoriestable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Name</th><th>Menu</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    

                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableCategories' id=" + value.CategoriesID + "_>";
                        htmls += "<td>" + value.CategoriesName + "</td>";
                        htmls += "<td>" + value.MenuName + "</td>";
                        
                        htmls += "<td>" + "<img src='/images/edit.png' class='CategoriesEdit'  type='button'  id='" + value.CategoriesID + "_" + value.CategoriesName + "_" + value.MenuID + "_" + value.PhotoPath + "' value='Edit' /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='CategoriesDelete' type='button'  id=_" + value.CategoriesID + " value='Delete' /></td></tr>";
                        htmls += "</tr>"

                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#categoriesdata').html(htmls);
                    $('#categoriestable').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });

                } else {
                    $('#Categoriesdata').html('No data');
                }
                //$(".CategoriesEdit").on('click', 'CategoriesEdit', function () {
                //    $('.showimage').show();
                //    $("#categoriesTable").show();
                //    $("#CategoriesButton").show();
                //    var ids = $(this).attr('id');
                //    var words = ids.split('_');
                //    eventFunction.config.CategoriesId = words[0];
                //    $("#textCategoriesName").val(words[1]);
                //    $("#ddlMenu").val(words[2]);
                //    $("#txtFile").val(words[3]);
                //    eventFunction.config.Categoriesupdate = 1;

                //    $("#ImgPreview").prop('src', SageFrameHostURL + '/Modules/ROCategory/images/' + words[3]);

                //});
                //$(".CategoriesDelete").on('click', 'CategoriesEdit', function () {
                //    eventFunction.DeleteCategories(this);
                //    eventFunction.ResetAll();
                //});

            },

            //BindItemMenu
            BindDropdownItem: function (result) {
                var datas = result.d;
                var x = new Array();
                $("#ddlMenu").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.MenuID + "'>" + value.MenuName + "</option>";
                    });

                    $("#ddlMenu").html(htmls);
                }

            },

           
            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#textCategoriesName').val(null);
                $('#ddlMenu').val(null);
                $('#txtFile').val('');
                $('.showimage').hide();
                $('#ImgPreview').val('');

            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        textCategoriesName: {
                            required: true,
                        },

                    },
                    messages: {
                        textCategoriesName: {
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