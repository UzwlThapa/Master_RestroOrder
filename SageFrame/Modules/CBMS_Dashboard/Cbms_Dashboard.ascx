<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Cbms_Dashboard.ascx.cs" Inherits="Modules_CBMS_Dashboard_Cbms_Dashboard" %>

<script type="text/javascript">
    $(function () {
        $(this).CReports({
        });
    });
</script>

<div class="CBMS-dash clearfix">
   <ul>
        <li>
          
            <div class="CBMS-dashTotal">
            <span id="lblTotalSales" class="CBMS-dash-number"></span>
            <span class="CBMS-dash-Title">Total Bills</span>
            </div>
              <img align="middle" style="width:60px; height:60px;" src="/PageImages/sale-report.png">
       </li>
  
        <li>
           
            <div class="CBMS-dashTotal">
            <span id="lblSyncedSales" class="CBMS-dash-number"></span>
            <span class="CBMS-dash-Title">Synced Bills</span>
            </div>
             <img align="middle" style="width:60px; height:60px;" src="/PageImages/sync-sales.png">
        </li>

        <li>
           
             <div class="CBMS-dashTotal">
            <span id="lblUnSyncedSales" class="CBMS-dash-number"></span>
            <span class="CBMS-dash-Title"> UnSynced Bills</span>
            </div>
             <img align="middle" style="width:60px; height:60px;" src="/PageImages/unsync-sales.png">
        </li>

        <li>
           
             <div class="CBMS-dashTotal">
            <span id="lblSalesReturnedBills" class="CBMS-dash-number"></span>
            <span class="CBMS-dash-Title"> Total Sales Returned Bills</span>
            </div>
             <img align="middle" style="width:60px; height:60px;" src="/PageImages/Total-Sale-Returned-Bill.png">
        </li>

        <li>
           
            <div class="CBMS-dashTotal">
            <span id="lblUnSyncedReturnedBills" class="CBMS-dash-number"></span>
            <span class="CBMS-dash-Title">UnSynced Returned Bills</span>
            </div>
             <img align="middle" style="width:60px; height:60px;" src="/PageImages/UnSynced-Returned-Bills.png">
        </li>
    </ul>
</div>

<!--    <li><span class="CBMS-dash-Title" style="font-size:22px;"> Sync All Bills</span><input type="button" id="btnSyncAllSales" class="sfBtn" value="Click Here" /></li>   -->
   
            
      

<div class="cbms-datas">
    <table id="tblSyncedData" class="thbg tableForlist dataTable no-footer" style="display:none;">
        <thead>
            <tr>
                <th>Synced Date</th>
                <th>No of Bills</th>
                <th>Total Sales</th>
                <th>Taxable Sales</th>
                <th>Vat</th>
            </tr>
        </thead>
        <tbody id="cbmsSyncedData">

        </tbody>
    </table>
</div>