
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
                 Username: '',
                 ModulePath: '/Modules/RecquistionSlip/'
             }, p);
        var selectedIndex = 0;
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
               // eventFunction.getVender();
            },

            init: function () {
                eventFunction.InitialSetup();

                $('#btnSaveRecquistion').on('click', function () {
                    var value = $('.Venderlist').filter(function () {
                        return $(this).val() == null;
                    });

                    if (value.length > 0) {
                        jAlert("Please! Select Vendor", 'Alert!!', function () { $.alerts.dialogClass = null; });
                    }
                    else {
                        eventFunction.SaveRecquistion();
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
                        eventFunction.BindRecquistions(data.d);
                        break;
                    case 1:
                        eventFunction.ResetAll();
                        break;
                    case 2:
                        eventFunction.bindVendorBox(data); 
                        break;
                    case 3:
                        jAlert('Request Send Successfully.', 'Information!');
                        $('#RecquistionDetails').dialog('close');
                        eventFunction.GetRecquistions();
                        break;
                }
            },
            ajaxFailure: function () {
            },

            GetRecquistions: function () {
                eventFunction.config.method = "GetRecquistions";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ isMainStore: true });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            getVender: function () {
                eventFunction.config.method = "getVender";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 2;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>

            bindVendorBox: function (result) {
                var datas = result.d;
                var htmls = "";
                $(".Venderlist").html('');
                if (datas.length > 0) {
                    htmls = "<option value='' disabled selected>-Select Vendor-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.MembershipID + "'>" + value.Fname + "</option>";
                    });
                }
                $(".Venderlist").html(htmls);
            },

     
            BindRecquistions: function (result) {
                $('#Requested-list').html('');
                $('#Inprogress-list').html('');
                $('#Completed-list').html('');
                
                var recquistionList = JSON.parse(result);
                
                    $.each(recquistionList, function (index, item) {
                        var htmls = '';
                        htmls += '<tr id="' + item.RecqId + '">';
                        htmls += '<td>' + item.RecqNo + '</td>';
                        htmls += '<td>' + item.StoreName + '</td>';
                        htmls += '<td>' + item.RequestedBy + '</td>';
                        htmls += '<td>' + item.RequestedOn + '</td>';
                        htmls += '<td class="tdcenter">';
                        htmls += "<img src='/images/view.png' class='recquistionView preview-icon' type='button'  id='" + item.RecqId + "+" + item.RecqNo + "+" + item.Status + "' value='View'  />";
                        htmls += '</td>';
                        htmls += '</tr>';

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
                        var id = $(this).attr('id');
                        var data = id.split('+')
                        var reqId = data[0];
                        var reqNo = data[1];
                        var status = data[2];
                    
                        $.each(recquistionList, function (index, item) {
                            var htmls = '';
                            if (item.RecqId == reqId) {
                                $.each(item.requestedItems, function (index, value) {
                                    htmls += '<tr>';
                                    htmls += '<td>' + value.ItemName + '</td>';
                                    htmls += '<td>' + value.Quantity + '</td>';
                                    htmls += '<td>' + value.IssueQuantity + '</td>';
                                    htmls += '<td>' + value.Symbol + '</td>';
                                    if (item.Status == 'Requested') {
                                        htmls += '<td><select name="Venderlist" class="Venderlist sfInputbox" style="width: 150px;"></select></td>';
                                        
                                    }
                                    else {
                                        htmls += '<td>' + value.vendorName + '</td>';
                                    }
                                    htmls += '<td class="RecqId" style="display:none;">' + value.RecqId + '</td>';
                                    htmls += '<td class="RecqDetailId" style="display:none;">' + value.RecqDetailId + '</td>';
                                    htmls += '</tr>';
                                });
                                if (item.Status == 'InProgress' || item.Status == 'Delivered') {
                                    $('#btnSaveRecquistion').hide();
                                }
                                else {
                                    $('#btnSaveRecquistion').show();
                                }
                            }
                            
                            $('#item-list').append(htmls);
                           
                           // reqNo = item.RecqNo;
                          
                        });

                        if (status == 'Requested') {
                            eventFunction.getVender();
                        }
                        
                    $('#RecquistionDetails').dialog({
                        'title': reqNo + ' : Details',
                        'width': '600px',
                         'dialogClass' : 'popup-titlebg',
                    });

                 

                    });
            },

            SaveRecquistion: function () {
                var recquistionDetails = new Array();
                $.each($('#item-list>tr'), function (index, row) {
                        var obj = new Object();
                        obj.RecqId = $(row).find('.RecqId').text();
                        obj.RecqDetailId = $(row).find('.RecqDetailId').text();
                        obj.VendorId = $(row).find('.Venderlist').val();
                        obj.AddedBy = SageFrameUserName;
                        recquistionDetails.push(obj);
                    });
               
                recquistion = recquistionDetails;
                jConfirm('Do you want to send request?', 'Confirm!', function (confirm) {
                    if (confirm) {
                        eventFunction.config.method = "SaveVendorForRecq";
                        eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                        eventFunction.config.data = JSON2.stringify({ recquistion: recquistion });
                        eventFunction.config.ajaxCallMode = 3;
                        eventFunction.ajaxCall(eventFunction.config);
                    }
                });
            },
          
            ResetAll: function () {
                eventFunction.GetRecquistions();
                $('.ui-dialog-content').dialog('close');
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        Venderlist: {
                            required: true,
                        },


                    },
                    messages: {
                        textUnit: {
                            number: '*'
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
