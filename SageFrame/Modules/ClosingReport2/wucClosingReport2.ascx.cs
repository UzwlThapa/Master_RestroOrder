using System;
using SageFrame.Web;

public partial class Modules_ClosingReport2_wucClosingReport2 : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Includes();
        IncludeJs("ClosingReport", "/Modules/ClosingReport2/js/jsClosingReportView.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeCss("DataTable", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.print.min.js");
    }



    private void Includes()
    {
        IncludeCss("ClosingReport", "/Modules/ClosingReport/css/style.css");
    }
}