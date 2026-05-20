(function ($) {
    $.openDrawer = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_openDrawer/',
                 master: '0',
             }, p);
        var v = 0;
        var DiffAmount = 0;
        var OpenCount = 1;
        var closeCount = 1;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForOpenDrawer.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0,
                TotalID:0,
            },
            InitialSetup: function () {
                // eventFunction.resetOpenDrawer();
                eventFunction.getopenDrawerListForBills();
                eventFunction.getopenDrawerListForCoin();
                eventFunction.getUserlist();
                eventFunction.getCostCenterlist();
            },
            init: function () {
                var sum = 0;
                eventFunction.InitialSetup();
                // eventFunction.ForIsClosing();
                //if (p.master == 2) {
                //    $(".close").show();
                //    $(".open").hide();
                //    $("#AddOpenDrawer").attr("value", "CLOSE DRAWER");
                //    eventFunction.getOpenBalance();
                //    var closeBlc = $("#txtTotalCount").val();
                //    var openBlc = $("#txtOpenDrawerBalance").val();
                //    DiffAmount = closeBlc - openBlc;
                //} else {
                //    $("#AddOpenDrawer").attr("value", "OPEN DRAWER");
                //    $(".close").hide();
                //    $(".open").show();
                //    DiffAmount = 0;
                //}
                //$("#tab").click(function () {
                //    $("#AddOpenDrawer").attr("value", "OPEN DRAWER");
                //    $(".close").hide();
                //    $(".open").show();
                //    DiffAmount = 0;
                //});

                //$("#tab2").click(function () {
                //    $(".close").show();
                //    $(".open").hide();
                //    $("#AddOpenDrawer").attr("value", "CLOSE DRAWER");
                //    eventFunction.getOpenBalance();
                //    var closeBlc = $("#txtTotalCount").val();
                //    var openBlc = $("#txtOpenDrawerBalance").val();
                //    DiffAmount = closeBlc - openBlc;
                //});

                $("input[type=radio][name=Customer]").change(function () {
                    if (this.value == '0') {
                        //eventFunction.checkForDataExist();
                        //if (eventFunction.checkForDataExist() == false) {
                        //$(".shows").hide();
                        eventFunction.DoesopeningExist();
                        $("#AddOpenDrawer").attr("value", "OPEN DRAWER");
                        $(".close").hide();
                        $(".open").show();
                        DiffAmount = 0;
                        $("#txtOpenDrawerBalance").val(0);
                        //}
                    } else {
                        eventFunction.getOpenBalance();
                        eventFunction.DoesClosingExist();
                        //$(".shows").show();
                        //$(".close").show();
                        //var closeBlc = $("#txtTotalCount").val();
                        //var openBlc = $("#txtOpenDrawerBalance").val();
                        //DiffAmount = closeBlc - openBlc;
                    }
                });
                $("#divForNote").on("change", ".bills", function (e) {
                    //alert("you are on the path of success");
                    e.preventDefault();
                    var ids = $(this).attr('id');
                    var word = ids.split("_");
                    sum += $("#" + ids + "").val() * word[1];
                    $("#txtTotalCount").val(sum);
                });

                $("#AddOpenDrawer").click(function () {
                    //if (OpenCount != 2) {
                        OpenCount++;
                        eventFunction.saveOpenDrawer();
                        eventFunction.resetOpenDrawer();
                    //} else {
                    //    alert("Alert! Entry for Open Drawer done already!");
                    //}
                    //for (var i = 0; i >= count; i++) {
                    //    arrayNote.push$(".bill" + i + "").val();
                    //}
                });
                $(document).on('click', '.bills', function (e) {
                    e.preventDefault();
                    var a = $(this).attr('id');
                    word = a.split('_');
                    sum = $("#txtTotalCount").val() - (word[1] * $("#" + a).val());
                });

            },

            DoesClosingExist: function () {
                eventFunction.config.method = "DoesClosingExist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindDoesClosingExist: function (result) {
                var data = result.d;
                var htmls = "";
                if (data.length > 0) {
                    $(".shows").hide();
                    jAlert('Data Entry for Close Drawer is done Already', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    ////if (confirm('Do you want to update?')) {
                    ////    $(".shows").show();
                    ////    $.each(data, function (index, value) {
                    ////        eventFunction.config.TotalID = value.TotalID;
                    ////    });
                    ////    //alert('Thanks for confirming');
                    ////    $(".shows").show();
                    ////    $(".close").show();
                    ////    var closeBlc = $("#txtTotalCount").val();
                    ////    var openBlc = $("#txtOpenDrawerBalance").val();
                    ////    DiffAmount = closeBlc - openBlc;
                    ////    $("#AddOpenDrawer").attr("value", "CLOSE DRAWER");
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
                    $(".shows").show();
                    $(".close").show();
                    var closeBlc = $("#txtTotalCount").val();
                    var openBlc = $("#txtOpenDrawerBalance").val();
                    DiffAmount = closeBlc - openBlc;
                    $("#AddOpenDrawer").attr("value", "CLOSE DRAWER");
                }
            },

            DoesopeningExist: function () {
                eventFunction.config.method = "DoesopeningExist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },


            bindDoesopeningExist: function (result) {
                var data = result.d;
                var htmls = "";
                var count = 0;
                if (data.length > 0) {
                    $(".shows").hide();
                    jAlert('Data Entry for Open Drawer is done Already', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    jConfirm('Are You Sure  ?', 'Update', function (confirmed) {
                        if (confirmed) {
                            $(".shows").show();
                            $.each(data, function (index, value) {
                                eventFunction.config.TotalID = value.TotalID;
                            });
                            eventFunction.getVaultView();
                            eventFunction.getVaultViewForCoin();
                            //alert('Thanks for confirming');
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

            getVaultViewForCoin: function () {
                date = new Date;
                eventFunction.config.method = "getVaultViewForCoin";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ date: date });
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
                    htmls += '<br/><input type="text" id="c_' + value.Note + "_" + value.NoteID + '" class="bills coin' + count + '" value="' + value.Number + '" /></td>';
                    $(".hdnCurrencyIcon").val($("#hdnCurrencyIcons").val());
                    $("#txtTotalCount").val(value.Balance);
                    $("#txtApprovedBy").val(value.ApprovedBy);
                });
                $(".noteFromDbForCoins").html(htmls);
            },

            getVaultView: function () {
                date = new Date;
                eventFunction.config.method = "getVaultViewForBills";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ date: date });
                eventFunction.config.ajaxCallMode = 14;
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
                    htmls += '<input type="text" id="b_' + value.Note + "_" + value.NoteID + '" class="bills bill' + count + '" value="' + value.Number + '"/></td>';
                    //arrayNote.push(value.NoteID);
                });
                $(".noteFromDbForBills").html(htmls);
            },


            checkForDataExist: function () {
                eventFunction.config.method = "checkForDataExit";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 7;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindcheckForDataExist: function (result) {
                var data = result.d;
                var htmls = "";
                if (data.length > 0) {
                    jAlert('Data Entry for Open Drawer is done Already', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    jConfirm('Are You Sure  ?', 'Update', function (confirmed) {
                        if (confirmed) {
                            $.each(data, function (index, value) {
                                var id = value.TotalID;
                            });
                            $(".shows").show();
                            jAlert('Thanks for confirming', 'Information!!', function () { $.alerts.dialogClass = null; });
                        } else {
                            jAlert('Why did you press cancel? You should have confirmed', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        }
                    });
                }
                else {
                    return false;
                }
            },

            getCostCenterlist: function () {
                eventFunction.config.method = "getCostCenterlist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindCostCenterList: function (result) {
                var data = result.d;
                var htmls = "";
                $.each(data, function (index, value) {
                    htmls += "<option value='" + value.CostCenterID + "'>" + value.CostCenterName + "</option>"
                });
                $("#selCostCenter").append(htmls);
            },


            getUserlist: function () {
                eventFunction.config.method = "getUserlist";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 5;
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

            getOpenBalance: function () {
                eventFunction.config.method = "getOpenBalance";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindOpenBalance: function (result) {
                var data = result.d;
                //if (!data) return;
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        $("#txtOpenDrawerBalance").val(value.Balance);
                    });
                    $(".open").hide();
                    $(".shows").show();
                    $(".close").show();
                    var closeBlc = $("#txtTotalCount").val();
                    var openBlc = $("#txtOpenDrawerBalance").val();
                    DiffAmount = closeBlc - openBlc;
                   // eventFunction.DoesClosingExist();
                }
                else {
                    $(".shows").hide();
                    jAlert('Data Entry for Open Drawer is not done!', 'Alert!!', function () { $.alerts.dialogClass = null; });
                    $("input[type=radio][name=Customer]").removeAttr('checked');
                   // $('#rdoCustomer').attr('checked', true);
                }
            },

            //ForIsClosing: function () {
            //    if (p.master == 1) {
            //        return false;
            //    } else
            //        return true;
            //},
            saveOpenDrawer: function () {
                arrayNote = [];
                var MyRows = $('table#tableForBills').find('tbody').find('tr').find('td');
                var MyRows2 = $('table#tableForCoins').find('tbody').find('tr').find('td');
                var note = new Object();
                for (var i = 1; i <= MyRows.length; i++) {
                    var objNote = new Object();
                    var ids = $(".bill" + i + "").attr('id');
                    var word = ids.split("_");
                    objNote.NoteID = word[2];
                    objNote.Number = $(".bill" + i + "").val();
                    arrayNote.push(objNote);
                }
                for (var i = 1; i <= MyRows2.length; i++) {
                    var objNote = new Object();
                    var ids = $(".coin" + i + "").attr('id');
                    var word = ids.split("_");
                    objNote.NoteID = word[2];
                    objNote.Number = $(".coin" + i + "").val();
                    arrayNote.push(objNote);
                }
                var NoteList = new Array();
                for (var i = 0; i < arrayNote.length; i++) {
                    var orderDetail = new Object();
                    orderDetail.NoteID = arrayNote[i].NoteID,
                    orderDetail.Number = arrayNote[i].Number,
                    NoteList.push(orderDetail);
                }
                note.TotalID = eventFunction.config.TotalID;
                note.Balance = $("#txtTotalCount").val();
                note.Date = new Date();
                note.CostCenter = "0";

                var value = parseInt($('input[name="Customer"]:checked').val());
                if (value == 1) {
                    var closeBlc = $("#txtTotalCount").val();
                    var openBlc = $("#txtOpenDrawerBalance").val();
                    note.DiffAmount = closeBlc - openBlc;
                    note.IsClosing = true;
                } else {
                    note.IsClosing = false;
                    DiffAmount = 0;
                }
                note.NoteList = NoteList;
                note.ApprovedBy = $("#txtApprovedBy").val();
                eventFunction.config.method = "saveOpenDrawer";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ note: note });
                if (eventFunction.config.TotalID != 0) {
                    eventFunction.config.ajaxCallMode = 9;
                } else {
                eventFunction.config.ajaxCallMode = 3;
                }
                eventFunction.ajaxCall(eventFunction.config);
            },

            getopenDrawerListForBills: function () {
                eventFunction.config.method = "getopenDrawerList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ id: 0 });
                eventFunction.config.ajaxCallMode = 1;
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
                    htmls += '<input type="text" id="b_' + value.Note + "_" + value.NoteID + '" class="bills bill' + count + '" value="0"/></td>';
                    //arrayNote.push(value.NoteID);
                });
                $(".noteFromDbForBills").html(htmls);
            },


            getopenDrawerListForCoin: function () {
                eventFunction.config.method = "getopenDrawerList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ id: 1 });
                eventFunction.config.ajaxCallMode = 2;
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
                    htmls += '<br/><input type="text" id="c_' + value.Note + "_" + value.NoteID + '" class="bills coin' + count + '" value="0" /></td>';
                    $("#hdnCurrencyIcons").val(value.CurrencyIcon);
                });
                $(".noteFromDbForCoins").html(htmls);
            },
            CheckIfCoin: function () {
                if ($('#ckbIsCoin').prop("checked") == true) {
                    return true;
                }
                else {
                    return false;
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
                    case 0:
                        break;
                    case 1:
                        eventFunction.bindopenDrawerListForBills(data);
                        break;
                    case 2:
                        eventFunction.bindopenDrawerListForCoin(data);
                        break;
                    case 3:
                        jAlert('Saved Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        $("input[type=radio][name=Customer]").removeAttr('checked');
                        location.reload();
                        break;
                    case 4:
                        eventFunction.bindOpenBalance(data);
                        break;
                    case 5:
                        eventFunction.bindUserList(data);
                        break;
                    case 6:
                        eventFunction.bindCostCenterList(data);
                        break;
                    case 7:
                        eventFunction.bindcheckForDataExist(data);
                        break;
                    case 8:
                        eventFunction.bindDoesopeningExist(data);
                        break;
                    case 9:
                        jAlert('Updated Successfully!', 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.config.TotalID = 0;
                        $("input[type=radio][name=Customer]").removeAttr('checked');
                        location.reload();
                        break;
                    case 10:
                        eventFunction.bindDoesClosingExist(data);
                        break;
                    case 14:
                        eventFunction.bindopenDrawerListForBillss(data);
                        break;
                    case 13:
                        eventFunction.bindopenDrawerListForCoins(data);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },

            resetOpenDrawer: function () {
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
    $.fn.openDrawers = function (p) {
        $.openDrawer(p);
    };
})(jQuery);
