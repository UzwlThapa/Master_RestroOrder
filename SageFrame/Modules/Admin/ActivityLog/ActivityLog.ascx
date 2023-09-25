<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ActivityLog.ascx.cs" Inherits="Modules_Admin_ActivityLog_ActivityLogReportView" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtEndDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtStartDate,#txtEndDate").datepicker("setDate", new Date());
        $(this).DailyChalanEDIT({

        });
        $('#tabs').tabs();
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table class="salesTable" style="display: block;">
            <tr>
                <td>
                    <label>User:</label>
                </td>
                <td>
                    <div class="sfListmenu clearfix">
                        <asp:DropDownList ID="userddlist" CssClass="sfInputbox lstUser" Style="width: auto;" runat="server" ClientIDMode="Static">
                        </asp:DropDownList>
                    </div>
                </td>
                <td>
                    <label>From Date:</label>
                </td>
                <td>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width: 100px;" />
                </td>
                <td>
                    <label>To Date:</label></td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width: 100px;" />
                </td>
                <td>
                      <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View Log</button>
                </td>

            </tr>
        </table>
    
        </div>
          <div class="report-view" style="display:none;">
          <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
             </div>
        <div id="DailyReport" style="border: none;">
    </div>
</div>
