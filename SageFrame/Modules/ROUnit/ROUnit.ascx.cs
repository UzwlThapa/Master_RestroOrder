using System;
using SageFrame.Web;

public partial class Modules_ROUnit_ROUnit : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROUnit", "/Modules/ROUnit/js/script.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeCss("ROUnit", "/Modules/ROUnit/js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/js/jquery-ui.css");

        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        //IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");


    }
}