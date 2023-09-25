using System;
using SageFrame.Web;
public partial class Modules_ROIIssue_IssueReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("ROIIssue", "/Modules/ROIIssue/script/RoiIssue.js");
    }
}