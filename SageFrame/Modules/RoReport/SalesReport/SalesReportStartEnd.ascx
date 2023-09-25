<%@ Control Language="C#" AutoEventWireup="true" CodeFile="SalesReportStartEnd.ascx.cs" Inherits="Modules_RoReport_SalesReport_SalesReportStartEnd" %>
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
                <label>Payment Mode:</label>

                <select id="sltPayMode" class="sfInputbox" style="width: 100px">
                    <option value="">All</option>
                    <option value="CASH">CASH</option>
                    <option value="CHEQUE">CHEQUE</option>
                    <option value="CARD">SWAP</option>
                    <option value="CREDIT">CREDIT</option>
                    <option value="ESEWA">ESEWA</option>
                    <option value="FONEPAY">FONEPAY</option>
                </select>
            </div>
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
                    Bill Status:</label>

                <select id="sltStatus" class="sfInputbox" style="width: 80px">
                    <option value="-1">All</option>
                    <option value="1">Paid</option>
                    <option value="0">Unpaid</option>
                </select>
            </div>
            <div class="form-group">
                <label>
                    Order Type:</label>

                <select id="selOrderType" class="sfInputbox" style="width: 80px">
                </select>
            </div>
            <div class="form-group">
                <label>
                    Cancel:</label>

                <input id="selBillCancel"  type="checkbox" />
                    
            </div>
            <div class="form-group">
                <label>
                    Sales Return:</label>

                <input id="selSalesReturn" type="checkbox" />
            </div>
            <div class="form-group">
                <label>
                    Customer Name:</label>

                <input type="text" id="txtCustName" class="sfInputbox" style="width: 80px">                
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


        <div id="membeshipformlist" style="display: none;">
        </div>

        <div id="membeshipformlist2" style="display: none;">
        </div>

        <div id="divEditCustomer" style="display: none;"></div>
    </div>
</div>
