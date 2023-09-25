using System;
using SageFrame.Web;

public partial class Modules_BillsReport_BillsReport : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("BillsReport", "/Modules/BillsReport/js/BillsReport.js");
    }
}