(function ($) {
    var tabs = $("#tabs").tabs();
    $.HouseKeepingFunction = function (p) {
        p = $.extend
             ({
                 PortalID: '',
                 UserModuleID: '',
                 CultureCode: '',
                 UserName: '',
                 ModulePath: '/Modules/HouseKeeping/',
             }, p);

        var v = 0;
        var HouseKeeping = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
            },
            InitialSetup: function () {

            },

            init: function () {
                HouseKeeping.DropDownRooms();
                HouseKeeping.GetItem();
                $('#container').hide();
                $('#btnAdd').show();
                $('#bindOutOfOrder').show();

                $("#btnAdd").on("click", function () {
                    //HouseKeeping.ResetAll();
                    $('#btnAdd').hide();
                    $('#btnEdit').hide();
                    $('#container').show();
                    $('#bindOutOfOrder').hide();
                    $('#btnSave').show();
                });

                $('#btnSave').on("click", function () {

                    if ($("#dropDownRoom").val() == "") {
                        alert("Please Select Room Type.")
                    }
                    else if ($("#txtStatus").val() == "") {
                        alert("Please give Status.")
                    }
                    else if ($("#txtFromDate").val() == "") {
                        alert("Please Fill Date.")
                    }
                    else if ($("#txtReturnAs").val() == 0) {
                        alert("Please provide Return As.")
                    }
                    else if ($("#txtThroughDate").val() == 0) {
                        alert("Please Fill Date.")
                    }
                    else if ($("#txtReason").val() == 0) {
                        alert("Please provide Reason.")
                    }
                    else if ($("#txtRemarks").val() == 0) {
                        alert("Please give Remarks.")
                    }
                        //alert("hello world");
                    else {
                        // HouseKeeping.Savelaundry();

                        HouseKeeping.SaveOutOfOrder();
                        $('#btnAdd').show();
                        $('#container').hide();
                        HouseKeeping.ResetAll();
                    }
                });

                $('#btnCancel').on("click", function () {
                    $('#btnAdd').show();
                    $('#container').hide();
                    $('#bindOutOfOrder').show();
                    HouseKeeping.ResetAll();
                });

                $('#btnEdit').on("click", function () {
                    HouseKeeping.SaveOutOfOrder();

                    $('#btnAdd').show();
                    $('#btnSave').show();
                    $('#container').hide();
                    $("#bindOutOfOrder").show();
                    HouseKeeping.ResetAll();
                });

                $("#dropDownRoom").change(function () {
                    
                    Roomvalue = $('#dropDownRoom').val();
                    HouseKeeping.config.method = "GetRoomNameByID";
                    HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                    HouseKeeping.config.data = JSON.stringify({ Roomvalue: Roomvalue });
                    HouseKeeping.config.ajaxCallMode = 6;
                    HouseKeeping.ajaxCall(HouseKeeping.config);

                });
            },

            ajaxCall: function (config) {
                $.ajax({
                    type: HouseKeeping.config.type,
                    contentType: HouseKeeping.config.contentType,
                    async: HouseKeeping.config.async,
                    cache: HouseKeeping.config.cache,
                    url: HouseKeeping.config.url,
                    data: HouseKeeping.config.data,
                    dataType: HouseKeeping.config.dataType,
                    success: HouseKeeping.ajaxSuccess,
                    error: HouseKeeping.ajaxFailure
                });
            },

            ajaxSuccess: function (data) {
                switch (parseInt(HouseKeeping.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        alert("Inserted successfully");
                        HouseKeeping.GetItem();
                        break;
                    case 2:
                        HouseKeeping.BindDataById(data);
                        break;
                    case 3:
                        alert("Deleted successfully");
                        HouseKeeping.GetItem();
                        break;
                    case 4:
                        HouseKeeping.BindData(data);
                        break;
                    case 5:
                        HouseKeeping.BindDDRooms(data);
                        break;
                    case 6:
                        HouseKeeping.BindDDRoomName(data);
                }
            },
            ajaxFailure: function () {
                //switch (parseInt(HouseKeeping.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>


            SaveOutOfOrder: function () {
                
                var obj = {
                    OutOfOrderID: $('#txtID').val(),
                    RoomID: $('#dropDownRoom').val(),
                    OO_Status: $('#txtStatus').val(),
                    FromDate: $('#txtFromDate').val(),
                    ThroughDate: $('#txtThroughDate').val(),
                    ReturnAs: $('#txtReturnAs').val(),
                    Reason: $('#txtReason').val(),
                    OO_Remarks: $('#txtRemarks').val()
                };

                if ($("#txtchkOrder").is(':checked')) {
                    obj.IsOutOfOrder = true;
                } else {
                    obj.IsOutOfOrder = false;
                }
                if ($("#txtchkService").is(':checked')) {
                    obj.IsOutOfService = true;
                } else {
                    obj.IsOutOfService = false;
                }

                HouseKeeping.config.method = "SaveOutOfOrder";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ obj: obj });
                HouseKeeping.config.ajaxCallMode = 1;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            GetItem: function () {
                
                //LostAndFoundID, PortalID, UserModuleID, CultureCode
                HouseKeeping.config.method = "GetOutOfOrder";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data
                HouseKeeping.config.ajaxCallMode = 4;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },



            DeleteItem: function (Oid) {
                HouseKeeping.config.method = "DeleteOutOfOrder";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ Oid: Oid });
                HouseKeeping.config.ajaxCallMode = 3;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            DropDownRooms: function () {
                HouseKeeping.config.method = "GetRooms";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 5;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            GetItemByID: function (Oid) {
                
                //LostAndFoundID, PortalID, UserModuleID, CultureCode
                HouseKeeping.config.method = "GetOrderItemByID";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON2.stringify({ OutOfOrderID: Oid });
                HouseKeeping.config.ajaxCallMode = 2;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            //getLostNFoundreport: function () {
            //    var StartDate = $("#txtStartDate").val();
            //    var EndDate = $("#txtEndDate").val();
            //    HouseKeeping.config.method = "getLostNFoundreport";
            //    HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
            //    HouseKeeping.config.data = JSON.stringify({ StartDate: StartDate, EndDate: EndDate });
            //    HouseKeeping.config.data = HouseKeeping.config.data;
            //    HouseKeeping.config.ajaxCallMode = 7;
            //    HouseKeeping.ajaxCall(HouseKeeping.config);
            //},



            ////<<-----------------------------------BindTable Here ------------------------------------->>>


            BindData: function (result) {
                
                $('#btnEdit').show();
                $("#bindOutOfOrder").show();
                $("#bindOutOfOrder").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var htmls = "<table id='OutOfOrderlisting' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Room Type</th><th>Status</th><th>FromDate</th><th>ThroughDate</th><th>ReturnAs</th><th>Reason</th><th>Remarks</th><th>Edit</th><th>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td >" + count + "</td>";
                        htmls += "<td >" + value.RoomType + "</td>";
                        htmls += "<td >" + value.OO_Status + "</td>";
                        htmls += "<td>" + value.FromDate + "</td>";
                        htmls += "<td >" + value.ThroughDate + "</td>";
                        htmls += "<td >" + value.ReturnAs + "</td>";
                        htmls += "<td >" + value.Reason + "</td>";
                        htmls += "<td >" + value.OO_Remarks + "</td>";
                        //htmls += "<td >" + value.IsOutOfOrder + "</td>";
                        //htmls += "<td >" + value.IsOutOfService + "</td>";
                        htmls += "<td ><img src='/images/edit.png' input type='button' id='OO_" + value.OutOfOrderID + "_" + value.RoomID + "_" + value.OO_Status + "_" + value.FromDate + "_" + value.ThroughDate + "_" + value.ReturnAs + "_" + value.Reason + "_" + value.OO_Remarks + "_" + value.IsOutOfOrder + "_" + value.IsOutOfService + "' class='OO_edit icon-edit' value='Edit'></td>";
                        htmls += "<td><img src='/images/delete.png' input type='button' id='OODel_" + value.OutOfOrderID + "' class='OODelete' value='Delete'></td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<thead>"
                    htmls += "</thead>"
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#bindOutOfOrder').html(htmls);

                    $('#OutOfOrderlisting').on('click', '.OO_edit', function () {
                        
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var Oid = findId[1];
                        HouseKeeping.GetItemByID(Oid);

                        //var ORoomType = findId[2];
                        //var OStatus = findId[3];
                        //var OFromDate = findId[4];
                        //var OThroughDate = findId[5];
                        //var OReturnAs = findId[6];
                        //var OReason = findId[7];
                        //var ORemarks = findId[8];
                        //var OOutOfOrder = findId[9];
                        //var OOutOfService = findId[10];


                    });

                    $('#OutOfOrderlisting').on('click', '.OODelete', function () {
                        
                        if (confirm("Delete! Are You Sure?")) {

                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var Oid = findId[1];
                    //    jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                            //jAlert('Confirmed: ' + r, 'Confirmation Results');
                          //  if (r) {
                        HouseKeeping.DeleteItem(Oid);
                            }
                       // });
                    });
                    $('#OutOfOrderlisting').dataTable(
                    {
                       "jQueryUI": true,
                        ordering: false,
                        dom: 'Bfrtip',
                        buttons: [
                            'print', 'excel', 'pdf'
                        ]
                    }
                );

                }
                else {
                    $('#bindOutOfOrder').html('No data');
                }
            },
            BindDataById: function (result) {
                $("#btnEdit").hide();
                
                var datas = result.d;
                $.each(datas, function (index, value) {

                    $("#bindOutOfOrder").hide();
                    $('#btnAdd').hide();
                    $('#container').show();
                    $('#btnSave').show();
                    $('#txtID').val(value.OutOfOrderID);
                    $('#dropDownRoom').val(value.RoomID);
                    $('#txtStatus').val(value.OO_Status);
                    $('#txtFromDate').val(value.FromDate);
                    $('#txtThroughDate').val(value.ThroughDate);
                    $('#txtReturnAs').val(value.ReturnAs);
                    $('#txtReason').val(value.Reason);
                    $('#txtRemarks').val(value.OO_Remarks);
                  //  $('#txtchkOrder').val(value.IsOutOfOrder);
                    //$('#txtchkService').val(value.IsOutOfService);

                    var boolOrder = value.IsOutOfOrder;
                    if (boolOrder == true) {
                        $("#txtchkOrder").prop('checked', true);
                    }
                    var boolService = value.IsOutOfService;
                    if (boolService == true) {
                        $("#txtchkService").prop('checked', true);
                    }
                });
            },

            BindDDRooms: function (result) {
                $("#dropDownRoom").show();
                $("#dropDownRoom").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var html2 = '';
                    html2 = "<option value='' selected>All</option>";
                    $.each(datas, function (index, value) {
                        html2 += "<option value ='" + value.RoomID + "'>" + value.RoomType + " </option>";
                    });
                    $('#dropDownRoom').html(html2);
                }
            },

            BindDDRoomName: function (result) {
                
                var datas = result.d;

                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        $('#ddRoomName').val(value.Roomvalue);
                    });
                }
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            //OutOfOrderID: $('#txtID').val(),
            //RoomType: $('#dropDownRoom').val(),
            //OO_Status: $('#txtStatus').val(),
            //FromDate: $('#txtFromDate').val(),
            //ThroughDate: $('#txtThroughDate').val(),
            //ReturnAs: $('#txtReturnAs').val(),
            //Reason: $('#txtReason').val(),
            //OO_Remarks: $('#txtRemarks').val(),
            // obj.IsOutOfOrder = false;
            //obj.IsOutOfService = true;

            ResetAll: function () {
                $('#txtID').val(0);
                $('#dropDownRoom').val('');
                $('#txtStatus').val('');
                $('#txtFromDate').val('');
                $('#txtThroughDate').val('');
                $('#txtReturnAs').val('');
                $('#txtReason').val('');
                $('#txtRemarks').val('');
                $('#txtchkOrder').val('');
                $('#txtchkService').val('');
            },
        };
        HouseKeeping.init();
    };
    $.fn.MainHouseKeeping = function (p) {
        $.HouseKeepingFunction(p);
    };
})(jQuery);
