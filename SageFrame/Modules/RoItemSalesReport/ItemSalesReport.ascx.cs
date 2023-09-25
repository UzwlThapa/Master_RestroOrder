using SageFrame.Web;
using System;

public partial class Modules_RoItemSalesReport_ItemSalesReport : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("RoItemSalesReport", "/Modules/RoItemSalesReport/script/itemsalesReport.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.print.min.js");
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
      
        // IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");

    }
}