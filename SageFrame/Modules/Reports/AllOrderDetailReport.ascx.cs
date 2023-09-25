using System;
using SageFrame.Web;
public partial class Modules_Reports_AllOrderDetailReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("Report", "/Modules/Reports/js/AllOrderDetail.js");
    }
}