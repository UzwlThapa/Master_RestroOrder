<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TopSixTables.ascx.cs" Inherits="Modules_LandingSummaries_TopSixTables" %>

<script type="text/javascript">
    $(function () {
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + "/Modules/LandingSummaries/webservice/wsLandingSummaries.asmx/getTop6Table",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = data.d;
                var htmls = "";

                if (result.length > 0) {
                    $.each(result, function (index, value) {
                        htmls += '<div class="dbsum-popular-list"><div class="dbsum-item-name">' + value.restroTableTitle + '</div><div class="dbsum-item-percent">' + value.cntTable + '</div></div>';
                    });
                    $("#divTopTables").append(htmls);
                } else {
                    $("#divTopTables").append("No Data!");
                }
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
    });
</script>
<div class="TopSixTables start-right">
<div class="dbsum-title">Top 6 Tables</div>
<div class="dbsum-popular content mCustomScrollbar" id="divTopTables"></div>
</div>