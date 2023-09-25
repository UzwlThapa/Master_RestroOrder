using SageFrame.Framework;
using SageFrame.Security;
using SageFrame.Web;
using System;

public partial class FrontPage : BaseUserControl
{
    public int userModuleID = 0;
    public string userName = string.Empty;
    public string Extension;
    public string HostUrl = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {

        HostUrl = GetHostURL();
        if (GetUsername == "anonymoususer")
        {
            SageFrameConfig sageConfig = new SageFrameConfig();
            Response.Redirect(sageConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalLoginpage) + ".aspx");
        }
        SecurityPolicy objSecurity = new SecurityPolicy();
        userName = objSecurity.GetUser(GetPortalID);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeCss("FrontPagecss", "/Modules/FrontPage/css/animate.css");
		IncludeCss("FrontPagecss", "/Modules/FrontPage/css/FrontPage.css");
		IncludeCss("FrontPagecss", "/Modules/FrontPage/css/colorbox.css");
		IncludeJs("FrontPagejs", "/Modules/FrontPage/js/FrontPage.js");
		IncludeJs("FrontPagejs", "/Modules/FrontPage/js/jquery.colorbox.js");

        SageFrameConfig sfConfig = new SageFrameConfig();
        Extension = SageFrameSettingKeys.PageExtension;
        lnkAccount.NavigateUrl = GetProfileLink(sfConfig);

        RoleController _role = new RoleController();
        bool isDashboardAccessible = _role.IsDashboardAccesible(GetUsername, GetPortalID);
        if (isDashboardAccessible)
        {
            hlnkDashboard.Visible = true;
            hlnkDashboard.HRef = GetPortalAdminPage();
        }
        else
        {
            hlnkDashboard.Visible = false;
        }
    }
    public string GetPortalAdminPage()
    {
        string sageNavigateUrl = string.Empty;
        SageFrameConfig sfConfig = new SageFrameConfig();
        if (!IsParent)
        {
            sageNavigateUrl = string.Format("{0}/portal/{1}/Admin/Admin" + Extension, GetParentURL, GetPortalSEOName);
        }
        else
        {
            sageNavigateUrl = GetParentURL + "/Admin/Admin" + Extension;
        }
        return sageNavigateUrl;
    }
    private string GetProfileLink(SageFrameConfig sfConfig)
    {
        string profileURL = "";
        if (!IsParent)
        {
            profileURL = GetParentURL + "/portal/" + GetPortalSEOName + "/" + "sfUser-Profile" + Extension;
        }
        else
        {
            profileURL = GetParentURL + "/User-Profile" + Extension;
        }
        return profileURL;
    }
}