<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CustomerBalanceReportView.ascx.cs" Inherits="Modules_CustomerBalanceReport_CustomerBalanceReportView" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',
            Username: '<%=Username%>',
            numpin: "<%=numpin%>"
        });
          // resizeIframe();
    });
</script>


<div class="RO_wrapper">
    <div id="div1">
        <%-- <table class="salesTable" style="display:block;">

  <tr>
        <td>
            <label>Customer Name :</label>
        </td>
        <td>
            <select id="ddCusName" >

            </select>
        </td>
   
                <td>Start Date:
                </td>
                <td>
                    <input type="text" id="startDate" class="DatePick" style="width: 73px" />
                    
                </td>
                <td>End Date:
                </td>
                <td>
                    <input type="text" id="EndDate" class="DatePick" style="width: 86px" />

                </td>
         <td>
                    <input type="button" class="sfBtn" id="StartEndReportView" value="View" />
                </td>
     </tr>
        </table>--%>
            <div class="report-view">
        
                       <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
         <div class="report-filter">
             <span>Search :</span> <input type="text" class="sfInputbox" id="txtSearch" /></div>
        <div id="membeshipformlist"></div>
           
        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
    </div>
        <div id="membeshipformlist2" style="display:none;">
        </div>
    <div id="BalanceTransactionlist" style="display:none;">
        </div>

        <div id="BillingView" style="display:none;">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrintsBill" style="margin-right:2px;">Print</button>
            <div id='customer-bill' style='text-align:center;width:100%;'></div>
        </div>

   <div id="sendSmsDialog" style="display:none;">
        <table style="width:auto">
            <tr>
                <td>Mobile Number :</td>
                <td><input id="mobileNumber" type="text" class="sfInputbox" disabled /></td>
            </tr>
            <tr>
                <td>Message:</td>
                <td><textarea id="smsMessage" rows="3" class="sfInputbox" style="width:300px;"></textarea></td>
            </tr>
            <tr><td></td>
            <td> <input id="btnSend" type="button" value="Send" class="sfBtn restro-btn" />
        <input id="btnCancel" type="button" value="Cancel" class="sfBtn restro-btn" /></td>
        </table>
       
    </div>
</div>
<input type="hidden" id="hdIsCustomer" runat="server" clientIDMode="static"/>

<div id="getReceiptbill" class="popup-tbl" style="display: none;">
     </div>

