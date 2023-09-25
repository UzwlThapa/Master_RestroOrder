<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AllOrderDetailReport.ascx.cs" Inherits="Modules_Reports_AllOrderDetailReport" %>
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
        <h3>Sales Report</h3>
    </div>
        <div class="restroform_wrapper">
<div class="form-group">
                    <label>Start Date : </label>
                    <input type="text" id="txtStartDate" class="sfInputbox" style="width:80px" />
                </div>
                <div class="form-group">
                    <label>End Date : </label>
                    <input type="text" id="txtEndDate" class="sfInputbox " style="width:80px"/>
                </div>
           
                <div class="form-group">
                    <label>Filter By :</label> 
                    <select id="selectFilterBy" class="sfInputbox">
                    </select>                 
                </div>
              <div class="form-group">
                    <label>Table Name :</label> 
                    <select id="seltable" class="sfInputbox">
                    </select>
                   
                </div>
                     <div class="form-group">
                    <label>View By : </label>
                    <select id="selectViewBy" class="sfInputbox">
                        <option value="1">Daily</option>
                        <option value="2">Summary</option>
                    </select>
               
              </div>
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
    <div id="reportDisplay"></div>
   
</div>
</div>