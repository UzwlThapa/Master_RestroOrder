<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LostAndFound.ascx.cs" Inherits="Modules_HouseKeeping_LostAndFound" %>

<script type="text/javascript">
    $(function () {
        $(this).MainHouseKeeping({

        });


        $(document).ready(function () {
            jQuery("#txtDate").datepicker({
                dateFormat: 'yy-mm-dd',
                changeMonth: true,
                changeYear: true,
                maxDate: '0',
                onClose: function (selectedDate) {
                    jQuery("#txtDate").datepicker("option", "minDate", selectedDate);
                }
            });
              resizeIframe();

        });
    });
</script>

<div class="RO_wrapper">
<div class="restro-title clearfix">
        <input type="button" value="Add" class="sfLocale icon-addnew sfBtn" id="btnAdd">
        </div>

        <table id="container" style="display:">
            <tr>
                <td colspan="4">
                    <input type="hidden" id="txtID" value="0"/>
                </td>
            </tr>
            <tr>
                <td>Room</td>
                <td>
                    <select id="dropDownRooms" class="sfInputbox DDRoom" style="width: 200px;"></select>

                </td>
                <td>Room Type</td>
                <td>
                    <%--<input type="text" id="ddRoomName" class="sfInputbox" />--%>
                    <select id="ddRoomName" class="sfInputbox" style="width: 200px;"></select>
                </td>
            </tr>
            <tr>
                <td>Date</td>
                <td>
                    <input type="text" id="txtDate" class="sfInputbox" />
                </td>
                <td>Guest Name</td>
                <td>
                    <input type="text" id="txtGName" class="sfInputbox" />
                </td>
            </tr>
            <tr>
                <td>Type </td>
                <td>
                    <input type="radio" name="lostAndFound" value="Missing">
                    Missing
                <input type="radio" name="lostAndFound" value="Found">
                    Found<br>
                </td>
                <td>Item</td>
                <td>
                    <input type="text" id="txtItem" class="sfInputbox" />
                </td>
            </tr>

            <tr>
                <td></td>
                <td>
                    <input class="sfLocale icon-save sfBtn" type="button" id="btnSave" value="Save" />
                    <input class="sfLocale icon-close sfBtn" type="button" id="btnCancel" value="Cancel" />
                </td>
            </tr>
        </table>
<div id="BindValues">
</div>
</div>
