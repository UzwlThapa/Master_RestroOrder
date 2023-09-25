using SageFrame.Web;
using System;

public partial class Modules_Admin_FiscalYearSetting_FiscalYearSetting : BaseUserControl
{

    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        Includes();
    }

    private void Includes()
    {
        IncludeCss("FiscalYearSettings","/css/jquery.alerts.css");
        IncludeJs("FiscalYearSettings", "/Modules/Admin/FiscalYearSetting/js/FisaclYearSetting.js");
        IncludeJs("FiscalYearSettings", "/Modules/ROUnit/js/jquery.validate.js","/js/jquery.alerts.js");
    }
}