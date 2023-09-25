using System;
using SageFrame.Web;

public partial class Modules_ROI_Item_Roi_items : BaseUserControl
{
    public string userName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("Roi_items", "/Modules/ROI_Item/Scripts/ItemScript.js");
        IncludeJs("Roi_items", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
        IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload-ui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
         IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
         IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        userName = GetUsername;
    }

}