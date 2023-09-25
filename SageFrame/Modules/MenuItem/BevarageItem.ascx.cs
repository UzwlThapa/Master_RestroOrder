using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;

public partial class Modules_MenuItem_BevarageItem : BaseUserControl
{
    public string userName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("Roi_items", "/Modules/MenuItem/js/Beverage.js");
        IncludeJs("Roi_items", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
        IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload-ui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        userName = GetUsername;

    }
}