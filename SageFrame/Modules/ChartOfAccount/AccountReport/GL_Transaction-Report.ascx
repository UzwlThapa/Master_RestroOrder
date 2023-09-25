<%@ Control Language="C#" AutoEventWireup="true" CodeFile="GL_Transaction-Report.ascx.cs" Inherits="Modules_ChartOfAccount_AccountReport_GL_Transaction_Report" %>


<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();

        var dateFormat = "yy-mm-dd",
          from = $("#txtFrom")
            .datepicker({
                dateFormat: "yy-mm-dd",
                changeMonth: true,
                changeYear: true,
            }).datepicker("setDate", "0")
            .on("change", function () {
                to.datepicker("option", "minDate", getDate(this));
            }),
          to = $("#txtTo").datepicker({
              dateFormat: "yy-mm-dd",
              changeMonth: true,
              changeYear: true,
          }).datepicker("setDate", "0")
          .on("change", function () {
              from.datepicker("option", "maxDate", getDate(this));
          });

        function getDate(element) {
            var date;
            try {
                date = $.datepicker.parseDate(dateFormat, element.value);
            } catch (error) {
                date = null;
            }
            return date;
        }
    });
</script>
<style type="text/css">
    .isGrouptrue {
        font-weight: bold;
    }
</style>
<div class="RO_wrapper">
<div>
        <table style="display: block;">
            <tr>
                <td>
                    <label>
                        From :
                    </label>
                </td>
                <td>
                    <input type="text" class="sfInputbox DatePick" style="width: 100px" id="txtFrom" name="Date" />

                </td>
                <td>
                    <label>
                        To :
                    </label>
                </td>
                <td>
                    <input type="text" class="sfInputbox DatePick" style="width: 100px" id="txtTo" name="Date" />

                </td>
                <td>
                    <label>Show Zero : </label>
                </td>
                <td>
                    <select id="sltIsZero" class="sfInputbox" style="width:100px;">
                        <option value="Yes">Yes</option>
                        <option value="No">No</option>
                    </select></td>
                <td>
                    <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">View</button>
                    <%--<input type='button' value="Excel" id="button" class="sfBtn restro-btn"/>--%>
                    <%--<input type='button' value="Pdf" id="buttonPdf"/>--%>
                </td>
            </tr>
        </table>
            <div class="report-view" style="display:none;">
          <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right:2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport"  style="margin-right:2px;" >Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right:2px;" >PDF</button>
                    </div>
             </div>
     <div id="divForBalanceSheet" class="restrowrapper"></div>
        </div>
    </div>

