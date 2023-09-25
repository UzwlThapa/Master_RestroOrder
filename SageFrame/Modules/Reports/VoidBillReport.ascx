<%@ Control Language="C#" AutoEventWireup="true" CodeFile="VoidBillReport.ascx.cs" Inherits="Modules_Reports_VoidBillReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>


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


    });
</script>
<div class="RO_wrapper">
    <div id="div1">



        <table class="salesTable" style="display:block;">
            <tr>
                <td>Start Date:
                </td>
                <td>
                    <input type="text" id="startDate" class="sfInputbox DatePick" style="width: 100px" />
                    <select id="StartHour" class="Hour"></select>
                    <select id="StartMin" class="Min"></select>
                </td>
                <td>End Date:
                </td>
                <td>
                    <input type="text" id="EndDate" class="sfInputbox DatePick" style="width: 100px" />
                    <select id="EndHour" class="Hour"></select>
                    <select id="EndMin" class="Min"></select>
                </td>

            <%--<td>Reporting Days:
                </td>
                <td>
                    <select class="sfListmenu required" name="repo" id="ReportingDays">
                        <option value="0" disabled selected>-Select-</option>
                        <option value="1">Daily</option>
                        <option value="2">Weekly</option>
                        <option value="3">Monthly</option>
                        <option value="4">Yearly</option>--%>
            <%--<option value="5">Range</option>--%>
            <%--</select>
                </td>--%>
            <%-- <td>Report Type</td>
                <td>   <select class="sfListmenu required" name="repo" id="ReportDescription">
                        <option value="0" disabled selected>-Select-</option>
                        <option value="1">Void Bill Report</option>
                        <option value="2">Vat Bill Report</option>
                        <option value="3">Service Charge</option>
                      <%--  <option value="4">Yearly</option>--%>
            <%--<option value="5">Range</option>--%>
            <%--   </select>--%>

            <%-- </td>--%>
            <%--</tr>
            
          
            <tr class="hide">
                <td id="Datess">Date :
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="Start Date" id="txtStartDate" name="startdate" required style="width:120px;"/>
                    <input type="text" class="sfInputbox" placeholder="To Date" id="txtToDate" name="startdate" required style="width:120px;"/>
                    <select class="span2 sfListmenu" id="seit" name="seit">
                        <option disabled selected>-Select-</option>--%>
            <%-- <option value="2014">2014</option>--%>
            <%-- </select>
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
            </tr>--%>

            <%--    <tr class="hide inputBtns">
                <td></td>
                <td>

                    <input type="checkbox" id="Waiter" value="1" />
                    <span style="padding-right:20px;position:relative;top:-2px;">Waiter</span>
                    <input type="checkbox" id="room" value="2" />
                    <span style="padding-right:20px;position:relative;top:-2px;"> Room</span>
                    <input type="checkbox" id="table" value="3" />
                    <span style="padding-right:20px;position:relative;top:-2px;">Table</span>
                </td>
            </tr>--%>
            <%--<tr class="hide">
                <td></td>
                <td>
                    <input type="button" class="sfBtn" id="btnView" value="View" />
                    <input type="button" class="sfBtn" id="btnViewWeekly" value="View" />
                    <input type="button" class="sfBtn" id="btnViewMonthly" value="View" />
                    <input type="button" class="sfBtn" id="btnViewYearly" value="View" />
                    <input type="button" class="sfBtn" id="btnViewRange" value="View" />
                </td>
            </tr>--%>
            
                <td>
                    <input type="button" class="sfBtn" id="StartEndReportView" value="View" />
                </td>
            </tr>
        </table>

        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
    </div>
<%--Total Amount: &nbsp; <label id="SumAmount"></label>--%>
<%--<div id="DailyReportByRoom"></div>--%>
<asp:HiddenField ID="HiddenField1" ClientIDMode="Static" runat="server" />
