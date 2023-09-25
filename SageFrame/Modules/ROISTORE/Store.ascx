<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Store.ascx.cs" Inherits="Modules_ROISTORE_Store" %>
<script type="text/javascript">

    $(function () {
        var tabs = $("#tabs").tabs();
        $("#ddlpst").on('change', function () {
            var values = $("#ddlpst").val();
            $("#hiddenStore").val(values);
        });
        $("#gvStore").dataTable({
            "jQueryUI": true,
            "searching": false,
            "ordering": false,
            "lengthChange": true,
        });
         resizeIframe();
    });
</script>
<div class="RO_wrapper">
<div class="restro-title clearfix">
<asp:Button runat="server" OnClick="btnadd_Click" ID="btnadd" class="sfLocale icon-addnew sfBtn" Text="Add "></asp:Button></div>
<table id="tablestore" runat="server" style="display:block;">
    <tr>
        <td>Store Name :
        </td>
        <td>
            <asp:TextBox ID="txtStore" runat="server" class="sfInputbox"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvcandidate" runat="server" ControlToValidate ="txtStore"  ErrorMessage="Enter Store Name" Display="dynamic"></asp:RequiredFieldValidator>
        </td>
         </tr>
        <tr>
        <td>Parent Store :
        </td>
        <td>
            <asp:DropDownList ClientIDMode="Static" ID="ddlpst" runat="server" Cssclass="sfInputbox"></asp:DropDownList>

            <asp:HiddenField ID="hiddenStore" runat="server" ClientIDMode="Static" />
        </td>
    </tr>
    <tr>
    <td></td>
    <td><asp:Button ID="saveStore" Text="Save"  class="icon-save sfBtn" ClientIDMode="Static" runat="server" OnClick="saveStore_Click"/>
     <asp:Button runat="server" CausesValidation="false"  OnClick="btncancel_Click" ID="btncancel" formnovalidate="formnovalidate" class="sfLocale icon-close sfBtn" Text="Cancel"></asp:Button></td></tr>

</table>


<%--<asp:GridView ID="gvDatas" AutoGenerateColumns="False" runat="server"  CellPadding="4" ForeColor="#333333" OnRowCommand="gvDatas_RowCommand" DataKeyNames="ITId" GridLines="None">
    <AlternatingRowStyle BackColor="White" />--%>

          <%--<asp:TextBox ID="TextBox1" runat="server" OnTextChanged="TextBox1_TextChanged"></asp:TextBox>--%>
          <div class="thbg">
<asp:GridView runat="server" ID="gvStore" DataKeyNames="STId" CellPadding="4" OnRowCommand="gvStore_RowCommand" AutoGenerateColumns="False" ForeColor="#333333" GridLines="None"  ClientIDMode="Static" RowStyle-CssClass="ROGrid"  OnRowCreated="gvStore_RowCreated" >
    <%--AllowPaging="True" OnPageIndexChanging="gvStore_PageIndexChanging" AllowSorting="True"--%>
       
    <AlternatingRowStyle BackColor="White" />

    <Columns>
        <asp:TemplateField HeaderText="Id" Visible="false">
            <ItemTemplate>
                <%# Eval("STId") %>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Store Name">
            <ItemTemplate>
                <%# Eval("PName") %>
            </ItemTemplate>
        </asp:TemplateField>

       <%-- <asp:TemplateField HeaderText="PST">
            <ItemTemplate>
                <%# Eval("PName") %>
            </ItemTemplate>
        </asp:TemplateField>--%>

        <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Edit">
            <ItemTemplate>
                <asp:LinkButton ID="storeEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                    CommandName="editStore" CssClass="icon-edit" ToolTip="Edit Store" meta:resourcekey="imgEditResource1" autoPostback="true" />
            </ItemTemplate>
            <HeaderStyle CssClass="sfEdit" />
        </asp:TemplateField>

        <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
            <ItemTemplate>
                <asp:LinkButton ID="storeDelete" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                    CommandName="storeDelete" OnClientClick="return confirm('Are you sure you want to delete this Store?');" CssClass="icon-delete" ToolTip="Edit Store" meta:resourcekey="imgEditResource1" autoPostback="true" />
            </ItemTemplate>
            <HeaderStyle CssClass="sfEdit" />
        </asp:TemplateField>

    </Columns>
    <FooterStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
    <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
    <RowStyle BackColor="#f5f5f5" ForeColor="#333333" />
    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
    <SortedAscendingCellStyle BackColor="#FDF5AC" />
    <SortedAscendingHeaderStyle BackColor="#4D0000" />
    <SortedDescendingCellStyle BackColor="#FCF6C0" />
    <SortedDescendingHeaderStyle BackColor="#820000" />
    <%--<PagerSettings FirstPageText="Previous" PageButtonCount="4" LastPageText="Next" Mode="NumericFirstLast" />--%>

</asp:GridView>
          <asp:Label ID="lblDes" runat="server"></asp:Label>
          </div>
        
    </div>
 