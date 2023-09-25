<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Note.ascx.cs" Inherits="Modules_Roi_Note_Note" %>
<script type="text/javascript">
    $(function () {
        $(this).Notes({
        });
    });
</script>
<div style="font-family: Arial;">
    <h2>Note Entry</h2>
    <table>
        <tr>
            <th>Note:
            </th>
            <td>
                <input type="text" id="txtNote" />
            </td>
        </tr>
        <tr>
            <td>
                <Input type="checkbox" id="ckbIsCoin" value="0" name="IsCoin"/>
                <label for="ckbIsCoin">IsCoin?</label>               
            </td>
        </tr>
         <tr>
            <td>
                <input type="button" id="btnSaveNote" value="Save"/>
            </td>
        </tr>
    </table>
    <div id="divForNoteList"></div>
</div>

