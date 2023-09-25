<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderItemCancelReport.ascx.cs" Inherits="Modules_Reports_OrderItemCancelReport" %>
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
                    <input type="text" id="startDate" class="sfInputbox DatePick" />
                
                </td>
                <td>End Date:
                </td>
                <td>
                    <input type="text" id="EndDate" class="sfInputbox DatePick" />
        
                </td>
                       <td>Cancelled By: </td>
                <td>
                        <select id="selCancelledBy" class="sfInputbox">
                        </select>
                    </td>
                       
                 
                  <td>Room: </td>
                <td>
                        <select id="selroom" class="sfInputbox">
                        </select>
                    </td>
                      </tr>
                  <tr>
                     <td>Table: </td>
                <td>
                        <select id="seltable" class="sfInputbox">
                        </select>
                    </td>
                       <td>Responsible Person: </td>
                <td>
                        <select id="selResponsible" class="sfInputbox">
                        </select>
                    </td>
                        
         
             <td>Ordered By: </td>
             
                         <td>
                        <select id="selOrderedBy" class="sfInputbox">
                        </select>
                    </td>
                  <td>Item </td>
                <td>
                        <input id="txtItem" type="text" class="sfInputbox"/></td>
                
                
                <td colspan="2">
            
                     <button type="button" class="sfBtn restro-btn fa fa-eye" id="StartEndReportView">View</button>
            </tr>
        </table>
        <div class="report-view" style="display:none;">
            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
         <%-- <div class="sfGridwrapper" id="filter" style="display: none;">
            <table class="sfGridwrapper" style="display:block;">
                <tr>
                    <td><label>Filter By : </label></td>
                    <td><label>Responsible Person </label>
                       <%-- <select id="selResponsible" class="sfInputbox">
                            <option value="">All</option>
                            <option value="Waiter">Waiter</option>
                            <option value="Customer">Customer</option>
                            <option value="Chef">Chef</option>  
                        </select>
                        <input id="selResponsible" type="text" class="sfInputbox"/>
                    </td>
                    <td><label>Item</label>
                        <input id="txtItem" type="text" class="sfInputbox"/></td>
                         <td><label>Cancelled By</label>
                        <input id="txtCancelled" type="text" class="sfInputbox"/></td>
                      <td><label>Ordered By</label>
                        <input id="txtOrderBy" type="text" class="sfInputbox"/></td>
                        <td><label>Room</label>
                        <input id="txtRoom" type="text" class="sfInputbox"/></td>
                        <td><label>Table</label>
                        <input id="txtTable" type="text" class="sfInputbox"/></td>
                     
                </tr>
            </table>
        </div>--%>

        <div class="sfGridwrapper" id="OrderItemCancelReport" style="border: none;">
        </div>
    </div>
</div>