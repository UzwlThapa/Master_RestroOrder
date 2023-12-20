<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemShiftReport.ascx.cs" Inherits="Modules_Reports_ItemShiftReport" %>
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
        <h3>Item Shift Report</h3></div>
    <div id="div1">
   <div class="restroform_wrapper">
      
                <div class="form-group"><label>Item Name: </label>
               <%-- <td><select class="span2 sfInputbox" id="selItemName" > </select></td>--%>
                <input type="text" class="span2 sfInputbox" placeholder="Item Name" id="txtItem" /></div>
                
                  <div class="form-group"><label>Date From:</label>
                 <input type="text" class="span2 sfInputbox DatePick" id="txtStartDate" style="width:80px"/>
                 </div>
                     
                  <div class="form-group"><label>Date From:</label>
                <input type="text" class="span2 sfInputbox DatePick" id="txtEndDate" style="width:80px"/>
                </div>

              

               
                 
            

          <div class="form-group"><label>Table From : </label>
                <select class="span2 sfInputbox" id="seltableFrom" > </select></div>

                
                <div class="form-group"><label> Table To :</label>
                 <select class="span2 sfInputbox" id="selTableTo" > </select></div>

                
                <div class="form-group"><label>Shifted By :</label>
                <select class="span2 sfInputbox" id="selShiftedBy" > </select></div>
            
              <div class="form-group">
                     <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                   
               </div>
        <div class="report-view" style="display:none;">
             <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>

        <div class="sfGridwrapper" id="ItemShiftReport" style="border:none;"></div>
    </div>
     </div>

   

