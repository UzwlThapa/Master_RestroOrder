using System;
using SageFrame.Web;

public partial class Modules_SiteMap_SiteMap : BaseAdministrationUserControl
{
    public string ModulePath = "";
    public int UserModuleID = 0;
    public int PortalID = 0;
    public string UserName = "", CultureName = "";
    public string PageExtension = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        PageExtension = SageFrameSettingKeys.PageExtension;
        UserName = GetUsername;
        UserModuleID = Int32.Parse(SageUserModuleID);
        PortalID = GetPortalID;
        CultureName = GetCurrentCultureName;
        ModulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        IncludeCss("sitemapcss", "/Modules/SiteMap/css/slickmap.css");
        IncludeJs("SiteMap", "/Modules/SiteMap/js/sitemap.js");
    }
}