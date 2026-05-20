var viewtype = "";
(function ($) {
    var tabs = $("#tabs").tabs();
     $('#tabs').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/RoOrderItemProcessing/webService/',
                 costcenter: '',
                 costcenterRefreshInterval:'',
             }, p);
        var ItemList = [];
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ItemProcessingService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                eventFunction.GetItemsProcessing();
                
            },
            init: function () {
                eventFunction.InitialSetup();
                setInterval(function () { eventFunction.GetItemsProcessing() },2000);

                $("#listviewcc").on('click', function () {
                    viewtype = "listview";
                    eventFunction.BindItem();
                });

                $("#gridviewcc").on('click', function () {
                    viewtype = "gridview";
                    eventFunction.BindItem();
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
                        ItemList = data.d;
                        eventFunction.BindItem();                      
                        break;
                    //case 1:
                    //    eventFunction.GetItemsProcessing();
                    //    break;
                    case 2:
                        eventFunction.GetItemsProcessing();
                        break;
                
                    //case 3:
                    //    eventFunction.BindWaiterCallLog(data);
                    //    break;

                    //case 4:
                    //    eventFunction.BindBookedRoomDetailByRoomID(data);
                    //    break;
                    case 5:
                        location.reload();
                        break;
                }
            },
            ajaxFailure: function () {
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
           
            GetItemsProcessing: function () {
                console.log(p.costcenter);
                eventFunction.config.method = "GetOrderItemsProcessingList";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ costcenter: p.costcenter });
                eventFunction.config.ajaxCallMode = 0;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //GetWaiterLog: function () {
            //    eventFunction.config.method = "GetWaiterLog";
            //    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            //    eventFunction.config.data = eventFunction.data;
            //    eventFunction.config.ajaxCallMode = 3;
            //    eventFunction.ajaxCall(eventFunction.config);
            //},

            //callWaiter: function (waiterIp) {
            //    eventFunction.config.method = "callWaiter";
            //    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
            //    eventFunction.config.data = JSON2.stringify({
            //        WaiterIp: waiterIp
            //    });
            //    eventFunction.config.ajaxCallMode = 4;
            //    eventFunction.ajaxCall(eventFunction.config);
            //},
          

            //<<-----------------------------------BindTable Herere ------------------------------------->>>

            //BindWaiterCallLog: function (result) {
            //    $('#callwaiterDiv').html("");
            //    var datas = result.d;
            //    var htmls = "";
            //    if (datas.length > 0) {
            //        htmls = "<ul>";
            //        $.each(datas, function (index, value) {
            //            htmls += ("<li><span id='waiter_" + value.WaiterIP + "' class='waiters'>" + value.WaiterName + "<span></li>");
            //        });
            //        htmls += "</ul>";
            //    } else {
            //        htmls = "No Waiters Online";
            //    }
            //    $('#callwaiterDiv').html(htmls);
            //    $('#callwaiterDiv').on('click', '.waiters', function () {
            //        var datas = $(this).attr('id');
            //        var dataarray = datas.split('_');
            //        var waiter = dataarray[1]
            //        //var Ipurl = dataarray[1].WaiterIP + "/?Department=WaiterCall&ItemName=BY&TableName=Web";
            //        eventFunction.callWaiter(waiter);
            //    });
            //},

            BindItem: function () {
                var queued = ItemList.OrderedItems;
                var inprogress = ItemList.InProgressItems;
                var completed = ItemList.CompletedItems;
                var cancelled = ItemList.CancelledItems;
                var complementary = ItemList.ComplementaryItems;

                if (viewtype == "gridview") {
                    eventFunction.BindListOrders(queued, "ordered");
                    eventFunction.BindListOrders(inprogress, "inprogress");
                    eventFunction.BindListOrders(completed, "completed");
                    eventFunction.BindListOrders(cancelled, "cancelled");
                    eventFunction.BindListOrderItem(complementary, "complementary");
                   
                }
                else {
                    eventFunction.BindOrders(queued, "ordered");
                    eventFunction.BindOrders(inprogress, "inprogress");
                    eventFunction.BindOrders(completed, "completed");
                    eventFunction.BindOrders(cancelled, "cancelled");
                    eventFunction.BindOrderItem(complementary, "complementary");
                }
            },

            BindOrders: function (data, datafor) {
                if (data.length > 0) {
                    $(".hide").show();
                    var htmls = "";
                    $("#" + datafor + "List").html(htmls);
                   
                    $.each(data, function (index, value) {
                        htmls += "<tr>";
                        if (value.ImagePath != "") {

                        htmls += "<td style='width:70px;'><img style='width:100%;' src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' /> </td>";
                        } else {
                            htmls += "<td style='width:70px;'><img style='width:100%;' src='/Modules/ROCompanyInfo/logo/logo.png' /> </td>";
                            
                        }
                        htmls += "<td style='font-weight:bold;'>" + value.ITName + "</br>" + value.Note + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.billtime + "</td>";
                        htmls += "<td>" + value.restroRoom + "/" + value.restrotableTitle + " (Bill No : " + value.SeatNo + ")</td>";
                        if (datafor == "ordered") {
                            htmls += "<td><input type='button' value='In Progress' class='sfBtn restro-btn btnInProgress' id='Inp_" + value.OrderDetailsID + "' style='padding:1px 4px; margin-left:10px;'/>";
                            htmls += "<input type='button' value='Complete' class='sfBtn restro-btn btnComplete' id='Comp_" + value.OrderDetailsID + "' style='padding:1px 4px; margin-left:10px;'/></td>";
                        }
                        if (datafor == "inprogress") {
                            htmls += "<td><input type='button' value='Complete' class='sfBtn restro-btn btnComplete' id='Comp_" + value.OrderDetailsID + "' style='padding:1px 4px; margin-left:10px;'/></td>";
                        }
                        htmls += "</tr>";

                    });

                    $("#" + datafor + "List").html(htmls);
                } else {
                    var htmls = "<img src='images/Noorder-Running.png' class='nooR' alt='No order Running' />";
                    $("#" + datafor + "List").html(htmls);
                }
                $('div.dataTables_filter input , .dataTables_length select').addClass('sfInputbox');

                $('.btnInProgress').unbind('click').on('click', function () {
                    
                    var orderDetailId = $(this).attr('id').split('_')[1];
                    var status = 2;
                    eventFunction.config.method = "ChangeOrderStatus";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ orderDetailId: orderDetailId, StatusID: status });
                    eventFunction.config.ajaxCallMode = 2;
                    eventFunction.ajaxCall(eventFunction.config);
                });

                $('.btnComplete').unbind('click').on('click', function () {
                    
                    var orderDetailId = $(this).attr('id').split('_')[1];
                    var status = 3;
                    eventFunction.config.method = "ChangeOrderStatus";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ orderDetailId: orderDetailId, StatusID: status });
                    eventFunction.config.ajaxCallMode = 2;
                    eventFunction.ajaxCall(eventFunction.config);
                  
                });
            },

            BindOrderItem: function (data, datafor) {
                if (data.length > 0) {
                    var htmls = "";
                    $("#" + datafor + "List").html(htmls);
                    $.each(data, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td style='width:70px;'><img style='width:100%;' src='/Modules/ROI_Item/ImageItem/" + value.ImagePath + "' /> </td>";
                        htmls += "<td style='font-weight:bold;'>" + value.ITName + "</br>" + value.Note + "</td>";
                        htmls += "<td>" + value.Quantity + "</td>";
                        htmls += "<td>" + value.billtime + "</td>";
                        htmls += "<td>" + value.restroRoom + "/" + value.restrotableTitle + "</td>";                 
                        htmls += "<td><input type='button' value='Complete' class='sfBtn restro-btn btnComComplete' id='Compl_" + value.CompId + "' style='padding:1px 4px; margin-left:10px;'/></td>";
                        htmls += "</tr>";

                    });
                    $("#" + datafor + "List").html(htmls);
                } else {
                    var htmls = "<img src='images/Noorder-Running.png' class='nooR' alt='No order Running' />";
                    $("#" + datafor + "List").html(htmls);
                }

                $('.btnComComplete').unbind('click').on('click', function () {              
                    var CompId = $(this).attr('id').split('_')[1];
                    var status = 3;
                    eventFunction.config.method = "ChangeCompOrderStatus";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ CompId: CompId, StatusID: status });
                    eventFunction.config.ajaxCallMode = 5;
                    eventFunction.ajaxCall(eventFunction.config);

                });
            },
            BindListItem: function () {
                var queued = ItemList.OrderedItems;
                var inprogress = ItemList.InProgressItems;
                var completed = ItemList.CompletedItems;
                var cancelled = ItemList.CancelledItems;
                var complementary = ItemList.ComplementaryItems;

              
            },

            BindListOrders: function (data, datafor) {
                if (data.length > 0) {
                    $(".hide").hide();               
                    $("#" + datafor + "List").html('');
                    var htmls = "";
                    var totalPerType = {};
                    for (var i = 0, len = data.length; i < len; ++i) {
                        totalPerType[data[i].ITName] = totalPerType[data[i].ITName] || 0;
                        totalPerType[data[i].ITName] += data[i].Quantity;
                    }
                    var result = $.map(totalPerType, function (ITName, Quantity) {
                        return { 'ITName': ITName, 'Quantity': Quantity };
                    });
          
                    htmls += "<div class='TablesInRooms Tables'>";
                    htmls += "<ul>";
                    $.each(result, function (index, value) {                       
                        htmls += "<li>"
                             
                        htmls += ("<img class='imgForTable' style='height: 60px;' src='/Modules/ROCompanyInfo/logo/" + companyInfo.Logo + "'>");                     
                        htmls += ("<h5 class='ellipsis_gird'>" + value.Quantity + "</h5>");
                        htmls += ("<h5 class='ellipsis_gird' style='border:none;padding-top:0px;'>   Qty : " + value.ITName + "</h5>");
                        htmls += ("</li>");
                      
                    });
                    htmls += "</ul>";
                    htmls += "</div>";
                    $("#" + datafor + "List").html(htmls);
                } else {
                    var htmls = "<img src='images/Noorder-Running.png' class='nooR' alt='No order Running' />";
                    $("#" + datafor + "List").html(htmls);
                }
                $('div.dataTables_filter input , .dataTables_length select').addClass('sfInputbox');
            },

            BindListOrderItem: function (data, datafor) {
                if (data.length > 0) {
                    var htmls = "";
                    $("#" + datafor + "List").html(htmls);
                    var htmls = "";
                    var totalPerType = {};
                    for (var i = 0, len = data.length; i < len; ++i) {
                        totalPerType[data[i].ITName] = totalPerType[data[i].ITName] || 0;
                        totalPerType[data[i].ITName] += data[i].Quantity;
                    }
                    var result = $.map(totalPerType, function (ITName, Quantity) {
                        return { 'ITName': ITName, 'Quantity': Quantity };
                    });
                  
                    htmls += "<div class='TablesInRooms Tables'>";
                    htmls += "<ul>";
                    $.each(result, function (index, value) {
                        htmls += "<li>"
                        htmls += ("<label class = '' >");
                        htmls += ("<img class='imgForTable' style='height: 65px; display: block;' src='/Modules/ROCompanyInfo/logo/" + companyInfo.Logo + "'></label> ");
                        htmls += ("<h5>" + value.Quantity + "</h5>");
                        htmls += ("<h5>  Quantity : " + value.ITName + "</h5>");
                        htmls += ("</li>");

                    });
                    htmls += "</ul>";
                    htmls += "</div>";
                    $("#" + datafor + "List").html(htmls);
                } else {
                    var htmls = "<img src='images/Noorder-Running.png' class='nooR' alt='No order Running' />";
                    $("#" + datafor + "List").html(htmls);
                }

                $('.btnComComplete').unbind('click').on('click', function () {
                    var CompId = $(this).attr('id');
                    var status = 3;
                    eventFunction.config.method = "ChangeCompOrderStatus";
                    eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                    eventFunction.config.data = JSON2.stringify({ CompId: CompId, StatusID: status });
                    eventFunction.config.ajaxCallMode = 5;
                    eventFunction.ajaxCall(eventFunction.config);

                });
            },
     
        };
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
