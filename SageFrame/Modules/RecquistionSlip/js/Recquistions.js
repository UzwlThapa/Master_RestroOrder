
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
    $('#tabs').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RecquistionSlip/'
             }, p);

        var reqlist = [];
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
            },
            InitialSetup: function () {
                eventFunction.GetRecquistions();
                eventFunction.GetAllUsers();
            },

            init: function () {
                eventFunction.InitialSetup();

                $("#ddlRecievedBy").val(SageFrameUserName);

                $('#txtSearch').on('keyup', function () {
                    eventFunction.BindRecquistions();
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
                        reqlist = JSON.parse(data.d);
                        eventFunction.BindRecquistions();
                        break;
                    case 1:
                        eventFunction.ResetAll();
                        break;
                    case 2:
                        eventFunction.BindUsers(data);
                        break;
                   
                        
                }
            },
            ajaxFailure: function () {
            },

            GetRecquistions: function () {
                eventFunction.config.method = "GetRecquistions";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ isMainStore: false });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetAllUsers: function () {
                eventFunction.config.method = "GetAllUsers";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>

        
            BindUsers: function (result) {
                var datas = result.d;
                var htmls = "";
                $("#ddlRecievedBy").html('');
                htmls = "<option value='' disabled selected>-Select-</option>";
                if (datas.UserList.length > 0) {
                    $.each(datas.UserList, function (index, value) {
                        htmls += "<option value='" + value.UserName + "'>" + value.UserName + "</option>";
                    });

                }
                $("#ddlRecievedBy").html(htmls);

            },


            BindRecquistions: function (result) {
                $('#Requested-list').html('');
                $('#Inprogress-list').html('');
                $('#Completed-list').html('');              
                var recquistionList = reqlist;
             
                $.each(recquistionList, function (index, item) {
                    var htmls = '';
                    var search = $('#txtSearch').val().toLowerCase();
                    if (item.RecqNo.toLowerCase().includes(search) || item.StoreName.toLowerCase().includes(search) || item.RequestedBy.toLowerCase().includes(search) || search == '') {
                        htmls += '<tr id="' + item.RecqId + '">';
                        htmls += '<td>' + item.RecqNo + '</td>';
                        htmls += '<td>' + item.StoreName + '</td>';
                        htmls += '<td>' + item.RequestedBy + '</td>';
                        htmls += '<td>' + item.RequestedOn + '</td>';
                        htmls += '<td class="tdcenter">';
                        htmls += "<img src='/images/view.png' class='recquistionView preview-icon' type='button' title='View' id='" + item.RecqId + "' value='View'  />";
                        if (item.Status == 'Requested' || item.Status == 'InProgress') {
                            htmls += (" | <img src='/images/issuee.png' class='recquistionIssue preview-icon' type='button' title='Issue' id='" + item.RecqId + "' value='Issue' />");
                        }
                        htmls += '</td>';
                        htmls += '</tr>';
                    }
                        if (item.Status == 'Requested') {
                            $('#Requested-list').append(htmls);
                        } else if (item.Status == 'InProgress') {
                            $('#Inprogress-list').append(htmls);
                        } else {
                            $('#Completed-list').append(htmls);
                        }
                    
                });
                $('.recquistionView').on('click', function () {
            
                    $('#item-list').html('');
                    var reqId = $(this).attr('id');
                    var reqNo = '';
                    
                    $.each(recquistionList, function (index, item) {
                        var htmls = '';
                        if (item.RecqId == reqId) {
                            $.each(item.requestedItems, function (index, value) {
                                htmls += '<tr>';
                                htmls += '<td>' + value.ItemName + '</td>';
                                htmls += '<td>' + value.Quantity + '</td>';
                                htmls += '<td>' + value.IssueQuantity + '</td>';
                                htmls += '<td>' + value.Symbol + '</td>';
                                htmls += '</tr>';                      
                            });
                            reqNo = item.RecqNo;
                        }
                            
                        $('#item-list').append(htmls);

                       
                    });
                   
                    $('#RecquistionDetails').dialog({
                        'title': reqNo + ' : Details',
                        'width': '600px',
                         'dialogClass' : 'popup-titlebg',
                    });


                });
                $('.recquistionIssue').on('click', function () {
                    
                    $('#Recieved').show();
                    $('#tblItemsIssue>tbody').html('');
                    var reqId = $(this).attr('id');
                    var reqNo = '';
                    var toStore = '';
                    var fromStore = '';
                    $.each(recquistionList, function (index, item) {
                        var htmls = '';
                        if (item.RecqId == reqId && item.ParentStore > 0) {
                            $.each(item.requestedItems, function (index, value) {
                                if (value.Quantity > value.IssueQuantity) {
                                    htmls += '<tr id="' + value.RecqDetailId + '">';
                                    htmls += '<td>' + value.ItemName + '</td>';
                                    htmls += '<td>' + value.Quantity + '</td>';
                                    htmls += '<td>' + value.IssueQuantity + '</td>';
                                    htmls += '<td>' + value.Symbol + '</td>';
                                    htmls += '<td><input type="textbox" Style="width: 80px;" onkeypress="return validateFloatKeyPress(this,event)" class="issueQnty sfInputbox" value="' + (value.Quantity - value.IssueQuantity) + '" /></td>';
                                    htmls += '</tr>';
                                }
                            });
                            $('#tblItemsIssue>tbody').append(htmls);

                            reqNo = item.RecqNo;
                            toStore = item.StoreName;
                            fromStore = item.ParentStoreName;
                            $('#RecquistionIssue').dialog({
                                'title': reqNo + ' : Issue From ' + fromStore + ' -> To ' + toStore,
                                'width': '600px',
                                 'dialogClass' : 'popup-titlebg',
                            });

                            return false;
                        }
                    });

                    $('#btnIssueRecquistion').on('click', function () {

                        if ($('#ddlRecievedBy').val() == null) {
                            jAlert('Please select Recieved By.', 'Alert!!', function () { $.alerts.dialogClass = null; });
                        }
                        else {
                            jConfirm('Are you sure you want to issue these items ?', 'Confirmation!', function (confirm) {
                                if (confirm) {
                                    
                                    var recquistion = new Object();
                                    recquistion.RecqId = reqId;

                                    var details = new Array();
                                    $.each($('#tblItemsIssue>tbody>tr'), function (index, item) {
                                        var detail = new Object();

                                        detail.RecqId = reqId;
                                        detail.RecqDetailId = $(item).attr('id');
                                        detail.IssueQuantity = $(item).find('.issueQnty').val();
                                        if (parseFloat(detail.IssueQuantity) > 0) {
                                            details.push(detail);
                                        }
                                    });
                                    recquistion.requestedItems = details;
                                    recquistion.RequestedBy = SageFrameUserName;
                                    recquistion.ReceivedBy = $('#ddlRecievedBy').val();
                                   
                                    eventFunction.config.method = "IssueRecquistions";
                                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                                    eventFunction.config.data = JSON2.stringify({ recquistion: recquistion });
                                    eventFunction.config.ajaxCallMode = 1;
                                    eventFunction.ajaxCall(eventFunction.config);
                                }
                            });
                        }
                    });
                });
            },

            ResetAll: function () {
                eventFunction.GetRecquistions();
                $('.ui-dialog-content').dialog('close');
                $('#ddlRecievedBy').val();
               
            },



        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
