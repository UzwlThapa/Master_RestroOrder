<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GoodsReceivedRe.ascx.cs" Inherits="Modules_ROIGoodsReceive_GoodsReceivedRe" %>
<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<br />
<asp:ScriptManager ID="ScriptManager1" runat="server">
</asp:ScriptManager>
<rsweb:ReportViewer ID="ReportViewer1" Visible="false" runat="server" Font-Names="Verdana" Font-Size="8pt" Height="436px" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="731px">
    <localreport reportpath="Modules\ROIGoodsReceive\GoodsRecievedReport.rdlc">
    </localreport>
</rsweb:ReportViewer>

<br />

<iframe id="IframeTermscondtion" runat="server" height="1000" width="100%" visible="true"></iframe>

