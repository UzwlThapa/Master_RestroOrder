using System;
using SageFrame.Web;

public partial class Modules_ROAccount_ROAccountGroup : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);

        IncludeJs("ROItem", "/Modules/ROAccount/Js/accountgroupscript.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeCss("ROItem", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROItem", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROItem", "/Modules/ROUnit/Js/jquery.dataTables.min.js");

    }
}