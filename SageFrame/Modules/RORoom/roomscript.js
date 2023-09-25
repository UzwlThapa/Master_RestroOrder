(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RORoom/',
             }, p);
        var editRoomName = "";
        var tableCount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "RORoomWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                roomID: 0,
                roomUpdate: 0


            },
            InitialSetup: function () {

                eventFunction.GetRooms();
                eventFunction.GetRoomType();
            },
            init: function () {
                eventFunction.InitialSetup();

                $("#txtRoom").focusout(function () {
                    var values = $('#txtRoom').val();
                    if (editRoomName != values || editRoomName == "") {
                        $.ajax({
                            type: "POST",
                            url: "/Modules/RORoom/RORoomWebService.asmx/DoesRoomNameExist",
                            data: JSON.stringify({ roomName: values }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (msg) {

                                $("#lblFortxtRoom").show();
                                $("#lblFortxtRoom").text(msg.d);

                            }
                        });
                    } else {
                        $("#lblFortxtRoom").hide();
                    }

                });
             
                $("#btnadd").on('click', function () {
                    $("#tbl1").show();
                    $("#btnadd , .thbg").hide();
                });
                $("#btncancel").on('click', function () {
                      $(".thbg").show();
                      eventFunction.reset();
                   

                });

                $("#btnsave").unbind('click').on('click', function () {
                    
                    if ($('#lblFortxtRoom').text() != "") {
                        jAlert('Room Name Already Exists. Type another Room Name.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                    else if ($('#txtRoom').val() == "") {
                        jAlert('Empty Restro Room.', 'Alert!!', function () { $.alerts.dialogClass = null; });

                    } else if ($('#ddlRoomType').val() == "" || $('#ddlRoomType').val() == null) {
                        jAlert('Select Room Type.', 'Alert!!', function () { $.alerts.dialogClass = null; });

                    } else {
                           $(".thbg").show();
                        eventFunction.SaveRoom();
                    }
                    //eventFunction.reset()
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
                        eventFunction.BindRooms(data.d);
                        break;
                    case 1:
                        eventFunction.BindRoomType(data.d);
                        break;
                    case 2:
                        jAlert('Inserted Successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.reset();
                        eventFunction.GetRooms();

                        break;
                    case 3:
                        jAlert('Updated Successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.reset();
                        eventFunction.GetRooms();

                        break;
                    case 4:
                        tableCount = data.d;
                        break;
                    case 5:
                        jAlert('Deleted Successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.reset();
                        eventFunction.GetRooms();

                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetRooms: function () {
                eventFunction.config.method = "GetRooms";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetRoomType: function () {
                eventFunction.config.method = "GetRoomType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SaveRoom: function () {
                var room = {};
                room.restroRoomId = eventFunction.config.roomID;
                room.restroRoom = $("#txtRoom").val();
                room.RoomTypeID = $("#ddlRoomType").val();

                eventFunction.config.method = "SaveRoom";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ restroroom: room });
                if (eventFunction.config.roomID == 0)
                    eventFunction.config.ajaxCallMode = 2;
                else
                    eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);

            },

            GetDependency: function (roomid) {
                eventFunction.config.method = "GetDependency";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ roomid: roomid });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteRoom: function (roomid) {
                eventFunction.config.method = "DeleteRoom";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ roomid: roomid });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteRoomAndTables: function (roomid) {
                eventFunction.config.method = "deleteRoomAndTables";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ roomid: roomid });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindRoomType: function (result) {
                rommlist = JSON.parse(result);
                if (rommlist.length > 0) {
                    var htmls = "";
                    htmls += "<option value='' selected disabled>--Select--</option>";
                    $.each(rommlist, function (index, value) {
                        htmls += "<option value='" + value.RoomTypeID + "'>" + value.Title + "</option>";
                    });

                    $("#ddlRoomType").html(htmls);
                }
            },
            BindRooms: function (data) {
                $("#divGrid").html('');
                datas = JSON.parse(data);
                var htmls = "<table id='gdvRestroRoom' class='sfGridwrapper dataTable display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th class='edit-heading' style='width:20px;'>S.N.</th><th>Room Name</th><th>Room Type</th><th class='edit-heading' style='width:20px;'>Edit</th><th class='delete-heading' style='width:20px;'>Delete</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                 
                    var sn = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + sn + "</td>";
                        htmls += "<td>" + value.restroRoom + "</td>";
                        htmls += "<td>" + value.RoomType + "</td>";
                        htmls += "<td><label id='" + value.restroRoomId + "_" + value.restroRoom + "_" + value.RoomType + "_" + value.RoomTypeID + "' class='icon-edit ItemEdit'></label></td>"
                        htmls += "<td><label id='" + value.restroRoomId + "' class='icon-delete ItemDelete'></label></td>"
                        //htmls += "<td>" + "<img src='/images/edit.png' class='ItemEdit'  type='button'  id='" + value.restroroomId + "_" + value.restroRoom + "_" + value.RoomType + "' value='Edit' /></td>";
                        //htmls += "<td>" + "<img src='/images/delete.png' class='ItemDelete' type='button'  id=_" + value.restroroomId + " value='Delete' /></td></tr>";
                        htmls += "</tr>"
                        sn++;

                    });
                } else {
                    $('#divGrid').html('No Data Available');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#divGrid').html(htmls);
                    $('#gdvRestroRoom').DataTable({
                        "jQueryUI": true,
                         "autoWidth": false,
                        columnDefs: [{ orderable: false, targets: [ 0,3,4] }],
                    
                    });
                    

         

                    $('#gdvRestroRoom').on('click', '.ItemEdit', function () {
                        $("#btnadd, .thbg").hide();
                        $("#btnsave").text("Update");
                        $("#tbl1").show();
                        var ids = $(this).attr('id');
                        var words = ids.split('_');
                        eventFunction.config.roomID = words[0];
                        $("#txtRoom").val(words[1]);
                        $("#ddlRoomType").val(words[3]);
                        editRoomName = words[1];
                        eventFunction.config.roomUpdate = 1;
                    });

                    $('#gdvRestroRoom').on('click', '.ItemDelete', function () {

                        var ids = $(this).attr('id');
                        eventFunction.GetDependency(ids);
                        jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                            if (confirmed) {
                                if (tableCount > 0) {
                                    jConfirm('There are Tables in this Room which will be deleted. Do you want to delete?  ?', 'Delete', function (confirmed) {
                                        if (confirmed) {
                                            eventFunction.DeleteRoomAndTables(ids);
                                        }
                                    });
                                } else {
                                    eventFunction.DeleteRoom(ids);
                                }
                            }
                        });
                    });

            },

            reset: function () {
                
                $("#txtRoom").val("");
                $("#ddlRoomType").val("");
                $("#tbl1").hide();
                $("#btnadd").show();

                $("#btnsave").text("Save");

                eventFunction.config.roomID = 0;
                eventFunction.config.roomUpdate = 0;
            },
            ValidationForm: function () {
                var v = $('#form').validate({
                    rules: {

                        ////StoreItem
                        textItemName: {
                            required: true,
                        },


                    },
                    messages: {
                        textItemPrice: {
                            number: 'Price must be number'

                        }
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