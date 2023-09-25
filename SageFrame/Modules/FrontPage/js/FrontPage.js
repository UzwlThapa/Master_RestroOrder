(function ($) {
    $.FrontPage = function (p) {
        var order = 0;
        var level = 0;
        var totalTable = 0;
        var occupiedTable = 0;
        var availableTable = 0;
        var totalsales = 0;
        var ImageUrl;

        p = $.extend
                ({
                    HostUrl: '',
                    CultureCode: '',
                    UserModuleID: '1'
                }, p);
        var companyInfo = JSON.parse(localStorage.getItem("companyInfo"));
        var FrontPage = {
            config: {
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: '{}',
                dataType: 'json',
                method: "",
                url: "",
                categoryList: "",
                ajaxCallMode: 0,
                arr: [],
                arrModules: [],
                baseURL: SageFrameAppPath + '/Modules/FrontPage/WebService/FrontPage.asmx/',
                Path: SageFrameAppPath + '/Modules/FrontPage/',
                PortalID: SageFramePortalID,
                UserName: SageFrameUserName,
                UserModuleID: p.UserModuleID                
            },
            init: function () {
                FrontPage.BindCompanyInfo();
                FrontPage.GetFrontPageStatus();

                window.setInterval(function () {
                    FrontPage.GetFrontPageStatus();
                }, 30000);

                $(".OcpTables").on("click", function () {
                    FrontPage.GetOccupiedTable();
                    $(".RO_wrapper").dialog({
                        'title': 'Occupied Tables',
                        width : 1000
                    });
                });
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: FrontPage.config.type,
                    contentType: FrontPage.config.contentType,
                    cache: FrontPage.config.cache,
                    async: FrontPage.config.async,
                    url: FrontPage.config.url,
                    data: FrontPage.config.data,
                    dataType: FrontPage.config.dataType,
                    success: FrontPage.ajaxSuccess,
                    error: FrontPage.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(FrontPage.config.ajaxCallMode)) {
                    case 0:
                        FrontPage.BindFrontPageStatus(data.d);
                        break;
                    case 1:
                        FrontPage.BindOccupiedTables(data.d);
                        break;
                }
            },
            ajaxFailure: function () {

            },
           
            GetFrontPageStatus: function () {
                
                FrontPage.config.method = "getFrontpageStatus";
                FrontPage.config.url = FrontPage.config.baseURL + FrontPage.config.method;
                FrontPage.config.data = FrontPage.config.data;
                FrontPage.config.ajaxCallMode = 0;
                FrontPage.ajaxCall(FrontPage.config);
            },



            GetOccupiedTable: function () {

                FrontPage.config.method = "getOccupiedTableList";
                FrontPage.config.url = FrontPage.config.baseURL + FrontPage.config.method;
                FrontPage.config.data = FrontPage.config.data;
                FrontPage.config.ajaxCallMode = 1;
                FrontPage.ajaxCall(FrontPage.config);
            },



            BindFrontPageStatus: function (result) {
             
                var FrontPageList = JSON.parse(result);
                totalTable = FrontPageList[0].TotalTables;
                occupiedTable = FrontPageList[0].OccupiedTables;
                availableTable = totalTable - occupiedTable;
                //totalsales = FrontPageList[0].TotalSales;

                $("#TotalTables").html(totalTable);
                $("#OccupiedTables").html(occupiedTable);
                $("#AvailableTables").html(availableTable);
                //$("#TotalSales").html(totalsales);
                
            },

            BindCompanyInfo: function () {
            
                ImageUrl = "/Modules/ROCompanyInfo/logo/" + companyInfo.Logo; 
                $("#logo").attr("src", ImageUrl);
                $("#logo").on("error", function () {
                $(this).attr('src', '/Modules/ROCompanyInfo/logo/logo.png');
            });
                $("#logo").css("display","block");
                
            },

            BindOccupiedTables: function (result) {
                var htmls = [];
                $('.RO_wrapper').html("");
                var datas = JSON.parse(result);
                if (datas.length > 0) {
                    htmls += "<div class='TablesInRooms Tables'>";
                    htmls += "<ul>";
                    $.each(datas, function (index, value) {
                        htmls += "<li>"
                            htmls += ("<label for ='");
                            htmls += ("Table_" + value.restrotableId + "_img_" + value.IsTable + "_" + value.restrotableTitle + '_no' + "' class = '' >");
                            htmls += ("<img class='imgForTable' id='IMG_" + value.restrotableId + "' src='" + p.HostUrl + "/Modules/RestroDashboard/image/tablered.png'></label> ");
                            htmls += ("<h5 class='occupiedTablee'>" + value.restrotableTitle + "</h5>");

                            if (value.BillPaid.toString() == '0' && value.IsCancelled.toString() == '0') {
                                htmls += ("<h5 class='order-time'");

                                var dateprev = new Date(value.tableDate);
                                var datet = new Date();
                                var diff = (datet - dateprev) / 1000;
                                function secondsTimeSpanToHMS(s) {
                                    var h = Math.floor(s / 3600); //Get whole hours
                                    s -= h * 3600;
                                    var m = Math.floor(s / 60); //Get remaining minutes
                                    s -= m * 60;
                                    if (h == 0) {
                                        return (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           }
                                    } else {
                                        return h + ":" + (m < 10 ? '0' + m : m) + "M";//zero padding on minutes and seconds                           }
                                    }

                                }
                                var dinal = secondsTimeSpanToHMS(diff)
                                htmls += ("' >" + value.tabletime + "</h5><h5 class='order-timeA'>" + dinal + "</h5>");
                            }
                            htmls += ("</li>");
                    
                    });
                    htmls += "</ul>";
                    htmls += "</div>";
                    $('.RO_wrapper').html(htmls);

                }
            },
           
        }
        FrontPage.init();
    }
    $.fn.FrontPage = function (p) {
        $.FrontPage(p);
    };
})(jQuery);
