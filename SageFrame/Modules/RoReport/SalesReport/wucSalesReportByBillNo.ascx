<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucSalesReportByBillNo.ascx.cs" Inherits="Modules_RoReport_SalesReport_wucSalesReportByBillNo" %>

<script type="text/javascript">
    $(document).ready(function () {
        $(this).companyProfEDIT({});
    });
</script>
<div id="tabs">
    <ul>
        <li><a href="#div1">Sales Report</a></li>
    </ul>
    <div id="div1">
        <table class="salesTable" style="display: block;">
            <tr>
                <td>Start Bill Number:
                </td>
                <td>
                    RO<label class="fiscal"></label>
                    <asp:Label ID="lblFiscal" ClientIDMode="Static" runat="server" />-
                    <input type="text" id="startBillNo"  style="width: 40px" />
                </td>
                <td>End Bill Number:
                </td>
                <td>
                    RO<asp:Label ID="lblFiscal2" ClientIDMode="Static" runat="server" />-
                    <input type="text" id="EndBillNo"  style="width: 40px" />
                </td>
                <td>
                    Bill Status
                </td>
                <td>
                     <select id="sltStatus">
                         <option value="-1">All</option>
                         <option value="0">Active</option>
                         <option value="1">Canceled</option>
                     </select>
                </td>
                <td>
                    <input type="button" class="sfBtn" id="btnSaleByBillNo" value="View" />
                </td>
            </tr>
        </table>
    </div>
    <div class="sfGridwrapper" id="DailyReport"></div>
    <div class="CancelWithReason" style="display: none;">
        <table style="display:block;margin-bottom:0;">
            <tr>
                <td>
                    <label>Reason:</label>
                </td>
                <td>
                    <textarea id="txtCancelWithReason" placeholder="Type the Reason.." class="sfInputbox"></textarea></td>
            </tr>
        </table>
        <%--<input type="text" id="txtCancelWithReason" placeholder="Type the Reason.." />--%>
    </div>
</div>
