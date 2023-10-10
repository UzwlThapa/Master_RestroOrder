<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClosingReport3_Monthly.ascx.cs" Inherits="Modules_Admin_ClosingReport3_Monthly_ClosingReport3_Monthly" %>
<script src="../../Scripts/main.js"></script>
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
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());
        $('#tabs').tabs();
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <div class="restroform_wrapper">
            
            <div class="form-group"><label>
                Start Date:
               </label>
                
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width:100px;" />
                </div>
            <div class="form-group"><label>
                End Date:
              </label>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width:100px;" />
               </div>
              
               <div class="form-group">
                   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewStatement">View Statement</button>
                   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewDatewise">View Datewise</button> 
              </div>
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
