<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Cbms_SalesReturnBook.ascx.cs" Inherits="Modules_CBMS_Dashboard_Cbms_SalesReturnBook" %>
<style>
/*#npd-table-div {
    display: none;
    }*/
table {
    border-collapse: collapse;
}

</style>
<%--<script src="https://unpkg.com/jspdf@latest/dist/jspdf.min.js"></script>--%>
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

    });

</script>

<script type="text/javascript">

    $(function () {

        $(this).CReports({
        });
    });

    // resizeIframe();
</script>
<div class="RO_wrapper">
<div>
<table style="display:block;">
<tr>

    <td><label>From Date: </label></td>
    <td><input type="text" id="txtStartDate" class="sfInputbox DatePick" autocomplete="off" style="width:100px;" /></td>
    <td><input type="hidden" id="txtEngMnthYear" /></td>

    <td><label>To Date: </label></td>
    <td><input type="text" id="txtEndDate" class="sfInputbox DatePick" autocomplete="off" style="width:100px;" /></td>
    <td><input type="hidden" id="txtEngToDate" /></td>
    <td>
             <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewReturnedSales">View Returns</button>
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

<div id="salesBookDiv" style="display:none;background-color: white;" >
  
       <div class="Report_header">
            <h4 style="text-align:center;margin:0;"><label id="lblCompanyName"></label></h4>
          
            <p style="text-align:center;margin:0;"><label id="lblCompanyAddress"></label>, PAN : <label id="lblCompanyPAN"></label></p>
           <p style="text-align:center;margin:0;"> Sales Return Book</p>
            <p style="text-align:center;margin:0;"> From : <label id="lblMonth"></label>  &nbsp; &nbsp;   To : <label id="lblYear"></label></p>
               </div>
           
              <table id="salesBookTbl" class="reportsprint report_L" style="border-collapse:collapse;margin:0;">
            <thead>
            <tr>
                <th class='salesbook-brd' rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Credit Note Number</th>
                <th class='salesbook-brd' rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Credit Note Date</th>
                <th colspan="3" class="invoicee" style='text-align:center;border:1px solid #575757;padding:2px;'>Invoice</th>
                <th class='salesbook-brd' rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;' >Total Sales</th>
                <th class='salesbook-brd' rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Non Taxable Sales</th>
                <th class='salesbook-brd' rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Export Sales</th>
                <th class='salesbook-brd' rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Discount</th>
                <th colspan="2" class="invoicee" style='text-align:center;border:1px solid #575757;padding:2px;'>Taxable Sales</th>
                <th rowspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Reason For Return</th>
            </tr>
            <tr>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Bill No</th>
                <th style='text-align:left;border:1px solid #575757;padding:2px;'>Buyer's Name</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;' >Buyer's PAN Number</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Amount</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Tax</th>
            </tr>
        </thead>
        <tbody></tbody>
        <tfoot></tfoot>
    </table>
</div>
</div>
</div>