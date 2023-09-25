<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PaymentModeReport.ascx.cs" Inherits="Modules_ROISalesPaymentMode_PaymentModeReport" %>
<script>
    $(document).ready(function () {
        var tabs = $("#tabs").tabs();
        $("#txtToday").datepicker();
        $('#txtweeklydate').datepicker();
    });

        //$(".monthly").css("visibility", "hidden");
        //$(".yearly").css("visibility", "hidden");
        //$(".daily").css("visibility", "hidden");
        //$(".weekly").css("visibility", "hidden");


        //for (i = new Date().getFullYear() ; i > 1900; i--) {
        //    $('#ddlyear').append($('<option/>').val(i).html(i));
        //}

        //$("#ddlyear").on('change', function () {

        //    var a = $("#ddlyear :selected").val();
        //    $("#yearvalue").val(a);
        //});

        //$("#ddlmonth").on('change', function () {
        //    var a = $("#ddlmonth :selected").val();
        //    $("#monthvalue").val(a);
        //});



        //$("#ddlreporting").on('change', function () {
        //    var a = $("#ddlreporting :selected").val();
        //    $("#rtId").val(a);
        //    if (a == 1) {
        //        $(".daily").css("visibility", "visible");
        //        $(".weekly").css("visibility", "hidden");
        //        $(".monthly").css("visibility", "hidden");
        //        $(".yearly").css("visibility", "hidden");
        //    }
        //    else if (a == 2) {
        //        $(".weekly").css("visibility", "visible");
        //        $(".daily").css("visibility", "hidden");
        //        $(".monthly").css("visibility", "hidden");
        //        $(".yearly").css("visibility", "hidden");
        //    }
        //    else if (a == 3) {
        //        //$(".monthly").css("visibility", "visible");
        //        $(".daily").css("visibility", "hidden");
        //        $(".weekly").css("visibility", "hidden");
        //        $(".monthly").css("visibility", "visible");
        //        $(".yearly").css("visibility", "hidden");
        //    }
        //    else if (a == 4) {
        //        //$(".monthly").css("visibility", "visible");
        //        $(".daily").css("visibility", "hidden");
        //        $(".weekly").css("visibility", "hidden");
        //        $(".monthly").css("visibility", "hidden");
        //        $(".yearly").css("visibility", "visible");
        //    }
        //});
        //var r = $("#rbModeList :selected").val();
        //if (r != 0) {
        //    $('#gvdreportProviderList').show();
        //    $('#gdvReport').show();

    //}
    
</script>

<asp:Panel id="reportingTime" runat="server">
       <label>Reporting BY:</label>
  <asp:DropDownList ID="ddlDate" runat="server" ClientIDMode="Static" AutoPostBack="true" OnSelectedIndexChanged="ddlreportingtime_SelectedIndexChanged">
                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                        <asp:ListItem Value="1">Daily</asp:ListItem>
                        <asp:ListItem Value="2">Weekly</asp:ListItem>
                        <asp:ListItem Value="3">Monthly</asp:ListItem>
                        <asp:ListItem Value="4">Yearly</asp:ListItem>
                        <%--<asp:ListItem Value="4">Range</asp:ListItem>--%>
 </asp:DropDownList>
     <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ControlToValidate="ddlDate" runat="server" InitialValue="0" ErrorMessage="Reporting method is required"></asp:RequiredFieldValidator>
</asp:Panel>

<asp:Panel id="DailydateInput" runat="server" Visible="false">
    Date:<asp:TextBox ID="txtToday" runat="server" ClientIDMode="Static" />
      <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtToday" runat="server" ErrorMessage="Date is required"></asp:RequiredFieldValidator>
    </asp:Panel>
<asp:Panel id="WeeklydateInput" runat="server" Visible="false">
  Date:<asp:TextBox ID="txtweeklydate" runat="server" ClientIDMode="Static" />
      <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtweeklydate" runat="server" ErrorMessage="Date is required"></asp:RequiredFieldValidator>
    </asp:Panel>

<asp:Panel id="MonthlydateInput" runat="server" Visible="false">
 Month:<asp:DropDownList ID="ddlmonth" runat="server" ClientIDMode="Static" />
     <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="ddlmonth" InitialValue="0" ErrorMessage="Month is not selected" />
    </asp:Panel>

<asp:Panel id="YearlydateInput" runat="server" Visible="false">
 Year:<asp:DropDownList ID="ddlyear" runat="server" ClientIDMode="Static" >
      <asp:ListItem Text="Select" Value="0"/>
     </asp:DropDownList>
      <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="ddlyear" InitialValue="0" ErrorMessage="Year is not selected" />
    </asp:Panel>

