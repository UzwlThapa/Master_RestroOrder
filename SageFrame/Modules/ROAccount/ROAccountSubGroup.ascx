<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROAccountSubGroup.ascx.cs" Inherits="Modules_ROAccount_ROAccountSubGroup" %>

<script>
    $(document).ready(function () {
        $(this).companyProfEDIT({


        });
        var tabs = $("#tabs").tabs();
        $("#tbl1").hide();

        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
        
        });

    });

    function HideTable(input) {
        $("#btncancel").on('click', function () {
            $("#tbl1").hide();
            $("#ImgPrv").hide();
        });
    }

</script>
<script>    //$(document).ready(function () { $('#ImgPrv').hide(); });</script>

<script src="//code.jquery.com/jquery-1.11.2.min.js" type="text/javascript"></script>

<div id="tabs">
    <ul>
        <li><a href="#div1">Account Sub Group</a>

        </li>
    </ul>
    <div id="div1">
        <asp:Button ID="btnadd" runat="server" CssClass="sfLocale icon-addnew sfBtn" Text="Add" OnClick="btnadd_Click"></asp:Button>


        <table visible="true" runat="server" id="tbl1">
            <tr>
                <td>Code :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtCode" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Name :</td>
                <td>
                    <asp:TextBox runat="server" ID="txtName" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>
            <tr>
                <td>Account Group :</td>
                <td>
                    <asp:DropDownList runat="server" ID="ddlAccountGroup" ClientIDMode="Static" CssClass="required sfInputbox" /></td>
            </tr>

            <tr>
                <td></td>
                <td>
                    <%--<label id="btnsave" class="sfLocale icon-save sfBtn">Save</label>--%>
                    <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="btnsave_Click1" />
                    <%--                      <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="btnsave_Click" --%>
                    <asp:Button Text="Cancel" ID="btncancel" ClientIDMode="Static" OnClientClick="HideTable(this)" class="sfLocale icon-close sfBtn" runat="server" OnClick="btncancel_Click" />
                    <%--<label id="btncancel" class="sfLocale icon-close sfBtn">Cancel</label>--%>

                </td>
            </tr>
        </table>


    </div>
    <div id="SubAccountGroupTable">
        <asp:GridView ID="gvSubAccountGroup" runat="server" PagerSettings-Visible="true" DataKeyNames="AccountSubGroupId" AutoGenerateColumns="false" OnRowCommand="gvSubAccountGroup_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                    <ItemTemplate>
                        <%# Eval("AccountSubGroupId") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Company Name">
                    <ItemTemplate>
                        <%# Eval("Name") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Regd No">
                    <ItemTemplate>
                        <%# Eval("Code") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Address">
                    <ItemTemplate>
                        <%# Eval("AccountGroupID") %>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" OnClientClick="ShowImagePreview(input)" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" autoPostback="true" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>

                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfDelete" />
                </asp:TemplateField>
            </Columns>

        </asp:GridView>
    </div>
</div>
