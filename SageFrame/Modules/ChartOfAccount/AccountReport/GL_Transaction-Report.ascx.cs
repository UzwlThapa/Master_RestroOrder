using SageFrame.Web;
using System;

public partial class Modules_ChartOfAccount_AccountReport_GL_Transaction_Report : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("AccountReport", "/Modules/ChartOfAccount/AccountReport/js/GL_Transaction-Report.js");
    }
}