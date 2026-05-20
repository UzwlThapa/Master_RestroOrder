(function ($) {
    var tabs = $("#tabs").tabs();
    $.HouseKeepingFunction = function (p) {
        p = $.extend
			 ({

			     //SageFrameCurrentCulture
			     PortalID: '',
			     //UserModuleID: '',
			     //CultureCode: '',
			     //UserName: '',
			     ModulePath: '/Modules/HouseKeeping/',
			 }, p);

        var v = 0 ;
        var logoInfo = 0 ;
        var PrintValue = " ";
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
                // CultureCode: 'SageFrameCurrentCulture',
                ajaxCallMode: 0,
                //NewItemID: 0,
                //ItemIDUpdate: 0bindHKDetails
            },
            InitialSetup: function () {
            },

            init: function () {
                HouseKeeping.DropDownItem();
                HouseKeeping.DropDownUser();
                HouseKeeping.DropDownRooms();
                HouseKeeping.GetItem("", "");

                $('#container').hide();
                $('#btnAdd').show();
                $('#bindHouseKeeping').show();


                $("#btnAdd").on("click", function () {
                    //HouseKeeping.ResetAll();
                    $('#btnAdd').hide();
                    $('#container').show();
                });
                $('#btnSave').click(function () {
                    HouseKeeping.SaveHouseKeeping();

                    $('#btnAdd').show();
                    $('#container').hide();
                    HouseKeeping.ResetAll();
                });

                $('#btnCancel').click(function () {
                    $('#btnAdd').show();
                    $('#container').hide();
                    $('#bindHouseKeeping').show();
                    HouseKeeping.ResetAll();
                });

                $('#btnEdit').click(function () {
                    HouseKeeping.SaveHouseKeeping();
                    $('#btnAdd').show();
                    $('#container').hide();
                    $("#bindHouseKeeping").show();
                    HouseKeeping.ResetAll();
                });
                $('#btnPrint').click(function () {
                    logoInfo += PrintValue;
                    HouseKeeping.print(logoInfo);
                });

                $('#btnView').click(function () {

                    var status = $('.ddStatus :selected').val();
                    var roles = $('.ddAssign :selected').val();
                    HouseKeeping.GetItem(status, roles);
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
                        HouseKeeping.GetItem("", "");
                        break;
                    case 2:
                        HouseKeeping.BindDropDown(data);
                        break;
                    case 3:
                        alert("Deleted successfully");
                        HouseKeeping.GetItem("", "");
                        break;
                    case 4:
                        HouseKeeping.BindData(data);
                        break;
                        //case 5:
                        //    alert("Updated successfully");
                        //    HouseKeeping.GetItem();
                        //    break;
                    case 6:
                        HouseKeeping.BindDDUsers(data);
                        break;
                    case 7:
                        HouseKeeping.BindDDRooms(data);
                    case 8:
                        HouseKeeping.bindgetcompanyInfo(data);
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

            SaveHouseKeeping: function () {
                var obj = {

                    HK_ID: $('#txtHKID').val(),
                    RoomType: $('#dropDownRooms').val(),
                    RoomStatus: $('#dropDownStatus1').val(),
                    Availability: $('#txtAvailability').val(),
                    Remarks_HK: $('#txtRemarks').val(),
                    AssignTo: $('#dropDownAssign1').val()

                };

                HouseKeeping.config.method = "SaveMainHouseKeeping";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ obj: obj });
                HouseKeeping.config.ajaxCallMode = 1;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            GetItem: function (status, Role) {
                HouseKeeping.config.method = "GetMainHouseKeepingInfo";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ Status: status, AssignTo: Role });
                HouseKeeping.config.ajaxCallMode = 4;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            DeleteItem: function (HK_ID) {
                HouseKeeping.config.method = "DeleteMainHouseKeepingDetails";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ HK_ID: HK_ID });
                HouseKeeping.config.ajaxCallMode = 3;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            DropDownItem: function () {
                HouseKeeping.config.method = "GetStatus";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 2;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },
            DropDownUser: function () {
                HouseKeeping.config.method = "GetUsers";
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
            getcompanyInfo: function () {
                HouseKeeping.config.method = "getcompanyInfo";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 8;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },





            ////<<-----------------------------------BindTable Here ------------------------------------->>>

            BindData: function (result) {
                $("#bindHouseKeeping").show();
                $("#bindHouseKeeping").html('');

                var datas = result.d;
                var HRoomID;
                var HRoomType;
                var HRoom;
                var HStatus;
                var HAvailability;
                var HRemarks_HK;
                var HAssignTo;
                var HDate;


                if (datas.length > 0) {
                    $('#btnPrint').show();
                    var htmls = "<table id='HKlisting' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Room Type</th><th>Room</th><th>Status</th><th>Booked Date</th><th>Availability</th><th>Remarks</th><th>Assign To</th><th>View</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td >" + count + "</td>";
                        htmls += "<td >" + value.RoomType + "</td>";
                        htmls += "<td >" + value.Room + "</td>";
                        htmls += "<td >" + value.RoomStatus + "</td>";
                        htmls += "<td >" + value.HK_Date + "</td>";
                        htmls += "<td >" + value.Availability + "</td>";
                        htmls += "<td >" + value.Remarks_HK + "</td>";
                        htmls += "<td>" + value.AssignTo + "</td>";
                        htmls += "<td ><label id='HKView_" + value.RoomID + "_" + value.RoomType + "_" + value.Room + "_" + value.RoomStatus + "_" + value.Availability + "_" + value.Remarks_HK + "_" + value.AssignTo + "' class='icon-preview HKView'/></td>";

                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "<thead>"
                    htmls += "</thead>"
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#bindHouseKeeping').html(htmls);

                    PrintValue += htmls;
                    $('#HKlisting').on('click', '.HKedit', function () {
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var HK_ID = findId[1];
                        var HRoomID = findId[2];
                        var HRoomType = findId[3];
                        var HRoom = findId[4];
                        var HStatus = findId[5];
                        var HAvailability = findId[6];
                        var HRemarks_HK = findId[7];
                        var HAssignTo = findId[8];


                        $("#bindHouseKeeping").hide();
                        $('#btnAdd').hide();
                        $('#container').show();
                        $('#btnSave').hide();
                        $('#txtHKID').val(HK_ID);
                        $('#dropDownStatus1').val(HStatus);
                        $('#txtAvailability').val(HAvailability);
                        $('#dropDownRooms').val(HRoomType);
                        $('#txtRemarks').val(HRemarks_HK);
                        $('#dropDownAssign1').val(HAssignTo);


                        //HouseKeeping.config.ajaxCallMode = 2;
                        //HouseKeeping.UpdateItem(ids);
                    });
                    $('#HKlisting').on('click', '.HKdelete', function () {
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var HK_ID = findId[1];
                        //jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                        //    //jAlert('Confirmed: ' + r, 'Confirmation Results');
                        //    if (r) {
                        HouseKeeping.DeleteItem(HK_ID);
                        //}
                        // });
                    });

                    $('#HKlisting').on('click', '.HKView', function () {

                        
                        var id = $(this).attr('id');
                        var findId = id.split('_');

                        //  var HK_ID = findId[1];
                        HRoomID = findId[1];
                        HRoomType = findId[2];
                        HRoom = findId[3];
                        //HStatus = findId[4];
                        //HAvailability = findId[5];
                        //HRemarks_HK = findId[6];
                        //HAssignTo = findId[7];

                        var htmlBind = "";
                        var dropdown = document.getElementById("rolesData").innerHTML;
                        var ddstatus = document.getElementById("statusData").innerHTML;
                        var ddroom = document.getElementById("roomsData").innerHTML;

                        $('#AssignToDialog').show();
                        $('#AssignToDialog').dialog({
                            'title': 'Assign To',
                            "resize": "auto",
                             dialogClass:'headingbg',
                            width: 400,
                        });
                        $('#AssignToDialog').html("");


                        htmlBind += "<table id='assignTable' name='form1'>"
                        htmlBind += "<tr><td>Room ID : " + HRoomID + "</td></tr>";
                        htmlBind += "<tr><td>Room Type : " + HRoomType + "</td></tr>";
                        htmlBind += "<tr><td>Room : " + HRoom + "</td></tr>";
                        htmlBind += "<tr><td> " + ddstatus + "</td></tr>";
                        htmlBind += "<tr><td>Date : <input type='text' id='txtBookDate' class='required' name='BookDate' /></td></tr>";
                        htmlBind += "<tr><td>Time : <select id='StartHour' class='Hour'><option value='0'>0</option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option><option value='6'>6</option><option value='7'>7</option><option value='8'>8</option><option value='9'>9</option><option value='10'>10</option><option value='11'>11</option><option value='12'>12</option><option value='13'>13</option><option value='14'>14</option><option value='15'>15</option><option value='16'>16</option><option value='17'>17</option><option value='18'>18</option><option value='19'>19</option><option value='20'>20</option><option value='21'>21</option><option value='22'>22</option><option value='23'>23</option></select>";
                        htmlBind += "<select id='StartMin' class='Min'><option value='0'>0</option><option value='1'>1</option><option value='2'>2</option><option value='3'>3</option><option value='4'>4</option><option value='5'>5</option><option value='6'>6</option><option value='7'>7</option><option value='8'>8</option><option value='9'>9</option><option value='10'>10</option><option value='11'>11</option><option value='12'>12</option><option value='13'>13</option><option value='14'>14</option><option value='15'>15</option><option value='16'>16</option><option value='17'>17</option><option value='18'>18</option><option value='19'>19</option><option value='20'>20</option><option value='21'>21</option><option value='22'>22</option><option value='23'>23</option><option value='24'>24</option><option value='25'>25</option><option value='26'>26</option><option value='27'>27</option><option value='28'>28</option><option value='29'>29</option><option value='30'>30</option><option value='31'>31</option><option value='32'>32</option><option value='33'>33</option><option value='34'>34</option><option value='35'>35</option><option value='36'>36</option><option value='37'>37</option><option value='38'>38</option><option value='39'>39</option><option value='40'>40</option><option value='41'>41</option><option value='42'>42</option><option value='43'>43</option><option value='44'>44</option><option value='45'>45</option><option value='46'>46</option><option value='47'>47</option><option value='48'>48</option><option value='49'>49</option><option value='50'>50</option><option value='51'>51</option><option value='52'>52</option><option value='53'>53</option><option value='54'>54</option><option value='55'>55</option><option value='56'>56</option><option value='57'>57</option><option value='58'>58</option><option value='59'>59</option></select>";
                        htmlBind += "<tr><td>Availability : <input id='txtYes' type='radio' name='Availability' value='Yes' checked/> YES <input id='txtNo' type='radio' name='Availability' value='No'/> NO </td></tr>";
                        htmlBind += "<tr><td>Remarks : <input id='txtRemarks' type='text' value='' name='Remarks' /></td></tr>";
                        htmlBind += "<td>" + dropdown + "</td></tr>";
                        htmlBind += "<tr><td><div><input id='txtOK' type='button' class='sfBtn ok' value='OK' />";
                        htmlBind += "<input id='txtCancel' type='button' class='sfBtn cancel' value='Cancel' /></div></td></tr>";
                        htmlBind += "<tr><td><div><input id='txtHk_ID' type='hidden' class='hiddenID' value='HK_ID' /></div></td></tr>";
                        htmlBind += "</table>"
                        $('#AssignToDialog').html(htmlBind);
                        $("#txtBookDate").datepicker({
                            dateFormat: 'yy-mm-dd',
                            changeMonth: true,
                            changeYear: true,
                            maxDate: '0',
                            onClose: function (selectedDate) {
                                jQuery("#txtDate").datepicker("option", "minDate", selectedDate);
                            }
                        });
                        $('#assignTable').on('click', '#txtOK', function () {
                            
                            if ($("#AssignToDialog #dropDownStatus").val() == 0) {
                                alert("Please Select Status")
                            }
                            else if ($("#AssignToDialog #txtAvailable").val() == "") {
                                alert("Please select")
                            }
                            else if ($("#AssignToDialog #txtRemarks").val() == "") {
                                alert("Please give Remarks.")
                            }

                            else if ($("#AssignToDialog #dropDownAssign").val() == 0) {
                                alert("Please Select Housekeeper")
                            }
                            else {
                                HK_ID = $('#txtHKID').val();
                                HStatus = $('#AssignToDialog #dropDownStatus').val();
                                HRem = $('#AssignToDialog #txtRemarks').val();
                                AssignTo = $('#AssignToDialog #dropDownAssign').val();
                                if ($('#AssignToDialog #txtYes').is(':checked')) {

                                    HAvailability = $('#AssignToDialog #txtYes').val();

                                }
                                else if ($('#AssignToDialog #txtNo').is(':checked')) {
                                    HAvailability = $('#AssignToDialog #txtNo').val();
                                }
                                HK_Date = $('#AssignToDialog #txtBookDate').val();
                                Time_Hour = $('#AssignToDialog #StartHour').val();
                                Time_Min = $('#AssignToDialog #StartMin').val();

                                var obj = {
                                    HK_ID: HK_ID,
                                    RoomID: HRoomID,
                                    RoomType: HRoomType,
                                    Room: HRoom,
                                    RoomStatus: HStatus,
                                    Availability: HAvailability,
                                    HK_Date: HK_Date,
                                    Time_Hour: Time_Hour,
                                    Time_Min: Time_Min,
                                    Remarks_HK: HRem,
                                    AssignTo: AssignTo

                                };
                                HouseKeeping.config.method = "SaveMainHouseKeeping";
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
                    $("#HKlisting").dataTable(
                       {
                           ordering: false,
                           "jQueryUI": true,
                           dom: 'Bfrtip',

                           buttons: [
                               'print', 'excel', 'pdf'
                           ]
                       }
                   );
                }
            },

            bindgetcompanyInfo: function (result) {
                
                var datas = result.d;
                if (datas.length > 0) {

                    var htmls = "";
                    htmls += "<div id='customer-bill' style='text-align:center;width:100%;'>"
                    $.each(datas, function (index, value) {
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
                    if (datas.length == 1) {
                        logoInfo = htmls;
                    }
                }
            },

            BindDropDown: function (result) {
                
                $(".ddStatus").show();
                $(".ddStatus").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' selected>All</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value ='" + value.HkStatus + "'>" + value.HkStatus + " </option>";
                    });
                    $('.ddStatus').html(htmls);
                }
            },

            BindDDUsers: function (result) {
                $(".ddAssign").show();
                $(".ddAssign").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var html1 = '';
                    html1 += "<option value='' selected>All</option>";
                    $.each(datas, function (index, value) {
                        html1 += "<option value ='" + value.Username + "'>" + value.Username + " </option>";
                    });
                    $('.ddAssign').html(html1);
                }
            },
            BindDDRooms: function (result) {
                $("#dropDownRooms").show();
                $("#dropDownRooms").html('');

                var datas = result.d;

                if (datas.length > 0) {
                    var html2 = '';
                    html2 = "<option value='' selected>All</option>";
                    $.each(datas, function (index, value) {
                        html2 += "<option value ='" + value.RoomType + "'>" + value.RoomType + " </option>";
                    });
                    $('#dropDownRooms').html(html2);
                }
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $('#dropDownStatus').val('');
                $('#dropDownAssign').val('');
            },

            ValidationForm: function () {

                //  t.find(".sfError").removeClass("sfError");
                var valid = true;

                if ($("#txtAvailable").val() == "") {
                    //  t.find(".txtIssuedAmount").addClass("sfError");
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
