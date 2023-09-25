<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TargetSales.ascx.cs" Inherits="Modules_Ro_TargetSales_TargetSales" %>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
    });
</script>

<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Target Sales</a></li>
    </ul>
    <div id="tabs-1">
        <div>
            <table style="display:block;">
                <tr>
                    <td>Select Date :  </td>
                      <td>  <input type="text" id="targetdate" class="picker sfInputbox" /></td>
                       <td> <label id="btnView" class="sfBtn">View</label></td>
                        <td><label id="btnPrint" class="sfBtn" style="display:none;">Export</label>
                    </td>
                </tr>
            </table>
           
        </div>
        <div id="sales"></div>
        <div id="TargetSales" class="TargetSales" style="background:#FFF;padding:15px;"></div>
    </div>
</div>
<div id="divForSalesAnalytics" class="restrowrapper">
    </div>
