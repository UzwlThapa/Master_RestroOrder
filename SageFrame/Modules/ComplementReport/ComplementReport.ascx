<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ComplementReport.ascx.cs" Inherits="Modules_ComplementReport_ComplementReport" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',

        });
    });
</script>


<div class="RO_wrapper">
<div>
        <div class="restroform_wrapper">
            
            <div class="form-group"><label>
                    Start Date :
                </label>
                    <input type="text" class="sfInputbox picker" id="txtStartDate" style="width:80px"/>
               </div>
               <div class="form-group"><label>
                    End Date :
               </label>
                    <input type="text" class="sfInputbox picker" id="endDate" style="width:80px"/>
              </div>
              <div class="form-group"><label>
                Room :</label>
                <select class="span2 sfInputbox" id="selroom" > </select>
                </div>
                <div class="form-group"><label>
               Table : </label>
                <select class="span2 sfInputbox" id="seltable" > </select></div>

                <div class="form-group"><label>Item Name : </label>
                 <input type="text" class="span2 sfInputbox"  id="txtItemName" /></div>
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
