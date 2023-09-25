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
                async: false,
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
                $('#BindValues').show();

                $("#btnAdd").on("click", function () {
                    //HouseKeeping.ResetAll();
                    $('#btnAdd').hide();
                    $('#btnEdit').hide();
                    $('#container').show();
                    $('#BindValues').hide();
                    $('#btnSave').show();
                });

                $('#btnSave').on("click", function () {

                    if ($("#dropDownRooms").val() == "" || $("#dropDownRooms").val() == 0 ) {
                        alert("Please Select Room.")
                    }
                    else if ($("#txtDate").val() == "") {
                        alert("Please Fill Date.")
                    }
                    else if ($("#txtGName").val() == "") {
                        alert("Please give Customer Name.")
                    }
                    else if ($("#txtItem").val() == 0) {
                        alert("Please provide the item lost.")
                    }
                        //alert("hello world");
                    else {
                        // HouseKeeping.Savelaundry();

                        HouseKeeping.SaveLostAndFound();
                        $('#btnAdd').show();
                        $('#container').hide();
                        HouseKeeping.ResetAll();
                    }
                });

                $('#btnCancel').on("click", function () {
                    $('#btnAdd').show();
                    $('#container').hide();
                    $('#BindValues').show();
                    HouseKeeping.ResetAll();
                });

                $('#btnEdit').on("click", function () {
                    HouseKeeping.SaveLostAndFound();

                    $('#btnAdd').show();
                    $('#btnSave').show();
                    $('#container').hide();
                    $("#BindValues").show();
                    HouseKeeping.ResetAll();
                });

                $("#dropDownRooms").change(function () {
                    restroRoomID = $('#dropDownRooms').val();
                    HouseKeeping.config.method = "GetRoomsByRoomID";
                    HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                    HouseKeeping.config.data = JSON.stringify({ restroRoomID: restroRoomID });
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
                        //case 2:
                        //    HouseKeeping.BindUpdateData(data);
                        //    break;
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


            SaveLostAndFound: function () {
                
                var obj = {
                    LF_ID: $('#txtID').val(),
                    RoomType: $('#ddRoomName').find("option:selected").text(),
                    Room: $('#dropDownRooms').find("option:selected").text(),
                    Date: $('#txtDate').val(),
                    Guest_Name: $('#txtGName').val(),
                    Item_Name: $('#txtItem').val()
                };
                var selectedVal = "";
                var selected = $("input[type='radio'][name='lostAndFound']:checked");
                if (selected.length > 0) {
                    selectedVal = selected.val();
                }

                obj.Type = selectedVal;

                HouseKeeping.config.method = "SaveLostAndFound";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ obj: obj });
                HouseKeeping.config.ajaxCallMode = 1;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            GetItem: function () {
                
                //LostAndFoundID, PortalID, UserModuleID, CultureCode
                HouseKeeping.config.method = "GetLostAndFound";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data
                HouseKeeping.config.ajaxCallMode = 4;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },


            //GetItem: function (LostAndFoundID, PortalID, UserModuleID, CultureCode) {
            //    
            //    //LostAndFoundID, PortalID, UserModuleID, CultureCode
            //    HouseKeeping.config.method = "GetLostAndFoundInfo";
            //    HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
            //    HouseKeeping.config.data = JSON2.stringify({
            //        LostAndFoundID: LostAndFoundID,
            //        PortalID: PortalID,
            //        UserModuleID: UserModuleID,
            //        CultureCode: CultureCode
            //    });
            //    HouseKeeping.config.ajaxCallMode = 4;
            //    HouseKeeping.ajaxCall(HouseKeeping.config);
            //},


            DeleteItem: function (LF_ID) {
                HouseKeeping.config.method = "DeleteLostAndFound";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ LF_ID: LF_ID });
                HouseKeeping.config.ajaxCallMode = 3;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            DropDownRooms: function () {
                HouseKeeping.config.method = "GetRoomName";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 5;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            getLostNFoundreport: function () {
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtEndDate").val();
                HouseKeeping.config.method = "getLostNFoundreport";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ StartDate: StartDate, EndDate: EndDate });
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 7;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },



            ////<<-----------------------------------BindTable Here ------------------------------------->>>


            BindData: function (result) {
                
                $('#btnEdit').show();
                
                $("#BindValues").show();
                $("#BindValues").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var htmls = "<table id='LostAndFoundlisting' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Room Type</th><th>Room</th><th>Date</th><th>Guest Name</th><th>Type</th><th>Item Name</th><th class='tdcenter'>Edit</th><th class='tdcenter'>Delete</th>";

                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td >" + count + "</td>";
                        htmls += "<td >" + value.RoomType + "</td>";
                        htmls += "<td >" + value.Room + "</td>";
                        htmls += "<td>" + value.Date + "</td>";
                        htmls += "<td >" + value.Guest_Name + "</td>";
                        htmls += "<td >" + value.Type + "</td>";
                        htmls += "<td >" + value.Item_Name + "</td>";
                        htmls += "<td class='tdcenter'><img src='/images/edit.png' input type='button' id='LF_" + value.LF_ID + "_" + value.RoomType + "_" + value.Room + "_" + value.Date + "_" + value.Guest_Name + "_" + value.Type + "_" + value.Item_Name + "' class='LF_edit icon-edit' value='Edit'><td>";
                        htmls += "<img src='/images/delete.png' input type='button' id='LFDel_" + value.LF_ID + "' class='LFDelete' value='Delete'></td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<thead>"

                    htmls += "</thead>"

                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#BindValues').html(htmls);

                    $('#LostAndFoundlisting').on('click', '.LF_edit', function () {
                        
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var Lid = findId[1];
                        var LRoomType = findId[2];
                        var LRoom = findId[3];
                        var LDate = findId[4];
                        var LGuestName = findId[5];
                        var LType = findId[6];
                        var LItem = findId[7];


                        $("#BindValues").hide();
                        $('#btnAdd').hide();
                        $('#container').show();
                        $('#btnSave').show();
                        $('#txtID').val(Lid);
                        $('#dropDownRooms').val(LRoomType);
                        $('#ddRoomName').val(LRoom);
                        $('#txtDate').val(LDate);
                        $('#txtGName').val(LGuestName);
                        $('#txtItem').val(LItem);

                        //   if (LType != '') {
                        //$("input[name=lostAndFound]").val(LType);
                        $("input[name=lostAndFound][value=" + LType + "]").attr('checked', true);
                        //  }

                        //if (LType == 'Missing') {
                        //    $('#radMissing').attr("checked", "checked");
                        //}
                        //else {
                        //    $('#radFound').attr("checked", "checked");
                        //}

                    });

                    $('#LostAndFoundlisting').on('click', '.LFDelete', function () {
                        
                        if (confirm("Delete! Are You Sure?")) {

                            var id = $(this).attr('id');
                            var findId = id.split('_');
                            var LF_ID = findId[1];
                            //jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                            //jAlert('Confirmed: ' + r, 'Confirmation Results');
                            //   if (r) {
                            HouseKeeping.DeleteItem(LF_ID);
                        }
                    });
                    $('#LostAndFoundlisting').dataTable(
                    {
                       "Jquery UI" : true,
                        ordering: false,
                        dom: 'Bfrtip',

                        buttons: [
                            'print', 'excel', 'pdf'
                        ]
                    }
                );

                }
                else {
                    $('#BindValues').html('No data');
                }
            },

            BindDDRooms: function (result) {
                $("#dropDownRooms").show();
                $("#dropDownRooms").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var html2 = '';
                    html2 = "<option value=0 selected>All</option>";
                    $.each(datas, function (index, value) {
                        html2 += "<option value ='" + value.RoomTypeID + "'>" + value.Roomvalue + " </option>";
                    });
                    $('#dropDownRooms').html(html2);
                }
            },

            BindDDRoomName: function (result) {
                //var datas = result.d;

                //if (datas.length > 0) {
                //    $.each(datas, function (index, value) {
                //        $('#ddRoomName').val(value.RoomType);
                //    });
                //}

                $('#ddRoomName').show();
                $('#ddRoomName').html('');
                var datas = result.d;
                if (datas.length > 0) {
                    var html2 = '';
                    html2 = "<option value='' selected>All</option>";
                    $.each(datas, function (index, value) {
                        html2 += "<option value =' " + value.RoomID + "'>" + value.RoomType + " </option>";
                    });
                    //Roomlist = html2;
                    $('#ddRoomName').html(html2);
                }
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $('#txtID').val(0);
                $('#dropDownRooms').val('');
                $('#ddRoomName').val('');
                $('#txtDate').val('');
                $('#txtGName').val('');
                $('#txtItem').val('');

                $("input:radio").attr("checked", false);
            },
        };
        HouseKeeping.init();
    };
    $.fn.MainHouseKeeping = function (p) {
        $.HouseKeepingFunction(p);
    };
})(jQuery);