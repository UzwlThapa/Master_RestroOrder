<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ConsumptionReport.ascx.cs" Inherits="Modules_ConsumptionReport_ConsumptionReport" %>
<script type="text/javascript">
    $(function () {
        $(this).CReports({
        });
    });
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
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());
        $('#tabs').tabs();
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
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width:100px;" />
                </td>
                <td>
                End Date:
                </td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width:100px;" />
                </td>
                <td>
                    <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
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
          <div class="sfGridwrapper" id="divForConsumptionReport" style="border: none;"></div>

    </div>
</div>
