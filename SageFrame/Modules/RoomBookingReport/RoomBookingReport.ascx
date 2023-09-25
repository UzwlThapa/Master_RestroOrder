<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RoomBookingReport.ascx.cs" Inherits="Modules_RoomBookingReport_RoomBookingReport" %>
<script type="text/javascript">
    $(function () {
        $(this).CReports({
        });
    });
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true
 
        });
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true
        });
        $("#txtStartDate").datepicker("setDate", new Date());
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
<div class="restroform_wrapper">
            
            <div class="form-group"><label>
                From Date:
              </label>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" autocomplete="off" style="width:80px;" />
               </div>
                <div class="form-group"><label>
                To Date:
               </label>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" autocomplete="off" style="width:80px;" />
               </div>
               <div class="form-group"><label>
                Customer's Name:
               </label>              
                 <input type="text" value="" id="txtName" class="sfInputbox" style="width:150px;" /> 
                  </div>
               <div class="form-group"><label>
                Room Name:
               </label>              
                 <input type="text" value="" id="txtRoomName" class="sfInputbox" style="width:150px;" /> 
                  </div>
                 <div class="form-group">
                   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                    <%--<input type="button" id="btnPrint" style="display:none" value="Print" class="sfBtn"/>--%>
                </div>
                </div>
     <div class="report-view" style="display:none;">
       <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
        <div class="sfGridwrapper" id="divForReport" style="border: none;"></div>

    </div>
</div>

