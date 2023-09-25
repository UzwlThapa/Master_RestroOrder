using System;
using SageFrame.Web;

public partial class Modules_Admin_Roi_InventoryReport_wucAdjusmentReport : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        //IncludeJs("Report", "/Modules/Admin/Roi_InventoryReport/jsInventoryReport.js");
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("Report", "/Modules/Admin/Roi_InventoryReport/AdujstmentReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
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
        HiddenField1.Value = "5";
    }
}