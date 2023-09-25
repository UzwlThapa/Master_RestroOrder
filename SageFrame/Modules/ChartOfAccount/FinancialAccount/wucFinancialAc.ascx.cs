using System;
using SageFrame.Web;
public partial class Modules_Admin_ChartOfAccount_FinancialAccount_wucFinancialAc : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("FinancialAccount", "/Modules/ChartOfAccount/FinancialAccount/js/jsFinancialAc.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
    }
}