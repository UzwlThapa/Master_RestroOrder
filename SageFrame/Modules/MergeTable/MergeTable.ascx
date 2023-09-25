<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MergeTable.ascx.cs" Inherits="Modules_MergeTable_MergeTable" %>

<script type="text/javascript">

    $(function () {
        $(this).companyDashboardEDIT({
            HostUrl: "<%= HostUrl %>",
        });
         // resizeIframe();

    });
</script>
<div class="RO_wrapper">


<div id="divForRoomTableMerge">
        <table style="display:block;">
            <tr>
                <asp:Literal ID="ltrMerge" runat="server" />
                <asp:Literal ID="ltrRoomForMerge" runat="server" />
            </tr>
        </table>
    <div >
        <div class ='TablesForMerge' style="display:none;"></div>
   
    <label class="sfBtn btnMerge restro-btn" style="display:none;">Merge Tables</label>
     </div>
    </div>
    </div>
