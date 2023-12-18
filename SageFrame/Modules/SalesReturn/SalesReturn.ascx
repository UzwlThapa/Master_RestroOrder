<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SalesReturn.ascx.cs" Inherits="Modules_SalesReturn_SalesReturn" %>

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
                <input type="text" id="startDate" class="sfInputbox DatePick" style="width: 80px" />
                <select style="display: none;" id="StartHour" class="sfInputbox Hour"></select>
                <select style="display: none;" id="StartMin" class="sfInputbox Min"></select>
            </div>
            <div class="form-group">
                <label>End Date:</label>
                <input type="text" id="EndDate" class="sfInputbox DatePick" style="width: 100px" />
                <select style="display: none;" id="EndHour" class="sfInputbox Hour"></select>
                <select style="display: none;" id="EndMin" class="sfInputbox Min"></select>
            </div>
            <div class="form-group">
                <label>
                    Bill No:</label>
                <input type="text" id="txtBillNo" class="sfInputbox" style="width: 80px">                
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
         </div>


            <div class="sfGridwrapper" id="DailyReport"></div>
            <div class="CancelWithReason" style="display: none;">
                <table style="display: block; margin-bottom: 0;">
                    <tr>
                        <td>
                            <label>Reason:</label>
                        </td>
                        <td>
                            <textarea id="txtCancelWithReason" placeholder="Type the Reason.." class="sfInputbox"></textarea></td>
                    </tr>
                </table>
                <%--<input type="text" id="txtCancelWithReason" placeholder="Type the Reason.." />--%>
            </div>
            <div id="divForViewSalesReport" style="display: none;"></div>
            <div id="BillingView" style="display: none;">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right: 2px;">Print</button>
                <input type="button" id="btnPayBill" value="Pay Bill" class="sfBtn restro-btn" style="display: none;" />
                <div id='customer-bill' style='text-align: center; width: 100%;'></div>
            </div>
        </div>


        <div id="EditBill" style="display: none;">
        </div>
    </div>
</div>
