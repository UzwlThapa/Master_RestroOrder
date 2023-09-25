<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemSalesReport.ascx.cs" Inherits="Modules_ItemSalesReport_ItemSalesReport" %>

<script type="text/javascript">
    $(document).ready(function () {
        $("#startDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#startDate").datepicker().datepicker("setDate", new Date());
        $("#EndDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#EndDate").datepicker().datepicker("setDate", new Date());
        $(this).companyProfEDIT({});
    });
</script>

<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <h3>Sales Report</h3>
    </div>

        <div class="restroform_wrapper">
            
            <div class="form-group"><label>Item Categories :</label>
                
                    <select id="ddlCategory" class="sfInputbox"></select>
                </div>
                <div class="form-group">
                    <label>Filter By :</label> 
                    <select id="selectFilterBy" class="sfInputbox">
                       <%-- <option value="0">All</option>
                        <option value="1">Kot</option>
                        <option value="2">Bar</option>
                        <option value="95">Bakery</option>
                        <option value="97">Pizza</option>--%>
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
                    <label>Start Date : </label>
                    <input type="text" id="startDate" class="sfInputbox DatePick" style="width:80px" />
                    <select style="display:none;" id="StartHour" class="sfInputbox Hour"></select>
                    <select style="display:none;" id="StartMin" class="sfInputbox Min"></select>
                </div>
                <div class="form-group">
                    <label>End Date : </label>
                    <input type="text" id="EndDate" class="sfInputbox DatePick" style="width:80px"/>
                    <select style="display:none;" id="EndHour" class="sfInputbox Hour"></select>
                    <select style="display:none;" id="EndMin" class="sfInputbox Min"></select>
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
   
</div>  </div>