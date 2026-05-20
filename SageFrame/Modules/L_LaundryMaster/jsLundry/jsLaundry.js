(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/L_LaundryMaster/webservices/'
             }, p);
        var checks = [];
        var laundryHead = "";
        var logoInfo = "";
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsLaundrys.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                laundryID: 0,
                laundryUpdate: 0,
                laundryMasterID: 0,
                laundryUpdate: 0,
                laundryDetailsID: 0
            },
            InitialSetup: function () {
                $("#tabs").tabs();
                eventFunction.getLaundryList();
                jQuery("#txtDate").datepicker({
                    dateFormat: 'yy/mm/dd',
                    changeMonth: true,
                    changeYear: true,
                    minDate: '0',
                    onClose: function (selectedDate) {
                        jQuery("#txtDeliveryDate").datepicker("option", "minDate", selectedDate);
                        $("#txtDeliveryDate").val($("#txtDate").val());
                    }
                }).datepicker("setDate", new Date());

                $("#txtDeliveryDate").datepicker({
                    dateFormat: "yy/mm/dd",
                    changeMonth: true,
                    changeYear: true,
                }).datepicker("setDate", "+3");

                eventFunction.getcompanyInfo();

               

                //$('#txtColor').ColorPicker({ flat: true });
                //$("#txtColor").colorpicker({});
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#btnSave").click(function () {
                    if ($('.tblForTempLaundry tbody').find("tr").length >= 2){
                        eventFunction.Savelaundry();
                    }
                    else {
                        alert("Empty Laundry Details");
                    }
                });
                $("#ddlCloth").change(function () {
                    var cloth = parseInt($("#ddlCloth").val() == "" ? 0 : $("#ddlCloth").val());
                    eventFunction.config.method = "getLaundryType";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ cloth: cloth});
                    eventFunction.config.ajaxCallMode = 10;
                    eventFunction.ajaxCall(eventFunction.config);
                });
                $(".getRate").change(function () {
                    var cloth = parseInt($("#ddlCloth").val() == "" ? 0 : $("#ddlCloth").val());
                    var Ltype = parseInt($("#ddlLaundryType").val() == "" ? 0 : $("#ddlLaundryType").val());
                    eventFunction.config.method = "getRatebyId";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ cloth: cloth, Ltype: Ltype });
                    eventFunction.config.ajaxCallMode = 1;
                    eventFunction.ajaxCall(eventFunction.config);
                });
                $(".tblForTempLaundry").on("click", ".delete", function () {
                    if (confirm("Delete! Are You Sure?")) {
                        var row = $(this).closest('tr');

                        $(this).closest('tr').remove();
                        var amount = 0;
                        var table = document.getElementById("tblForTempLaundry");
                        for (var i = 0, row; row = table.rows[i]; i++) {
                            //iterate through rows
                            //rows would be accessed using the "row" variable assigned in the for loop
                            amount += $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(4)').text() * $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(5)').text();

                        }
                        $("#txtAmount").val(amount);
                        $("#txtDiscount").val(0);
                        $("#txtGrandTotal").val(amount);
                    }
                });
                
                $("#txtYes2").change(function () {

                    if ($(this).prop('checked') == true) {

                        $("#CashPaid").dialog({
                            'title': 'Customer List',
                            width: 1024,
                            modal: true,
                            resizable: true,
                            dialogClass:'headingbg',
                        });
                        eventFunction.GetCustomeronChange();
                        $("#membeshipformlist").hide();
                    }
                    else {
                        $("#CashPaid").hide();
                        //$("#txtCashCusName").val("");
                        //$("#txtAddress").val("");
                        //$("#txtPan").val("");
                    }
                });
                $("#ddlRoomType").change(function () {
                    // alert("Hello world!");
                    //var id = parseInt($(this).attr('id'));
                    eventFunction.getRoomNoByRoomType();
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
                        alert("saved Successfully");
                        eventFunction.Reset();
                        break;
                    case 1:
                        $("#txtRate").val(data.d);
                        break;
                    case 2:
                        eventFunction.bindLaundryList(data);
                        break;
                    case 3:
                        eventFunction.getLaundryByIDInDialog(data.d);
                        break;
                    case 4:
                        eventFunction.bindLaundryByID(data.d);
                        break;
                    case 5:
                        eventFunction.BindCusCash(data);
                        break;
                    case 6:
                        alert("Update Successfully");
                        eventFunction.Reset();
                        break;
                    case 7:
                        eventFunction.bindRoomNoByRoomType(data);
                        break;
                    case 8:
                        eventFunction.bindgetcompanyInfo(data.d);
                        break;
                    case 9:
                        alert("Delete Successfully");
                        eventFunction.Reset();
                        break;
                    case 10:
                        eventFunction.bindLaundryTypeList(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            bindLaundryTypeList:function(data){
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(data, function (index, value) {
                        htmls += "<option value='" + value.ID + "'>" + value.Type + "</option>";
                    });

                    $("#ddlLaundryType").html(htmls);
            },
            getcompanyInfo: function () {
                eventFunction.config.method = "getcompanyInfo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //eventFunction.config.data = JSON2.stringify({ RoomTypeID: id });
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindgetcompanyInfo: function (data) {
                var htmls = "";
                htmls += "<div id='customer-bill' style='text-align:center;width:100%;'>"
                $.each(data, function (index, value) {
                    htmls += (" <img src='/Modules/ROCompanyInfo/logo/" + value.Logo + "' style='width:100px;'/>");
                    htmls += ("<table style='width:100%;padding-bottom:5px;text-align:center;border-bottom:1px dotted;'>");
                    htmls += ("<tr>");
                    htmls += ("<td style='font-size:24px;text-align:center;'>" + value.Name + "</td>");
                    htmls += ("</tr>");
                    htmls += ("<tr>");
                    htmls += ("<td style='font-size:22px;text-align:center;'>" + value.Address + "</td>");
                    htmls += ("</tr>");
                    htmls += ("<tr>");
                    htmls += ("<td style='font-size:21px;text-align:center;'>" + value.PhoneNo + "</td>");
                    htmls += ("</tr>");
                    htmls += ("</table>");
                    htmls += ("</div>");
                });
                logoInfo = htmls;
            },



            print: function (Contents) {
                var contents = Contents;
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
            },

            getRoomNoByRoomType: function () {
                var id = $("#ddlRoomType").val();
                eventFunction.config.method = "getRoomNoByRoomType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ RoomTypeID: id });
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },


            bindRoomNoByRoomType: function (result) {
                var datas = result.d;
                var x = new Array();
                $("#ddlRoom").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                    });

                    $("#ddlRoom").html(htmls);
                    $(".room").show();
                }
            },
            bindLaundryByID: function (data) {
                var htmls = "";
                var laundryMasterID = "";
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<tr><td id='+ value.ClothID +'>' + value.Cloth + '</td>';
                        htmls += '<td id=' + value.MaterialID + '>'+ value.Material+'</td>';
                        //htmls += '<td>' + value.Color + '</td>';
                        htmls += '<td>' + value.Description + '</td>';
                        htmls += '<td id=' + value.LaundryTypeID + '>'+ value.LaundryType+'</td>';
                        htmls += '<td>' + value.Quantity + '</td>';
                        htmls += '<td>' + value.Rate + '</td>';
                        htmls += '<td>' + value.Quantity * value.Rate + '</td>';
                        htmls += '<td>' + value.IsDelivered + '</td>';
                        htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.ID + '"></label></td></tr>';
                        eventFunction.config.laundryDetailsID = value.ID;
                        laundryMasterID = value.LaundryMasterID;

                    });
                    $(".tblForTempLaundry").append(htmls);
                    var rowCount = $('.tblForTempLaundry tbody tr').length;
                    $("#divLaundryList").hide();
                    $("#filterbox").hide();
                    $(".addForm").show();
                    $("#dvAddBtn").hide();
                    $("#tblForTotal").show();
                    $('.tblForTempLaundry').show();
                    $("#btnSave").prop('value','Update');
                    //$(".tblForTempFinancialAc").on("click", ".edit", function (e) {
                    //    e.preventDefault();
                    //    var row = $(this).parents('tr');
                    //    alert(row.find('td:eq(1)').text());

                    //});
                }

            },
            GetCustomeronChange: function () {
                var customer = 1;
                eventFunction.config.method = "getsdatass";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ customer: customer });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindCusCash: function (data) {
                $("#CashPaid").show();
                $("#CashPaid").html('');

                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='Cashtable' class=' display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"

                    htmls += "<th>Cus Name </th><th style='width:200px'> Address </th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th>PAN</th><th class='delete-heading'>Select</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.Occupation + "</td>";
                        htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td>" + "<img src='/images/completed.png' style='width:25px;' class='CusSelect' type='button'  id=+" + value.MembershipID + "+" + value.Fname + "+" + value.Lname + "+" + value.PAN + "+" + value.Address + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        checks.push(value.CardNumber);

                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#CashPaid').html(htmls);
                    $('#Cashtable').DataTable(
                         {
                             "scrollY": false,
                             "scrollCollapse": false,
                             "jQueryUI": true,
                         });
                } else {
                    $('#CashPaid').html('No data');
                }
                $("#CashPaid").on('click', '.CusSelect', function (event) {
                    var rows = $(this).closest('tr');
                    var customer = rows.find('td:eq(0)').text();

                    var ids = $(this).attr('id');
                    var word = ids.split("+");
                    var customer = rows.find('td:eq(0)').text();
                    // $(".txtCustomer").val(word[2] + " " + word[3]);
                    $(".txtCustomer").val(customer);
                    $("#ddlCustomerID").val(word[1]);
                    $(".txtCustomer").show();
                    $("#CashPaid").hide();
                    $("#txtYes2").prop("checked", false);
                    $("#CashPaid").hide();
                    $("#CashPaid").dialog("close");

                });
            },

            getLaundryByIDInDialog: function (datas) {
          
                if (datas.length > 0) {
                    var htmls = '';
                    var a = 0;
                    htmls += "<table id='tableLaundryByIDInDialog' class='display dataTable no-footer' border='1'><thead><tr><th>S.N.</th><th>Cloth</th><th>Material</th>"
                        //+"<th>Color</th>
                        +"<th>Description</th><th>Laundry Type</th><th>Quantity</th><th>Rate(Rs.)</th><th>Amount(Rs.)</th><th>IsDelivered</th></tr></thead><tbody>";
                    var valids = "";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.Cloth + '</td>';
                        htmls += '<td>' + value.Material + '</td>';
                        //htmls += '<td>' + value.Color + '</td>';
                        htmls += '<td>' + value.Description + '</td>';
                        htmls += '<td>' + value.LaundryType + '</td>';
                        htmls += '<td>' + value.Quantity + '</td>';
                        htmls += '<td>' + value.Rate + '</td>';
                        htmls += '<td>' + value.Quantity * value.Rate + '</td>';
                        var deliv = value.IsDelivered;
                        if (deliv == true) {
                            htmls += "<td> <input type='checkbox' id='" + value.ID + "' value='" + value.IsDelivered + "' checked class='IsDelivered'></td>";

                        }
                        else {
                            htmls += "<td> <input type='checkbox' id='" + value.ID + "' value='" + value.IsDelivered + "' class='IsDelivered'></td>";

                        }
                    });
                    htmls += "</tbody></table>";
                    var laundry = htmls;
                    htmls += '<br/><input type="button" id="print" value="Print" class="sfBtn"/>';
                    $("#divLaundryView").append(htmls);
                    $("#tableLaundryByIDInDialog").dataTable({
                        search: false,
                        ordering:false,
                        // paging: false,
                        //info: false,
                    });

                }
                else {
                    $("#divLaundryView").append("<br/>  No Data");
                }
                
                $(".IsDelivered").on('click', function () {
                    var row = $(this).parents('tr');
                    var id = parseInt($(this).attr('id'));
                   // eventFunction.config.laundryDetailsID = id;
                    eventFunction.config.method = "updateldisdelivered";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ laundryDetailsID: id });
                    eventFunction.config.ajaxCallMode = 10;
                    //eventFunction.config.ID = id;
                    eventFunction.ajaxCall(eventFunction.config);
                    eventFunction.getLaundryList();
                    var boolval = document.getElementById(eventFunction.config.laundryMasterID).value;
                    if (boolval == 'true') {
                        $(".deliver").prop('checked', true);
                    }
                    else {
                        $(".deliver").prop('checked', false);
                    }
                    //if ($(".Delivered").prop('checked') == true) {
                    //    $(".deliver").prop('checked', true);
                    //}
                    //else {
                    //    $(".deliver").prop('checked', false);
                    //}
                });
                $(".deliver").on('click', function () {
                    var row = $(this).parents('tr');
                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.laundryMasterID = id;
                    eventFunction.config.method = "updateisdelivered";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ laundryMasterID: id });
                    eventFunction.config.ajaxCallMode = 10;
                    //eventFunction.config.ID = id;
                    eventFunction.ajaxCall(eventFunction.config);
                    eventFunction.getLaundryList();
                    if ($(".deliver").prop('checked') == true) {
                        $(".IsDelivered").prop('checked', true);
                    }
                    else {
                        $(".IsDelivered").prop('checked', false);
                    }
                });
                // $("#tableLaundryByIDInDialog").on("click", "#print", function () {
                $("#print").click(function () {
                    // alert("Hello World!");
                    eventFunction.print(logoInfo +"</br>"+ laundryHead + laundry);
                });
            },


            getUserlist: function () {
                eventFunction.config.method = "getUserlist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getLaundryList: function () {
                eventFunction.config.method = "getLaundry";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindLaundryList: function (datas) {
                var htmls = "";
                $("#divLaundryList").html("");
                //var datas = result.d;
                var i = 1;
                htmls += "<table id='tableForLaundryListing' class='sfGridwrapper display dataTable no-footer'><thead><tr><th>S.N.</th><th>Room Type</th><th>Room No.</th><th>Customer</th><th>Date</th><th>Deleviry Date</th>"
                    //+ "<th>Challan No.</th>"
                    + "<th>HouseKeeper</th><th>Amount</th><th>Discount</th><th>Total</th><th>IsDelivered</th><th class='edit-heading'>View</th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th></tr></thead><tbody>"
                if (datas.d.length >= 0) {
                    $(datas.d).each(function (index, value) {
                        htmls += '<tr><td>' + i + '</td>';
                        htmls += '<td>' + value.RoomTypeName + '</td>';
                        htmls += '<td>' + value.RoomName + '</td>';
                        htmls += '<td>' + value.CustomerName + '</td>';
                        dates = value.Date.split(" ");
                        deliverydates = value.DeliveryDate.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td>' + deliverydates[0] + '</td>';
                        //htmls += '<td>' + value.ChallanNo + '</td>';
                        htmls += '<td>' + value.HouseKeeperName + '</td>';
                        htmls += '<td>' + value.Amount + '</td>';
                        htmls += '<td>' + value.Discount + ' ('+ value.DiscountType +') </td>';
                        htmls += '<td>' + value.Total + '</td>';
                        var deliv = value.IsDelivered;
                        if (deliv == true) {
                            htmls += "<td> <input type='checkbox' id='" + value.ID + "' value='" + value.IsDelivered + "' checked class='Delivered'></td>";

                        }
                        else {
                            htmls += "<td> <input type='checkbox' id='" + value.ID + "' value='" + value.IsDelivered + "' class='Delivered'></td>";

                        }
                        //htmls += "<td> <input type='button' id='"+ value.ID +"' value='" + value.IsDelivered + "' class='IsDelivered'></td>";
                        htmls += '<td><label class="icon-preview btnViewLaundry" id="' + value.ID + '"></label>';
                        htmls += '<td><label id="' + value.ID + '+' + value.CustomerID + '" class="edit icon-edit" value="Edit"></label></td>';
                        htmls += '<td><label id="' + value.ID + '" class="delete icon-delete" value="Delete"></label></td></tr>';
                        i++;
                    });
                    htmls += '</tbody></table>';
                    $("#divLaundryList").html(htmls);
                    //$.fn.dataTable.ext.search.push(
                    //    function (settings, data, dataIndex) {
                    //        var max = $('#max').val();
                    //        var age = data[1]); // use data for the age column

                    //        if ((isNaN(min) && isNaN(max)) ||
                    //             (isNaN(min) && age <= max) ||
                    //             (min <= age && isNaN(max)) ||
                    //             (min <= age && age <= max)) {
                    //            return true;
                    //        }
                    //        return false;
                    //    }
                    //);
                    $("#tableForLaundryListing").dataTable({
                        //paging:true,

                    });
                }
                else {
                    $("#divLaundryList").html("No Data..");
                }
                $('#ddlroomtypelist').change(function () {
                    //alert($("#roomsearch").val())
                    $("#tableForLaundryListing").DataTable().columns(1).search(this.value).draw();

                    //var value = $("#ddlCloth").val();
                    //$("#hfClothTypeID").val(value);
                    //console.log(value);

                });
                $("#tableForLaundryListing").on("click", ".btnViewLaundry", function () {
                    var row = $(this).parents('tr');
                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.laundryMasterID = id;
                    htmls = "";
                    $("#divLaundryView").html(htmls);
                    htmls += "<table class='popup-tblTop'><tr><td>Room Type : " + row.find('td:eq(1)').text();
                    htmls += "</td><td>Room No. : " + row.find('td:eq(2)').text();
                    htmls += "</td><td> Customer : " + row.find('td:eq(3)').text();
                    htmls += "</td></tr><tr><td>Date : " + row.find('td:eq(4)').text();
                    htmls += "</td><td>DeliveryDate : " + row.find('td:eq(5)').text();
                    //htmls += "<br/>Challan No : " + row.find('td:eq(6)').text();
                    htmls += "</td><td>Housekeeper : " + row.find('td:eq(6)').text();
                    htmls += "</td></tr><tr><td>Amount : " + row.find('td:eq(7)').text();
                    htmls += "</td><td>Discount : " + row.find('td:eq(8)').text();
                    htmls += "</td><td>Total : " + row.find('td:eq(9)').text();
                    htmls += "</td></tr><tr><td></td><td>";
                    var boolval = document.getElementById(id).value;
                    if (boolval == 'true') {
                        //htmls += "<td> <input type='checkbox' id='" + value.ID + "' value='" + value.IsDelivered + "' checked class='IsDelivered'></td>";
                        htmls += "</td><td>Is Delivered :  <input type='checkbox' id='"+ id +"' checked class='deliver'>";

                    }
                    else {
                        htmls += "</td><td>Is Delivered :  <input type='checkbox' id='" + id + "' class='deliver'>";
                    }
                    htmls += "</td></tr></table>";
                    $("#divLaundryView").html(htmls);
                    laundryHead = htmls;

                    eventFunction.config.method = "getLaundryByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ laundryMasterID: id });
                    eventFunction.config.ajaxCallMode = 3;
                    eventFunction.ajaxCall(eventFunction.config);

                    $("#divLaundryView").dialog({
                        'title': 'Laundry Master',
                        width: 1024,
                        modal: true,
                        resizable: true,
                         dialogClass:'headingbg',
                    });
                });
                $("#tableForLaundryListing").on("click", ".delete", function () {
                    if (confirm("Delete! Are You Sure?")) {
                        var row = $(this).parents('tr');
                        var id = parseInt($(this).attr('id'));
                        eventFunction.config.laundryMasterID = id;

                        eventFunction.config.method = "deleteLaundry";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ laundryMasterID: id });
                        eventFunction.config.ajaxCallMode = 9;
                        eventFunction.ajaxCall(eventFunction.config);

                    }
                });
                $("#tableForLaundryListing").on("click", ".edit", function (e) {
                    //e.preventDefault();
                    //if (confirm("Edit! Are You Sure?")) 
                    {
                        eventFunction.config.laundryUpdate = 1;
                        var row = $(this).parents('tr');
                        var ids = $(this).attr('id').split('+');
                        var id = parseInt(ids[0]);
                        eventFunction.config.laundryMasterID = id;
                        $("#ddlRoomType option").each(function () {
                            if ($(this).text() == row.find('td:eq(1)').text()) {
                                $(this).attr('selected', 'selected');
                            }
                        });
                        eventFunction.getRoomNoByRoomType();
                        $("#ddlRoom option").each(function () {
                            if ($(this).text() == row.find('td:eq(2)').text()) {
                                $(this).attr('selected', 'selected');
                            }
                        });
                        $("#ddlRoom").show();
                        $(".txtCustomer").val(row.find('td:eq(3)').text());
                        $(".txtCustomer").show();
                        $("#ddlCustomerID").val(ids[1]);
                        date = row.find('td:eq(4)').text().split(' ');
                        $("#txtDate").val(date[0]);
                        $("#txtDeliveryDate").val(row.find('td:eq(5)').text());
                        //$("#txtChallanNo").val(row.find('td:eq(6)').text());
                        $("#ddlHouseKeeperID option").each(function () {
                            if ($(this).text() == row.find('td:eq(6)').text()) {
                                $(this).attr('selected', 'selected');
                            }
                        });
                        var boolval = document.getElementById(id).value;
                        if (boolval == 'true') {
                            $("#chkDelivered").prop('checked', true);
                        }
                        $("#lblDelivered").show();
                        $("#chkDelivered").show();
                        //$("#chkDelivered").prop('checked', boolval);
                        //$("#chkDelivered").val(boolval);
                        $("#txtAmount").val(row.find('td:eq(7)').text());
                        var disc = row.find('td:eq(8)').text().split(" ");
                        $("#txtDiscount").val(disc[0]);
                        var regExp = /\(([^)]+)\)/;
                        var matches = regExp.exec(disc[1]);
                        //console.log(matches[1]);
                        $("#discType option").each(function () {
                            if (matches != null) {
                                if ($(this).val() == matches[1]) {
                                    $(this).attr('selected', 'selected');
                                }
                            }
                        });
                        $("#txtGrandTotal").val(row.find('td:eq(9)').text());

                        eventFunction.config.method = "getLaundryByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ laundryMasterID: id });
                        eventFunction.config.ajaxCallMode = 4;
                        eventFunction.ajaxCall(eventFunction.config);
                    };
                });
                $(".Delivered").on('click', function () {
                    if (confirm("Do You want to change delivery status?")) {
                        var row = $(this).parents('tr');
                        var id = parseInt($(this).attr('id'));
                        eventFunction.config.laundryMasterID = id;
                        eventFunction.config.method = "updateisdelivered";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ laundryMasterID: id });
                        eventFunction.config.ajaxCallMode = 10;
                        //eventFunction.config.ID = id;
                        eventFunction.ajaxCall(eventFunction.config);
                        eventFunction.getLaundryList();
                    }
                    else {
                        eventFunction.getLaundryList();
                    }

                });
            },
            Savelaundry: function () {
                var obj = {};
                obj.ID = eventFunction.config.laundryMasterID;
                obj.RoomTypeID = ($("#ddlRoomType").val());
                obj.RoomID = ($("#ddlRoom").val());
                obj.CustomerID = ($("#ddlCustomerID").val());
                obj.Date = ($("#txtDate").val());
                obj.DeliveryDate = ($("#txtDeliveryDate").val());
                obj.ChallanNo = ($("#txtChallanNo").val());
                obj.HouseKeeperID = ($("#ddlHouseKeeperID").val());
                obj.IsDelivered = ($("#chkDelivered").is(':checked'));
                obj.Amount = ($("#txtAmount").val());
                obj.DiscountType = ($("#discType").val());
                obj.Discount = ($("#txtDiscount").val());
                obj.Total = ($("#txtGrandTotal").val());
                //ctl.AddLaundry(obj);


                var rowCount = $('#tblForTempLaundry tbody tr').length;
                var ColCount = $('.tblForTempLaundry tbody tr td').length / rowCount;
                laundryDetails = new Array;
                for (var i = 1; i < rowCount; i++) {
                    //for (var j = 0; j < ColCount; i++)
                    {
                        laundryDetail = {
                            ClothID: parseInt($('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(0)').attr('id')),
                            MaterialID: parseInt($('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(1)').attr('id')),
                            //Color: $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(2)').text(),
                            Color: "",
                            Description: $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(2)').text(),
                            LaundryTypeID: parseInt($('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(3)').attr('id')),
                            Quantity: parseInt($('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(4)').text()),
                            Rate: $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(5)').text(),
                            IsDelivered: $('#tblForTempLaundry tbody').find('tr:eq(' + i + ')').find('td:eq(7)').text(),
                        }
                        // row.find('td:eq(' + i + ')').text();
                    }
                    laundryDetails.push(laundryDetail);
                }
                obj.laundryDetails = laundryDetails;
                eventFunction.config.method = "SaveLaundry";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ laundry: obj });
                if (eventFunction.config.laundryUpdate == 1){
                    eventFunction.config.ajaxCallMode = 6;
                }
                else {
                    eventFunction.config.ajaxCallMode = 0;
                }
                eventFunction.ajaxCall(eventFunction.config);
            },

            Reset: function () {
                window.location.reload(true);
                //eventFunction.InitialSetup();
                //$("#addForm").hide();
                //$("#divLaundryList").show();
                //$("#filterbox").show();
                //$("#dvAddBtn").show();
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        JEDescription: {
                            required: true,
                        },
                       
                    },
                    messages: {
                        JEDescription: {
                            required: "Enter challan no",
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
