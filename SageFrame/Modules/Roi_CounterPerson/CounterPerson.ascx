<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CounterPerson.ascx.cs" Inherits="Modules_Roi_CounterPerson_CounterPerson" %>

<script>
    $(function () {
        $(this).CounterPersons({
           
        });
    });
</script>
<div style="font-family:Arial;">
    <h2><u>Counter Person Details:</u></h2>
    <table>
        <tr>
            <td>
                Name:
            </td>
            <td>
                <input type="text" id="txtCPName" class="sfInputbox" />
            </td>
            </tr>
            <tr>
            <td>
                Code:
            </td>
            <td>
                <input type="text" id="txtCPCode" class="sfInputbox" />
            </td>
        </tr>
         <tr>
            <td>
                <input class="sfLocale icon-Add sfBtn" type="button" id="btnCPAdd" value="Add" />
            </td>
        </tr>
    </table>
</div>
<div id="divForList"></div>