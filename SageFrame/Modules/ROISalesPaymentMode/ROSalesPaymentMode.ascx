<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ROSalesPaymentMode.ascx.cs" Inherits="Modules_ROISalesPaymentMode_js_ROSalesPaymentMode" %>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<%--<script src="js/vendor/jquery.ui.widget.js"></script>
<script src="js/jquery.iframe-transport.js"></script>
<script src="js/jquery.fileupload.js"></script>--%>
<script type="text/javascript">
    var filename;

    $(function () {


        //var imagefile = [];
        $(this).companyProfEDIT({


        });
    })
</script>

<div id="tabs">
    <ul>
        <li><a href="#tab">Sales Payment Mode</a></li>
    </ul>
    <div id="tab">
        <label id="AddSalesPaymentMode" class="sfLocale icon-addnew sfBtn">Add</label>
        <div id="salespaymentmodeTable">
            <table id="RO-SalesPaymentMode">
                <tr>
                    <td>Payment Mode :
                    </td>
                    <td>
                        <input type="text" id="textSalesPaymentModeName" name="itemname" class="required sfInputbox" />
                    </td>
                </tr>
                <tr>
                    <td>Description :
                    </td>
                    <td>
                        <textarea id="textSalesPaymentModeDescription" class="required sfInputbox" name="text" style="width: 60%; height: 60px"></textarea>
                        <%--<input type="text" id="textItemDescription" class="sfInputbox" />--%>
                    </td>
                </tr>
                <tr>
                    <td>Swap
                    </td>
                    <td>
                        <input type="checkbox" name="chckSwap" id="chckSwap" />
                        <table id="tblSwap">
                            <tr>
                                <td>Provider Name</td>
                                <td><input type="text" name="txtProviderName" /></td>
                            </tr>            <tr>
                                <td></td>
                                <td>D</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div id="SalesPaymentModeButton">
            <label id="btnSalesPaymentModeSave" class="sfLocale icon-save sfBtn">Save</label>
            <label id="btnSalesPaymentModeCancel" class="sfLocale icon-close sfBtn">Cancel</label>
        </div>
    </div>
    <div id="salespaymentmodedata"></div>
</div>
