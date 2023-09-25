<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RestoListingView.ascx.cs" Inherits="Modules_RestoListing_RestoListingView" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',
            Username: '<%=Username%>'
        });
    });
</script>
<h4 class="billing-table">Pick Ordered List</h4>
<div id="SortableRestoListing" class="sfModulecontent clearfix">

</div>
<div id="DialogOrderDetail" style="display:none;"></div>