<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucAdjusmentReport.ascx.cs" Inherits="Modules_Admin_Roi_InventoryReport_wucAdjusmentReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());
     
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $(this).companyProfEDIT({});
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table class="salesTable" style="display:block;">
             <tr>
                <td>
                Start Date:
                </td>
                <td>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width:80px;" />
                </td>
              <td>
                End Date:
                </td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width:80px;" />
                </td>
              
                <td>
                       <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewAdjustment">View</button>
                </td>
            </tr>
     
        </table>
<div class="report-view" style="display:none;">
     <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
         <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
    </div>
</div>

<asp:HiddenField ID="HiddenField1" ClientIDMode="Static" runat="server" />

