using System;
using SageFrame.Web;
public partial class Modules_ROIUnitDefine_ROIUnitDefine : BaseAdministrationUserControl
{

    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROUnit", "/Modules/ROIUnitDefine/script/UnitDefine.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");

    }
}