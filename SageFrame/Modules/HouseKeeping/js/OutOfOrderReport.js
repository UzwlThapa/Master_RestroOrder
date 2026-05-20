(function ($) {
    var tabs = $("#tabs").tabs();
    $.HouseKeepingFunction = function (p) {
        p = $.extend
			 ({
			     PortalID: '',
			     ModulePath: '/Modules/HouseKeeping/',
			 }, p);

        var v = 0;
        var logoInfo = 0;
        var PrintValue = " ";
        var Roomlist = "";
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
                HouseKeeping.DropDownRoomType();
               // HouseKeeping.DropDownRoomClass();
                HouseKeeping.GetOOReport(0, 0, '', '', 0, 0);

                $('#container').show();
                $('#btnPrint').click(function () {
                    logoInfo += PrintValue;
                    HouseKeeping.print(logoInfo);
                });

                $('#btnView').click(function () {
                    
                    var RoomID = $("#dropDownRooms").val();
                    var RoomTypeID = $('#ddRoomName').val();
                    var RoomClass = ""; //$("#ddRoomClass").val();
                    var StartDate = $("#txtStartDate").val();

                    if ($("#txtchkOrder").is(':checked')) {
                        IsOutOfOrder = 1;
                    } else {
                        IsOutOfOrder = 0;
                    }
                    if ($("#txtchkService").is(':checked')) {
                        IsOutOfService = 1;
                    } else {
                        IsOutOfService = 0;
                    }

                    HouseKeeping.GetOOReport(RoomID, RoomTypeID, RoomClass, StartDate, IsOutOfOrder, IsOutOfService);
                });

                //$("#dropDownRooms").change(function () {
                //    
                //    Roomvalue = $('#dropDownRooms').val();
                //    if (Roomvalue == 0) {
                //        $('#ddRoomName').val('');
                //    }
                //    else {

                //    }
                //    HouseKeeping.config.method = "GetRoomNameByID";
                //    HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                //    HouseKeeping.config.data = JSON.stringify({ Roomvalue: Roomvalue });
                //    HouseKeeping.config.ajaxCallMode = 5;
                //    HouseKeeping.ajaxCall(HouseKeeping.config);

                //});
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
                        $('#btnView').click();
                        // HouseKeeping.GetOOReport(0, 0,'', '', 0, 0);
                        break;

                    case 2:
                        HouseKeeping.BindDataById(data);
                        break;

                    case 3:
                        alert("Deleted successfully");
                        HouseKeeping.GetOOReport(0, 0, '', '', 0, 0);
                        break;

                    case 4:
                        HouseKeeping.BindData(data);
                        break;

                    case 5:
                        // alert("Updated successfully");
                        HouseKeeping.BindDDRoomName(data);
                        break;

                    case 6:
                        HouseKeeping.BindDDRoomClass(data);
                        break;

                    case 7:
                        HouseKeeping.BindDDRooms(data);
                        break;

                    case 8:
                        HouseKeeping.BindDataByIdforView(data);
                        break;

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

            //SaveHouseKeeping: function () {
            //    var obj = {

            //        HK_ID: $('#txtHKID').val(),
            //        RoomType: $('#dropDownRooms').val(),
            //        RoomStatus: $('#dropDownStatus1').val(),
            //        Availability: $('#txtAvailability').val(),
            //        Remarks_HK: $('#txtRemarks').val(),
            //        AssignTo: $('#dropDownAssign1').val()
            //    };

            //    HouseKeeping.config.method = "SaveMainHouseKeeping";
            //    HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
            //    HouseKeeping.config.data = JSON.stringify({ obj: obj });
            //    HouseKeeping.config.ajaxCallMode = 1;
            //    HouseKeeping.ajaxCall(HouseKeeping.config);
            //},

            GetOOReport: function (RoomID, RoomTypeID, RoomClass, StartDate, IsOutOfOrder, IsOutOfService) {
                HouseKeeping.config.method = "getOOReport";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ RoomID: RoomID, RoomTypeID: RoomTypeID, RoomClass: RoomClass, StartDate: StartDate, IsOutOfOrder: IsOutOfOrder, IsOutOfService: IsOutOfService });
                HouseKeeping.config.ajaxCallMode = 4;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            GetItemByID: function (Oid) {
                HouseKeeping.config.method = "GetOrderItemByID";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON2.stringify({ OutOfOrderID: Oid });
                HouseKeeping.config.ajaxCallMode = 2;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            GetItemByIDforView: function (Oid) {
                HouseKeeping.config.method = "GetOrderItemByID";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON2.stringify({ OutOfOrderID: Oid });
                HouseKeeping.config.ajaxCallMode = 8;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            DropDownRoomClass: function () {
                HouseKeeping.config.method = "getRoomClassList";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 6;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            DropDownRooms: function () {
                HouseKeeping.config.method = "GetRooms";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 7;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            DropDownRoomType: function () {

                HouseKeeping.config.method = "GetRoomName";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 5;
                HouseKeeping.ajaxCall(HouseKeeping.config);

            },

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
                    htmls += "<th>SN</th><th>Room Type</th><th>Status</th><th>FromDate</th><th>ThroughDate</th><th>ReturnAs</th><th>Reason</th><th>Remarks</th><th class='tdcenter'>Action</th>";
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
                        // htmls += "<td >" + value.IsOutOfOrder + "</td>";
                        //htmls += "<td >" + value.IsOutOfService + "</td>";
                        htmls += "<td class='tdcenter'><img src='/images/edit.png' input type='button' id='OO_" + value.OutOfOrderID + "_" + value.RoomID + "' class='OOedit icon-edit' value='Edit'>";
                        htmls += " | <img src='/images/delete.png' input type='button' id='OODel_" + value.OutOfOrderID + "' class='OODelete' value='Delete'>";
                        htmls += " | <label id='OOView_" + value.OutOfOrderID + "' class='icon-preview OOView' /></td>";

                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<thead>"
                    htmls += "</thead>"
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#bindOutOfOrder').html(htmls);

                    $('#OutOfOrderlisting').on('click', '.OOedit', function () {
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var Oid = findId[1];
                        $('#txtID').val(Oid);
                        HouseKeeping.GetItemByID(Oid);
                    });

                    $('#OutOfOrderlisting').on('click', '.OOView', function () {
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var Oid = findId[1];
                        $('#txtID').val(Oid);
                        HouseKeeping.GetItemByIDforView(Oid);
                    });

                    $('#OutOfOrderlisting').on('click', '.OODelete', function () {
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var LF_ID = findId[1];
                        jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                            if (r) {
                                HouseKeeping.DeleteItem(LF_ID);
                            }
                        });
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
                var htmlBind = "";

                $.each(datas, function (index, value) {
                    $('#AssignToDialog').show();
                    $('#AssignToDialog').dialog({
                        'title': 'Assign To',
                        "resize": "auto",
                        width: 500,
                         dialogClass:'headingbg',
                    });
                    $('#AssignToDialog').html("");

                    htmlBind += "<table id='assignTable' name='form1'>"
                    htmlBind += "<tr><td>Room Type :<select id='dropDownRoom' class='ddRoom' name='ddRoomName' value= " + value.RoomID + ">" + Roomlist + " </select></td></tr>";
                    htmlBind += "<tr><td>Status :<input type='text' id='txtStatus' class='required'  value= " + value.OO_Status + "></td></tr>";
                    htmlBind += "<tr><td>From Date : <input type='text' id='txtFromDate' class='required txtDate' value=" + value.FromDate + "></td></tr>";
                    htmlBind += "<tr><td>Through Date : <input type='text' id='txtThroughDate' class='required txtDate' value= " + value.ThroughDate + "></td></tr>";
                    htmlBind += "<tr><td>Return As :  <input type='text' id='txtReturnAs' class='required' value = " + value.ReturnAs + "></td></tr>";
                    htmlBind += "<tr><td>Reason : <input type='text' id='txtReason' class='required' value=" + value.Reason + "></td></tr>";
                    htmlBind += "<tr><td>Remarks :<input type='text' id='txtRemarks' class='required' value= " + value.OO_Remarks + "></td></tr>";
                    htmlBind += "<tr><td>Out Of Order :</td><td><input type='checkbox' id='txtchkOrder1' name='OutOfOrder' " + (value.IsOutOfOrder ? "checked" : "") + "/></td></tr>";
                    htmlBind += "<tr><td>Out Of Service :</td><td><input type='checkbox' id='txtchkService1' name='OutOfService' " + (value.IsOutOfService ? "checked" : "") + "/></td></tr>";
                    htmlBind += "<tr><td><div><input id='txtOK' type='button' class='sfBtn ok' value='OK' />";
                    htmlBind += "<input id='txtCancel' type='button' class='sfBtn cancel' value='Cancel' /></div></td></tr>";
                    // htmlBind += "<tr><td><div><input id='txtHk_ID' type='hidden' class='hiddenID' value='HK_ID' /></div></td></tr>";
                    htmlBind += "</table>"
                    $('#AssignToDialog').html(htmlBind);
                    $('#dropDownRoom').val(value.RoomID);
                    $('#txtStatus').val(value.OO_Status);
                    $('#txtReturnAs').val(value.ReturnAs);
                    $('#txtReason').val(value.Reason);
                    $('#txtRemarks').val(value.OO_Remarks);




                    $("#txtFromDate").datepicker({
                        numberOfMonths: 1,
                        changeMonth: true,
                        changeYear: true,
                        onSelect: function (selected) {
                            var dt = new Date(selected);
                            dt.setDate(dt.getDate() + 1);
                            $("#txtThroughDate").datepicker("option", "minDate", dt, 'setDate', 'today');
                        }
                    });

                    $("#txtThroughDate").datepicker({
                        numberOfMonths: 1,
                        changeMonth: true,
                        changeYear: true,
                        onSelect: function (selected) {
                            var dt = new Date(selected);
                            dt.setDate(dt.getDate() - 1);
                            $("#txtFromDate").datepicker("option", "maxDate", dt);
                        }
                    });

                    $('#assignTable').on('click', '#txtOK', function () {
                        if ($("#AssignToDialog #dropDownRoom").val() == 0) {
                            alert("Please Select Status")
                        }
                        else if ($("#AssignToDialog #txtStatus").val() == "") {
                            alert("Please select")
                        }
                        else if ($("#AssignToDialog #txtFromDate").val() == "") {
                            alert("Please give Remarks.")
                        }
                        else if ($("#AssignToDialog #txtThroughDate").val() == 0) {
                            alert("Please Select Housekeeper")
                        }
                        else if ($("#AssignToDialog #txtReason").val() == 0) {
                            alert("Please Select Housekeeper")
                        }
                        else if ($("#AssignToDialog #txtRemarks").val() == 0) {
                            alert("Please Select Housekeeper")
                        }
                        else {
                            var obj = {
                                OutOfOrderID: $('#txtID').val(),
                                RoomID: $('#dropDownRoom').val(),
                                OO_Status: $('#txtStatus').val(),
                                FromDate: $('#txtFromDate').val(),
                                ThroughDate: $('#txtThroughDate').val(),
                                ReturnAs: $('#txtReturnAs').val(),
                                Reason: $('#txtReason').val(),
                                OO_Remarks: $('#txtRemarks').val()
                                // OutOfOrder : $
                            };
                            if ($("#txtchkOrder1").is(':checked')) {
                                obj.IsOutOfOrder = true;
                            } else {
                                obj.IsOutOfOrder = false;
                            }
                            if ($("#txtchkService1").is(':checked')) {
                                obj.IsOutOfService = true;
                            } else {
                                obj.IsOutOfService = false;

                            }
                            HouseKeeping.config.method = "SaveOutOfOrder";
                            HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                            HouseKeeping.config.data = JSON.stringify({ obj: obj });
                            HouseKeeping.config.ajaxCallMode = 1;
                            HouseKeeping.ajaxCall(HouseKeeping.config);
                            $('#AssignToDialog').dialog('close');
                        }
                    });

                    $('#assignTable').on('click', '#txtCancel', function () {
                        $('#AssignToDialog').dialog('close');
                    });
                });
            },

            BindDataByIdforView: function (result) {
                
                $("#btnEdit").hide();
                var datas = result.d;
                var htmlBind = "";

                $.each(datas, function (index, value) {
                    $('#AssignToDialog').show();
                    $('#AssignToDialog').dialog({
                        'title': 'Assign To',
                        "resize": "auto",
                        width: 500,
                    });
                    $('#AssignToDialog').html("");

                    htmlBind += "<table id='assignTable' name='form1'>"
                    htmlBind += "<tr><td>Room Type :" + value.RoomType + " </td></tr>";
                    htmlBind += "<tr><td>Status :" + value.OO_Status + " </td></tr>";
                    htmlBind += "<tr><td>From Date :" + value.FromDate + "</td></tr>";
                    htmlBind += "<tr><td>Through Date :" + value.ThroughDate + "</td></tr>";
                    htmlBind += "<tr><td>Return As :" + value.ReturnAs + "</td></tr>";
                    htmlBind += "<tr><td>Reason : " + value.Reason + "</td></tr>";
                    htmlBind += "<tr><td>Remarks : " + value.OO_Remarks + "</td></tr>";
                    //    htmlBind += "<tr><td>Out Of Order : " + (value.IsOutOfOrder ? "checked" : "") + "</td></tr>";
                    //  htmlBind += "<tr><td>Out Of Service :</td><td><input type='checkbox' id='txtchkService1' name='OutOfService' " + (value.IsOutOfService ? "checked" : "") + "/></td></tr>";
                    //htmlBind += "<tr><td><div><input id='txtOK' type='button' class='sfBtn ok' value='OK' />";
                    //htmlBind += "<input id='txtCancel' type='button' class='sfBtn cancel' value='Cancel' /></div></td></tr>";
                    // htmlBind += "<tr><td><div><input id='txtHk_ID' type='hidden' class='hiddenID' value='HK_ID' /></div></td></tr>";
                    htmlBind += "</table>"
                    $('#AssignToDialog').html(htmlBind);
                    $('#dropDownRoom').val(value.RoomID);
                    $('#txtStatus').val(value.OO_Status);
                    $('#txtReturnAs').val(value.ReturnAs);
                    $('#txtReason').val(value.Reason);
                    $('#txtRemarks').val(value.OO_Remarks);




                    //$("#txtFromDate").datepicker({
                    //    numberOfMonths: 1,
                    //    changeMonth: true,
                    //    changeYear: true,
                    //    onSelect: function (selected) {
                    //        var dt = new Date(selected);
                    //        dt.setDate(dt.getDate() + 1);
                    //        $("#txtThroughDate").datepicker("option", "minDate", dt, 'setDate', 'today');
                    //    }
                    //});

                    //$("#txtThroughDate").datepicker({
                    //    numberOfMonths: 1,
                    //    changeMonth: true,
                    //    changeYear: true,
                    //    onSelect: function (selected) {
                    //        var dt = new Date(selected);
                    //        dt.setDate(dt.getDate() - 1);
                    //        $("#txtFromDate").datepicker("option", "maxDate", dt);
                    //    }
                    //});

                    //$('#assignTable').on('click', '#txtOK', function () {
                    //    if ($("#AssignToDialog #dropDownRoom").val() == 0) {
                    //        alert("Please Select Status")
                    //    }
                    //    else if ($("#AssignToDialog #txtStatus").val() == "") {
                    //        alert("Please select")
                    //    }
                    //    else if ($("#AssignToDialog #txtFromDate").val() == "") {
                    //        alert("Please give Remarks.")
                    //    }
                    //    else if ($("#AssignToDialog #txtThroughDate").val() == 0) {
                    //        alert("Please Select Housekeeper")
                    //    }
                    //    else if ($("#AssignToDialog #txtReason").val() == 0) {
                    //        alert("Please Select Housekeeper")
                    //    }
                    //    else if ($("#AssignToDialog #txtRemarks").val() == 0) {
                    //        alert("Please Select Housekeeper")
                    //    }
                    //    else {
                    //        var obj = {
                    //            OutOfOrderID: $('#txtID').val(),
                    //            RoomID: $('#dropDownRoom').val(),
                    //            OO_Status: $('#txtStatus').val(),
                    //            FromDate: $('#txtFromDate').val(),
                    //            ThroughDate: $('#txtThroughDate').val(),
                    //            ReturnAs: $('#txtReturnAs').val(),
                    //            Reason: $('#txtReason').val(),
                    //            OO_Remarks: $('#txtRemarks').val()
                    //            // OutOfOrder : $
                    //        };
                    //        if ($("#txtchkOrder1").is(':checked')) {
                    //            obj.IsOutOfOrder = true;
                    //        } else {
                    //            obj.IsOutOfOrder = false;
                    //        }
                    //        if ($("#txtchkService1").is(':checked')) {
                    //            obj.IsOutOfService = true;
                    //        } else {
                    //            obj.IsOutOfService = false;

                    //        }
                    //        HouseKeeping.config.method = "SaveOutOfOrder";
                    //        HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                    //        HouseKeeping.config.data = JSON.stringify({ obj: obj });
                    //        HouseKeeping.config.ajaxCallMode = 1;
                    //        HouseKeeping.ajaxCall(HouseKeeping.config);
                    //        $('#AssignToDialog').dialog('close');
                    //    }
                    //});

                    $('#assignTable').on('click', '#txtCancel', function () {
                        $('#AssignToDialog').dialog('close');
                    });
                });
            },

            BindDDRoomClass: function (result) {
                $("#ddRoomClass").show();
                $("#ddRoomClass").html('');
                var datas = result.d;
                if (datas.length > 0) {
                    var html1 = '';
                    html1 += "<option value='' selected>All</option>";
                    $.each(datas, function (index, value) {
                        html1 += "<option value ='" + value.Class + "'>" + value.Class + " </option>";
                    });
                    $('#ddRoomClass').html(html1);
                }
            },

            BindDDRooms: function (result) {
                $('#dropDownRooms').show();
                $('#dropDownRooms').html('');
                var datas = result.d;
                if (datas.length > 0) {
                    var html2 = '';
                    html2 = "<option value=0 selected>All</option>";
                    $.each(datas, function (index, value) {
                        html2 += "<option value ='" + value.RoomID + "'>" + value.RoomType + " </option>";
                    });
                    Roomlist = html2;
                    $('#dropDownRooms').html(html2);
                }
            },

            BindDDRoomName: function (result) {
                
                $('#ddRoomName').show();
                $('#ddRoomName').html('');

                var datas = result.d;
                if (datas.length > 0) {
                    var html2 = '';
                    html2 = "<option value=0 selected>All</option>";
                    $.each(datas, function (index, value) {
                        html2 += "<option value ='" + value.RoomTypeID + "'>" + value.Roomvalue + " </option>";
                    });
                  //  Roomlist = html2;
                    $('#ddRoomName').html(html2);
                    // $('#ddRoomName').val(value.Roomvalue);
                }
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $('#dropDownRooms').val('');
                $('#ddRoomName').val('');
                $('#ddRoomClass').val('');
                $('#txtStartDate').val('');
                $('#txtchkOrder').val('');
                $('#txtchkService').val('');



            },

            ValidationForm: function () {
                var valid = true;
                if ($("#txtAvailable").val() == "") {
                    alert('Give the value for availability');
                    valid = false;
                }
                if ($("#txtRemarks").val() == "") {
                    alert('Give Remarks');
                    valid = false;
                }
                return valid;
            },
        };
        HouseKeeping.init();
    };
    $.fn.MainHouseKeeping = function (p) {
        $.HouseKeepingFunction(p);
    };
})(jQuery);
