var arrOccupiedTableIds = [];
var mergeTableList = [];
var arrOccupiedTables = [];
(function ($) {
    $.companyDashboardcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RestroDashboard/',
                 HostUrl: '',
                 TypeId: '',
             }, p);
        var v = 0;
        var pinMatch = false;
        var username = "";
        var mergetableid = 0;
        var containOccTab = false;
        var pinfor = "";
        var DashboardFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 
                dataType: 'json',
                baseURL: p.ModulePath + "services/DashBoardWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                RoomId: 0,
            },
            init: function () {
                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'Merge') {
                             mergeTableList = [];
                            
                            //var slides = document.getElementsByClassName("imgtablemerge");
                            // for (var i = 0; i < arrOccupiedTableIds.length; i++) {
                            //         mergeTableList.push(parseInt(arrOccupiedTableIds[i]));
                            // }
                            if (arrOccupiedTableIds.length > 1) {
                                jConfirm('Are You Sure  ?', 'Merge Tables', function (confirmed) {
                                    if (confirmed) {
                                        DashboardFunction.SaveMergeTables();
                                    }
                                });
                            }
                            else {
                                jAlert('At least 2 tables required to merge', "Alert!!", function () { $.alerts.dialogClass = null; });
                            }
                        }
                    }
                });
                PinCodeSetup();
                NumCodeSetup();
                $(".btnMerge").on("click", function () {
                    
                    $('#hdnPinFor').val('Merge');
                    InitializePin();
                });
                $(".imgroomtypeformerge").on('change', function () {
                    var id = $(".imgroomtypeformerge").val();
                    DashboardFunction.GetRoomByRoomTypeIdForMerge(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;
                     
                });
                $(".imgroomtypeformerge").change();
            },

            ajaxCall: function (config) {
                $.ajax({
                    type: DashboardFunction.config.type,
                    contentType: DashboardFunction.config.contentType,
                    async: DashboardFunction.config.async,
                    cache: DashboardFunction.config.cache,
                    url: DashboardFunction.config.url,
                    data: DashboardFunction.config.data,
                    dataType: DashboardFunction.config.dataType,
                    success: DashboardFunction.ajaxSuccess,
                    error: DashboardFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(DashboardFunction.config.ajaxCallMode)) {
                    case 0:
                        var result = JSON.parse(data.d);
                        if (result != null) {
                            pinMatch = true;
                            username = result;
                        }
                        else {
                            pinMatch = false;
                        }
                        break;
                    case 1:
                        DashboardFunction.BindRoomByRoomTypeIdForMerge(data);
                        $(".imgRoomMerge").change();
                        break;
                    case 2:
                        DashboardFunction.BindTableByRoomTypeIdForMerge(data);
                        break;
                    case 3:
                        var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(mergetableid);
                        window.location.href = url;
                        break;
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            
            SaveMergeTables: function () {
                
                var slides = document.getElementsByClassName("imgtablemerge");
                var mergelist = 0;
                var i = 0
                // while (mergelist < 1) {
                //     if (slides[i].checked) {
                //         var data = slides[i].id.split('_');
                //         mergelist = data[1];
                //     }
                //     i++;
                // }

                mergelist = arrOccupiedTableIds[0].tableID;
                //mergetableid = parseInt(mergelist);
                mergetableid = (mergetableid > 0 ? mergetableid : parseInt(mergelist));
                mergeTableList = new Array;
              var  occupiedTables = new Array;
                for (var i = 0; i < arrOccupiedTableIds.length; i++) {
                    
                        merge = {
                            MergeID: parseInt(arrOccupiedTableIds[i].mergeid),
                            TableID: parseInt(arrOccupiedTableIds[i].tableID),
                            MergeTableList: mergetableid,
                        }
                        mergeTableList.push(merge);
                        occupiedTables.push( parseInt(arrOccupiedTableIds[i].tableID));
                    
                }

            

               
                DashboardFunction.config.method = "MergeTables";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ mergeTableList: mergeTableList, occupiedTableIds: occupiedTables });
                DashboardFunction.config.ajaxCallMode = 3;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetRoomByRoomTypeIdForMerge: function (roomtypeid) {
                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 1;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetTableByRoomTypeIdForMerge: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 2;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            CheckPinCodeMatch: function (PinCode) {
                DashboardFunction.config.method = "CheckPinCodeMatch";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    PinCode: PinCode
                });
                DashboardFunction.config.ajaxCallMode = 0;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            BindRoomByRoomTypeIdForMerge: function (result) {
                var htmls = [];
                $('.RoomsForMerge').html("");

                var datas = JSON.parse(result.d);
                htmls += "<select class='imgRoomMerge sfInputbox' style='width:150px;'>";
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += ("<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>");
                    });
                } else {
                    htmls += "No Data";
                }
                htmls += "</select>";
                $('.RoomsForMerge').html(htmls);

                $(".imgRoomMerge").on('change', function () {
                    var id = $(".imgRoomMerge").val();
                    RoomId = parseInt(id);
                    activeorder = id;
                    DashboardFunction.GetTableByRoomTypeIdForMerge(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;
                    
                });

                // $(".imgRoomMerge").on('change', function () {

                // 	resizeIframe();

                // });
                $('.RoomsForMerge').show();
                $('.TablesForMerge').hide();

            },
            BindTableByRoomTypeIdForMerge: function (result) {
                
                var htmls = [];
                $('.TablesForMerge').html("");
                //$('#DialogOrderDetail').html("");
                var datas = JSON.parse(result.d);
                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";
                    $.each(datas, function (index, value) {
                        var billNotCleared = ((value.BillPaid == 1 && value.restrotablesStatusID == 7) ? true : false);
                        if (value.MergeTableList <= 0 && value.IsTable && !billNotCleared) {
                            htmls += "<li>"
                            htmls += ("<input type='checkbox' class='imgtablemerge' id='");

                            if (value.BillPaid == 0 && value.IsCancelled == 0) {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_yes' + "' /> ");
                            } else {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_no' + "' /> ");
                            }
                            htmls += ("<label for ='");

                            if (value.BillPaid == 0 && value.IsCancelled == 0) {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_yes' + "' class = '' >");
                                htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablered.png'></label> ");
                            } else {
                                htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_' + value.MergeTableList + '_' + value.MergeID + '_no' + "' class = '' >");
                                htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablegreen.png'></label> ");
                            }

                            htmls += ("<h5 class='");
                            htmls += (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0' ? "NotPaid" : "Paid");
                            htmls += ("' >" + value.restrotableTitle + "</h5>");

                            if (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0') {
                                htmls += ("<h5 class='order-time'");

                                var dateprev = new Date(value.tableDate);
                                var datet = new Date();
                                var diff = (datet - dateprev) / 1000;
                                function secondsTimeSpanToHMS(s) {
                                    var h = Math.floor(s / 3600); //Get whole hours
                                    s -= h * 3600;
                                    var m = Math.floor(s / 60); //Get remaining minutes
                                    s -= m * 60;
                                    if (h == 0) {
                                        return (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           }
                                    } else {
                                        return h + ":" + (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           }
                                    }

                                }
                                var dinal = secondsTimeSpanToHMS(diff)
                                htmls += ("' >" + value.tabletime + "</h5><h5 class='order-timeA'>" + dinal + "</h5>");
                            }
                            htmls += ("</li>");
                        }
                    });
                    htmls += "</ul>";

                    $('.TablesForMerge').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });
                }


                $(".imgtablemerge").off('change').on('change', function () {
                    
                    //debugger;
                    var data = $(this).attr('id').split('_');
                    var occupiedtable = data[7];
                    var isOcc = (occupiedtable == "yes" ? true : false);
                    var imgid = 'IMG_' + data[1];
                    //if (isOcc) {
                    //    arrOccupiedTableIds.push(data[1]);
                    //}
                    if (isOcc && !$(this).prop('checked')) {
                        $(this).prop('checked', false);

                        var obj = {tableID:  data[1], mergeid: data[6]};

                        arrOccupiedTableIds = removeItemAll(arrOccupiedTableIds, obj)
                        document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tablered.png';
                        if (arrOccupiedTableIds.length > 0) {
                            containOccTab = true;
                            mergetableid = arrOccupiedTableIds[0];
                        } else {
                            containOccTab = false;
                            mergetableid = 0;
                        }
                        
                    } else if (!isOcc && !$(this).prop('checked')) {
                        var obj = {tableID:  data[1], mergeid: data[6]};
                        $(this).prop('checked', false);     
                        arrOccupiedTableIds = removeItemAll(arrOccupiedTableIds, obj)                   
                        document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tablegreen.png';
                    } else {
                        if (isOcc) {
                            var obj = {tableID:  data[1], mergeid: data[6]};
                            arrOccupiedTableIds.push(obj);
                        }
                        if (containOccTab && isOcc) {
                            
                            //jAlert('Two Occupied Tables cannot be merged.', "Alert!!", function () { $.alerts.dialogClass = null; });
                            //$(this).prop('checked', false);
                            //document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tablered.png';
                           
                            containOccTab = (occupiedtable == "yes" ? true : containOccTab);
                            mergetableid = (isOcc ? data[1] : mergetableid);
                            document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tableyellow.png';
                        }
                        else {
                            
                            containOccTab = (occupiedtable == "yes" ? true : containOccTab);
                            mergetableid = (isOcc ? data[1] : mergetableid);
                            var obj = {tableID:  data[1], mergeid: data[6]};
                            arrOccupiedTableIds.push(obj);
                            document.getElementById(imgid).src = p.HostUrl + '/Modules/RestroDashboard/image/tableyellow.png';
                        }
                    }

                });
             

                $('.TablesForMerge').show();
                $('.btnMerge').show();



            },
        };
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);

function removeItemAll(arr, value) {
    var i = 0;
    while (i < arr.length) {
        if (arr[i].tableID === value.tableID) {
            arr.splice(i, 1);
        } else {

        }
        ++i;
    }
    return arr;
}