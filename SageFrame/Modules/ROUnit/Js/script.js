(function ($) {
    var tabs = $("#tabss").tabs();
    $('#tabss').css('display', 'block');
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '/Modules/ROUnit/'
             }, p);
        var v = 0;
        var errorlist = ["Successfully inserted", "ERROR! First and Second Unit Cannot Be Same.",
                        "ERROR! Duplicate Compound Unit Not Valid!", "ERROR! First Unit Already Used As Small Unit!"
        , "ERROR! First and Second Unit Cannot Be Same.", "ERROR! Duplicate Compound Unit Not Valid!"]
        var eventFunction = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ROUnitWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                UnitId: 0,
                Unitupdate: 0,
                Unit1Id: 0,
                Unit1IdUpdate: 0,
                Unit2ID: 0,
                Unit2IDUpdate: 0
            },
            InitialSetup: function () {


            },
            init: function () {

                eventFunction.InitialSetup();
                eventFunction.GetUnit2();
                eventFunction.GetUnit1();
                

                $(".Unit1").hide();
                $(".unit2").hide();
                
                $("#btnadd").on('click', function () {
                    $(".Unit1").show();
                    $("#btnadd , #getUnit1").hide();
                });

                $("#btnUnitadd").on('click', function () {
                    $(".unit2").show();
                    //$("#btnadd").hide();
                    $("#btnUnitadd , #getUnit2 ").hide();
                });

                $("#btnUnit1Cancel").on('click', function () {
                    $(".Unit1").hide();
                    $("#btnadd, #getUnit1").show();
                    //eventFunction.ResetAll();
                    $('#txtUnitDescription').val('');
                    $('#txtSymbol').val('');
                    
                });

                $("#btnUnit2Cancel").on('click', function () {
                    $(".unit2").hide();
                    $("#btnUnitadd , #getUnit2").show();
                    $('#textUnit').val('');
                    $("#ddFirstUnit").val('');
                    $("#txtConversion").val('');
                    $("#ddlSecondtUnit").val('');
                    //eventFunction.ResetAll();
                });

                
                $("#btnUnit2Save").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {

                        eventFunction.UnitSave2();
                    }

                });
                $("#btnUnit1Save").on('click', function () {
                    var checkValid = eventFunction.ValidationForm();
                    if (checkValid) {

                        eventFunction.UnitSave1();
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
                        break;
                    case 1:
                        jAlert('Inserted successfully.', 'Information!!');
                        eventFunction.ResetAll();
                        eventFunction.GetUnit2();
                        eventFunction.GetUnit1();
                        break;
                    case 2:
                        jAlert('Updated successfully.', 'Information!!');
                        eventFunction.ResetAll();
                        eventFunction.GetUnit2();
                        eventFunction.GetUnit1();
                        //location.reload();
                        break;
                    case 3:
                        jAlert('Delete successfully.', 'Information!!');
                        eventFunction.ResetAll();
                        eventFunction.GetUnit2();
                        eventFunction.GetUnit1();
                        break;
                    case 5:
                        var result = JSON.parse(data.d);
                        eventFunction.BindUnit1(result);
                        eventFunction.BindDDUnit(result);
                        break;
                    case 7:
                        jAlert(data.d, 'Information!!');
                        eventFunction.InitialSetup();
                        //alert(errorlist[data.ErrorBit]);
                        break;
                    case 8:
                        eventFunction.BindUnit2(data.d);
                        break;

                }
            },
            ajaxFailure: function () {
                switch (parseInt(eventFunction.config.ajaxCallMode)) {
                    case 1:
                        jAlert('Duplicate UnitName   Not Valid', 'Alert!!');

                        break;
                    case 3:
                        jAlert('Cannot Be Delete..Depends on other', 'Alert!!');
                        break;
                }
            },

            //<<-----------------------------Post & Get Here ---------------------------------------->>
            UnitSave1: function () {
                var UnitInf = {};
                UnitInf.Unit1Id = eventFunction.config.Unit1Id;
                UnitInf.UnitDescription = $('#txtUnitDescription').val();
                UnitInf.Symbol = $('#txtSymbol').val();
                eventFunction.config.method = "Unit1Save1Todatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ UnitInf: UnitInf });
                if (eventFunction.config.Unit1IdUpdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.Unit1Id = 0;
                eventFunction.config.Unit1IdUpdate = 0;
            },
            UnitSave2: function () {
                var UnitInf = {};
                UnitInf.Unit2ID = eventFunction.config.Unit2ID;
                UnitInf.FirstUnit = $('#ddFirstUnit').val();
                UnitInf.Conversion = $('#txtConversion').val();
                UnitInf.SecondUnit = $('#ddlSecondtUnit').val();
                eventFunction.config.method = "Unit1Save2Todatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ UnitInf: UnitInf });
                if (eventFunction.config.Unit2IDUpdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.Unit2ID = 0;
                eventFunction.config.Unit2IDUpdate = 0;
            },


            GetUnit2: function () {
                eventFunction.config.method = "GetUnit2fromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 8;
                eventFunction.ajaxCall(eventFunction.config);
            },

            GetUnit1: function () {
                eventFunction.config.method = "GetUnit1fromDatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = eventFunction.config.data;
                eventFunction.config.ajaxCallMode = 5;
                eventFunction.ajaxCall(eventFunction.config);
            },

            UnitSave: function () {
                var UnitInf = {};

                UnitInf.UnitID = eventFunction.config.UnitId;
                UnitInf.UnitName = $('#textUnit').val();
                eventFunction.config.method = "UnitSaveTodatabase";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON2.stringify({ UnitInf: UnitInf });

                if (eventFunction.config.Unitupdate == 1) {
                    eventFunction.config.ajaxCallMode = 2;
                } else {
                    eventFunction.config.ajaxCallMode = 1;
                }

                eventFunction.ajaxCall(eventFunction.config);
                eventFunction.config.Unitupdate = 0;
            },



            DeleteUnit1: function (item) {
                var id = parseInt(item.id.split("_")[1])
                $(item).closest('tr').remove();
                var UnitID1 = id;
                eventFunction.config.method = "UnitDelete1";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ UnitID1: UnitID1 });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },
            DeleteUnit2: function (item) {
                var id = parseInt(item.id.split("_")[1]);
                $(item).closest('tr').remove();
                var isFrist = item.id.split("_")[0];
                var UnitID2 = id;
                eventFunction.config.method = "UnitDelete2";
                eventFunction.config.url = eventFunction.config.baseURL + eventFunction.config.method;
                eventFunction.config.data = JSON.stringify({ UnitID2: UnitID2, IsFrist: isFrist });
                eventFunction.config.ajaxCallMode = 3;
                eventFunction.config.ID = id;
                eventFunction.ajaxCall(eventFunction.config);
            },

            //<<-----------------------------------BindTable Herere ------------------------------------->>>
            BindUnit2: function (data) {
                $("#getUnit2").show();
                $("#getUnit2").html('');
                datas = JSON.parse(data);
                var htmls = "<table id='unittableSecond' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Large Unit</th><th>Large Unit Symbol</th> <th>Small Unit</th><th>Small Unit Symbol</th><th>Conversion</th><th class='edit-heading tdcenter' style='width:20px;'>Edit</th><th class='delete-heading tdcenter' style='width:20px;'>Delete</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"

                if (datas.length > 0) {              
                    $.each(datas, function (index, value) {
                        if (value.Conversion > 1) {
                            htmls += "<tr class='tableItem' id='" + value.UnitID + "'>";
                            htmls += "<td>" + value.FirstUnit + "</td>";
                            htmls += "<td>" + value.FirstUnitCode + "</td>";
                            htmls += "<td>" + value.SecondUnit + "</td>";
                            htmls += "<td>" + value.SecondUnitCode + "</td>";
                            htmls += "<td>" + value.Conversion + "</td>";
                            htmls += "<td class='tdcenter'>" + "<img src='/images/edit.png' class='UnitEdit2 edit-icon'  type='button'  id='" + value.UnitID + "_" + value.FirstUnitID + "_" + value.SecondUnitID + "_" + value.Conversion + "_" + value.FirstUnit + "_" + value.FirstUnitCode + "_" + value.IsFirst + "' value='Edit' /></td>";
                            htmls += "<td class='tdcenter'>" + "<img src='/images/delete.png' class='UnitDelete2 delete-icon' type='button'  id=_" + value.UnitID + " value='Delete' /></td>";
                            htmls += "</tr>"
                        }
                    });
                } else {
                    $('#getUnit2').html('No data');
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#getUnit2').html(htmls);
                    $('#unittableSecond').DataTable(
                         {
                            
                              columnDefs: [{ orderable: false, targets: [ 5, 6] }],
                              "lengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                                "pageLength": 20,
                             "jQueryUI": true,
                         });

              
                $("#unittableSecond").on('click', '.UnitEdit2', function () {
                    
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    if (words[6] == 'true') {
                        
                        eventFunction.config.Unit1Id = parseInt(words[0]);
                        var k = $('#tabs a[href="#tabs-1"]').parent().index();
                        $("#tabs").tabs("option", "active", k);

                        $(".Unit1").show();
                        $("#getUnit2").hide();

                        $("#txtUnitDescription").val(words[4]);
                        $("#txtSymbol").val(words[5]);
                        eventFunction.config.Unit1IdUpdate = 1;
                        $("#btnadd, #getUnit2").hide();
                        
                        
                    }
                    else {
                        eventFunction.config.Unit2ID = parseInt(words[0]);
                        var k = $('#tabs a[href="#tabs-2"]').parent().index();
                        $("#tabs").tabs("option", "active", k);
                        $(".unit2").show();
                        $("#ddFirstUnit").val(words[1]);
                        $("#ddlSecondtUnit").val(words[2]);
                        $("#txtConversion").val(words[3]);
                        eventFunction.config.Unit2IDUpdate = 1;
                        $("#btnUnitadd").hide();
                        $("#getUnit2").hide();
                    }
                   

                });
                $("#getUnit2").on('click', '.UnitDelete2', function () {
                    //$(".UnitDelete2").on('click', function () {

                    eventFunction.DeleteUnit2(this);
                    eventFunction.ResetAll();
                    
                });

            },


            BindUnit1: function (datas) {
                $("#getUnit1").show();
                $("#getUnit1").html('');
                var htmls = "<table id='unittable' class='sfGridwrapper display' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Unit Description</th><th>Symbol</th><th class='edit-heading tdcenter' style='width:20px;'>Edit</th><th class='delete-heading tdcenter' style='width:20px;'>Delete</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        htmls += "<tr class='tableItem' id=" + value.Unit1Id + "_>";
                        htmls += "<td>" + value.UnitDescription + "</td>";
                        htmls += "<td>" + value.Symbol + "</td>";
                        htmls += "<td class='tdcenter'>" + "<img src='/images/edit.png' class='edit-icon UnitEdit1'  type='button'  id='" + value.Unit1Id + "_" + value.UnitDescription + "_" + value.Symbol+ "' value='Edit' /></td>";
                        htmls += "<td class='tdcenter'>" + "<img src='/images/delete.png' class='delete-icon UnitDelete1' type='button'  id=_" + value.Unit1Id + " value='Delete' /></td>";
                        htmls += "</tr>"

                    });
                } else {
                    $('#getUnit1').html('No Data Available');
               
                }
                    htmls += "</tbody>";
                    htmls += "</table>";
                    $('#getUnit1').html(htmls);
                    $('#unittable').DataTable(
                         {
                             "jQueryUI": true,
                             columnDefs: [{ orderable: false, targets: [ 2, 3] }],
                             "lengthMenu": [[20, 50, 100, -1], [20, 50, 100, "All"]],
                        "pageLength": 20,
                         });

                
                $('#unittable').on('click', ".UnitEdit1", function () {
                    $(".Unit1").show();
                    $("#getUnit1").hide();
                    $("#btnadd").hide();
                    var ids = $(this).attr('id');
                    var words = ids.split('_');
                    eventFunction.config.Unit1Id = words[0];
                    $("#txtUnitDescription").val(words[1]);
                    $("#txtSymbol").val(words[2]);
                    eventFunction.config.Unit1IdUpdate = 1;

                });
                $('#unittable').on('click', ".UnitDelete1", function () {
                    
                    eventFunction.DeleteUnit1(this);
                    eventFunction.ResetAll();
                });

            },
            BindDDUnit: function (datas) {
                $(".fsUnit").html('');

                if (datas.length > 0) {
                    var htmls = '';
                    htmls = "<option value='' disabled selected>-Select-</option>";
                    $.each(datas, function (index, value) {
                        htmls += "<option value='" + value.Unit1Id + "'>" + value.UnitDescription + "</option>";
                    });

                    $(".fsUnit").html(htmls);
                }

            },

            

          

            ResetAll: function () {
                $('.unit2').hide();
                $('#btnadd,#btnUnitadd').show();
                $('.Unit1').hide();
                $('#btnadd,#btnUnitadd').show();

                //Unit
                $('#textUnit').val('');
                $('#txtUnitDescription').val('');
                $('#txtSymbol').val('');
                $("#ddFirstUnit").val('');
                $("#txtConversion").val('');
                $("#ddlSecondtUnit").val('');
                // eventFunction.GetUnit2();
                //eventFunction.GetUnit1();
                eventFunction.config.Unit2ID = 0;
                eventFunction.config.Unit2IDUpdate = 0;
              
            },

            ValidationForm: function () {
                v = $('#form1').validate({
                    rules: {

                        //StoreItem
                        textUnit: {
                            required: true,
                        },
                        Conversion: {
                            required: true,
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
        eventFunction.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);
