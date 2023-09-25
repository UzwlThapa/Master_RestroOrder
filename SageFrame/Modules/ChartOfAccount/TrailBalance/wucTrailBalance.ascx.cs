using System;
using SageFrame.Web;

public partial class Modules_ChartOfAccount_TrailBalance_wucTrailBalance : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("TrailBalance", "/Modules/ChartOfAccount/TrailBalance/js/jsTrailBalance.js");
   }
}