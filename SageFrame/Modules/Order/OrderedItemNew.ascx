<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderedItemNew.ascx.cs" Inherits="Modules_Order_OrderedItemNew" %>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script type="text/javascript" src="../../js/quicksearch.js"></script>
<script type="text/javascript">
    $(function () {
        //$('.search_textbox').each(function (i) {
        //    $(this).quicksearch("[id*=gdvOrderItem] tr:not(:has(th))", {
        //        'testQuery': function (query, txt, row) {
        //            return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;
        //        }
        //    });
        //});
        $("#gdvOrderItem").dataTable({
            "jQueryUI": false,
            "searching": true,
            "ordering": false,
            "bPaginate" : $('#gdvOrderItem tbody tr').length>10,
            "iDisplayLength": 10,
            "lengthChange": true,
            "lengthMenu": [[5, 10, -1], [5, 10, "All"]]
        });
        //$("#btnSearch").click(function () {
        //    $("#btnSearch").each(function (i) {
        //        $("input#txtSearch").quicksearch("[id*=gdvOrderItem] tr:not(:has(th))", {
        //            'testQuery': function (query, txt, row) {
        //                return $(row).children(":eq(" + i + ")").text().toLowerCase().indexOf(query[0].toLowerCase()) != -1;
        //            }
        //        });
        //    });
        //});
    });
</script>

<h4 class="billing-table">Ordered Items</h4>
<p class="billing-table">
   <%-- <asp:TextBox ID="txtSearch" runat="server" placeholder="Search"></asp:TextBox>
    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" Style="height: 26px" ClientIDMode="Static" />--%>
</p>

<div id="companyTable">
   <asp:GridView ID="gdvOrderItem" runat="server" PagerSettings-Visible="true"  BackColor="transparent" DataKeyNames="OrderMasterID" AutoGenerateColumns="false" OnRowCommand="gdvOrderItem_RowCommand" ClientIDMode="Static" BorderColor="transparent" BorderStyle="None" BorderWidth="1px" CellPadding="3" CssClass="BookedTable-list-tbl">
        <%--OnPageIndexChanged="gdvOrderItem_PageIndexChanged"--%>
        <%--OnPageIndexChanged="gdvOrderItem_PageIndexChanged"--%>
        <Columns>
            <%--<asp:BoundField DataField="restroRoom" HeaderText="Room" ItemStyle-Width="30" />--%>
            <asp:TemplateField HeaderText="Id" Visible="false">
                <ItemTemplate>
                    <%# Eval("OrderMasterID") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Order No">
            <ItemStyle Width="100px" />
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
                    <%# (Eval("IsCancelled") as bool? == true ? "Cancelled" : (Eval("BillPaid") as int? == 0 ? "Unpaid" : "Paid")) %>

                    <%--<%# Eval("BillPaid") as int? == 0 ? "Unpaid" : "Paid" %>--%>
<%--                    <%# Eval("IsCancelled") as bool? == true ? "Cancelled" : "Paid" %>--%>
                </ItemTemplate>
            </asp:TemplateField>

          <%--  <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Action">
                <ItemTemplate>
                    <asp:LinkButton ID="PayBill" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                        CommandName="PayBill" CssClass="icon-view" ToolTip="View OrderDetail" meta:resourcekey="imgEditResource1" autoPostback="false" />
                </ItemTemplate>
                <HeaderStyle CssClass="sfEdit" />

            </asp:TemplateField>--%>
        </Columns>
         <FooterStyle BackColor="#F7DFB5" ForeColor="#000000" />
    <HeaderStyle BackColor="#ff993e" Font-Bold="True" ForeColor="#ffffff" />
    <PagerStyle ForeColor="#000000" HorizontalAlign="Center" />
    <RowStyle BackColor="#FFFFFF" ForeColor="#000000" />
    <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="#000000" />
    <SortedAscendingCellStyle BackColor="#FFF1D4" />
    <SortedAscendingHeaderStyle BackColor="#B95C30" />
    <SortedDescendingCellStyle BackColor="#F1E5CE" />
    <SortedDescendingHeaderStyle BackColor="#93451F" />

        <%--<PagerSettings Mode="NumericFirstLast" PageButtonCount="4" FirstPageText="First" LastPageText="Last" />--%>
        <PagerStyle CssClass="gridview-pagination" HorizontalAlign="Center" />

    </asp:GridView>
</div>


