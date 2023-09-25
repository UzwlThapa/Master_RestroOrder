using System;
using SageFrame.Web;

public partial class Modules_Admin_DailyChalan_DailyChalan : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("DailyChalan", "/Modules/Admin/DailyChalan/js/DailyChalanScript.js");
        IncludeJs("DailyChalan", "/Modules/ROUnit/js/jquery.validate.js", "/js/jquery.alerts.js");

        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeCss("DataTable", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/dataTables.buttons.min.js");

    }
}