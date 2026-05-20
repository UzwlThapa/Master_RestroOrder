(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '',
                 HostUrl: ''
             }, p);
        var v = 0;
        var companyProf = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForRestoListing.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MachineID: 0,
                Machineupdate: 0,
                orderId:0
            },
            InitialSetup: function () {

                companyProf.GetRestoListing();
            },
            init: function () {

                companyProf.InitialSetup();
            },
            ajaxCall: function (config) {
                $.ajax({
                    type: companyProf.config.type,
                    contentType: companyProf.config.contentType,
                    async: companyProf.config.async,
                    cache: companyProf.config.cache,
                    url: companyProf.config.url,
                    data: companyProf.config.data,
                    dataType: companyProf.config.dataType,
                    success: companyProf.ajaxSuccess,
                    error: companyProf.ajaxFailure
                });
            },
            ajaxSuccess: function (data) {
                switch (parseInt(companyProf.config.ajaxCallMode)) {
                    case 0:
                        break;
                    case 1:
                        companyProf.BindRestoList(data);
                        break;
                    case 2:
                        var url = p.HostUrl + "/Sales-Bill.aspx?OID=" + encodeURIComponent(orderId);
                        window.location.href = url;
                        break;
                    case 5:
                        companyProf.BindLoyaltyDetails(data);
                        break;
                }
            },
            ajaxFailure: function () {

                
            },



            GetRestoListing: function () { 
                companyProf.config.method = "GetPickOrderFromDataBase";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 1;
                companyProf.ajaxCall(companyProf.config);
            },
            BindLoyaltyDetails: function (result) {
                $('.rightDiv').html("");
                $('.buttonDiv').html('');
                var datas = result.d;
                if (datas.length <= 0) {
                    jAlert('Data not found', "Alert!!", function () { $.alerts.dialogClass = null; });
                    $('.ok').show();
                    $(".cancel").show();
                    return;
                }
                var htmls = "";
                var htmlss = "";

                var gotloyaltyid = result.d[0].MembershipID;
                var gotPhoneNo = result.d[0].TelMobile;
                var loyaltyId = "ROL_" + gotloyaltyid;
                if (datas.length > 0) {
                    htmls += ("<div>Name: " + result.d[0].Fname + " " + result.d[0].Lname + "</div>");
                    htmls += ("<div>Address: " + result.d[0].Address + "</div>");
                    htmls += ("<div>City: " + result.d[0].City + "</div>");
                    htmls += ("<div>Country: " + result.d[0].Country + "</div>");
                    htmls += ("<div>Tel Home: " + result.d[0].TelHome + "</div>");
                    htmls += ("<div>Work: " + result.d[0].TelWork + "</div>");
                    htmls += ("<div>Mobile: " + result.d[0].TelMobile + "</div>");
                    htmls += ("<div>Email: " + result.d[0].Email + "</div>");
                    htmls += ("<div>Occupation: " + result.d[0].Occupation + "</div>");
                    htmls += ("<div>Company: " + result.d[0].Company + "</div>");
                    htmls += ("<div>Birthday: " + result.d[0].Birthday + "</div>");
                    htmls += ("<div>Anniversary: " + result.d[0].Anniversary + "</div>");
                    htmls += ("<div>Card No: " + result.d[0].CardNumber + "</div>");
                    htmls += ("<div>Date Of Issue: " + result.d[0].DateOfIssue + "</div>");
                    htmls += ("<div>Date Of Expire: " + result.d[0].DateOfExpire + "</div>");

                    htmlss += ("<input id='Pay_" + Tobepayedno + "' type='button' class='sfBtn restro-btn pay' value='Pay' />");
                    htmlss += ("<input type='button' class='sfBtn restro-btn cancel' value='Cancel' style='margin-left:10px;'/>");
                } else {
                    htmls += ("Name: " + value.Fname + " " + value.Lname + "<br />");
                    htmlss += ("<br/><input type='button' class='sfBtn cancel' value='Cancel' />");
                }
                $('.rightDiv').html(htmls);
                $('.buttonDiv').html(htmlss);

                $(".pay").on('click', function () {
                    var data = $(this).attr('id');
                    var id = data.split('_');
                    var url = p.HostUrl + "/Sales-Bill.aspx?OID=" + Tobepayedno + "&loyaltyNo=" + loyaltyId + "&PhnNo=" + gotPhoneNo;
                    window.location.href = url;
                });

                $(".cancel").on('click', function () {
                    $('#DialogOrderDetail').dialog("close");
                });

            },

            CheckLoyaltyForDiscount: function (loyaltyno, phoneno) {

                if (loyaltyno == '0') {
                    var loyal = 0;
                }
                else {
                    if (loyaltyno.indexOf('_') > -1) {
                        var loylty = loyaltyno.split('_');

                        var loyal = loylty[1];
                    }
                    else {
                        var loyal = 0;
                    }

                }

                companyProf.config.method = "CheckLoyaltyForDiscount";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({
                    MembershipID: loyal,
                    TelMobile: phoneno

                });
                companyProf.config.ajaxCallMode = 5;
                companyProf.ajaxCall(companyProf.config);
            },


            BindRestoList: function (result) {
                $("#SortableRestoListing").show();
                $("#SortableRestoListing").html('');
                var datas = result.d;
                if (datas.length > 0) {
                    var htmls = "<table class='sfGridwrapper table-restro order-listing-homepage'>";
                    htmls += "<thead><tr><th> Name </th><th style='width:400px'> Item Name </th><th> Order Date </th><th> Order Time </th><th> Appointment Receive Time </th><th> Date </th><th>Pay</th></tr></thead><tbody>";
                    $.each(datas, function (index, value) {
                        htmls += "<tr class=table id=" + value.OrderID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:400px'>" + value.ItemName + "</td>";
                        htmls += "<td>" + value.OrderDate + "</td>";
                        htmls += "<td>" + value.OrderTime + "</td>";
                        htmls += "<td>" + value.AppoinmentReceiveTime + "</td>";
                        htmls += "<td>" + value.AppoinmentReceiveDate + "</td>";
                      //htmls += "<td><img src='/images/edit.png' class='MachineEdit' id='" + value.MachineTypeId + "_" + value.MachineType + "' value='Edit'  /></td>";
                        htmls += "<td>" + "<img src='/images/pay.png' class='PayOrder' id='" + value.OrderID + "' type='button'/></td></tr>";

                        
                    });
                    htmls += "</tbody></table>";
                    $('#SortableRestoListing').html(htmls);
                    $(".sfGridwrapper").dataTable();
                } else {
                    $('#SortableRestoListing').html('No data');
                }

                $(".table-restro").on('click', ".PayOrder", function () {
                    $("#DialogOrderDetail").dialog();
                    //console.log(datas);
                    //var id = parseInt(datas[0].OrderID);
                    var id = $(this).closest('tr').attr('id');
                    
                    var data = id.split('_');
                    
                    //var Orderid = id;
                    //var url = p.HostUrl + "/Sales-Bill.aspx?OID=" + encodeURIComponent(parseInt(data[0]));
                    //window.location.href = url;



                    //-----------------------starts here 

                    var htmls = "";
                    $('#DialogOrderDetail').html("");
                    htmls += "<div id='dialogOrderOpen'>";
                    htmls += "<h4>Is Loyalty ?</h4>";
                    htmls += ("<div>");
                    htmls += ("<input id='Yes_" + data[0] + "' type='button' class='sfBtn Yes restro-btn' value='Yes' />");
                    htmls += ("<input id='No_" + data[0] + "' type='button'  class='sfBtn No restro-btn' style='margin-left:10px;' value='NO' /></div>");
                    $('#DialogOrderDetail').html(htmls);


                    $('.Yes').on('click', function () {
            
                        var id = $(this).attr('id');
                        var data = id.split('_');
                        //var url = p.HostUrl + "/Order.aspx?ID=" + encodeURIComponent(data[1]);
                        //window.location.href = url;



                        var htmls = "";
                        $('#DialogOrderDetail').html("");
                        htmls += "<div id='dialogOrderOpen'>";

                        htmls += "<div class='leftDiv'>";
                        htmls += '<form>';
                        htmls += '<fieldset>';
                        htmls += '<label for="name">Loyalty No:</label>';
                        htmls += '<input type="text"  id="txtloyaltyNo" class="text ui-widget-content ui-corner-all sfInputbox">';
                        htmls += '<label for="name">Phone No:</label>';
                        htmls += '<input type="text"  id="txtphoneNo" class="text ui-widget-content ui-corner-all sfInputbox">';
                        //htmls += '<input type="submit" tabindex="-1" style="position:absolute; top:-1000px">';
                        htmls += '</fieldset>';
                        htmls += '</form>';
                        htmls += ("</div>");

                        htmls += ("<div class='rightDiv clearfix'>")
                        htmls += ("</div>");

                        htmls += ("<div class='buttonDiv' style='margin-top:15px;'>")
                        htmls += ("<input id='ok_" + data[1] + "' type='button' class='sfBtn restro-btn ok' value='Ok' />");
                        htmls += ("<input id='cancel_" + data[1] + "' type='button'  class='sfBtn restro-btn cancel' value='cancel' style='margin-left:10px;'/></div></div>");
                        $('#DialogOrderDetail').html(htmls);

                        $('.ok').on('click', function () {
                            var id = $(this).attr('id');
                            var data = id.split('_');
                            Tobepayedno = data[1];
                            if ($('#txtloyaltyNo').val() == '') {
                                var loyaltyno = '0';
                            } else {
                                var loyaltyno = $('#txtloyaltyNo').val();
                            }

                            var phoneno = $('#txtphoneNo').val();
                            companyProf.CheckLoyaltyForDiscount(loyaltyno, phoneno);

                        });

                        $(".cancel").on('click', function () {
                            $('#DialogOrderDetail').dialog("close");
                        });

                    });

                    $('.No').on('click', function () {

                        var id = $(this).attr('id');
                        var data = id.split('_');
                        var url = p.HostUrl + "/Sales-Bill.aspx?OID=" + encodeURIComponent(data[1]);
                        window.location.href = url;

                    });

                });




                    //----------------------- ends here
                

            },
           
            RedirectList: function (item) {
                var id = parseInt(item.id.split("_")[1])
                $("#" + id + "_").remove();
                var Orderid = id;
                //var MachineTypeId = id;
                //companyProf.config.method = "DeleteMachineRow";
                //companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                //companyProf.config.data = JSON.stringify({ MachineTypeId: MachineTypeId });
                companyProf.config.ajaxCallMode = 2;

                companyProf.ajaxCall(companyProf.config);

            },


            ResetMachineForm: function () {
                $('#txtMachineType').val('');

            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        MachineType: {
                            required: true,
                        }





                    },
                    MachineType: {

                        required: '*'

                    },




                });
                if (v.form()) {
                    return true;
                }
                else
                    return false;

            },

        };
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
