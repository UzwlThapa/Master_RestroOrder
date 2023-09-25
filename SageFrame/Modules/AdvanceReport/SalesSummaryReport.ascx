<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SalesSummaryReport.ascx.cs" Inherits="Modules_AdvanceReport_SalesSummaryReport" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        $("#txtEndDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());
        $(this).companyProfEDIT({});
    });
</script>


<div class="RO_wrapper">
<div class="restro-title clearfix">
        <h3>Sales Summary Report</h3></div>
    <div id="div1">


        
        <table class="salesTable" style="display:block;">
      
            <tr>
                <td>Room : </td>
                <td><select class="span2 sfInputbox" id="selroom" > </select></td>

                <td>Table : </td>
                <td><select class="span2 sfInputbox" id="seltable" > </select></td>

                
                <td> Invoice No : </td>
                <td> <input type="text" class="span2 sfInputbox"  id="txtInvoiceNo" /></td>

                
                <td>ProviderName : </td>
                <td><select class="span2 sfInputbox" id="selProviderName" > </select></td>
                 </tr>
            <tr>

                <td>Customer : </td>
                <td><select class="span2 sfInputbox" id="selCustomer" > </select></td>

               
                <td>Waiter : </td>
                <td><select class="span2 sfInputbox" id="selWaiter" > </select></td>


                 <td>Cashier : </td>
                <td><select class="span2 sfInputbox" id="selCashier" > </select></td>

                     <td>PaymentMode : </td>
                <td><select class="span2 sfInputbox" id="selPaymentMode" > </select></td>
                 </tr>
            <tr>
              <td>From Date:</td>
                <td> <input type="text" class="span2 sfInputbox" placeholder="Start Date" id="txtStartDate" /></td>

                
                  <td>To Date:</td>
                <td><input type="text" class="span2 sfInputbox" placeholder="End Date" id="txtEndDate" /></td>
             <%--    </tr>
            <tr>--%>

                <td>From Time :</td>
                <td>
                    <select class="span2 sfInputbox" id="txtTimeFrom">
                        <option value="0">All</option>
                        <option value="1">1 : 00</option>
                        <option value="2">2 : 00</option>
                        <option value="3">3 : 00</option>
                        <option value="4">4 : 00</option>
                        <option value="5">5 : 00</option>
                        <option value="6">6 : 00</option>
                        <option value="7">7 : 00</option>
                        <option value="8">8 : 00</option>
                        <option value="9">9 : 00</option>
                        <option value="10">10 : 00</option>
                        <option value="11">11 : 00</option>
                        <option value="12">12 : 00</option>
                         <option value="13">13 : 00</option>                   
                        <option value="14">14 : 00</option>
                        <option value="15">15 : 00</option>
                        <option value="16">16 : 00</option>
                        <option value="17">17 : 00</option>
                        <option value="18">18 : 00</option>
                        <option value="19">19 : 00</option>
                        <option value="20">20 : 00</option>
                        <option value="21">21 : 00</option>
                        <option value="22">22 : 00</option>
                        <option value="23">23 : 00</option>
                        <option value="24">24 : 00</option>
                    </select>
                </td>
                  <td> To Time:</td>
                <td>
                    <select class="span2 sfInputbox" id="txtTimeTo" >
                        <option value="">All</option>
                        <option value="1">1 : 00</option>
                        <option value="2">2 : 00</option>
                        <option value="3">3 : 00</option>
                        <option value="4">4 : 00</option>
                        <option value="5">5 : 00</option>
                        <option value="6">6 : 00</option>
                        <option value="7">7 : 00</option>
                        <option value="8">8 : 00</option>
                        <option value="9">9 : 00</option>
                        <option value="10">10 : 00</option>
                        <option value="11">11 : 00</option>
                        <option value="12">12 : 00</option>
                         <option value="13">13 : 00</option>                   
                        <option value="14">14 : 00</option>
                        <option value="15">15 : 00</option>
                        <option value="16">16 : 00</option>
                        <option value="17">17 : 00</option>
                        <option value="18">18 : 00</option>
                        <option value="19">19 : 00</option>
                        <option value="20">20 : 00</option>
                        <option value="21">21 : 00</option>
                        <option value="22">22 : 00</option>
                        <option value="23">23 : 00</option>
                        <option value="24">24 : 00</option>
                    </select>
                </td>
            
                </tr>
            <tr>
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
        <div class="sfGridwrapper" id="SummarySalesReport" style="border:none;">
        </div>
    </div>

   
</div>
