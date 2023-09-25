<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucForCounter.ascx.cs" Inherits="Modules_Roi_Counter_wucForCounter" %>
<script type="text/javascript">
    $(function () {
        $(this).Counters({
        });
    });
</script>
<div id="tabs">
          <ul>
            <li><a href="#tabs-1">Counter Transaction</a></li>
    
          </ul>
          <div id="tabs-1"> 
    <div id="divForNote">
        <table id="CounterInfo" style="display:block;">
            <tr>
                <td>CostCenter Name :</td>
                <td><Select id="selCostCenter" class="sfInputbox" style="width:150px;">
                    <option selected disabled value=""> -select- </option>
                    </Select>
                </td>
                <td>Counter Number :</td>
                 <td><Select id="txtCN" class="sfInputbox" style="width:150px;">
                    </Select>
                </td>
                </tr>
                <tr>
                <td>New Counter Person :</td>
                <td><Select id="selNewCP" class="sfInputbox" style="width:150px;">
                    <option selected disabled value=""> -select- </option>
                    </Select>
                </td>
           
                <td>Old Counter Person :</td>
                <td><Select id="selOldCP" class="sfInputbox" style="width:150px;">
                    <option selected disabled value=""> -select- </option>
                    </Select>
                </td>
            </tr>


        </table>
        <h4>Bills :</h4>
        <table id="tableForBills" style="display:block;">
          
                <tr class="noteFromDbForBills">
                </tr>
        </table>
         <h4>Coins :</h4>
        <table id="tableForCoins" style="display:block;">
                <tr class="noteFromDbForCoins">
                </tr>
        </table>

        <table class="close" style="display:none;">
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
            <input type="text" id="hdnCurrencyIcon" style="border: 0;width:45px;" readonly/>
            <input type="text" id="txtTotalCount" style="border: 0;" value="0" />
        </h4>
        <br />
       <input type="checkbox" id="ckbxIsOpening"/><label for="ckbxIsOpening">&nbsp IS Opening?</label><br />
       <%-- <h5>Open Drawer Balance: 
            <input type="text" id="txtOpenDrawerBalance" style="border: 0;" value="0" />
        </h5>--%>
        <br />
        <input class="sfLocale icon-save sfBtn" type="button" id="AddOpenDrawer" value="Save" />
    </div>
</div>
    <div id="CounterTotalListing"></div>
</div>