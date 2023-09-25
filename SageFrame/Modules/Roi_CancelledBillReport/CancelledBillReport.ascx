<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CancelledBillReport.ascx.cs" Inherits="Modules_Roi_CancelledBillReport_CancelledBillReport" %>

<style type="text/css">
    
</style>
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
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $("#txtToDate").datepicker().datepicker("setDate", new Date());
        $(this).companyProfEDIT({});
    });
</script>
<div class="RO_wrapper">
<div class="restro-title clearfix">
        <h3>Cancelled Bill Report</h3></div>
    <div id="div1">
       <div class="restroform_wrapper">
            
            <div class="form-group"><label>
                Start Date:
               </label>
                    <input type="text" id="txtStartDate" class="sfInputbox" style="width:80px;"/>
              </div>
              <div class="form-group"><label>
                End Date:
              </label>
                    <input type="text" id="txtEndDate" class="sfInputbox" style="width:80px;"/>
              </div>
                <div class="form-group"><label>
                    Cancelled By:
               </label>
                    <select id="selcancelledby" class="sfInputbox"></select>
               </div>
               <div class="form-group">
                     <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
               <%-- <td>Reporting Days:
                </td>
                <td>
                    <select class="sfInputbox sfListmenu required" name="repo" id="ReportingDays">
                        <option value="0" disabled selected>-Select-</option>
                        <option value="1">Daily</option>
                        <option value="2">Weekly</option>
                        <option value="3">Monthly</option>
                        <option value="4">Yearly</option>
                        <option value="5">Range</option>
                    </select>
                </td>
                <td></td>
                <td></td>--%>
            </tr>
            <%--<tr class="hide">
                <td id="Datess">Date :
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="Start Date" id="txtStartDate" name="startdate" required style="width:120px;"/>
                    <input type="text" class="sfInputbox" placeholder="To Date" id="txtToDate" name="startdate" required style="width:120px;"/>
                    <select class="span2 sfListmenu" id="seit" name="seit">
                        <option disabled selected>-Select-</option>
                         <option value="2014">2014</option>
                    </select>
                    <select class="span2" id="month" name="seit">
                        <option disabled selected>-Select-</option>
                        <option value="1">January</option>
                        <option value="2">February</option>
                        <option value="3">March</option>
                        <option value="4">April</option>
                        <option value="5">May</option>
                        <option value="6">June</option>
                        <option value="7">July</option>
                        <option value="8">August</option>
                        <option value="9">September</option>
                        <option value="10">October</option>
                        <option value="11">November</option>
                        <option value="12">December</option>
                    </select>
                </td>
            </tr>

            <tr class="hide inputBtns">
                <td></td>
                <td>

                    <input type="checkbox" id="Waiter" value="1" checked="checked"/>
                    <span style="padding-right:20px;position:relative;top:-2px;">Waiter</span>
                    <input type="checkbox" id="room" value="2" checked="checked" />
                    <span style="padding-right:20px;position:relative;top:-2px;"> Room</span>
                    <input type="checkbox" id="table" value="3" checked="checked"/>
                    <span style="padding-right:20px;position:relative;top:-2px;">Table</span>
                </td>
            </tr>--%>
           <%-- <tr class="hide">
                <td></td>
                <td>
                    <input type="button" class="restro-btn sfBtn" id="btnView" value="View" />
                    <input type="button" class="restro-btn sfBtn" id="btnViewWeekly" value="View" />
                    <input type="button" class="restro-btn sfBtn" id="btnViewMonthly" value="View" />
                    <input type="button" class="restro-btn sfBtn" id="btnViewYearly" value="View" />
                    <input type="button" class="restro-btn sfBtn" id="btnViewRange" value="View" />
                </td>
            </tr>--%>
       </div>
<div class="report-view" style="display:none;">
  <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
          
        <div class="sfGridwrapper" id="DailyReport" style="border:none;">
        </div>

    </div>

    <div class="CancelWithReason" style="display:none;">
        Give Reason:
        <textarea id="txtCancelWithReason" placeholder="Type the Reason.."></textarea>
        <%--<input type="text" id="txtCancelWithReason" placeholder="Type the Reason.." />--%>
    </div>
</div>
<div id="BillingView" style="display:none;margin-top:20px;">
    <input type="button" id="btnPrints" value="Print" class="restro-btn sfBtn restro-btn" />
    <div id='customer-bill' style='text-align:center;width:100%;'></div>
</div>