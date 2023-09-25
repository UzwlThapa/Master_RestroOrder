<%@ Control Language="C#" AutoEventWireup="true" CodeFile="FiscalYearSetting.ascx.cs" Inherits="Modules_Admin_FiscalYearSetting_FiscalYearSetting" %>

<script type="text/javascript">
    $(function () {
        $('#tabs').tabs()
        $(this).FiscalYearEDIT({
            Username: '<%=Username%>'
        });
          resizeIframe();
    });
</script>

<div class="RO_wrapper">
    <div class="restro-title clearfix">
        <input type="button" id="btnAddfy" value="Add" class="sfLocale icon-addnew sfBtn">
    </div>
        <table id="frmInput" style="display: none;">
            <tr>
                <td>Fiscal Year ID :
                </td>
                <td>
                    <input type="text" id="txtFyId" value="0" disabled="disabled" class="sfInputbox" />
                </td>
            </tr>
            <tr>
                <td>Fiscal Year Name :
                </td>
                <td>
                    <input type="text" id="txtFyName" class="sfInputbox required" />
                </td>
            </tr>
            <tr>
                <td>Date Range ( Start Date - End Date ): 
                </td>
                <td>
                    <input type="text" id="txtStartDate" class="sfInputbox required" style="width:100px;float:left;" />
                    <input type="text" id="txtEndDate" class="sfInputbox required" style="width:100px;float:left;margin-left:10px;"/>
                </td>
            </tr>
            <tr>
                <td>Is Active 
                </td>
                <td>
                    <input type="checkbox" id="chkIsActive" />
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input class="sfLocale icon-save sfBtn" type="button" id="btnPurchaseAdd" value="Save" />
                    <input class="sfLocale icon-close sfBtn" type="button" id="btnPurchaseCancel" value="Cancel" /></td>
            </tr>
        </table>
        <div id="AddTempTable" class="restrowrapper" style="margin-top: -1px;">
            <table id='tblFiscalData' cellspacing='0'>
                <thead>
                    <tr>
                        <th>Fiscal Year ID</th>
                        <th>Fiscal Year</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Is Active</th>
                        <th>Edit</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
