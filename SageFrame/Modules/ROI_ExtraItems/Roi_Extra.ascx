<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Roi_Extra.ascx.cs" Inherits="Modules_ROI_ExtraItems_Roi_Extra" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
        });

       
    });
</script>

<div class="RO_wrapper">
<div class="restro-title clearfix">
         <input type="button" id="btnAdd" value="Add" class="icon-addnew sfBtn" />
        </div>
       
        <div id="extraItemForm" style="display: none;" class="sfformwrapper">
            <table style="display:block;">
                <tr>
                    <td>Extra Item Name <span style="color:red;">*</span>: </td>
                    <td><input type="text" id="txtExtraItemName" name="ExtraItemName" class="sfInputbox" /></td>
                </tr>
                <tr>
                    <td>Price <span style="color:red;">*</span>: </td>
                    <td><input type="text" id="txtPrice" name="Price" class="sfInputbox" /></td>
                </tr>
                <tr>
                    <td>Is Active : </td>
                    <td><input type="checkbox" id="chkActive" name="Active" checked /></td>
                </tr>
            </table>
            <div id="divForIngredient" style="margin-bottom:15px;">
                <h5>Ingredient Entry</h5>
                <table id="tableForIngredient" style="margin: 0;display:block;" class="reportsprint">
                    <thead>
                        <tr>
                            <th>Ingredient</th>
                            <%--<th class="unit">Units</th>--%>
                            <th>Quantity</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <input type="text" class="sfInputbox txtIngredient" style="width: 300px;" />
                                <input type="hidden" class="sfInputbox hdnIngredientID" />
                            </td>
<%--                            <td class="unit">
                                <select class="sfInputbox selIngredientUnit" name="quentity" style="width: 100px;">
                                </select>
                            </td>--%>
                            <td>
                                <input type="text" class="sfInputbox txtIngredientQuantity" style="width: 100px;" />
                                <input type="hidden" class="sfInputbox hdnItemID" value="" />
                            </td>
                            <td>
                                <label class="sfLocale icon-addnew sfBtn addTextboxIngredient restro-btn"></label>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <table>
                <tr>
                    <td><input type="button" id="btnSave" value="Save" class="sfLocale icon-save sfBtn" />
                        <input type="button" id="btnCancel" value="Cancel" class="sfLocale icon-close sfBtn" /></td>
                </tr>

            </table>
        </div>

        <div id="divForExtraItemList">

        </div>
    </div>

</div>