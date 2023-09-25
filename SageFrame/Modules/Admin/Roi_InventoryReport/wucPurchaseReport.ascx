<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucPurchaseReport.ascx.cs" Inherits="Modules_Admin_Roi_InventoryReport_wucPurchaseReport" %>
<script type="text/javascript">
    $(document).ready(function () {
        jQuery("#txtStartDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            //onClose: function (selectedDate) {
            //    jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            //}
        });
         $("#txtStartDate").datepicker().datepicker("setDate", new Date());
        jQuery("#txtEndDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            //onClose: function (selectedDate) {
            //    jQuery("#txtEndDate").datepicker("option", "minDate", selectedDate);
            //}
        });
        $("#txtEndDate").datepicker().datepicker("setDate", new Date());
        //$("#txtStartDate").datepicker({
        //    changeMonth: true,
        //    changeYear: true,
        //    maxDate: 0
        //});
        $("#txtToDate").datepicker({
            changeMonth: true,
            changeYear: true,
        });
        $(this).companyProfEDIT({});
        $("input[type=radio][name=Customer]").change(function () {
            $(".main").show();
            if (this.value == '0') {
                $(".purc").show();
                $(".date").hide();
            } else {
                $(".purc").hide();
                $(".date").show();
            }
        });
    });
</script>
<div class="RO_wrapper">
    <div id="div1">
        <table class="salesTable date" style="display: block;">
            <tr>
                <td>Purchase No.:
                </td>
                <td>
                    <input type="text" class="sfInputbox" placeholder="Type" id="txtPurchaseNo" name="startdate" style="width: 120px;">
                </td>
                <td>Start Date:
                </td>
                <td>
                    <input type="text" value="" id="txtStartDate" class="sfInputbox" style="width: 100px;">
                </td>
                <td>End Date:
                </td>
                <td>
                    <input type="text" value="" id="txtEndDate" class="sfInputbox" style="width: 100px;">
                </td>

                <td>Vendor Name:
                </td>
                <td>


                    <asp:DropDownList ClientIDMode="Static" ID="ddlVendorList" name="ddlVendorList" CssClass="sfInputbox" runat="server"></asp:DropDownList>
                </td>
                <td>
                    <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                </td>
            </tr>

        </table>
        <div class="report-view" style="display: none;">

            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right: 2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport" style="margin-right: 2px;">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right: 2px;">PDF</button>
            </div>
        </div>
        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
        <asp:HiddenField ID="HiddenField1" ClientIDMode="Static" runat="server" />
        <div id="PurchaseViewReport" style="display: none;">
        </div>
    </div>
</div>



