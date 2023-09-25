<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BillsReport.ascx.cs" Inherits="Modules_BillsReport_BillsReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("#startDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#startDate").datepicker().datepicker("setDate", new Date());
        $("#endDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#endDate").datepicker().datepicker("setDate", new Date());
        $(this).companyProfEDIT({});    
    });
</script>

<div class="RO_wrapper">
    <div id="div1">
        <div class="restroform_wrapper">
            
            <div class="form-group"><label>
                    Start Date :
               </label>
                    <input type="text" class="sfInputbox picker" id="startDate" style="width:80px" />
               </div>
               <div class="form-group"><label>
                    End Date :
               </label>
                    <input type="text" class="sfInputbox picker" id="endDate" style="width:80px"/>
              </div>
               <div class="form-group"><label>
                    Payment Mode :
               </label>
                    <select id="payOption" class="sfInputbox" style="width:80px">
                        <option value="0">All</option>
                        <option value="2">Cheque</option>
                        <option value="3">Swap</option>
                        <option value="5">eSewa</option>
                        <option value="6">Fonepay</option>
                    </select>
               </div>
               <div class="form-group"><label>
                    Provider Name :</label>
                    <select id="providerOption" class="sfInputbox"></select>
              </div>
              <div class="form-group"><label>
                    View By :
               </label>
                    <select id="viewOption" class="sfInputbox">
                        <option value="0">All</option>
                         <option value="1">Day</option>
                        <option value="2">Summary</option>
                       
                        
                 </select>
                 </div>
             <div class="form-group">
                     <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
           </div>
     </div>
                     <div class="report-view" style="display:none;">
                          <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
           <div id="reportDisplay">  
    </div>
     </div>   
     </div>
 