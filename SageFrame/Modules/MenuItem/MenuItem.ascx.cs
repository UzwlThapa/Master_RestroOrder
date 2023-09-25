using SageFrame.Web;
using System;

public partial class Modules_MenuItem_MenuItem : BaseUserControl
{
    public string userName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
    
        IncludeJs("MenuItem", "/Modules/MenuItem/js/MenuItem.js");
        IncludeJs("MenuItem", "/Modules/MenuItem/js/ckeditor/adapters/jquery.js");
        IncludeJs("MenuItem", "/Modules/MenuItem/js/ckeditor/ckeditor.js");
        IncludeCss ("MenuItem", "/Modules/MenuItem/js/ckeditor/skins/moono-lisa/editor.css");
        IncludeJs("Roi_items", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
        IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload-ui.css");
        IncludeJs("ROI_Item", "/js/jquery.validate.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        userName = GetUsername;
    }
}