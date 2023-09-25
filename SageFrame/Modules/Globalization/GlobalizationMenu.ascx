<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GlobalizationMenu.ascx.cs" Inherits="Modules_Globalization_GlobalizationMenu" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
        });
    });
</script>
<div class="RO_wrapper">
<table class="table" style="display:block;">
            <tr>
                <td>Language :
                </td>
                <td>
            <select id="selLanguage" class="sfInputbox" style="width:200px;" >
            </select>
                   <td>         
            </table>

    <div id="divForGlobalMenu" class="restrowrapper"></div>

     <button type="button" class="sfBtn restro-btn" id="btnSave">Save</button>
</div>