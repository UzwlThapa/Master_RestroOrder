<%@ Control Language="C#" AutoEventWireup="true" CodeFile="MainHouseKeeping.ascx.cs" Inherits="Modules_HouseKeeping_MainHouseKeeping" %>
<script type="text/javascript">
    $(function () {
        $(this).MainHouseKeeping({

        });
         resizeIframe();
    });
</script>
<div class="RO_wrapper">
    <table id="reportView" style="display:block;">
        <tr>
        <td>Status : </td>
            <td id="statusData">
                  <select id="dropDownStatus" class="sfInputbox ddStatus "></select>
            </td>
            <td>Assign Room To : </td>
            <td id="rolesData">
                   <select id="dropDownAssign" class="sfInputbox ddAssign  "></select>
            </td>


            <td>
                <input type="button" id="btnView" value="View " class="sfBtn restro-btn"/>
                <input type="button" id="btnPrint" value="Print " class="sfBtn restro-btn" style='display:none;'/>
            </td>
        </tr>

    </table>
<div id="container">
    <table>
        <tr>
            <td colspan="4">
                <input type="hidden" id="txtHKID" value="0" />
            </td>
        </tr>

        <tr>
            <td>Status :</td>
            <td id="statusData1">
                <select id="dropDownStatus1" class="sfInputbox ddStatus" style="width:200px;"></select>

            </td>
            <td>Availability : </td>
            <td><input type="text" id="txtAvailability" class="sfInputbox"/>
            </td>

        </tr>
        <tr>

            <td>Room :</td>
            <td id="roomsData">
                <select id="dropDownRooms" class="sfInputbox" style="width:200px;"></select>
            </td>
            <td>Assign To :</td>
            <td id="rolesData1">
                <select id="dropDownAssign1" class="sfInputbox ddAssign" style="width:200px;"></select>
            </td>

        </tr>
        <tr>
            <td>Remarks : </td>
            <td>
                <textarea id="txtRemarks" class="sfInputbox"></textarea>
            </td>
            
        </tr>

        <tr>
            <td>
                <input class="sfLocale icon-Add sfBtn" type="button" id="btnSave" value="Save" />
                <input class="sfLocale icon-Add sfBtn" type="button" id="btnCancel" value="Cancel" />
                <input class="sfLocale icon-Add sfBtn" type="button" id="btnEdit" value="Edit" /></td>
        </tr>
    </table>
</div>
<div class="restrowrapper">
<div id="bindHouseKeeping"></div>
<div id="AssignToDialog"></div>
</div>
</div>
