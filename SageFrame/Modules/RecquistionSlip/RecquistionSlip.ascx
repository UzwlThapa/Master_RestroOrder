<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RecquistionSlip.ascx.cs" Inherits="Modules_RecquistionSlip_RecquistionSlip" %>
<script type="text/javascript">
    $(document).ready(function () {
        $(this).companyProfEDIT({});
    });
</script>
<div class="RO_wrapper">
<table style="display:block;">
<tr>
    <td><label>Store : </label></td>

    <td><select id="ddlStore" class="sfInputbox"> </select></td>

    <td>   <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button></td>
    </tr>
</table>

<div id="tabs" style="display:none;">
    <ul>
        <li><a href="#tabs-1">Recquistion Slip</a></li>
        <li><a href="#tabs-2">Requested Recquistions</a></li>
    </ul>
    <div id="tabs-1">
        <input type="button" class="sfBtn restro-btn" id="btnAddItem" style="display:none;margin:10px;" value="Add Items">
        <div id="outOfStockList" class="reportsprint">
    
        </div>
    </div>

    <div id="tabs-2">
        <div id="RecquistionsSent" class="reportsprint" style="display:none;" >
            <table id="tblRequested">
                <thead>
                    <tr>
                        <th>Recq. No.</th>
                        <th>Requested Items</th>
                        <th>Request From</th>
                        <th>Requested By</th>
                        <th>Requested On</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="Requested-list"></tbody>
            </table>
        </div>
    </div>
</div>


<div id="divAddForm" style="display:none;">
    <input type="hidden" id="hdfItemId" />
    <table>
        <tr>
            <td>Item : </td>
            <td>
                <input type="text" id="txtItemName" name="ItemName" class="sfInputbox" />
            </td>
        </tr>
         <tr>
            <td>Quantity : </td>
            <td>
                <input type="text" onkeypress="return validateFloatKeyPress(this,event)" id="txtQnty" name="ItemQnty" class="sfInputbox" />
            </td>
        </tr>
         <tr>
            <td>Unit : </td>
            <td>
                <select id="ddlItemUnit" name="ItemUnit" class="sfInputbox"></select>
            </td>
        </tr>
    </table>
    <label class="sfBtn restro-btn" id="btnAdd">Add</label>
    <label class="sfBtn restro-btn" id="btnAddForEdit">Add</label>
</div>


<div id="RecquistionEdit" style="display:none;">
<div class="dataTables_wrapper no-footer">
    <label class="sfBtn restro-btn" id="btnAddItemForUpdate">Add Items</label>
    <table id="tblItems" class="sfGridwrapper display tablee-section">
        <thead>
            <tr>
                <th>Item Name</th>
                <th>Quantity</th>
                <th>Symbol</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>
    <label class="sfBtn restro-btn" id="btnUpdateRecquistion">Update</label>
    <label class="sfBtn restro-btn" id="btnCancel">Cancel</label>
</div>
</div>
</div>