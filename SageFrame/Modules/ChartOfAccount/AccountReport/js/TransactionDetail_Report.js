(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ChartOfAccount/AccountReport/'

             }, p);
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "Reportwebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0
            },
            InitialSetup: function () {
                //eventFunction.getAllFinancialAcForGrid();
            },
            getUrlVars: function () {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            },
            init: function () {
                eventFunction.InitialSetup();
                eventFunction.getFinancialAc();


                $("#btnAdd").click(function () {
                    $("#divForTransactionDetail").hide();
                    $("#btnAdd").hide();
                    $(".AccountForm").show();
                });

                $("#btnView").click(function () {
                    eventFunction.getcompanyInfo();
                    eventFunction.GetTransactionDetailReport();
                });

                $("#buttonPdf").on("click", function () {

                    eventFunction.GetTransactionDetailReport();

                    $("#divForTransactionDetail").tableExport({
                        //bootstrap: false
                        type: 'pdf',
                    });

                });

                $("#button").on("click", function () {
                    eventFunction.GetTransactionDetailReport();
                    $("#divForTransactionDetail").table2excel({
                        //exclude: ".noExl",
                        name: "Worksheet Name",
                        filename: "SomeFile" //do not include extension
                    });
                });
                var id = eventFunction.getUrlVars()['id'];
                var Todate = eventFunction.getUrlVars()['Todate'];
                var Fromdate = eventFunction.getUrlVars()['Fromdate'];

                if (!(id == undefined)) {
                    $('#ddGL_Name').val(id);
                    $('#txtFrom').val(Fromdate);
                    $('#txtTo').val(Todate);
                    $('#btnView').trigger('click');
                }
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

                    case 1:
                        eventFunction.bindGL_Name(data.d);
                        break;
                    case 2:
                        eventFunction.bindCompanyInfo(data.d);
                        break;

                    case 3:
                        eventFunction.bindGetTransactionDetailReport(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
                switch (parseInt(eventFunction.config.ajaxFailureMode)) {
                    case 2:
                        jAlert("Error!" + console.log(error), 'Error!!', function () { $.alerts.dialogClass = null; });
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>

            getcompanyInfo: function () {
                eventFunction.config.method = "getcompanyInfo";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getFinancialAc: function () {
                eventFunction.config.method = "getFinancialAc";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetTransactionDetailReport: function () {
                
                eventFunction.config.method = "GetTransactionDetailReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ From: $("#txtFrom").val(), To: $("#txtTo").val(), GL_ID: $(".ddGL_NameClass").val() == null ? 0 : $(".ddGL_NameClass").val() });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindCompanyInfo: function (result) {
                
                $("#divForTransactionDetail").hide();
                var From = $("#txtFrom").val();
                var To = $("#txtTo").val();
                datas = JSON.parse(result);
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
                        htmls += ("<tr>");
                        htmls += ("<td style='text-align:right; font-size:15px;'> From : " + From + "  To : " + $("#txtTo").val() + "</td>");
                        htmls += ("</tr>");
                        htmls += ("</table>");
                        htmls += ("</div>");
                    });
                    if (datas.length == 1) {
                        $("#divForTransactionDetail").html(htmls);

                    }
                }
            },
            bindGetTransactionDetailReport: function (result) {

                $("#divForTransactionDetail").show();
            
                var tDebit = 0;
                var tCredit = 0;
                var tmpDebid = 0;
                var tmpCredid = 0;
                datas = JSON.parse(result);

                if (datas.length > 0) {
                    $('#btnPrint').show();
                    var htmls = "<table id='tblOfFinancialAc' class='sfGridwrapper nowrap display' cellspacing='0' style='border:none;width:100%;'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th>Sn </th><th style='width: 88px;'>Date</th><th>Voucher No</th><th>Descriptions</th><th>Particulars</th><th style='width: 150px;text-align:right;'>Debit</th><th style='width: 150px;text-align:right;'>Credit</th><th style='width: 150px;text-align:right;'>Balance</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"
                    var count = 1;
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td >" + count + "</td>";
                        if (value.TransactionID == 0) {
                            htmls += "<td >" + value.Date.split(' ')[0] + "</td>";
                            htmls += "<td >" + value.VoucherNo + "</td>";
                            htmls += "<td >" + value.Descriptions + "</td>";
                            htmls += "<td >" + value.Particulars + "</td>";
                            htmls += "<td ></td>";
                            htmls += "<td ></td>";
                        }
                        else {
                            tDebit += value.Debit;
                            tCredit += value.credit;
                            tmpDebid += value.Debit;
                            tmpCredid += value.credit;
                            htmls += "<td >" + value.Date.split(' ')[0] + "</td>";
                            htmls += "<td >" + value.VoucherNo + "</td>";
                            htmls += "<td >" + value.Descriptions + "</td>";
                            htmls += "<td >" + value.Particulars + "</td>";
                            htmls += "<td style='text-align:right;' class='isGrouptrue'>" + value.Debit.toFixed(2) + "</td>";
                            htmls += "<td style='text-align:right;' class='isGrouptrue'>" + value.credit.toFixed(2) + "</td>";

                        }
                        if (value.Balance >= 0) {
                            htmls += "<td style='text-align:right;' class='isGrouptrue'>" + value.Balance.toFixed(2) + "(DR)" + "</td>";

                        }
                        else if (value.Balance < 0) {
                            htmls += "<td style='text-align:right;' class='isGrouptrue'>" + Math.abs(value.Balance).toFixed(2) + "(CR)" + "</td>";

                        }
                        htmls += "</tr>"
                        //  htmls += '<tr class="isGrouptrue"><td></td><td style="text-align:right;">Sub Total : </td><td></td><td></td><td></td><td style="text-align:right;">' + tmpDebid.toFixed(2) + '</td><td style="text-align:right;">' + tmpCredid.toFixed(2) + '</td></tr>';
                        // htmls += '</tbody><tfoot><tr><th></th><th style="text-align:right;">Total : </th><th></th><th style="text-align:right;">' + tDebit.toFixed(2) + '</th><th style="text-align:right;">' + tCredit.toFixed(2) + '</th></tr>';
                        // htmls += '<tr><th></th><th style="text-align:right;">Grand Total : </th><th></th><th style="text-align:right;">' + tDebit.toFixed(2) + '</th><th style="text-align:right;">' + tCredit.toFixed(2) + '</th></tr>';
                        // htmls += '</tfoot></table>';
                        count++;
                    });

                    htmls += "<thead>"
                    htmls += "</thead>"
                    htmls += "</tbody>";
                    htmls += "<tfoot>";
                    htmls += '<tr class="isGrouptrue"><td></td><td></td><td style="text-align:right;">Total : </td><td></td><td></td><td style="text-align:right;">' + tmpDebid.toFixed(2) + '</td><td style="text-align:right;">' + tmpCredid.toFixed(2) + '</td></tr>';
                    htmls += "</tfoot>";
                    htmls += "</table>";
                    $('#divForTransactionDetail').append(htmls);
                }
            },

            bindGL_Name: function (result) {
                $(".ddGL_NameClass").show();
                $(".ddGL_NameClass").html('');

                data = JSON.parse(result)
                var htmls = "";
                htmls += '<option disabled selected> -Select- </option>';
                if (data.length > 0) {
                    var pid = 0;
                    $.each(data, function (index, value) {
                        if (value.isGroup == 0) {
                            htmls += '<option value="' + value.FinancialAcID + '">' + value.items + '</option>';
                        }
                        else {
                            htmls += '<optgroup label="' + value.items + '" value="' + value.FinancialAcID + '"></optgroup>';
                            pid = value.FinancialAcID;
                        }
                    });
                    $(".ddGL_NameClass").html(htmls);
                } else {
                    $(".ddGL_NameClass").html("No Data");
                }
            },

        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
