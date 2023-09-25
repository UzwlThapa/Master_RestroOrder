<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROItemRate.ascx.cs" Inherits="Modules_ROI_temRate_ROItemRate" %>


<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({
        });
        var itemvalue = $('#dditemrate1').val();
        var unitvalue = $('#dditemrate2').val();
        $('#dditemrate1').on('change', function () {
            
            var itemvalue = $('#dditemrate1').val();
            $('#HiddenParentItem').val(itemvalue);
        })

        $('#dditemrate2').on('change', function () {

            var unitvalue = $('#dditemrate2').val();
            $('#MunitHideen').val(unitvalue);
        });
        $("#gvItemRate").dataTable({
            "jQueryUI": false,
            "searching": true,
            "ordering": true,
            "lengthChange": true,
        });
       

        //$("#Vitemrate").datepicker('setDate', new Date);

        $("#Vitemrate").datepicker({ dateFormat: 'yy/mm/dd' });
    });


</script>

<div id="tabs">
<ul>
            <li><a href="#tabs-1">Item Rate</a></li>
    
          </ul>
          <div id="tabs-1"> 
<table style="display:block;">
    <tr>
        <td>
           Item 
        </td>
        <td>
            <asp:DropDownList runat="server" Cssclass="sfInputbox required" ClientIDMode="Static" style="width:200px;" ID="dditemrate1"></asp:DropDownList>
            <asp:HiddenField ID="HiddenParentItem" runat="server" ClientIDMode="Static" />
            <asp:HiddenField ID="HiddenRate" runat="server" ClientIDMode="Static" />

        </td>
        <td>
            Unit 
        </td>
        <td>
            <asp:DropDownList Cssclass="sfInputbox required" ClientIDMode="Static"  runat="server" style="width:200px;" ID="dditemrate2"></asp:DropDownList>
            <asp:HiddenField ID="MunitHideen" runat="server" ClientIDMode="Static" />
        </td>
    </tr>

    <tr>
        <td>
           Purchase Rate
        </td>
        <td>
            <asp:TextBox ID="pritemrate" Cssclass="sfInputbox required" ClientIDMode="Static" runat="server" ></asp:TextBox>

        </td>
        <td>
           Sells Rate
        </td>
        <td>
            <asp:TextBox ID="sritemrate" Cssclass="sfInputbox required" ClientIDMode="Static" runat="server" ></asp:TextBox>
          
        </td>
    </tr>
        <tr>
        <td>
           Valid From
        </td>
        <td>
            <asp:TextBox ID="Vitemrate"  Cssclass="sfInputbox required" ClientIDMode="Static" runat="server" ></asp:TextBox>
        </td>
    </tr>
     
   
    <tr>
        
        <td>

        </td>
        <td>
            <asp:Button ID="saveItem" ClientIDMode="Static" Text="SAVE" runat="server" OnClick="saveItem_Click" Cssclass="sfLocale icon-save sfBtn"/>
        </td>
    </tr>

    
</table>
</div>

 <asp:GridView ID="gvItemRate" runat="server" PagerSettings-Visible="true" DataKeyNames="ItemRateID" AutoGenerateColumns="False" OnRowCommand="gvItemRate_RowCommand" ClientIDMode="Static" OnRowCreated="gvItemRate_RowCreated" Cssclass="inventory-table ">
            
     <AlternatingRowStyle BackColor="#FFFFFF" />
            
     <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                    <ItemTemplate>
                        <asp:GridView ID="GridView1" runat="server"></asp:GridView>
                        <%# Eval("ItemRateID") %>
                    </ItemTemplate>

                </asp:TemplateField>
                <asp:TemplateField HeaderText="Item">
                    <ItemTemplate>
                        <%# Eval("ITName") %>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField visible="false" HeaderText="Unit">
                    <ItemTemplate>
                        <%# Eval("UnitID") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Purchase Rate">
                    <ItemTemplate>
                        <%# Eval("PRate") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sells Rate">
                    <ItemTemplate>
                        <%# Eval("SRate") %>
                    </ItemTemplate>
                </asp:TemplateField>
               <asp:TemplateField HeaderText="Valid From">
                    <ItemTemplate>
                        <%# Convert.ToDateTime(Eval("Validfroms")).ToShortDateString() %>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" OnClientClick="ShowImagePreview(input)" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditItem" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" autoActivityback="true" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>

                <asp:TemplateField meta:resourcekey="TemplateFieldResource8" HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" OnClientClick="return jConfirm('Are You Sure  ?', 'Delete', function (confirmed) { return confirmed; }); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteItem" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfDelete" />
                </asp:TemplateField>
                
         </Columns>

     <FooterStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White"/>
     <HeaderStyle BackColor="#ff9933" Font-Bold="True" ForeColor="White"/>
     <PagerStyle BackColor="PaleGoldenrod" ForeColor="DarkSlateBlue" HorizontalAlign="Center" />
     <SelectedRowStyle BackColor="DarkSlateBlue" ForeColor="GhostWhite" />
     <SortedAscendingCellStyle BackColor="#FAFAE7" />
     <SortedAscendingHeaderStyle BackColor="#DAC09E" />
     <SortedDescendingCellStyle BackColor="#E1DB9C" />
     <SortedDescendingHeaderStyle BackColor="#C2A47B" />

  </asp:GridView>
