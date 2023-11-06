<%@ Control Language="C#" AutoEventWireup="true" CodeFile="sTOCKrEPORT.ascx.cs" Inherits="Modules_ROI_STOCKREPORT_sTOCKrEPORT" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<style>
    .hide {
        display: none;
    }
</style>

<script src="../../../Scripts/main.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $("#txtStartDate").datepicker({});
        $("#txtToDate").datepicker({});
        $("#txtDetailStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        }).datepicker("setDate", "0");
        $("#txtDetailEndDate").datepicker({
            changeMonth: true,
            changeYear: true,
        }).datepicker("setDate", "0");

        $(this).companyProfEDIT({});


    });
</script>

<div class="RO_wrapper">
    <div id="div1">

        <table class="salesTable" style="display: block;">
            <tr>
                <td>Select Store:
                </td>
                <td>
                    <select id="ddlStore" class="sfInputbox Store"></select>

                </td>
                <td>
                    <input type="text" id="txtSearchText" class="sfInputbox" style="width:150px">
                </td>
                <td>
                     <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                </td>
            </tr>
        </table>

        <div class="report-view" style="display: none;">
            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right: 2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport" style="margin-right: 2px;">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right: 2px;">PDF</button>
            </div>
        </div>

        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
    </div>
    <div id="StockDetailView" style="display:none;">
    <div id='DetailTable' style='width:100%;'>

         <div id="divForForm" class="sfformwrapper">
            <table style="display: block;">
                
                <tr>
                    <td>
                        <input type="text" class="span2 sfInputbox" data-detail="" id="txtDetailHidden" style="display: none;"/>
                    </td>
                    
                   <td>Date From:</td>
                <td> <input type="text" class="span2 sfInputbox" placeholder="Start Date" id="txtDetailStartDate" style="width: 120px;"/></td>
        
                  <td>Date To:</td>
                <td><input type="text" class="span2 sfInputbox" placeholder="End Date" id="txtDetailEndDate" style="width: 120px;"/></td>
             
                    <td>
                        <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnDetailView">View</button>
                    </td>
                </tr>
            </table>
        </div>

        <div class="report-view" style="display: none;">
            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnDetailPrint" style="margin-right: 2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnDetailExport" style="margin-right: 2px;">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnDetailPdf" style="margin-right: 2px;">PDF</button>
            </div>
        </div>

    <div id="divItemledger" class="restrowrapper" style="margin-top: 20px;"></div>

    </div>
</div>
</div>
