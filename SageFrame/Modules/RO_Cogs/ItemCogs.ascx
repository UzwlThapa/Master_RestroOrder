<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ItemCogs.ascx.cs" Inherits="Modules_RO_Cogs_ItemCogs" %>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
    });
</script>

<div class="RO_wrapper">
            <table style="display:block;">
                <tr>
                    <td>Cost Center :  </td>
                    <td>
                        <select id="selCostCenter" class='sfInputbox' style='width:100px;'>
                            <option value="0" selected>--ALL--</option>
                            <option value="1">KOT</option>
                            <option value="2">BAR</option>
                            <option value="95">BAKERY</option>
                         </select>
                    </td>
                    <td>Item :  </td>
                    <td>
                        <select id="selItem" class='sfInputbox' style='width:150px;'>
                            <option value="0" selected>--ALL--</option>
                         </select>
                    </td>
                    <td>COGS Range :  </td>
                    <td>From :  </td>
                    <td>
                        <input style="width:100px;" id="txtMinCogs" class='sfInputbox' type="text" value="0" onkeypress="return validateFloatKeyPress(this,event)" />
                    </td>
                    <td>To :  </td>
                    <td>
                        <input style="width:100px;"  id="txtMaxCogs" class='sfInputbox' type="text" value="0" onkeypress="return validateFloatKeyPress(this,event)" />
                    </td>

                  <%--  <td>Select Date :  </td>
                    <td>  <input type="text" id="targetdate" class="picker sfInputbox" /></td>--%>
                    <td> <label id="btnViewItemCogs" class="sfBtn restro-btn">View</label></td>
                </tr>
            </table>
        <div id="divItemCogs" class="" style="background:#FFF;padding:15px;"></div>
</div>
