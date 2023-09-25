<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucForCounterTotal.ascx.cs" Inherits="Modules_Roi_CounterTotal_wucForCounterTotal" %>

<script type="text/javascript">
    $(function () {
        $(this).CounterTotals({
            userName: '<%=userName%>',
        });
       
    });
</script>
<%--<style>
        .no-close .ui-dialog-titlebar-close {display: block; }

</style>--%>
<!-- <div style="font-family: Arial">
    <h2 class="open"><u>Counter Total</u></h2>
    <h2 class="open">Drawer: Cash Drawer</h2>
    <h2 class="close" style="display: none;">Close Drawer: Cash Drawer</h2>
    <hr />
    <h3>Enter the current drawer count (you'll record your deposit after this step)</h3> -->
<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Counter Total</a></li>

    </ul>

    <div id="tabs-1">
        <div id="divForNote">
            <table id="CounterInfo" style="display: block;">
                <tr>
                    <td>Cost Center Name :</td>
                    <td>
                        <select id="selCostCenter" class="sfInputbox" style="width: 150px;">
                            <option selected disabled value="">-select- </option>
                        </select>
                    </td>
                    <td>Counter Number :</td>
                    <td>
                        <select id="txtCN" class="sfInputbox" style="width: 150px;">
                            <%--<option selected disabled value="">-select- </option>--%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div class="drawer-radio-btn">
        Select :
                         <label class="control control--radio">Open Counter<input type="radio" id="rdoCustomer" class="required" name="Customer" value="0"/> <div class="control__indicator"></div>
    					</label>
                        <label class="control control--radio">Close Counter<input type="radio" id="rdoVender" class="required" name="Customer" value="1" /> <div class="control__indicator"></div>
    					</label>
    					</div>
                        <%--<input type="checkbox" id="ckbxIsOpening" /><label for="ckbxIsOpening">&nbsp IS Closing?</label><br />--%>
                    </td>
                    </tr>
                    <tr>
                    <td colspan="3" style="display:none;" class="closes">
                        <h5>Open Drawer Balance: 
         <input type="text" class="hdnCurrencyIcon" style="border: 0; width: 45px;" readonly />
                            <input type="text" id="txtOpenDrawerBalance" style="border: 0;" value="0" readonly />
                        </h5>
                    </td>
                </tr>
            </table>
            <div class="shows" style="display: none;">
            <h4>Bills :</h4>
            <table id="tableForBills" style="display: block;">
                <tr class="noteFromDbForBills">
            </table>
            <h4>Coins :</h4>
            <table id="tableForCoins" style="display: block;">

                <tr class="noteFromDbForCoins">
                </tr>
            </table>

            <table class="close" style="display: none;">
                <thead>
                    <tr>
                        <th>Cheque:</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>In $:
                        <input type="text" id="txtCheque" placeholder="Add Check" /></td>
                    </tr>
                </tbody>
            </table>

            <h4><strong>TOTAL COUNT: </strong>
                <input type="hidden" id="hdnCurrencyIcons" />
                <input type="text" id="hdnCurrencyIcon" class="hdnCurrencyIcon" style="border: 0; width: 45px;" readonly />
                <input type="text" id="txtTotalCount" style="border: 0;" value="0" readonly />
            </h4>
            <table style="display: block;">
                <tr>
                    <td>
                        <h5>Approved By: 
             <select id="txtApprovedBy">
                 <option selected disabled value="">-select- </option>
             </select>
                        </h5>
                    </td>
                </tr>
            </table>
            <br />
            <input class="sfLocale icon-save sfBtn" type="button" id="AddOpenDrawer" value="Save" />
        </div>
            </div>
        <br />
        <br />
        <div id="CounterTotalListing"></div>
        <div id="showNote" style="display:none;"></div>
        <input type="hidden" id="hdnCounter" />
        <input type="hidden" id="hdnCenter" />
    </div>
    </div>
