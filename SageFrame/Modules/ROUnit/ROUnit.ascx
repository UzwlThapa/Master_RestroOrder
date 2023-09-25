<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROUnit.ascx.cs" Inherits="Modules_ROUnit_ROUnit" %>
<script type="text/javascript">
    $(function () {

        $(this).companyProfEDIT({
        });
    });


</script>
<div id="tabs">
    <ul>
        <li><a href="#tab">Unit</a></li>
    </ul>
    <div id="tab">

        <label id="AddUnit" class="sfLocale icon-addnew sfBtn">Add</label>
        <div id="UnitTable">
            <table id="RO-unit">
                <tr>
                    <td>Unit :
                    </td>
                    <td>
                        <input type="text" id="textUnit" name="unit" class="required sfInputbox"/>
                    </td>
                </tr>
            </table>
        </div>
        <div id="UnitButton">
            <label id="btnUnitSave" class="sfLocale icon-save sfBtn">Save</label>
            <label id="btnUnitCancel" class="sfLocale icon-close sfBtn">Cancel</label>
        </div>
    </div>

    <div id="unitdata"></div>
</div>
<%--<div>

</div>--%>
