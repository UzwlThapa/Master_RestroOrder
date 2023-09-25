\<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ClosingReportView.ascx.cs" Inherits="Modules_Admin_MaterializedReport_MaterializedReportView" %>
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
        //jQuery("#txtEndDate").datepicker({
        //    dateFormat: 'yy-mm-dd',
        //    changeMonth: true,
        //    changeYear: true,
        //    maxDate: '0',
        //    onClose: function (selectedDate) {
        //        jQuery("#txtStartDate").datepicker("option", "maxDate", selectedDate);
        //    }
        //});
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
                    <input type="button" class="sfBtn" id="btnView" value="View" />
                 <input type="button" class="sfBtn" id="btnViewStatement" value="View Statement" />
                    <input type="button" id="btnPrint" style="display:none" value="Print" class="sfBtn"/>
                </td>
            </tr>
        </table>
     

        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>

    </div>
</div>
