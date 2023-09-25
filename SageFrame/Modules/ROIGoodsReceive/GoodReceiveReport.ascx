<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GoodReceiveReport.ascx.cs" Inherits="Modules_ROIGoodsReceive_GoodReceiveReport" %>
<script type="text/javascript">
    $(function () {
        $(this).companyProfEDIT({
            Username: '<%=Username%>'
        });
    });
</script>


    <ul>
        <li><a href="#tabs-1">Good Receive Report</a></li>

    </ul>
   <h1> Good Receive Report </h1>

    <div id="tabs-1">
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
                    <input type="text" class="sfInputbox picker" id="txtEndDate" style="width:100px"/>
                </td>
                <td>
                    <input type="button" id="btnView" value="View" class="sfBtn"/>
                </td>
            </tr>
        </table>

    </div>
    <div id="GoodReceiveReportDisplay"></div>
    </div>