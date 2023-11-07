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

                $("#btnView").on('click', function () {
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
                htmls += '<div class="Report_header"><h4 style="text-align:center;margin:0;">' + companyInfo.Name + '</h4>';
                htmls += '<p style="text-align:center;margin:0;">' + companyInfo.Address + ' , ' + (companyInfo.IsPan ? 'PAN' : 'VAT') + ' : ' + companyInfo.PAN + '</p>';
                htmls += '<p style="margin:0;text-align:center;">Profit & Loss Statement For ' + $('#txtStartDate').val() + ' to ' + $('#txtEndDate').val() + '</p>';
                htmls += '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p></div>';

                //Updated By Bishal Open
                htmls += '<div class="sfCol_50"><table id="tblOfFinancialAcDr" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;">' +
                    '<thead><tr style="font-weight: bold;background-color: #ff9933;color: white;">' +
                    '<th style="width: 100px;text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">EXPENSES OR LOSSES </th>' +
                    '<th style="width: 20px;text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;font-weight:bold;">(Dr.) AMOUNT</th>' +
                    '</tr></thead><tbody id="tbl_PLDr"></tbody></table></div>';
                htmls += '<div class="sfCol_50"><table id="tblOfFinancialAcCr" class="sfGridwrapper display dataTable no-footer reportsprint" style="border:none;width:100%;border-collapse:collapse;">' +
                    '<thead><tr style="font-weight: bold;background-color: #ff9933;color: white;">' +
                    '<th style="width: 100px;text-align:center;border:1px solid #575757;padding:2px;font-weight:bold;">INCOME OR GAIN</th>' +
                    '<th style="width: 20px;text-align:right;border:1px solid #575757;padding:2px;font-weight:bold;">(Cr.) AMOUNT</th>' +
                    '</tr></thead><tbody id="tbl_PLCr"></tbody></table></div>';

                $("#divForBalanceSheet").append(htmls);

                function getGroupTotal(group, data, type) {
                    groupTotalTemp = 0;
                    var childList = data.filter((item) => item.PFinancialAcName == group && item.FinancialAcName != group);
                    if (childList.length > 0) {
                        $.each(childList, function (index, parent) {
                            var childList2 = data.filter((item) => item.PFinancialAcName == parent.FinancialAcName && item.FinancialAcName != parent.FinancialAcName);
                            if (childList2.length > 0) {
                                childList2.map((child) => groupTotalTemp += child[type]);
                            } else {
                                groupTotalTemp += parent[type]
                            }
                        });
                    } else {
                        groupTotalTemp += group[type]
                    }

                    return groupTotalTemp;
                }

                if (data.length > 0) {

                    var htmDr = '';
                    var htmCr = '';
                    var drlist = [];
                    var crlist = [];
                    var groupTotal = 0;
                    var groupTotalTemp = 0;
                    var grandTotalDr = 0;
                    var grandTotalCr = 0;
                    var drRowCount = 0;
                    var crRowCount = 0;

                    //Creating two list of datas for Dr value and Cr Value
                    $.each(data, function (index, value) {
                        if (value.IsDebit == false) {
                            crlist.push(value);
                        }
                        if (value.IsDebit == true) {
                            drlist.push(value);
                        }
                    });

                    //Looping inside Debit List 
                    // Opening
                    var opening = drlist.filter((item) => item.FinancialAcName.toLowerCase() == 'opening stock');
                    htmDr += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                    htmDr += `<td style="text-align:left;border:1px solid #575757;padding-left:2rem!important;">${opening[0].FinancialAcName}</td>`;
                    htmDr += `<td style="text-align:right;border:1px solid #575757;padding-left:2rem!important;">${formatNumber(opening[0].Debit)}</td>`;
                    htmDr += '</tr>';
                    drRowCount++;

                    var groupNameListDr = [...new Set(drlist.map(item => item.PFinancialAcName))];
                    groupNameListDr.splice(groupNameListDr.indexOf("OPENING STOCK"), 1);
                    if (groupNameListDr.includes("")) {
                        groupNameListDr.pop("");
                    }

                    $.each(groupNameListDr, function (index, group) {

                        var groupDataDr = drlist.filter((item) => item.PFinancialAcName == group && item.FinancialAcName != group);
                        if (groupDataDr.length > 0) {

                            // Group Header
                            groupTotal = getGroupTotal(group, drlist, 'Debit');
                            htmDr += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                            htmDr += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:2rem!important;">${group}</td>`;
                            htmDr += `<td style="text-align:right;">${formatNumber(groupTotal)}</td>`;
                            htmDr += '</tr>';
                            grandTotalDr += groupTotal;
                            groupTotal = 0;
                            drRowCount++;

                            // Rows
                            $.each(groupDataDr, function (index, child) {

                                // if third level child is present, find child of the 3rd level parent instead
                                if (groupNameListDr.includes(child.FinancialAcName) && child.FinancialAcName.toLowerCase() != 'opening stock') {
                                    // remove group from list
                                    groupNameListDr.splice(groupNameListDr.indexOf(child.FinancialAcName), 1);

                                    var groupDataDr2 = drlist.filter((item) => item.PFinancialAcName == child.FinancialAcName && item.FinancialAcName != child.FinancialAcName);
                                    if (groupDataDr2.length > 0) {

                                        // Group Sub Header
                                        groupTotal = getGroupTotal(child.FinancialAcName, drlist, 'Debit');
                                        htmDr += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                                        htmDr += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:4rem!important;">${child.FinancialAcName}</td>`;
                                        htmDr += `<td style="text-align:right;">${formatNumber(groupTotal)}</td>`;
                                        htmDr += '</tr>';
                                        drRowCount++;

                                        // Rows
                                        $.each(groupDataDr2, function (index, child2) {
                                            htmDr += '<tr>';
                                            htmDr += `<td style="text-align:left;border:1px solid #575757;padding-left:6rem!important;">${child2.FinancialAcName}</td>`;
                                            htmDr += `<td style="text-align:right;border:1px solid #575757;">${formatNumber(child2.Debit)}</td>`;
                                            htmDr += '</tr>';
                                            drRowCount++;
                                        });
                                    }
                                } else {

                                    // Rows
                                    htmDr += '<tr>';
                                    htmDr += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${child.FinancialAcName}</td>`;
                                    htmDr += `<td style="text-align:right;border:1px solid #575757;">${formatNumber(child.Debit)}</td>`;
                                    htmDr += '</tr>';
                                    drRowCount++;
                                }
                            });
                        }
                    });

                    $('#tbl_PLDr').html(htmDr);

                    //Looping inside Credit List  
                    // closing
                    var closing = crlist.filter((item) => item.FinancialAcName.toLowerCase() == 'closing stock');
                    htmCr += '<tr style="text-align:left;background:#f7ebeb;font-weight:bold;">';
                    htmCr += `<td style="text-align:left;border:1px solid #575757;">${closing[0].FinancialAcName}</td>`;
                    htmCr += `<td style="text-align:right;border:1px solid #575757;">${formatNumber(closing[0].Credit)}</td>`;
                    htmCr += '</tr>';
                    crRowCount++;

                    var groupNameListCr = [...new Set(crlist.map(item => item.PFinancialAcName))];
                    groupNameListCr.splice(groupNameListCr.indexOf("CLOSING STOCK"), 1);
                    if (groupNameListCr.includes("")) {
                        groupNameListCr.pop("");
                    }

                    $.each(groupNameListCr, function (index, group) {
                        var groupDataCr = crlist.filter((item) => item.PFinancialAcName == group && item.FinancialAcName != group);
                        if (groupDataCr.length > 0) {

                            // Group Header
                            groupTotal = getGroupTotal(group, crlist, 'Credit');
                            htmCr += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                            htmCr += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:2rem!important;">${group}</td>`;
                            htmCr += `<td style="text-align:right;">${formatNumber(groupTotal)}</td>`;
                            htmCr += '</tr>';
                            grandTotalCr += groupTotal;
                            groupTotal = 0;
                            crRowCount++;

                            // Rows
                            $.each(groupDataCr, function (index, child) {

                                // if third level child is present, find child of the 3rd level parent instead
                                if (groupNameListCr.includes(child.FinancialAcName) && child.FinancialAcName.toLowerCase() != 'closing stock') {
                                    // remove group from list
                                    groupNameListCr.splice(groupNameListCr.indexOf(child.FinancialAcName), 1);

                                    var groupDataCr2 = crlist.filter((item) => item.PFinancialAcName == child.FinancialAcName && item.FinancialAcName != child.FinancialAcName);
                                    if (groupDataCr2.length > 0) {

                                        // Group Sub Header 
                                        groupTotal = getGroupTotal(child.FinancialAcName, crlist, 'Credit');
                                        htmCr += '<tr style="text-align:left;background:#e1dfdf;font-weight:bold;">';
                                        htmCr += `<td style="text-align:center;border:1px solid #575757;text-align:left;padding-left:4rem!important;">${child.FinancialAcName}</td>`;
                                        htmCr += `<td style="text-align:right;">${formatNumber(groupTotal)}</td>`;
                                        htmCr += '</tr>';
                                        crRowCount++;

                                        // Rows
                                        $.each(groupDataCr2, function (index, child2) {
                                            htmCr += '<tr>';
                                            htmCr += `<td style="text-align:left;border:1px solid #575757;padding-left:6rem!important;">${child2.FinancialAcName}</td>`;
                                            htmCr += `<td style="text-align:right;border:1px solid #575757;">${formatNumber(child2.Credit)}</td>`;
                                            htmCr += '</tr>';
                                            crRowCount++;
                                        });
                                    }
                                } else {

                                    // Rows
                                    htmCr += '<tr>';
                                    htmCr += `<td style="text-align:left;border:1px solid #575757;padding-left:4rem!important;">${child.FinancialAcName}</td>`;
                                    htmCr += `<td style="text-align:right;border:1px solid #575757;">${formatNumber(child.Credit)}</td>`;
                                    htmCr += '</tr>';
                                    crRowCount++;
                                }
                            });
                        }
                    });

                    $('#tbl_PLCr').html(htmCr);

                    //Checking if one list is greater than other to inster blank rows for design
                    $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                    $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')

                    var rowDiff = 0;
                    if (drRowCount != crRowCount) {
                        if (drRowCount > crRowCount) {
                            rowDiff = drRowCount - crRowCount;
                            for (i = 0; i < rowDiff; i++) {
                                $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                            }
                        }
                        if (drRowCount < crRowCount) {
                            rowDiff = crRowCount - drRowCount;
                            for (i = 0; i < rowDiff; i++) {
                                $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                            }
                        }
                    }

                    if (grandTotalCr > grandTotalDr) {
                        $('#tbl_PLCr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                        $('#tbl_PLDr').append('<tr style="font-weight: bold;"><td style="text-align:left;">Net Profit (Transfered to Capital)</td><td style="text-align:right;">' + formatNumber(grandTotalCr - grandTotalDr) + '</td></tr>')
                    }
                    if (grandTotalCr < grandTotalDr) {
                        $('#tbl_PLDr').append('<tr><td>&nbsp;</td><td>&nbsp;</td></tr>')
                        $('#tbl_PLCr').append('<tr style="font-weight: bold;"><td style="text-align:left;">Net Loss (Transfered to Capital)</td><td style="text-align:right;">' + formatNumber(grandTotalDr - grandTotalCr) + '</td></tr>')
                    }
                    $('#tbl_PLCr').append('<tr style="background-color: #ff9933;color: white;font-weight: bold;"><td style="text-align:left;">Total Amount</td><td style="text-align:right;">' + formatNumber(grandTotalCr) + '</td></tr>')
                    $('#tbl_PLDr').append('<tr style="background-color: #ff9933;color: white;font-weight: bold;"><td style="text-align:left;">Total Amount</td><td style="text-align:right;">' + formatNumber(grandTotalDr) + '</td></tr>')
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