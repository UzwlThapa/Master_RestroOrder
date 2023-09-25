function IntegerAndDecimal(evt, element) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode != 8) &&
        (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
        (charCode < 48 || charCode > 57))
        return false;
    return true;
}

(function ($) {
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
        var companyProf = {
            config: {
                isPostBack: false,
                async: false,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "LoyalityCardWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                CardTypeID: 0,
                CardTypeIDUpdate: 0

            },
            InitialSetup: function () {
               companyProf.GetCardLoyalityType();              
            },
            init: function () {
                companyProf.InitialSetup();
                
                $("#btnAddLoyalityCard").on("click", function (event) {
                    $("#divForcard").show();
                    $("#btnAddLoyalityCard").hide();
                    $("#divLoyalityCardType").hide();
                });

                $("#btnCancelCard").on("click", function (event) {
                    $("#divForcard").hide();
                    $("#btnAddLoyalityCard").show();
                    $("#divLoyalityCardType").show();
                });

                $("#btnSaveCard").on("click", function (event) {
                    var checkValid = companyProf.ValidationForm();
                    if (checkValid) {
                       companyProf.SaveCardType();
                    }
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
                        companyProf.ResetForm();
                        companyProf.GetCardLoyalityType();
                        break;
                    case 2:
                        jAlert("Update successfully", "Information!!", function () {
                            companyProf.ResetForm();
                            companyProf.GetCardLoyalityType();
                        });
                   
                        break;
                    case 3:
                        companyProf.BindCardLoyalityType(data.d);
                        break;
                    case 4:
                        jAlert("Deleted successfully", "Information!!", function () {
                            companyProf.ResetForm();
                            companyProf.GetCardLoyalityType();
                        });
                        break;
                }
            },
            ajaxFailure: function (data) {

            },


            //-----------------------------------------getdata---------------------------

            DeleteLoyalityCardType: function (CardTypeID) {
                var CardTypeID = CardTypeID;
                companyProf.config.method = "DeleteLoyalityCardType";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON.stringify({ CardTypeID: CardTypeID });
                companyProf.config.ajaxCallMode = 4;
                companyProf.ajaxCall(companyProf.config);
            },

            GetCardLoyalityType: function () {
                companyProf.config.method = "GetLoyalityCardType";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.ajaxCallMode = 3;
                companyProf.ajaxCall(companyProf.config);
            },

            SaveCardType: function () {

                var CardInfo = {};
                CardInfo.CardTypeID = companyProf.config.CardTypeID;
                CardInfo.CardName = $('#txtName').val();
                CardInfo.Description = $('#txtDescription').val();
                CardInfo.discount = $('#txtDiscount').val();
                companyProf.config.method = "SaveLoyalityCard";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({ CardInfo: CardInfo });
                if (companyProf.config.CardTypeIDUpdate == 1) {
                    companyProf.config.ajaxCallMode = 2;
                } else {
                    companyProf.config.ajaxCallMode = 1;
                }
                companyProf.ajaxCall(companyProf.config);
                companyProf.config.CardTypeIDUpdate = 0;
            },

            //---------------------------------------------BindData----------------------------------------------------------------------

            BindCardLoyalityType: function (data) {
                $("#divLoyalityCardType").html('');
                var  datas = JSON.parse(data);
                var htmls = '';
                htmls += "<table id='Brandtable' class='reportsprint' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>CardType Name </th><th>Description</th><th>Discount</th>";
                htmls += "<th class='edit'>Edit</th>";
                htmls += "<th class='edit'>Delete</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        if (value.Description != 'None') {
                            htmls += "<tr class='tableItem'>";
                            htmls += "<td>" + value.CardName + "</td>";
                            htmls += "<td>" + value.Description + "</td>";
                            htmls += "<td>" + value.discount + "</td>";                           
                            htmls += "<td>" + "<img src='/images/edit.png' class='edit-icon BrandEdit' type='button'  id='" + value.CardTypeID + "+" + value.CardName + "+" + value.Description + "+" + value.discount + "' value='Edit'  /></td>";
                            htmls += "<td>" + "<img src='/images/delete.png' class='BrandDelete' type='button'  id=_" + value.CardTypeID + " value='Delete'  /></td>";
                            }
                        htmls += "</tr>";
                    });

                } else {
                    htmls += "<tr>";
                    htmls += "<td colspan='5' style='text-align:center;'> No Data Available</td>";
                    htmls += '</tr>';

                }
                htmls += "</tbody>";
                htmls += "</table>";
                $('#divLoyalityCardType').html(htmls);

                $("#divLoyalityCardType").on('click', '.BrandEdit', function (event) {
                    var ids = $(this).attr('id');
                    var words = ids.split('+');
                    companyProf.config.CardTypeID = words[0];
                    $('#txtName').val(words[1]);
                    $('#txtDescription').val(words[2]);
                    $('#txtDiscount').val(words[3]);
                    $("#divForcard").show();
                    $("#btnAddLoyalityCard").hide();
                    $("#divLoyalityCardType").hide();
                    companyProf.config.CardTypeIDUpdate = 1;
                });

                $("#divLoyalityCardType").on('click', '.BrandDelete', function (event) {
                    var deletedata = $(this).attr('id');
                    var ids = deletedata.split('_');
                    var id = parseInt(ids[1]);

                    jConfirm('Are You Sure You Want To Delete?', 'Confirmation Dialog', function (r) {
                        if (r) {
                            companyProf.DeleteLoyalityCardType(id);
                        }
                    });
                });

            },
         

            ResetForm: function () {
                $('#txtName').val('');
                $('#txtDescription').val('');
                $('#txtDiscount').val('');
                companyProf.config.CardTypeID = 0;
                companyProf.config.CardTypeIDUpdate = 0;
                $("#divForcard").hide();
                $("#btnAddLoyalityCard").show();
                $("#divLoyalityCardType").show();
            },
            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {
                        txtName: {
                            required: true,
                        },

                        txtDiscount: {
                            required: true,
                        },

                        txtDescription: {
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
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);