using System;
using SageFrame.Web;

public partial class Modules_ProductionHouse_ProductionHouse : BaseUserControl
{
    public string userName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ProductionHouse", "/Modules/ProductionHouse/jsProduction.js");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        userName = GetUsername;
    }
}