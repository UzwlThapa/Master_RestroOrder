<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemSalesReport.ascx.cs" Inherits="Modules_RoItemSalesReport_ItemSalesReport" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            ModulePath: '<%=modulePath %>',

        });
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
                    <input type="text" class="sfInputbox picker" id="txtStartDate" style="width:100px"/>
                </td>
                <td>
                    End Date :
                </td>
                <td>
                    <input type="text" class="sfInputbox picker" id="endDate" style="width:100px"/>
                </td>
                <td>
                    <input type="button" id="btnView" value="View" class="sfBtn restro-btn"/>
                </td>
            </tr>
        </table>

    <div id="reportDisplay"></div>
    </div>