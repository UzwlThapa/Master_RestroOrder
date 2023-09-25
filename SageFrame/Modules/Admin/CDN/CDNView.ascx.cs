using System;
using SageFrame.Web;
/// <summary>
/// CDNView inherists from BaseAdministrationUserControl class
/// </summary>
public partial class Modules_HTML_CDNView : BaseAdministrationUserControl
{    
   
    public string ModulePath = "";
    public int UserModuleID = 0;
    public int PortalID = 0;
    public string UserName = "", CultureName = "";
    public string PageExtension = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("CDN", "/Modules/Admin/CDN/js/CDN.js", "/js/jquery.validate.js");
        PortalID = GetPortalID;
        UserModuleID = int.Parse(SageUserModuleID);
    }
}
