<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CostCenter.ascx.cs" Inherits="Modules_CostCenter_CostCenter" %>
<script>
    $(function () {


        $("#tabs").tabs();

        resizeIframe();

        <%--$('#<%=gdvCostCenter.ClientID %>').find('tr td:last-child .icon-delete').each(function (index, item) {
            if (index <= 4)
                $(this).remove();
        });--%> 

        $(this).CostCenterJs();
    });
</script>
<div class="RO_wrapper">
    <div class="restro-title clearfix">
    </div>
    <div style="margin-top: 5px; margin-left: 10px">

        <%--<asp:Button runat="server" OnClick="btnadd_Click" ID="btnadd" CssClass="sfBtn restro-btn icon-addnew sfBtn" Text="Add "></asp:Button>--%>

        <button type="button" class="sfBtn restro-btn icon-addnew btnAddCostCenter" id="btnCostCenterAdd" runat="server">Cost Center</button>

    

    </div>
     <%--<asp:Button runat="server" OnClick="btncancelall_Click" ID="btncancelall" CssClass="sfLocale icon-cancel sfBtn" Text="Cancel "></asp:Button>--%>
    

    <%-- Bishal Added --%>
            <div id="divGrid" class="thbg">
        <%--<PagerSettings Mode="NextPrevious" PageButtonCount="4" PreviousPageText="Previous" NextPageText="Next" />--%>
        <asp:GridView OnRowCommand="gdvCostCenter_RowCommand" OnPageIndexChanging="gdvCostCenter_PageIndexChanging" runat="server" ID="gdvCostCenter" PageSize="50" DataKeyNames="CostCenterId" AutoGenerateColumns="false" AllowPaging="true" RowStyle-CssClass="ROGrid" GridLines="None">
            <AlternatingRowStyle BackColor="white" />
            <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                    <ItemTemplate>
                        <%# Eval("CostCenterID") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Cost Center Name">
                    <ItemTemplate>
                        <%# Eval("CostCenterName") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Number Of Counter">
                    <ItemTemplate>
                        <%# Eval("NumberOfCounter") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Default Printer">
                    <ItemTemplate>
                        <%# Eval("DefaultPrinter") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Discount">
                    <ItemTemplate>
                        <%# ((decimal) Eval("coDiscount")) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Store">
                    <ItemTemplate>
                        <%# Eval("StName") %>
                    </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Group">
                    <ItemTemplate>
                        <%# Eval("GroupName") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditCostCenter" CssClass="icon-edit editBtn" ToolTip="Edit Cost Center" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" OnClientClick="return confirm('Are you sure you want to delete this Cost Center?'); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteCostCenter" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfDelete" />
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#ff9933" Font-Bold="false" ForeColor="White" />
            <HeaderStyle BackColor="#ff9933" Font-Bold="false" ForeColor="White" />
            <RowStyle BackColor="#f5f5f5" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#FFCC66" Font-Bold="false" ForeColor="Navy" />
            <SortedAscendingCellStyle BackColor="#FDF5AC" />
            <SortedAscendingHeaderStyle BackColor="#4D0000" />
            <SortedDescendingCellStyle BackColor="#FCF6C0" />
            <SortedDescendingHeaderStyle BackColor="#820000" />
        </asp:GridView>
    </div>





     <table id="AddCostCenter" runat="server" style="display: block;">
        <tr>
            <td>Cost center <span style="color: red">*</span> :</td>

            <td>
                <asp:HiddenField runat="server" ID="hdfcostcenterid" />
                <asp:TextBox ID="CostCenterName" CssClass="sfInputbox" runat="server" />
                <%--<asp:DropDownList ID="CostCenterName" runat="server" CssClass="sfInputbox" AutoPostBack="True" OnSelectedIndexChanged="Selection_Change">
                        <asp:ListItem Value="" Selected="True"> -Select- </asp:ListItem>
                        <asp:ListItem Value="Kot">Kot</asp:ListItem>
                        <asp:ListItem Value="Bar">Bar</asp:ListItem>
                        <asp:ListItem Value="Bakery-Cafe">Bakery-Cafe</asp:ListItem>
                        <asp:ListItem Value="Billing">Billing</asp:ListItem>
                    </asp:DropDownList>--%>
                <%--<asp:HiddenField runat="server" ID="hdfcostcenterName" />--%>
                <asp:RequiredFieldValidator ID="rfvCostCenterName" ControlToValidate="CostCenterName" runat="server" ErrorMessage="Cost-Center name is required" Display="dynamic"></asp:RequiredFieldValidator>
            </td>

            <td>Number of Counter <span style="color: red">*</span> :</td>
            <td>
                <%--<asp:HiddenField runat="server" ID="HiddenField1" />--%>
                <asp:TextBox ID="NumberOfCounter" CssClass="sfInputbox" runat="server" Text="1" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="NumberOfCounter" runat="server" ErrorMessage="Cost-Center name is required" Display="dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Default Printer <span style="color: red">*</span> :</td>

            <td>

                <asp:DropDownList runat="server" ID="ddlDefaultPrinter" CssClass="sfInputbox"></asp:DropDownList>
                <%--<asp:TextBox ID="txtDefaultPrinter" runat="server"  CssClass="sfInputbox"></asp:TextBox>--%>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="ddlDefaultPrinter" runat="server" ErrorMessage="Default Printer is required" Display="dynamic"></asp:RequiredFieldValidator>

                <%--                    <asp:TextBox ID="txtDefaultPrinter" runat="server" CssClass="sfInputbox runat=" RegularExpressionValidator="" server="">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtDefaultPrinter" runat="server" ErrorMessage="Default Printer is required"></asp:RequiredFieldValidator>--%>

                </td>

            <td>Discount :</td>

            <td>

                <asp:TextBox ID="txtCoDiscount" CssClass="sfInputbox" runat="server" />

                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Discount should be either number or decimal upto two digits" Display="dynamic"
                    ControlToValidate="txtCoDiscount" ValidationExpression="^(\d{1,9}|\d{0,9}\.\d{1,2})$" />
            </td>
        </tr>
        <tr>
            <td>Store :</td>
            <td>
                <asp:DropDownList ID="ddlstore" CssClass="sfInputbox" runat="server" DataTextField="StName" DataValueField="STId" />
            </td>
            <td>Group :</td>
            <td>
                <asp:DropDownList ID="ddlGroup" CssClass="sfInputbox" runat="server" DataTextField="GroupName" DataValueField="GroupId" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:Button ID="CostCenterSave" runat="server" Text="Save" CssClass="sfLocale icon-save sfBtn" OnClick="CostCenterSave_Click" />
                <asp:Button ID="btnCancel" runat="server" CssClass="sfLocale icon-close sfBtn" CausesValidation="false" Text="Cancel" OnClick="btnCancel_Click" />
            </td>
        </tr>
    </table>

         
    <div id="CostCenterForm" style="display: none;">
        <p style="color: red; display: none;" id="txtValidation">Warning</p>
           <table id="CostCenterTable" runat="server" style="display: block;">
        <tr>
            <td>Cost center <span style="color: red">*</span> :</td>

            <td>
                <label></label>
                <input class="sfInputbox" id="txtCostCenter" /> 
                </td>

            <td>Number of Counter <span style="color: red">*</span> :</td>
            <td>
                <input type="number" value="1" class="sfInputbox" id="txtCounter" /> 
                </td>
        </tr>
        <tr>
            <td>Default Printer <span style="color: red">*</span> :</td>

            <td class="tdTxtPrinter">

                                </td>

            <td>Discount :</td>
     
            <td>
            <input type="number" value="0.0" class="sfInputbox" id="txtDiscount" /> 

                </td>
        </tr>
        <tr>
            <td>Store :</td>
            <td class="tdTxtStore">
                
             </td>

            <td>Group :</td>
            <td class="tdTxtGroup">
                
             </td>
        </tr>
        <tr>
            <td></td>
            <td>
                 <button type="button" class="sfBtn restro-btn icon-addnew sfBtn" id="btnSaveCostcenter">Save</button>
            </td>
        </tr>
    </table>
    </div>

<%--    <input type="button" value="Back" class="sfLocale icon-close sfBtn" onClick="window.top.location.reload();">--%>
</div>
