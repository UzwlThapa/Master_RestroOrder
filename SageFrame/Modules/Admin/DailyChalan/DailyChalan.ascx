<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DailyChalan.ascx.cs" Inherits="Modules_Admin_DailyChalan_DailyChalan" %>

<script type="text/javascript">

    $(document).ready(function () {

        $(this).DailyChalanEDIT({

        });

        $(".AddIssue").click(function () {
            $(".AddIssue").hide();
            $("#IssueContainer").show();
        });

        $(".AddReturn").click(function () {
            $(".AddReturn").hide();
            $("#returnContainer").show();
        });
        resizeIframe();
    });

</script>
<div id="tabs">
    <ul>
        <li><a href="#tab-1">Daily Chalan</a></li>
    </ul>
    <div id="tab-1">
        <input type="button" id="btnAdd" value="Add" class="sfLocale icon-addnew sfBtn" style="margin-bottom: 15px;" />
        <table id="container">
            <tr>
                <td>
                    <table style="display: block;">
                        <tr>
                            <td>
                                <input type="hidden" value="0" id="txtId" />
                            </td>
                        </tr>
                        <tr>
                            <td>Initial Amount :</td>
                            <td>
                                <input type="text" class="txtTotal sfInputbox required" style="width: 90px" name="txtTotal" />
                            </td>
                            <td>Remaining Amount :</td>
                            <td>
                                <input type="text" class="txtRemainingAmt sfInputbox required" style="width: 90px" name="txtTotal" readonly="readonly" />
                            </td>
                            <td>Assigned By :</td>
                            <td>
                                <select class="dd_AssignedBy dd_bind" name="dd_AssignedBy"></select>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label class="sfLocale icon-addnew sfBtn AddIssue">Add Issue</label>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <%--<tr>
                <td>
                    <input type="checkbox" class="chkIssue chkbx">issue
                     <input type="checkbox" class="chkReturn chkbx">Return
                </td>
            </tr>--%>
            <tr>
                <td>
                    <table id="IssueContainer" style="display: none;">
                        <tbody>
                            <tr class="issueRow" data-id="0">

                                <td>Issued By :</td>
                                <td>
                                    <select id="ddlIssue" class="dd_bind dd_IssuedBy"></select>
                                </td>
                                <td>Amount :</td>
                                <td>
                                    <input type="text" class="txtIssuedAmount sfInputbox required" style="width: 90px" name="txtIssuedAmount" />
                                </td>
                                <td>For :</td>
                                <td>
                                    <input type="text" class="txtFor sfInputbox required" style="width: 90px" name="txtFor" />
                                </td>
                                <td>
                                    <input type="button" class="sfBtn sfButton btnPlus" value="+" />
                                </td>

                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="5" style="text-align: right;">Balance :</td>
                                <td>
                                    <input type="text" class="sfInputbox txtIssuedBalance" style="width: 90px" readonly="readonly" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <label class="sfLocale icon-addnew sfBtn AddReturn">Add Return</label>
                                </td>
                            </tr>

                        </tfoot>
                    </table>
                </td>
            </tr>

            <tr>
                <td>
                    <div id="temporaryReturn">

                        <table id="returnContainer" style="display: none;">
                            <tbody>
                                <tr class="returnRow" data-id="0">
                                    <td>Returned By :</td>
                                    <td>
                                        <select id="ddlReturn" class="dd_ReturnedBy dd_bind"></select>
                                    </td>
                                    <td>Amount :</td>
                                    <td>
                                        <input type="text" class="txtReturnedAmount sfInputbox required" style="width: 90px" name="txtReturnedAmount" />
                                    </td>
                                    <td>Remarks :</td>
                                    <td>
                                        <textarea class="sfInputbox txtMessage" rows="2" cols="8" name="txtMessage"></textarea>
                                    </td>
                                    <td>
                                        <input type="button" class="sfBtn sfButton btnReturnPlus" value="+" />
                                    </td>

                                </tr>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="5" style="text-align: right;">Balance :</td>
                                    <td>
                                        <input type="text" class="sfInputbox txtReturnedBalance" style="width: 90px" readonly="readonly" />
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                    <tr>
                        <td>
                            <input type="button" class="sfLocale icon-save sfBtn" id="btnSave" value="Save" style="margin-bottom: 10px;" />
                            <input type="button" class="sfLocale icon-close sfBtn" id="btnCancel" value="Cancel" style="margin-bottom: 10px;" />
                        </td>
                    </tr>
        </table>
    </div>
</div>
<div id="bindChalan"></div>
<%--<script>
    $(document).ready(function () {

        $(".txtIssuedAmount").on("keydown keyup", function (event) {
            $(".txtBalance").val(Number($(".txtIssuedAmount").val()) + Number($(".txtIssuedAmount").val()));

        });
    });

</script>--%>
