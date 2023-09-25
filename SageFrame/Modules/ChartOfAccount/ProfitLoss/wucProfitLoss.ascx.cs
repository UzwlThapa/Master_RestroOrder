using System;
using SageFrame.Web;

public partial class Modules_ChartOfAccount_ProfitLoss_wucProfitLoss : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("ProfitLoss", "/Modules/ChartOfAccount/ProfitLoss/js/jsProfitLoss.js");
    }
}