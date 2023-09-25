using System;
using SageFrame.Web;
using SageFrame.ChartOfAccount;
public partial class Modules_Admin_ChartOfAccount_JournalEntry_wucJournalEntry : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("FinancialAccount", "/Modules/ChartOfAccount/JournalEntry/js/jsJournalEntry.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
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