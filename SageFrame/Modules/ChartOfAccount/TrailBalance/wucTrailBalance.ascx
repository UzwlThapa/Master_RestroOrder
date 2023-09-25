<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucTrailBalance.ascx.cs" Inherits="Modules_ChartOfAccount_TrailBalance_wucTrailBalance" %>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
        $("#btnAdd").click(function () {
            $("#divForFinancialAc").hide();
            $("#btnAdd").hide();
            $(".AccountForm").show();
        });

        $(".DatePick").datepicker({
            dateFormat: "yy-mm-dd",
            changeMonth: true,
            changeYear: true,
        }).datepicker("setDate", "0");
          
    });
</script>
<style type="text/css">
    .isGrouptrue {
        font-weight: bold;
    }
    
</style>
<div class="RO_wrapper">
<div>
       <table style="display:block;">
            <tr>
                <td>
                    <label>
                        Select Date : </label></td> 
                <td><input type="text" class="sfInputbox DatePick" style="width:100px" id="txtDate" name="Date" />
                   
                </td>
                <td style="display:none;">
                    <label>Show Zero : </label>
                    </td>
                    <td style="display:none;">
                        <select id="sltIsZero" class="sfInputbox" style="width:100px;">
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select></td>
                <td>
                    <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                    <%--<input type='button' value="Excel" id="button" class="sfBtn restro-btn"/>--%>
                    <%--<input type='button' value="Pdf" id="buttonPdf"/>--%>
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
     <div id="divForBalanceSheet" class="restrowrapper"></div>
       <div id="divForFinancialDetails" class="restrowrapper"></div>
        </div>
</div>
