<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProviderList.ascx.cs" Inherits="Modules_ROISalesPaymentMode_ProviderList" %>

<script>
    $(document).ready(function () {
        $("#tabs").tabs();
         resizeIframe();
    });
</script>

<div class="RO_wrapper">
<div class="restro-title clearfix">
        <asp:Button ID="btnProviderAdd" CssClass="sfLocale icon-addnew sfBtn" ClientIDMode="Static"  runat="server" TEXT="Add" OnClick="btnProviderAdd_Click" />
        </div>
         <table runat="server" id="tblProviderList" style="display:block;">
             <tr>
                 <td>
                     Provider Name<span style="color:red">*</span> :
                 </td>
                 <td>

                    <asp:TextBox ID="txtProvider" runat="server" ClientIDMode="Static"  CssClass="sfInputbox"></asp:TextBox>
                     <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtProvider" ErrorMessage="Provider Name is required" Display="dynamic"></asp:RequiredFieldValidator>
                 </td>
             </tr>
             <tr>
                 <td>
                     Description :
                 </td>
                 <td>
                     
                    <asp:TextBox TextMode="MultiLine" ID="txtDescription" runat="server" ClientIDMode="Static" CssClass="sfInputbox" style="width:400px;height:100px;"></asp:TextBox>
                 </td>
                 </tr>
             <tr>
                 <td></td>
                 <td>
                      <asp:Button ID="btnProviderSave" runat="server" CssClass="sfLocale icon-save sfBtn" Text="Save"  OnClick="btnProviderSave_Click" />
                      <asp:Button ID="btnProviderSaveCancel" CausesValidation="false" CssClass="sfLocale icon-close sfBtn" runat="server" Text="Cancel" OnClick="btnProviderSaveCancel_Click" />
                 </td>
                 
             </tr>
                 
         </table>
    <div id="divGrid" class="thbg">
        <asp:GridView ID="gdvProvider" runat="server" AutoGenerateColumns="false" DataKeyNames="ProviderID" OnRowCommand="gdvProvider_RowCommand" RowStyle-CssClass="ROGrid" Gridlines="none">
         <AlternatingRowStyle BackColor="white" />
            <Columns>
            <asp:TemplateField HeaderText="ID" Visible="false">
                <ItemTemplate>
                    <%# Eval("ProviderID")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Provider Name">
                <ItemTemplate>
                    <%# Eval("ProviderName")%>
                </ItemTemplate>
            </asp:TemplateField>
           <%-- <asp:TemplateField HeaderText="Description">
                <ItemTemplate>
                    <%# Eval("Description")%>
                </ItemTemplate>
            </asp:TemplateField>--%>
            <asp:TemplateField HeaderText="Description">
                <ItemTemplate>
                    <%# Eval("Description")%>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Edit" HeaderStyle-CssClass="sfEdit">
                <ItemTemplate>
                  <asp:LinkButton ID="roomEdit" runat="server" CausesValidation="false" CommandArgument="<%# Container.DataItemIndex %>" CommandName="editProvider" CssClass="icon-edit" ToolTip="Edit Room" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Delete" HeaderStyle-CssClass="sfDelete">
                <ItemTemplate>
                  <asp:LinkButton ID="roomDelete" CausesValidation="false" OnClientClick="return confirm('Are you sure you want to delete this Provider?'); " runat="server" CommandArgument="<%# Container.DataItemIndex %>" CommandName="DeleteProvider" CssClass="icon-delete" ToolTip="Delete Room" />
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
         <PagerSettings Mode="NumericFirstLast"  PageButtonCount="4"  FirstPageText="First" LastPageText="Last" />
             <PagerStyle CssClass="gridview-pagination" HorizontalAlign="Center" />
            <FooterStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White" />
    
    <RowStyle BackColor="#f5f5f5" ForeColor="#333333" />
    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
    <SortedAscendingCellStyle BackColor="#FDF5AC" />
    <SortedAscendingHeaderStyle BackColor="#4D0000" />
    <SortedDescendingCellStyle BackColor="#FCF6C0" />
    <SortedDescendingHeaderStyle BackColor="#820000" />
    </asp:GridView>
    </div>
    
    
    <asp:HiddenField ID="editablevalue" runat="server"  />                  

</div>
</div>