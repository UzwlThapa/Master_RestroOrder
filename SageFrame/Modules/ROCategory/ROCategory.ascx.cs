using SageFrame.Web;
using System;

public partial class Modules_ROCategory_ROCategory : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        //IncludeJs("ROItem", "/js/uploadfile/form.js", "/js/uploadfile/jquery.uploadfile.js");
        IncludeJs("ROMenu", "/Modules/ROCategory/Js/categoryscript.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeCss("ROUnit", "/Modules/ROUnit/js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        IncludeCss("RoItem", "/js/uploadfile/uploadfile.css");
        
    }
}