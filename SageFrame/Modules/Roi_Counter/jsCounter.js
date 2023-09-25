(function ($) {
     var tabs = $("#tabs").tabs();
    $.Counter = function (p) {
        var arrayNote = [];
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/Roi_Counter/',
                 master: '0',
             }, p);
        var v = 0;
        var DiffAmount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsForCounter.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                NewItemID: 0,
                ItemIDUpdate: 0


            },
            InitialSetup: function () {
                var sum = 0;
                eventFunction.getCostCenterlist();
                eventFunction.getUserlist();
                eventFunction.getopenDrawerListForBills();
                eventFunction.getopenDrawerListForCoin();
                $('#ckbxIsOpening').prop('checked', true);
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
                //$(".bills").click(function () {
                //    var a = $(this).attr('id');
                //    word = a.split('_');
                //    sum = $("#txtTotalCount").val() - (word[1] * $("#" + a).val());
                //});

                $(document).on('click', '.bills', function (e) {
                    e.preventDefault();
                    var a = $(this).attr('id');
                    word = a.split('_');
                    sum = $("#txtTotalCount").val() - (word[1] * $("#" + a).val());
                });

                $("#ckbxIsOpening").click(function () {
                    eventFunction.checkIsOpen();
                    if (eventFunction.checkIsOpen() == true)
                        $("#txtOpenDrawerBalance").val(0);
                    //else
                    //    eventFunction.getOpenBalance();
                });
                $("#AddOpenDrawer").click(function () {
                    var counter = {};
                    if ($("#selNewCP").val() != $("#selOldCP").val()) {
                        eventFunction.saveCounter();
                        eventFunction.resetCounter();
                        eventFunction.InitialSetup();
                    }
                    else
                        jAlert('Error: You have Selected Same Counter Person /n Select Different Counter Person', 'Information!!', function () { $.alerts.dialogClass = null; });
                });

                $("#selCostCenter").change(function () {
                   //alert( $(this).val());
                    var ids = $(this).val();
                    eventFunction.getNumberOfCounter(ids);
                });
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
                htmls += "<table id='tableForCounterTotal' class='sfGridwrapper display dataTable no-footer'><thead><tr><th>S.N.</th><th>Cost Center</th><th>Counter ID</th><th>Balance</th><th>Is Opening</th><th>NewCounterPerson</th><th>OldCounterPerson</th></tr></thead><tbody>";
                $.each(data, function (index, value) {
                    a++;
                    htmls += '<tr><td>' + a + '</td>';
                    htmls += '<td>' + value.CCID + '</td>';
                    htmls += '<td>' + value.CID + '</td>';
                    htmls += '<td>' + value.Amount + '</td>';
                    //htmls += '<td>' + value.DifAmount + '</td>';
                    htmls += '<td>' + value.IsOpening + '</td>';
                    htmls += '<td>' + value.NewCounterPerson + '</td>';
                    htmls += '<td>' + value.OldCounterPerson + '</td>';
                    //htmls += '<td><input type="button" class="showNote" id="' + value.CTID + '" value="Show"></td></tr>';
                    htmls += '</tr>';
                });
                htmls += "</tbody></table>";
                $("#CounterTotalListing").html(htmls);
                $("#tableForCounterTotal").dataTable({
                    paging: false,
                    searching: false,
                });

                //$(".showNote").click(function () {
                //    var ids = $(this).attr('id');
                //    eventFunction.config.method = "getshowNote";
                //    eventFunction.config.data = JSON2.stringify({ id: ids });
                //    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                //    eventFunction.config.ajaxCallMode = 14;
                //    eventFunction.ajaxCall(eventFunction.config);
                //});
            },

            getNumberOfCounter: function (data) {
                eventFunction.config.method = "getNumberOfCounter";
                eventFunction.config.data = JSON2.stringify({ id: data });
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindNumberOfCounter: function (result) {
                var htmls = "";
                var data = result.d;
                var a = 0;
                $.each(data, function (index, value) {
                    a = value.NumberOfCounter;
                });
                htmls += '<option selected disabled value="">-select- </option>';
                for (var i = 1; i <= a; i++) {
                    htmls += "<option value='" + i + "'>" + i + "</option>"
                }
                $("#txtCN").html(htmls);
            },

            saveCounter: function () {
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

                var cTransaction = new Object();
                cTransaction.CID = $("#txtCN").val();
                cTransaction.IsOpening = eventFunction.checkIsOpen();
                cTransaction.Amount = $("#txtTotalCount").val();
                cTransaction.NCPID = $("#selNewCP").val();
                cTransaction.CostCenterID = $("#selCostCenter").val();
                cTransaction.OCPID = $("#selOldCP").val();
                cTransaction.Date = new Date();
                //var counter = {};
                //counter.CID = $("#txtCN").val();
                //counter.Balance = $("#txtTotalCount").val();
                //counter.IsClosing = eventFunction.checkIsOpen();
                //counter.DiffAmount = "0";
                //counter.Date = new Date();
                //counter.CostCenterID = $("#selCostCenter").val();
                //counter.CTransaction = cTransaction;

                cTransaction.NoteList = NoteList;
                eventFunction.config.method = "saveCounter";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ counter: cTransaction });
                eventFunction.config.ajaxCallMode = 6;
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
                eventFunction.config.method = "getOpenBalance";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindOpenBalance: function (result) {
                var data = result.d;
                if (!data) return;
                $("#txtOpenDrawerBalance").val(data);
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
                    htmls += '<br/><input type="text" id="c_' + value.Note + "_" + value.NoteID + '" class="bills coin' + count + '" value="0" /></td>';
                    $("#hdnCurrencyIcon").val(value.CurrencyIcon);
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
                    htmls += '<input type="text" id="b_' + value.Note + "_" + value.NoteID + '" class="bills bill' + count + '" value="0"/></td>';
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
                $("#selNewCP").append(htmls);
                $("#selOldCP").append(htmls);
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
                $.each(data, function (index, value) {
                    htmls += "<option value='" + value.CostCenterID + "'>" + value.CostCenterName + "</option>"
                });
                $("#selCostCenter").append(htmls);
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
                        break;
                    case 7:
                        //alert("success");
                        eventFunction.bindCounterTotal(data);
                        break;
                    case 8:
                        eventFunction.bindNumberOfCounter(data);
                        break;
                }
            },
            ajaxFailure: function (error) {
                console.debug(error);
            },
            reset: function () {

            },

            resetCounter: function () {
                $("#txtOpenDrawerBalance").val(0);
                $(".bills").val(0);
                $("#txtTotalCount").val(0);
                sum = 0;
                $("#selCostCenter").val("");
                $("#txtCN").val("");
                $("#txtApprovedBy").val("");
                $("#selNewCP").val("");
                $("#selOldCP").val("");
            },
        };
        eventFunction.init();
    };
    $.fn.Counters = function (p) {
        $.Counter(p);
    };
})(jQuery);