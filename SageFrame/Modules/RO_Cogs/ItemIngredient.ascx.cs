using SageFrame.Web;
using System;

public partial class Modules_RO_Cogs_ItemIngredient : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("RO_Cogs", "/Modules/RO_Cogs/js/CogsScript.js");
        IncludeJs("Order", "/Modules/Order/js/owl.carousel.js");
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
        IncludeCss("RO_Cogs", "/Modules/RO_Cogs/css/style.css");
        IncludeCss("Order","/css/jquery.alerts.css", "/Modules/Order/css/owl.carousel.css","/Modules/Order/css/orderitem.css","/Modules/Order/css/owl.theme.css");
        IncludeCss("Report", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
    }
}