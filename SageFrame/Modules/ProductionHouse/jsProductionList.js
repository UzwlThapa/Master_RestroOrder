function Print() {
    $('#printedDate').show();
    $('.edit-heading').hide();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#ProductionList').html();
    $('#printedDate').hide();
    $('.edit-heading').show();
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
    $('#tabs').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ProductionHouse/',
                 userName: ''
             }, p);
        var v = 0;
        var i = 2;
        var AutocompleteIngredient = [];
        var htmls = "";
        var number = 0;
        var numbers = 0;
        var PurchaseArray = [];
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
                baseURL: p.ModulePath + "ProductionHouse.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0,
                ItemID: 0,
                updateGroup: 0,
                groupID: 0,
                countExtra: 0,
            },
            InitialSetup: function () {

           
                eventFunction.GetStore();
            },
            init: function () {

                eventFunction.InitialSetup();
           
                $('#btnView').on('click', function () {
                    eventFunction.GetProductionList();
                    $('.report-view').show();
                });

                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    $('.edit-heading').hide();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#ProductionList').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ProductionList_" + $("#txtStartDate").val() + '-' + $("#txtEndDate").val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                    $('.edit-heading').show();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                }); 

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    $('.edit-heading').hide();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#ProductionList"), 0, 0, options, function () {
                        pdf.save('ProductionList_' + $("#txtStartDate").val() + '-' + $("#txtEndDate").val() + '.pdf');
                    });
                    $('#printedDate').hide();
                    $('.edit-heading').show();
               
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
                        eventFunction.BindStore(data.d);
                        break;
                    case 1:
                        eventFunction.BindProductionList(data.d);
                        break;
                    case 2:
                        eventFunction.BindProductionDetailsList(data.d);
                        break;
              
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            GetStore: function () {
                eventFunction.config.method = "getIssueToDDlHirerchy";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);

            },

            GetProductionList: function () {
                var storeid = $("#SelStoreName").val() == '' ? 0 : $("#SelStoreName").val();
                var datefrom = $("#txtStartDate").val();
                var dateTo = $("#txtEndDate").val();
              

                eventFunction.config.method = "getProductionMain";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({
                    fromDate: datefrom, toDate: dateTo, storeid: storeid
                });
                eventFunction.config.ajaxCallMode = 1
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindStore: function (result) {
                datas = JSON.parse(result);
                $("#SelStoreName").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' selected>-All-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.STId + "'>" + value.StName + "</option>";
                    });
                    $("#SelStoreName").html(htmls);
                }

            },


            BindProductionList: function (result) {
                $("#ProductionList").show();
                $("#ProductionList").html('');
                Prodlist = JSON.parse(result);
                var Item = '';
                var htmls = '';
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">ProductionList From ' + $('#txtStartDate').val() + ' To ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';
                htmls += "<table id='Brandtable' class='reportsprint' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th> Item Name</th><th>Quantity</th><th>Unit</th><th>Store</th><th> Added On</th><th class='edit-heading' style='text-align:center;'>View</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (Prodlist.length > 0) {                
                    $.each(Prodlist, function (index, value) {
                        var date = value.AddedOn;
                        var split = date.split("T");
                        var dta = split[0];
                        htmls += "<tr>";
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.Symbol + "</td>";
                        htmls += "<td>" + value.StName + "</td>";
                        htmls += "<td>" + dta + "</td>";
                        htmls += '<td class="edit-heading" style="text-align:center;"><label id="' + value.ProductionMainId + '_' + value.ITName + '" class="view icon-preview"/></td>';
                        htmls += "</tr>"  
                    });   
                }

                else {
                    htmls += "<tr>";
                    htmls += "<td colspan='6' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#ProductionList').html(htmls);

                $("#Brandtable").on('click', '.view', function () {
                   
                    var ids = $(this).attr('id');
                    var data = ids.split('_');
                    var id = data[0];

                    eventFunction.config.method = "GetProductionDetailsByID";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: id });
                    eventFunction.config.ajaxCallMode = 2;
                    eventFunction.ajaxCall(eventFunction.config);

                    $('#DivForViewItemByID').dialog(
                        {
                            'title': data[1] + ' : Production List',
                            "resize": "auto",
                            modal: true,
                            width: 400,
                            dialogClass: 'popup-titlebg',
                        });
                });
            },




            BindProductionDetailsList: function (result) {

                datas = JSON.parse(result);
                $("#DivForViewItemByID").html('');
                if (datas.length > 0) {
                    var htmls = '';
                    var Item = '';
                    var a = 0;
                    htmls += "<table id='tableForViewItemByID' class='sfGridwrapper display'><thead><tr><th> Item Name</th><th>Quantity</th><th>Unit</th></tr></thead><tbody>";
                    var valids = "";
                    $.each(datas, function (index, value) {
                        a++;
                        htmls += '<tr>';
                        htmls += "<td>" + value.ITName + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.Symbol + "</td>";
                        htmls += '</tr>';
                    });
                    htmls += "</tbody></table>";
                    $("#DivForViewItemByID").append(htmls);
                 
                }
                else {
                    $("#DivForViewItemByID").append("<br/>  No Data");
                    //$("#DivGetInventoryByID").append("<br/>  No Data");
                }
            },

            //<<-----------------------------------Reset & Validation ------------------------------------->>>
          

        };


        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);