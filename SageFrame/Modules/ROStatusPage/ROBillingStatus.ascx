<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROBillingStatus.ascx.cs" Inherits="Modules_ROBilling_ViewBilling" %>
<%--<script type="text/javascript">
    $('#Ro-billing-tem-list').DataTable(
                         {
                             "scrollY": 200,
                             "scrollCollapse": true,
                             "jQueryUI": true
                         });
</script>--%>
<br />
<h4 class="billing-table">Ordered Items</h4>

    <div id="companyTable">
         <asp:gridview id="gdvOrderItem" runat="server" PagerSettings-Visible="true" DataKeyNames="OrderMasterID" AutoGenerateColumns="false" OnRowCommand="gdvOrderItem_RowCommand">
            <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                  <ItemTemplate>
                       <%# Eval("OrderMasterID") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Order No">
                  <ItemTemplate>
                       <%# Eval("BillNo") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Table No">
                  <ItemTemplate>

                       <%# Eval("TableId") %>
                  </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Date">
                  <ItemTemplate>
                       <%# Eval("Date") %>
                  </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Status">
                  <ItemTemplate>
                       <%# Eval("BillPaid") as int? == 0 ? "Unpaid" : "Paid" %> 
                  </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="View">
                   <ItemTemplate>
                    <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="ViewOrder" CssClass="icon-edit" ToolTip="View OrderDetail" meta:resourcekey="imgEditResource1" autoPostback="false"  />
                </ItemTemplate>
                <HeaderStyle CssClass="sfEdit" />
<%--                <ItemTemplate>
                    <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" autoPostback="false"  />
                </ItemTemplate>
                <HeaderStyle CssClass="sfEdit" />--%>
            <%--</asp:TemplateField>

            <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
                <ItemTemplate>
                    <asp:LinkButton ID="imgDelete" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                </ItemTemplate>--%>
                <%--<HeaderStyle CssClass="sfDelete" />--%>
            </asp:TemplateField>
            </Columns>

        </asp:gridview>
        </div>

<%--<asp:Literal runat="server" ID="ltrBilling"></asp:Literal>--%>
<asp:Button ID="btnRefresh" CssClass="print-button" Text="Refresh" OnClick="btnRefresh_Click" runat="server" />

