<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OutOfOrderReport.ascx.cs" Inherits="Modules_HouseKeeping_OutOfOrderReport" %>
<script>
    $(document).ready(function () {

        $(this).MainHouseKeeping({
            <%-- Username: '<%=Username%>'--%>

        });
        //jQuery("#txtStartDate").datepicker({
        //    dateFormat: 'yy-mm-dd',
        //    changeMonth: true,
        //    changeYear: true,
        //    maxDate: '0',
        //    onClose: function (selectedDate) {
        //        jQuery("#txtDate").datepicker("option", "minDate", selectedDate);
        //    }
        //});
        //jQuery("#txtEndDate").datepicker({
        //    dateFormat: 'yy-mm-dd',
        //    changeMonth: true,
        //    changeYear: true,
        //    maxDate: '0',
        //    onClose: function (selectedDate) {
        //        jQuery("#txtDate").datepicker("option", "minDate", selectedDate);
        //    }
        //});


        $("#txtStartDate").datepicker({
            numberOfMonths: 1,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selected) {
                var dt = new Date(selected);
                dt.setDate(dt.getDate() + 1);
                $("#txtEndDate").datepicker("option", "minDate", dt, 'setDate', 'today');
            }
        });

        //$("#txtEndDate").datepicker({
        //    numberOfMonths: 1,
        //    changeMonth: true,
        //    changeYear: true,
        //    onSelect: function (selected) {
        //        var dt = new Date(selected);
        //        dt.setDate(dt.getDate() - 1);
        //        $("#txtStartDate").datepicker("option", "maxDate", dt);
        //    }
        //});
        var tabs = $("#tabs").tabs();
         resizeIframe();
    });
</script>


<div class="RO_wrapper">
    <div id="container">
        <table style="display:block;">
            <tr>
                <td colspan="4">
                    <input type="hidden" id="txtID" value="0" />
                </td>
            </tr>
            <tr>
                <td>Room type:</td>
                <td>
                    <select id="ddRoomName" class="sfInputbox" style="width: 200px;" ></select>
                </td>
                <td>Room :</td>
                <td>
                    <select id="dropDownRooms" class="sfInputbox" style="width: 200px;"></select>
                </td>
            </tr>
            <tr>

                <%--<td>Room Class:</td>
                <td>
                    <select id="ddRoomClass" class="sfInputbox" style="width: 200px;"></select>
                </td>--%>

                <td>For Date :</td>
                <td>
                    <input type="text" id="txtStartDate" class="sfInputbox required" name="StartDate" style="width: 100px;" />
                </td>
            </tr>
            <tr>
                <td>Out Of Order :</td>
                <td>
                    <input type="checkbox" id="txtchkOrder" name="OutOfOrder" value="OutOfOrder" />
                </td>
                <td>Out Of Service :</td>
                <td>
                    <input type="checkbox" id="txtchkService" name="OutOfService" value="OutOfService" />
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" id="btnView" value="View" class="sfBtn restro-btn" />
                </td>
                <td>
                    <input type="button" id="btnPrint" value="Print" class="sfBtn restro-btn" />
                </td>
            </tr>
        </table>
    </div>
<div id="bindOutOfOrder"></div>
<div id="AssignToDialog" class="headingbg">
</div>
</div>
