<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ViewBilling.ascx.cs" Inherits="Modules_ROBilling_ViewBilling" %>
<br />
<h4 class="billing-table">Current Order</h4>
<table id="billing-page">
    <tr>
    <td>Room No. : </td>
    <td><asp:DropDownList runat="server" ViewStateMode="Enabled" AutoPostBack="True" ID="ddlRoom" OnSelectedIndexChanged="ddlRoom_SelectedIndexChanged">
         <%--<asp:ListItem Text="Default text" Selected="True" Value="Default value" />--%>
    </asp:DropDownList></td>
        <td>(Select Room Number to Generate Billing Information)</td>
        </tr>
    <tr id="trTable"  runat="server">
    <td>Table No. : </td>
    <td><asp:DropDownList runat="server" ViewStateMode="Enabled" AutoPostBack="True" ID="ddlBillingOrder" OnSelectedIndexChanged="ddlBillingOrder_OnSelectedIndexChanged">
         <asp:ListItem Text="Default text" Selected="True" Value="Default value" />
    </asp:DropDownList></td>
        <td>(Select Table Number to Generate Billing Information)</td>
        </tr>
    </table>
    <asp:Panel runat="server" ID="pnlTable"></asp:Panel>
    <asp:Literal runat="server" ID="ltrBilling"></asp:Literal>

