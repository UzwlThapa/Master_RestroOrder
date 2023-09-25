<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SalesOldReport.ascx.cs" Inherits="Modules_SalesReportOld_SalesOldReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
        $("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
        $("#txtStartDate,#txtEndDate").datepicker("setDate", new Date());
        $(this).companyDashboardEDIT({});
    });
</script>
<div class="RO_wrapper">
<div class="restro-title clearfix">
       </div>
    <div id="div1">
        <table class="ReportTable"  style="display:block;">           
            <tr>
                <td>Start Date : </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="Start Date" id="txtStartDate" autocomplete="off" style="width:120px;"/>
                </td>
                <td> End Date : </td>
                <td>
                 <input type="text" class="sfInputbox" placeholder="End Date" id="txtEndDate" autocomplete="off" style="width:120px;"/>
                </td>
                
                 <td></td>
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
        <div class="sfGridwrapper" id="ReservationReport" style="border:none;">
        </div>
    </div>

</div>

