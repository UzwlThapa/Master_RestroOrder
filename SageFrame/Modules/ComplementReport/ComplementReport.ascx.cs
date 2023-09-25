using System;
using SageFrame.Web;

public partial class Modules_ComplementReport_ComplementReport : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("ComplementReport", "/Modules/ComplementReport/complementReport.js");
    }
}