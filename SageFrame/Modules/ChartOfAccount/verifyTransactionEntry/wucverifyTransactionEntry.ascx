<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucVerifyTransactionEntry.ascx.cs" Inherits="Modules_Admin_ChartOfAccount_verifyTransactionEntry_wucVerifyTransactionEntry" %>

<style type="text/css">
    .sfFormwrapper input.hasDatepicker {
        margin-left: 0px;
    }
</style>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
        $("#tabss").tabs();
        $('#tabss').css('display', 'block');
        $("#btnAdd").click(function () {
            $(".MainForm").show();
            $("#divForFinancialAc").hide();
            $("#btnAdd").hide();
            // $(".AccountForm").show();
            $(".bank").hide();
            $(".tabsForlist").hide();

        });

        $("#txtJEDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
        }).datepicker('setDate', new Date());
        $(".txtChequeDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            minDate: '0',
        }).datepicker('setDate', new Date());

        $(".DatePick").datepicker({
            dateFormat: "yy-mm-dd"
        }).datepicker("setDate", "0");

       // $("#txtStartDate,#txtEndDate").datepicker().datepicker("setDate", new Date());

    });
</script>

<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn restro-btn" value="Add" />
    </div>
    <div class="MainForm" style="display: none;">
        <div id="divVerifiedVoucher">
            <table style="display: block;">
                <tr>
                    <td>Select Voucher Type : </td>
                    <td>
                        <select id="selVoucharType" class="sfInputbox" style="width: 200px;"></select><label id="lblVoucherType"></label></td>
                    <td>
                        <input id="hdnVoucherNo" type="hidden" runat="server" clientidmode="Static"></td>
                </tr>
            </table>

            <%--<h2><span class="Title">Journal Entry</span></h2>--%>
            <div class="sfFormwrapper AccountForm restrowrapper" style="display: none;">
                <h4><span class="Title"></span></h4>
                <table style="display: block;">
                    <tr>
                        <td>Description<span style="color: red;">*</span> : </td>
                        <td>
                            <label id="lblVoucherTypeDescription" style="width: 200px;"></label>
                            <textarea class="sfInputbox" id="txtJEDescription" name="JEDescription" style="width: 500px; height: 100px;"></textarea>
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <table class="tblForFinancialAc sfGridwrapper">
                                <thead>
                                    <tr>
                                        <th>Financial Account</th>
                                        <th>Particulars</th>
                                        <th>Debit (Rs.)</th>
                                        <th>Credit (Rs.)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <input type="text" class="sfInputbox selFinancialAc" name="FinancialAc" />
                                            <%--                                            <select class="selFinancialAc sfInputbox" name="FinancialAc">
                                            </select>--%>
                                            <input type="hidden" class="sfInputbox hdnFinancialAcID" name="AcDescription" style="width: 460px;" />
                                        </td>
                                        <td>
                                            <input type="text" class="sfInputbox txtAcDescription" name="AcDescription" style="width: 460px;" /></td>
                                        <td>
                                            <input type="text" class="sfInputbox txtDebit" name="Debit" style="width: 105px;" /></td>
                                        <td>
                                            <input type="text" class="sfInputbox txtCredit" name="Credit" style="width: 105px;" /></td>
                                    </tr>
                                    <tr class="bank" style="display: none;">
                                        <td>
                                            <label>ChequeNo</label>
                                            <%-- </td>
                                    <td>--%>
                                            <input type="text" class="sfInputbox txtChequeNo" name="ChequeNo" />
                                        </td>
                                        <td>
                                            <label>ChequeDate</label>
                                            <%--</td>
                                    <td>--%>
                                            <input type="text" class="sfInputbox txtChequeDate" name="ChequeDate" readonly="readonly" />
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <label class="sfLocale icon-addnew sfBtn restro-btn addNewRow"></label>
                            Add a line
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <div class="printData" style="display: block;">
                                <table>
                                    <tr>
                                        <td>Date : </td>
                                        <td>
                                            <label id="lblVoucherTypeDate"></label>
                                            <input type="text" class="sfInputbox" id="txtJEDate" name="JEDate" readonly="readonly" />
                                            <input type="hidden" id="hdnPostedBy"><input type="hidden" id="hdnPostedOn">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table class="tblForTempFinancialAc sfGridwrapper" style="display: none;">
                                                <thead>
                                                    <tr>
                                                        <th>FinancialAc</th>
                                                        <th>FinancialAcID</th>
                                                        <th>Particulars</th>
                                                        <th>Debit</th>
                                                        <th>Credit</th>
                                                        <th>Cheque No.</th>
                                                        <th>Cheque Date</th>
                                                        <th colspan="2">Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <th></th>
                                                        <th colspan="2">Total:</th>
                                                        <th>
                                                            <label class="" id="lblDebitTotal">
                                                            </label>
                                                        </th>
                                                        <th>
                                                            <label class="" id="lblCreditTotal">
                                                            </label>
                                                        </th>
                                                        <th colspan="3"></th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </td>

                                    </tr>

                                    <%-- <tr>
                        <td>
                            <label class="icon-save sfBtn restro-btn" id="btnSave">
                                Verify</label>
                            <label class="icon-close sfBtn restro-btn" id="btnCancel">
                                Cancel</label>
                            <label class="icon-print sfBtn restro-btn" id="btnPrintVerifiedVoucher">
                                Print</label>
                        </td>
                    </tr>--%>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div>

            <label class="icon-save sfBtn restro-btn" id="btnSave">
                Verify</label>
            <label class="icon-close sfBtn restro-btn" id="btnCancel">
                Cancel</label>
            <label class="icon-print sfBtn restro-btn" id="btnPrintVerifiedVoucher">
                Print Page</label>

        </div>
    </div>
    <div id="tabss" class="tabsForlist" style="display: none;">
        <ul>
            <li><a href="#tabs-2">Temporary Transaction</a></li>
            <li><a href="#tabs-3">Verified Transaction</a></li>
        </ul>

        <div id="tabs-2" style="padding: 1px">
            <table class="" style="display: block;">
                <tbody>
                    <tr>

                        <td>Start Date:
                        </td>
                        <td>
                            <input type="date" value="" id="txtStartDate" class="sfInputbox  DatePick" style="width: 100px;">
                        </td>
                        <td>End Date:
                        </td>
                        <td>
                            <input type="date" value="" id="txtEndDate" class="sfInputbox DatePick" style="width: 100px;">
                        </td>
                        <td>
                            <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnView">Search</button>
                        </td>
                    </tr>

                </tbody>
            </table>
            <input id="btnverify" type="button" value="Verify" class="sfBtn restro-btn" style="float: right" />
            <div id="divForListingTempTransaction" class="restrowrapper"></div>
        </div>
        <div id="tabs-3" style="padding: 1px">
            <table class="" style="display: block;">
                <tbody>
                    <tr>

                        <td>Start Date:
                        </td>
                        <td>
                            <input type="date" value="" id="txtStartDate_Verified" class="sfInputbox DatePick" style="width: 100px;">
                        </td>
                        <td>End Date:
                        </td>
                        <td>
                            <input type="date" value="" id="txtEndDate_Verified" class="sfInputbox DatePick" style="width: 100px;">
                        </td>
                        <td>
                            <button type="button" class="sfBtn restro-btn fa fa-eye" id="btnViewVerified">Search</button>
                        </td>
                    </tr>

                </tbody>
            </table>
            <div id="divForListingVerifiedTransaction" class="restrowrapper"></div>
        </div>
    </div>
    <div id="divFinancialView" class="popup-tbl" style="display: none;"></div>
</div>
