<%@ Control Language="C#" AutoEventWireup="true" CodeFile="WebUserControlForVaultReport.ascx.cs" Inherits="Modules_Roi_VaultReport_WebUserControlForVaultReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtYear").datepicker({
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            dateFormat: 'yy-mm',
            showMonthAfterYear: true,
            onChangeMonthYear: function (year, month, widget) {
                setTimeout(function () {
                    $('.ui-datepicker-calendar').hide();
                });
            },
            onClose: function (dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year, month, 1));
            },
        }).click(function () {
            $('.ui-datepicker-calendar').hide();
        });
        $("#txtYears").datepicker({
            changeYear: true,
            changeMonth: false,
            showMonthAfterYear: false,
            stepMonths: '0',
            showButtonPanel: true,
            dateFormat: 'yy',
            onChangeMonthYear: function (year, month, widget) {
                setTimeout(function () {
                    $('.ui-datepicker-calendar').hide();
                });
            },
            onClose: function (dateText, inst) {
                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year));
            },
        }).click(function () {
            $('.ui-datepicker-calendar').hide();
        });
        $("#btnPdfReport").click(function () {
            var a = $("#txtYear").val();
        });
        $("#txtSelectDate").datepicker({
            changeMonth: true,
            changeYear: true,
        }).click(function () {
            $('.ui-datepicker-calendar').show();
        });

        $("#selOption").click(function () {
            var a = $("#selOption").val();
            $(".show").show();
            if (a == 1 || a==2) {
                $("#txtSelectDate").show();
                $("#txtYear").hide();
                $("#txtYears").hide();
            }
            if (a == 3) {
                $("#txtSelectDate").hide();
                $("#txtYear").show();
                $("#txtYears").hide();
            }
            if (a == 4) {
                $("#txtSelectDate").hide();
                $("#txtYear").hide();
                $("#txtYears").show();
            }
        });
    });
</script>

<div style="font-family: Arial;">
    <h2>Vault Report</h2>
    <table>
        <tr>
            <td>View Report by:</td>
            <td>
                <select id="selOption" runat="server" clientidmode="static">
                    <option>-Select- </option>
                    <option value="1">Date</option>
                    <option value="2">Week</option>
                    <option value="3">Month</option>
                    <option value="4">Year</option>
                </select>
            </td>
        </tr>
        <tr>
            <td class="show" style="display:none;">Select Date:</td>
            <td>
                <input type="text" id="txtSelectDate" placeholder="Pick Date" readonly="readonly" runat="server" clientidmode="static" style="display:none;"/>
                <input type="text" id="txtYear" placeholder="Pick Year and Month" readonly="readonly" runat="server" clientidmode="static" style="display:none;"/>
                <input type="text" id="txtYears" placeholder="Pick Year" readonly="readonly" runat="server" clientidmode="static" style="display:none;"/>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Button Text="Pdf Report" ID="btnPdfReport" runat="server" OnClick="btnPdfReport_Click" ClientIDMode="Static" />
                <%--<input type="button" id="btnPdfReport" value="Pdf Report" runat="server"/>--%></td>
        </tr>
    </table>
</div>
<div style="display: none;">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana" Font-Size="8pt" WaitMessageFont-Names="Verdana" WaitMessageFont-Size="14pt" Width="100%" Height="100%" AsyncRendering="False" SizeToReportContent="True">
        <LocalReport ReportPath="Modules\Roi_VaultReport\ReportForVault.rdlc">
        </LocalReport>
    </rsweb:ReportViewer>
</div>
<iframe runat="server" id="vaultReportPdf" height="800" width="100%"></iframe>
