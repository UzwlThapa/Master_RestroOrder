<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BillingTermView.ascx.cs" Inherits="Modules_BillingTerm_BillingTermView" %>
<%--<script>--%>


<script>
    $(document).ready(function () {
        var tabs = $("#tabs").tabs();
        //$("#tbl1").hide();
        $('#txtFromTime').timepicker({
            timeFormat: 'HH:mm',
            dropdown: true,
            scrollbar: true
        });
        $('#txtToTime').timepicker({
            timeFormat: 'HH:mm',
            dropdown: true,
            scrollbar: true
        });

        $('#txtFromDate').datepicker({
            minDate: 'dateToday',
            //defaultDate: '',
            useCurrent: false,
            onSelect: function (date) {
                var date2 = $('#txtFromDate').datepicker('getDate');
                date2.setDate(date2.getDate());
                //$('.BookDataTo').datetimepicker('setDate', date2);
                //sets minDate to dt1 date + 1btnRoomAdd
                $('#txtToDate').datepicker('option', 'minDate', date2);
            }
        });
        $('#txtToDate').datepicker();
        //$("#chkIsAlwaysActive").on('change', function () {
        //    if ($("#chkIsAlwaysActive").is(':checked')) {
        //        $(".billDetails").hide();
        //    }
        //    else {
        //        $(".billDetails").show();
        //    }
        //});

    });
</script>
    <script>
        $(document).ready(function () {
            // $(this).companyProfEDIT({


            // });

        $("#btnadd").on('click', function () {
            $("#tbl1").show();
            $('#textMenu').val('');
        });
        //$("#btncancel").on('click', function () {
        //    $("#tbl1").hide();
        //    $("#txtname").val('');
        //    $("#hfBillTermId").val(null);
        //    $("#txtrate").val('');
        //    $("#txtdesc").val('');
        //    $("#ddlSequence").val('');
        //    //$("#chkisAdd").val('false');
        //    $('#chkisAdd').prop('checked', false);
        //});

        $("#imgDelete").on('click', function () {
            $("#tbl1").hide();
            //$('#textMenu').val('');
        });
        $("#btnsave").on('click', function () {
            $("#tbl1").hide();

        });
         resizeIframe();
    });
