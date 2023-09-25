<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemBalanceView.ascx.cs" Inherits="Modules_ItemBalance_ItemBalanceView" %>

<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',
            Username: '<%=Username%>',
        });
        $("#btnAdd").click(function () {
            $("#divForForm").dialog({
                'title': 'Opening Balance',
                width: '400',
                height: 'auto',
                modal: true,
                position: ['center', 'center']
            });
        });
        
    });
</script>


<div class="RO_wrapper">
<div class="restro-title clearfix">
        <h3>Opening Balance</h3>
         <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn" value="Add" />
        </div>
       
        <div id="divForForm" style="display: none;" class="sfformwrapper">
            <table style="display: block;">
                <tr>
                    <td>
                        <label>Item :</label>
                    </td>
                    <td>
                        <%--<select id="dd_itemName" name="Item" class="sfInputbox" style="width:200px;"></select>--%>
                        <input type="text" id="itemName" class="sfInputbox" style="width: 150x; float: left;" />

                        <input type="hidden" id="dd_itemName" class="sfInputbox" />
                    </td>
                </tr>
                <tr>
                    <td>
                        <label>Store :</label>
                    </td>
                    <td>
                        <select id="dd_store" name="Store" class="sfInputbox" style="width: 150px;"></select>

                    </td>
                </tr>
                <tr>
                    <td>
                        <label>Opening Balance :</label>
                    </td>
                    <td>
                        <input type="text" id="txtOpeningBalance" name="OpeningBalance" class="sfInputbox" /></td>
                    <td>
                        <%--<input type="text" id="itemUnit" class="sfInputbox" style="width:23px;"/>--%>
                        <select id="itemUnit" class="sfInputbox" style="width: 60px;">
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label>Opening Rate :</label>
                    </td>
                    <td>
                        <input type="number" id="txtOpeningRate" name="OpeningRate" class="sfInputbox" />

                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="button" id="btnSave" value="SAVE" class="sfLocale icon-save sfBtn" />
                        <input type="button" id="CancelItems" value="Cancel" class="sfLocale icon-close sfBtn">
                    </td>
                </tr>
            </table>
        </div>
    <div id="sotablebalance" class="restrowrapper"></div>
</div>
