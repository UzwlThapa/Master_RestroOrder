function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function Print() {
    $('#printedDate').show();
    $('.BrandEdit').hide();
    $('.checkbox').hide();
    $('.edit').hide();
    $('#lblPrintedOn').html(new Date());
    var contents = $('#membeshipformlist').html();
    $('#printedDate').hide();
    $('.BrandEdit').show();
    $('.checkbox').show();
    $('.edit').show();
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
                Customer: ''
            }, p);
        var v = 0;
        var name = [];
        var checks = [];
        var numbers = [];
        var userRole = "";
        var CheckRole = false;
        var Custlist = [];
        var loyalitylist = [];
        var companyProf = {
            config: {
                isPostBack: false,
                async: true,
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
                companyProf.GetCardLoyalityType();

                $('#txtSearch').on('keyup', function () {
                    companyProf.Bindmember();
                });

                var mid = getParameterByName("ID", window.location.href);

                if (mid != null) {

                    companyProf.config.method = "getmembershiplistbyId";
                    companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                    companyProf.config.data = JSON2.stringify({ memberid: mid });
                    companyProf.config.ajaxCallMode = 5;
                    companyProf.ajaxCall(companyProf.config);
                }
                $("#txtAnniversary").datepicker({
                    changeYear: true,
                    changeMonth: true,
                    onClose: function () {
                        //$(this).next().focus();
                        $(this).valid();
                    }
                    //yearRange: "1990:2030",
                });
                $("#txtDateOfIssue").datepicker({
                    changeYear: true,
                    changeMonth: true,
                    onClose: function () {
                        //$(this).next().focus();
                        $(this).valid();
                    }
                    //yearRange: "1990:2030",
                });
                $("#txtDateOfExpiry").datepicker({
                    changeYear: true,
                    changeMonth: true,
                    //yearRange: "1951:2030",
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

                numbers = [];
                // if (p.Customer == 1) {
                companyProf.getmember();
                //  }

            },
            init: function () {
                companyProf.InitialSetup();
                $("#btnExport").click(function (e) {
                    $('.BrandEdit').hide();
                    $('.checkbox').hide();
                    $('.edit').hide();
                    $('#printedDate').show();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    $('#printedDate').hide();
                    let file = new Blob([$('#membeshipformlist').html()], { type: "application/vnd.ms-excel" });
                    let url = URL.createObjectURL(file);
                    let a = $("<a />", {
                        href: url,
                        download: "CustomerList.xls"
                    }).appendTo("body").get(0).click();
                    e.preventDefault();
                    $('#printedDate').hide();
                    $('.BrandEdit').show();
                    $('.checkbox').show();
                    $('.edit').show();
                });
                $('#btnPrint').on('click', function () {
                    Print();
                });

                $('#btnPdf').click(function () {
                    $('#printedDate').show();
                    $('.BrandEdit').hide();
                    $('.checkbox').hide();
                    $('.edit').hide();
                    var dNow = new Date();
                    $('#lblPrintedOn').html(dNow);
                    var options = {
                        background: '#FFF',
                        pagesplit: true,
                    };
                    var pdf = new jsPDF('p', 'pt', 'a4');
                    pdf.internal.scaleFactor = 2.23;
                    pdf.addHTML($("#membeshipformlist"), 0, 0, options, function () {
                        pdf.save('CustomerList.pdf');
                    });
                    $('#printedDate').hide();
                    $('.BrandEdit').show();
                    $('.checkbox').show();
                    $('.edit').show();
                });


                $("#txtCardNumber").change(function () {
                    for (var i = 0; i < checks.length; i++) {
                        if (checks[i] == $("#txtCardNumber").val()) {
                            jAlert("Already Exist: " + checks[i] + "; \n Please Enter a Unique Card Number", "Alert!!", function () { $.alerts.dialogClass = null; });
                            $("#txtCardNumber").val("");
                        }
                    }
                });


                $("#txtPhoneMobile").change(function () {
                    var a = $("#txtPhoneMobile").val();
                    var filter = /^[7-9][0-9]{9}$/;
                    if (filter.test(a)) {
                    }
                    else {
                        alert("not valid mbl number");
                    }
                });
                $("#selLoyalityCardType").change(function () {
                    if ($("#selLoyalityCardType").val() == '1') {
                        $("#txtDiscount").attr("disabled", false);
                    } else {
                        companyProf.GetLoyalityDiscountByCard(parseInt($("#selLoyalityCardType").val()));
                    }

                });

                $("#btnSaveMembershipApplication").on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                        companyProf.SaveMembership();
                    }
                });

                $("#btnCancelItem").click(function () {
                    $("#divForMember").hide();
                    $("#membeshipformlist").show();
                    $(".report-view").show();
                    $(".report-filter").show();
                });

                $('#btnSendSms').on('click', function () {
                    if ($('.checkbox:checked').length > 0) {
                        $("#sendSmsDialog").dialog({
                            'title': 'Send SMS',
                            width: 500,
                            modal: true,
                            resizable: true,
                            dialogClass: 'popup-titlebg'
                        });
                        $(".checkbox:checked").each(function () {
                            var row = $(this).parents('tr');
                            var num = row.find('td:eq(8)').text();
                            numbers.push(num);
                        });
                        $('#mobileNumber').val(numbers);
                        $('#smsMessage').val('Your Message Here.');
                    }
                    else {
                        jAlert('Please Select Customer first.', 'ALERT!!');
                    }
                });

                $('#btnCancel').on('click', function () {
                    $('#mobileNumber').val('');
                    $('#smsMessage').val('');
                    $("#sendSmsDialog").dialog('close');
                    companyProf.InitialSetup();
                });

                $("#btnSend").on('click', function () {
                    companyProf.SendSMS();
                });

                //$("#sendSmsDialog").on("dialogclose", function (event, ui) { companyProf.InitialSetup(); });

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
                        $(".report-filter").hide();
                        break;
                    case 2:
                        jAlert("Update successfully", "Information!!", function () {
                            var mid = getParameterByName("ID", window.location.href);
                            if (mid != null) {
                                parent.document.location.reload(true);
                                window.close();
                            }
                        });
                        $("#divForMember").hide();
                        companyProf.getmember();
                        $(".report-view").show();
                        $(".report-filter").show();
                        break;
                    case 3:
                        Custlist = [];
                        Custlist = JSON.parse(data.d);
                        companyProf.Bindmember();
                        break;
                    case 4:
                        jAlert(data.d, "INFORMATION");
                        $('#mobileNumber').val('');
                        $('#smsMessage').val('');
                        $("#sendSmsDialog").dialog('close');
                        companyProf.InitialSetup();
                        break;
                    case 5:
                        companyProf.BindmemberbyId(data.d);
                        break;
                    case 6:
                        var role = data.d;
                        userRole = role.Roles;
                        break;
                    case 7:
                        if (data.d == 100) {
                            jAlert("This Customer cannot be deleted.", "Information!!", function () { });
                        } else {
                            jAlert("Deleted successfully", "Information!!", function () {
                                companyProf.getmember();
                            });
                        }

                        break;
                    case 8:
                        loyalitylist = JSON.parse(data.d);
                        companyProf.BindCardLoyalityType(data.d);
                        break;
                    case 9:
                        companyProf.BindLoyalityDiscountByCard(data.d);
                        break;
                }
            },
            ajaxFailure: function (data) {

            },


            //-----------------------------------------getdata---------------------------
            GetLoyalityDiscountByCard: function (CardTypeID) {
                companyProf.config.method = "GetLoyalityDiscountByCard";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ CardTypeID: CardTypeID });
                companyProf.config.ajaxCallMode = 9;
                companyProf.ajaxCall(companyProf.config);
            },

            GetCardLoyalityType: function () {
                companyProf.config.method = "GetLoyalityCardType";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.ajaxCallMode = 8;
                companyProf.ajaxCall(companyProf.config);
            },
            DeleteItem: function (id) {
                var RId = id;
                var deletedby = SageFrameUserName;
                companyProf.config.method = "deletemember";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ RId: RId, deletedby: deletedby });
                companyProf.config.ajaxCallMode = 7;

                companyProf.ajaxCall(companyProf.config);
            },

            GetUserName: function () {
                var loggername = SageFrameUserName;
                companyProf.config.method = "GetRolesByUsername";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ username: loggername });
                companyProf.config.ajaxCallMode = 6;
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

            SendSMS: function () {
                var toNumber = $('#mobileNumber').val();
                var textMessage = $('#smsMessage').val();
                companyProf.config.method = "sendSMS";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ to: toNumber, text: textMessage });
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },

            SaveMembership: function () {

                var MemberInfo = {};
                MemberInfo.MembershipID = companyProf.config.MembershipID;
                MemberInfo.Fname = $('#txtFirstName').val();
                MemberInfo.Lname = $('#txtLastName').val();
                MemberInfo.Address = $('#txtAddress').val();
                MemberInfo.City = $('#txtCity').val();
                MemberInfo.Country = $('#txtCountry').val();
                MemberInfo.TelHome = $('#txtPhoneHome').val();
                MemberInfo.TelWork = $('#txtPhoneWork').val();
                MemberInfo.TelMobile = $('#txtPhoneMobile').val();
                MemberInfo.Email = $('#txtEmail').val();
                MemberInfo.Occupation = $('#txtOccupation').val();
                MemberInfo.discount = 0;
                MemberInfo.Company = $('#txtCompany').val();
                MemberInfo.PAN = $('#txtCustPan').val();
                MemberInfo.Birthday = $('#txtBirthday').val();
                MemberInfo.Anniversary = $('#txtAnniversary').val();

                MemberInfo.CardNumber = $('#txtCardNumber').val();
                MemberInfo.DateOfIssue = $('#txtDateOfIssue').val();
                MemberInfo.DateOfExpire = $('#txtDateOfExpiry').val();
                MemberInfo.discount = $('#txtDiscount').val();
                MemberInfo.OpeningBalance = $('#txtOpeningBalance').val();
                MemberInfo.ExtraDetail = $('#txtExtraDetail').val();

                if (MemberInfo.discount == "") {
                    MemberInfo.discount = 0;
                }

                MemberInfo.IsCustomer = true;
                MemberInfo.IsVat = false;
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

            BindLoyalityDiscountByCard: function (result) {
                var datas = JSON.parse(result);
                $("#txtDiscount").val(datas[0].discount);
                $("#txtDiscount").attr("disabled", true);
            },

            BindCardLoyalityType: function (result) {
                var datas = JSON.parse(result);
                $('#selLoyalityCardType').html("");
                var htmls = "";
                $.each(datas, function (index, item) {
                    htmls += "<option value='" + item.CardTypeID + "'>" + item.CardName + "</option>";
                });
                $('#selLoyalityCardType').html(htmls);
            },


            Bindmember: function () {

                debugger;
                $("#membeshipformlist").show();
                $("#membeshipformlist").html('');
                var Roles = userRole.split(",");
                datas = Custlist;
                //JSON.parse(data);
                var htmls = '<p id="printedDate" style="display:none;text-align:center;margin:0;margin-bottom:5px;">Printed On : <label id="lblPrintedOn"></label></p>';
                htmls += "<table id='Brandtable' class='reportsprint' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th><input type='checkbox' class='checkbox'  id='select_all' /></th><th style='width:200px'> Name </th><th style='width:200px'> Address </th><th>PAN</th><th>Card No.</th><th> Extra Info </th><th> Occupation </th><th> Company </th><th> ContactNo.</th><th style='width:90px'> Discount(%) </th><th class='tdrate' style='width:90px'> Opening BAL </th><th class='tdrate' style='width:90px'> RMNG BAL </th><th class='tdrate' style='width:90px'> Total Paid </th>"

                if (Roles.includes("Manager") || Roles.includes("Super User") || Roles.includes("Site Admin")) {
                    htmls += "<th class='edit'>Edit</th>";
                }
                if (Roles.includes("Super User")) {
                    htmls += "<th class='edit'>Delete</th>";
                }
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        var search = $('#txtSearch').val().toLowerCase();
                        if (value.Name.toLowerCase().includes(search) || value.TelMobile.toLowerCase().includes(search) || value.Addresss.toLowerCase().includes(search) || search == '') {
                            htmls += "<tr class='tableItem' id=" + value.MembershipID + "_>";
                            var tel = value.TelMobile;
                            if (tel.length > 0) {
                                htmls += "<td><input type='checkbox' class='checkbox' /></td>";
                            }
                            else {
                                htmls += "<td><span> </span></td>"
                            }
                            htmls += "<td style='width:200px'>" + value.Name + "</td>";
                            htmls += "<td style='width:200px'>" + value.Addresss + "</td>";
                            htmls += "<td style='width:90px'>" + value.PAN + "</td>";
                            htmls += "<td style='width:90px'>" + value.CardNumber + "</td>";
                            htmls += "<td>" + value.ExtraDetail + "</td>";
                            htmls += "<td>" + value.Occupation + "</td>";
                            htmls += "<td>" + value.Company + "</td>";
                            htmls += "<td>" + value.TelMobile + "</td>";
                            htmls += "<td style='width:90px'>" + value.discount + " %</td>";
                            htmls += "<td style='width:90px;text-align:right;'>Rs. " + value.OpeningBalance + "</td>";
                            htmls += "<td style='width:90px;text-align:right;'>Rs. " + value.RemainingBalance + "</td>";
                            htmls += "<td style='width:90px;text-align:right;'>Rs. " + value.UptoNowPaid + "</td>";

                            if (Roles.includes("Manager") || Roles.includes("Super User") || Roles.includes("Site Admin")) {
                                htmls += "<td>" + "<img src='/images/edit.png' class='edit-icon BrandEdit' type='button'  id='" + value.MembershipID + "+" + value.Fname + "+" + value.Lname + "+" + value.Address + "+" + value.City + "+" + value.Country + "+" + value.TelHome + "+" + value.TelWork + "+" + value.TelMobile + "+" + value.Email + "+" + value.Occupation + "+" + value.Company + "+" + value.Birthday + "+" + value.Anniversary + "+" + value.CardNumber + "+" + value.DateOfIssue + "+" + value.DateOfExpire + "+" + value.discount + "+" + value.PAN + "+" + value.IsCustomer + "+" + value.OpeningBalance + "+" + value.ExtraDetail + "' value='Edit'  /></td>";
                            }
                            if (Roles.includes("Super User")) {
                                htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.MembershipID + " value='Delete'  /></td>";
                            }
                            htmls += "</tr>"
                            checks.push(value.CardNumber);
                        }
                    });

                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='12' style='text-align:center;'> No Data </td>";
                    htmls += '</tr>';

                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#membeshipformlist').html(htmls);


                $(".dataTables_scrollBody").css('height', '100%');
                $('#select_all').on('click', function () {
                    if (this.checked) {
                        $('.checkbox').each(function () {
                            this.checked = true;
                        });
                    } else {
                        $('.checkbox').each(function () {
                            this.checked = false;
                        });
                    }
                });

                $('.checkbox').on('click', function () {
                    if ($('.checkbox:checked').length == $('.checkbox').length) {
                        $('#select_all').prop('checked', true);
                    } else {
                        $('#select_all').prop('checked', false);
                    }
                });

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
                    $('#txtExtraDetail').val(words[21]);
                    $.each(loyalitylist, function (index, item) {
                        if (words[17] == item.discount) {
                            $("#selLoyalityCardType").val(item.CardTypeID);
                            $("#selLoyalityCardType").change();
                        }
                    });
                    $(".main").show();
                    $("#divForMember").show();
                    $("#membeshipformlist").hide();
                    $("#tabss").hide();
                    $(".loyaltycheckbox.drawer-radio-btn").hide();
                    $("#btnSendSms").hide();
                    $(".report-view").hide();
                    $(".report-filter").hide();
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
                        }
                    });
                });

            },
            BindmemberbyId: function (result) {
                datas = JSON.parse(result);
                $('#txtPhoneMobile').focus();
                companyProf.config.MembershipID = datas[0].MembershipID;
                $('#txtFirstName').val(datas[0].Fname);
                $('#txtLastName').val(datas[0].Lname);
                $('#txtAddress').val(datas[0].Addresss);
                $('#txtCity').val(datas[0].City);
                $('#txtCountry').val(datas[0].Country);
                $('#txtPhoneHome').val(datas[0].TelHome);
                $('#txtPhoneWork').val(datas[0].TelWork);
                $('#txtPhoneMobile').val(datas[0].TelMobile);
                $('#txtEmail').val(datas[0].Email);
                $('#txtOccupation').val(datas[0].Occupation);
                $('#txtCompany').val(datas[0].Company);
                $('#txtBirthday').val(datas[0].Birthday);
                $('#txtAnniversary').val(datas[0].Anniversary);
                $('#txtCardNumber').val(datas[0].CardNumber);
                $('#txtDiscount').val(datas[0].discount);
                $('#txtCustPan').val(datas[0].PAN);
                $('#txtOpeningBalance').val(datas[0].OpeningBalance);
                $('#txtDateOfIssue').val(datas[0].DateOfIssue);
                $('#txtDateOfExpiry').val(datas[0].DateOfExpire);
                companyProf.config.MembershipIDUpdate = 1;
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
                $('#txtPan').val('');
                $('#txtCustPan').val('');
                $('#txtOpeningBalance').val('0');
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
                        //txtPhoneWork: {
                        //    number: true,
                        //    required: false,
                        //},
                        PhoneMobile: {
                            required: true,
                            number: true,
                            phone: true,
                        },
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
                        //CardNumber: {
                        //    number: true
                        //}
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
