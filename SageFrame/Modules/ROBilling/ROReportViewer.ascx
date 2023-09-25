<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROReportViewer.ascx.cs" Inherits="Modules_ROBilling_ROReportViewer" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<asp:ScriptManager ID="sm1" runat="server"></asp:ScriptManager>
<br />
<h4 class="billing-table">Customer Report</h4>
<table id="billing-page">


    <tr>
        <td>Room No. : </td>
        <td>
            <asp:DropDownList runat="server" ViewStateMode="Enabled" AutoPostBack="True" ID="ddlRoom" OnSelectedIndexChanged="ddlRoom_SelectedIndexChanged">
            </asp:DropDownList></td>
        <td>(Select Room Number to Generate Billing Information)</td>
    </tr>

    <tr>
        <td>Table No. : </td>
        <td>
            <asp:DropDownList runat="server" ViewStateMode="Enabled" AutoPostBack="True" ID="ddlBillingOrder" OnSelectedIndexChanged="ddlBillingOrder_OnSelectedIndexChanged">
            </asp:DropDownList></td>
        <td>(Select Table Number to Print Billing Information)</td>
    </tr>
    <asp:Panel runat="server" ID="pnlSeatNumber" Visible="false">

        <tr>
            <td>Seat No. : </td>
            <td>
                <asp:DropDownList runat="server" ViewStateMode="Enabled" AutoPostBack="True" ID="ddlSeatNumber" OnSelectedIndexChanged="ddlSeatNumber_SelectedIndexChanged">
                </asp:DropDownList></td>
            <td>
                <asp:CheckBox ID="chkReport" runat="server" Text="Print All Report" /><asp:Button ID="btnAllReport" runat="server" Text="Print All" OnClick="btnAllReport_Click" /></td>
        </tr>
    </asp:Panel>
</table>

<asp:ImageButton AlternateText="Print" ID="btnPrint" runat="server" Style="border: none !important; outline: none !important" OnClick="btnPrint_Click" CssClass="print-button" />


<asp:SqlDataSource ID="SqlDataSource1" runat="server"></asp:SqlDataSource>

<iframe id="frmPrint" name="IframeName" width="500" height="200" runat="server" style="display: none"></iframe>


<rsweb:ReportViewer ID="ReportViewer1" ShowPageNavigationControls="false" ShowToolBar="false" runat="server" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="100%">
    <LocalReport ReportPath="Modules\ROBilling\Report.rdlc">
    </LocalReport>
</rsweb:ReportViewer>
