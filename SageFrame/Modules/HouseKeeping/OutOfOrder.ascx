<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OutOfOrder.ascx.cs" Inherits="Modules_HouseKeeping_HouseStatusScript" %>
<script type="text/javascript">
    $(function () {
        $(this).MainHouseKeeping({

        });

        $("#txtFromDate").datepicker({
            numberOfMonths: 1,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selected) {
                var dt = new Date(selected);
                dt.setDate(dt.getDate() + 1);
                $("#txtThroughDate").datepicker("option", "minDate", dt, 'setDate', 'today');
            }
        });

        $("#txtThroughDate").datepicker({
            numberOfMonths: 1,
            changeMonth: true,
            changeYear: true,
            onSelect: function (selected) {
                var dt = new Date(selected);
                dt.setDate(dt.getDate() - 1);
                $("#txtFromDate").datepicker("option", "maxDate", dt);
            }
        });
         resizeIframe();
    });
</script>

<div class="RO_wrapper">
<div class="restro-title clearfix">
        <input class="sfLocale icon-addnew sfBtn" type="button" id="btnAdd" value="Add" /></div>
        <%--<table id="reportView" style="display:block;">
        <tr>
            <td id="statusData">Status :
                  <select id="dropDownStatus" class="ddStatus "></select>
            </td>
            <td id="rolesData">Assign Room To :
                   <select id="dropDownAssign" class="ddAssign  "></select>
            </td>


            <td>
                <input type="button" id="btnView" value="View " class="sfBtn restro-btn"/>
                <input type="button" id="btnPrint" value="Print " class="sfBtn restro-btn" style='display:none;'/>
            </td>
        </tr>

    </table>--%>
    <div id="container">
        <table style="display:block;">
            <tr>
                <td colspan="4">
                    <input type="hidden" id="txtID" value="0" />
                </td>
            </tr>

            <tr>
                <td>Room Name :</td>
                <td>
                    <select id="dropDownRoom" class="sfInputbox ddRoomName" style="width: 200px;"></select>
                </td>
                <td>Status : </td>
                <td>
                    <input type="text" id="txtStatus" class="sfInputbox" />
                </td>
            </tr>
            <tr>
                <td>From Date :</td>
                <td>
                    <input type="text" id="txtFromDate" class="sfInputbox txtDate" />
                </td>

                <td>Through Date :</td>
                <td>
                    <input type="text" id="txtThroughDate" class="sfInputbox txtDate" />
            </tr>
            <tr>
                <td>Return As : </td>
                <td>
                    <input type="text" id="txtReturnAs" class="sfInputbox" />
                </td>
            </tr>
            <tr>

                <td>Reason :</td>
                <td>
                    <input type="text" id="txtReason" class="sfInputbox" />
                </td>

                <td>Remarks :</td>
                <td>
                    <input type="textarea" id="txtRemarks" class="sfInputbox"  style="width:300px;height:80px;" />
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
                    <input class="sfLocale icon-save sfBtn" type="button" id="btnSave" value="Save" />
                    <input class="sfLocale icon-close sfBtn" type="button" id="btnCancel" value="Cancel" />
                    <input class="sfLocale icon-Add sfBtn" type="button" id="btnEdit" value="Edit" /></td>
            </tr>
        </table>
    </div>
    <%--<div class="restrowrapper">--%>

<div id="bindOutOfOrder"></div>
</div>

