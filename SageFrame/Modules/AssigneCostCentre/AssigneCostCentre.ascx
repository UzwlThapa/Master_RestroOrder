<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AssigneCostCentre.ascx.cs" Inherits="Modules_AssigneCostCentre_AssigneCostCentre" EnableViewState="true" %>
<div id="tabs">
    <ul>
        <li><a href="#tab1">Assign Cost Center</a></li>
    </ul>

    <div id="tab1">
        <table style="display: block;">
            <tr>
                <td>Users :</td>
                <td>
                    <asp:DropDownList ID="userddlist" CssClass="sfInputbox" Style="width: auto;" runat="server">
                    </asp:DropDownList></td>

                <td>Cost Centre :</td>


                <td>
                    <asp:ListBox ID="costcentrelist" CssClass="sfListmenu sfListmenubig" runat="server" SelectionMode="Multiple" Style="width: 200px;"></asp:ListBox></td>

                <td>Role :</td>
                <td>
                    <asp:ListBox ID="lstAvailableRoles" CssClass="sfListmenu sfListmenubig" runat="server" SelectionMode="Multiple"
                        Style="width: 200px;"></asp:ListBox></td>
            </tr>
        </table>

        <asp:Button ID="ButtonSave" runat="server" Text="Save" OnClick="ButtonSave_Click" CssClass="sfLocale icon-save sfBtn" />

    </div>
    <div class="thbg costcentergrid">
        <%--<asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" CssClass="cost-center-tablee" OnRowCreated="GridView1_RowCreated" ClientIDMode="Static">--%>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="cost-center-tablee" ClientIDMode="Static">
            <%--<Columns>
        <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
        <asp:BoundField DataField="AssignedCostCentre" HeaderText="Assigned Cost Centre" SortExpression="AssignedCostCentre" />
        <asp:BoundField DataField="RoleName" HeaderText="RoleName" SortExpression="RoleName" />
    </Columns>
       <PagerSettings Mode="NumericFirstLast"  PageButtonCount="4"  FirstPageText="First" LastPageText="Last" />
             <PagerStyle CssClass="gridview-pagination" HorizontalAlign="Center" />
      <FooterStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
    <HeaderStyle BackColor="#990000" Font-Bold="True" ForeColor="White" />
    
    <RowStyle BackColor="#f5f5f5" ForeColor="#333333" />
    <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
    <SortedAscendingCellStyle BackColor="#FDF5AC" />
    <SortedAscendingHeaderStyle BackColor="#4D0000" />
    <SortedDescendingCellStyle BackColor="#FCF6C0" />
    <SortedDescendingHeaderStyle BackColor="#820000" />--%>

            <Columns>
                <asp:TemplateField HeaderText="Username">
                    <ItemTemplate><%#Eval("Username") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Assigned Cost Centre">
                    <ItemTemplate><%#Eval("AssignedCostCentre") %></ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="RoleName">
                    <ItemTemplate><%#Eval("RoleName") %></ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
       <%-- <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="Data Source=danfeserver;Initial Catalog=RestrOrder;Persist Security Info=True;User ID=db_user;Password=danfeNepal1!" ProviderName="System.Data.SqlClient" SelectCommand="usp_GetgridDatatable" SelectCommandType="StoredProcedure"></asp:SqlDataSource>--%>
    </div>
</div>

<script>
    $(document).ready(function () {
        var tabs = $("#tabs").tabs();
        $("#GridView1").dataTable();
    }
);
</script>
