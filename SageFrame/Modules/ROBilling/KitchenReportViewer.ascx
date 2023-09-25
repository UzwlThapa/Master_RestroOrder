
<%@ Control Language="C#" AutoEventWireup="true" CodeFile="KitchenReportViewer.ascx.cs" Inherits="Modules_ROBilling_KitchenReportViewer" %>


<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>
<asp:ScriptManager runat="server"></asp:ScriptManager>
<br />
<h4 class="billing-table">Kitchen Report</h4>
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
<td><asp:DropDownList runat="server" ViewStateMode="Enabled" AutoPostBack="True" ID="ddlBillingOrder" OnSelectedIndexChanged="ddlBillingOrder_OnSelectedIndexChanged">
       
    </asp:DropDownList></td>
          <td>(Select Table Number to Print Billing Information)</td>
        </tr>
    </table>

<%--Restro Order Report
<asp:ImageButton ImageUrl="~/Modules/Logo/image/printpdf.png" AlternateText="Print" ID="btnPrint" runat="server" OnClick="btnPrint_Click" Height="37px" Width="73px"  />


    <rsweb:ReportViewer ShowToolBar="false"  ID="ReportViewer1"  runat="server" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="100%" EnableViewState="true" ShowPrintButton="true" ShowPageNavigationControls="false" BackColor="#CCCCCC">
        <LocalReport ReportPath="Modules/ROBilling/Report.rdlc">
            
        </LocalReport>
    </rsweb:ReportViewer>
    --%>
<iframe id="frmPrint" name="IframeName" width="500" height="200" runat="server" style="display: none" ></iframe>
    

<asp:ImageButton AlternateText="Print" ID="btnKitchenPrint" runat="server" OnClick="btnKitchenPrint_Click"  CssClass="print-button" />


    <rsweb:ReportViewer ShowToolBar="false"  ID="ReportViewer2"  runat="server" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="100%" EnableViewState="true" ShowPrintButton="true" ShowPageNavigationControls="false" BackColor="#CCCCCC">
        <LocalReport ReportPath="Modules/ROBilling/KitchenReport.rdlc">
            
        </LocalReport>
    </rsweb:ReportViewer>

<%--<iframe id="Iframe1" name="IframeName" width="500" height="200" runat="server" style="display: none" ></iframe>--%>
