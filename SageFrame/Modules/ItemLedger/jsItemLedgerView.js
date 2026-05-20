(function ($) {
    var tabs = $("#tabs").tabs();
    var deletecount = 0;
    $.companyProfcreate = function (p) {
        p = $.extend
             ({
                 UserModuleID: '',
                 ModulePath: '',
                 Username: ''
             }, p);
        var v = 0;
        var AutocompleteItem = [];
        var DeleteArray = [];
        var name = [];
        var companyProf = {
            config: {
                isPostBack: false,
                async: true,
                cache: false,
                type: 'POST',
                contentType: "application/json; charset=utf-8",
                data: {},
                dataType: 'json',
                baseURL: p.ModulePath + "ItemLedgerWebService.asmx/",
                method: "",
                url: "",
                ajaxCallMode: 0,
                CustomerId: 0,
                Customerupdate: 0,


            },
            InitialSetup: function () {
                companyProf.GetItemForAutocomplete();
            },
            init: function () {

                companyProf.InitialSetup();
                $("#itemName").click(function () {
                    $("#itemName").autocomplete({
                        source: AutocompleteItem,
                        delay: 0,
                        select: function (event, ui) {
                            var ids = ui.item.id;
                            $("#dd_itemName").val(ids);
                            
                        }
                    });
                });


                $("#btnView").click(function () {
                    companyProf.GetItemLedger();
                  
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
                        companyProf.BindDropdwonItem(data.d);
                        break;
                    case 1:
                        companyProf.BindItemLedger(data.d);
                        break;
    
                }
            },
            ajaxFailure: function () {



            },

            GetItemForAutocomplete: function () {
                companyProf.config.method = "GetItemForSearch";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = companyProf.config.data;
                companyProf.config.ajaxCallMode = 0;
                companyProf.ajaxCall(companyProf.config);
            },


            GetItemLedger: function () {
                var itemid = $("#dd_itemName").val() == "" ? 0 : $("#dd_itemName").val();
                var datefrom = $("#txtStartDate").val();
                var dateTo = $("#txtEndDate").val();
             
                companyProf.config.method = "getItemledger";
                companyProf.config.url = companyProf.config.baseURL + companyProf.config.method;
                companyProf.config.data = JSON2.stringify({
                    itemId: itemid, startDate: datefrom, endDate: dateTo
                });
                companyProf.config.ajaxCallMode = 1
                companyProf.ajaxCall(companyProf.config);
            },


            GetSummarySalesReport: function () {

                if ($("#selroom").val() == '') {
                    var room = $("#selroom").val();
                }
            },
            BindDropdwonItem: function (result) {
                datas = JSON.parse(result);
                if (datas.length > 0) {
                    $.each(datas, function (index, value) {
                        {
                            AutocompleteItem.push({ label: value.ITName, id: value.ITId });
                        }
                      
                    });

                }
            },
           
            BindItemLedger: function (result) {
                $("#divItemledger").show();
                $("#divItemledger").html('');
             
                var salesQuantity = 0.0;
                var purchaseQuantity = 0.0;
                var complimentryQty = 0.0;
                var adjustmentQuantity = 0.0;
                var purchaseReturnQuantity = 0.0;
                //var balanceQty = 0.0;
                ledger = JSON.parse(result);
                var htmls = "";
                var htmls = "<table id='Brandtable' class='reportsprint' cellspacing='0'>"
                htmls += "<thead>"
                htmls += "<tr>"
                htmls += "<th>Date</th><th>Item Name</th><th> Sales Quantity </th><th> Purchase Quantity </th><th> Adjustment Quantity </th><th> Complimentry </th><th> Purchase Return </th><th> Balance</th><th> Unit Description</th>";
                htmls += "</tr>"
                htmls += "</thead>"
                htmls += "<tbody>"
                if (ledger.length > 0) {
                    htmls += "<tbody>"
                    $.each(ledger, function (index, value) {
                        var date = value.Date;
                        var split = date.split("T");
                        var dta = split[0];

                        salesQuantity += value.SalesQty;
                        purchaseQuantity += value.PurchaseQty;
                        complimentryQty += value.Complimentry;
                        adjustmentQuantity += value.Adjustment;
                        purchaseReturnQuantity += value.PurchaseReturn;
                        //balanceQty += value.Balance;

                        htmls += "<tr>";
                        htmls += "<td>" + dta + "</td>";
                        htmls += "<td>" + value.Item + "</td>";
                        if (value.SalesQty == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + value.SalesQty + "</td>";
                        }
                        if (value.PurchaseQty == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + value.PurchaseQty + "</td>";
                        }

                        if (value.Adjustment == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + value.Adjustment + "</td>";
                        }

                        if (value.Complimentry == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + value.Complimentry + "</td>";
                        }

                        if (value.PurchaseReturn == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + value.PurchaseReturn + "</td>";
                        }

                        if (value.Balance == 0) {
                            htmls += "<td>-</td>";
                        } else {
                            htmls += "<td>" + value.Balance + "</td>";
                        }                      
                        htmls += "<td>" + value.Unit + "</td>";
                 
                        htmls += "</tr>"
                    });
                    htmls += "</tbody>";
                    htmls += `<tr><td></td><td>Total</td><td>${salesQuantity}</td><td>${purchaseQuantity}</td>
                                <td>${adjustmentQuantity}</td><td>${complimentryQty}</td><td>${purchaseReturnQuantity}</td><td></td><td></td></tr>`;
                }

                else {
                    $('#divItemledger').html('No data');
                }
                //htmls += "</tbody>";
                htmls += "</table>";
                $('#divItemledger').html(htmls);
 
            },
           

        };
        companyProf.init();
    };
    $.fn.companyProfEDIT = function (p) {
        $.companyProfcreate(p);
    };
})(jQuery);


