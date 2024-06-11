<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Cbms_SalesBook.ascx.cs" Inherits="Modules_CBMS_Dashboard_Cbms_SalesBook" %>
<%--<script src="https://unpkg.com/jspdf@latest/dist/jspdf.min.js"></script>--%>

<script type="text/javascript">

    $(function () {

        $(this).CReports({
        });
    });

    // resizeIframe();
</script>
<style>
    /* Add some padding and better border color for the table */
    #salesBookTbl {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
        font-size: 16px;
        text-align: left;
        background-color: #f0f0f0;
    }

    #salesBookTbl th, #salesBookTbl td {
        padding: 12px 15px;
        border: 1px solid #000;
        color: #000;
    }

    #salesBookTbl thead th {
        background-color: #b0b0b0;
        color: #000;
        text-align: center;
    }

    #salesBookTbl tbody tr {
        border-bottom: 1px solid #000;
    }

    #salesBookTbl tbody tr:last-of-type {
        border-bottom: 2px solid #000;
    }

    .restro-title h3 {
        margin-bottom: 20px;
        color: #000;
    }

</style>
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
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf">PDF</button>
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
                <p style="text-align: center; margin: 0;">बिक्री खाता</p>
                <p style="text-align: center; margin: 0;">From :
                    <label id="lblMonth"></label>
                    &nbsp; &nbsp;   To :
                    <label id="lblYear"></label>
                </p>
            </div>

            <table id="salesBookTbl" class="reportsprint">
                <thead>
                    <tr>
                        <th colspan="8" class="invoice">बीजक</th>
                        <th class='salesbook-brd' rowspan="2">जम्मा बिक्री / निकासी (रु)</th>
                        <th class='salesbook-brd' rowspan="2">स्थानीय कर छुटको बिक्री  मूल्य (रु)</th>
                        <th colspan="2">करयोग्य बिक्री</th>
                        <th colspan="4" class='salesbook-brd'>निकासी</th>
                    </tr>
                    <tr>
                        <th>मिति</th>
                        <th>बीजक नम्बर</th>
                        <th>खरिदकर्ताको नाम</th>
                        <th>खरिदकर्ताको स्थायी लेखा नम्बर</th>
                        <th>वस्तु वा सेवाको नाम</th>
                        <th>वस्तु वा सेवाको परिमाण</th>
                        <th>वस्तु वा सेवाको परिमाण मापन गर्ने इकाइ</th>
                        <th>विवरण</th>
                        <th>मूल्य <br /> (रु)</th>
                        <th>कर <br /> (रु)</th>
                        <th>निकासी गरेको वस्तु वा सेवाको मूल्य (रु)</th>
                        <th>निकासी गरेको देश</th>
                        <th>निकासी प्रज्ञापनपत्र नम्बर</th>
                        <th>निकासी प्रज्ञापनपत्र मिति</th>
                    </tr>
                </thead>
                <tbody></tbody>
                <tfoot></tfoot>
            </table>
        </div>
    </div>
</div>
<%--<div id="editor"></div>--%>
