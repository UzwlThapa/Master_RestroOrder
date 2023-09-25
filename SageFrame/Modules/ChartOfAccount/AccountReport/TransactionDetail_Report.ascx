<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TransactionDetail_Report.ascx.cs" Inherits="Modules_ChartOfAccount_AccountReport_TransactionDetail_Report" %>
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
                    <label>
                        Fin. A/c Name :
                    </label>
                </td>
                <td>
                    <select class="ddGL_NameClass sfInputbox" style="width: 100px" id="ddGL_Name" name="Date" />

                </td>
                 <td>
                    <label>
                        Vou No. :
                    </label>
                </td>
                <td>
                    <input type="text" class="VoucherNo sfInputbox" style="width: 100px" id="txtVoucherNo"  />

                </td>
                <%--<td>
                    <label>Show Zero : </label>
                    </td>
                    <td>
                        <select id="sltIsZero">
                            <option value="Yes">Yes</option>
                            <option value="No">No</option>
                        </select></td>--%>
                <td>
                    <input type="button" value="View" id="btnView" class="sfBtn restro-btn">
                    <input type='button' value="Excel" id="button" class="sfBtn restro-btn"/>
                    <%--<input type='button' value="Pdf" id="buttonPdf"/>--%>
                </td>
            </tr>
        </table>
        <div id="divForTransactionDetail" class="restrowrapper"></div>
    </div>
