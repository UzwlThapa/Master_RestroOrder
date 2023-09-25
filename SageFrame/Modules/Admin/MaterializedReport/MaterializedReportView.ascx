<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MaterializedReportView.ascx.cs" Inherits="Modules_Admin_MaterializedReport_MaterializedReportView" %>
<script type="text/javascript">
    $(function () {
        $(this).CReports({
            CompanyName: '<%=CompanyName %>',
            Address : '<%=Address %>',
            PhoneNo : '<%=PhoneNo %>',
            Pan: '<%=PanNo%>'
        });
    });
    $(document).ready(function () {
        jQuery("#txtStartDate").nepaliDatePicker({
            npdMonth: true,
            npdYear: true,
            npdYearCount: 10 // Options | Number of years to show
        });
        jQuery("#txtEndDate").nepaliDatePicker({
            npdMonth: true,
            npdYear: true,
            npdYearCount: 10 // Options | Number of years to show
        });
        $('#tabs').tabs();
    });
</script>
<div class="RO_wrapper">
<div class="restro-title clearfix">
        <h3>Materialize Report</h3></div>
    <div id="div1">
        <table class="salesTable" style="display:block;"> 
            <tr>
               <%-- <td>
                    <label>User:</label>
                </td>
                <td>
                    <div class="sfListmenu clearfix">
                        <asp:DropDownList ID="userddlist" CssClass="sfInputbox" Style="width: auto;" runat="server">
                        </asp:DropDownList>
                    </div>
                </td>--%>
                <td>
                From Date:
                </td>
                <td>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" autocomplete="off" style="width:100px;" />
                </td>
                <td>
                    To Date:</td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" autocomplete="off" style="width:100px;" />
                </td>
                <td>
                   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View Report</button>
                    <%--<asp:Button ID="btnView" CssClass="sfBtn" runat="server" OnClick="btnView_Click1" />--%>
                
                  

               </td>
            </tr>
        </table>
         <div class="report-view" style="display:none;">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                     <a href="#" class="sfBtn restro-btn" onclick="$('.dataTables_scroll').tableExport({type:'xml',escape:'false'});">XML</a>
                    </div>
        <%--<asp:GridView ID="GridView1" runat="server">
            <Columns>
                <asp:TemplateField HeaderText="FiscalYear">
                    <ItemTemplate>
                        <%# Eval("FiscalYear") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Bill_No">
                    <ItemTemplate>
                        <%# Eval("Bill_No") %>
                    </ItemTemplate>
                </asp:TemplateField>  
                 <asp:TemplateField HeaderText="Customer_Name">
                    <ItemTemplate>
                        <%# Eval("Customer_Name") %>
                    </ItemTemplate>
                </asp:TemplateField>  
                 <asp:TemplateField HeaderText="Customer_PAN">
                    <ItemTemplate>
                        <%# Eval("Customer_PAN") %>
                    </ItemTemplate>
                </asp:TemplateField>    
         </Columns>
        </asp:GridView>--%>
       

        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>

    </div>
    <div id="BillingView" style="display:none;margin-top:20px;">
    <div id='customer-bill' style='text-align:center;width:100%;'></div>
</div>
</div>
