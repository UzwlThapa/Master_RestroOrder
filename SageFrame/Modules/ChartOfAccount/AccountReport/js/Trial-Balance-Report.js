/// <reference path="VoucherReport.js" />
(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ChartOfAccount/AccountReport/',
                 CompanyName: '',
                 Pan: ''

             }, p);
        var v = 0;
  
        var eventFunction = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "Reportwebservice.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0
            },
            InitialSetup: function () {
                $("#btnView").on('click', function () {
                    eventFunction.TrialBalanceReport();
                    $("#btnPrint").show();
                });
            },
            init: function () {

                eventFunction.InitialSetup();
              



                //----------------------------------------Daily----------------
                //$("#btnView").on('click', function () {
                //    var checkValid = eventFunction.ValidationForm();
                //    if (checkValid) {
                //        eventFunction.GetDailyReport();
                //    }
                //});



                //--------------------------Print PDF----------------
                $("#btnPrint").on('click', function () {
                    var contents = document.getElementById("DailyReport").innerHTML;
                    var frame1 = document.createElement('iframe');
                    frame1.name = "frame1";
                    //frame1.style.position = "absolute";
                    //frame1.css({ "position": "absolute", "top": "-1000000px" });
                    //$("body").append(frame1);
                    //frame1.style.top = "-1000000px";
                    document.body.appendChild(frame1);
                    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
                    frameDoc.document.open();
                    frameDoc.document.write('<html><head><title></title>');
                    frameDoc.document.write('</head><body>');
                    //frameDoc.document.write('<link href="../../Core/Template/css/custom.css" rel="stylesheet" type="text/css" />');
                    frameDoc.document.write(contents);
                    frameDoc.document.write('</body></html>');
                    frameDoc.document.close();
                    setTimeout(function () {
                        window.frames["frame1"].focus();
                        window.frames["frame1"].print();
                        document.body.removeChild(frame1);
                    }, 500);
                    return false;
                });

                //--------------------------Export To EXCEL----------------
                $("#exportToXCEl").click(function (e) {
                    var data_type = 'data:application/vnd.ms-excel';
                    var table_div = document.getElementById('DailyReport');
                    var table_html = table_div.outerHTML.replace(/ /g, '%20');
                    window.open(data_type + ', ' + table_html);
                    e.preventDefault();
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
                        eventFunction.BindTrialBalance(data);
                        break;
                   

                }
            },
            ajaxFailure: function () {
                //switch (parseInt(eventFunction.config.ajaxCallMode)) {
                //    case 7:
                //        alert("Delete fail ! Your data is being used: remove dependencies", "fail");
                //        break;
                //}
            },

            TrialBalanceReport: function () {
                var StartDate = $("#txtStartDate").val();
                eventFunction.config.method = "TrialBalanceReport";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ Date: StartDate });
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode =1;
                eventFunction.ajaxCall(eventFunction.config);
            },


            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindTrialBalance: function (data) {
                $("#DailyReport").html('');
                var datas = data.d;
                var StartDate = $("#txtStartDate").val();
                var EndDate = $("#txtToDate").val();
                var _oDt = new Date();
                var _DateStr = $.datepicker.formatDate('mm/dd/yy', _oDt);

                var debit=0;
                var credit=0;
                var balance = 0;
                if (datas.length > 0) {
                var htmls = "<table class='pur-static-tbl1'><tr><td colspan='2'> Trial Balance </td></tr><tr>" + datas[0].CompanyName + "</tr><tr><td style='text-align:right;font-size:15px;'> As Of : " + $("#txtStartDate").val() + "</td></tr><tr><td>Created On: " + _DateStr + "</td></tr></table>";
                htmls += "<table id='unittableSecond' class='sfGridwrapper display pur-static-tbl' cellspacing='0'>";
                htmls += "<thead>";
                htmls += "<tr>";
                htmls += "<th>Account</th><th>Debit</th><th>Credit</th>";
                htmls += "</tr>";
                htmls += "</thead>";
                htmls += "<tbody>";
               
                   
                    $.each(datas, function (index, value) {
                        htmls += "<tr>";
                        htmls += "<td>" + value.Account + "</td>";
                       if (value.Debit != 0)
                        {
                            htmls += "<td class='tdrate'>" + value.Debit + "</td>";
                            htmls += "<td>0</td>";
                            debit = debit + value.Debit;
                        
                        
                        } else {
                            htmls += "<td>0</td>";
                            htmls += "<td class='tdrate'>" + value.Credit + "</td>";
                            credit = credit + value.Credit;
                          
                        }
                        htmls += "</tr>";
                      
                    });
                
                    htmls += "<tr><th class='tdrate'>Total</th><th>" + debit + "</th><th class='tdrate'>" + credit + "</th></tr>";
                    //htmls += "<tfoot><tr><td colspan='4'>Total</td><td>" + A.toFixed(2) + "</td><td></td><td></td><td>" + Ta.toFixed(2) + "</td><td>" + Taa.toFixed(2) + "</td></tr></tfoot>";
                }
                else {
                    htmls += "<tr class='tableItem' >";
                    htmls += "<td>No Data Found</td><tr>";
                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#DailyReport').html(htmls);
                //$('#Exports').show();

            },


            //<<-----------------------------------Reset & Validation ------------------------------------->>>

            ResetAll: function () {
                //Unit
                $('#textUnit').val('');
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        textUnit: {
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