0<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VerifiedReport.ascx.cs" Inherits="Modules_RecquistionSlip_VerifiedReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        var IsPossible = true;
        $("#txtStartDate").datepicker('setDate', 'today');
        $("#txtStartDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtToDate").datepicker('setDate','today');
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });

        $('body').off('keyup').on('keyup', function (e) {
            e.preventDefault();
            var key = e.key.toLowerCase();
            if (IsPossible) {
                if (e.ctrlKey && e.altKey && key == "a") {
                    $('#div2').hide();
                    $('#div1').show();
                }
                if (e.ctrlKey && e.altKey && key == "d") {
                    jConfirm('Are You Sure you want to delete  ?', 'Delete', function (confirmed) {
                        if (confirmed) {
                            $.get('/Modules/RoReport/SalesReport.asmx/UpdateAcc', {}, function () { alert("Success") })
                        }
                    });
                }
            }
            
        });

       


        $(this).companyProfEDIT({});
    });
</script>
<div class="RO_wrapper">
    <div id="div2">
        <table style="display:block;">
<tr>
    <td><label>Recieved By : </label></td>

    <td><asp:DropDownList ClientIDMode="Static" ID="ddlRecievedBy" name="ddlRecievedBy" CssClass="sfInputbox required" runat="server" Style="width: 150px;"></asp:DropDownList></td>
      
    <td><button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button></td>
    <td><input type="hidden" name="Roles" id="Roles" /></td>
    </tr>
</table>
    
      <div class="report-filter">
             <span>Search :</span> <input type="text" class="sfInputbox" id="txtSearch" /></div>
<div id="tabs" style="display:none;">
    <ul>
        <li><a href="#tabs-1">Verification</a></li>
        <li><a href="#tabs-2">Verified</a></li>
    </ul>
       <div id="tabs-1" style="padding-left:0;padding-right:0;">
       <table id="tblForVerification" class="reportsprint">
            <thead>
                <tr>
                    <th>Issue. No.</th>
                    <th>Issued From</th>
                    <th>Issued To</th>
                    <th>Issued On</th>
                    <th class="tdcenter">Action</th>
                </tr>
            </thead>
            <tbody id="Verification-list"></tbody>
        </table>
    </div>

    <div id="tabs-2"  style="padding-left:0;padding-right:0;">
            <table id="tblVerified" class="reportsprint">
            <thead>
                <tr>
                  <th>Issue. No.</th>
                    <th>Issued From</th>
                    <th>Issued To</th>
                    <th>Issued On</th>
                    <th class="tdcenter">Action</th>
                </tr>
            </thead>
            <tbody id="Verified-list"></tbody>
        </table>
           
        </div>
   
</div>

    <div id="issueDialog">
</div>

    </div>

<div id="div1" style="display: none;">



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
                 <input type="text" class="sfInputbox" id="txtSalesSearch" />
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
    </div>

</div>
