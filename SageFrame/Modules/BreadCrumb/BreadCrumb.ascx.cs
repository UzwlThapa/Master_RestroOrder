#region "Copyright"
/*
FOR FURTHER DETAILS ABOUT LICENSING, PLEASE VISIT "LICENSE.txt" INSIDE THE SAGEFRAME FOLDER
*/
#endregion

#region "References"
using System;
using System.Web.UI;
using SageFrame.Web;
using System.IO;
using SageFrame.Common.Shared;
#endregion 

public partial class Modules_BreadCrumb_BreadCrumb : BaseAdministrationUserControl
{
    public int PortalID = 0;
    public string PageName = "", AppPath = string.Empty, pagePath = string.Empty;
    public string DefaultPortalHomePage = "",CultureCode=string.Empty;
    public int MenuID;
    public string Extension;
    protected void Page_Load(object sender, EventArgs e)
    { 
        IncludeLanguageJS(); 
        CultureCode = GetCurrentCulture();
        Extension = SageFrameSettingKeys.PageExtension;
        Initialize();
        SageFrameConfig sfConfig = new SageFrameConfig();
        string pagePath = ResolveUrl(GetParentURL) + GetReduceApplicationName;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "BreadCrumGlobal1", " var BreadCrumPagePath='" + pagePath + "';", true);
        pagePath = IsParent ? pagePath : pagePath + "portal/" + GetPortalSEOName;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "BreadCrumAdminGlobal" + GetPortalID, " var BreadCrumPageLink='" + ResolveUrl(pagePath) + "';", true);
        PortalID = GetPortalID;
        if (!IsParent)
        {
            DefaultPortalHomePage = GetParentURL + "/portal/" + GetPortalSEOName + "/" + sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage) + SageFrameSettingKeys.PageExtension;
        }
        else
        {
            DefaultPortalHomePage = GetParentURL + "/" + sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage) + SageFrameSettingKeys.PageExtension;
        }
    }

    public void Initialize()
    {
        PortalID = GetPortalID;
        PageName = Path.GetFileNameWithoutExtension(PagePath);
        AppPath = Request.ApplicationPath != "/" ? Request.ApplicationPath : "";
        RegisterClientScriptToPage(ScriptMap.BreadCrumbScript.Key, ResolveUrl(AppPath + ScriptMap.BreadCrumbScript.Value), true);
        MenuID = 0;
        IncludeCss("BreadCrumb", "/Modules/BreadCrumb/css/module.css");
    }
}
