<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucJournalEntry.ascx.cs" Inherits="Modules_Admin_ChartOfAccount_JournalEntry_wucJournalEntry" %>

<style type="text/css">
    .sfFormwrapper input.hasDatepicker {
        margin-left: 0px;
    }
</style>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();


        $("#txtJEDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            maxDate: '0',
            //onClose: function (selectedDate) {
            //    jQuery("#txtJEDate").datepicker("option", "minDate", selectedDate);
            //}
        }).datepicker('setDate', new Date());

        $("#txtPRDate").datepicker({
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
        

        $(".txtPRChequeDate").datepicker({
            dateFormat: 'yy-mm-dd',
            changeMonth: true,
            changeYear: true,
            minDate: '0',
        }).datepicker('setDate', new Date());

        $(".DatePick").datepicker({
            dateFormat: "yy-mm-dd"
        }).datepicker("setDate", "0");
        //$("#txtStartDate,#txtEndDate").datepicker().datepicker("setDate", new Date());

    });
</script>

<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn restro-btn" value="Voucher Entry" />
        <input id="btnAddPaymentReceive" type="button" style="margin-bottom:5px" class="sfLocale icon-addnew sfBtn restro-btn" value="Payment/Receive Voucher" />

    </div>
    <div class="MainForm" style="display: none;">
        <table style="display: block;">
            <tr>
                <td>Select Voucher Type : </td>
                <td>
                    <select id="selVoucharType" class="sfInputbox">
                    </select></td>
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
                        <textarea class="sfInputbox" id="txtJEDescription" name="JEDescription" style="width: 500px; height: 100px;"></textarea></td>
                </tr>
                <tr>
                    <td>Date<span style="color: red;">*</span> : </td>
                    <td>
                        <input type="text" class="sfInputbox" id="txtJEDate" name="JEDate" readonly="readonly" /></td>
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
                                        <input type="hidden" class="sfInputbox hdnFinancialAcID" name="AcDescription" />
                                    </td>
                                    <td>
                                        <input type="text" class="sfInputbox txtAcDescription" name="AcDescription" /></td>
                                    <td>
                                        <input type="text" class="sfInputbox txtDebit" name="Debit" /></td>
                                    <td>
                                        <input type="text" class="sfInputbox txtCredit" name="Credit" /></td>
                                </tr>
                                <tr class="bank" style="display: none;">
                                    <td colspan="2" style="text-align: left">
                                        <label>ChequeNo : </label>

                                        <input type="text" class="sfInputbox txtChequeNo" name="ChequeNo" style="display: inline-block;" />

                                        <label>ChequeDate :</label>

                                        <input type="text" class="sfInputbox txtChequeDate" name="ChequeDate" readonly="readonly" style="display: inline-block;" />
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
                                    <th colspan="4"></th>
                                </tr>
                            </tfoot>
                        </table>
                    </td>
                </tr>
                <%--  <tr>
                        <td colspan="2">
                            <table class="total sfGridwrapper">
                                <tr>
                                    <th></th>
                                    <th colspan="2">Total:</th>
                                    <td>
                                        <label class="" id="lblDebitTotal">
                                        </label>
                                    </td>
                                    <td>
                                        <label class="" id="lblCreditTotal">
                                        </label>
                                    </td>
                                    <td colspan="3"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
                <tr>

                    <td>
                        <label class="icon-save sfBtn restro-btn" id="btnSave">
                            Save</label>
                        <label class="icon-close sfBtn restro-btn" id="btnCancel">
                            Cancel</label>
                    </td>
                </tr>
            </table>
        </div>
    </div>


    <div class="PaymentReceiveForm" style="display: none;">
        <h2>Payment Receive Voucher Entry</h2>
        <div class="sfFormwrapper AccountPEForm restrowrapper">
            <h4><span class="Title"></span></h4>
            <table style="display: block;">
                <tr>
                    <td>Description<span style="color: red;">*</span> : </td>
                    <td>
                        <textarea class="sfInputbox" id="txtPRDescription" name="PRDescription" style="width: 500px; height: 100px;"></textarea></td>
                </tr>
                <tr>
                    <td>Date<span style="color: red;">*</span> : </td>
                    <td>
                        <input type="text" class="sfInputbox" id="txtPRDate" name="PRDate" readonly="readonly" /></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table class="tblForPRFinancialAc sfGridwrapper">
                            <thead>
                                <tr>
                                    <th>Voucher Type</th>
                                    <th>Financial Account</th>
                                    <th>Particulars</th>
                                    <th>Amount</th>
                                     <th>Payment Mode</th>
                                    <th class="PayModeBank" style="display: none;">Bank Detail</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <select class="sfInputbox" id="selVoucherType">
                                            <option value="1">Payment</option>
                                            <option value="2">Receive</option>
                                        </select>    
                                    </td>
                                    <td>
                                        <input type="text" class="sfInputbox selPRFinancialAc" name="FinancialAc" />
                                        <input type="hidden" class="sfInputbox hdnselPRFinancialAc" name="AcDescription" />
                                    </td>
                                    <td>
                                        <input type="text" class="sfInputbox txtPRParticulars" name="AcDescription" />

                                    </td>
                                    <td>
                                        <input type="text" class="sfInputbox txtPRAmount" name="Amount" />

                                    </td>
                                    <td id="divPaymentModes">

                                    </td>
                                    <td class="PayModeBank" style="display: none;">
                                        <input type="text" class="sfInputbox selBankFinancialAc" name="Bank" />
                                        <input type="hidden" class="sfInputbox hdnBankFinancialAcID" name="Bank" />
                                    </td>
                                </tr>
                                <tr class="PayModebankCheque" style="display: none;">
                                    <td colspan="2" style="text-align: left">
                                        <label>ChequeNo : </label>

                                        <input type="text" class="sfInputbox txtPRChequeNo" name="ChequeNo" style="display: inline-block;" />

                                        <label>ChequeDate :</label>

                                        <input type="text" class="sfInputbox txtPRChequeDate" name="ChequeDate" readonly="readonly" style="display: inline-block;" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>

                    <td>
                        <label class="icon-save sfBtn restro-btn" id="btnPRSave">
                            Save</label>
                        <label class="icon-close sfBtn restro-btn" id="btnPRCancel">
                            Cancel</label>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div id="div1">
        <table class="" style="display: block;">
            <tbody>
                <tr>

                    <td>Start Date:
                    </td>
                    <td>
                        <input type="date" value="" id="txtStartDate" class="sfInputbox DatePick" style="width: 100px;">
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
        <div class="report-view" style="display: none;">

            <div class="report-printt">
                <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrint" style="margin-right: 2px;">Print</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-excel-o" id="btnExport" style="margin-right: 2px;">Excel</button>
                <button type="button" class="sfBtn restro-btn fa fa-file-pdf-o" id="btnPdf" style="margin-right: 2px;">PDF</button>
            </div>
        </div>
        <div class="sfGridwrapper" id="DailyReport" style="border: none;">
        </div>
        <input type="hidden" name="lytA$ctl09$HiddenField1" id="HiddenField1" value="4">
        <div id="PurchaseViewReport" style="display: none;">
        </div>

        <div id="divForListingTempTransaction" class="restrowrapper"></div>
    </div>

</div>
