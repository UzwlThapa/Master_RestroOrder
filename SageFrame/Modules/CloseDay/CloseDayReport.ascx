<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CloseDayReport.ascx.cs" Inherits="Modules_CloseDay_CloseDayReport" %>

<script type="text/javascript">
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
        $("#txtStartDate,#txtEndDate").datepicker("setDate", new Date());
        $(this).companyProfEDIT({
           
        });

    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table style="display:block;">
             <tr>
              
                <td>
                Start Date:
                </td>
                <td>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" autocomplete="off" style="width:100px;">
                </td>
              <td>
                End Date:
                </td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" autocomplete="off" style="width:100px;">
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

       
           <div class="sfGridwrapper" id="CloseDayReport" style="border: none;">

    </div>
</div>
    </div>

