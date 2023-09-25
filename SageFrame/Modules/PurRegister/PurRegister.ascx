<%@ Control Language="C#" AutoEventWireup="true" CodeFile="PurRegister.ascx.cs" Inherits="Modules_PurRegister_PurRegister" %>
<script type="text/javascript">
    $(document).ready(function () {
        $(".ReportDate").datepicker({

        });
        $("#btnviewreport").on('click', function () { $("#tblData").show(); $('#Exports').show(); });
    });
</script>
<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Purchase Register</a></li>

    </ul>
    <div id="tabs-1">
        <table style="display: block;">
            <tr>
                <td>Start Date :
                </td>
                <td>
                    <input type="text" id="txtStartDate" class="sfInputbox ReportDate" style="width: 100px" />
                </td>
                <td>End Date :
                </td>
                <td>
                    <input type="text" id="txtEndDate" class="sfInputbox ReportDate" style="width: 100px" />
                </td>
                <td>
                    <input type="button" id="btnviewreport" value="View" class="sfBtn" />
                </td>
                <td> <div id="Exports" style="display:none;">
        <a href="#" class="sfBtn" onclick="$('#displayreports').tableExport({type:'excel',escape:'false'});">Excel</a>
        <a href="#" class="sfBtn" onclick="$('#displayreports').tableExport({type:'xml',escape:'false'});">XML</a>
        <a href="#" class="sfBtn" onclick="$('#displayreports').tableExport({type:'txt',escape:'false'});">TEXT</a>
    </div></td>
            </tr>
        </table>
    </div>
    
   
    <table id="tblData" class="pur-static-tbl" style="display: none;">
        <thead>
            <tr>
                <th colspan="4">Invoice</th>
                <th></th>
                <th></th>
                <th colspan="2">Taxable Purchase</th>
                <th colspan="2">Taxable Import</th>
                <th colspan="2">Taxable Capital Purchase/ Import</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Date</td>
                <td>Invoice No.</td>
                <td>Supplier Name</td>
                <td>Supplier PAN</td>
                <td>Total Purchase</td>
                <td>Tax Exempted Purchase</td>
                <td>Value</td>
                <td>Tax</td>
                <td>Value</td>
                <td>Tax</td>
                <td>Value</td>
                <td>Tax</td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4">Total</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>

            </tr>
        </tfoot>
    </table>
