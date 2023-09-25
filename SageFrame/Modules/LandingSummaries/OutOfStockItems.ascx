<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OutOfStockItems.ascx.cs" Inherits="Modules_LandingSummaries_OutOfStockItems" %>

<script type="text/javascript">
    $(function () {
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + "/Modules/LandingSummaries/webservice/wsLandingSummaries.asmx/getOutOfStockItems",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = data.d;
                var htmls = "";

                htmls += '<table id="tblStock" class="sfGridwrapper"><thead><tr><th>Store</th><th>Item</th><th>Remaining</th></thead><tbody>';
                if (result.length > 0) {
                    $.each(result, function (index, value) {
                        htmls += '<tr><td>' + value.StName + '</td><td>' + value.ITName + '</td><td>' + value.CLBal + ' ' + value.Symbol + '</td>';
                    });
                } else {
                    htmls += 'No Data';
                }
                htmls += '</tbody></table>';
                $("#divOutOfStock").append(htmls);
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
    });
</script>
<div class="OutOfStock start-right">
<div class="dbsum-title">Out Of Stock Items</div>
<div class="dbsum-popular mCustomScrollbar" id="divOutOfStock"></div>
</div>