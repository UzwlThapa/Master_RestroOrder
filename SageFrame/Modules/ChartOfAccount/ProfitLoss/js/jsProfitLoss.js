/// <reference path="../../../Roi_CounterPerson/jquery.dataTables.min.js" />
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ChartOfAccount/ProfitLoss/webService/'
             }, p);
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
                baseURL: p.ModulePath + "wsProfitLoss.asmx/",
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
            init: function () {
        
                $("#btnView").on('click',function () {
                    $('.report-view').show();
                    eventFunction.getAllFinancialAcForGrid();
                });
                $("#btnExport").on('click', function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#divForBalanceSheet').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "ProfitLoss_" + $('#txtDate').val() + ".xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();

                    $('#printedDate').hide();
                });
                $('#btnPrint').on('click', function () {
                    $('#printedDate').show();
                    $('#lblPrintedOn').html(new Date());
                    var contents = $('#divForBalanceSheet').html();
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
                });

                $('#btnPdf').on('click', function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.3;
                    pdf.addHTML($("#divForBalanceSheet"), 0, 0, options, function () {
                        pdf.save('ProfitLoss_' + $('#txtDate').val() + '.pdf');

                    });
                    $('#printedDate').hide();
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
                    case 1:
                        break;
                    case 3:
                        eventFunction.bindAllFinancialAcForGrid(data.d);
                        break;
                    case 4:
                        eventFunction.bindFinancialAcDetails(data.d);
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

            getAllFinancialAcForGrid: function () {
                var startdate = $("#txtStartDate").val();
                var enddate = $("#txtEndDate").val();
                eventFunction.config.method = "getAllFinancialAcForGrid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ startdate: startdate, enddate: enddate });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindAllFinancialAcForGrid: function (result) {
                $("#divForBalanceSheet").html('');
                $("#divForBalanceSheet").show();
                data = JSON.parse(result);
                var htmls = "";
                var ShowZero = $('#sltIsZero').val() == "Yes" ? true : false;
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Profit & Loss Statement For ' + $('#txtStartDate').val() + ' to ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';

                //Updated By Bishal Open
                htmls += '<div class="sfCol_50"><table id="tblOfFinancialAcDr" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;">' +
                    '<thead><tr style="font-weight: bold;background-color: #ff9933;color: white;">' +
                    '<th style="width: 100px;text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">EXPENSES OR LOSSES </th>' +
                    '<th style="width: 20px;text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;font-weight:bold;">(Dr.) Amount</th>' +
                    '</tr></thead><tbody id="tbl_PLDr"></tbody></table></div>';
                htmls += '<div class="sfCol_50"><table id="tblOfFinancialAcCr" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;">' +
                    '<thead><tr style="font-weight: bold;background-color: #ff9933;color: white;">' +
                    '<th style="width: 100px;text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">INCOME OR GAIN</th>' +
                    '<th style="width: 20px;text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">(Cr.) Amount</th>' +
                    '</tr></thead><tbody id="tbl_PLCr"></tbody></table></div>';

                $("#divForBalanceSheet").append(htmls);

                if (data.length > 0) {

                    var htmDr = '';
                    var htmCr = ''; 
                    var drlist = [];
                    var crlist = []; 
                    var drdiff = 0;
                    var crdiff = 0;

                    //Creating two list of datas for Dr value and Cr Value
                    $.each(data, function (index, value) { 
                        if (value.IsDebit == false) {                            
                            crlist.push(value);
                        }
                        if (value.IsDebit == true) {
                            drlist.push(value);
                        }
                    });
                     
                    var grandTotalDr = 0;
                    var grandTotalCr = 0; 

                    //Looping inside Debit List 
                    // Opening
                    var opening = drlist.filter((item) => item.FinancialAcName.toLowerCase() == 'opening stock');
                    htmDr += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                    htmDr += `<td style="text-align:left;border:1px solid #575757;">${opening[0].FinancialAcName}</td>`;
                    htmDr += `<td style="text-align:right;border:1px solid #575757;">${opening[0].Debit}</td>`;
                    htmDr += '</tr>';

                    const groupNameListDr = [...new Set(drlist.map(item => item.PFinancialAcName))];
                    groupNameListDr.pop("");

                    $.each(groupNameListDr, function (index, value) {                       
                        var groupData = drlist.filter((item) => item.PFinancialAcName == value && item.FinancialAcName.toLowerCase() != 'opening stock');
                        if (groupData.length > 0) {

                            // Group Header
                            htmDr += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                            htmDr += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:2rem!important;">${value}</td>`;
                            htmDr += '<td></td>';
                            htmDr += '</tr>';

                            // Rows
                            $.each(groupData, function (index, value) {
                                grandTotalDr += value.Debit;
                                htmDr += '<tr>';
                                htmDr += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${value.FinancialAcName}</td>`;
                                htmDr += `<td style="text-align:right;border:1px solid #575757;">${value.Debit}</td>`;
                                htmDr += '</tr>';
                            });
                        }
                        
                    }); 

                    $('#tbl_PLDr').html(htmDr);
                     
                    //Looping inside Credit List  
                    // closing
                    var closing = crlist.filter((item) => item.FinancialAcName.toLowerCase() == 'closing stock');
                    htmCr += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                    htmCr += `<td style="text-align:left;border:1px solid #575757;">${closing[0].FinancialAcName}</td>`;
                    htmCr += `<td style="text-align:right;border:1px solid #575757;">${closing[0].Debit}</td>`;
                    htmCr += '</tr>';

                    const groupNameListCr = [...new Set(crlist.map(item => item.PFinancialAcName))];
                    groupNameListCr.pop("");

                    $.each(groupNameListCr, function (index, value) {
                        var groupData = crlist.filter((item) => item.PFinancialAcName == value && item.FinancialAcName.toLowerCase() != 'closing stock');
                        if (groupData.length > 0) {

                            // Group Header
                            htmCr += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                            htmCr += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:2rem!important;">${value}</td>`;
                            htmCr += '<td></td>';
                            htmCr += '</tr>';

                            // Rows
                            $.each(groupData, function (index, value) {
                                grandTotalCr += value.Credit;
                                htmCr += '<tr>';
                                htmCr += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${value.FinancialAcName}</td>`;
                                htmCr += `<td style="text-align:right;border:1px solid #575757;">${value.Credit}</td>`;
                                htmCr += '</tr>';
                            }); 
                        } 
                    });

                    $('#tbl_PLCr').html(htmCr);
                     
                    //Checking if one list is greater than other to inster blank rows for design
                    $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                    $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')

                    if (drlist.length != crlist.length) {
                        if (drlist.length > crlist.length) {
                            crdiff = drlist.length - crlist.length

                            for (i = 0; i < crdiff; i++) {
                                $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                            }

                        }
                        if (drlist.length < crlist.length) {
                            drdiff = crlist.length - drlist.length

                            for (i = 0; i < drdiff; i++) {
                                $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                            }
                        }
                    }

                    if (grandTotalCr > grandTotalDr) {
                        $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                        $('#tbl_PLDr').append('<tr style="font-weight: bold;"><td>Net Profit (Transfered to Capital)</td><td style="text-align:right;">' + (grandTotalCr - grandTotalDr).toFixed(2) + '</td></tr>')
                    }
                    if (grandTotalCr < grandTotalDr) {
                        $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                        $('#tbl_PLCr').append('<tr style="font-weight: bold;"><td>Net Loss (Transfered to Capital)</td><td style="text-align:right;">' + (grandTotalDr - grandTotalCr).toFixed(2) + '</td></tr>')
                    } 
                    $('#tbl_PLCr').append('<tr style="background-color: #ff9933;color: white;"><td style="text-align:right;">Total Amount</td><td style="text-align:right;">' + grandTotalDr + '</td></tr>')
                    $('#tbl_PLDr').append('<tr style="background-color: #ff9933;color: white;"><td style="text-align:right;">Total Amount</td><td style="text-align:right;">' + grandTotalCr + '</td></tr>')
                } 
            },
            bindFinancialAcDetails: function (data) {
                var result = JSON.parse(data);
                var htmls = "";
                $("#divForFinancialDetails").html(htmls);
                htmls += '<table class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;"><thead><tr><th style="width: 88px;text-align:center;border:1px solid #575757;padding:2px;">S.N.</th><th style="text-align:left;border:1px solid #575757;padding:2px;">Particulars</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Debit</th><th style="width: 150px;text-align:right;border:1px solid #575757;padding:2px;">Credit</th></tr></thead><tbody>';
                for (var i = 0; i < result.length; i++) {
                    bal = result[i].Debit - result[i].Credit;
                    htmls += '<tr>';
                    htmls += '<td style="text-align:center;border:1px solid #575757;padding:2px;">' + (i + 1) + '</td>';
                    htmls += '<td class="abc" style="text-align:left;border:1px solid #575757;padding:2px;">' + result[i].FinancialAcName + '</td>';
                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal > 0 ? bal.toFixed(2) : '0.00') + '</td>';
                    htmls += '<td style="text-align:right;border:1px solid #575757;padding:2px;">' + (bal < 0 ? Math.abs(bal).toFixed(2) : '0.00') + '</td>';
                    htmls += '</tr>';
                }
                htmls += '</tbody></table>';

                $("#divForFinancialDetails").append(htmls);
                $('#divForFinancialDetails').dialog({
                    title: 'Details'
                })
            },
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);