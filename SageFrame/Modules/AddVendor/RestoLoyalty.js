function Print() {
    $('#printedDate').show();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#VenderListing').html();
    $('#printedDate').hide();
    var frame1 = document.createElement('iframe');
    frame1.name = "frame1";
    document.body.appendChild(frame1);
    var frameDoc = frame1.contentWindow ? frame1.contentWindow : frame1.contentDocument.document ? frame1.contentDocument.document : frame1.contentDocument;
    frameDoc.document.open();
    frameDoc.document.write('<html><head><title></title>');
    frameDoc.document.write('</head><body>');
    frameDoc.document.write(contents);
    frameDoc.document.write('</body>');
    frameDoc.document.close();
    setTimeout(function () {
        window.frames["frame1"].focus();
        window.frames["frame1"].print();
        document.body.removeChild(frame1);
    }, 500);
}
(function ($) {
    // var tabs = $("#tabss").tabs();
    // $('#tabss').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '',
                 vendor: ''
             }, p);
        var v = 0;      
        var name = [];
        var checks = [];
        var Custlist = [];
        var userRole = "";
        var companyProf = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "WebServiceOfRestoLoyalty.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                MembershipID: 0,
                MembershipIDUpdate: 0
                

            },
            InitialSetup: function () {
                companyProf.GetUserName();
                if (p.vendor == 1) {
                    companyProf.getmemberForVender();
                }
                $('#txtSearch').on('keyup', function () {
                    companyProf.BindmemberForVender();
                });

                $("#txtDateOfIssue").datepicker({
                    changeYear: true,
                    changeMonth: true,
                    onClose: function () {
                        $(this).valid();
                    }                  
                });
                $("#txtDateOfExpiry").datepicker({
                    changeYear: true,
                    changeMonth: true,
                   
                    onClose: function () {
                        //$(this).next().focus();
                        $(this).valid();
                    }
                });
                $("#txtBirthday").datepicker({
                    changeYear: true,
                    changeMonth: true,
                    yearRange: "1951:2030",
                    onClose: function () {
                        //$(this).next().focus();
                        $(this).valid();
                    }
                });
              
               
                //$("input[type=radio][name=Customer]").removeAttr("disabled", "disabled");
                //$("#btnAddItem").show();

            },
            init: function () {
                companyProf.InitialSetup();
            
                $("#btnCancelItem").click(function () {
                    $("#divForMember").hide();
                    $("#VenderListing").show();
                    $("#tabss").show();
                    $(".main").hide();
                    companyProf.ResetMembershipForm();
                });
                $("#txtCardNumber").change(function () {
                    for (var i = 0; i < checks.length; i++) {
                        if (checks[i] == $("#txtCardNumber").val()) {
                            jAlert("Already Exist: " + checks[i] + "; \n Please Enter a Unique Card Number", "Alert!!", function () { $.alerts.dialogClass = null; });
                            $("#txtCardNumber").val("");
                        }
                    }
                });
                $("#btnSaveMembershipApplication").on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SaveMembership();
               
                    }
                });
           
                $("#btnExport").click(function (e) {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#VenderListing').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "VenderList.xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#VenderListing"), 0, 0, options, function () {
                        pdf.save('VenderList.pdf');
                    });
                    $('#printedDate').hide();
                  
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
                        jAlert("Inserted successfully", "Information!!", function () { $.alerts.dialogClass = null; });
                        companyProf.ResetMembershipForm();
                        break;
                    case 2:
                        jAlert("Update successfully", "Information!!", function () { $.alerts.dialogClass = null; });
                        companyProf.ResetMembershipForm();
                        $("#divForMember").hide();
                        $("#tabss").show();
                        companyProf.InitialSetup();
                        break;
                    case 3:
                        companyProf.Bindmember(data.d);
                        break;
                    case 4:
                        Custlist = [];
                        Custlist = JSON.parse(data.d);
                        companyProf.BindmemberForVender();
                        break;
                    case 5:
                        jAlert("Deleted successfully", "Information!!", function () {
                            companyProf.getmemberForVender();
                        });
                        break;
                    case 6:
                        var role = data.d;
                        userRole = role.Roles;
                        break;

                }
            },
            ajaxFailure: function (data) {

       
            },


            //-----------------------------------------getdata---------------------------
            GetUserName: function () {
                var loggername = SageFrameUserName;
                companyProf.config.method = "GetRolesByUsername";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ username: loggername });
                companyProf.config.ajaxCallMode = 6;
                companyProf.ajaxCall(companyProf.config);
            },

            DeleteItem: function (id) {              
                var RId = id;
                var deletedby = SageFrameUserName;
                companyProf.config.method = "deletemember";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ RId: RId, deletedby: deletedby });
                companyProf.config.ajaxCallMode = 5;
                companyProf.ajaxCall(companyProf.config);
            },

            getmember: function () {
                var customer = 1;
                companyProf.config.method = "getsdatass";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ customer: customer });
                companyProf.config.ajaxCallMode = 3;
                companyProf.ajaxCall(companyProf.config);
            },
            getmemberForVender: function () {
                var customer = 0;
                companyProf.config.method = "getsdatass";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ customer: customer });
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },

            SaveMembership: function () {
                
                var MemberInfo = {};
                MemberInfo.MembershipID = companyProf.config.MembershipID;
                MemberInfo.Fname = $('#txtFirstName').val();
                MemberInfo.Lname = "";
                MemberInfo.Address = $('#txtAddress').val();
                MemberInfo.City = $('#txtCity').val();
                MemberInfo.Country = $('#txtCountry').val();
                MemberInfo.TelHome = "";
                MemberInfo.TelWork = $('#txtPhoneWork').val();
                MemberInfo.TelMobile = $('#txtPhoneMobile').val();
                MemberInfo.Email = $('#txtEmail').val();
                MemberInfo.OpeningBalance = $('#txtOpeningBalance').val();
                MemberInfo.Occupation = "";
                MemberInfo.discount = 0;
                
                //MemberInfo.PAN = 0;
                //var value = parseInt($('input[name="Customer"]:checked').val());
                //if (value == 0) {
                    //MemberInfo.Company = $('#txtCompany').val();
                    //MemberInfo.PAN = $('#txtCustPan').val();
                    //MemberInfo.Birthday = $('#txtBirthday').val();
                    //MemberInfo.Anniversary = $('#txtAnniversary').val();

                    //MemberInfo.CardNumber = $('#txtCardNumber').val();
                    //MemberInfo.DateOfIssue = $('#txtDateOfIssue').val();
                    //MemberInfo.DateOfExpire = $('#txtDateOfExpiry').val();
                    //MemberInfo.discount = $('#txtDiscount').val();
                    //if (MemberInfo.discount == "") {
                    //    MemberInfo.discount = 0;
                    //}
                    //MemberInfo.IsCustomer = true;
                    //MemberInfo.IsVat = false;
                //} else {
                    MemberInfo.PAN = $('#txtPan').val();
                    MemberInfo.IsCustomer = false;
                    MemberInfo.IsVat = $("#ckboxIsVAT").is(':checked');
                //}
                    MemberInfo.AddedBy = SageFrameUserName;
                companyProf.config.method = "SaveMembership";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ MemberInfo: MemberInfo });
                if (companyProf.config.MembershipIDUpdate == 1) {
                    companyProf.config.ajaxCallMode = 2;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }

                companyProf.ajaxCall(companyProf.config);

                companyProf.config.MembershipIDUpdate = 0;
            },

            //---------------------------------------------BindData----------------------------------------------------------------------

            Bindmember: function (data) {
                debugger;
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');

                var datas = JSON.parse(data);
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtable' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th style='width:200px'> Address </th><th>PAN</th><th>Card No.</th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th><th style='width:90px'> Opening BAL </th><th style='width:90px'> RMNG BAL </th><th style='width:90px'> Total Paid </th><th class='edit-heading'>Edit</th><th class='delete-heading'>Delete</th>";
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {

                        htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                        //htmls += "<td>" + value.MembershipID + "</td>";
                        htmls += "<td>" + value.Name + "</td>";
                        htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                        htmls += "<td style='width:90px'>" + value.PAN + "</td>";
                        htmls += "<td style='width:90px'>" + value.CardNumber + "</td>";
                        htmls += "<td>" + value.Occupation + "</td>";
                        htmls += "<td>" + value.Company + "</td>";
                        htmls += "<td>" + value.TelMobile + "</td>";
                        htmls += "<td style='width:90px'>" + value.discount + " %</td>";
                        htmls += "<td style='width:90px;text-align:right;'>Rs. " + value.OpeningBalance + "</td>";
                        htmls += "<td style='width:90px;text-align:right;'>Rs. " + value.RemainingBalance + "</td>";
                        htmls += "<td style='width:90px;text-align:right;'>Rs. " + value.UptoNowPaid + "</td>";

                        htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "+" + value.Fname + "+" + value.Lname + "+" + value.Address + "+" + value.City + "+" + value.Country + "+" + value.TelHome + "+" + value.TelWork + "+" + value.TelMobile + "+" + value.Email + "+" + value.Occupation + "+" + value.Company + "+" + value.Birthday + "+" + value.Anniversary + "+" + value.CardNumber + "+" + value.DateOfIssue + "+" + value.DateOfExpire + "+" + value.discount + "+" + value.PAN + "+" + value.IsCustomer + "+" + value.OpeningBalance + "' value='Edit'  /></td>";
                        htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                        htmls += "</tr>"
                        //name.push(value.Brand.toLowerCase());
                        checks.push(value.CardNumber);
                    });
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#membeshipformlist').html(htmls);
                    $('#Brandtable').DataTable(
                         {
                             "scrollY": false,
                             "scrollCollapse": false,
                             "jQueryUI": true,
                                columnDefs: [{ orderable: false, targets: [0,10,11] }],
                               

                         });

                } else {
                    $('#membeshipformlist').html('No data');

                }
                $("#membeshipformlist").on('click', '.BrandEdit', function (event) {
                    var ids = $(this).attr('id');
                    var words = ids.split('+');
                    companyProf.config.MembershipID = words[0];
                    $('#txtFirstName').val(words[1]);
                    $('#txtLastName').val(words[2]);
                    $('#txtAddress').val(words[3]);
                    $('#txtCity').val(words[4]);
                    $('#txtCountry').val(words[5]);
                    $('#txtPhoneHome').val(words[6]);
                    $('#txtPhoneWork').val(words[7]);
                    $('#txtPhoneMobile').val(words[8]);
                    $('#txtEmail').val(words[9]);
                    $('#txtOccupation').val(words[10]);
                    $('#txtCompany').val(words[11]);
                    $('#txtBirthday').val(words[12]);
                    $('#txtAnniversary').val(words[13]);
                    $('#txtCardNumber').val(words[14]);
                    $('#txtDateOfIssue').val(words[15].split(" ")[0]);
                    $('#txtDateOfExpiry').val(words[16].split(" ")[0]);
                    $('#txtDiscount').val(words[17]);
                    $('#txtCustPan').val(words[18]);
                    
                    $('#Customer').val(words[19]);
                    $('#txtOpeningBalance').val(words[20]);
                    //$("input[type=radio][name=Customer]").prop('checked', false);
                    //if (words[19] == "true") {
                    //    $('#rdoCustomer').prop('checked', true);
                    //    //$('#rdoVender').attr('checked', false);
                    //    $(".custo").show();
                    //    $(".vend").hide();
                    //}
                    //else {
                    //    $('#rdoVender').prop('checked', true);
                    //    // $('#rdoCustomer').attr('checked', false);
                    //    $(".custo").hide();
                    //    $(".vend").show();
                    //}
                    $(".main").show();
                    //$("input[type=radio][name=Customer]").attr("disabled", "disabled");
                    //$("#btnAddItem , .loyaltycheckbox").hide();
                    $("#divForMember").show();
                    $("#tabss").hide();
                    companyProf.config.MembershipIDUpdate = 1;
                });

                $("#membeshipformlist").on('click', '.BrandDelete', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                        //jAlert('Confirmed: ' + r, 'Confirmation Results');
                        if (r) {
                            companyProf.DeleteItem(id);
                            companyProf.getmember();
                        }
                    });
                });
                $(".dataTables_scrollBody").css('height', '100%');

            },
            BindmemberForVender: function (data) {
                $("#VenderListing").show();
                $("#VenderListing").html('');
         
                var Roles = userRole.split(",");
                var datas = Custlist;
                if (datas.length > 0) {
                    var htmls = "<table id='Brandtables' cellspacing='0'>"
                    htmls += "<thead>"
                    htmls += "<tr>"
                    htmls += "<th> Name </th><th> Address </th><th> Contact No.</th><th> Email </th><th>PAN No.</th><th>Opening Balance.</th>";
                    if (Roles.includes("Manager") || Roles.includes("Super User") || Roles.includes("Site Admin")) {
                        htmls += "<th class='edit'>Edit</th>";
                    }
                    if (Roles.includes("Super User")) {
                        htmls += "<th class='edit'>Delete</th>";
                    }
                    htmls += "</tr>"
                    htmls += "</thead>"
                    htmls += "<tbody>"

                    $.each(datas, function (index, value) {
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.Name.toLowerCase().includes(search) || value.TelMobile.toLowerCase().includes(search) || value.Addresss.toLowerCase().includes(search) || search == '') {
                            htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                            htmls += "<td>" + value.Name + "</td>";
                            htmls += "<td>" + value.Addresss + "</td>";
                            htmls += "<td>" + value.TelMobile + "</td>";
                            htmls += "<td>" + value.Email + "</td>";
                            htmls += "<td>" + value.PAN + "</td>";
                            htmls += "<td>" + value.OpeningBalance + "</td>";
                            if (Roles.includes("Manager") || Roles.includes("Super User") || Roles.includes("Site Admin")) {
                                htmls += "<td>" + "<img src='/images/edit.png' class='BrandEdit' type='button'  id='" + value.MembershipID + "+" + value.Fname + "+" + value.Lname + "+" + value.Address + "+" + value.City + "+" + value.Country + "+" + value.TelHome + "+" + value.TelWork + "+" + value.TelMobile + "+" + value.Email + "+" + value.Occupation + "+" + value.Company + "+" + value.discount + "+" + value.PAN + "+" + value.IsVat + "+" + value.OpeningBalance + "' value='Edit'  /></td>";
                            }
                            if (Roles.includes("Super User")) {
                                htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                            }
                            htmls += "</tr>"
                            //name.push(value.Brand.toLowerCase());
                            checks.push(value.CardNumber);
                        }
                    });
                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='5' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#VenderListing').html(htmls);
                
                $("#VenderListing").on('click', '.BrandEdit', function (event) {
                    var ids = $(this).attr('id');
                    var words = ids.split('+');
                    companyProf.config.MembershipID = words[0];
                    $('#txtFirstName').val(words[1]);
                    $('#txtAddress').val(words[3]);
                    $('#txtCity').val(words[4]);
                    $('#txtCountry').val(words[5]);
                    $('#txtPhoneHome').val(words[6]);
                    $('#txtPhoneWork').val(words[7]);
                    $('#txtPhoneMobile').val(words[8]);
                    $('#txtEmail').val(words[9]);
                    $('#txtOccupation').val(words[10]);
                    $('#txtCompany').val(words[11]);
                    $('#txtDiscount').val(words[12]);
                    $('#txtPan').val(words[13]);
                    $('#Customer').val(words[14]);
                    $('#txtOpeningBalance').val(words[15]);
                    //$("input[type=radio][name=Customer]").prop('checked', false);              
                    //$('#ckboxIsVAT').prop('checked', false);
                    if (words[14] == "true") {
                        $('#ckboxIsVAT').prop('checked', true);
                    }
                    $(".main").show();
                    $("input[type=radio][name=Customer]").attr("disabled", "disabled");
                    $("#btnAddItem , .loyaltycheckbox").hide();
                    $("#divForMember").show();
                    $("#tabss").hide();
                    $("#VenderListing").hide();
                    $(".report-view").hide();
                    $(".report-filter").hide();
                    companyProf.config.MembershipIDUpdate = 1;

                });

                $("#VenderListing").on('click', '.BrandDelete', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                        //jAlert('Confirmed: ' + r, 'Confirmation Results');
                        if (r) {
                            companyProf.DeleteItem(id);
                        }
                    });
                });
                $(".dataTables_scrollBody").css('height', '100%');

            },
            ResetMembershipForm: function () {
                $('#txtFirstName').val('');
                $('#txtLastName').val('');
                $('#txtAddress').val('');
                $('#txtCity').val('');
                $('#txtCountry').val('');
                $('#txtPhoneHome').val('');
                $('#txtPhoneWork').val('');
                $('#txtPhoneMobile').val('');
                $('#txtEmail').val('');
                $('#txtOccupation').val('');
                $('#txtCompany').val('');
                $('#txtBirthday').val('');
                $('#txtAnniversary').val('');
                $('#txtCardNumber').val('');
                $('#txtDateOfIssue').val('');
                $('#txtDateOfExpiry').val('');
                $('#txtDiscount').val('');
                $('#txtOpeningBalance').val('');
                $('#txtPan').val('');
                $('#txtCustPan').val('');
                //$("#btnAddItem").show();
                $("#divForMember").show();
                //$("#tabss").show();
                $(".report-view").show();
                $(".report-filter").show();
                companyProf.config.MembershipID = 0;

                companyProf.config.MembershipIDUpdate = 0;
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        FirstName: {
                            required: true,
                        },

                        //PhoneHome: {
                        //    required: true,
                        //    number: true,
                        //    phone: true,
                        //},
                        txtPhoneWork: {
                            number: true,
                            required: false,
                        },
                        //PhoneMobile: {
                        //    required: true,
                        //    number: true,
                        //    phone: true,
                        //},
                        //Email: {
                        //    required: true,
                        //    email: true,
                        //},
                        //Discount: {
                        //    required: true,
                        //    number: true,
                        //},
                        CustPan: {
                            number: true
                        },
                        pan: {
                            number: true
                        },
                        CardNumber: {
                            number: true
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