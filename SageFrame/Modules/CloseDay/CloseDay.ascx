<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CloseDay.ascx.cs" Inherits="Modules_CloseDay_CloseDay" %>
<style type="text/css">
    .closeday-total label, .closeday-sec label {
        font-weight: bold;
    }

    .closeday-total td {
        padding: 2px 5px;
    }

        .closeday-total td strong {
            margin-right: 5px;
        }
</style>
<script>
    $(function () {
        $(this).companyProfEDIT({
            OccupiedTableDayClosedEnable: "<%= OccupiedTableDayClosedEnable %>",
           FixedFloat: "<%= DayCloseFixedFloat %>",   // <-- ADD THIS LINE
           CloseDay: 1
       });
        resizeIframe();
    });

    function IntegerAndDecimal(evt, element) {
        var charCode = (evt.which) ? evt.which : event.keyCode
        if ((charCode != 8) &&
            (charCode != 46 || $(element).val().indexOf('.') != -1) &&      // “.” CHECK DOT, AND ONLY ONE.
            (charCode < 48 || charCode > 57))
            return false;
        return true;
    }

</script>
<div class="RO_wrapper">
    <div style="padding: 10px 10px 0px;">
        <button type="button" class="sfBtn restro-btn fa fa-print" id="btnPrints" style="margin-right: 2px;">Print</button>
    </div>
    <div class="dashboardmain">


        <div id="divCloseDay" class="left-sec">
            <input type="hidden" id="hdfFinancialID" />
            <input type="hidden" id="hdfPeriod" />
            <div class="dialogflex">
                <h5>Opening Balance :
                    <label id="txtOpeningBal"></label>
                </h5>
            
           

                <h5>Total Sales :
                    <label id="txtTotalSales"></label>
                </h5>

            </div>
            <div class="closeday-sec">
                <h5>Sales Collection</h5>

                <table style='background: #e2e2e2; border-radius: 3px 3px 0px 0px; border: none; width: 100%; border-collapse: collapse;' class="item-list-tbl reportsprint">
                    <tr>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Cash</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Cheque</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Card</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Credit</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>eSewa</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>FonePay</th>
                        <th style='width: 16%; text-align: center; border: 1px solid #575757; padding: 2px;'>Surplus Deficit</th>

                    </tr>
                    <tr>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCash"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCheque"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCard"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCredit"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txteSewa"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtFonePay"></label>
                        </td>
                        <td style='width: 16%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtSurplusDeficit"></label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="closeday-sec">
                <h5>Credit Collection</h5>
                <table style='background: #e2e2e2; border-radius: 3px 3px 0px 0px; border: none; width: 100%; border-collapse: collapse;' class="item-list-tbl reportsprint">

                    <tr>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Cash</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Cheque</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Card</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>eSewa</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>FonePay</th>
                        <th colspan="2" style='width: 30%; text-align: center; border: 1px solid #575757; padding: 2px;'></th>

                    </tr>
                    <tr>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCreditCollectedInCash"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCreditCollectedInCheque"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCreditCollectedInCard"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCreditCollectedIneSewa"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtCreditCollectedInFonePay"></label>
                        </td>
                        <td colspan="2" style='width: 30%; text-align: center; border: 1px solid #575757; padding: 2px;'></td>
                    </tr>
                </table>
            </div>
            <div class="closeday-sec">
                <h5>Advance Collection</h5>
                <table style='background: #e2e2e2; border-radius: 3px 3px 0px 0px; border: none; width: 100%; border-collapse: collapse;' class="item-list-tbl reportsprint">

                    <tr>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Cash</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Cheque</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>Card</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>eSewa</th>
                        <th style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>FonePay</th>
                        <th colspan="2" style='width: 30%; text-align: center; border: 1px solid #575757; padding: 2px;'></th>

                    </tr>
                    <tr>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtAdvanceCollectedInCash"></label>
                        </td>

                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtAdvanceCollectedInCheque"></label>
                        </td>

                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtAdvanceCollectedInCard"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtAdvanceCollectedIneSewa"></label>
                        </td>
                        <td style='width: 14%; text-align: center; border: 1px solid #575757; padding: 2px;'>
                            <label id="txtAdvanceCollectedInFonePay"></label>
                        </td>
                        <td colspan="2" style='width: 30%; text-align: center; border: 1px solid #575757; padding: 2px;'></td>
                    </tr>
                </table>
            </div>
            <div class="closeday-total" style="margin-top: 10px;">

                <table>
                    <tr>
                        <td colspan="2"><strong>Total Cash Received : </strong>
                            <label id="txtTotalCashReceived"></label>
                        </td>
                    </tr>
                    <tr>
                        <td><strong>Total Expenses : </strong>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtExpenses" class="sfInputbox" style="width: 100px; display: inherit;" value="0" /></td>
                        <td id="closeday_remarks"><strong>Remarks : </strong>
                            <textarea id="txtRemarks" class="sfInputbox" placeholder="Remarks" style="display: inherit;"></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="2"><strong>Cash In Counter : </strong>
                            <label id="txtCashInCounter"></label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><strong>Cash Settlement : </strong>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtCashSettlement" class="sfInputbox" style="width: 100px; display: inherit" value="0" /></td>
                    </tr>
                    <tr>
                        <td colspan="2"><strong>Closing Balance : </strong>
                            <label id="txtClosingBalance"></label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="button" id="btnCloseDay" value="Close Day" class="sfBtn restro-btn" /></td>
                    </tr>
                </table>

            </div>
        </div>

        <div id="CashDomination" class="right-sec">
            <div class="right-secA right-secAA">
                <div class="dialogflex">
                    <h5>Cash Denomination</h5>
                </div>
                <table id="Cash">
                    <tr>
                        <td>1000 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtthousand" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>500 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtfivehundred" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>100 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txthundred" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>50 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtfifty" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>20 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txttwenty" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>10 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtten" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>5 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtfive" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>2 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txttwo" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>1 *
                </td>
                        <td>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtone" class="sfInputbox" style="width: 100px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>Total:
                </td>
                        <td>
                            <%--<label id="txtTotalSum"></label>--%>
                            <input type="text" onkeypress="return IntegerAndDecimal(event,this);" id="txtTotalSum" class="sfInputbox" disabled style="width: 100px;" />
                        </td>
                    </tr>
                </table>
            </div>

        </div>
    </div>
</div>
