(function ($) {
    var tabs = $("#tabs").tabs();
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: ''
             }, p);
        var v = 0;
        var TotalAmount = 0;
        var totamount = 0;
        var name = [];
        var checks = [];
        var companyProf = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceForCusBalanceReport.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MemberID: 27,
                MemberIDUpdate: 0



            },
            InitialSetup: function () {
                $('#sample').hide();
                companyProf.GetCustomer();
                $("#membeshipformlist").hide();
                $("#check").hide();
                $("#bindtotalamount").hide();
                $("#bindpaidamount").hide();



            



            },
            init: function () {
                companyProf.InitialSetup();


                //$("#txtYEs").change(function () {                   
                //    var customer = 1;
                //    companyProf.config.method = "getsdatass";
                //    companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                //    companyProf.config.data = JSON2.stringify({ customer: customer });
                //    companyProf.config.ajaxCallMode = 5;
                //    companyProf.ajaxCall(companyProf.config);
                //});





                $("#btnOk").on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SaveAmount();
                    }
                });

              
                // updatemember

         
                $("#ddCusName").change(function () {                

                    var MembershipID = $("#ddCusName").val();

                    companyProf.config.method = "GetCusOnChange";
                    companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                    companyProf.config.data = JSON.stringify({ MembershipID: MembershipID });
                    companyProf.config.ajaxCallMode = 6;

                    companyProf.ajaxCall(companyProf.config);
                  
                });



             

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
                        //  alert("Inserted successfully");
                        companyProf.ResetForm();
                        companyProf.InitialSetup();

                        break;
                    case 2:
                        jAlert('Update successfully', 'Information!!', function () { $.alerts.dialogClass = null; });
                        companyProf.ResetForm();
                        companyProf.InitialSetup();
                        break;
                    case 3:
                        companyProf.Bindmember(data);
                        break;
                    case 4:
                        companyProf.DropDownCustomer(data);
                        break;
                    case 5:

                        companyProf.Bindmembership(data);
                        companyProf.BindCusCash(data);

                        break;
                    case 6:
                        companyProf.Bindmembership(data);
                        break;


                }
            },
            ajaxFailure: function (data) {

                // alert("Department Not Unique");

            },


            //-----------------------------------------getdata---------------------------\\



         


            

            //---------------------------------------------BindData-------------------------------------------\\

            GetCustomer: function () {
                companyProf.config.method = "getCusName";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },



            GetCustomeronChange: function () {
                var customer = 1;
                companyProf.config.method = "getsdatass";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ customer: customer });
                companyProf.config.ajaxCallMode = 5;
                companyProf.ajaxCall(companyProf.config);
            },


            //$("#txtYEs").change(function () {                   
            //    var customer = 1;
            //    companyProf.config.method = "getsdatass";
            //    companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
            //    companyProf.config.data = JSON2.stringify({ customer: customer });
            //    companyProf.config.ajaxCallMode = 5;
            //    companyProf.ajaxCall(companyProf.config);
            //});



            

            //getmember: function () {
            //    var customer = 1;
            //    companyProf.config.method = "getsdatass";
            //    companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
            //    companyProf.config.data = JSON2.stringify({ customer: customer });
            //    companyProf.config.ajaxCallMode = 6;
            //    companyProf.ajaxCall(companyProf.config);
            //},



            DropDownCustomer: function (result) {
                //if (!result.data) return;
                if (!result.d) return;
                var datas = result.d;
                $("#ddCusName").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.MembershipID + "'>" + value.Name + "</option>";
                    });

                    $("#ddCusName").html(htmls);
                }

            },


            Bindmembership: function (data) {
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');

                debugger;
                var datas = data.d;
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' class='sfGridwrapper display' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th style='width:200px'> Card Number </th><th> Remaining Balance </th><th> Upto Now Paid </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:200px'>" + value.CardNumber + "</td>";
                        htmls += "<td>" + value.RemainingBalance + "</td>";
                        htmls += "<td>" + value.UptoNowPaid + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + "</td>";
                        // htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "_" + value.Fname + "_" + value.Lname + "_" + value.Address + "_" + value.City + "_" + value.Country + "_" + value.TelHome + "_" + value.TelWork + "_" + value.TelMobile + "_" + value.Email + "_" + value.Occupation + "_" + value.Company + "_" + value.Birthday + "_" + value.Anniversary + "_" + value.CardNumber + "_" + value.DateOfIssue + "_" + value.DateOfExpire + "_" + value.discount + "_" + value.PAN + "_" + value.IsCustomer + "' value='Edit'  /></td>";
                      //  htmls += "<td>" + "<img src='/images/paid.png' class='BrandDelete' style='width:30px' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                         {
                             dom: 'Bfrtip',

                             buttons: [

                                 'print', 'excel', 'pdf'
                             ],

                             "scrollY": false,
                             "scrollCollapse": false,
                             "jQueryUI": true,

                         });

                } else {
                    $('#membeshipformlist').html('No data');

                }
             


                $(".dataTables_scrollBody").css('height', '100%');

            },



           
            ResetForm: function () {
                $('#txtTotalAmount').val('');
                $('#txtTenderAmount').val('');
                $('#txtReturnAmount').val('');


            },


            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        FirstName: {
                            required: true,
                        },



                        PaidAmount: {
                            required: true,
                            number: true,
                        }
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
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
