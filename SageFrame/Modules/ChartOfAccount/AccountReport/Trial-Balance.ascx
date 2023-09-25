<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Trial-Balance.ascx.cs" Inherits="Modules_ChartOfAccount_AccountReport_Trial_Balance" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<style type="text/css">
   
    .hide {
        display: none;
    }

    .ui-datepicker td {
        padding: 7px;
    }

    .ui-datepicker .ui-datepicker-prev,
    .ui-datepicker .ui-datepicker-next {
        display: none;
    }
</style>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $(this).companyProfEDIT({
            CompanyName: '<%=CompanyName%>'
        });
        


    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table class="salesTable" style="display:block;">
            <tr>
                <td id="Datess">Date :
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="Date" id="txtStartDate" name="startdate" required style="width: 120px;" />
                </td>
                <td>
                      <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                     <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;display:none;">Print</button>
             </td>
            </tr>
        </table>

        <div class="restrowrapper sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
    </div>

</div>


