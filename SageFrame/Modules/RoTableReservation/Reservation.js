
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&
        (charCode < 48 || charCode > 57)) {
        return false;
    }
    if ($(element).val().indexOf('.') != -1 && $(element).val().split('.')[1].length >= 2) {
        return false;
    }

    return true;
}

function Print() {
    $('#printedDate').show();
    $('#reportDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#ReservationReport').html();
    $('#printedDate').hide();
    $('#reportDate').hide();
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
}

(function ($) {
    $.companyDashboardcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RoTableReservation/',
                 HostUrl: '',
                 TypeId: '',
                 Username: '',
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
                baseURL: p.ModulePath + "ReservationService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                RoomId: 0,
            },
            init: function () {
                DashboardFunction.GetReservedTableList();
                DashboardFunction.GetTable();
                $("#txtReserveDateTime").datetimepicker({
                    changeYear: true,
                    changeMonth: true,
                    onClose: function () {
                        $(this).valid();
                    }
                });


                $("#btnAddReservation").on('click', function () {
                    $("#divForRoomTablerReservation").show();
                    $("#ViewReservedTable").hide();
                    $("#btnAddReservation").hide();

                });

                $("#btnView").on('click', function () {
                    debugger;
                    $(".report-view").show();
                    DashboardFunction.GetReservedTableReport();
                });

                $('#hdnPinMatch').on('change', function () {
                    if ($('#hdnPinMatch').val() == "true") {
                        var pinFor = $('#hdnPinFor').val();
                        if (pinFor == 'Reserve') {
                            var ReserveTableList = [];

                            var slides = document.getElementsByClassName("imgtablemerge");
                            for (var i = 0; i < slides.length; i++) {
                                if (slides[i].checked) {
                                    var data = slides[i].id.split('_');
                                    ReserveTableList.push(parseInt(data[1]));
                                }
                            }
                            if (ReserveTableList.length > 0) {
                                var checkValid = DashboardFunction.ValidationForm();
                                if (checkValid) {
                                    jConfirm('Are You Sure  ?', 'Reserve Tables', function (confirmed) {
                                        if (confirmed) {
                                            DashboardFunction.SaveReserveTables();
                                        }
                                    });
                                }
                            }
                            else {
                                jAlert('At least 1 table required', "Alert!!", function () { $.alerts.dialogClass = null; });
                            }
                        }
                    }
                });
                PinCodeSetup();
                NumCodeSetup();

                $(".btnReserve").on("click", function () {
                    $('#hdnPinFor').val('Reserve');
                    InitializePin();
                });
                $(".imgroomtypeformerge").on('change', function () {
                    var id = $(".imgroomtypeformerge").val();
                    DashboardFunction.GetRoomByRoomTypeIdForReservation(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;

                });
                $(".imgroomtypeformerge").change();




                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#ReservationReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "tableReservationReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#ReservationReport"), 0, 0, options, function () {
                        pdf.save('tableReservationReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });

                $('.customerForCash').on('change', function () {
                    if ($('.customerForCash').prop('checked') == true) {
                        DashboardFunction.GetCustomeronChange();
                        $("#membeshipformlist").dialog({
                            'title': 'Customer',
                            width: 800,
                            modal: true,
                            resizable: true,
                            position: ['center', 'top']
                        });
                    }
                });
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
                        jAlert('Successfully Reserved!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        DashboardFunction.ResetAll();
                        break;
                    case 1:
                        DashboardFunction.BindRoomByRoomTypeIdForReservation(data);
                        $(".imgRoomMerge").change();
                        break;
                    case 2:
                        DashboardFunction.BindTableByRoomTypeIdForReservation(data);
                        break;
                    case 3:
                        DashboardFunction.BindReservedTable(data.d);
                        break;
                    case 4:
                        jAlert('Successfully confirmed the Reservation!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        DashboardFunction.ResetAll();
                        break;
                    case 5:
                        jAlert('Successfully cancelled the Reservation!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        DashboardFunction.ResetAll();
                        break;
                    case 6:
                        DashboardFunction.BindReservedTableReport(data.d);
                        break;
                    case 7:
                        DashboardFunction.Bindmembership(data);
                        break;
                    case 8:
                        DashboardFunction.BindTable(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetTable: function () {
                DashboardFunction.config.method = "getRestroTable";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.config.data;
                DashboardFunction.config.ajaxCallMode = 8;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetCustomeronChange: function () {
                var customer = 1;
                DashboardFunction.config.method = "getsdatass";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({ customer: customer });
                DashboardFunction.config.ajaxCallMode = 7;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            Bindmembership: function (data) {
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var datas = JSON.parse(data.d);
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='BookedTable-list display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Select</th><th> Name </th><th>PAN</th><th style='width:200px'> Address </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.PAN + "_" + value.Address + "_" + value.discount + "_" + value.TelMobile + "_" + value.CardNumber + "'>";
                        htmls += "<td>" + "<img src='/images/completed.png' class='Customer' style='width:20px;height:20px;' type='button'  id='_" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.TelMobile + "' value='Delete'  /></td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td>" + value.PAN + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        htmls += "</tr>"
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                         {
                             jQueryUI: true,
                             ordering: false,
                             "lengthMenu": [[20,50, 100, -1], [20, 50, 100, "All"]],
                             "iDisplayLength": 20,
                         });
                } else {
                    $('#membeshipformlist').html('No data');

                }
                $('#membeshipformlist').on('click', '.Customer', function () {
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    $('#txtCustName').val(words[2] + " " + words[3]);
                    $('#txtPhone').val(words[4]);
                    $('#membeshipformlist').dialog('close');
                });
            },

            SaveReserveTables: function () {
                var slides = document.getElementsByClassName("imgtablemerge");
                ReserveTableList = new Array;
                for (var i = 0; i < slides.length; i++) {
                    if (slides[i].checked) {
                        var tbl = new Object();
                        var data = slides[i].id.split('_');
                        tbl.TableID = parseInt(data[1]);
                        ReserveTableList.push(tbl);
                    }
                }
                table = new Object();
                table.ReservedTable = ReserveTableList;
                table.CustomerName = $('#txtCustName').val();
                table.ReservedDateTime = $('#txtReserveDateTime').val();
                table.NoOfPeople = $('#txtPeople').val();
                table.ReservedBy = p.Username;
                table.Phone = $('#txtPhone').val();
                table.NotifyBefore = $('#txtNotify').val();
                table.Note = $('#txtNote').val();
                var jsonText = JSON2.stringify({ table: table });
                DashboardFunction.config.method = "saveTableReservation";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = jsonText;
                DashboardFunction.config.ajaxCallMode = 0;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetRoomByRoomTypeIdForReservation: function (roomtypeid) {
                DashboardFunction.config.method = "GetRoomByRoomTypeId";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomTypeID: roomtypeid
                });
                DashboardFunction.config.ajaxCallMode = 1;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            GetTableByRoomTypeIdForReservation: function (roomid) {
                DashboardFunction.config.method = "GetTableByRoomTypeIdWeb";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    RoomId: roomid
                });
                DashboardFunction.config.ajaxCallMode = 2;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
     
            GetReservedTableList: function () {
                DashboardFunction.config.method = "getReservedTableList";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.config.data;
                DashboardFunction.config.ajaxCallMode = 3;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            GetReservedTableReport: function () {
                debugger;
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtEndDate").val();
                var CustomerName = $('#txtCustomerName').val();
                var TableId = $('#seltable').val();
                DashboardFunction.config.method = "getReservedTableListReport";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    StartDate: StartDate, EndDate: EndDate, CustomerName: CustomerName, TableId: TableId
                });
                DashboardFunction.config.ajaxCallMode = 6;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },

            BindTable: function (result) {
                tablelist = JSON.parse(result);
                $("#seltable").html('');
                var htmls = "";
                htmls += "<option value='0' selected>All</option>";
                $.each(tablelist, function (index, value) {
                    htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                });

                $("#seltable").html(htmls);

            },

            BindRoomByRoomTypeIdForReservation: function (result) {
                var htmls = [];
                $('.RoomsForMerge').html("");

                var datas = JSON.parse(result.d);
                htmls += "<label>Rooms : </label> <select class='imgRoomMerge sfInputbox'>";
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
                    DashboardFunction.GetTableByRoomTypeIdForReservation(parseInt(id));
                    mergetableid = 0;
                    containOccTab = false;
                });

                $('.RoomsForMerge').show();
                $('.TablesForMerge').hide();

            },
            BindTableByRoomTypeIdForReservation: function (result) {
                var htmls = [];
                $('.TablesForMerge').html("");
                var datas = JSON.parse(result.d);
                if (datas.length > 0) {
                    htmls += "<h4>Tables in " + datas[0].restroRoom + "</h4><hr><ul>";
                    $.each(datas, function (index, value) {
                        var billNotCleared = ((value.BillPaid == 1 && value.restrotablesStatusID == 7) ? true : false);
                        if (value.MergeTableList <= 0 && value.IsTable && !billNotCleared) {
                            htmls += "<li>"
                            htmls += ("<input type='checkbox' class='imgtablemerge' id='");
                            htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' /> ");                           
                            htmls += ("<label for ='");
                            htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle +  '_no' + "' class = '' >");
                            htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablegreen.png'></label> ");
                            htmls += ("<h5 class='");
                            htmls += ("' >" + value.restrotableTitle + "</h5>");               
                            htmls += ("</li>");
                        }
                    });
                    htmls += "</ul>";

                    $('.TablesForMerge').html(htmls);

                } else {
                    jAlert('No Tables Available in selected Room.', "Alert!!", function () { $.alerts.dialogClass = null; });
                }

                $(".imgtablemerge").on('change', function () {
                    var data = $(this).attr('id').split('_');
                    $(this).prop('checked');
                });

                $('.TablesForMerge').show();
                $('.btnReserve').show();
            },

            BindReservedTable: function(result){
                datas = JSON.parse(result);
                $("#ViewReservedTable").html();
                var htmls = '';             
                htmls += "<table id='tableFor' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Table Name</th><th>Customer Name</th><th>Contact No.</th><th>Reservation Date</th><th>ReservationTime</th><th>No of people </th><th>Note </th><th class='edit-heading tdcenter'>Confirm</th><th class='edit-heading tdcenter'>Cancel</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    var count = 1;
                    $.each(datas, function (index, value) {
                        var date = new Date(value.ReservedDateTime);
                        var hours = date.getHours()
                        var minutes = date.getMinutes()
                        if (minutes < 10)
                            minutes = "0" + minutes;

                        var suffix = "AM";
                        if (hours >= 12) {
                            suffix = "PM";
                            hours = hours - 12;
                        }
                        if (hours == 0) {
                            hours = 12;
                        }
                        var current_time = hours + ":" + minutes + " " + suffix;
                        debugger;
                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.Tablename + "</td>";
                        htmls += "<td>" + value.CustomerName + "</td>";
                        htmls += "<td>" + value.Phone + "</td>";
                        htmls += "<td>" + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + "</td>";
                        htmls += "<td>" + current_time + "</td>";
                        htmls += "<td>" + value.NoOfPeople + "</td>";
                        htmls += "<td>" + value.Note + "</td>";
                  
                        if (value.IsConfirmed == true) {
                            htmls += "<td></td>";
                        }
                        else {
                            htmls += "<td class='tdcenter'>" + "<img src='/images/completed.png' class='Confirm preview-icon' type='button'  id='" + value.ReservationID + "' value='Confirm' /></td>";
                        }
                        htmls += "<td class='tdcenter'>" + "<img src='/images/cancel-icon.png' class='Cancel preview-icon' type='button'  id='" + value.ReservationID + "' value='Cancel' /></td>";
                        htmls += "</tr>"
                        count++;
                    });

                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='9' style='text-align:center;'> No Data Available</td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "</table>";

                $('#ViewReservedTable').html(htmls);

                $("#ViewReservedTable").on('click', '.Confirm', function () {
                
                    var reserveid = $(this).attr('id');
                    var confirmedby = p.Username;
                    
                    jConfirm('Do You want to confirm the reserved table?', 'Confirmation!!', function (confirm) {
                        if (confirm) {
                           
                            DashboardFunction.config.method = "ConfirmReservation";
                            DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                            DashboardFunction.config.data = JSON2.stringify({
                                reserveid: reserveid, confirmedby: confirmedby
                            });
                            DashboardFunction.config.ajaxCallMode = 4;
                            DashboardFunction.ajaxCall(DashboardFunction.config);
                       
                        }
                    });                  
                });
                $("#ViewReservedTable").on('click', '.Cancel', function () {
                    var reserveid = $(this).attr('id');
                    var cancelledby = p.Username;
                    jConfirm('Do You want to Cancel the reserved table?', 'Confirmation!!', function (confirm) {
                        if (confirm) {
                          
                            DashboardFunction.config.method = "CancelReservation";
                            DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                            DashboardFunction.config.data = JSON2.stringify({
                                reserveid: reserveid, cancelledby: cancelledby
                            });
                            DashboardFunction.config.ajaxCallMode = 5;
                            DashboardFunction.ajaxCall(DashboardFunction.config);

                        }
                    });
                });
            },

            BindReservedTableReport: function (result) {
                debugger;
                datas = JSON.parse(result);
                $('#ReservationReport').show();
                $("#ReservationReport").html();
                var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Table Reservation Report </p> <p style="text-align:center;margin:0;">From: ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val()) + ' To: ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='tableFor' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>SN</th><th>Table Name</th><th>Customer Name</th><th>Contact No.</th><th>Reservation Date</th><th>ReservationTime</th><th>No of people </th><th>Note </th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    var count = 1;
                    $.each(datas, function (index, value) {
                        var date = new Date(value.ReservedDateTime);
                        var hours = date.getHours()
                        var minutes = date.getMinutes()
                        if (minutes < 10)
                            minutes = "0" + minutes;

                        var suffix = "AM";
                        if (hours >= 12) {
                            suffix = "PM";
                            hours = hours - 12;
                        }
                        if (hours == 0) {
                            hours = 12;
                        }
                        var current_time = hours + ":" + minutes + " " + suffix;

                        htmls += "<tr>";
                        htmls += "<td>" + count + "</td>";
                        htmls += "<td>" + value.Tablename + "</td>";
                        htmls += "<td>" + value.CustomerName + "</td>";
                        htmls += "<td>" + value.Phone + "</td>";
                        htmls += "<td>" + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + "</td>";
                        htmls += "<td>" + current_time + "</td>";
                        htmls += "<td>" + value.NoOfPeople + "</td>";
                        htmls += "<td>" + value.Note + "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='7' style='text-align:center;'> No Data Available</td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#ReservationReport').html(htmls);
            },

            ResetAll: function () {
                $("#divForRoomTablerReservation").hide();
                $("#ViewReservedTable").show();
                $("#btnAddReservation").show();
                DashboardFunction.GetReservedTableList();
               $('#txtCustName').val('');
               $('#txtReserveDateTime').val('');
               $('#txtPeople').val('');
               $('#txtPhone').val('');
               $('#txtNotify').val('');
               $('#txtNote').val('');
            },


            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        DateTime: {
                            required: true,
                        },

                        CustName: {
                            required: true,

                        },

                        Phone: {
                            required: true,
                        },

                        People: {
                             required: true,
                        },

                        Notify: {
                             required: true,
                         }
                    },
                    messages: {
                        textUnit: {
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
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);