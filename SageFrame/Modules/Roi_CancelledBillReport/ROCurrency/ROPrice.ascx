<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROPrice.ascx.cs" Inherits="Modules_ROPrice_ROPrice" %>

<script>
    $(document).ready(function () {
        $("#tabs").tabs();
        $(this).companyProfEDIT({


        });
        $("#btnadd").on('click', function () {
            $("#tbl1").show();

        });
        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
        });
        $("#btnsave").on('click', function () {
            $("#tbl1").hide();
        });
    });

    //function Show_Hide_Display() {
    //    $("#btnsave").on('click', function () {
    //        $("#tbl1").hide();
    //    });
    //    $("#btncancel").on('click', function () {
    //        $("#tbl1").hide();
    //    });

    


</script> 
<div id="tabs">
    <ul>
        <li><a href="#tab1" > Price Unit</a></li>
    </ul>
    <div id="tab1">
    <%--<input type="button" value="Add" id="btnadd" />--%>
         <asp:Button runat="server" OnClick="btnadd_Click" id="btnadd" class="sfLocale icon-addnew sfBtn" Text="Add "></asp:Button>
    
        <table id="tbl1" runat="server" style="display:block">
            <tr>
                <td>
                     <asp:HiddenField ID="hdfpriceid" runat="server" />
                    <label>Currency Unit<span style="color:red">*</span> :</label></td>
                <td>
                    <asp:TextBox runat="server" Placeholder="Enter Price Unit" ID="txtprice"  CssClass="sfInputbox" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtprice" ErrorMessage="Currency Unit is required" Display="dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td>
                     
                    <label>Currency Sub Unit<span style="color:red">*</span> :</label></td>
                <td>
                   <%--<input type="text" runat="server" id="txtrestrotable" />--%>
                    <asp:TextBox runat="server" Placeholder="Enter Price Sub Unit" ID="txtSubPrice"  CssClass="sfInputbox" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtSubPrice" ErrorMessage="Currency Sub Unit is required" Display="dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td>
                    <label>Currency Icon<span style="color:red">*</span> :</label></td>
                <td>
                    <asp:TextBox runat="server" Placeholder="Enter Currency Icon" ID="txtCurrencyIcon" ValidationGroup="tezt" CssClass="sfInputbox" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCurrencyIcon" ErrorMessage="Currency Icon field is required" Display="dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                 <td></td>
                <td>
                   <%-- <asp:Button ID="btnsave" Text="Save" CssClass="" runat="server" OnClick="btnsave_Click" />
                    <input type="button" value="Cancel" id="btncancel" />--%>
                      <asp:Button OnClick="btnsave_Click"   runat="server" id="btnsave" Text="Save" class="sfLocale icon-save sfBtn"></asp:Button>
                 <asp:Button runat="server" OnClick="btncancel_Click" CausesValidation="false" OnClientClick="Show_Hide_Display()" id="btncancel"  CssClass="sfLocale icon-close sfBtn" Text="Cancel"></asp:Button></td>
                
            </tr>

        </table>
    </div>
    <div id="divGrid" class="thbg">
        <asp:GridView runat="server" ID="gdvPrice" DataKeyNames="CurrencyID" AutoGenerateColumns="false" OnRowCommand="gdvPrice_RowCommand">
             <AlternatingRowStyle BackColor="white" />
             <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                  <ItemTemplate>
                       <%# Eval("CurrencyID") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Currency">
                  <ItemTemplate>
                       <%# Eval("CurrencyName") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Currency Sub Unit">
                  <ItemTemplate>
                       <%# Eval("SubCurrencyName") %>
                  </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Icon">
                  <ItemTemplate>
                       <%# Eval("CurrencyIcon") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Edit">
                <ItemTemplate>
                    <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" />
                </ItemTemplate>
                <HeaderStyle CssClass="sfEdit" />
            </asp:TemplateField>

            <asp:TemplateField  HeaderText="Delete">
                <ItemTemplate>
                    <asp:LinkButton ID="imgDelete" OnClientClick="return confirm('Are you sure you want to delete this Currency?'); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                </ItemTemplate>
                <HeaderStyle CssClass="sfDelete" />
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
        </asp:gridview>
    </div>
    
</div>

