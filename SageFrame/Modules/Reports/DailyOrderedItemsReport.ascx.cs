using System;
using SageFrame.Web;

public partial class Modules_Reports_DailyOrderedItemsReport : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        IncludeJs("Report", "/Modules/Reports/DailyOrderedItemReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("Report", "/Modules/RoReport/jspdf.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("Report", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("Report", "/Modules/DataTable/js/buttons.print.min.js");
        IncludeCss("Report", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
    }
}