using System;
using SageFrame.Web;

public partial class Modules_ChartOfAccount_BalanceSheet_BalanceSheet : BaseUserControl
{
    public string HostUrl = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("FinancialAccount", "/Modules/ChartOfAccount/BalanceSheet/js/jsBalanceSheet.js");
        HostUrl = GetHostURL();
    }
}