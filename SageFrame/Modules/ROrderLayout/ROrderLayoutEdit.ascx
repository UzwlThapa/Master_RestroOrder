<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROrderLayoutEdit.ascx.cs" Inherits="Modules_ROrderLayout_ROrderLayoutEdit" %>
<script type="text/javascript">
    $(function () {
        $(this).companyDashboardEDIT({
            HostUrl: '<%=HostUrl%>',
            UserModuleID: '<%=UserModuleID%>'
        });
    });
</script>
<div class="RO_wrapper">
<div id="ROlayout">
        <table style="display:block;">
            <tr>
                <td><asp:Literal ID="ltrLayout" runat="server" /></td>
                <td><asp:Literal ID="ltrRoomForLayout" runat="server" /></td>
            </tr>
        </table>
    <div >
        <div class ='TablesForLayout'></div>
   <label class="sfBtn btnSave restro-btn" >Save</label>
     </div>
    </div>
    </div>