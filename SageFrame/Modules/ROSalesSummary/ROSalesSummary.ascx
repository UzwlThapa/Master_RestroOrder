<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROSalesSummary.ascx.cs" Inherits="Modules_ROSalesSummary_ROSalesSummary"  %>

<script type="text/javascript">
    $(document).ready(function () {
          var tabs = $("#tabs").tabs();
        $("#txtDailyDate").datepicker({});
        $("#txtWeeklyDate").datepicker({});
        $("#txtFromDate").datepicker({});
        $("#txtToDate").datepicker({});
      
   
     <%--   $("#<%=ddlDate.ClientID%>").change(function ()
        {
            var value = $("#<%=ddlDate.ClientID%>").val();
            if (value == 1 || value == 2 ) 
            {
                $('#<%=DailyNWeeklydateInput.ClientID%>').show();
                $('#<%=MonthlydateInput.ClientID%>').hide();
                $('#<%=YearlydateInput.ClientID%>').hide();
            }
            else if(value == 3)
            {
                $('#<%=MonthlydateInput.ClientID%>').show();
                $('#<%=YearlydateInput.ClientID%>').show();
                $('#<%=DailyNWeeklydateInput.ClientID%>').hide();
            }
            else if(value == 4)
            {
                $('#<%=YearlydateInput.ClientID%>').show();
                $('#<%=MonthlydateInput.ClientID%>').hide();
                $('#<%=DailyNWeeklydateInput.ClientID%>').hide();
            }
        });--%>
         resizeIframe();
      
    });
</script>
<div class="RO_wrapper">
<div id="div1">

<table style="display:block;">
 <tr>
<td>Select Sales Type:</td>
<td>
<asp:DropDownList ID="ddlDate" class="sfInputbox" AppendDataBoundItems="true" runat="server" ClientIDMode="Static" OnSelectedIndexChanged="ddlDate_SelectedIndexChanged" AutoPostBack="true" style="width:100px;">
     <asp:ListItem Text="Select" Value="0" />
     <asp:ListItem Text="Daily" Value="1" />
     <asp:ListItem Text="Weekly" Value="2" />
     <asp:ListItem Text="Monthly" Value="3" />
     <asp:ListItem Text="Yearly" Value="4" />
     <asp:ListItem Text="Range" Value="5" />
</asp:DropDownList>
            </td>
               <!-- </tr><tr> -->
<td>
 <asp:Panel id="DailydateInput" Visible="false"  runat="server">
    <td><label>Date:</label></td>
 <td>
     <asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtDailyDate" style="width:120px;"></asp:TextBox>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtDailyDate" runat="server" ErrorMessage="Date is required" display="Dynamic"></asp:RequiredFieldValidator></td>
</asp:Panel>
</td>
<td>
<asp:Panel id="WeeklydateInput" Visible="false"  runat="server">
 <td><label>Date:</label></td><td>
 <asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtWeeklyDate" style="width:120px;"></asp:TextBox>
     <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtWeeklyDate" runat="server" ErrorMessage="Date is required" display="Dynamic"></asp:RequiredFieldValidator></td>
</asp:Panel>
</td>
<td>
<asp:Panel id="MonthlydateInput" Visible="false" runat="server">
 <td><label>Month:</label></td><td>
        <asp:DropDownList ID="ddlMonth" class="sfInputbox" AppendDataBoundItems="true" runat="server" ClientIDMode="Static" >
               <asp:ListItem Text="Select" Value="0"/>
                 <asp:ListItem value="1" Text="January"/>
                 <asp:ListItem value="2" Text ="February"/>
                 <asp:ListItem value="3" Text ="March"/>
                 <asp:ListItem value="4" Text ="April"/>
                 <asp:ListItem value="5" Text ="May"/>
                 <asp:ListItem value="6" Text ="June"/>
                 <asp:ListItem value="7" Text ="July"/>
                 <asp:ListItem value="8" Text ="August"/>
                 <asp:ListItem value="9" Text ="September"/>
                 <asp:ListItem value="10" Text ="October"/>
                 <asp:ListItem value="11" Text ="November"/>
                 <asp:ListItem value="12" Text ="December"/>
          </asp:DropDownList>
    </td><td><asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="ddlMonth" InitialValue="0" ErrorMessage="Month is not selected" display="Dynamic"/></td></asp:Panel>
  </td>
<td>
  <asp:Panel id="YearlydateInput" Visible="false" runat="server">
     <td><label>Year:</label>
     </td><td><asp:DropDownList class="sfInputbox" ID="ddlYear" runat="server" >
          <asp:ListItem Text="Select" Value="0"/>
     </asp:DropDownList>
       <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlYear" InitialValue="0" ErrorMessage="Year is not selected" display="Dynamic"/></td>
</asp:Panel></td>
<td>
  <asp:Panel id="RangedateInput" Visible="false" runat="server">
        <td><label>From:</label></td>
 <td><asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtFromDate" style="width:120px;"></asp:TextBox>
       <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ControlToValidate="txtFromDate" runat="server" ErrorMessage="From date is required" display="Dynamic"></asp:RequiredFieldValidator>
     </td>
 <td>
        <label>To:</label>
 </td>
 <td><asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtToDate" style="width:120px;"></asp:TextBox>
         <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="txtToDate" runat="server" display="Dynamic" ErrorMessage="To date is required"></asp:RequiredFieldValidator>
       </td></asp:Panel></td>

<td>
<asp:Button runat="server"  OnClick="btnGenerate_Click" ID="btnGenerate" formnovalidate="formnovalidate" class="restro-btn sfLocale sfBtn" Text="Generate" Visible="false" style="padding:9px;"></asp:Button></td></tr></table>
 </div>
       <div id="divGrid" class="thbg">
        <asp:GridView runat="server" EmptyDataText="No items to display"  ID="gdvSalesSummary" PageSize="10" AllowSorting="true"  AutoGenerateColumns="false" AllowPaging="true" OnPageIndexChanging="gdvSalesSummary_PageIndexChanging" GridLines="None">
            <AlternatingRowStyle BackColor="white" />
            <Columns>
                <asp:TemplateField HeaderText="S.N" >
                    <ItemTemplate>
                        <%# Eval("Count") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Item">
                    <ItemTemplate>
                        <%# Eval("ITName") %>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="Quantity">
                    <ItemTemplate>
                        <%# Eval("Quantity") %>
                     
                    </ItemTemplate>
                </asp:TemplateField>
                 <asp:TemplateField HeaderText="Unit">
                    <ItemTemplate>
                        <%# Eval("ITUnit") %>
                     
                    </ItemTemplate>
                </asp:TemplateField>
            
            <%--    <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteUser" OnClientClick="return confirm('Are you sure you want to delete this Table?'); " CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfDelete" />
                </asp:TemplateField>--%>


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
        </div>
    </div>