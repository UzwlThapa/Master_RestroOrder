using System;
using SageFrame.Web;
using SageFrame.ChartOfAccount;
public partial class Modules_Admin_ChartOfAccount_verifyTransactionEntry_wucVerifyTransactionEntry : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("FinancialAccount", "/Modules/ChartOfAccount/verifyTransactionEntry/js/jsVerifyTransactionEntry.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        //autoVoucherNo();
    }
    private void autoVoucherNo()
    {
        AccountController con = new AccountController();
        string data = con.getAutoVoucherNo();

        //foreach (var item in data)
        //{
        //    txtPuno.Text = item.PuNo;
        //}
        hdnVoucherNo.Value = data;
    }
}