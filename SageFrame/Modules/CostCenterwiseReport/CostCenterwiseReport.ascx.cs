using System;
using SageFrame.Web;

public partial class Modules_CostCenterwiseReport_CostCenterwiseReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("CostCenterwiseReport", "/Modules/CostCenterwiseReport/js/CostCenterwiseReport.js");
    }
}