</script> 
<div class="RO_wrapper">
<div class="restro-title clearfix">
        <asp:Button id="btnadd" Text="Add" OnClick="btnadd_Click" runat="server" CssClass="sfLocale icon-addnew sfBtn restro-right"></asp:Button>
        </div>
    <table id="tbl1" runat="server" style="display:block;">
        <tr>
            <td>
                <asp:HiddenField ID="hfBillTermId" ClientIDMode="Static" Value="0" runat="server" />
                Name<span style="color:red">*</span> :
            </td>
            <td><asp:TextBox ID="txtname" ClientIDMode="Static"  runat="server"  CssClass="sfInputbox"/>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Bill Term Name is required" ControlToValidate="txtname" Display="dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
         <tr>
            <td>
                Is Add :
            </td>
            <td><asp:CheckBox ID="chkisAdd" ClientIDMode="Static" runat="server"/></td>
        </tr>
         <tr>
            <td>
                Rate<span style="color:red">*</span> :
            </td>
            <td><asp:TextBox ID="txtrate" ClientIDMode="Static" runat="server"  CssClass="sfInputbox" />
                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server"  ErrorMessage="Accepts only decimal." Display="dynamic" ControlToValidate="txtrate" ValidationExpression="^(\d{1,3})(.\d{1,2})?$"></asp:RegularExpressionValidator> 
                
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Rate is required" ControlToValidate="txtrate" Display="dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                Sequence No<span style="color:red">* </span>:
            </td>
            <td><div class="clearfix"><asp:DropDownList ID ="ddlSequence" ClientIDMode="Static" runat="server" CssClass="sfInputbox" style="width:150px;float:left">

                </asp:DropDownList>
                 <span class="notee" style="float:left;margin-top:8px;margin-left: 15px;"> (Number for two Bill Term shouldn't be the same. Vat will always have highest sequence number.)</span></div>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlSequence" ErrorMessage="Sequence Filed is Required" Display="dynamic"></asp:RequiredFieldValidator>
               
            </td>
        </tr>
         <tr>
            <td>
                Description<span style="color:red">*</span> :
            </td>
            <td><asp:TextBox TextMode="MultiLine" ClientIDMode="Static" ID="txtdesc" runat="server"  CssClass="sfInputbox" style="width:400px;height:100px;"/>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtdesc" ErrorMessage="Description is Required" Display="dynamic"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <%--<tr>
            <td>
                Is Always Active :
            </td>
            <td><asp:CheckBox ID="chkIsAlwaysActive" ClientIDMode="Static" runat="server" Checked="true" /></td>
        </tr>--%>
        <tr class="billDetails" id="billDetails" runat="server" clientidmode="static" style="display:none;">
            <td>Effective Date : </td>
            <td>
                From : <input type="text" ClientIDMode="Static" runat="server" id="txtFromDate" readonly />
                 <%--<asp:TextBox runat="server" ID="txtFromDate" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>--%>
                 To : <input type="text" ClientIDMode="Static" runat="server" id="txtToDate" readonly />
                <%--<asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>--%>
                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="From Date is required." ControlToValidate="txtFromDate" Display="dynamic"></asp:RequiredFieldValidator>--%>
                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="To Date is required." ControlToValidate="txtToDate" Display="dynamic"></asp:RequiredFieldValidator>--%>

            </td>
        </tr>
        <tr class="billDetails" id="billDetails1" runat="server" clientidmode="static" style="display:none;">
            <td>Effective Time : </td>
            <td>From : <input type="text" ClientIDMode="Static" runat="server" id="txtFromTime" readonly />
                <%--<asp:TextBox runat="server" ID="txtFromTime" CssClass="timepick" ClientIDMode="Static" ReadOnly="true"></asp:TextBox>--%>
                 To : <input type="text" ClientIDMode="Static" runat="server" id="txtToTime" readonly />
                <%--<asp:TextBox runat="server" ReadOnly="true" ID="txtToTime" ClientIDMode="Static"></asp:TextBox>--%>
                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ErrorMessage="From Time is required." ControlToValidate="txtFromTime" Display="dynamic"></asp:RequiredFieldValidator>--%>
                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="To Time is required." ControlToValidate="txtToTime" Display="dynamic"></asp:RequiredFieldValidator>--%>
            </td>
        </tr>
        <tr class="billDetails" id="billDetails2" runat="server" clientidmode="static" style="display:none;">
            <td>Effective Days : </td>
            <td>
                <asp:CheckBox runat="server" ID="chkSunday" ClientIDMode="Static" Checked="true" Text="Sunday" />
                <asp:CheckBox runat="server" ID="chkMonday" ClientIDMode="Static" Checked="true" Text="Monday" />
                <asp:CheckBox runat="server" ID="chkTuesday" ClientIDMode="Static" Checked="true" Text="Tuesday" />
                <asp:CheckBox runat="server" ID="chkWednesday" ClientIDMode="Static" Checked="true" Text="Wednesday" />
                <asp:CheckBox runat="server" ID="chkThursday" ClientIDMode="Static" Checked="true" Text="Thursday" />
                <asp:CheckBox runat="server" ID="chkFriday" ClientIDMode="Static" Text="Friday" Checked="true" />
                <asp:CheckBox runat="server" ID="chkSaturday" ClientIDMode="Static" Text="Saturday" Checked="true" />
            </td>
        </tr>
        <tr>
            <td></td>
            <td>
                <asp:Button Text="Save" ClientIDMode="Static"  runat="server" class="sfLocale icon-save sfBtn" OnClick="btnsave_Click" />
                 <%--<label id="btnsave" class="sfLocale icon-save sfBtn">Save</label>--%>
                 <asp:Button ID="btncancel" CausesValidation="false" runat="server" OnClick="btncancel_Click" Text="Cancel" CssClass="sfLocale icon-close sfBtn"></asp:Button></td>
                <%--<asp:Button ID="btnsave" runat="server" Text="Save" OnClick="btnsave_Click" /></td>--%>
            <%--<td> <input type="button" id="btncancel" value="CANCEL" /></td>--%>
        </tr>
    </table>
 <div id="divGrid" class="thbg">
        <asp:GridView runat="server" ID="gdvBillingTerm" DataKeyNames="BilingID" AutoGenerateColumns="false" OnRowCommand="gdvBillingTerm_RowCommand" RowStyle-CssClass="ROGrid" GridLines="None">
             <AlternatingRowStyle BackColor="white" />
             <Columns>
                <asp:TemplateField HeaderText="BillingID" Visible="false">
                  <ItemTemplate>
                       <%# Eval("BilingID") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Bill Term">
                  <ItemTemplate>
                       <%# Eval("Name") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Sequence No">
                  <ItemTemplate>
                       <%# Eval("SequenceOrder") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="IsAdd">
                  <ItemTemplate>
                       <%# Eval("IsAdd") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Rate">
                  <ItemTemplate>
                       <%# Eval("Rate") %>
                  </ItemTemplate>
                </asp:TemplateField>
                <%--<asp:TemplateField HeaderText="Always Active">
                  <ItemTemplate>
                       <%# Eval("IsAlwaysActive") %>
                  </ItemTemplate>
                </asp:TemplateField>--%>

                <asp:TemplateField HeaderText="Edit">

                      <ItemTemplate>
                            <asp:LinkButton ID="imgEdit" runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                       Visible='<%# DataBinder.Eval(Container.DataItem, "Name").ToString() != "VAT" %>'  CommandName="EditUser" CssClass="icon-edit" ToolTip="Edit User" meta:resourcekey="imgEditResource1" />
                     </ItemTemplate>
                 
                    
                  <%--Visible="<%# Eval("Name").ToString() == "VAT"? "false": "true" %>"--%>
               
                <HeaderStyle CssClass="sfEdit" />
            </asp:TemplateField>

            <asp:TemplateField  HeaderText="Delete">
                 <ItemTemplate>
                    
                       <asp:LinkButton ID="imgDelete" ClientIDMode="Static" OnClientClick="return confirm('Are you sure you want to delete this Bill Term?'); " runat="server" CausesValidation="False" CommandArgument='<%# Container.DataItemIndex %>'
                    Visible='<%# DataBinder.Eval(Container.DataItem, "Name").ToString() != "VAT" %>'   CommandName="DeleteUser" CssClass="icon-delete" ToolTip="Delete User" meta:resourcekey="imgEditResource1" /> 
                  <%--Visible="<%# Eval("Name").ToString() == "VAT"? false: true %>"--%> 
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

