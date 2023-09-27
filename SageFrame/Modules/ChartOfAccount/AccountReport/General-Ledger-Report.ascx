<%@ Control Language="C#" AutoEventWireup="true" CodeFile="General-Ledger-Report.ascx.cs" Inherits="Modules_ChartOfAccount_AccountReport_VoucherReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<style type="text/css">
    .hide {
        display: none;
    }

    /*.ui-datepicker td {
        padding: 7px;
    }

    .ui-datepicker .ui-datepicker-prev,
    .ui-datepicker .ui-datepicker-next {
        display: none;
    }*/
</style>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtToDate").datepicker().datepicker("setDate", new Date());
        $(this).companyProfEDIT({
            CompanyName: '<%=CompanyName%>',
            FinancialID: '<%=FinancialID%>',
            Fromdate: '<%=Fromdate%>',
            Todate: '<%=Todate%>'
        });

    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table class="salesTable" style="display: block;">
            <tr>
                <td id="Datess">Dates :
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="Start Date" id="txtStartDate" name="startdate" required style="width: 120px;" />
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="To Date" id="txtToDate" name="startdate" required style="width: 120px;" />
                </td>
                <td>
                    <input type="hidden" id="hdnFinancialID" />
                    <label for="voucherDropDownList"></label>
                    <input type="text" class="sfInputbox" placeholder="Financial A/C" id="voucherDropDownList" autocomplete="off" style="width: 500px;" />
                </td> 
                <td>
                    <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                </td>

            </tr>
        </table>
        <div class="report-view" style="display: none;">
            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right: 2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport" style="margin-right: 2px;">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right: 2px;">PDF</button>
            </div>
        </div>
        <div class="restrowrapper" id="DailyReport" style="border: none;">
        </div>
    </div>


    <div id="divFinancialView" class="popup-tbl" style="display: none;"></div>

</div>


