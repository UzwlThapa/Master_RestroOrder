<%@ Control Language="C#" AutoEventWireup="true" CodeFile="UnpaidBills.ascx.cs" Inherits="Modules_UnPaid_Bills_UnpaidBills" %>

<script type="text/javascript">

    $(function () {
        $(this).companyDashboardEDIT({
            HostUrl: "<%= HostUrl %>",
            TypeId: "<%=TypeId%>",
            numpin: "<%=numpin%>"
        });

    });
</script>

<div class="RO_wrapper"><div id="UnpaidBills" style="padding:10px;"></div></div>
<div id="MembershipPopTable"></div>
<div id="membeshipformlist" style="display:none;"></div>
<div id="membeshipformlist2" style="display:none;"></div>

<div id="BillingView" style="display:none;">
    
   
    <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right:2px;">Print</button>
    <div id='customer-bill' style='text-align:center;width:100%;'></div>
</div>