<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TopSixItems.ascx.cs" Inherits="Modules_LandingSummaries_TopSixItems" %>

<script type="text/javascript">
    $(function () {
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + "/Modules/LandingSummaries/webservice/wsLandingSummaries.asmx/getTop6Item",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = data.d;
                var htmls = "";

                if (result.length > 0 && result[0].cntItem != -1) {
                    var total = 0;
                    $.each(result, function (index, value) {
                        //if (value.cntItem != -1) {
                        if (index == 0) {
                            total = value.cntItem;
                        } else {
                            htmls += '<div class="dbsum-popular-list"><div class="dbsum-item-name">' + value.ITName + '</div>';
                            //htmls += '<div class="dbsum-item-percent" style="margin-right:5px;">' + value.cntItem + '</div>';
                            htmls += '<div class="dbsum-item-percent">' + (value.cntItem / total * 100).toFixed(2) + '%</div></div>';
                        }
                        //} else {
                        //    $(".dbsum-items-listing").append("No Data!");
                        //}
                    });
                    $("#divTopItems").append(htmls);
                } else {
                    $("#divTopItems").append("No Data!");
                }
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
    });
</script>
<div class="TopSixItems start-right">
<div class="dbsum-title">Top 6 Items</div>
<div class="dbsum-popular mCustomScrollbar" id="divTopItems"></div>
</div>