<%@ Control Language="C#" AutoEventWireup="true" CodeFile="wucVoucherType.ascx.cs" Inherits="Modules_Admin_ChartOfAccount_VoucherType_wucVoucherType" %>
<script>
    $(function () {
        $(this).companyProfEDIT({});
        $("#tabs").tabs();
        $("#btnAdd").click(function () {
           
            $(".MainForm").show();
            $("#btnAdd").hide();
            $("#divForVoucherTypeList").hide();
        });
           
    });
</script>

<div class="RO_wrapper">
<div class="restro-title clearfix">
        <input id="btnAdd" type="button" class="sfLocale icon-addnew sfBtn restro-btn" value="Add" />
        </div>
        <div class="MainForm" style="display: none;">
            <table style="display:block;">
                <tr>
                    <td>Voucher Name:</td>
                    <td>
                        <input type="text" id="txtVoucherName" name="VoucherName" class="sfInputbox" /></td>
                </tr>
                <tr>
                    <td>Prefix:</td>
                    <td>
                        <input type="text" id="txtPrefix" name="Prefix" class="sfInputbox" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <label class="icon-save sfBtn restro-btn" id="btnSave">
                            Save</label>
                        <label class="icon-close sfBtn restro-btn" id="btnCancel">
                            Cancel</label>
                    </td>
                </tr>
            </table>
        </div>
    
    <div id="divForVoucherTypeList" class="restrowrapper"></div>
</div>
