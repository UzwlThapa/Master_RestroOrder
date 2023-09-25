function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.	  
        (charCode < 48 || charCode > 57))
        return false;
    return true;
}
(function ($) {
    var tabs = $("#tabs").tabs();
    $('#tabs').css('display', 'block');
    $.callWaitercreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/CallWaiter/',
                 HostUrl: '',
                 TypeId: '',
             }, p);
        var v = 0;
        var DashboardFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},// "{'emailAddress':'bob@bob.com', 'password':'Password1'}", 	                
                dataType: 'json', dataType: 'json',
                baseURL: "/Modules/RestroDashboard/services/DashBoardWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MenuId: 0,
                Menuupdate: 0,
                RoomId: 0,
                OrderId: 0,
                OrderUpdateId: 0,
                ShiftID: 0
            },
            InitialSetup: function () {
                
                      DashboardFunction.GetWaiterLog();            
            },

            init: function () {
             
                
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: DashboardFunction.config.type,
                    contentType: DashboardFunction.config.contentType,
                    async: DashboardFunction.config.async,
                    cache: DashboardFunction.config.cache,
                    url: DashboardFunction.config.url,
                    data: DashboardFunction.config.data,
                    dataType: DashboardFunction.config.dataType,
                    success: DashboardFunction.ajaxSuccess,
                    error: DashboardFunction.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(DashboardFunction.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        DashboardFunction.BindWaiterCallLog(data.d);
                        break;
                }
            },
            ajaxFailure: function () {
            },
            //<<-----------------------------Post & Get Here ---------------------------------------->>	
            GetWaiterLog: function () {
                DashboardFunction.config.method = "GetWaiterLog";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = DashboardFunction.data;
                DashboardFunction.config.ajaxCallMode = 1;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            callWaiter: function (waiterIp) {
                DashboardFunction.config.method = "callWaiter";
                DashboardFunction.config.url = DashboardFunction.config.baseURL + DashboardFunction.config.method;
                DashboardFunction.config.data = JSON2.stringify({
                    WaiterIp: waiterIp
                });
                DashboardFunction.config.ajaxCallMode = 0;
                DashboardFunction.ajaxCall(DashboardFunction.config);
            },
            //<<----------------------------- Bind Here ---------------------------------------->>	
            BindWaiterCallLog: function (result) {
                $('#callwaiterDiv').html("");
                var WaiterList = JSON.parse(result);
                
                var htmls = "";
                if (WaiterList.length > 0) {
                    htmls = "<ul>";
                    $.each(WaiterList, function (index, value) {
                        if (value.image == '') {
                            htmls += ("<li><span id='waiter_" + value.WaiterIP + "' class='waiters'> <img src='/Modules/Admin/UserManagement/UserPic/waiter.png'><span>" + value.WaiterName + "</span><i class='fa fa-bell swing'></i></span></li>");
                        }
                        else {
                            htmls += ("<li><span id='waiter_" + value.WaiterIP + "' class='waiters'><img src='/Modules/Admin/UserManagement/UserPic/" + value.image + "' ><span>" + value.WaiterName + "</span><i class='fa fa-bell swing'></i></span></li>");
                        }
                    });
                    htmls += "</ul>";
                } else {
                    htmls = "<h4>No Waiters Online</h4><img src='images/findwaiter.gif'>";
                }
                $('#callwaiterDiv').html(htmls);
            },


        };

        DashboardFunction.InitialSetup();
        $('#callwaiterDiv').on('click', '.waiters', function () {       
            var datas = $(this).attr('id');
            var dataarray = datas.split('_');
            var waiterIp = dataarray[1];
            DashboardFunction.callWaiter(waiterIp);
        });
     
        $('#callwaiter').click(function (e) {
            e.stopPropagation();
            DashboardFunction.GetWaiterLog();
            $('#callwaiterDiv').dialog(
                      {
                          'title': 'Online Waiters',
                          width: 300,
                          height: 'auto',
                          modal: true,
                          position: ['center', 'center']
                      });
            var effect = 'slide';
            var options = { direction: 'right' };
            var duration = 700;
            $('.delivery').prop('checked', true);
            $(".com").show();
            $(".dine").hide();
        });
    };
    $.fn.callWaiterEDIT = function (p) {
        $.callWaitercreate(p);
    };
})(jQuery);
