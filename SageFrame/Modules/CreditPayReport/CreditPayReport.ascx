<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CreditPayReport.ascx.cs" Inherits="Modules_CreditPayReport_CreditPayReport" %>
<script type="text/javascript">
    $(function () {
        $(this).CReports({
        });
    });
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        });
        $("#txtStartDate,#txtEndDate").datepicker("setDate", new Date());
        $('#tabs').tabs();
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
<div class="restroform_wrapper">
            
            <div class="form-group"><label>
                From Date:
              </label>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width:80px;" />
               </div>
                <div class="form-group"><label>
                To Date:
               </label>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width:80px;" />
               </div>
               <div class="form-group"><label>
                Membership Type:
               </label>
                    <select id="selMembershipType" class="sfInputbox" >
                        <option value="-1">All</option>
                        <option value="true">Customer</option>
                        <option value="false">Vendor</option>
                     
                    </select>
                 <input type="text" value="" id="txtName" class="sfInputbox" placeholder="Customer/Vendor Name" style="width:150px;" /> </td>
                  </div>
                   <div class="form-group"><label>
               Payment Type:
               </label>
             
                    <select id="selPaymentType" class="sfInputbox" style="width:100px;" >
                        <option value="-1">Both</option>
                         <option value="0">Paid</option>
                        <option value="1">Credit</option>
                     
                    </select>
                </div>
                 <div class="form-group">
                   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                    <%--<input type="button" id="btnPrint" style="display:none" value="Print" class="sfBtn"/>--%>
                </div>
                </div>
     <div class="report-view" style="display:none;">
       <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
        <div class="sfGridwrapper" id="divForCreditPayReport" style="border: none;"></div>

    </div>
</div>

  <div id="customer-bill" style="display:none;">
        </div>
<div id="goodReveivedDiv" class="popup-tbl" style="display: none;">
     </div>

<div id="getReceiptbill" class="popup-tbl" style="display: none;">
     </div>
