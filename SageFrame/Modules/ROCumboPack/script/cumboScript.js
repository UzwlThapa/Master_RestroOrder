function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}
function IntDec(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}

(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROCumboPack/service/'
             }, p);
        var v = 0;
        var count = 1;
        var totalPoints = 0;
        var items = [];
        var countsarray = [];
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "CumboWebervice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ComboIDUpdate: 0,
                ComboID: 0,

            },
            InitialSetup: function () {
                $('.showimage').hide();
                $("#itemTable").hide();
                $("#ItemButton").hide();
                
                eventFunction.getcumboiterm();
                eventFunction.getInactiveComboList();
                eventFunction.InactiveCombo();
                eventFunction.GetCostCenter();
                eventFunction.GetItem();
                eventFunction.getUpcomingcumbolist();
                eventFunction.getCancelledcumbolist();

                $("#btnShowForm").click(function () {
                    $("#btnShowForm").hide();
                    $("#comboListing").hide();
                    $("#roiitemtable").show();
                    $(".tabsForlist").hide();
                   
                    
                });

                $("#fileImage").change(function () {
                    var path = $('input[type=file]').val();
                    var filename = path.replace(/^.*\\/, "");
                    $("#txtImage").val(filename);
                    // $("#txtImage").val("~/Modules/ROI_Item/ImageItem/" + $('input[type=file]').val());
                    // alert($("#txtImage").val());

                    eventFunction.readURL(this);
                });


                $("#fileuploaderMain").uploadFile({
                    url: SageFrameHostURL + "/Modules/ROCumboPack/UploadHandler.ashx",
                    dragDrop: false,
                    fileName: "myfile",
                    showDelete: true,
                    showDownload: true,
                    statusBarWidth: 600,
                    maxFileCount: 10,
                    onSuccess: function (files, data, xhr) {
                        var filename = (data);
                        $("#txtFile").val(filename);
                        $("#ImgPreview").prop('src', SageFrameHostURL + '/Modules/ROCumboPack/images/' + data);

                        $('.showimage').show();
                        //console.log(filename);
                    },
                    deleteCallback: function (data, pd) {
                        $('.showimage').hide();

                    }
                });


            },

            BindCostCenter: function (result) {
                datas = JSON.parse(result);
                $("#SelCostCenter").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.CostCenterId + "'>" + value.CostCenterName + "</option>";
                    });
                    $("#SelCostCenter").html(htmls);
                }
            },
            GetCostCenter: function () {
                eventFunction.config.method = "GetCostCenter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },
            init: function () {
                
                eventFunction.InitialSetup();
                jQuery("#startDate").datepicker({
                    dateFormat: 'yy/mm/dd',
                    changeMonth: true,
                    changeYear: true,
                    minDate: '0',
                    onClose: function (selectedDate) {
                        jQuery("#endate").datepicker("option", "minDate", selectedDate);
                        $("#endate").val($("#startDate").val());
                    }
                }).datepicker("setDate", new Date());

              

                $("#endate").datepicker({
                    dateFormat: "yy/mm/dd",
                    changeMonth: true,
                    changeYear: true,
                }).datepicker("setDate", "+3");

                $("#btnSave").on("click", function () {

                    var value = $('.Quantity').filter(function () {
                        return $(this).val() == '';
                    });
                  
                    var rate = $('.Rate').filter(function () {
                        return $(this).val() == '';
                    });

                    if (value.length > 0) {
                        jAlert("Please! Fill all the Item field.", 'Alert!!');
                    }
    
                    else if (rate.length > 0) {
                        jAlert("Please! Fill all the Rate field.", 'Alert!!');
                    }

                    else if ($("#ItemsSalesCost").val() == "NaN") {
                        jAlert('Item Cost is Invalid', 'Information!!', function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        var checkValid = eventFunction.ValidationForm();
                        if (checkValid) {
                            eventFunction.uploadImage();
                            eventFunction.SaveCumbo();
                            
                        }
                    }

                });


                $("#btnCancel").on("click", function () {
                    
                  eventFunction.Reset();
                });

                $("#cumbotable").on("click", "#btnAdd", function () {
                    var isvalid = eventFunction.validedform($(this).parents("tr"));
                    if (isvalid) {
                        $(this).parents("td").remove("input");
                        $(this).parents("td").html("<input type='button' value='Remove' class='sfBtn RemoveItem'/>");
                        var htmls = eventFunction.CreateHtmlForItem();
                        count++;
                        $("#cumbotable tbody").append(htmls);
                        $(".autopickitem").autocomplete({
                            source: items,
                            focus: function (event, ui) {
                                // prevent autocomplete from updating the textbox
                                event.preventDefault();
                                // manually update the textbox
                               // $(this).val(ui.item.label);
                                $(this).parents("tr").find('#autopickid').val(ui.item.label);
                            },
                            select: function (event, ui) {
                                // prevent autocomplete from updating the textbox
                                event.preventDefault();
                                // manually update the textbox and hidden field
                               // $(this).val(ui.item.label);
                                $(this).parents("tr").find('#autopickid').val(ui.item.label);
                                $(this).parents("tr").attr('data-id', ui.item.value);
                                $(this).parents("tr").find('.Rate').val(ui.item.rate);
                            }
                        });
                    }
                });
                $("#cumbotable").on("click", ".RemoveItem", function () {
                    $(this).parents("tr").remove();
                    totalPoints = 0;
                    $(".TotalPrice").each(function () {
                        totalPoints += parseFloat($(this).val());
                    });
                    $("#ItemsSalesCost").val(totalPoints);
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
                    eventFunction.ItemSave();
                    eventFunction.GetItem();
                    eventFunction.ResetAll();
                    $("#itemTable").hide(1000);
                    $("#ItemButton").hide(1000);
                    $("#AddItem").show(1000);
                    $('.showimage').hide();
                });

                $("#cumbotable").on('change', '.Quantity', function () {

                    var rate = parseFloat($(this).parents("tr").find(".Rate").val());
                    var qty = parseFloat($(this).parents("tr").find('.Quantity').val());
                    var resutl = rate * qty;
                    $(this).parents("tr").find('.TotalPrice').val(resutl);
                    totalPoints = 0;
                    $(".TotalPrice").each(function () {
                        totalPoints += parseFloat($(this).val());
                    });
                    $("#ItemsSalesCost").val(totalPoints.toFixed(2));

                });


                $("#itemtable").on('click', '.ItemEdit', function () {
                    $('.showimage').show();
                    $("#itemTable").show();
                    $("#ItemButton").show();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    eventFunction.config.NewItemID = words[0];
                    $("#textItemName").val(words[1]);
                    $("#textItemDescription").val(words[2]);
                    $("#txtFile").val(words[3]);
                    $("#textItemPrice").val(words[4]);
                    $("#textItemCode").val(words[5]);
                    $("#ddlUnit").val(words[6]);
                    $("#ddlCategory").val(words[7]);
                    $("#ddlCostCenter").val(words[8]);
                    eventFunction.config.ItemIDUpdate = 1;


                    $("#ImgPreview").prop('src', SageFrameHostURL + '/Modules/ROItem/images/' + words[3]);

                });
                $("#itemtable").on('click', '.ItemDelete', function () {
                    eventFunction.DeleteItem(this);
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
                        eventFunction.Reset();                   
                        eventFunction.GetAll();                    
                        break;
                    case 2:
                        jAlert('Updated successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.GetAll();
                        break;
                    case 3:
                        jAlert('Delete successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        var id = eventFunction.config.ID;
                        eventFunction.GetAll();
                        break;
                    case 4:
                        eventFunction.BindItem(data.d);
                        break;
                    case 6:
                        eventFunction.BindDropdownUnit(data);
                        break;
                    case 7:
                        eventFunction.BindcomboListing(data.d);
                        break;
                    case 8:
                        eventFunction.Bindcombobyid(data.d);
                        break;
                    case 10:
                        eventFunction.BindCostCenter(data.d);
                        break;
                    case 11:

                        break;
                    case 12:
                        eventFunction.BindComboDetailsbyID(data.d);
                        break;
                    case 13:
                        eventFunction.BindInactiveComboList(data.d);
                        break;
                    case 14:
                        eventFunction.BindUpcomingComboList(data.d);
                        break;
                    case 15:
                        eventFunction.BindCancelledComboList(data.d);
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
            InactiveCombo: function () {

                eventFunction.config.method = "InactiveCombo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);


            },
            getInactiveComboList: function () {
                eventFunction.config.method = "getInactivecumbolist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 13;
                eventFunction.ajaxCall(eventFunction.config);
            },

            dDeletecombo: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var comboid = id;
                var UserName = p.Username;
                eventFunction.config.method = "DELETECOMBO";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ comboid: comboid, UserName: UserName });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },
            getcombobyid: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var comboid = id;
                eventFunction.config.method = "getcombodatabyid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ comboid: comboid });
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            validedform: function (t) {
                t.find(".sfError").removeClass("sfError");
                var valid = true;
                if (t.attr("data-id") == 0) {
                    t.find(".autopickitem").addClass("sfError");
                    valid = false;
                    jAlert('Please  insert Item!', 'Information!!', function () { $.alerts.dialogClass = null; });

                }
                if (t.find(".Quantity").val() == "") {
                    t.find(".Quantity").addClass("sfError");
                    valid = false;
                    jAlert('Please Insert Quantity!', 'Information!!', function () { $.alerts.dialogClass = null; });

                }


                return valid;
            },


            SaveCumbo: function () {
                var CumboPackDetails = new Array();
                var MyRows = $('table#cumbotable').find('tbody').find('tr');
                $.each(MyRows, function (x, y) {
                    var CumboPackObject = new Object();
                    CumboPackObject.ItemID = $(y).attr("data-id");
                    CumboPackObject.ItemRate = ($(y).find('.Rate').val());
                    CumboPackObject.Quantity = ($(y).find('.Quantity').val());
                    CumboPackObject.TotalPrice = ($(y).find(".TotalPrice").val());
                    CumboPackDetails.push(CumboPackObject);
                });
                superss = new Object();
                superss.CumboPackDetails = CumboPackDetails;
                superss.Name = $('#cmbName').val();
                superss.Description = $('#cmbDescriptoin').val();
                superss.CostCenter = $('#SelCostCenter').val();
                superss.ComboCode = $('#cmbCode').val();
                superss.ImagePath = $("#txtImage").val();
                superss.StartDate = $('#startDate').val();
                superss.EndDate = $('#endate').val();
                superss.SalesPrice = $('#salesprice').val();
                superss.ItemsSalesCost = $('#ItemsSalesCost').val();
                var value = $("#ans").attr('checked', true);
                if (value = true) {
                    superss.IsActive = true;
                }
                else {
                    superss.IsActive = false;
                }
                superss.AddedBy = p.Username;
                superss.ComboID = eventFunction.config.ComboID;

                var jsonText = JSON2.stringify({ comboorder: superss });
                eventFunction.config.method = "restroCombo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                //eventFunction.config.ajaxCallMode = 1;
                //eventFunction.ajaxCall(eventFunction.config);
                if (eventFunction.config.ComboIDUpdate == 1)
                    eventFunction.config.ajaxCallMode = 2;
                else
                    eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.ComboIDUpdate= 0;
                eventFunction.config.ComboID = 0;
                
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
            getcumboiterm: function () {
                eventFunction.config.method = "getcumbolist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
            getUpcomingcumbolist: function () {
                 eventFunction.config.method = "getUpcomingcumbolist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getCancelledcumbolist: function () {
                eventFunction.config.method = "getCancelledcumbolist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 15;
                eventFunction.ajaxCall(eventFunction.config);
            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            Bindcombobyid: function (data) {
                $("#comboDialog").html('');
                var datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<h5> Combo Name : " + datas[0].Name + "</h5>";
                    htmls += "<h5> Price : " + datas[0].SalesPrice + "</h5>";
                    htmls += "<img src='/Modules/ROCumboPack/images/" + datas[0].ImagePath + "'>"
                    htmls += "<div class='dataTables_wrapper no-footer'><table id='unitTable' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    //<th class='delete-heading'>Delete</th>
                    htmls += "<th>Item Name</th><th>Qty</th><th>Code</th><th>Start Date </th> <th>End Date</th><th>Item Sales Cost</th><th>Item Total Cost</th></th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.ComboID + "_>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.ComboCode + "</td>";
                        htmls += "<td>" + value.StartDatee + "</td>";
                        htmls += "<td>" + value.EndDatee + "</td>";
                        htmls += "<td class='tdrate'>" + value.ItemsSalesCost + "</td>";
                        htmls += "<td class='tdrate'>" + (value.Quantity * value.ItemsSalesCost) + "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table></div>";
                    $('#comboDialog').html(htmls);
                    $("#comboDialog").dialog({
                        'title': 'Combo Details : ' + datas[0].Name,
                        'width': 800,
                        modal :true,
                        dialogClass: 'popup-titlebg',
                        "jQueryUI": true
                    });
                } else {
                    $('#comboDialog').html('No data');
                }
            },
            BindcomboListing: function (data) {
                $("#comboListing").show();
                $("#comboListing").html('');
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<table id='unitTable' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    //<th class='delete-heading'>Delete</th>
                    htmls += "<th>SN</th><th>Name </th><th>Combo Code </th><th>Start Date </th> <th>End Date</th><th class='tdrate'>Sales Rate</th><th class='tdrate'>Sales Cost</th><th class='tdcenter'>Action</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.ComboID + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.ComboCode + "</td>";
                        htmls += "<td>" + value.StartDatee + "</td>";
                        htmls += "<td>" + value.EndDatee + "</td>";
                        htmls += "<td class='tdrate'>" + value.SalesPrice + "</td>";
                        htmls += "<td class='tdrate'>" + value.ItemsSalesCost + "</td>";
                        //htmls += "<td>" + value.IsActive + "</td>";
                       // htmls += "<td> <input type='button' value='" + value.IsActive + "' class='sfBtn IsActiveClass " + value.ComboID + "'></td>";

                        htmls += "<td class='tdcenter'>";
                        htmls += "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.ComboID + "_" + value.Name + "_" + value.ComboCode + "_" + value.Description + "_" + value.StartDatee + "_" + value.EndDatee + "_" + value.SalesPrice + "_" + value.ItemsSalesCost + "_" + value.ImagePath + "_" + value.CostCenter + "' value='Edit' />";
                        htmls += " | ";
                        htmls += "<img src='/images/view.png' class='viewCombo preview-icon' type='button'  id=_" + value.ComboID + " value='View' />";
                        htmls += " | ";
                        htmls += "<img src='/images/closelabel.png' class='UnitDelete delete-icon' type='button'  id=_" + value.ComboID + " value='Delete' />";
                        htmls += "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#comboListing').html(htmls);
                    //$('#unitTable').DataTable({
                
                    //    "jQueryUI": true,
                    //});


                } else {
                    $('#comboListing').html('No data');
                }

                $("#unitTable").on('click', ".UnitDelete", function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.dDeletecombo(item);
                           
                        }
                    });
                    return false;
                });

                $("#unitTable").on('click', ".UnitEdit", function () {

                    $("#tabss").hide();
                    $("#InactivecomboList").hide();
                    $('#comboListing').hide();
                    $('#btnShowForm').hide();
                    $("#roiitemtable").show();
                    eventFunction.config.ComboIDUpdate = 1;
                    var ids = $(this).attr('id');
                    var word = ids.split("_");
                    $('#cmbName').val(word[1]);
                    $('#cmbDescriptoin').val(word[3]);
                    $('#SelCostCenter').val(word[9]);
                    $('#cmbCode').val(word[2]);
              
                    $('#startDate').val(word[4]);
                    $('#endate').val(word[5]);
                    $('#salesprice').val(word[6]);
                    $('#ItemsSalesCost').val(word[7]);
                    $("#txtImage").val(word[8]);
                    $("#ImgPrvs").attr("src", "/Modules/ROCumboPack/images/" + word[8]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();
           
                    var comboid = word[0];
                    eventFunction.config.ComboID = word[0];
                    eventFunction.config.method = "getcombodatabyid";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ comboid: comboid });
                    eventFunction.config.ajaxCallMode = 12;

                    eventFunction.ajaxCall(eventFunction.config);
                });


                $("#unitTable").on('click', '.viewCombo', function () {
                    eventFunction.getcombobyid(this);
                });
                $(".IsActiveClass").on('click', function () {
                    var ComboID = parseInt($(this).parents('tr').attr("id").split("_")[0]);
                    eventFunction.config.method = "updateisactive";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ ComboID: ComboID });
                    eventFunction.config.ajaxCallMode = 9;
                    //eventFunction.config.ID = id;
                    eventFunction.ajaxCall(eventFunction.config);
                    eventFunction.getcumboiterm();
                });
                //var rate = parseFloat($(this).parents("tr").find(".Rate").val());

            },

            BindInactiveComboList: function (data) {
                $("#InactivecomboList").show();
                $("#InactivecomboList").html('');
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<table id='unitTableSS' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    //<th class='delete-heading'>Delete</th>
                    htmls += "<th>SN</th><th>Name </th><th>Combo Code </th><th>Start Date </th> <th>End Date</th><th class='tdrate'>Sales Rate</th><th class='tdrate'>Sales Cost</th><th class='tdcenter'>Action</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.ComboID + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.ComboCode + "</td>";
                        htmls += "<td>" + value.StartDatee + "</td>";
                        htmls += "<td>" + value.EndDatee + "</td>";
                        htmls += "<td class='tdrate'>" + value.SalesPrice + "</td>";
                        htmls += "<td class='tdrate'>" + value.ItemsSalesCost + "</td>";
                        //htmls += "<td>" + value.IsActive + "</td>";
                        // htmls += "<td> <input type='button' value='" + value.IsActive + "' class='sfBtn IsActiveClass " + value.ComboID + "'></td>";

                        htmls += "<td class='tdcenter'>";
                        htmls += "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.ComboID + "_" + value.Name + "_" + value.ComboCode + "_" + value.Description + "_" + value.StartDatee + "_" + value.EndDatee + "_" + value.SalesPrice + "_" + value.ItemsSalesCost + "_" + value.ImagePath + "_" + value.CostCenter + "' value='Edit' />";
                        htmls += " | ";
                        htmls += "<img src='/images/view.png' class='viewCombo preview-icon' type='button'  id=_" + value.ComboID + " value='View' />";
                        //htmls += " | ";
                        //htmls += "<img src='/images/closelabel.png' class='UnitDelete delete-icon' type='button'  id=_" + value.ComboID + " value='Delete' />";
                        htmls += "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#InactivecomboList').html(htmls);
                    //$('#unitTableSS').DataTable({
                     
                    //    "jQueryUI": true,
                    //});


                } else {
                    $('#InactivecomboList').html('No data');
                }

                $("#unitTableSS").on('click', ".UnitDelete", function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.dDeletecombo(item);

                        }
                    });
                    return false;
                });
                $("#unitTableSS").on('click', ".UnitEdit", function () {

                    $("#tabss").hide();
                    $("#InactivecomboList").hide();
                    $('#comboListing').hide();
                    $('#btnShowForm').hide();
                    $("#roiitemtable").show();
                    eventFunction.config.ComboIDUpdate = 1;
                    var ids = $(this).attr('id');
                    var word = ids.split("_");
                    $('#cmbName').val(word[1]);
                    $('#cmbDescriptoin').val(word[3]);
                    $('#SelCostCenter').val(word[9]);
                    $('#cmbCode').val(word[2]);

                    $('#startDate').val(word[4]);
                    $('#endate').val(word[5]);
                    $('#salesprice').val(word[6]);
                    $('#ItemsSalesCost').val(word[7]);
                    $("#txtImage").val(word[8]);
                    $("#ImgPrvs").attr("src", "/Modules/ROCumboPack/images/" + word[8]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();

                    var comboid = word[0];
                    eventFunction.config.ComboID = word[0];
                    eventFunction.config.method = "getcombodatabyid";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ comboid: comboid });
                    eventFunction.config.ajaxCallMode = 12;

                    eventFunction.ajaxCall(eventFunction.config);
                });

                $("#unitTableSS").on('click', '.viewCombo', function () {
                    eventFunction.getcombobyid(this);
                });
                $(".IsActiveClass").on('click', function () {
                    var ComboID = parseInt($(this).parents('tr').attr("id").split("_")[0]);
                    eventFunction.config.method = "updateisactive";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ ComboID: ComboID });
                    eventFunction.config.ajaxCallMode = 9;
                    //eventFunction.config.ID = id;
                    eventFunction.ajaxCall(eventFunction.config);
                    eventFunction.getcumboiterm();
                });
                //var rate = parseFloat($(this).parents("tr").find(".Rate").val());

            },


            BindUpcomingComboList: function (data) {
                $("#UpcomingcomboList").show();
                $("#UpcomingcomboList").html('');
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<table id='unitTableUP' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    //<th class='delete-heading'>Delete</th>
                    htmls += "<th>SN</th><th>Name </th><th>Combo Code </th><th>Start Date </th> <th>End Date</th><th class='tdrate'>Sales Rate</th><th class='tdrate'>Sales Cost</th><th class='tdcenter'>Action</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.ComboID + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.ComboCode + "</td>";
                        htmls += "<td>" + value.StartDatee + "</td>";
                        htmls += "<td>" + value.EndDatee + "</td>";
                        htmls += "<td class='tdrate'>" + value.SalesPrice + "</td>";
                        htmls += "<td class='tdrate'>" + value.ItemsSalesCost + "</td>";
                        //htmls += "<td>" + value.IsActive + "</td>";
                        // htmls += "<td> <input type='button' value='" + value.IsActive + "' class='sfBtn IsActiveClass " + value.ComboID + "'></td>";

                        htmls += "<td class='tdcenter'>";
                        htmls += "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.ComboID + "_" + value.Name + "_" + value.ComboCode + "_" + value.Description + "_" + value.StartDatee + "_" + value.EndDatee + "_" + value.SalesPrice + "_" + value.ItemsSalesCost + "_" + value.ImagePath + "_" + value.CostCenter + "' value='Edit' />";
                        htmls += " | ";
                        htmls += "<img src='/images/view.png' class='viewCombo preview-icon' type='button'  id=_" + value.ComboID + " value='View' />";
                        htmls += " | ";
                        htmls += "<img src='/images/closelabel.png' class='UnitDelete delete-icon' type='button'  id=_" + value.ComboID + " value='Delete' />";
                        htmls += "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#UpcomingcomboList').html(htmls);
                    //$('#unitTableUP').DataTable({

                    //    "jQueryUI": true,
                    //});


                } else {
                    $('#UpcomingcomboList').html('No data');
                }

                $("#unitTableUP").on('click', ".UnitDelete", function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.dDeletecombo(item);

                        }
                    });
                    return false;
                });
                $("#unitTableUP").on('click', ".UnitEdit", function () {

                    $("#tabss").hide();
                    $("#InactivecomboList").hide();
                    $('#comboListing').hide();
                    $('#btnShowForm').hide();
                    $("#roiitemtable").show();
                    eventFunction.config.ComboIDUpdate = 1;
                    var ids = $(this).attr('id');
                    var word = ids.split("_");
                    $('#cmbName').val(word[1]);
                    $('#cmbDescriptoin').val(word[3]);
                    $('#SelCostCenter').val(word[9]);
                    $('#cmbCode').val(word[2]);

                    $('#startDate').val(word[4]);
                    $('#endate').val(word[5]);
                    $('#salesprice').val(word[6]);
                    $('#ItemsSalesCost').val(word[7]);
                    $("#txtImage").val(word[8]);
                    $("#ImgPrvs").attr("src", "/Modules/ROCumboPack/images/" + word[8]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();

                    var comboid = word[0];
                    eventFunction.config.ComboID = word[0];
                    eventFunction.config.method = "getcombodatabyid";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ comboid: comboid });
                    eventFunction.config.ajaxCallMode = 12;

                    eventFunction.ajaxCall(eventFunction.config);
                });

                $("#unitTableUP").on('click', '.viewCombo', function () {
                    eventFunction.getcombobyid(this);
                });
        
            },

            BindCancelledComboList: function (data) {
                $("#CancelledcomboList").show();
                $("#CancelledcomboList").html('');
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<table id='unitTableCan' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    //<th class='delete-heading'>Delete</th>
                    htmls += "<th>SN</th><th>Name </th><th>Combo Code </th><th>Start Date </th> <th>End Date</th><th class='tdrate'>Sales Rate</th><th class='tdrate'>Sales Cost</th><th class='tdcenter'>Action</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1
                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.ComboID + "_>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.ComboCode + "</td>";
                        htmls += "<td>" + value.StartDatee + "</td>";
                        htmls += "<td>" + value.EndDatee + "</td>";
                        htmls += "<td class='tdrate'>" + value.SalesPrice + "</td>";
                        htmls += "<td class='tdrate'>" + value.ItemsSalesCost + "</td>";
                        //htmls += "<td>" + value.IsActive + "</td>";
                        // htmls += "<td> <input type='button' value='" + value.IsActive + "' class='sfBtn IsActiveClass " + value.ComboID + "'></td>";

                        htmls += "<td class='tdcenter'>";
                        //htmls += "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.ComboID + "_" + value.Name + "_" + value.ComboCode + "_" + value.Description + "_" + value.StartDatee + "_" + value.EndDatee + "_" + value.SalesPrice + "_" + value.ItemsSalesCost + "_" + value.ImagePath + "_" + value.CostCenter + "' value='Edit' />";
                        //htmls += " | ";
                        htmls += "<img src='/images/view.png' class='viewCombo preview-icon' type='button'  id=_" + value.ComboID + " value='View' />";
                        //htmls += " | ";
                        //htmls += "<img src='/images/closelabel.png' class='UnitDelete delete-icon' type='button'  id=_" + value.ComboID + " value='Delete' />";
                        htmls += "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#CancelledcomboList').html(htmls);
                    //$('#unitTableCan').DataTable({

                    //    "jQueryUI": true,
                    //});


                } else {
                    $('#UpcomingcomboList').html('No data');
                }

                $("#unitTableCan").on('click', ".UnitDelete", function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.dDeletecombo(item);

                        }
                    });
                    return false;
                });
                $("#unitTableCan").on('click', ".UnitEdit", function () {

                    $("#tabss").hide();
                    $("#InactivecomboList").hide();
                    $('#comboListing').hide();
                    $('#btnShowForm').hide();
                    $("#roiitemtable").show();
                    eventFunction.config.ComboIDUpdate = 1;
                    var ids = $(this).attr('id');
                    var word = ids.split("_");
                    $('#cmbName').val(word[1]);
                    $('#cmbDescriptoin').val(word[3]);
                    $('#SelCostCenter').val(word[9]);
                    $('#cmbCode').val(word[2]);

                    $('#startDate').val(word[4]);
                    $('#endate').val(word[5]);
                    $('#salesprice').val(word[6]);
                    $('#ItemsSalesCost').val(word[7]);
                    $("#txtImage").val(word[8]);
                    $("#ImgPrvs").attr("src", "/Modules/ROCumboPack/images/" + word[8]);
                    $(".ajax-file-upload").show();
                    $(".ajax-file-upload-statusbar").hide();

                    var comboid = word[0];
                    eventFunction.config.ComboID = word[0];
                    eventFunction.config.method = "getcombodatabyid";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ comboid: comboid });
                    eventFunction.config.ajaxCallMode = 12;

                    eventFunction.ajaxCall(eventFunction.config);
                });

                $("#unitTableCan").on('click', '.viewCombo', function () {
                    eventFunction.getcombobyid(this);
                });

            },

            BindComboDetailsbyID: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        var i = 1;
                        if (index == 0) {
                            $('#cumbotable tbody').find('tr').attr('data-id', value.ItemID);              
                            $('#cumbotable tbody tr:eq(0)').find('td:eq(0) input[type=text]').val(value.ITName);
                            $('#cumbotable tbody tr:eq(0)').find('td:eq(1) input[type=text]').val(value.ItemRate);
                            $('#cumbotable tbody tr:eq(0)').find('td:eq(2) input[type=text]').val(value.Quantity);
                            $('#cumbotable tbody tr:eq(0)').find('td:eq(3) input[type=text]').val(value.TotalPrice);
                        }
                        else {
                            $("#cumbotable #btnAdd").click();
                            $('#cumbotable tbody').find('tr:eq(' + index + ')').attr('data-id', value.ItemID);
                            $('#cumbotable tbody tr:eq(' + index + ')').find('td:eq(0) input[type=text]').val(value.ITName);
                            $('#cumbotable tbody tr:eq(' + index + ')').find('td:eq(1) input[type=text]').val(value.ItemRate);
                            $('#cumbotable tbody tr:eq(' + index + ')').find('td:eq(2) input[type=text]').val(value.Quantity);
                            $('#cumbotable tbody tr:eq(' + index + ')').find('td:eq(3) input[type=text]').val(value.TotalPrice);
                            i++;
                        }
                    });
                }
            },
            CreateHtmlForItem: function () {

                var html = "<tr data-id='0'>";
                html += '<td> <input type="text" class="sfInputbox autopickitem" id="autopickid" style="width: 94%" /></td>';
                html += '<td> <input type="text" class="sfInputbox Rate" disabled style="width: 100px" /></td>';
                html += '<td> <input type="text" class="sfInputbox Quantity" onkeypress="return isNumber(event)" style="width: 100px" /> </td>';
                html += '<td> <input type="text" class="sfInputbox TotalPrice" disabled style="width: 150px"/></td>';
                html += '<td> <input type="button" id="btnAdd" value="ADD" class="sfLocale icon-addnew sfBtn" /></td>';
                html += "</tr>"
                countsarray.push(count);
                return html;
            },
            BindItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, v) {


                        items.push({ label: v.ItemName, value: v.ItemID, rate: v.PRate });
                    });
                    $(".autopickitem").autocomplete({

                        source: items,

                        focus: function (event, ui) {
                            // prevent autocomplete from updating the textbox
                            event.preventDefault();
                            // manually update the textbox
                           // $(this).val(ui.item.label);
                            $(this).parents("tr").find('#autopickid').val(ui.item.label);
                        },
                        select: function (event, ui) {
                            // prevent autocomplete from updating the textbox
                            event.preventDefault();
                            // manually update the textbox and hidden field
                           // $(this).val(ui.item.label);
                            $(this).parents("tr").find('#autopickid').val(ui.item.label);
                            $(this).parents("tr").attr('data-id', ui.item.value);
                            $(this).parents("tr").find('.Rate').val(ui.item.rate);

                        }

                    });
                }

            },

            uploadImage: function () {
                var fileUpload = $("#fileImage").get(0);
                var files = fileUpload.files;

                var data = new FormData();
                for (var i = 0; i < files.length; i++) {
                    data.append(files[i].name, files[i]);
                }

                $.ajax({
                    url: "/Modules/ROCumboPack/UploadHandler.ashx",
                    type: "POST",
                    data: data,
                    contentType: false,
                    processData: false,
                    success: function (result) { },
                    error: function (err) {
                        jAlert(err.statusText, 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                });
                //success: function (result) { alert(result); },
            },

            BindRate: function (result) {
                var datas = result.d;
                $("#Rate").val(datas[0].PRate);
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>
            ResetAll: function () {
                //Unit
                eventFunction.init();
                $('#textItemName').val(null);
                $('#textItemCode').val(null);
                $('#textItemPrice').val(null);
                $('#ddlUnit').val(null);
                $('#ddlCategory').val(null);
                $('#ddlCostCenter').val(null);
                $('#txtFile').val('');
                $('.showimage').hide();
                $('#ImgPreview').val('');
                $('#textItemDescription').val(null);
                eventFunction.config.NewItemID = 0;
                eventFunction.config.ItemIDUpdate = 0;
                $("#btnShowForm").show();
                $("#comboListing").show();
                $("#roiitemtable").hide();
            },

            GetAll: function () {
                eventFunction.getcumboiterm();
                eventFunction.getInactiveComboList();
                eventFunction.getUpcomingcumbolist();
                eventFunction.getCancelledcumbolist();
            },

            Reset: function () {
                eventFunction.config.NewItemID = 0;
                $('#cmbName').val('');
                $('#txtFile').val('');
                $("#ImgPreview").val('');
                $("#fileImage").val("");
                $("#ImgPrvs").removeAttr('src');
                $(".ajax-file-upload").show();
                $(".ajax-file-upload-statusbar").hide();
                $(".ajax-file-upload-error").hide();
                $("#txtImage").val('');
                $('.showimage').hide();
                $('#cmbCode').val('');
                $('#SelCostCenter').val('');
                $('#cmbDescriptoin').val('');
                
                $("#cumbotable tbody tr:not(:last-child)").remove();
                $("#cumbotable tbody tr:not(:last-child)").val('');
                $('#cumbotable tbody tr').attr('data-id', '0');
                $('#autopickid').val('');
                $('.Rate').val('');
                $('.Quantity').val('');
                $('.TotalPrice').val('');
                $('#ItemsSalesCost').val('');
                $('#salesprice').val('');
               
                 totalPoints = 0;
              

                $("#btnShowForm").show();
                $("#comboListing").show();
                $("#InactivecomboList").show();
                $("#roiitemtable").hide();
                $("#tabss").show();

               
                eventFunction.config.ComboIDUpdate = 0;
                eventFunction.config.ComboID = 0;

            },
            readURL: function readURL(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        $('#ImgPrvs').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        SelCostCenter: { required: true },
                        txtComboCode: { required: true },
                        txtStart: { required: true },
                        txtEnd: { required: true },
                        txtName: { required: true },
                        txtSalePrice: { required: true, number: true }
                    },
                    messages: {
                    }

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