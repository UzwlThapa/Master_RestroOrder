/// <reference path="../../../../js/jquery-1.7.js" />
(function ($) {
    var tabs = $("#tabs").tabs();
    $.chalanSetting = function (p) {
        p = $.extend
             ({
                 ModulePath: '/Modules/Admin/DailyChalan'
             }, p);

        var TotalAmount = 0;
        var TotalReturnedAmount = 0;
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "/DailyChalan.asmx/",
                method: "",
                url: "",
                ModulePath: p.ModulePath,
                ajaxCallMode: 0,

            },
            InitialSetup: function () {

                //$('.chkIssue').click(function () {

                //});

                $(".txtTotal").on('change', function () {
                    $(".txtRemainingAmt").val($(".txtTotal").val());
                });

                $('#IssueContainer').on('click', '.btnPlus', function () {
                    var isvalid = eventFunction.validTable($(this).parents("tr"));
                    if (isvalid) {
                        var html = '<tr class="issueRow" data-id="0">' + $(this).parents('tr').html() + '</tr>';
                        $(this).removeClass('btnPlus');
                        $(this).addClass('btnMinus');
                        $(this).val('-');
                        $('#IssueContainer tbody').append(html);
                    }
                });
                $("#ddlAssig").on('change', function () {
                    var value = $('#ddlAssig').val();
                    $(".dd_AssignedBy").val(value);
                });


                $("#IssueContainer").on("change", ".txtIssuedAmount", function () {
                    var TA = 0;
                    $('.txtIssuedAmount').each(function (x, y) {
                        TA += parseFloat($(this).val());
                    });
                    $(".txtIssuedBalance").val(TA);
                    var a = parseFloat($(".txtRemainingAmt").val());
                    var b = parseFloat($(this).val());
                    var Issuebal = parseInt(a - b);
                    $(".txtRemainingAmt").val(Issuebal);

                });

                $('#IssueContainer').on('click', '.btnMinus', function () {
                    $(this).parents('.issueRow').remove();
                    var TA = 0;
                    $('.txtIssuedAmount').each(function (x, y) {
                        TA += parseFloat($(this).val());
                    });
                    $(".txtIssuedBalance").val(TA);
                });

                $('#returnContainer').on('click', '.btnReturnPlus', function () {
                    var isvalid = eventFunction.validTable($(this).parents("tr"));
                    if (isvalid) {
                        var html = '<tr class="returnRow" data-id="0">' + $(this).parents('tr').html() + '</tr>';
                        $(this).removeClass('btnReturnPlus');
                        $(this).addClass('btnReturnMinus');
                        $(this).val('-');
                        $('#returnContainer tbody').append(html);
                    }
                });

                $("#returnContainer").on("change", ".txtReturnedAmount", function () {
                    var TA = 0;
                    $('.txtReturnedAmount').each(function (x, y) {
                        TA += parseFloat($(this).val());
                    });
                    $(".txtReturnedBalance").val(TA);

                    var returnbal = parseFloat($(".txtRemainingAmt").val()) + parseFloat($(this).val());
                    $(".txtRemainingAmt").val(returnbal);
                });

                $('#returnContainer').on('click', '.btnReturnMinus', function () {
                    $(this).parents('.returnRow').remove();
                    var TA = 0;
                    $('.txtReturnedAmount').each(function (x, y) {
                        TA += parseFloat($(this).val());
                    });
                    $(".txtReturnedBalance").val(TA);
                });
            },
            init: function () {
                $("#btnAdd").show();
                $("#container").hide();
                //$("#bindChalan").show();
                eventFunction.InitialSetup();
                eventFunction.GetItem();
                eventFunction.DropDownItem();
                $("#btnAdd").on("click", function (event) {
                    $("#container").show();
                    $("#btnAdd").hide();
                    $("#bindChalan").hide();
                    eventFunction.ResetAll();

                })
                $("#btnSave").on("click", function (event) {
                    var checkValid = eventFunction.validationform();
                    if (checkValid) {
                        eventFunction.ChalanSaveTodatabase();
                        eventFunction.GetItem();
                        $("#container").hide();
                        $("#btnAdd").show();
                        $("#bindChalan").show();
                        eventFunction.ResetAll();
                    }

                });

                $("#btnCancel").on("click", function (event) {
                    location.reload();
                    $("#bindChalan").show();
                    $("#tabs").hide();
                    $("#btnAdd").show();
                    eventFunction.ResetAll();
                    $(".AddIssue").show();
                    $("#IssueContainer").hide();
                    $(".AddReturn").show();
                    $("#returnContainer").hide();
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
                        eventFunction.BindData(data);
                        break;
                    case 2:
                        eventFunction.BindDropDown(data);
                        break;
                    case 3:
                        jAlert('Inserted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        break;
                    case 4:
                        eventFunction.BindIssuedRow(data);
                    case 5:
                        eventFunction.BindReturnedRow(data);
                        //case 6:
                        //    alert("Updated Successfully");
                        //    eventFunction.GetItem();
                        //    break;
                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>


            ChalanSaveTodatabase: function () {
                var issueDetails = new Array();
                var returnedDetails = new Array();
                var issueRows = $('table#IssueContainer').find('tbody').find('tr');
                var returnedRows = $('table#returnContainer').find('tbody').find('tr');

                $.each(issueRows, function (index, value) {
                    var obj = new Object();
                    obj.issueID = ($(value).attr('data-id'));
                    obj.IssuedBy = ($(value).find('.dd_IssuedBy').val());
                    obj.IssuedAmount = parseFloat($(value).find('.txtIssuedAmount').val() == "" ? 0 : $(value).find('.txtIssuedAmount').val()).toFixed(2);
                    obj.For = ($(value).find('.txtFor').val());
                    // obj.Balance = ($(value).find('.txtBalance').val());
                    issueDetails.push(obj);

                });

                $.each(returnedRows, function (index, value) {
                    var newObj = new Object();
                    newObj.returnedID = ($(value).attr('data-id'));
                    newObj.ReturnedBy = ($(value).find('.dd_ReturnedBy').val());
                    newObj.ReturnedAmount = parseFloat($(value).find('.txtReturnedAmount').val() == "" ? 0 : $(value).find('.txtReturnedAmount').val()).toFixed(2);
                    newObj.Remarks = ($(value).find('.txtMessage').val());
                    returnedDetails.push(newObj);

                });
                chalan = new Object();
                chalan.issueDetails = issueDetails;
                chalan.returnedDetails = returnedDetails;
                chalan.DailyChalanId = $('#txtId').val();
                chalan.TotalAmount = $('.txtTotal').val();
                chalan.RemainingAmount = $('.txtRemainingAmt').val();
                chalan.AssignedBy = $('.dd_AssignedBy').val();
                chalan.IssuedBalance = parseFloat($('.txtIssuedBalance').val() == 0 ? 0 : $('.txtIssuedBalance').val()).toFixed(2);
                chalan.ReturnedBalance = parseFloat($('.txtReturnedBalance').val() == "" ? 0 : $('.txtReturnedBalance').val()).toFixed(2);
                eventFunction.config.method = "ChalanSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ chalan: chalan });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetItem: function () {
                eventFunction.config.method = "GetDataFromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },

            DropDownItem: function () {
                eventFunction.config.method = "GetDropdown";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindingIssueDetails: function (ids) {
                eventFunction.config.method = "GetIssuedDetails";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ DailyChalanId: ids });
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            BindingReturnDetails: function (ids) {
                eventFunction.config.method = "GetReturnedDetails";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ DailyChalanId: ids });
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            validTable: function (t) {
              
                t.find(".sfError").removeClass("sfError");
                var valid = true;

                if (t.find(".txtIssuedAmount").val() == "") {
                    t.find(".txtIssuedAmount").addClass("sfError");
                    valid = false;
                }
                if (t.find(".txtReturnedAmount").val() == "") {
                    t.find(".txtReturnedAmount").addClass("sfError");
                    valid = false;
                }

                return valid;
            },
            validationform: function () {
                v = $('#form1').validate({
                    rules: {
                        //StoreItem

                        txtTotal: {
                            required: true
                        },
                        txtIssuedAmount: {
                            required: true,
                            number:true,
                        },
                        txtFor: {
                            required: true,
                        },
                        txtReturnedAmount: {
                            required: true,
                            number: true,
                        },
                        txtMessage: {
                            required: true,
                        },
                        dd_AssignedBy: {
                            required: true,
                        }

                    },
                    //messages: {

                    //    txtType: {
                    //        number: '*'
                    //    },

                    //},
                });
                if (v.form()) {
                    return true;
                }
                else
                    return false;

            },
            //<<-----------------------------------BindTable Here ------------------------------------->>>

            BindDropDown: function (data) {

                var datas = data.d;

                $('.dd_bind').show();
                $(".dd_bind").html("");

                if (datas.length > 0) {
                    var htmls = '';

                    htmls = "<option>Select</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value ='" + value.UserName + "'>" + value.UserName + " </option>";
                    });
                }
                $(".dd_bind").html(htmls);

            },

            BindData: function (data) {
                var datas = data.d;
                $('#bindChalan').show();
                $('#bindChalan').html("");

                if (datas.length > 0) {
                    var htmlstring = "";
                    htmlstring += "<table id='bindTable' class='sfGridwrapper display dataTable no-footer'>"

                    htmlstring += "<thead>"
                    htmlstring += "<tr>"
                    htmlstring += "<th> Daily Chalan Id </th><th> Total Amount </th><th> Assigned By </th><th>Issued Balance</th><th>Returned Balance</th><th>Edit</th>";
                    htmlstring += "</tr>"
                    htmlstring += "</thead>"
                    htmlstring += "<tbody>"

                    $.each(datas, function (index, value) {
                        htmlstring += "<tr>";
                        htmlstring += "<td>" + value.DailyChalanId + "</td>";
                        htmlstring += "<td>" + value.TotalAmount + "</td>";
                        htmlstring += "<td>" + value.AssignedBy + "</td>";
                        htmlstring += "<td>" + value.IssuedBalance + "</td>";
                        htmlstring += "<td>" + value.ReturnedBalance + "</td>";
                        htmlstring += "<td ><img src='/images/edit.png' class='delete-icon' type='button' id='Chalan_" + value.DailyChalanId + "_" + value.TotalAmount + "_" + value.AssignedBy + "_" + value.IssuedBalance + "_" + value.ReturnedBalance +"_" + value.RemainingAmount + "' class='chalanedit' value='Edit'></td>";
                        htmlstring += "</tr>"

                    });
                    htmlstring += "</tbody>";
                    htmlstring += "</table>";
                    $('#bindChalan').html(htmlstring);
                    $("#bindTable").dataTable(
                        {
                        scrollX: true,
                    autoWidth: false,
                    ordering: false,
                        }
                    );
                    $('#bindTable').on('click', '.chalanedit', function () {
                        var id = $(this).attr('id');
                        var findId = id.split('_');
                        var ids = findId[1];
                        var totalamt = findId[2];
                        var assigned = findId[3];
                        var issuedBal = findId[4];
                        var returnedBal = findId[5];
                        $("#bindChalan").hide();
                        $('#btnAdd').hide();
                        $("#container").show();
                        $('#btnsave').hide();
                        $('#btnEdit').show();
                        $('#txtId').val(ids);
                        $('.txtTotal').val(totalamt);
                        $('.txtIssuedBalance').val(issuedBal);
                        $('.dd_AssignedBy').val(assigned);
                        $('.txtReturnedBalance').val(returnedBal);
                        $('.txtRemainingAmt').val(findId[6]);
                        eventFunction.BindingIssueDetails(ids);
                        eventFunction.BindingReturnDetails(ids);
                    });
                } else {
                    $('#bindChalan').html('No data');
                }
            },

            BindIssuedRow: function (data) {
                var datas = data.d;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        if (index != 0) {
                            $('#IssueContainer .issueRow:eq(' + (index - 1) + ')').find('.btnPlus').click();
                        }
                        $('#IssueContainer .issueRow:eq(' + index + ')').attr('data-id', value.issueID);
                        $('#IssueContainer .issueRow:eq(' + index + ')').find('.dd_IssuedBy').val(value.IssuedBy);
                        $('#IssueContainer .issueRow:eq(' + index + ')').find('.txtIssuedAmount').val(value.IssuedAmount);
                        $('#IssueContainer .issueRow:eq(' + index + ')').find('.txtFor').val(value.For);
                    });
                    $(".AddIssue").hide();
                    $("#IssueContainer").show();
                } else {
                    $(".AddIssue").show();
                    //$("#IssueContainer").show();
                }
            },
            BindReturnedRow: function (data) {
                var datas = data.d;
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        if (index != 0) {
                            $('#returnContainer .returnRow:eq(' + (index - 1) + ')').find('.btnReturnPlus').click();
                        }
                        $('#returnContainer .returnRow:eq(' + index + ')').attr('data-id', value.returnedID);
                        $('#returnContainer .returnRow:eq(' + index + ')').find('.dd_ReturnedBy').val(value.ReturnedBy);
                        $('#returnContainer .returnRow:eq(' + index + ')').find('.txtReturnedAmount').val(value.ReturnedAmount);
                        $('#returnContainer .returnRow:eq(' + index + ')').find('.txtMessage').val(value.Remarks);

                    });
                    $(".AddReturn").hide();
                    $("#returnContainer").show();
                }
                else {
                    $(".AddReturn").show();
                }
            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                $('.txtTotal').val('');
                $('.txtIssuedBalance').val('');
                $('.dd_AssignedBy').val('');
                $('.txtReturnedBalance').val('');
                $('.dd_IssuedBy').val('');
                $('.txtIssuedAmount').val('');
                $('.txtFor').val('');
                $('.dd_ReturnedBy').val('');
                $('.txtReturnedAmount').val('');
                $('.txtMessage').val('');
                $(".AddIssue").show();
                $("#IssueContainer").hide();
                $(".AddReturn").show();
                $("#returnContainer").hide();


            },
        };
        eventFunction.init();
    };
    $.fn.DailyChalanEDIT = function (p) {
        $.chalanSetting(p);
    };
})(jQuery);
