<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PurchaseOrder.ascx.cs" Inherits="Modules_RoiPurchase_PurchaseOrder" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<br />
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<rsweb:ReportViewer ID="ReportViewer1" Visible="false" runat="server" Font-Names="Verdana" Font-Size="8pt" Height="436px"  WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="731px">
    <LocalReport ReportPath="Modules\RoiPurchase\PurchaseOrderReport.rdlc">
    </LocalReport>
</rsweb:ReportViewer>

<br />

<iframe id="IframeTermscondtion" runat="server" height="1000" width="100%" visible="true"></iframe>
