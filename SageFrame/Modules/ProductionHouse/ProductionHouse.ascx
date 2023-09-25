<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ProductionHouse.ascx.cs" Inherits="Modules_ProductionHouse_ProductionHouse" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            userName: '<%=userName%>',
        });
    });
    </script>
<div class="RO_wrapper">
    <div>
        <table class='reportsprint' style="margin: 0; display: block;">
            <tr>
                <t4 colspan="4">
                    <h4 style="margin: 0;">Previous Productions</h4>
                </t4>
 
            </tr>
            <tr>
                <td>
                    <input type="text" id="OldProductionDetails" name="OldProductionDetails" class="sfInputbox OldProductionDetails" placeholder="Previous Productions" />
                    <input type="hidden" id="hdOldProductionDetails" name="hdOldProductionDetails" class="sfInputbox hdOldProductionDetails" />
                </td>

            </tr>
        </table>

        <table class='reportsprint' style="margin: 0; display: block;">
            <tr>
                <t4 colspan="4">
                    <h4 style="margin: 0;">Output</h4>
                </t4>
 
            </tr>
            <tr>
                <td>
                    <input type="text" id="itemName" name="itemName" class="sfInputbox itemName" placeholder="Item Name" />
                    <input type="hidden" id="hditemName" name="hditemName" class="sfInputbox hditemName" />
                </td>


                <td>
                    <input type="text" id="txtQuantity" class="sfInputbox" name="txtQuantity" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" placeholder="Quantity" /></td>

                <td>
                    <input type="text" id="txtUnit" class="sfInputbox txtUnit" name="txtUnit" style="width: 100px;" placeholder="Unit" readonly />
                    <input type="hidden" id="hdtxtUnit" name="hdtxtUnit" class="sfInputbox hdtxtUnit" />
                </td>
                <td>
                    <select id="SelStoreName" name="SelStoreName" class="sfInputbox"></select>
                </td>

            </tr>
        </table>
        <table id="tableForIngredient" class='reportsprint' style="margin: 0; display: block;">



            <thead>
                <tr>
                    <td colspan="4">
                        <h4 style="margin: 0;">Input</h4>
                    </td>
                </tr>
                <tr>
                    <th>Ingredient</th>
                    <th>Quantity</th>
                    <th>Unit</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <tr>

                    <td>
                        <input type="text" class="sfInputbox txtIngredient" style="width: 200px;" />
                        <input type="hidden" class="sfInputbox hdnIngredientID" />
                    </td>

                    <td>
                        <input type="text" class="sfInputbox txtIngredientQuantity" onkeypress="return IntegerAndDecimal(event,this);" style="width: 100px;" />
                        <input type="hidden" class="sfInputbox hdnItemID" value="" />
                    </td>
                    <td>
                        <input type="text" class="sfInputbox txtiUnit" style="width: 100px;" readonly />
                        <input type="hidden" class="sfInputbox hdUnit" />
                    </td>

                    <td>
                        <label class="icon-addnew sfBtn addTextboxIngredient restro-btn"></label>
                    </td>
                </tr>
            </tbody>
        </table>
        <input type="button" id="btnSave" value="Save" class="sfLocale icon-save sfBtn" style="margin-bottom: 15px;" />
        <input type="button" id="btnCancel" value="Clear" class="sfLocale icon-close sfBtn" style="margin-bottom: 15px;" />
    </div>
</div>
