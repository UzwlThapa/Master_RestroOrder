<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderedItemNew.ascx.cs" Inherits="Modules_Order_OrderedItemNew" %>
<h4 class="billing-table">Ordered Items</h4>

    <div id="companyTable">
         <asp:gridview id="gdvOrderItem" runat="server" PagerSettings-Visible="true" DataKeyNames="OrderMasterID" AutoGenerateColumns="false" OnRowCommand="gdvOrderItem_RowCommand" AllowPaging="True" OnPageIndexChanging="gdvOrderItem_PageIndexChanging" >
             <%--OnPageIndexChanged="gdvOrderItem_PageIndexChanged"--%>
            <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                  <ItemTemplate>
                       <%# Eval("OrderMasterID") %>
                  </ItemTemplate>
                </asp:TemplateField>
                   <asp:TemplateField HeaderText="Order No">
                  <ItemTemplate>
                       <%# Container.DataItemIndex + 1 %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Room">
                  <ItemTemplate>
                       <%# Eval("restroRoom") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Table">
                  <ItemTemplate>
                      <%# Eval("restrotableTitle") %>
                  </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Time">
                  <ItemTemplate>
                      <asp:Label ID="lblStartTime" runat="server" Text='<%#Convert.ToDateTime(Eval("Date")).ToShortTimeString()%>' />
                       <%-- <%# Eval("Date") %>--%>
                  </ItemTemplate>
                </asp:TemplateField>
                   <asp:TemplateField HeaderText="Amount">
                  <ItemTemplate>
                       <%# Eval("BasicAmount") %>
                  </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Status">
                  <ItemTemplate>
                       <%# Eval("BillPaid") as int? == 0 ? "Unpaid" : "Paid" %> 
                  </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Action">
                   <ItemTemplate>
                    <asp:LinkButton ID="PayBill" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="PayBill" CssClass="icon-edit" ToolTip="View OrderDetail" meta:resourcekey="imgEditResource1" autoPostback="false"  />
                </ItemTemplate>
                <HeaderStyle CssClass="sfEdit" />
         
            </asp:TemplateField>
            </Columns>

             <PagerSettings Mode="NumericFirstLast"  PageButtonCount="4"  FirstPageText="First" LastPageText="Last" />

        </asp:gridview>
        </div>


