<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PurchaseBook.ascx.cs" Inherits="Modules_PurchaseBook_PurchaseBook" %>
<script type="text/javascript">
    $(function () {
        $(this).CReports({
        });
    });
    
</script>
<div class="RO_wrapper">
<div class="restro-title clearfix">
       
<table style="display:block;">
<tr>
    <td><label>Start Date : </label></td>
    <td><input type="text" id="txtMnthYear" class="sfInputbox" autocomplete="off" style="width:100px;"/></td>
    <td><label>End Date : </label></td>
    <td><input type="text" id="txtMnthYearEnd" class="sfInputbox" autocomplete="off" style="width:100px;"/></td>
    <td>
        <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewPurchase">View PurchaseBook</button>
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
<div id="purchaseBookDiv" style="display:none;background-color: white;" >
  
        <div class="Report_header">
            <h4 style="text-align:center;margin:0;"><label id="lblCompanyName"></label></h4>
          
            <p style="text-align:center;margin:0;"> PAN : <label id="lblCompanyPAN"></label></p>
           
            <p style="text-align:center;margin:0;"> Duration of Sales : Month <label id="lblMonth"></label> Year <label id="lblYear"></label></p>
        <p style="text-align:center;margin:0;"> Purchase Book </p>
               </div>
           
              <table id="salesBookTbl" class="reportsprint" style="border-collapse:collapse;margin:0;">
            <thead>
            <tr>
                <th colspan="5" class="invoicee" style='text-align:center;border:1px solid #575757;padding:2px;'>Invoice</th>
                <th colspan="2" class='salesbook-brd' style='text-align:center;border:1px solid #575757;padding:2px;'>Total Purchase</th>
                <th colspan="3" class='salesbook-brd' style='text-align:center;border:1px solid #575757;padding:2px;'>Discount</th>
                <th colspan="2" style='text-align:center;border:1px solid #575757;padding:2px;'>Taxable Sales</th>
            </tr>
            <tr>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Date</th>
                  <th style='text-align:center;border:1px solid #575757;padding:2px;'>Description</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Invoice No</th>
                <th style='text-align:left;border:1px solid #575757;padding:2px;'>Vendor's Name</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Vendor's PAN Number</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Vat Total</th>
                <th style='text-align:center;border:1px solid #575757;padding:2px;'>Non-Vat Total</th>
                <th style='text-align:right;border:1px solid #575757;padding:2px;'>Vat Discount</th>
                <th style='text-align:right;border:1px solid #575757;padding:2px;'>Non-Vat Discount</th>
                <th style='text-align:right;border:1px solid #575757;padding:2px;'>Extra Discount</th>
                <th style='text-align:right;border:1px solid #575757;padding:2px;'>Amount</th>
                <th style='text-align:right;border:1px solid #575757;padding:2px;'>Tax</th>
            </tr>
        </thead>
        <tbody></tbody>
        <tfoot></tfoot>
    </table>
</div>
</div>
</div>