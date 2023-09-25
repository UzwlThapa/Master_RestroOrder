using SageFrame.Web;
using System;

public partial class Modules_ExtraBilling_ViewBilling : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ExtraBilling", "/Modules/Admin/ExtraBilling/Script/ViewBilling.js");

         IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");

        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
    }
}