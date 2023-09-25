var isButtonClicked = false;
var salesMaster = 0;
function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode

    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;

    return true;
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $('#tabs').css('display', 'block');
    $.companyDashboardcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RestroDashboard/',
                 HostUrl: '',
                 TypeId: '',
                 numpin: ''
             }, p);
        var v = 0;
        var username = "";
        var CustName = "";
        var membershipfor = "";
        var CustAddress = "";
        var pinfor = "";
        var tabletoshift = "";
        var CustPAN = "";
        var logoInfo = "";
        var body = "";
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
                MenuId: 0,
                Menuupdate: 0,
                RoomId: 0,
                OrderId: 0,
                OrderUpdateId: 0,
                ShiftID: 0


            },
            InitialSetup: function () {
                DashboardFunction.GetUnpaidBills();
                NumCodeSetup();
                setInterval(function () { DashboardFunction.GetUnpaidBills() }, 60000);

            },
            init: function () {
                DashboardFunction.InitialSetup();
               
                $("#UnpaidBills").on("click", ".btnViewBill", function () {
                    var ids = $(this).attr('id');
                    DashboardFunction.GetBill(ids);
                    isButtonClicked = true;
                    salesMaster = ids;
                    $('#InvoiceType').html('INVOICE');
                    $(this).prev('.ui-widget-overlay').dialog('close'); 
                });

                $("#UnpaidBills").on("click", ".btnPayBill", function () {
                    var datas = $(this).attr('id').split("_");
                    payment(datas[0]);
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
                        DashboardFunction.bindUnpaidBillsData(data.d);
                        break;
                    case 1:
                        print();
                        $('#BillingView').dialog('close');
                        break;
                }
            },
            ajaxFailure: function () {

            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            
            GetBill: function (salesMasterId) {
                getBill(salesMasterId, false);
                $('#BillingView').dialog({
                    'title': 'Vat Bill',
                    width: '350',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'top']
                });

                $('#btnPrints').unbind('click').on('click', function () {
                    //DashboardFunction.print();
                    $('#divPrintedOn').text(formatAMPM());
                    DashboardFunction.config.method = "savePrintCount";
                    DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                    DashboardFunction.config.data = JSON2.stringify({
                        Printcount: (parseInt($('#hdfPrntCnt').val()) + 1), BillNo: parseInt($('#hdfSMID').val()), PrintedBy: SageFrameUserName
                    });
                    DashboardFunction.config.ajaxCallMode = 1;
                    DashboardFunction.ajaxCall(DashboardFunction.config);
                });
            },
            GetUnpaidBills: function () {
                DashboardFunction.config.method = "GetUnpaidBills";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.ajaxCallMode = 0;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            bindUnpaidBillsData: function (datas) {
                var htmls = "";
                htmls += "<table id='tblforunpaidbills'>";
                htmls += "<thead><th>Bill No</th><th>Table</th><th>Amount</th><th></th></thead><tbody>";
                $.each(eval(datas), function (index, item) {
                    htmls += "<tr><td>" + item.BillNo + "</td>";
                    htmls += "<td>" + item.TableName + "</td>";
                    htmls += "<td>" + item.BillAmount + "</td>";
                    htmls += "<td><label id='" + item.salesMasterId + "' class='sfBtn btnViewBill restro-btn' style='padding:1px 4px;margin-right:10px;'>View Bill</label>";
                    htmls += "<label id='" + item.salesMasterId + "_" + item.CusID + "_" + item.Customer.replace(/['"]+/g, '') + "_" + item.Address + "_" + item.PAN + "_" + item.BillNo + "_" + item.BillAmount + "' class='sfBtn btnPayBill restro-btn' style='padding:1px 4px;'>Pay Bill</label></td></tr>";
                });
                htmls += "</tbody></table>";
                $("#UnpaidBills").html(htmls);
                $("#tblforunpaidbills").dataTable({
                    "jQueryUI" : true,
                    "ordering": false,
                     "lengthMenu": [[20,50, 100, -1], [20, 50, 100, "All"]],
             "iDisplayLength": 20,
                });
                $('div.dataTables_filter input').addClass('sfInputbox');
            },

            //<<----------------------------- Bind Here ---------------------------------------->>

            
            Reset: function () {
                $(".ui-dialog-content").dialog("close");
            },
        };
        DashboardFunction.init();
    };
    $.fn.companyDashboardEDIT = function (p) {
        $.companyDashboardcreate(p);
    };
})(jQuery);
function print() {
    var contents = $('#customer-bill').html();
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

function SendToCBMS() {
    //var evtobj = window.event ? event : e
    //if (evtobj.keyCode == 86 && evtobj.altKey && evtobj.ctrlKey && isButtonClicked) {
        isButtonClicked = false;
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + "/Services/RestroWebservice.asmx/SendToCBMS",
            data: JSON.stringify({ salesMasterId: salesMaster }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = data.d;
                if (result == "True") {
                    getBill(salesMaster, false);
                    $('#InvoiceType').html('TAX INVOICE');
                    $('#printno').hide();
                    print();
                    $('#BillingView').dialog('close');
                    jAlert("Bill Successfully Printed.", "Information", function () {
                        location.reload();
                    });
                } else {
                    jAlert("Sorry some error occured. Contact the support team.", "Error!!");
                }
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
    //}
}