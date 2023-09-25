<%@ Control Language="C#" AutoEventWireup="true" CodeFile="L_LaundryRateView.ascx.cs" Inherits="Modules_L_LaundryRate_L_LaundryRateView" %>

<script type='text/javascript'>
    $(function () {
        $('#ddlCloth').change(function () {
            var value = $("#ddlCloth").val();
            $("#hfClothTypeID").val(value);
        });
    });
    $(function() {
        $('#ddlLaundryType').change(function () {
            var value = $("#ddlLaundryType").val();
            $("#hfLaundryTypeID").val(value);
            //console.log(value);

        });
    });

</script>
<script>
    $(document).ready(function () {
        $('.gdv').DataTable();
        $('#tabs').tabs();
        });
    </script>
<div id="tabs">
    <ul>
        <li><a href="#tab1">Laundry Rate</a>

        </li>
    </ul>
    <div id="tab1">
<div id="dvAddBtn" runat="server">                         
        <asp:Button ID="btnAddLaundryRate" runat="server" Text="Add" OnClick="btnAddLaundryRate_Click" CssClass="sfLocale icon-addnew sfBtn"/>
</div>

<div runat="server" id="addForm">
    <table style="display:block;">
        <tr>
            <td>
                <asp:Label runat="server" ID="lblCloth" >Cloth : </asp:Label>
            </td>
            <td>
                <asp:DropDownList ClientIDMode="Static" runat="server" ID="ddlCloth" Cssclass="sfInputbox" style="width:200px;"></asp:DropDownList>
                <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfClothTypeID" Value="" />

            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ClientIDMode="Static" runat="server" ID="lblLaundryType" >Laundry Type : </asp:Label>
            </td>
            <td>
                <asp:DropDownList ClientIDMode="Static" runat="server" ID="ddlLaundryType" Cssclass="sfInputbox" style="width:200px;"></asp:DropDownList>
                <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfLaundryTypeID" Value="" />

            </td>
        </tr>
        <tr>
            <td>
                <asp:Label runat="server" ID="lblRate" >Rate : </asp:Label>
            </td>
            <td>
                <asp:TextBox runat="server" ID="txtRate" Cssclass="sfInputbox"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvHeader" Display="Dynamic" runat="server" ErrorMessage="Rate is required !!"
                            ControlToValidate="txtRate" ValidationGroup="btnSave"></asp:RequiredFieldValidator>
                 <asp:RegularExpressionValidator ID="rgx" ControlToValidate="txtRate" runat="server"
                            ErrorMessage="Rate must be decimal number only !!" Display="Dynamic" ValidationGroup="btnSave" ValidationExpression="[0-9]*\.?[0-9]*"></asp:RegularExpressionValidator>

            </td>
        </tr>
        <tr>
        <td></td>
            <td>
                <asp:Button ID="btnSave" runat="server" ValidationGroup="btnSave" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="btnSave_Click" />
            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="sfLocale icon-close sfBtn" OnClick="btnCancel_Click" /></td>
        </tr>
    </table>
</div>
</div>
<div class="thbg">
<asp:GridView runat="server" CssClass="gdv" ID="gdvLaundryRateList" Width="100%" EmptyDataText="..........No Data Found.........." AutoGenerateColumns="False"
     OnRowCommand="gdvLaundryRateList_RowCommand"  CellPadding="4" ForeColor="#333333" GridLines="None" OnPreRender="gdvLaundryRateList_PreRender">
    <AlternatingRowStyle BackColor="White" />
    <Columns>
        <asp:TemplateField HeaderText="S.N">
            <ItemTemplate>
                <%#Container.DataItemIndex+1 %>
            </ItemTemplate>
            <HeaderStyle VerticalAlign="Top" CssClass="sfEdit" />
        </asp:TemplateField>
        <asp:BoundField DataField="ClothType" HeaderText="Cloth Type" SortExpression="ClothType" />
        <asp:BoundField DataField="LaundryType" HeaderText="Laundry Type" SortExpression="LaundryType" />
        <asp:BoundField DataField="Rate" HeaderText="Rate" SortExpression="Rate" />
        <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="sfEdit">
            <ItemTemplate>
                <asp:LinkButton ID="Edit" CssClass="icon-edit" runat="server" CausesValidation="False"
                    CommandArgument='<%#Eval("ID")%>' CommandName="laundryRate_edit" ImageUrl='<%# GetTemplateImageUrl("imgedit.png", true) %>' />
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="sfDelete">
            <ItemTemplate>
                <asp:LinkButton ID="Delete" CssClass="icon-delete" runat="server" CausesValidation="False" CommandArgument='<%#Eval("ID")%>'
                    CommandName="laundryRate_delete" ImageUrl='<%# GetTemplateImageUrl("imgdelete.png", true) %>'
                    OnClientClick="return ConfirmDialog(this, 'Confirmation', 'Are you sure you want to delete Laundry Rate?');" />
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