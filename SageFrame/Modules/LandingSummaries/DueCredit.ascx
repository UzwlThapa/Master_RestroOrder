<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DueCredit.ascx.cs" Inherits="Modules_LandingSummaries_DueCredit" %>

<script type="text/javascript">
    $(function () {
        $.ajax({
            type: "POST",
            async: false,
            cache: false,
            url: SageFrameHostURL + "/Modules/LandingSummaries/webservice/wsLandingSummaries.asmx/getDueCredit",
            data: "",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var result = data.d;
                var htmls = "";

                htmls += '<table id="tblDue" class="sfGridwrapper"><thead><tr><th>Customer</th><th class="tdrate">Due Balance</th></thead><tbody>';
                if (result.length > 0) {
                    $.each(result, function (index, value) {
                        htmls += '<tr><td>' + value.Name + '</td><td class="tdrate"> Rs. ' + value.RemainingBalance.toFixed(2) + '</td>';
                    });
                } else {
                    htmls += 'No Data';
                }
                htmls += '</tbody></table>';
                $("#divDueCredit").append(htmls);
            },
            failure: function (response) {
                jAlert("Sorry some error occured. Contact the support team.", "Error!!");
            }
        });
    });
    
</script>
<div class="duecredit start-right">
<div class="dbsum-title">Due Credits</div>
<div class="dbsum-popular mCustomScrollbar" id="divDueCredit"></div>
</div>