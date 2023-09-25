<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RestoItemView.ascx.cs" Inherits="Modules_RestoItem_RestoItemView" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            UserModuleID: '<%=userModuleID %>',
            Username: '<%=Username%>'
        });
    });
</script>
<div id="tabs">
<ul>
       
        <li><a href="#tabs-7">Item</a></li>

     
    </ul>
    <div id="tabs-7">
     <input type="button" id="btnAddItem" value="Add" class="sfLocale icon-addnew sfBtn">
     


    <table id="tblRestoItem" style="display:block;" >
        <tr>
            <td>
                Item:
            </td>
            <td>
                <select id="dd_itemName" name="ItemName" class="sfInputbox" style="width:200px;"></select>
                
            </td>
            <td>
                Unit:
            </td>
            <td>
                  <select id="dd_unitName" name="UnitName" class="sfInputbox" style="width:200px;"></select>
               
            </td>
        </tr>
        <tr>
            <td>
                Purchase Rate:
            </td>
            <td>
                <input type="text" id="txtPurchaseRate" class="sfInputbox" name="PurchaseRate" />
            </td>
            <td>
                Selling Rate:
            </td>
            <td>
                <input type="text" id="txtSellingRate" class="sfInputbox" name="SellingRate" />
            </td>
        </tr>
         <tr>
            <td>
                Valid From:
            </td>
            <td>
                <input type="text" id="txtValidFrom" class="sfInputbox" name="ValidFrom" readonly />
            </td>
           
        </tr>
    </table>
    
<div>
    <input type="button" id="btnSaveItem" class="sfLocale icon-save sfBtn" value="Save">
    <input type="button"  id="btnCancelItem" class="sfLocale icon-close sfBtn" value="Cancel">
    </div>
        <br />

<div id="SortableRestoItem"></div>
    </div>
    </div>
 <br />       