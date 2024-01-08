<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Cbms_SalesBook.ascx.cs" Inherits="Modules_CBMS_Dashboard_Cbms_SalesBook" %>
<%--<script src="https://unpkg.com/jspdf@latest/dist/jspdf.min.js"></script>--%>

<script type="text/javascript">

    $(function () {

        $(this).CReports({
        });
    });

    // resizeIframe();
</script>
<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <h3>Sales Book</h3>
    </div>
    <div>
        <table style="display: block;">
            <tr>
                <td>
                    <label>From Date: </label>
                </td>
                <td>
                    <input type="text" id="txtMnthYear" class="sfInputbox" autocomplete="off" style="width: 100px;" /></td>
                <td>
                    <input type="hidden" id="txtEngMnthYear" /></td>
                <td>
                    <label>To Date: </label>
                </td>
                <td>
                    <input type="text" id="txtToDate" class="sfInputbox" autocomplete="off" style="width: 100px;" /></td>
                <td>
                    <input type="hidden" id="txtEngToDate" /></td>
                <td>
                    <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewSales">View Sales</button>
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

        <div id="salesBookDiv" style="display: none; background-color: white;">

            <div class="Report_header">
                <h4 style="text-align: center; margin: 0;">
                    <label id="lblCompanyName"></label>
                </h4>

                <p style="text-align: center; margin: 0;">
                    <label id="lblCompanyAddress"></label>
                    , PAN :
                    <label id="lblCompanyPAN"></label>
                </p>
                <p style="text-align: center; margin: 0;">Sales Book</p>
                <p style="text-align: center; margin: 0;">From :
                    <label id="lblMonth"></label>
                    &nbsp; &nbsp;   To :
                    <label id="lblYear"></label>
                </p>
            </div>

            <table id="salesBookTbl" class="reportsprint" style="border-collapse: collapse; margin: 0;">
                <thead>
                    <tr>
                        <th colspan="7" class="invoicee" style='text-align: center; border: 1px solid #575757; padding: 2px;'>Invoice</th>
                        <th class='salesbook-brd' rowspan="2" style='text-align: center; border: 1px solid #575757; padding: 2px;'>Total Sales</th>
                        <th class='salesbook-brd' rowspan="2" style='text-align: center; border: 1px solid #575757; padding: 2px;'>Local Tax</th>
                        <th colspan="2" style='text-align: center; border: 1px solid #575757; padding: 2px;'>Taxable Sales</th>
                        <th colspan="4" class='salesbook-brd' style='text-align: center; border: 1px solid #575757; padding: 2px;'>Export Sales</th>
                    </tr>
                    <tr>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Date</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Bill No</th>
                        <th style='text-align: left; border: 1px solid #575757; padding: 2px;'>Buyer's Name</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Buyer's PAN Number</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Service Type</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Quantity</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Unit</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Amount</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Tax</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Rate</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Country</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Export Number</th>
                        <th style='text-align: center; border: 1px solid #575757; padding: 2px;'>Date</th>
                    </tr>
                </thead>
                <tbody></tbody>
                <tfoot></tfoot>
            </table>
        </div>
    </div>
</div>
<%--<div id="editor"></div>--%>