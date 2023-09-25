<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CostCenterReport.ascx.cs" Inherits="Modules_RoReport_CostCenterReport_CostCenterReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });

        $(this).companyProfEDIT({});

        // resizeIframe();

    });
</script>
<div class="RO_wrapper">
    <div id="div1">



        <div class="restroform_wrapper">

            
            <div class="form-group">
                <label>Start Date: </label>
                <input type="text" id="startDate" class="sfInputbox DatePick" style="width: 100px" autocomplete="off" />
            </div>
            <div class="form-group">
                <label>End Date:</label>
                <input type="text" id="EndDate" class="sfInputbox DatePick" style="width: 100px" autocomplete="off"/>
            </div>
            
            
            <div class="form-group">
                <button type="button" class="sfBtn restro-btn fa fa-eye" id="StartEndReportView">View</button>
            </div>

           
         <div class="report-view" style="display: none;">
             <div class="report-printt">
                 <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right: 2px;">Print</button>
                 <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport" style="margin-right: 2px;">Excel</button>
                 <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right: 2px;">PDF</button>
             </div>
             <div class="report-filter">
                 <span>Search :</span>
                 <input type="text" class="sfInputbox" id="txtSearch" />
             </div>
         </div>


            <div class="sfGridwrapper" id="DailyReport"></div>
           
            <div id="divForViewSalesReport" style="display: none;"></div>
            <div id="BillingView" style="display: none;">
               
                <div id='customer-bill' style='text-align: center; width: 100%;'></div>
            </div>
        </div>


        <div id="membeshipformlist" style="display: none;">
        </div>

        <div id="membeshipformlist2" style="display: none;">
        </div>
    </div>
</div>
