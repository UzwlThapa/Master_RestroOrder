
function validateFloatKeyPress(el, evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode;
    var number = el.value.split('.');
    if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    //just one dot (thanks ddlab)
    if (number.length > 1 && charCode == 46) {
        return false;
    }
    //get the carat position
    var caratPos = getSelectionStart(el);
    var dotPos = el.value.indexOf(".");
    if (caratPos > dotPos && dotPos > -1 && (number[1].length > 1)) {
        return false;
    }
    return true;
}

function getSelectionStart(o) {
    if (o.createTextRange) {
        var r = document.selection.createRange().duplicate()
        r.moveEnd('character', o.value.length)
        if (r.text == '') return o.value.length
        return o.value.lastIndexOf(r.text)
    } else return o.selectionStart
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RecquistionSlip/'
             }, p);
        var storeList = new Array();
        var LargeUnit = new Object();
        var parentId = 0;
        var items = [];
        var recquistionList = [];
        var ReqNo = 0;
        var Large = new Array();
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "RecquistionService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                ReqId: 0,
                ReqUpdate: 0
            },
            InitialSetup: function () {
                eventFunction.GetStore();
                eventFunction.GetItem();
                eventFunction.GetRecquistions();
                eventFunction.GetRecquistionsAll();
               
            },

            init: function () {
                eventFunction.InitialSetup();

                $('#btnView').on('click', function () {
                    $( "#tabs" ).tabs({ active: 0 });
                    if ($('#ddlStore').val() != null && $('#ddlStore').val() != '') {
                        parentId = $('#ddlStore option:selected').attr('attr-parent');
                        $('#btnAddItem').show();
                        $('#tabs').show();
                        eventFunction.GetOutOfStockItemsByStoreId();
                        eventFunction.BindRecquistions();
                    } else {
                        jAlert('Please Select The Store.', 'Alert!', function () { });
                    }
                });
                $("#txtItemName").autocomplete({
                    source: items,
                    delay: 0,
                    select: function (event, ui) {
                        var ids = ui.item.id;
                        $("#hdfItemId").val(ids);
                        eventFunction.config.method = "GetUnitOfItemByID";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ ids: ids });
                        eventFunction.config.ajaxCallMode = 5;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });
                //$('#tblRecquistionSlip').on('click', '.deleteItem', function () {
                //    row = this;
                //    jConfirm('Are you sure you want to remove this item ?', 'Confirmation!', function (confirm) {
                //        if (confirm) {
                //            $(row).closest('tr').remove();
                //        }
                //    });
                //});
                $('#tblItems').on('click', '.deleteItem', function () {
                    row = this;
                    jConfirm('Are you sure you want to remove this item ?', 'Confirmation!', function (confirm) {
                        if (confirm) {
                            $(row).closest('tr').remove();
                        }
                    });
                });

                $('#btnAddItem,#btnAddItemForUpdate').on('click', function () {
                    if ($(this).attr('id') == 'btnAddItem') {
                        $('#btnAdd').show();
                        $('#btnAddForEdit').hide();
                    } else {
                        $('#btnAdd').hide();
                        $('#btnAddForEdit').show();
                    }
                    $('#divAddForm').dialog({
                        'title': 'Add Recquistion Items',
                        'width': '300px',
                        'dialogClass' : 'popup-titlebg',
                    });
                });
                $('#btnCancel').on('click', function () {
                    $('#RecquistionEdit').dialog('close');
                });
                $('#btnAdd,#btnAddForEdit').unbind('click').on('click', function () {
                    if ($('#hdfItemId').val() == "" || $('#hdfItemId').val() == null) {
                        jAlert('Please Enter The Item.', 'Alert!');
                    } else if ($('#txtQnty').val() == "" || $('#txtQnty').val() == null) {
                        jAlert('Please Enter The Quantity.', 'Alert!');
                    } else if ($('#ddlItemUnit').val() == "" || $('#ddlItemUnit').val() == null) {
                        jAlert('Please Select The Unit.', 'Alert!');
                    } else {
                        eventFunction.AddItem(this);
                         $('#tblRecquistionSlip .trhide td').hide();
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
                        eventFunction.BindStore(data.d);
                        break;
                    case 1:
                        eventFunction.BindOutOfStockItems(data.d);
                        break;
                    case 2:          
                        Large = [];
                        $(JSON.parse(data.d)).each(function (index, result) {
                            Large.push(result);
                        })
                        break;
                    case 3:
                        if (eventFunction.config.ReqUpdate == 0)
                        {
                            jAlert('Request Successfully Sent. Your Request No is : ' + data.d, 'Information!');
                            eventFunction.ResetAll();
                        }
                                                
                    else {
                            jAlert('Request No: ' + ReqNo + ' Successfully Updated', 'Information!');
                            eventFunction.ResetAll();
                            }
                        break;
                    case 4:
                        if (data.d.length > 0) {
                            $.each(data.d, function (index, value) {
                                items.push({ label: value.ITName, id: value.ITId });
                            });
                        }
                        break;
                    case 5:
                        eventFunction.BindDropdwonUnit(data);
                        break;
                    case 6:
                        $(JSON.parse(data.d)).each(function (index, result) {
                            recquistionList.push(result);
                        })
                        break;
                    case 7:
                        jAlert('Request Successfully Deleted.', 'Information!');
                        eventFunction.GetRecquistions();
                        eventFunction.GetRecquistionsAll();
                        eventFunction.BindRecquistions();
                        break;
                }
            },
            ajaxFailure: function () {
            },


            GetStore: function () {
                eventFunction.config.method = "GetStoreList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetOutOfStockItemsByStoreId: function () {              
                var storeId = $('#ddlStore').val();
   
                eventFunction.config.method = "GetOutOfStockItemsByStoreId";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ storeId: storeId });
                eventFunction.config.ajaxCallMode = 1;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetUNITbySmallUnit: function (smallUnit) {

                eventFunction.config.method = "GetUNITbySmallUnit";
                eventFunction.config.url = '/Modules/ROI_Item/RoiItem.asmx/' + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ unit: smallUnit });
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },
            SendRecquistion: function () {
                var recquistion = new Object();
                recquistion.RecqId = eventFunction.config.ReqId;
                recquistion.StoreId = $('#ddlStore').val();
                recquistion.ParentStore = $('#ddlStore option:selected').attr('attr-parent');
                recquistion.RequestedBy = SageFrameUserName;


                var recquistionDetails = new Array();
                if (eventFunction.config.ReqUpdate == 0) {
                    $.each($('#tblRecquistionSlip>tbody>tr.trShow'), function (index, row) {
                        var obj = new Object();
                        obj.ItemId = $(row).attr('id');
                        obj.Quantity = $(row).find('.orderQnty').val();
                        obj.Unit = $(row).find('.orderUnit').val();
                        recquistionDetails.push(obj)
                    });
                } else {
                    $.each($('#tblItems>tbody>tr'), function (index, row) {
                        var obj = new Object();
                        obj.ItemId = $(row).attr('id').split('_')[0];
                        obj.Quantity = $(row).find('.orderEditQnty').val();
                        obj.Unit = $(row).attr('id').split('_')[1];              
                        recquistionDetails.push(obj)
                    });
                }
                
                recquistion.requestedItems = recquistionDetails;
                
                jConfirm('Do you want to send request?', 'Confirm!', function (confirm) {                   
                    if (confirm) {
                        eventFunction.config.method = "SendRecquistion";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ recquistion: recquistion });
                        eventFunction.config.ajaxCallMode = 3;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });
            },
            GetItem: function () {
                eventFunction.config.method = "getitemfromdatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 4;
                eventFunction.ajaxCall(eventFunction.config);
            },
            GetRecquistions: function () {
                recquistionList = [];
                var isMainStore = false;
                eventFunction.config.method = "GetRecquistions";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ isMainStore: isMainStore });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetRecquistionsAll: function () {
                var isMainStore = true;
                eventFunction.config.method = "GetRecquistions";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ isMainStore: isMainStore });
                eventFunction.config.ajaxCallMode = 6;
                eventFunction.ajaxCall(eventFunction.config);
            },
            //<<-----------------------------------BindTable Herere ------------------------------------->>


            BindStore: function (result) {
                storeList = JSON.parse(result);
                var htmls = '';
                htmls += '<option selected disabled>-- Select --</option>';
                $.each(storeList, function (index, item) {
                    htmls += '<option value="' + item.STId + '" attr-parent="' + item.PSTId + '">' + item.StName + '</option>';
                });
                $('#ddlStore').html(htmls);
            },

            BindOutOfStockItems: function (result) {
               
                var stockList = JSON.parse(result);
                var htmls = '';
                $('#outOfStockList').html(htmls);
                htmls += '<table id="tblRecquistionSlip"><thead><tr>';
                htmls += '<th>S.N.</th>';
                htmls += '<th>Item</th>';
                htmls += '<th>Min. Stock</th>';
                htmls += '<th>Remaining Stock</th>';
                htmls += '<th>Symbol</th>';
                htmls += '<th>Request Quantity</th>'
                htmls += '<th>Unit</th>'
                htmls += '<th class="tdcenter">Delete</th>'
                htmls += '</tr></thead><tbody>';
                if (stockList.length > 0) {
                $.each(stockList, function (index, item) {
                    eventFunction.GetUNITbySmallUnit(item.ITUnit)
                    htmls += '<tr class="trShow" id="' + item.ITId + '">';
                    htmls += '<td>' + (index + 1) + '</td>';
                    htmls += '<td>' + item.ITName + '</td>';
                    htmls += '<td>' + item.MinStock + '</td>';
                    htmls += '<td>' + item.CLBal + '</td>';
                    htmls += '<td>' + item.Symbol + '</td>';
                    htmls += '<td><input type="textbox" onkeypress="return validateFloatKeyPress(this,event)" class="orderQnty sfInputbox" style="width:100px;"/></td>';
                    htmls += '<td><select class="orderUnit sfInputbox" style="width:100px;">';
                    htmls += '<option value="' + item.ITUnit + '">' + item.Symbol + '</option>';
                    if (Large.length > 0) {

                        $.each(Large, function (index, LargeUnit) {
                            htmls += '<option value="' + LargeUnit.UnitId + '">' + LargeUnit.Particulars + '</option>';
                        });
                    }
                    htmls += '</select></td>';
                    htmls += '<td class="tdcenter"><img src="/images/delete.png" class="deleteItem edit-icon tdcenter" type="button" value="Delete"></td>';
                    htmls += '</tr>';
                });
            }

            else {
                    htmls += "<tr class='trhide'>";
                    htmls += "<td colspan='8' style='text-align:center;'> Click Add Items to Insert data!!</td>";
                    htmls += '</tr>';
                }
                htmls += '</tbody></table>';
                
                htmls += '<input type="button" id="btnSendRequest" value="Send Request" class="sfBtn restro-btn" style="margin:10px;"/>';
                $('#outOfStockList').html(htmls);

                $('#btnSendRequest').unbind('click').on('click', function () {
                    var emptyQntyBox = $(".orderQnty").filter(function () {
                        return $.trim($(this).val()) == '';
                    }).length;
                    if (emptyQntyBox > 0) {
                        jAlert('Empty Order Quantity.', 'Alert!', function () { });
                    } else {
                        eventFunction.config.ReqId = 0;
                        eventFunction.config.ReqUpdate = 0;
                        eventFunction.SendRecquistion();
                    }
                });

                $('#tblRecquistionSlip').on('click', '.deleteItem', function () {
                    row = this;
                    jConfirm('Are you sure you want to remove this item ?', 'Confirmation!', function (confirm) {
                        if (confirm) {
                            $(row).closest('tr').remove();
                        }
                    });
                });
            },
            BindDropdwonUnit: function (result) {
                if (!result.d) return;
                var datas = result.d;
                var htmls = "";
                $("#ddlItemUnit").html('');
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.UnitID + "' attr-conversion='" + value.Conversion + "'>" + value.Symbol + "</option>";
                    });
                }
                $("#ddlItemUnit").html(htmls);
            },
            AddItem: function (button) {
                rowIndex = 1;
                var itemAdded = 0;
                $.each($('#tblRecquistionSlip>tbody>tr'), function (index, row) {
                    if ($(row).attr('id') == $('#hdfItemId').val()) {
                        itemAdded = 1;
                        rowIndex = (parseInt($(row).find('td:eq(0)').text()) + 1);
                        return false;
                    }
                });
                if (itemAdded == 1) {
                    jAlert('Item has already been added in the slip', 'Alert!', function () { });
                } else {
                    var htmls = "";
                    if ($(button).attr('id') == 'btnAdd') {
                        htmls += '<tr class="trShow" id="' + $('#hdfItemId').val() + '">';
                        htmls += '<td>' + rowIndex + '</td>';
                        htmls += '<td>' + $('#txtItemName').val() + '</td>';
                        htmls += '<td>-</td>';
                        htmls += '<td>-</td>';
                        htmls += '<td>-</td>';
                        htmls += '<td><input type="textbox" onkeypress="return validateFloatKeyPress(this,event)" class="orderQnty sfInputbox" value="' + $('#txtQnty').val() + '" /></td>';
                        htmls += '<td><select class="orderUnit sfInputbox" >' + $('#ddlItemUnit').html() + '</select></td>';
                        htmls += '<td class="tdcenter"><img src="/images/delete.png" class="deleteItem edit-icon" type="button" value="Delete"></td>';
                        htmls += '</tr>';
                        $('#tblRecquistionSlip>tbody').append(htmls);

                        $('#tblRecquistionSlip>tbody>tr:last').find('.orderUnit').val($('#ddlItemUnit').val())
                    } else {
                        htmls += '<tr class="trShow" id="' + $('#hdfItemId').val() + '_' + $('#ddlItemUnit').val() + '">';
                        htmls += '<td>' + $('#txtItemName').val() + '</td>';
                        htmls += '<td><input type="textbox" onkeypress="return validateFloatKeyPress(this,event)" class="sfInputbox orderEditQnty" value="' + $('#txtQnty').val() + '" style="width:100px;"/></td>';
                        htmls += '<td>' + $('#ddlItemUnit option:selected').text() + '</td>';
                        htmls += '<td><img src="/images/delete.png" class="deleteItem edit-icon" type="button" value="Delete"></td>';
                        htmls += '</tr>';
                        $('#tblItems>tbody').append(htmls);
                    }
                }
                $('#hdfItemId').val('');
                $('#txtItemName').val('');
                $('#txtQnty').val('');
                $('#ddlItemUnit').html('');

                $('#btnAdd').bind('click');
                
                $('#btnAddForEdit').bind('click');
            },
            BindRecquistions: function () {
                $('#RecquistionsSent').show();
                $('#Requested-list').html('');
                $.each(recquistionList, function (index, item) {
                   
                    if (item.Status == 'Requested' && item.StoreId ==  $('#ddlStore').val()) {
                        var htmls = '';
                        htmls += '<tr id="' + item.RecqId + '">';
                        htmls += '<td>' + item.RecqNo + '</td>';
                        htmls += '<td>';
                        $.each(item.requestedItems, function (index, value) {
                            htmls += '' + value.ItemName + ' (' + value.Quantity + ' ' + value.Symbol + ')<br >';
                        });
                        htmls += '</td>';
                        htmls += '<td>' + item.StoreName + '</td>';
                        htmls += '<td>' + item.RequestedBy + '</td>';
                        htmls += '<td>' + item.RequestedOn + '</td>';
                        htmls += '<td>';
                        htmls += "<img src='/images/edit.png' class='recquistionEdit edit-icon' type='button'  id='" + item.RecqId + "' value='Edit'  />";
                        htmls += " | <img src='/images/delete.png' class='recquistionDelete delete-icon' type='button'  id='" + item.RecqId + "' value='Delete'  />";
                        htmls += '</td>';
                        htmls += '</tr>';

                        $('#Requested-list').append(htmls);
                    } 

                });
                $('.recquistionDelete').on('click', function () {
                    var recq = new Object();
                    recq.RecqId = $(this).attr('id');
                    recq.RequestedBy = SageFrameUserName;

                    jConfirm('Do You want to delete this Recquistion ?', 'Confrimation!!', function (confirm) {
                        if (confirm) {
                            eventFunction.config.method = "DeleteRecquistion";
                            eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                            eventFunction.config.data = JSON2.stringify({ recquistion: recq });
                            eventFunction.config.ajaxCallMode = 7;
                            eventFunction.ajaxCall(eventFunction.config);
                        }
                    })
                });
                $('.recquistionEdit').on('click', function () {
                    $('#tblItems>tbody').html('');
                    var reqId = $(this).attr('id');
                    var reqNo = '';
                    $.each(recquistionList, function (index, item) {
                        var htmls = '';
                        if (item.RecqId == reqId) {
                            $.each(item.requestedItems, function (index, value) {
                                htmls += '<tr id="' + value.ItemId + '_' + value.Unit + '">';
                                htmls += '<td>' + value.ItemName + '</td>';
                                htmls += '<td><input type="textbox" onkeypress="return validateFloatKeyPress(this,event)" class="sfInputbox orderEditQnty" value="' + value.Quantity + '" style="width:100px;"/></td>';
                                htmls += '<td>' + value.Symbol + '</td>';
                                htmls += '<td><img src="/images/delete.png" class="deleteItem edit-icon" type="button" value="Delete"></td>';
                                htmls += '</tr>';
                            });
                            $('#tblItems>tbody').append(htmls);

                            reqNo = item.RecqNo;
                            return false;
                        }
                    });

                    $('#RecquistionEdit').dialog({
                        'title': reqNo + ' : Edit',
                        'width': '400px',
                         'dialogClass' : 'popup-titlebg',
                    });
                    $('#btnUpdateRecquistion').unbind('click').on('click', function () {
                        var emptyQntyBox = $(".orderEditQnty").filter(function () {
                            return $.trim($(this).val()) == '';
                        }).length;
                        if (emptyQntyBox > 0) {
                            jAlert('Empty Order Quantity.', 'Alert!', function () { });
                        } else {
                            ReqNo = reqNo;
                            eventFunction.config.ReqId = reqId;
                            eventFunction.config.ReqUpdate = 1;
                            eventFunction.SendRecquistion();
                        }
                    });
                });
            },
            ResetAll: function () {
                eventFunction.config.ReqId = 0;
                eventFunction.config.ReqUpdate = 0;
                eventFunction.GetRecquistions();
                eventFunction.GetRecquistionsAll();           
                eventFunction.BindRecquistions();
                $("#tblRecquistionSlip tbody tr").remove();
                $('#hdfItemId').val('');
                $('#txtItemName').val('');
                $('#txtQnty').val('');
                $('#ddlItemUnit').html('');
                $('#RecquistionEdit').dialog('close');
                $('#divAddForm').hide();
                $('#RecquistionEdit').hide();
                $('#RecquistionsSent').hide();
                $('#btnAddItem').hide();
                $('#outOfStockList').html('');
                $('#tabs').hide();
             
            },


        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
