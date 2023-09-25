using System;
using SageFrame.Web;

public partial class Modules_PurRegister_PurRegister : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("RoReport", "/Modules/RoReport/SalseReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("RoReport", "/Modules/RoReport/jspdf.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.print.min.js");
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("RoReport", "/Modules/DataTable/css/dataTables.min.css");
        IncludeCss("PurRegister", "/Modules/PurRegister/css/custom.css");

        IncludeJs("RoReport", "/js/tableExport.js");
        IncludeJs("RoReport", "/js/jquery.base64.js");
    }
}