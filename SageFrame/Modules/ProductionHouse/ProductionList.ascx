<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductionList.ascx.cs" Inherits="Modules_ProductionHouse_ProductionList" %>

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
        <h3>Production List</h3>
    </div>
    <div id="div1">
        <table class="salesTable" style="display: block;">
            <tr>
                <td>Store Name : </td>
                <td>
                    <select id="SelStoreName" name="SelStoreName" class="sfInputbox"></select></td>


                <td>From Date:</td>
                <td>
                    <input type="text" class="span2 sfInputbox" placeholder="Start Date" id="txtStartDate" style="width: 100px;" /></td>


                <td>To Date:</td>
                <td>
                    <input type="text" class="span2 sfInputbox" placeholder="End Date" id="txtEndDate" style="width: 100px;" /></td>

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

        <div class="sfGridwrapper" id="ProductionList" style="border: none;">
        </div>
    </div>

    <div id="DivForViewItemByID" style="display: none;"></div>
</div>
