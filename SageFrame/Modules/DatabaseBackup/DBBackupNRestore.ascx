<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DBBackupNRestore.ascx.cs" Inherits="Modules_DatabaseBackup_DBBackupNRestore" %>

<script>
    $(document).ready(function () {
        resizeIframe();
    });
</script>
<div class="RO_wrapper">

    <div id="tab1">
        <table cellpadding="0" cellspacing="0" border="0" style="display: block;">
            <tr>
                <td align="right">
                    Selected Database :
                </td>
                <td>

                    <asp:Label ID="ddlDatabases" runat="server"></asp:Label>
                </td>
                <td>
                    <asp:Button ID="btnGenerateScript" runat="server" Text="Backup Script..." OnClick="btnBackupScript_Click" CssClass="sfLocale fa fa-hdd-o sfBtn restro-btn" />
                </td>
                <td>
                    <asp:Label ID="lblMessage" ForeColor="Red" runat="server" Text=""></asp:Label>
                </td>
            </tr>
        </table>
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <td style="font-weight: bold; font-size: 16px;">
                    <strong>Backup Databases List:</strong>
                </td>
            </tr>
            <tr>
                <td class="database-physical-path">
                    <asp:DropDownList ID="lstBackupfiles" runat="server" Width="100%" CssClass="sfInputbox"></asp:DropDownList>
                </td>
            </tr>
        </table>
        <asp:Button ID="btnRestore" runat="server" Text="Restore Script..." OnClick="btnRestoreScript_Click" CssClass="sfLocale icon-add sfBtn restro-btn" />
    </div>
</div>
