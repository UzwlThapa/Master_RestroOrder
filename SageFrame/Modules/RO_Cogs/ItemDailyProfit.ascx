<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemDailyProfit.ascx.cs" Inherits="Modules_RO_Cogs_ItemDailyProfit" %>
<script>
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            onClose: function (selectedDate) {
                jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            }
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());
    });
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
    });
</script>

<div class="RO_wrapper">
            <table style="display:block;">
                <tr> 
                    <td>Start Date: </td>
                    <td>  <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width:100px;" /> </td>
                    <td>End Date: </td>
                                 
                    <td> <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width:100px;" /> </td>
                    <td>Item :  </td>   
                     <td>
                    <select id="selItem" class='sfInputbox' style='width:150px;'>
                                                <option value="0" selected>--ALL--</option>
                                             </select>
                    </td>

                    <td> <label id="btnViewItemReport" class="sfBtn restro-btn">View</label></td>
                </tr>
            </table>
      <div class="report-view"> 
             <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
         </div>
        <div id="divItemReport" class="" style="background:#FFF;padding:15px;"></div>
</div>
