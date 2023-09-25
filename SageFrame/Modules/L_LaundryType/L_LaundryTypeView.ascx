<%@ Control Language="C#" AutoEventWireup="true" CodeFile="L_LaundryTypeView.ascx.cs" Inherits="Modules_L_LaundryType_L_LaundryTypeView" %>

<script>
    $(document).ready(function () {
        $('.gdv').DataTable();

        $('#tabs').tabs();
        });
    </script>
<div id="tabs">
    <ul>
        <li><a href="#tab1">Laundry Type</a>

        </li>
    </ul>
    <div id="tab1">

<div id="dvAddBtn" runat="server">                         
        <asp:Button ID="btnAddLaundryType" runat="server" Text="Add" OnClick="btnAddLaundryType_Click" CssClass="sfLocale icon-addnew sfBtn"/>
</div>

<div runat="server" id="addForm">
    <table style="display:block;">
        <tr>
            <td>
                <asp:Label runat="server" ID="lblLaundryType" >Laundry Type : </asp:Label>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtLaundryType" CssClass="sfInputbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvHeader" Display="Dynamic" runat="server" ErrorMessage="Type is required !!"
                                            ControlToValidate="txtLaundryType" ValidationGroup="btnSave"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
        <td></td>
            <td>
                <asp:Button ID="btnSave" runat="server" ValidationGroup="btnSave" Text="Save" OnClick="btnSave_Click" CssClass="sfLocale icon-save sfBtn"/>
            
    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" CssClass="sfLocale icon-close sfBtn" /></td>
        </tr>
    </table>
</div>
</div>
<div class="thbg">
<asp:GridView ID="gdvLaundryTypeList" CssClass="gdv" runat="server" Width="100%" EmptyDataText="..........No Data Found.........." AutoGenerateColumns="False"
     OnRowCommand="gdvLaundryTypeList_RowCommand"  CellPadding="4" ForeColor="#333333" GridLines="None" OnPreRender="gdvLaundryTypeList_PreRender">
    <AlternatingRowStyle BackColor="White" />
    <Columns>
        <asp:TemplateField HeaderText="S.N">
            <ItemTemplate>
                <%#Container.DataItemIndex+1 %>
            </ItemTemplate>
            <HeaderStyle VerticalAlign="Top" CssClass="sfEdit" />
        </asp:TemplateField>
        <asp:BoundField DataField="Type" HeaderText="Laundry Type" SortExpression="Type" />
        <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="sfEdit">
            <ItemTemplate>
                <asp:LinkButton ID="Edit" CssClass="icon-edit" runat="server" CausesValidation="False"
                     CommandArgument='<%#Eval("ID")%>' 
                    CommandName="laundryType_edit" ImageUrl='<%# GetTemplateImageUrl("imgedit.png", true) %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="sfDelete">
            <ItemTemplate>
                <asp:LinkButton ID="Delete" runat="server" CssClass="icon-delete" CausesValidation="False" CommandArgument='<%#Eval("ID")%>'
                    CommandName="laundryType_delete" ImageUrl='<%# GetTemplateImageUrl("imgdelete.png", true) %>'
                    OnClientClick="return ConfirmDialog(this, 'Confirmation', 'Are you sure you want to delete Laundry Type?');" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EditRowStyle BackColor="#2461BF" />
    <FooterStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
    <RowStyle BackColor="#f5f5f5" HorizontalAlign="Center" />
    <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
    <SortedAscendingCellStyle BackColor="#F5F7FB" />
    <SortedAscendingHeaderStyle BackColor="#6D95E1" />
    <SortedDescendingCellStyle BackColor="#E9EBEF" />
    <SortedDescendingHeaderStyle BackColor="#4870BE" />
</asp:GridView>
</div>
</div>