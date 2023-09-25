function Print() {
    $('#printedDate').show();
    $('#reportDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#IssueViewReport').html();
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
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 Username: '',
                 ModulePath: '/Modules/RoiPurchase/',
                 Issue: ''
             }, p);
        var v = 0;
        var selectedIndex = 0;
        var indexs = 0;
        var number = 0;
        var numbers = 0;
        var Autonumberitem = new Array();
        var issue = [];
        var IssueArray = [];
        var invt = [];
        var IssuedList = [];
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "PurchaseWebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                UnitId: 0,
                Unitupdate: 0,
                Unit1Id: 0,
                Unit1IdUpdate: 0,
                Unit2ID: 0,
                Unit2IDUpdate: 0
            },
            InitialSetup: function () {

                $(".unit").hide();

            },
            init: function () {

                eventFunction.InitialSetup();
                eventFunction.getCompanyInfo();
                eventFunction.GetPareintItems();
                eventFunction.GetAllUsers();
                eventFunction.issueget();
                eventFunction.GetInventoryList();
                $("#txtStartDate").datepicker({ changeMonth: true, changeYear: true });
                $("#txtEndDate").datepicker({ changeMonth: true, changeYear: true });

                $('#txtSearch').on('keyup', function () {
                    eventFunction.bindissue();
                });

               
                $('#txtqTY').keypress(function (evt) {
                    evt = (evt) ? evt : window.event;
                    var charCode = (evt.which) ? evt.which : evt.keyCode;
                    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                        return false;
                    }
                    return true;
                });

                //$("#ddlRecievedBy option:contains(" + SageFrameUserName + ")").attr("selected", "selected");
                $("#ddlRecievedBy").val(SageFrameUserName);

                $("#textitem").autocomplete({
                    source: Autonumberitem,
                    delay: 0,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        //$("#lblItemid").val(ids);
                        // var id = $('#textitem').val();
                        $('#lblItemid').val(ids);
                        eventFunction.config.method = "GetUnitOfItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON.stringify({ ids: ids });
                        eventFunction.config.ajaxCallMode = 4;
                        eventFunction.ajaxCall(eventFunction.config);

                    },


                });
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('#reportDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#IssueViewReport').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "IssueReport_" + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#CompanyDisplay').hide();
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
                    pdf.addHTML($("#IssueViewReport"), 0, 0, options, function () {
                        pdf.save('IssueReport_' + $('#txtStartDate').val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('#reportDate').hide();
                });
            

                $("#BtnAddIsue").unbind('click').on('click', function () {
                    var item = $("#lblItemid").val();
                    var unit = $("#ddlUnit").val();
                    var qts = $("#txtqTY").val();
                    var qtyintext = $("#txtQtyInText").val();

                    if (numbers != 100) {
                        if (item == "") {
                            jAlert('Please Fill The Item Name.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        } else if (unit == "") {
                            jAlert('Please Fill The Unit.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        } else if (qts == "") {
                            jAlert('Please Fill The Quentity.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        } else if (qtyintext == "") {
                            jAlert('Please Fill The Quentity in Text.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        }
                        else {

                            eventFunction.AddPurchase();
                            eventFunction.ResetAll();
                            //$("#tblAddItem").dialog("close");
                            numbers = 0
                        }

                    }
                    else {
                        var MyRows = $('table#IssueTempTable').find('tbody').find('tr');
                        $(MyRows[selectedIndex]).find('td:eq(0)').html($("#lblItemid").val());
                        $(MyRows[selectedIndex]).find('td:eq(1)').html($("#textitem").val());
                        $(MyRows[selectedIndex]).find('td:eq(2)').html($("#ddlUnit").val());
                        $(MyRows[selectedIndex]).find('td:eq(3)').html($("#ddlUnitText :selected").text());
                        $(MyRows[selectedIndex]).find('td:eq(4)').html($("#txtqTY").val());
                        $(MyRows[selectedIndex]).find('td:eq(5)').html($("#ddlUnitText :selected").attr('attr-conversion'));
                        selectedIndex = 0;
                        numbers = 0
                        eventFunction.ResetAll();
                    }
                });

                $("#btnAddItems").on('click', function () {
                    $("#tblAddItem").dialog({
                        'title': 'Add Items',
                        width: 300,
                        modal: true,
                        dialogClass: 'headingbg',
                        resizable: true,
                        dialogClass: 'popup-titlebg'
                    });
                });

                $("#btnPurchaseClose").on('click', function () {
                    $("#tblAddItem").dialog("close");
                });

                $("#btnAddIssue").on('click', function () {
                    $("#addIssueTable").show();
                    $("#issuedata").hide();
                    $(".report-filter").hide();
                    $("#btnAddIssue").hide();
                    $("#btnCancelIssue").show();
                    $('#AddTempTable').show();
                    
                });

                $("#btnView").on("click", function () {
                    eventFunction.GetIssueReport();
                    $('.report-view').show();
                });

                $("#ddlUnitText").on("change", function () {
                    $("#ddlUnit").val($("#ddlUnitText").val());
                });

                $("#btnCancelIssue").on('click', function () {
                    eventFunction.ResetAll();
                    location.reload();
                });

                $("#btnIssuSave").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {
                        eventFunction.SavePurchase();
                        eventFunction.ResetAll();
                        $('#ddlIssuedToStore').val('');
                        $('#ddlIssuedFrST').val('');
                        $('#IssueTempBody').empty();
                        eventFunction.init();
                        $("#btnAddIssue").show();
                    }
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
                        jAlert("Inserted successfully. Your Issue No. is " + data.d + ".", 'Information!!', function () { $.alerts.dialogClass = null; });
                        //location.reload();
                        eventFunction.ResetAll();
                        eventFunction.ResetBOx();

                        break;
                    case 2:
                        eventFunction.BindText(data);
                        break;
                    case 3:
                        eventFunction.BindItem(data);
                        break;
                    case 4:
                        eventFunction.BindDropdwonUnit(data.d);
                        break;
                    case 5:
                        IssuedList = JSON.parse(data.d);
                        if (p.Issue == 1) {
                            eventFunction.bindissue();
                        } else {
                            eventFunction.bindissuemain(data.d);
                        }
                        break;
                    case 7:
                        eventFunction.BindIssueReport(data.d);
                        break;
                    case 8:
                        eventFunction.BindIssueFromId(data);
                        break;
                    case 9:
                        eventFunction.BindUsers(data)
                        break;

                    case 10:
                        var companyInfo = JSON.parse(data.d);
                        $('#lblCompanyName').html(companyInfo.Name);
                        $('#lblCompanyPAN').html(companyInfo.PAN);
                        break;
                    case 11:
                        eventFunction.BindInventoryList(data.d);
                        break;
                }
            },
      
            //<<-----------------------------Post & Get Here ---------------------------------------->>
            GetInventoryList: function () {
                eventFunction.config.method = "GetInventoryItemList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getCompanyInfo: function () {
                eventFunction.config.method = "getCompanyInfo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindIssueFromId: function (data) {
                $("#issueDialog").html('');
                var datas = data.d;
                if (datas.length > 0) {
                    htmls = "<h5> Issue No : " + datas[0].ISNo + "</h5>";
                    htmls = "<div class='dataTables_wrapper no-footer'><table id='unitTable' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    //<th class='delete-heading'>Delete</th>
                    htmls += "<th>Item Name</th><th>Issue From</th><th>Issue To</th><th>Qnty</th><th>Unit</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.ISNo + "_>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.StName + "</td>";
                        htmls += "<td>" + value.IssToStName + "</td>";
                        htmls += "<td>" + value.Qnty + "</td>";
                        htmls += "<td>" + value.Symbol + "</td>";
                        htmls += "</tr>"
                        count++;
                    });
                    htmls += "</tbody>";
                    htmls += "</table></div>";
                    $('#issueDialog').html(htmls);
                    $("#issueDialog").dialog({
                        'title': 'Issue Details : ' + datas[0].ISNo,
                        'width': 800,
                        modal : true,
                        dialogClass: 'popup-titlebg',
                        "jQueryUI": true
                    });
                } else {
                    $('#issueDialog').html('No data');
                }
       
            },

            DeleteAdjust: function (item) {
                var id = parseInt(item.id.split("_")[1])
                var IMId = id;
                eventFunction.config.method = "DELETEissue";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ IMId: IMId });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetAllUsers: function () {
                eventFunction.config.method = "GetAllUsers";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 9;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetIssueReport: function () {

                var startDate = $("#txtStartDate").val();
                var endDate = $("#txtEndDate").val();
                var ISNo = $("#txtIssueNo").val();
                var itemname = $("#txtItemName").val();
                eventFunction.config.method = "GetIssueReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startDate: startDate, endDate: endDate, ISNo: ISNo, itemname: itemname })
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },

         
            BindIssueReport: function (data) {
                $("#IssueViewReport").show();
                $("#IssueViewReport").html();
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Issue Report <p style="text-align:center;margin:0;">From : ' + ($('#txtStartDate').val() == "" ? "Beginning" : $('#txtStartDate').val())  + '   To : ' + ($('#txtEndDate').val() == "" ? "End" : $('#txtEndDate').val()) + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='tableForViewReport' class='reportsprint' cellspacing='0' style='border:none;width:100%;border-collapse:collapse;'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th style='text-align:center;border:1px solid #575757;padding:2px;'>SN</th><th style='text-align:left;border:1px solid #575757;padding:2px;'>Item Name</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Quantity</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Unit</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Issued From</th><th style='text-align:center;border:1px solid #575757;padding:2px;'>Issued To</th><th>ISNo</th><th style='text-align:center;'>Issued On</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                var datas = JSON.parse(data);
                var tblQuantity = 0;
                if (datas.length > 0) {
                    var count = 1;
                    $.each(datas, function (index, value) {
                        var date = value.IssuedOn;
                        var word = date.split("T");
                        htmls += "<tr>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + count + "</td>";
                        htmls += "<td style='text-align:left;border:1px solid #575757;padding:2px;'>" + value.ITName + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Qnty + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.Symbol + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.StName + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.IssToStName + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + value.ISNo + "</td>";
                        htmls += "<td style='text-align:center;border:1px solid #575757;padding:2px;'>" + word[0] + "</td>";
                        htmls += "</tr>"
                        count++;
                        tblQuantity += parseFloat(value.Qnty);
                    });
                  
                }
                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='8' style='text-align:center;'> No Data Available</td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "<tfoot>";
                htmls += "<tr>";
                htmls += '<tr><th colspan=2 style="text-align:center;">Total:</th>';
                htmls += '<th style="text-align:center;border:1px solid #575757;padding:2px;">' + tblQuantity.toFixed(2) + '</th>';
                htmls += '<th colspan=5></th>';
                htmls += '</tr>';
                htmls += "</tfoot>";
                htmls += "</table>";

                $('#IssueViewReport').html(htmls);
            },


            issueget: function () {
                eventFunction.config.method = "getissuemain";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            SavePurchase: function () {

                var SuperMainlist = new Array();
                var IssueObjectDetails = new Array();
                var IssueObject = new Object();
                var MyRows = $('table#IssueTempTable').find('tbody').find('tr');
                for (var i = 0; i < MyRows.length; i++) {
                    var IssueDetailsObject = new Object();
                    IssueDetailsObject.ITID = parseInt($(MyRows[i]).find('td:eq(0)').html());
                    IssueDetailsObject.UsedUnitId = parseInt($(MyRows[i]).find('td:eq(2)').html());
                    // IssueDetailsObject.Qnty = parseInt($(MyRows[i]).find('td:eq(4)').html()) * parseInt($(MyRows[i]).find('td:eq(6)').html());
                    IssueDetailsObject.Qnty = parseInt($(MyRows[i]).find('td:eq(4)').html());
                    IssueDetailsObject.QntyInText = $(MyRows[i]).find('td:eq(5)').html();
                    IssueDetailsObject.ReceivedBy = p.Username;
                    //IssueDetailsObject.ReceivedBy = p.Username;
                    IssueObjectDetails.push(IssueDetailsObject);
                }
                IssueMain = new Object();
                IssueMain.IssueObjectDetails = IssueObjectDetails;
                //IssueMain.ISNo = $('#issuNo').val();
                //IssueMain.ISNo = '0';
                IssueMain.IssuedToSTId = parseInt($('#ddlIssuedToStore').val());
                IssueMain.IssuedFrSTId = parseInt($('#ddlIssuedFrST').val());
                IssueMain.ReceivedBy = $('#ddlRecievedBy').val();
                IssueMain.IssuedBy = p.Username;
                var jsonText = JSON2.stringify({ IssueObject: IssueMain });
                eventFunction.config.method = "SaveIssueToDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = jsonText;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            AddPurchase: function () {
                var htmls = '';
                $("#AddTempTable").show();
                $("#btnIssuSave").show();
                htmls += "<tr class='tableItem'>";
                htmls += "<td class='itemname' style='text-align:left;display:none;'>" + $('#lblItemid').val() + "</td>";
                htmls += "<td class='itemnameName' style='text-align:left'>" + $('#textitem').val() + "</td>";
                htmls += "<td class='unitDescri' style='display:none;'>" + $('#ddlUnit').val() + "</td>";
                htmls += "<td>" + $('#ddlUnitText :selected').text() + "</td>";
                htmls += "<td class='Quenity'>" + $('#txtqTY').val() + "</td>";
                htmls += "<td class='QuentityText' style='display:none;'>" + $('#txtQtyInText').val() + "</td>";
                htmls += "<td style='display:none;'>" + $('#ddlUnitText :selected').attr('attr-conversion') + "</td>";
                //htmls += "<td class='ReceiveBy'>" + $('#ddlItem :selected').text() + "</td>";
                htmls += "<td class='tdcenter'>" + "<img src='/images/edit.png' class='IssueEdit'  id='IssueEdit_" + number + "' value='Edit'/>" + "</td>";
                htmls += "<td class='tdcenter'>" + "<img src='/images/delete.png' class='IssueDelete'  id='IssueDelete_" + number + "' value='Delete'/>" + "</td>";
                htmls += "</tr>"
                number += 1;
                $("#IssueTempTable tbody").append(htmls);
                $(".IssueEdit").on('click', function () {
                    $("#tblAddItem").dialog("open");
                    var data = $(this).attr('id');
                    var splicedata = data.split('_');
                    var itemid = $(this).closest('tr').find(".itemname").html();
                    var index = parseInt(splicedata[1]);
                    indexs = parseInt(itemid);
                    selectedIndex = parseInt(index);
                    numbers = 100;
                    var table = $("#IssueTempTable");
                    var rows = table.find("tr.tableItem");
                    $('#textitem').val($(this).closest('tr').find(".itemnameName").html());
                    $('#lblItemid').text($(this).closest('tr').find(".itemname").html());
                    $('#ddlUnit').val($(this).closest('tr').find(".unitDescri").html());
                    $('#txtqTY').val($(this).closest('tr').find(".Quenity").html());
                    $('#txtQtyInText').val($(this).closest('tr').find(".QuentityText").html());
                    //$('#txtReceiveBy').val($(this).closest('tr').find(".ReceiveBy").html());
                    //var idd = $('#lblItemid').val();
                    var id = $(this).closest('tr').find(".itemname").html();
                    // eventFunction.config.method = "getunitbyItem"; GetUnitOfItemByID
                    eventFunction.config.method = "GetUnitOfItemByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ ids: id });
                    eventFunction.config.ajaxCallMode = 4;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#ddlUnitText').val($(this).closest('tr').find(".unitDescri").html());
                    $('#ddlUnit').val($(this).closest('tr').find(".unitDescri").html());
                    $("#btnIssuSave").show();

                });
                $(".IssueDelete").on('click', function () {
                    var data = $(this).attr('id');
                    var row = $(this).closest('tr');
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            var splicedata = data.split('_');
                            var index = parseInt(splicedata[1]);
                            row.remove();
                        }
                    });

                });
            },



            GetPareintItems: function () {
                eventFunction.config.method = "getgoodreceiveforissue";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getQuentityinText: function () {
                var numb = $("#txtqTY").val();
                eventFunction.config.method = "changeCurrencyToWords";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ numb: numb });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>>

          

            BindUsers: function (result) {
             
                var datas = result.d;   
                var htmls = "";
                $("#ddlRecievedBy").html('');
                htmls = "<option value='' disabled selected>-Select-</option>";
                if (datas.UserList.length > 0) {
                    $.each(datas.UserList, function (index, value) {
                        htmls += "<option value='" + value.UserName + "'>" + value.UserName + "</option>";
                    });
               
                }
                $("#ddlRecievedBy").html(htmls);
 
            },


            bindissue: function () {
                $("#issuedata").show();
                $("#issuedata").html('');
                datas = IssuedList;

                var htmls = "<table id='unitTableSS' class='sfGridwrapper display tablee-section' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                //<th class='delete-heading'>Delete</th>
                htmls += "<th>SN</th><th>Issue No </th><th>Issue To</th><th>Issued From</th><th>Issued On</th><th class='tdcenter'>View</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {           
                    var count = 1
                    $.each(datas, function (index, value) {           
                        var date = new Date(value.IssuedOn);
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.ISNo.toLowerCase().includes(search) || value.StName.toLowerCase().includes(search) || value.IssToStName.toLowerCase().includes(search) || value.IssuedOn.toLowerCase().includes(search) || search == '') {
                            htmls += "<tr class='tableItem' id=" + value.IMId + "_>";
                            htmls += "<td>" + count + "</td>";
                            htmls += "<td>" + value.ISNo + "</td>";
                            htmls += "<td>" + value.IssToStName + "</td>";
                            htmls += "<td>" + value.StName + "</td>";
                            htmls += "<td>" + (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear() + "</td>";
                            htmls += "<td class='tdcenter'>" + "<img src='/images/view.png' class='viewIssue preview-icon' type='button'  id='" + value.IMId + "' value='View' /></td>";
                            //htmls += "<td>" + value.Remarks + "</td>";
                            //htmls += "<td>" + "<img src='/images/edit.png' class='UnitEdit' type='button'  id='" + value.UnitID + "_" + value.UnitDesc + "' value='Edit' /></td>";
                            //htmls += "<td>" + "<img src='/images/delete.png' class='UnitDelete' type='button'  id=_" + value.IMId + " value='Delete' /></td></tr>";
                            htmls += "</tr>"
                            count++;
                        }
                    });
                } else {
                   
                    htmls += "<tr>";
                    htmls += "<td colspan=6 style='text-align:center;'> No Data Available</th>";
                    htmls += "</tr>";
                }

                htmls += "</tbody>";
                htmls += "</table>";
                $('#issuedata').html(htmls);

                
                $(".UnitDelete").on('click', function () {
                    var item = this;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            eventFunction.DeleteIssue(item);
                            eventFunction.ResetAll();
                        }
                    });
                    return false;
                });


                $("#unitTableSS").on('click', '.viewIssue', function () {

                    var imid = $(this).attr('id');
                    eventFunction.config.method = "GetIssueDetailsbyId";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON.stringify({ imid: imid});
                    eventFunction.config.ajaxCallMode = 8;
                    eventFunction.ajaxCall(eventFunction.config);
                });
            },

            BindText: function (result) {
                var datas = result.d;
                $("#txtQtyInText").val(datas);

            },
            BindItem: function (result) {
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = '';

                    $.each(datas, function (index, value) {
                      
                        Autonumberitem.push({ label: value.ITName, id: value.ITId });
                    });


                }

            },


            BindDropdwonUnit: function (result) {
                datas = JSON.parse(result);
                var htmls = "";
                $("#ddlUnitText").html('');
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "' attr-conversion='" + value.Conversion + "'>" + value.Symbol + "</option>";
                    });
                    $(".unit").show();
                }
                $("#ddlUnitText").html(htmls);
                $("#ddlUnit").val( $("#ddlUnitText").val());
            },

            bindissuemain: function (result) {
                issueList = JSON.parse(result);
                issue = [];
                if (issueList.length > 0) {
                    $.each(issueList, function (index, value) {
                        issue.push({ label: value.ISNo, id: value.IMId });
                    });
                }

                $("#txtIssueNo").autocomplete({
                    source: issue,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#txtIssueNo").val(ids);
                    }

                });
            },

            BindInventoryList: function (result) {
                invList = JSON.parse(result);
                invt = [];
                if (invList.length > 0) {
                    $.each(invList, function (index, value) {
                        if (value.IsProdMaterial == true) {
                            invt.push({ label: value.ITName, id: value.ITId });
                        }
                    });
                }

                $("#txtItemName").autocomplete({
                    source: invt,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#txtItemName").val(ids);
                    }

                });
            },
            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#ddlUnit').text('');
                $('#ddlUnit').val('');
                $('#lblItemid').text("");
                $('#textitem').val('');
                $('#ddlItem').val('');
                $('#ddlUnit').val('');
                $('#txtqTY').val('');
                $('#txtQtyInText').val('');
                $('#txtReceiveBy').val('');
                $('#ddlUnitText').val('');
        
            },

            ResetBOx:  function () {
                $("#addIssueTable").hide();
                $("#issuedata").show();
                $(".report-filter").show();
                $("#btnAddIssue").show();
                $('#AddTempTable').hide();
                $("#btnCancelIssue").hide();
                $('#btnIssuSave').hide();
                
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        ctl19$ddlIssuedToStore: {
                            required: false,
                        },
                        ddlIssuedFrST: {
                            required: false
                        },
                        ddlRecievedBy: {
                            required: false
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
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);