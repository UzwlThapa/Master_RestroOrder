using System;
using SageFrame.Web;

public partial class Modules_Roi_CReport_wucForCReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsCounterPerson", "/Modules/Roi_CReport/jsCReport.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");

        IncludeCss("DataTable", "/Modules/DataTable/css/buttons.dataTables.min.css");
        //IncludeCss("DataTable", "/Modules/DataTable/css/dataTables.min.css");


        //IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/jquery-1.12.3.js");
      //IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/buttons.print.min.js");
        //IncludeJs("ROI_STOCKREPORT", "/Modules/DataTable/js/demo.js");

        //IncludeJs("ROI_STOCKREPORT", "/Modules/ROI_STOCKREPORT/Stockjs.js");
    }
}