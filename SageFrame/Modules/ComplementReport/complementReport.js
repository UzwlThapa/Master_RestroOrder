function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#reportDisplay').html();
    $('#printedDate').hide();
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
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: ''
             }, p);
        var v = 0;
        var TotalAmount = 0;
        var totamount = 0;
        var name = [];
        var checks = [];
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var companyProf = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: "/Modules/RestroComplementary/services/ComplementaryWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MemberID: 27,
                MemberIDUpdate: 0
            },
            InitialSetup: function () {

                $(".picker").datepicker({
                    dateFormat: "yy-mm-dd"
                }).datepicker("setDate", "0");


                $("#btnView").on("click", function () {
                    $('.report-view').show();
                    companyProf.getitemsalesReport();
                })

                companyProf.GetRoom();
                companyProf.GetTable();
            },
            init: function () {
                companyProf.InitialSetup();

                $("#selroom").on('change', function () {
                    if ($("#selroom").val() == '0') {
                        companyProf.GetTable();
                    }
                    else {
                        var restroRoomId = $("#selroom").val();
                   
                        companyProf.config.method = "getRestroTableByRoomID";
                        companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                        companyProf.config.data = JSON2.stringify({
                            restroRoomId: restroRoomId
                        });
                        companyProf.config.ajaxCallMode = 3;
                        companyProf.ajaxCall(companyProf.config);
                    }
                });

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#reportDisplay').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ComplementReport_" + $('#txtStartDate').val() + '_' + $("#endDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();

                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#reportDisplay"), 0, 0, options, function () {
                        pdf.save('ComplementReport_' + $('#txtStartDate').val() + '_' + $("#endDate").val() + '.pdf');
                     
                    });
                    $('#printedDate').hide();
                });
            },



            ajaxCall: function (config) {
                $.ajax({
                    type: companyProf.config.type,
                    contentType: companyProf.config.contentType,
                    async: companyProf.config.async,
                    cache: companyProf.config.cache,
                    url: companyProf.config.url,
                    data: companyProf.config.data,
                    dataType: companyProf.config.dataType,
                    success: companyProf.ajaxSuccess,
                    error: companyProf.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        companyProf.BindComplementReport(data.d);
                        break;
                    case 2:
                        companyProf.BindRoom(data.d);
                        break;

                    case 3:
                        companyProf.BindTable(data.d);
                        break;
                }
            },
            ajaxFailure: function (data) {

                // alert("Department Not Unique");

            },


            //-----------------------------------------getdata---------------------------\\

            GetRoom: function () {

                companyProf.config.method = "getRestroRoom";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 2;
                companyProf.ajaxCall(companyProf.config);
            },

            GetTable: function () {
                companyProf.config.method = "getRestroTable";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 3;
                companyProf.ajaxCall(companyProf.config);
            },


            //---------------------------------------------BindData-------------------------------------------\\
            BindRoom: function (result) {
                roomlist = JSON.parse(result);
                if (roomlist.length > 0) {
                    var htmls = "";
                    htmls += "<option value='0' selected>All</option>";
                    $.each(roomlist, function (index, value) {
                        htmls += "<option value='" + value.restroRoomId + "'>" + value.restroRoom + "</option>";
                    });

                    $("#selroom").html(htmls);
                }
            },


            BindTable: function (result) {
                tablelist = JSON.parse(result);
                $("#seltable").html('');
                if (tablelist.length > 0) {
                    var htmls = "";
                    htmls += "<option value='0' selected>All</option>";
                    $.each(tablelist, function (index, value) {
                        htmls += "<option value='" + value.restrotableId + "'>" + value.restrotableTitle + "</option>";
                    });

                    $("#seltable").html(htmls);
                }
            },

            getitemsalesReport: function () {
                var Start = $("#txtStartDate").val() + " 00:00";
                var EndDate = $("#endDate").val() + " 23:59";
                var tableid = $("#seltable").val();
                var roomid = $("#selroom").val();
                var itemname = $("#txtItemName").val() == null ? '' : $("#txtItemName").val();
                companyProf.config.method = "getComplementsalesreport";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ Start: Start, EndDate: EndDate, tableid: tableid, roomid: roomid, itemname: itemname });
                companyProf.config.ajaxCallMode = 1;
                companyProf.ajaxCall(companyProf.config);
            },

            BindComplementReport: function (result) {
                var totalQty = 0;
                var totalRate = 0;
                var totalAmt = 0;
                $("#reportDisplay").show();
                $("#reportDisplay").html('');
                salesList = JSON.parse(result);
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Complementary Report </p> <p style="text-align:center;margin:0;">From :  ' + $('#txtStartDate').val() + ' To :  ' + $('#endDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Cashtable' class='sfGridwrapper reportsprint display' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>BillDate</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Cost Center Name </th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Item Name </th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Details</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Qty</th><th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Rate</th><th class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Net Amount </th><th style='text-align:center;border:1px solid #575757;padding:2px;'>IsCombo</th>"
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (salesList.length > 0) {
                    $.each(salesList, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Date + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.CostCenterName + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ITName + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.Details + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Quantity + " " + value.ITUnit + "</td>";
                        htmls += "<td class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Rs. " + value.rate + "</td>";
                        htmls += "<td class='tdrate' style='text-align:right;border:1px solid #575757;padding:2px;'>Rs. " + parseFloat(value.NetAmount).toFixed(2) + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.IsCombo + "</td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);
                        totalQty += parseFloat(value.Quantity);
                        totalRate += value.rate;
                        totalAmt += value.NetAmount;
                    });


                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='8' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';

                }

                htmls += "<tfoot>"
                htmls += "<tr>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='f' colspan='4' style='text-align:right;'>Total </th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + totalQty + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + totalRate + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' class='tot-rig f'>" + totalAmt + "</th>";
                htmls += "<th style='text-align:right;border:1px solid #575757;padding:2px;' colspan=2></th>";
                htmls += "</tr>"
                htmls += "</tfoot>"
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#reportDisplay').html(htmls);
         

            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        FirstName: {
                            required: true,
                        },



                        PaidAmount: {
                            required: true,
                            number: true,
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
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);