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
        var logoInfo = 0
        var PrintValue = "";
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
                HouseKeeping.getcompanyInfo();
            },

            init: function () {
                HouseKeeping.InitialSetup();
                $('#btnPrint').hide();
                $('#btnView').on("click", function () {
                    if ($("#txtStartDate").val() == "") {
                        alert('Enter start date');
                    }
                    else if ($("#txtEndDate").val() == "") {
                        alert('Enter End date');
                    }
                    else {
                        HouseKeeping.getLostNFoundreport();
                    }
                });

                $('#btnPrint').on("click", function () {
                    logoInfo += PrintValue;
                    HouseKeeping.print(logoInfo);
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
                        HouseKeeping.bindgetcompanyInfo(data);
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
                    case 7:
                        HouseKeeping.BindLnfReport(data);
                   // case 8:


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


            SaveLostAndFound: function () {
                var obj = {
                    LF_ID: $('#txtID').val(),
                    RoomType: $('#dropDownRooms').val(),
                    Room: $('#ddRoomName').val(),
                    Date: $('#txtDate').val(),
                    Guest_Name: $('#txtGName').val(),
                    Item_Name: $('#txtItem').val()
                };
                if ($('#radMissing').is(':checked')) {
                    obj.Type = $('#radMissing').val();
                }
                else if ($('#radFound').is(':checked')) {
                    obj.Type = $('#radFound').val();
                }

                HouseKeeping.config.method = "SaveLostAndFound";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ obj: obj });
                HouseKeeping.config.ajaxCallMode = 1;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            DeleteItem: function (LF_ID) {
                HouseKeeping.config.method = "DeleteLostAndFound";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = JSON.stringify({ LF_ID: LF_ID });
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

            getcompanyInfo: function () {
                HouseKeeping.config.method = "getcompanyInfo";
                HouseKeeping.config.url = HouseKeeping.config.baseURL + HouseKeeping.config.method;
                HouseKeeping.config.data = HouseKeeping.config.data;
                HouseKeeping.config.ajaxCallMode = 2;
                HouseKeeping.ajaxCall(HouseKeeping.config);
            },

            ////<<-----------------------------------BindTable Here ------------------------------------->>>


            BindLnfReport: function (result) {
                
                $("#BindValues").show();
                $("#BindValues").html('');
                var datas = result.d;
                if (datas.length > 0) {
                    $('#btnPrint').show();
                    var htmls = "<table id='LostAndFoundlisting' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>SN</th><th>Room Type</th><th>Room</th><th>Date</th><th>Guest Name</th><th>Item Name</th><th>Type</th>";
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
                        htmls += "<td >" + value.Item_Name + "</td>";
                        htmls += "<td >" + value.Type + "</td>";
                        htmls += "</tr>"
                        count++;
                    });

                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#BindValues').html(htmls);
                    PrintValue += htmls;
                    $('#LostAndFoundlisting').dataTable(
                       {
                           "jQueryUI": true,
                           ordering: false,
                           dom: 'Bfrtip',

                           buttons: [
                               'excel', 'pdf'
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

            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $('#txtId').val(0);
                $('#txtName').val('');
                $('#txtEmail').val('');
                $('#txtAddress').val('');
                $('#txtCountry').val('');
            },
        };
        HouseKeeping.init();
    };
    $.fn.MainHouseKeeping = function (p) {
        $.HouseKeepingFunction(p);
    };
})(jQuery);
