<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Lnf_Report.ascx.cs" Inherits="Modules_HouseKeeping_Lnf_Report" %>

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

        $("#txtEndDate").datepicker({
            numberOfMonths: 1,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selected) {
                var dt = new Date(selected);
                dt.setDate(dt.getDate() - 1);
                $("#txtStartDate").datepicker("option", "maxDate", dt);
            }
        });
        var tabs = $("#tabs").tabs();
          resizeIframe();
    });
</script>


<div class="RO_wrapper">

        <table style="display:block;">
            <tr>
                <td>
                    Start Date :
                </td>
                <td>
                    <input type="text" id="txtStartDate" class="sfInputbox required" name="StartDate" style="width:100px;" />
                </td>
                <td>
                    End Date :
                </td>
                <td>
                    <input type="text" id="txtEndDate" name="EndDate" class="sfInputbox required" style="width:100px;"/>
                </td>
                <td>
                    <input type="button" id="btnView" value="View" class="sfBtn restro-btn"/>
                </td>
                 <td>
                    <input type="button" id="btnPrint" value="Print" class="sfBtn restro-btn" />
                </td>
            </tr>
        </table>

<div id="BindValues"></div>
</div>