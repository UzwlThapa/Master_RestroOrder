(function ($) {
    var tabs = $("#tabs").tabs();
    $.CounterTotal = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_CounterTotal/',
                 master: '0',
                 userName: '',
             }, p);
        var v = 0;
        //var counterTotals = [];
        var DiffAmount = 0;
        var sum = 0;
       
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsForCounterTotal.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0,
                TotalID:0,
            },
            InitialSetup: function () {
                var sum = 0;
                eventFunction.getCostCenterlist();
                eventFunction.getUserlist();
                eventFunction.getopenDrawerListForBills();
                eventFunction.getopenDrawerListForCoin();
                //$('#ckbxIsOpening').prop('checked', true);
                //eventFunction.getOpenBalance();
                eventFunction.getCounterTotal();
            },
          

            init: function () {
                eventFunction.InitialSetup();
                
                $("#divForNote").on("change", ".bills", function (e) {
                    e.preventDefault();
                    //alert("you are on the path of success");
                    var ids = $(this).attr('id');
                    var word = ids.split("_");
                    sum += $("#" + ids + "").val() * word[1];
                    $("#txtTotalCount").val(sum);
                });
                $("#divForNote").on("click", ".bills", function (e) {
                //$(".bills").click(function (e) {
                    e.preventDefault();
                    var a = $(this).attr('id');
                    word = a.split('_');
                    sum = $("#txtTotalCount").val() - (word[1] * $("#" + a).val());
                });

                $("input[type=radio][name=Customer]").change(function () {
                    if ($("#selCostCenter").val() != null && $("#txtCN").val() != null) {
                       // eventFunction.checkIsOpen();
                        //$("#txtOpenDrawerBalance").val(0);
                        if (this.value == '0') {
                            eventFunction.DoesopeningExist();
                            $("#txtOpenDrawerBalance").val(0);
                            $(".closes").hide();
                        }
                        else {
                            eventFunction.getOpenBalance();
                            eventFunction.DoesClosingExist();
                            //$(".closes").show();
                        }
                    } else {
                        jAlert('First Select Cost Center and Counter Number!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        $('input[type=radio][name=Customer]').attr('checked', false);
                    }
                });
                $("#ckbxIsOpening").click(function () {
                    if ($("#selCostCenter").val() != null && $("#txtCN").val() != null) {
                        eventFunction.checkIsOpen();
                        //$("#txtOpenDrawerBalance").val(0);
                        if (eventFunction.checkIsOpen() != true) {
                            $("#txtOpenDrawerBalance").val(0);
                            $(".closes").hide();
                        }
                        else {
                            eventFunction.getOpenBalance();
                            //$(".closes").show();
                        }
                    } else {
                        jAlert('First Select Cost Center and Counter Number!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        $('#ckbxIsOpening').attr('checked', false);
                    }
                });
                $("#AddOpenDrawer").click(function () {
                    var counterTotals = new Array();
                    var MyRows = $('table#tableForCounterTotal').find('tbody').find('tr');
                    var counterTotal = new Object();
                    for (var i = 0; i < MyRows.length; i++) {
                        counterTotal.CC = $(MyRows[i]).find('td:eq(1)').html();
                        counterTotal.CID = parseInt($(MyRows[i]).find('td:eq(2)').html());
                        counterTotal.IsClosing = ($(MyRows[i]).find('td:eq(5)').html());
                        counterTotals.push(counterTotal);
                    }
                    var p = $.inArray($("#txtCN").val(), counterTotals);
                    //var q = $.inArray(eventFunction.checkIsOpen(), counterTotals);
                    //if (p == -1) {
                    //alert("success");
                    eventFunction.saveCounterTotal();
                    eventFunction.resetCounterTotal();
                    eventFunction.InitialSetup();
                    // }
                });
                //$("#txtCN").change(function () {
                //    eventFunction.getOpenBalance();
                //});

                $("#selCostCenter").change(function () {
                    var ids = $(this).val();
                    eventFunction.getNumberOfCounter(ids);
                });
            },

            getVaultViewForCoin: function () {
                date = new Date;
                var ccid = $("#selCostCenter").val();
                var cid = $("#txtCN").val();
                eventFunction.config.method = "getVaultViewForCoin";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ date: date, ccid: ccid, cid: cid });
                eventFunction.config.ajaxCallMode = 13;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindopenDrawerListForCoins: function (result) {
                var count = 0;
                var data = result.d;
                var htmls = "";
                $.each(data, function (index, value) {
                    count++;
                    //arrayList.push(value.NoteID);
                    htmls += "<td>" + $("#hdnCurrencyIcons").val() + " " + value.Note;
                    htmls += '<br/><input type="text" id="c_' + value.Note + "_" + value.NoteID + '" class="bills coin' + count + '" value="'+value.Number+'" /></td>';
                    $(".hdnCurrencyIcon").val($("#hdnCurrencyIcons").val());
                    $("#txtTotalCount").val(value.Balance);
                    $("#txtApprovedBy").val(value.ApprovedBy);
                });
                $(".noteFromDbForCoins").html(htmls);
            },


            getVaultView: function () {
                date = new Date;
                var ccid = $("#selCostCenter").val();
                var cid = $("#txtCN").val();
                eventFunction.config.method = "getVaultViewForBills";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ date: date,ccid:ccid, cid:cid });
                eventFunction.config.ajaxCallMode = 12;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindopenDrawerListForBillss: function (result) {
                var data = result.d;
                var htmls = "";
                var note = "";
                var count = 0;
                $.each(data, function (index, value) {
                    count++;
                    htmls += "<td>" + $("#hdnCurrencyIcons").val() + " " + value.Note + "<br/>";
                    htmls += '<input type="text" id="b_' + value.Note + "_" + value.NoteID + '" class="bills bill' + count + '" value="'+value.Number+'"/></td>';
                    //arrayNote.push(value.NoteID);
                });
                $(".noteFromDbForBills").html(htmls);
            },


            DoesClosingExist: function () {
                var ccid = $("#selCostCenter").val();
                var cid = $("#txtCN").val();
                eventFunction.config.method = "DoesClosingExistOfCounterTotal";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ ccid: ccid, cid: cid });
                eventFunction.config.ajaxCallMode = 11;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindDoesClosingExist: function (result) {
                var data = result.d;
                var htmls = "";
                if (data.length > 0) {
                    $(".shows").hide();
                    jAlert('Data Entry for Close Drawer is done Already!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    $("#rdoVender").prop("checked", false);
                    //if (confirm('Do you want to update?')) {
                    //    //$(".shows").show();
                    //    $.each(data, function (index, value) {
                    //        eventFunction.config.TotalID = value.TotalID;
                    //    }); 
                    //    //alert('Thanks for confirming');
                    //   // $(".shows").show();
                    //   // $(".close").show();
                    //    var closeBlc = $("#txtTotalCount").val();
                    //    var openBlc = $("#txtOpenDrawerBalance").val();
                    //    DiffAmount = closeBlc - openBlc;
                    //    //$("#AddOpenDrawer").attr("value", "CLOSE DRAWER");
                    //} else {
                    //    //alert('Why did you press cancel? You should have confirmed');
                    //    $("#rdoVender").prop("checked", false);
                    //    $(".shows").hide();
                    //}
                }
                else {
                    //return false;
                    // alert("Data Entry for Open Drawer is not exist!");
                    $(".shows").show();
                    //
                    $(".shows").show();
                    //$(".close").show();
                    var closeBlc = $("#txtTotalCount").val();
                    var openBlc = $("#txtOpenDrawerBalance").val();
                    DiffAmount = closeBlc - openBlc;
                    //$("#AddOpenDrawer").attr("value", "CLOSE DRAWER");
                }
            },

            DoesopeningExist: function () {
                var ccid = $("#selCostCenter").val();
                var cid = $("#txtCN").val();
                eventFunction.config.method = "DoesopeningExistOfCounterTotal";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ccid:ccid,cid:cid});
                eventFunction.config.ajaxCallMode = 9;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindDoesopeningExist: function (result) {
                var data = result.d;
                var htmls = "";
                //var count = 0;
                if (data.length > 0) {
                    $(".shows").hide();
                    jAlert('Data Entry for Open Drawer is done Already!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    jConfirm('Are You Sure  ?', 'Update', function (confirmed) {
                        if (confirmed) {
                            $(".shows").show();
                            $.each(data, function (index, value) {
                                eventFunction.config.TotalID = value.CTID;
                            });
                            eventFunction.getVaultView();
                            eventFunction.getVaultViewForCoin();
                            //alert('Thanks for confirming');
                            //eventFunction.getopenDrawerListForBills();
                            //eventFunction.getopenDrawerListForCoin();
                        } else {
                            //alert('Why did you press cancel? You should have confirmed');
                            $("#rdoCustomer").prop("checked", false);
                        }
                    });
                }
                else {
                    //return false;
                    // alert("Data Entry for Open Drawer is not exist!");
                    $(".shows").show();
                }
            },

            getNumberOfCounter: function (data) {
                eventFunction.config.method = "getNumberOfCounter";
                eventFunction.config.data = JSON2.stringify({id:data});
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindNumberOfCounter: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                $.each(data, function (index, value) {
                    a= value.NumberOfCounter;
                });
                htmls += '<option selected disabled value="">-select- </option>';
                for (var i = 1; i <= a; i++) {
                    htmls += "<option value='" + i + "'>" + i + "</option>"
                }
                $("#txtCN").html(htmls);
            },

            getCounterTotal: function () {
                eventFunction.config.method = "getCounterTotal";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindCounterTotal: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                htmls += "<table id='tableForCounterTotal' class='sfGridwrapper display dataTable no-footer'><thead><tr><th>S.N.</th><th>Cost Center</th><th>Counter ID</th><th>Balance</th><th>Difference</th><th>Is Closing</th><th>Approved By</th><th></th></tr></thead><tbody>";
                $.each(data, function (index, value) {
                    a++;
                    htmls += '<tr><td>' + a + '</td>';
                    htmls += '<td>' + value.CCID + '</td>';
                    htmls += '<td>' + value.CID + '</td>';
                    htmls += '<td>' + value.Balance + '</td>';
                    htmls += '<td>' + value.DifAmount + '</td>';
                    htmls += '<td>' + value.IsClosing + '</td>';
                    htmls += '<td>' + value.ApprovedBy + '</td>';
                    htmls += '<td><input type="button" class="showNote" id="' + value.CTID + '" value="Show"></td></tr>';
                });
                htmls += "</tbody></table>";
                $("#CounterTotalListing").html(htmls);
                $("#tableForCounterTotal").dataTable({
                    paging: false,
                    searching: false,
                });

                $(".showNote").click(function () {
                    var ids = $(this).attr('id');
                    eventFunction.config.method = "getshowNote";
                    eventFunction.config.data = JSON2.stringify({ id: ids });
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.ajaxCallMode = 14;
                    eventFunction.ajaxCall(eventFunction.config);
                });
            },

            bindCounterView: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                var balance = 0;
                var difference = 0;
                var ApprovedBy = "";
                var IsClosing = "";
                var center = "";
                var counter = "";
                var MyRows = $('table#tableForCounterTotal').find('tbody').find('tr');
                if (data.length > 0) {
                    htmls += "<table id='tableForCounterTotals' class='inventory-table'><thead><tr><th>S.N.</th><th>Note</th><th>Number</th><th>IsCoin</th></tr></thead><tbody>";
                    $.each(data, function (index, value) {
                        $("#hdnCenter").val(value.CostCenterName);
                        $("#hdnCounter").val(value.CID);
                        a++;
                        htmls += '<tr><td>' + a + '</td>';
                        htmls += '<td>' + value.Note + '</td>';
                        htmls += '<td>' + value.Number + '</td>';
                        htmls += '<td>' + value.IsCoin + '</td></tr>';
                        balance = value.Balance;
                        difference = value.DifAmount;
                        ApprovedBy = value.ApprovedBy;
                        IsClosing = value.IsClosing;
                    });
                    htmls += "<tr><td></td><td></td><td>Balance</td><td>" + balance + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Difference</td><td>" + difference + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Is Closing</td><td>" + IsClosing + "</td></tr>";
                    htmls += "<tr><td></td><td></td><td>Approved By</td><td>" + ApprovedBy + "</td></tr>";
                    htmls += "</tbody>";
                    htmls += "</table>";
                } else {
                    htmls += "No Data!";
                }
                $(".counter").html(counter);
                $(".center").html(center);
                $("#showNote").html(htmls);
                $("#tableForCounterTotals").dataTable({
                    paging: false,
                    ordering: false,
                    searching: false,
                    info: false,
                });
            },

            saveCounterTotal: function () {
                var MyRows = $('table#tableForBills').find('tbody').find('tr').find('td');
                var MyRows2 = $('table#tableForCoins').find('tbody').find('tr').find('td');
                var note = new Object();
                for (var i = 1; i <= MyRows.length; i++) {
                    var objNote = new Object();
                    var ids = $(".bill" + i + "").attr('id');
                    var word = ids.split("_");
                    objNote.NoteID = word[2];
                    objNote.Number = $(".bill" + i + "").val() == "" ? 0 : $(".bill" + i + "").val();
                    arrayNote.push(objNote);
                }
                for (var i = 1; i <= MyRows2.length; i++) {
                    var objNote = new Object();
                    var ids = $(".coin" + i + "").attr('id');
                    var word = ids.split("_");
                    objNote.NoteID = word[2];
                    objNote.Number = $(".coin" + i + "").val() == "" ? 0 : $(".coin" + i + "").val();
                    arrayNote.push(objNote);
                }
                var NoteList = new Array();
                for (var i = 0; i < arrayNote.length; i++) {
                    var orderDetail = new Object();
                    orderDetail.NoteID = arrayNote[i].NoteID,
                    orderDetail.Number = arrayNote[i].Number,
                    NoteList.push(orderDetail);
                }

                var counter = new Object();
                //cTransaction.CID = $("#txtCN").val();
                //cTransaction.IsOpening = eventFunction.checkIsOpen();
                //cTransaction.Amount = $("#txtTotalCount").val();
                //cTransaction.NCPID = $("#selNewCP").val();
                //cTransaction.CostCenterID = $("#selCostCenter").val();
                //cTransaction.OCPID = $("#selOldCP").val();
                //cTransaction.Date = new Date();

                var counter = {};
                counter.CTID = eventFunction.config.TotalID;
                counter.CID = $("#txtCN").val();
                counter.CCID = $("#selCostCenter").val();
                counter.Balance = $("#txtTotalCount").val();
                //counter.IsClosing = eventFunction.checkIsOpen();
                //if (eventFunction.checkIsOpen() != true)
                //    counter.DifAmount = 0;
                //else
                //    counter.DifAmount = $("#txtTotalCount").val() - $("#txtOpenDrawerBalance").val();
                var value = parseInt($('input[name="Customer"]:checked').val());
                if (value == 1) {
                    var closeBlc = $("#txtTotalCount").val();
                    var openBlc = $("#txtOpenDrawerBalance").val();
                    counter.DifAmount = closeBlc - openBlc;
                    counter.IsClosing = true;
                } else {
                    counter.IsClosing = false;
                    counter.DifAmount = 0;
                }
                counter.Date = new Date();
                counter.ApprovedBy = $("#txtApprovedBy").val();
                //counter.CTransaction = cTransaction;
                counter.NoteList = NoteList;
                eventFunction.config.method = "saveCounterTotal";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ counter: counter });
                if (eventFunction.config.TotalID != 0) {
                    eventFunction.config.ajaxCallMode = 10;
                } else {
                eventFunction.config.ajaxCallMode = 6;
                }
                eventFunction.ajaxCall(eventFunction.config);
            },

            checkIsOpen: function () {
                //var a = $('#ckbxIsOpening').prop('checked');
                if ($('#ckbxIsOpening').prop('checked') == true)
                    return true;
                else
                    return false;
            },
            getOpenBalance: function () {
                CID = $("#txtCN").val();
                CostCenterID = $("#selCostCenter").val();
                eventFunction.config.method = "getOpenBalance";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ cid: CID, ccid: CostCenterID });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindOpenBalance: function (result) {
                var data = result.d;
                //if (!data) return;
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        $("#txtOpenDrawerBalance").val(value.Balance);
                    });
                    $(".closes").show();
                }
                else {
                    $('#ckbxIsOpening').attr('checked', false);
                    jAlert('Data Entry for Open Drawer is done Already!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                }
            },

            getopenDrawerListForCoin: function () {
                eventFunction.config.method = "getopenDrawerList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ id: 1 });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindopenDrawerListForCoin: function (result) {
                var count = 0;
                var data = result.d;
                var htmls = "";
                $.each(data, function (index, value) {
                    count++;
                    //arrayList.push(value.NoteID);
                    htmls += "<td>" + value.CurrencyIcon + " " + value.Note;
                    htmls += '<br/><input type="text" id="c_' + value.Note + "_" + value.NoteID + '" class="bills coin' + count + '" placeholder="0" /></td>';
                    $(".hdnCurrencyIcon").val(value.CurrencyIcon);
                });
                $(".noteFromDbForCoins").html(htmls);
            },

            getopenDrawerListForBills: function () {
                eventFunction.config.method = "getopenDrawerList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ id: 0 });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindopenDrawerListForBills: function (result) {
                var data = result.d;
                var htmls = "";
                var note = "";
                var count = 0;
                $.each(data, function (index, value) {
                    count++;
                    htmls += "<td>" + value.CurrencyIcon + " " + value.Note + "<br/>";
                    htmls += '<input type="text" id="b_' + value.Note + "_" + value.NoteID + '" class="bills bill' + count + '" placeholder="0"  /></td>';
                    $("#hdnCurrencyIcons").val(value.CurrencyIcon);
                    //arrayNote.push(value.NoteID);
                });
                $(".noteFromDbForBills").html(htmls);  
            },

            getUserlist: function () {
                eventFunction.config.method = "getUserlist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindUserList: function (result) {
                var data = result.d;
                var htmls = "";
                $.each(data, function (index, value) {
                    htmls += "<option value='" + value.UserID + "'>" + value.Username + "</option>"
                });
                $("#txtApprovedBy").append(htmls);
            },

            getCostCenterlist: function () {
                eventFunction.config.method = "getCostCenterlist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindCostCenterList: function (result) {
                var data = result.d;
                var htmls = "";
                htmls += '<option selected disabled value="">-select- </option>';
                $.each(data, function (index, value) {
                    htmls += "<option value='" + value.CostCenterID + "'>" + value.CostCenterName + "</option>"
                });
                $("#selCostCenter").html(htmls);
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
                        eventFunction.bindCostCenterList(data);
                        break;
                    case 2:
                        eventFunction.bindUserList(data);
                    case 3:
                        eventFunction.bindopenDrawerListForBills(data);
                        break;
                    case 4:
                        eventFunction.bindopenDrawerListForCoin(data);
                        break;
                    case 5:
                        eventFunction.bindOpenBalance(data);
                        break;
                    case 6:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("input[type=radio][name=Customer]").removeAttr('checked');
                        location.reload();
                        break;
                    case 7:
                        //alert("success");
                        eventFunction.bindCounterTotal(data);
                        break;
                    case 8:
                        eventFunction.bindNumberOfCounter(data);
                        break;
                    case 9:
                        eventFunction.bindDoesopeningExist(data);
                        break;
                    case 10:
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.config.TotalID = 0;
                        $("input[type=radio][name=Customer]").removeAttr('checked');
                        location.reload();
                        break;
                    case 11:
                        eventFunction.bindDoesClosingExist(data);
                        break;
                    case 12:
                        eventFunction.bindopenDrawerListForBillss(data);
                        break;
                    case 13:
                        eventFunction.bindopenDrawerListForCoins(data);
                        break;
                    case 14:
                        eventFunction.bindCounterView(data);
                        $("#showNote").dialog({
                            title: $("#hdnCenter").val() + " " + $("#hdnCounter").val(),
                            height: 'auto',
                            width: 320,
                            showTitle: true,
                            open: function (event, ui) {
                                originalContent = $("#showNote").html();
                            },
                            close: function (event, ui) {
                                $("#showNote").html(originalContent);
                            }
                        });
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },
            reset: function () {

            },

            resetCounterTotal: function () {
                $("#txtOpenDrawerBalance").val(0);
                $(".bills").val(0);
                $("#txtTotalCount").val(0);
                $("#selCostCenter").val("");
                $("#txtCN").val("");
                $("#txtApprovedBy").val("");
                sum = 0;
            },
        };
        eventFunction.init();
    };
    $.fn.CounterTotals = function (p) {
        $.CounterTotal(p);
    };
})(jQuery);