<asp:Panel runat="server">
   Sales Payment Mode:
             
                    <asp:RadioButtonList ID="rbModeList" AutoPostBack="true" ViewStateMode="Enabled" RepeatDirection="Horizontal" ClientIDMode="Static" runat="server" OnSelectedIndexChanged="rbModeList_SelectedIndexChanged">
                        <asp:ListItem Text="Cash" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Cheque" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Swap" Value="3"></asp:ListItem>
                    </asp:RadioButtonList>
      <asp:RequiredFieldValidator ID="ReqiredFieldValidator" runat="server" ControlToValidate ="rbModeList" ErrorMessage="Select payement mode!" />
 </asp:Panel>

<asp:Panel runat="server" ID="ProviderList" Visible="false">
    <label>Provider List:</label>
    <asp:DropDownList ID="ddlProviderList" ViewStateMode="Enabled" runat="server" ClientIDMode="Static">
         <asp:ListItem Text="Select" Value="0"/>
    </asp:DropDownList>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate ="ddlProviderList" InitialValue="0" ErrorMessage="Provider is not selected" />
</asp:Panel>
    <asp:Button runat="server" ID="btnView" Text="View"  OnClick="btnView_Click" />

 




    <div>
        <asp:GridView runat="server" AutoGenerateColumns="false" ID="gdvReport" ClientIDMode="Static" EmptyDataText="No data to display" PageSize="10" AllowSorting="true"  AllowPaging="true" OnPageIndexChanging="gdvReport_PageIndexChanging" >
            <Columns>
                <%--<asp:TemplateField HeaderText="ID" Visible="false">
                <ItemTemplate>
                    <%# Eval("ProviderID")%>
                </ItemTemplate>
            </asp:TemplateField>--%>
                 <asp:TemplateField HeaderText="BillDate">
                    <ItemTemplate>
                        <%#Convert.ToDateTime(Eval("BillDate")).ToShortDateString()%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Amount">
                    <ItemTemplate>
                        <%# Eval("Amount")%>
                    </ItemTemplate>
                </asp:TemplateField>
               
                <%-- <asp:TemplateField HeaderText="Description">
                <ItemTemplate>
                    <%# Eval("Description")%>
                </ItemTemplate>
            </asp:TemplateField>
                --%>
            </Columns>
                 <PagerSettings Mode="NextPreviousFirstLast" PageButtonCount="4" PreviousPageText="Previous" NextPageText="Next" />
        </asp:GridView>
    </div>
    <div>
          <asp:GridView runat="server" AutoGenerateColumns="false" ID="gvdReportForSwap" ClientIDMode="Static" EmptyDataText="No data to display" PageSize="10" AllowSorting="true"  AllowPaging="true" OnPageIndexChanging="gvdReportForSwap_PageIndexChanging" >
            <Columns>
                <%--<asp:TemplateField HeaderText="ID" Visible="false">
                <ItemTemplate>
                    <%# Eval("ProviderID")%>
                </ItemTemplate>
            </asp:TemplateField>--%>
                  <asp:TemplateField HeaderText="BillDate">
                    <ItemTemplate>
                        <%#Convert.ToDateTime(Eval("BillDate")).ToShortDateString()%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Amount">
                    <ItemTemplate>
                        <%# Eval("Amount")%>
                    </ItemTemplate>
                </asp:TemplateField>
              
                 <asp:TemplateField HeaderText="ProviderName">
                <ItemTemplate>
                    <%# Eval("ProviderName")%>
                </ItemTemplate>
            </asp:TemplateField>
                
            </Columns>
                   <PagerSettings Mode="NextPreviousFirstLast" PageButtonCount="4" PreviousPageText="Previous" NextPageText="Next" />
        </asp:GridView>
    </div>
    
    <div>
        <asp:GridView runat="server" AutoGenerateColumns="false" ID="gvdreportProviderList" ClientIDMode="Static" EmptyDataText="No data to display" PageSize="10" AllowSorting="true"  AllowPaging="true" OnPageIndexChanging="gvdreportProviderList_PageIndexChanging">
            <Columns>
                <%--<asp:TemplateField HeaderText="ID" Visible="false">
                <ItemTemplate>
                    <%# Eval("ProviderID")%>
                </ItemTemplate>
            </asp:TemplateField>--%>
                  <asp:TemplateField HeaderText="BillDate">
                    <ItemTemplate>
                        <%#Convert.ToDateTime(Eval("BillDate")).ToShortDateString()%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Amount">
                    <ItemTemplate>
                        <%# Eval("Amount")%>
                    </ItemTemplate>
                </asp:TemplateField>
              
            <%--    <asp:TemplateField HeaderText="ProviderName">
                    <ItemTemplate>
                        <%# Eval("Amount")%>
                    </ItemTemplate>
                </asp:TemplateField>--%>
                <%-- <asp:TemplateField HeaderText="Description">
                <ItemTemplate>
                    <%# Eval("Description")%>
                </ItemTemplate>
            </asp:TemplateField>
                --%>
            </Columns>
                 <PagerSettings Mode="NextPreviousFirstLast" PageButtonCount="4" PreviousPageText="Previous" NextPageText="Next" />
        </asp:GridView>
    </div>

