<%@ Control Language="C#" CodeFile="restroTable.ascx.cs" AutoEventWireup="true" Inherits="Modules_RestroTable_restroTable" %>


<script>
    $(document).ready(function () {
      
        $("#<%=txtTableName.ClientID%>").focusout(function () {
            var values = $('#txtTableName').val();
            $.ajax({
                type: "POST",
                url: "/Modules/RORestroTable/ROTableWebService.asmx/DoesTableNameExist",
                data: JSON.stringify({ tableName: values }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {

                    $("#<%=lblFortxtTableName.ClientID%>").text(msg.d);

                }
            });
        });
        $("#gdvRestroTable").dataTable({
            "jQueryUI": true,
            "searching": true,
            "ordering": true,
            "lengthChange": true,
            columnDefs: [{ orderable: false, targets: [4,5] }],
             "lengthMenu": [[20,50, 100, -1], [20, 50, 100, "All"]],
             "iDisplayLength": 20,
        });

        if ($('#chkTblRoom').is(':checked')) {
            $('#rate').hide();
            $('#txtRate').val('0');
            $('#seatno').show();
        } else {
            $('#rate').show();
            $('#seatno').hide();
            $('#txtSeatNo').val('0');
        }
        $('#chkTblRoom').on('change', function () {
            if ($('#chkTblRoom').is(':checked')) {
                $('#rate').hide();
                $('#txtRate').val('0');
                $('#seatno').show();
            } else {
                $('#rate').show();
                $('#seatno').hide();
                $('#txtSeatNo').val('0');
            }
        });

         resizeIframe();
    });

</script>

<%--<asp:ScriptManager runat="server" ID="scriptManager">
        <Services>
            <asp:ServiceReference Path="RoWebService.asmx" />
        </Services>
    </asp:ScriptManager>--%>
<div class="RO_wrapper">
<div class="restro-title clearfix">
        <asp:Button runat="server" OnClick="btnadd_Click" ID="btnadd" class="sfLocale icon-addnew sfBtn" Text="Add "></asp:Button>
</div>
        <table id="tbl1" runat="server" style="display:block;">
            <tr>
                <td>
                    <asp:HiddenField ID="hdfrestrotableid" runat="server" />
                    <label>Table<span style="color:red">*</span> :</label></td>
                <td>
                    <asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtTableName"></asp:TextBox>
                    <asp:Label runat="server" ID="lblFortxtTableName" name="lblFortxtTableName" ForeColor="red" ClientIDMode="Static" ViewStateMode="Enabled"></asp:Label>

                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtTableName" runat="server" ErrorMessage="Table name is required" Display="dynamic"></asp:RequiredFieldValidator>
                </td>
            </tr>
             <tr>
                <td>
                    <label>Is Table :</label>
                </td>
                <td>
                    <asp:CheckBox runat="server" ClientIDMode="Static" ID="chkTblRoom"  Checked="true" />
                </td>
            </tr>
             <tr runat="server" ClientIDMode="Static" id="rate" style="display:none;">
                <td>
                    <label>Room Rate/Day :</label>
                </td>
                <td>
                    <asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtRate"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revRate" ControlToValidate="txtRate" runat="server" ValidationExpression="[\d]{1,6}([.,][\d]{1,2})?" ErrorMessage="Please enter decimal only" Display="dynamic"/>

                </td>
            </tr>
            <tr runat="server" ClientIDMode="Static" id="seatno">
                <td>
                    <label>Table Capacity :</label>
                </td>
                <td>
                    <asp:TextBox runat="server" ClientIDMode="Static" CssClass="sfInputbox" ID="txtSeatNo"></asp:TextBox>
                    <%--                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtSeatNo" runat="server" ErrorMessage="This Number of Seat is required"></asp:RequiredFieldValidator>
                    <br />--%>
                    <asp:RegularExpressionValidator ID="revSeatNumber" ControlToValidate="txtSeatNo" runat="server" ValidationExpression="\d+" ErrorMessage="Please enter numbers only" Display="dynamic"/>

                </td>
            </tr>

            <tr>
                <td>
                    <label>Room Name :</label></td>
                <td>
                    <asp:DropDownList ID="ddlRoom" runat="server" OnSelectedIndexChanged="ddlRoom_SelectedIndexChanged" CssClass="sfInputbox" style="width:200px;"></asp:DropDownList>
                    <%--<input type="text" runat="server" id="txtrestrotable" />--%>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="ddlRoom" runat="server" ErrorMessage="Room name is required" Display="dynamic"></asp:RequiredFieldValidator>

                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <%-- <asp:Button ID="btnsave" Text="Save" CssClass="" runat="server" OnClick="btnsave_Click" />
                    <input type="button" value="Cancel" id="btncancel" />--%>
                    <asp:Button OnClick="btnsave_Click" runat="server" ID="btnsave" Text="Save" class="sfLocale icon-save sfBtn"></asp:Button>
                    <%--<input type="button" runat="server" ID="btncancel" formnovalidate="formnovalidate" class="sfLocale icon-close sfBtn" Text="Cancel">--%>

                    <asp:Button runat="server" CausesValidation="false"  OnClick="btncancel_Click" ID="btncancel" formnovalidate="formnovalidate" class="sfLocale icon-close sfBtn" Text="Cancel"></asp:Button></td>

            </tr>

        </table>
    <div id="divGrid" class="thbg">
        <asp:GridView runat="server" ID="gdvRestroTable"  DataKeyNames="restrotableId" AutoGenerateColumns="false" OnRowCommand="gdvRestroTable_RowCommand"
             OnRowCreated="gdvRestroTable_RowCreated" ClientIDMode="Static" RowStyle-CssClass="ROGrid" GridLines="None">
             <AlternatingRowStyle BackColor="white" />
            <Columns>
                <asp:TemplateField HeaderText="Id" Visible="false">
                    <ItemTemplate>
                        <%# Eval("restrotableId") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Table/Room">
                    <ItemTemplate>
                        <%# Eval("restrotableTitle") %> <%# ((bool)Eval("IsTable")) ? "(Table)":"(Room)" %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Table Capacity">
                    <ItemTemplate>
                        <%# ((int)Eval("Seatcap") <= 0) ? "Not-Specified" : Eval("Seatcap") %>
                        <%--<%# Eval("SeatNo") %>--%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Rate">
                    <ItemTemplate>
                        <%# Eval("Rate") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Room Name">
                    <ItemTemplate>
                        <%# Eval("restroRoom") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" />
                    </ItemTemplate>
                    <HeaderStyle CssClass="sfEdit" />
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:LinkButton ID="imgDelete" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                            CommandName="DeleteUser" OnClientClick="return  jConfirm('Are You Sure  ?', 'Delete', function (confirmed) { return confirmed; }); " CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" />
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

</div>

