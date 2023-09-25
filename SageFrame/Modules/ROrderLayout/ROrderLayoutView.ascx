<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROrderLayoutView.ascx.cs" Inherits="Modules_ROrderLayout_ROrderLayoutView" %>
<script type="text/javascript">
 $(function () {
        $(this).companyDashboardEDIT({
            HostUrl: '<%=HostUrl%>',
            UserModuleID: '<%=UserModuleID%>'
        });
    });
</script>
<div id="DialogOrderDetail" class="DialogOrderDetail"></div>
<div id="DialogDetail"></div>

<div id="DisplayCancel" style="display: none">
    <label>Canceled By : </label>
    <label class="cancelby"></label>
    <div style='display:flex'>
    <label>Split No : </label>
    <select class='splitNoCancel sfInputbox' style='width:100px;margin-left:2px;'></select>
    </div>
    <label>Reason</label><textarea class="canceltextarea sfInputbox"></textarea>
    <input type="button" value="OK" class="btnSumbit icon-save sfBtn restro-btn" style="margin-top:20px;"/>
</div>

<div id="divForRoomTableShift" class="" style="display: none">
 <div class="dialogflex" style="border-bottom:none;">
<div class="shiftLRT" style="border-right:1px solid #dcdcdc;">
       <div id="tableToShift">
        <table style="margin:0;">
            <tr>
                <td>Shift From: <span class="shiftingTableName"  style="font-weight:bold;font-size:15px;"></span></td>
            </tr>
            <tr>
                <td>Seat No: <select class="shiftingTableSeatNo sfInputbox"></select></td>
            </tr>
        </table>
    </div>
    </div>
    <div class="shiftCRT" style="border-right:1px solid #dcdcdc;">
        <table style="margin:0;">
               <tr>
                <td>Room Type : <select class="imgroomtypeforshift sfInputbox"></select></td>
            </tr>
            <tr>
                <td>Rooms : <select  class="RoomsForShift sfInputbox"></select></td>
            </tr>
        </table>
    </div>
   <div class="shiftRRT">
    <div id="shiftToTable">
          <table style="margin:0;">
            <tr>
                <td>Shift To: <span  class="shiftToTableName" style="font-weight:bold;font-size:15px;"></span></td>
            </tr>
            <tr>
                <td>Seat No: <select  class="shiftToTableSeatNo sfInputbox"></select></td>
            </tr>
            <tr>
                <td>
                    <label class="confirmShift sfBtn restro-btn" >Shift</label>
                </td>
            </tr>
        </table>
    </div> 

   </div>

</div>
          <div class ='TablesForShift' style="border-top:1px solid #dcdcdc;"></div>
        </div>
     <div class="Layoutwrapper" id='ViewTable_<%=UserModuleID%>' style="border: none;">
    </div>

<div id="LayoutBillingView" style="display:none;">
    <input type="button" value="Print" class="btnPrints sfBtn restro-btn" />
    <div id='customer-bill' style='text-align:center;width:100%;'></div>
</div>
