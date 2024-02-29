
(function ($) {
    $.companyProfcreate = function (p) {
        p = $.extend
            ({
                UserModuleID: '',
                ModulePath: '/Modules/ChartOfAccount/FinancialAccount/webService/'
            }, p);
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "wsFinancialAc.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ajaxFailureMode: 0,
                FinancialAcID: 0,
                FinancialAcUpdate: 0,
                BankAccountID: 0,
            },
            InitialSetup: function () {
                eventFunction.getAllFinancialAcForGrid();
                eventFunction.getFinancialSysName();
                eventFunction.getFinancialAcName();

            },
            init: function () {
                eventFunction.InitialSetup();
                $("#btnSave").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid)
                        eventFunction.saveFinancialAc();
                });

                $("#btnMergeSave").on('click', function () {

                    var obj = {}
                    obj.ParentAccId = $('#selMergePName').val();
                    obj.NewAccName = $('#txtNewMergeName').val();
                    obj.MergeFirstAccId = $('#selMergeOneFinancialAc').val();
                    obj.MergeSecondAccId = $('#selMergeTwoFinancialAc').val();
                    obj.MergeBy = SageFrameUserName;
                    if (obj.MergeFirstAccId != obj.MergeSecondAccId) {
                        eventFunction.config.method = "MergeFinancialAcc";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ obj: obj });
                        eventFunction.config.ajaxCallMode = 12;
                        eventFunction.ajaxCall(eventFunction.config);
                    } else {
                        jAlert("Cannot merge same Accounts !!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    }
                });

                $("#btnOpeningSave").on('click', function () {
                    if ($('#selOpeningFinancialAc').val() == '') {
                        jAlert("Please Choose a Account !!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    } else if ($('#txtOpeningBalance').val() <= 0) {
                        jAlert("Opening Amount Should Be Greater Than 0 !!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    } else {
                        var obj = {}
                        obj.AccId = $('#selOpeningFinancialAc').val();
                        obj.OpeningDate = $('#OpeningDate').val();
                        obj.OpeningBalance = $('#txtOpeningBalance').val();
                        //obj.IsDebit = $('.DrOpen:checked').val();/* == "true" ? true : false;*/
                        obj.IsDebit = $('input:radio[name="DrCrOpening"]:checked').val()
                        obj.AddedBy = SageFrameUserName;

                        eventFunction.config.method = "AddOpeningBalance";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ obj: obj });
                        eventFunction.config.ajaxCallMode = 13;
                        eventFunction.ajaxCall(eventFunction.config);
                    }

                });

                $("#btnOpeningUpdate").on('click', function () {
                    if ($('#txtOpeningBalance').val() <= 0) {
                        jAlert("Opening Amount Should Be Greater Than 0 !!", 'Error!!', function () { $.alerts.dialogClass = null; });
                    } else {
                        var obj = {}
                        obj.AcOpeningId = $('#hdnOpeningDtId').val();
                        obj.TranDate = $('#OpeningDate').val();
                        obj.OpeningAmt = $('#txtOpeningBalance').val();
                        obj.IsDebit = $('input:radio[name="DrCrOpening"]:checked').val()
                        obj.AddedBy = SageFrameUserName;
                        eventFunction.config.method = "UpdateOpeningBalance";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ obj: obj });
                        eventFunction.config.ajaxCallMode = 13;
                        eventFunction.ajaxCall(eventFunction.config);
                    }

                });

                $("#btnCancel").on('click', function () {
                    eventFunction.Reset();
                });

                $("#btnMergeCancel").on('click', function () {
                    $(".MergeForm").hide();
                    $('#selMergePName').val('');
                    $('#txtNewMergeName').val('');
                    $('#selMergeOneFinancialAc').val('');
                    $('#selMergeTwoFinancialAc').val('');
                    eventFunction.Reset();
                });

                $('#btnOpening').on('click', function () {
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $("#btnMerge").hide();
                    $("#btnOpening").hide();
                    $("#btnAddOpening").show();
                    eventFunction.getOpeningBalanceDetails();
                })

                $('#btnAddOpening').on('click', function () {
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $("#btnMerge").hide();
                    $("#btnOpening").hide();
                    $("#btnOpeningSave").show();
                    $("#btnOpeningUpdate").hide();
                    //$("#OpeningBalance").show();
                    $('#OpeningBalance').dialog({
                        'title': 'Opening Balance',
                        width: '400',
                        height: 'auto',
                        modal: true,
                        position: ['center', 'center']
                    });
                })

                $("#btnOpeningCancel").on('click', function () {
                    $("#btnOpeningSave").hide();
                    $("#btnOpeningUpdate").hide();
                    $("#OpeningBalance").dialog('close');

                });



                $("#selFinancialSys").on("change", function () {
                    // alert($("#selFinancialSys").find(':selected').attr('data'));
                    var isgrp = $(this).find(':selected').attr('data');
                    //if (isgrp == "false")
                    //    $(".open").show();
                    //else
                    //    $(".open").hide();
                    if ($(this).val() == 4) {
                        $("#BankAccountForm").show();
                    } else
                        $("#BankAccountForm").hide();
                });


                $('#txtOpeningBalance').on('keypess', function (event) {
                    if ((event.which != 46 || $(this).val().indexOf('.') != -1) && (event.which < 48 || event.which > 57) && event.which != 8) {
                        event.preventDefault();
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
                        eventFunction.bindFinancialSysName(data);
                        break;
                    case 2:
                        jAlert("Saved Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.getAllFinancialAcForGrid();
                        break;
                    case 3:
                        eventFunction.bindAllFinancialAcForGrid(data.d);
                        eventFunction.bindParentFinancialAcName(data.d);
                        eventFunction.bindMergeParentFinancialAcName(data.d);
                        break;
                    case 4:
                        jAlert(data.d, 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.getAllFinancialAcForGrid();
                        break;
                    case 5:
                        jAlert("Updated Successfully!", 'Information!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        eventFunction.getAllFinancialAcForGrid();
                        break;
                    case 6:
                        eventFunction.bindBankInfoByFinancialAcID(data)
                        break;
                    case 9:
                        var html = "";
                        $.each(data.d, function (index, value) {
                            html += "<option value='" + value.fyId + "'>" + value.fyName + "</option>"
                        });
                        $("#txtFyid").html(html);
                        break;
                    case 9:
                        var html = "";
                        $.each(data.d, function (index, value) {
                            html += "<option value='" + value.fyId + "'>" + value.fyName + "</option>"
                        });
                        $("#txtFyid").html(html);
                        break;
                    case 10:
                        eventFunction.bindFinancialAcName(data.d);
                        break;

                    case 11:
                        break;
                    case 12:
                        jAlert("Merged Successfully !!!", 'Error!!', function () { $.alerts.dialogClass = null; });
                        eventFunction.Reset();
                        break;
                    case 13:
                        jAlert("Opening Added Successfully !!!", 'Error!!', function () { $.alerts.dialogClass = null; });
                        $('#OpeningBalance').dialog('close');
                        $('#btnAddOpening').hide();
                        eventFunction.Reset();
                        break;
                    case 14:
                        eventFunction.bindAllOpeningForGrid(data.d);
                        break;
                    case 15:
                        var d = JSON.parse(data.d)
                        eventFunction.bindOpeningEdit(d);
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
            getTodayFiscalYr: function () {
                eventFunction.config.method = "getTodayFiscalYr";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 9;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getAllFinancialAcForGrid: function () {
                eventFunction.config.method = "getAllFinancialAcForGrid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getFinancialAcName: function () {
                eventFunction.config.method = "getFinancialAc";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 10;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getOpeningBalanceDetails: function () {
                eventFunction.config.method = "getOpeningBalanceDetails";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 14;
                eventFunction.ajaxCall(eventFunction.config);
            },

            bindFinancialAcName: function (result) {
                data = JSON.parse(result);
                var AutocompleteFinancialAc = [];
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        if (!value.SystemGenerated || !value.isGroup) {

                            AutocompleteFinancialAc.push({ label: value.items, id: value.FinancialAcID });
                        }
                    });
                }
                $(".selFristFinancialAc").autocomplete({
                    source: AutocompleteFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnFirstFinancialAcID').val(ui.item.id);
                    }
                });
                $(".selSecondFinancialAc").autocomplete({
                    source: AutocompleteFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnSecondFinancialAcID').val(ui.item.id);
                    }
                });
                $(".selOpeningFinancialAc").autocomplete({
                    source: AutocompleteFinancialAc,
                    delay: 0,
                    select: function (event, ui) {
                        $('.hdnOpeningFinancialAcID').val(ui.item.id);
                    }
                });



            },

            bindOpeningEdit: function (result) {
                $('#hdnOpeningDtId').val(result.AcOpeningId);
                $('.selOpeningFinancialAc').val(result.AcName);
                $('.selOpeningFinancialAc').prop('disabled', true);
                $("#OpeningDate").datepicker("setDate", result.TranDate.split('T')[0]);
                //$('#OpeningDate').val();
                $('#txtOpeningBalance').val(result.OpeningAmt);
                $('input:radio[value="' + result.IsDebit + '"]').prop('checked', true)
                $("#btnOpeningSave").hide();
                $("#btnOpeningUpdate").show();
                $('#OpeningBalance').dialog({
                    'title': 'Opening Balance',
                    width: '400',
                    height: 'auto',
                    modal: true,
                    position: ['center', 'center']
                });
            },

            bindAllOpeningForGrid: function (result) {
                var data = JSON.parse(result);
                var htmls = "";
                htmls += '<table id="tblOfOpeningBlc" class="sfGridwrapper display dataTable no-footer"><thead><tr><th style="display:none;"></th><th>S.N.</th><th>Account Name</th><th>Opening Date</th><th>Opening Amt</th><th>IsDebit</th>';
                //htmls += '<th>Opening Balance(Rs.)</th>';
                htmls += '<th class="edit-heading">Edit</th></tr></thead><tbody>';
                if (data.length > 0) {
                    var sn = 1;
                    $.each(data, function (index, value) {
                        htmls += '<tr>';
                        htmls += '<td>' + sn + '</td>';
                        htmls += '<td>' + value.AcName + '</td>';
                        htmls += '<td>' + value.TranDate.split('T')[0] + '</td>';
                        htmls += '<td>' + value.OpeningAmt + '</td>';
                        htmls += '<td>' + (value.IsDebit == true ? "Yes" : "No") + '</td>';
                        htmls += '<td><label value="Edit" class="openingEdit icon-edit" id="' + value.AcOpeningId + '"></label></td>';
                        htmls += '</tr>';
                        sn++;
                    });
                    htmls += '</tbody></table>';
                    $("#divForOpeningBalance").html(htmls);
                } else {
                    $("#divForOpeningBalance").html("No Data found !!");
                };


                $('.openingEdit').on('click', function () {
                    var id = parseInt($(this).attr('id'));
                    eventFunction.config.method = "GetAcOpeningDetails";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ id: id });
                    eventFunction.config.ajaxCallMode = 15;
                    eventFunction.ajaxCall(eventFunction.config);

                })
            },

            bindAllFinancialAcForGrid: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                htmls += '<table id="tblOfFinancialAc" class="sfGridwrapper display dataTable no-footer"><thead><tr><th style="display:none;"></th><th>S.N.</th><th style="display:none;">Account Name</th><th>GL Account</th><th>Parent Account</th><th>Financial System</th>';
                //htmls += '<th>Opening Balance(Rs.)</th>';
                htmls += '<th>Added On</th><th>Added By</th><th class="edit-heading">Edit</th><th class="delete-heading">Delete</th></tr></thead><tbody>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<tr class="isGroup' + value.isGroup + '"><td style="display:none;" class="details-control"></td><td>' + (index + 1) + '</td>';
                        htmls += '<td style="display:none;">' + value.FinancialAcName + '</td>';
                        htmls += '<td>';
                        for (var i = 0; i < value.level; i++) {
                            //htmls += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
                            htmls += "- - - - - -"
                        }
                        htmls += value.FinancialAcName + '</td>';
                        // htmls += '<td>' + value.items + '</td>';
                        htmls += '<td>' + value.PFinancialAcName + '</td>';
                        htmls += '<td>' + value.FinancialSysName + '</td>';
                        //if (value.isGroup == false)
                        //    htmls += '<td class="tdrate">' + parseFloat(value.OpeningBalance).toFixed(2) + '</td>';
                        //else
                        //    htmls += '<td></td>';
                        var dates = value.AddedOn.split(" ");
                        htmls += '<td>' + dates[0] + '</td>';
                        htmls += '<td>' + value.AddedBy + '</td>';
                        if (!value.IsGroup) {
                            htmls += '<td><label value="Edit" class="edit icon-edit" id="' + value.FinancialAcID + '+' + value.PFinancialAcID + '+' + value.FinancialSysID + '+' + value.OpeningBalance + '+' + value.isGroup + '+' + value.FinancialAcName + '"></label></td>';
                        } else {
                            htmls += '<td><label value="Edit" class="edit icon-edit" hidden id="' + value.FinancialAcID + '+' + value.PFinancialAcID + '+' + value.FinancialSysID + '+' + value.OpeningBalance + '+' + value.isGroup + '+' + value.FinancialAcName + '"></label></td>';
                        }

                        if (!value.IsGroup) {
                            htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '"></label></td></tr>';
                        } else {
                            htmls += '<td><label value="Delete" class="delete icon-delete" id="' + value.FinancialAcID + '" hidden></label></td></tr>';
                        }
                    });
                    htmls += '</tbody></table>';
                    $("#divForFinancialAc").html(htmls);
                } else {
                    $("#divForFinancialAc").html(htmls);
                }
                $("#tblOfFinancialAc").dataTable({
                    jQueryUI: true,
                    sort: false,
                    paging: false,
                    //info: false,
                });
                $("#tblOfFinancialAc").on('click', '.delete', function () {
                    var datas = $(this).attr('id');
                    var username = SageFrameUserName;
                    jConfirm('Are You Sure  ?', 'Delete', function (confirmed) {

                        if (confirmed) {
                            eventFunction.config.method = "deleteFinancialAcByID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ id: datas, username: username });
                            eventFunction.config.ajaxCallMode = 4;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    });
                });

                $('#btnMerge').on('click', function () {
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $("#btnMerge").hide();
                    $("#btnOpening").hide();
                    $(".MergeForm").show();
                })

                $("#btnAdd").click(function () {
                    $("#divForFinancialAc").hide();
                    $("#btnAdd").hide();
                    $("#btnMerge").hide();
                    $("#btnOpening").hide();
                    $(".AccountForm").show();
                });



                $('#selPName').on('change', function () {
                    if ($(this).val() == 0) {
                        $('#divFinancialSys').hide();
                        $('#divFinancialType').show();
                        $('#divFinancialTypeCol').show();
                    } else {
                        $('#divFinancialSys').show();
                        $('#divFinancialType').hide();
                        $('#divFinancialTypeCol').hide();
                    }
                });

                $('#selFinancialSys').on('change', function () {
                    if ($(this).val() == 2) {
                        $('#open').show();
                    } else {
                        $('#open').hide();
                    }
                });


                $("#tblOfFinancialAc").on('click', '.edit', function () {
                    //if (confirm("Edit! Are You Sure?"))
                    {
                        var row = $(this).parents('tr');
                        //$("#txtName").val(row.find('td:eq(1)').text());
                        var datas = $(this).attr('id');
                        var word = datas.split("+");
                        $("#txtName").val(word[5]);
                        $("#selPName").val(word[1]);
                        $("#selFinancialSys").val(word[2]);
                        //if (word[4] == "false") {
                        //    $("#txtOpeningBalance").val(parseFloat(word[3]).toFixed(2));
                        //    $(".open").show();
                        //} else {
                        //    $("#txtOpeningBalance").val("");
                        //    $(".open").hide();
                        //}
                        eventFunction.config.FinancialAcID = word[0];
                        eventFunction.config.FinancialAcUpdate = 1;
                        var username = SageFrameUserName;
                        if (word[2] == 4) {
                            eventFunction.config.method = "getBankInfoByFinancialAcID";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ FinancialAcID: word[0] });
                            eventFunction.config.ajaxCallMode = 6;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                        window.scrollTo(0, 0);
                        $("#btnSave").text("Update");
                        $("#divForFinancialAc").hide();
                        $("#btnAdd").hide();
                        $(".AccountForm").show();
                    }
                });
            },

            bindBankInfoByFinancialAcID: function (result) {
                var data = result.d;
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        $("#txtPhoneNo").val(value.PhoneNo);
                        $("#txtBranch").val(value.Branch);
                        $("#txtContactPerson").val(value.ContactPerson);
                        $("#chkboxIsFixed").prop("checked", value.IsFixed);
                        $("#txtInterestRate").val(value.InterestRate);
                        //var test= new Date(value.OpenDate.match(/\d+/).map(Number)[0])
                        //alert(test);
                        var OpenDate = value.OpenDate.split(" ");
                        var MatureDate = value.MatureDate.split(" ");
                        $("#txtOpenDate").val(OpenDate[0]);
                        $("#txtMatureDate").val(MatureDate[0]);
                        $("#txtMinimumBalance").val(value.MinimumBalance);
                        $("#BankAccountForm").show();
                    });
                }
            },

            saveFinancialAc: function () {

                var info = {};
                info.FinancialAcID = eventFunction.config.FinancialAcID;
                info.FinancialAcName = $("#txtName").val();
                info.PFinancialAcID = parseInt($("#selPName").val());
                info.FinancialSysID = $("#selFinancialSys").val() == null ? "1" : $("#selFinancialSys").val();
                info.OpeningBalance = $("#txtOpeningBalance").val();
                info.AccountEntryType = $('#selFinancialType').val();
                if (parseInt($("#selPName").val()) == 0) {

                    info.IsDebit = $('input:radio[name="DrCrCol"]:checked').val();/* == "true" ? true : false;*/
                }

                info.AddedBy = SageFrameUserName;
                var banks = [];
                if ($("#selFinancialSys").val() == 4) {
                    var bankInfo = new Object();
                    //bankInfo.BankAccountID = eventFunction.config.BankAccountID;
                    //bankInfo.FinancialAcID = parseInt($("#txt").val());
                    bankInfo.PhoneNo = $("#txtPhoneNo").val();
                    bankInfo.Branch = $("#txtBranch").val();
                    bankInfo.ContactPerson = $("#txtContactPerson").val();
                    bankInfo.IsFixed = $("#chkboxIsFixed").is(":checked");
                    //bankInfo.IsFixed = $("#chkboxIsFixed").val();
                    bankInfo.InterestRate = parseFloat($("#txtInterestRate").val());
                    bankInfo.OpenDate = $("#txtOpenDate").val();
                    bankInfo.MatureDate = $("#txtMatureDate").val();
                    bankInfo.MinimumBalance = parseFloat($("#txtMinimumBalance").val());

                    banks.push(bankInfo);
                }
                info.bankInfo = banks;
                eventFunction.config.method = "saveFinancialAc";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ info: info });
                if (eventFunction.config.FinancialAcUpdate == 1)
                    eventFunction.config.ajaxCallMode = 5;
                else
                    eventFunction.config.ajaxCallMode = 2;
                eventFunction.config.ajaxFailureMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
                //eventFunction.config.FinancialAcUpdate = 0;
                //eventFunction.config.FinancialAcID = 0;
            },

            getParentFinancialAcName: function () {
                eventFunction.config.method = "getAllFinancialAcForGrid";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindParentFinancialAcName: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                htmls += '<option selected value="0">Root</option>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        if (value.isGroup) {
                            htmls += '<option value="' + value.FinancialAcID + '">' + value.items + '</option>';
                        }
                    });
                }
                $("#selPName").html(htmls);

            },
            bindMergeParentFinancialAcName: function (result) {
                data = JSON.parse(result);
                var htmls = "";
                htmls += '<option selected value="0">Root</option>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        if (value.isGroup) {
                            htmls += '<option value="' + value.FinancialAcID + '">' + value.items + '</option>';
                        }
                    });
                }
                $("#selMergePName").html(htmls);

            },

            getFinancialSysName: function () {
                eventFunction.config.method = "getFinancialSysName";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            bindFinancialSysName: function (result) {
                var data = result.d;
                var htmls = "";
                htmls += '<option selected value="0" disabled> -Select- </option>';
                if (data.length > 0) {
                    $.each(data, function (index, value) {
                        htmls += '<option value="' + value.FinancialSysID + '" data="' + value.isGroup + '">' + value.FinancialSysName + '</option>';
                    });
                    $("#selFinancialSys").html(htmls);
                } else {
                    $("#selFinancialSys").html("No Data");
                }
            },

            Reset: function () {
                eventFunction.config.FinancialAcUpdate = 0;
                eventFunction.config.FinancialAcID = 0;
                $("#txtName").val("");
                $("#selPName").val("0");
                $("#selFinancialSys").val("0");

                $("#btnSave").text("Save");
                $(".AccountForm").hide();
                $("#divForFinancialAc").show();
                $("#btnAdd").show();

                $("#btnOpeningUpdate").hide();
                $("#btnOpeningSave").hide();

                $('#hdnOpeningDtId').val('');
                $('.selOpeningFinancialAc').val('');
                $('.selOpeningFinancialAc').prop('disabled', false);
                $('#OpeningDate').val('');
                $('#txtOpeningBalance').val('');

                //Add account Reset form
                $('#divFinancialSys').hide();
                $('.MergeForm').hide();
                //$('#divFinancialTypeCol').hide();

                //Merge Form Reset
                $("#btnMerge").show();
                $("#btnOpening").show();
                $("#OpeningBalance").hide();

                //$("#divForFinancialAc").hide();
                //$("#btnAdd").hide();
                //$(".AccountForm").hide();
                $("#BankAccountForm").hide();
                $("#txtPhoneNo").val('');
                $("#txtBranch").val('');
                $("#txtContactPerson").val('');
                $("#chkboxIsFixed").prop("checked", false);
                //bankInfo.IsFixed = $("#chkboxIsFixed").val();
                $("#txtInterestRate").val(0);
                $("#txtOpenDate").val('');
                $("#txtMatureDate").val('');
                $("#txtMinimumBalance").val(0);

            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        Name: {
                            required: true,
                        },
                        FinancialSys: {
                            required: true,
                        },
                        PhoneNo: {
                            number: true,
                        },
                        Branch: {
                            required: true,
                        },
                        ContactPerson: {
                            required: true,
                        },
                        InterestRate: {
                            number: true,
                        },
                        MinimumBalance: {
                            number: true,
                        },
                    },
                    messages: {
                        PhoneNo: {
                            number: "Enter Number",
                        },
                        InterestRate: {
                            number: "Enter Number",
                        },
                        MinimumBalance: {
                            number: "Enter Number",
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