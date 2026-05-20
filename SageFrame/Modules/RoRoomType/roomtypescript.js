(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RoRoomType/',
             }, p);
        var editRoomName = "";
        var tableCount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "RoRoomTypeWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                roomTypeID: 0,
                roomTypeUpdate: 0


            },
            InitialSetup: function () {
                
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

        

                $("#btnRoomTypeAdd").on('click', function () {
                    $("#tblroom").show();
                    $("#btnRoomTypeAdd , .thbg").hide();
                });
                $("#btnRoomTypeCancel").on('click', function () {
                    $(".thbg").show();
                    eventFunction.reset()
                });

                $("#btnRoomTypeSave").unbind('click').on('click', function () {

                    
                    if ($('#lblFortxtTitle').text() != "") {
                        jAlert('Room Title Already Exists. Type another Room Title.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    } else if ($('#txtTitle').val()=="" ){
                        jAlert('Empty Room Title.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    
                    } else {
                        $(".thbg").show();
                        eventFunction.SaveRoomType();
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
                        break;
                    case 1:
                        eventFunction.BindRoomType(data.d);
                        break;
                    case 2:
                        jAlert('Inserted Successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        alert("Inserted Successfully .....");
                        eventFunction.reset();
                        eventFunction.GetRoomType();
                        break;
                    case 3:
                        jAlert('Updated Successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.reset();
                        eventFunction.GetRoomType();
                        break;
                    case 4:
                        tableCount = data.d;
                        break;
                    case 5:
                        jAlert('Deleted Successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.GetRoomType();
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            
            GetRoomType: function () {
                eventFunction.config.method = "GetRoomType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SaveRoomType: function () {
                var roomtype = {};
                roomtype.RoomTypeID = eventFunction.config.roomTypeID;
                roomtype.Title = $("#txtTitle").val();
                roomtype.Description = $("#txtDescription").val();
                roomtype.InsertedBy = "";
                roomtype.UpdateBy = "";
                roomtype.DeleteBy = "";

                eventFunction.config.method = "SaveRoomType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ restroroomtype: roomtype });
                if(eventFunction.config.roomTypeID==0)
                    eventFunction.config.ajaxCallMode = 2;
                else
                    eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);

            },

            GetDependency: function (roomTypeID) {
                eventFunction.config.method = "GetDependency";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ roomtypeid: roomTypeID });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteRoomType: function (roomTypeID) {
                eventFunction.config.method = "DeleteRoomType";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ roomtypeid: roomTypeID });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteRoomAndTables: function (roomTypeID) {
                eventFunction.config.method = "deleteRoomAndTables";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ roomtypeid: roomTypeID });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindRoomType: function (data) {
                $("#divGrid").html('');
               
                datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<table id='gvRoomType' class='sfGridwrapper dataTable display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th class='edit-heading' style='width:20px;'>S.N.</th><th>Room Type</th><th>Description</th><th class='edit-heading' style='width:20px;'>Edit</th><th class='delete-heading' style='width:20px;'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var sn = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + sn + "</td>";
                        htmls += "<td>" + value.Title + "</td>";
                        htmls += "<td>" + value.Description + "</td>";
                        htmls += "<td><label id='" + value.RoomTypeID + "_" + value.Title + "_" + value.Description + "' class='icon-edit ItemEdit'></label></td>"
                        htmls += "<td><label id='" + value.RoomTypeID + "' class='icon-delete ItemDelete'></label></td>"
                        htmls += "</tr>"
                        sn++;

                    });
                } else {
                    $('#divGrid').html('No data');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#divGrid').html(htmls);
                    $('#gvRoomType').DataTable({
                        "jQueryUI": true,
                        columnDefs: [{ orderable: false, targets: [0, 2,3,4] }],
                
                    });

              
                

                $("#gvRoomType").on('click', '.ItemEdit', function () {
                    $("#btnRoomTypeAdd , .thbg").hide();
                    $("#btnRoomTypeSave").text("Update");
                    $("#tblroom").show();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    eventFunction.config.roomTypeID = words[0];
                    $("#txtTitle").val(words[1]);
                    $("#txtDescription").val(words[2]);
                    editRoomName = words[1];
                    eventFunction.config.roomTypeUpdate = 1;
                });

                $("#gvRoomType").on('click', '.ItemDelete', function () {
                    var ids = $(this).attr('id');
                    eventFunction.GetDependency(ids);
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            if (tableCount > 0) {
                                jConfirm('There are Tables in this Room which will be deleted. Are You Sure  ?', 'Delete', function (confirmed) {
                                    if (confirmed) {
                                        eventFunction.DeleteRoomAndTables(ids);
                                    }
                                });
                            } else {
                                eventFunction.DeleteRoomType(ids);
                            }
                        }
                    });
                });
            },

            reset: function(){
              
                $("#txtTitle").val("");
                $("#txtDescription").val("");
                $("#tblroom").hide();
                $("#btnRoomTypeAdd").show();

                $("#btnRoomTypeSave").text("Save");
                eventFunction.config.roomTypeID = 0;
                eventFunction.config.roomTypeUpdate = 0;
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
