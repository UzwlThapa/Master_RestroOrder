<%@ Control Language="C#" AutoEventWireup="true" CodeFile="openDrawer.ascx.cs" Inherits="Modules_Roi_OpenDrawer_openDrawer" %>

<script type="text/javascript">
    $(function () {
        $(this).openDrawers({
        });
        var $tabs = $("#tabs").tabs();
    });
</script>
<div id="tabs">
    <ul>
        <li><a href="#tab">Drawer</a></li>
        <%--<li><a href="#tab2">Close Drawer</a></li>--%>
    </ul>
    <div id="tab" class="tabs">
       <%--<ul>
           <li>CostCenter:<select id="selCostCenter" class="sfInputbox" style="width:150px;">
                        <option selected disabled value=""> -select- </option>
                    </select></li>
       </ul> --%>

    <div class="drawer-radio-btn">
        Select :
                         <label class="control control--radio">Open Drawer<input type="radio" id="rdoCustomer" class="required" name="Customer" value="0"/> <div class="control__indicator"></div>
    					</label>
                        <label class="control control--radio">Close Drawer<input type="radio" id="rdoVender" class="required" name="Customer" value="1" /> <div class="control__indicator"></div>
    					</label>
    					</div>
    <div  class="shows" style="display: none;">
        <h3 class="open">Open Drawer: Cash Drawer</h3>
        <h3 class="close" style="display: none;">Close Drawer: Cash Drawer</h3>
        <hr />
        <h4>Enter the current drawer count (you'll record your deposit after this step)</h4>
        <div id="divForNote">
            <input type="hidden" id="hdnIsClosing" value="false" />
               <h4 style="margin-top:10px;">Bills :</h4>
            <table id="tableForBills" style="display:block;">
                    <tr class="noteFromDbForBills">
                    </tr>
            </table>
            <h4>Coins :</h4>
            <table id="tableForCoins" style="display:block;">
                    <tr class="noteFromDbForCoins">
                    </tr>
            </table>


            <h4>TOTAL COUNT: 
                 <input type="text" id="hdnCurrencyIcon" class="hdnCurrencyIcon" style="border: 0; width: 45px;" readonly />
                <input type="hidden" id="hdnCurrencyIcons" />
            <input type="text" id="txtTotalCount" style="border: 0;" value="0" readonly />
            </h4>
            <table style="display:block;"> 
            <tr>
            <td class="close" style="display:none;"><h5>Open Drawer Balance: 
                 <input type="text" class="hdnCurrencyIcon" style="border: 0; width: 45px;" readonly />
            <input type="text" id="txtOpenDrawerBalance" style="border: 0;" value="0" readonly />
            </h5></td>
            <td>Approved By:
         <select id="txtApprovedBy">
             <option value="" selected disabled>-select- </option>
         </select></td>
         </tr>
         </table>
            <div class="drawer-button" style="margin-top:10px;">
            <input class="sfLocale restro-btn sfBtn" type="button" id="AddOpenDrawer" value="OPEN DRAWER" />
            </div>
        </div>
    </div>
</div>
</div>
