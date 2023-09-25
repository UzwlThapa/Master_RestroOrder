<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RoiGoodsReceiveReport.ascx.cs" Inherits="Modules_RoiGoodsReceiveReport_RoiGoodsReceiveReport" %>
<style>
.gmid:hover {background: #AC8B84;}
</style>
<script type="text/javascript">
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
       // $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
        $(this).companyProfEDIT({});
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table class="salesTable date" style="display:block;">
             <tr>
              
                <td>
                Start Date:
                </td>
                <td>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width:100px;">
                </td>
              <td>
                End Date:
                </td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width:100px;">
                </td>
                   <td>Purchase No.:
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="PO_" id="txtPurchaseNo" style="width: 120px;">
                </td>
                  <td>
              Goods Recieve No:
                </td>
              <td>
                    <input type="text" class="sfInputbox" placeholder="GM_" id="txtReceiveNo" style="width: 120px;">
                </td>
                        <td>
              Item Name:
                </td>
              <td>
                    <input type="text" class="sfInputbox" placeholder="ItemName" id="txtItemName" style="width: 120px;">
                </td>

                  <td>
              Payment Mode:
                </td>
              <td>
                    <select id="sltPayMode" class="sfInputbox" style="width: 100px">
                    <option value="0">All</option>
                    <option value="1">CASH</option>
                    <option value="2">CHEQUE</option>
                    <option value="3">SWAP</option>
                    <option value="4">CREDIT</option>
                    <option value="5">ESEWA</option>
                    <option value="6">FONEPAY</option>
                </select>
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

       
           <div class="sfGridwrapper" id="GoodsReceiveViewReport" style="border: none;">

    </div>
</div>
    </div>
               <div id="ViewReport"></div>
