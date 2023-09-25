using System;
using System.Data;
using System.Linq;
using System.Web;
using SageFrame.Web;
using SageFrame.Templating;
using System.IO;
using System.Collections.Generic;
using SageFrame.Common;
using SageFrame.Security;
using SageFrame.Framework;
using SageFrame.Core;
using SageFrame.SageMenu;
using SageFrame.MenuManager;
using System.Text;

public partial class Controls_TopStickyBar : BaseAdministrationUserControl
{
    public int UserModuleID, PortalID;
    public string appPath = string.Empty;
    public string Extension;
    public string ContainerClientID = string.Empty;
    public string userName = string.Empty;
    public string logoNavigation = string.Empty;
    public string menuType = string.Empty;
    public string UserName = string.Empty, PageName = string.Empty, CultureCode = string.Empty;
    string pagePath = string.Empty;

    protected void Page_Init(object sender, EventArgs e)
    {

        BindThemes();
        BindLayouts();
        BindValues();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeLanguageJS();
        appPath = GetApplicationName;
        SecurityPolicy objSecurity = new SecurityPolicy();
        userName = objSecurity.GetUser(GetPortalID);
        Extension = SageFrameSettingKeys.PageExtension;
        UserModuleID = Convert.ToInt32(537);
        PortalID = GetPortalID;
        UserName = GetUsername;
        CultureCode = GetCurrentCulture();
        PageName = Path.GetFileNameWithoutExtension(PagePath);
        pagePath = IsParent ? ResolveUrl(GetParentURL) : ResolveUrl(GetParentURL) + "portal/" + GetPortalSEOName;

        CreateDynamicNav();
        IncludeJs("topstickybar", "/js/TopStickyBar.js");
        if (!IsPostBack)
        {
            // BindThemes();
            //BindLayouts();
            //BindValues();
            hlnkDashboard.Visible = false;
            SageFrameConfig conf = new SageFrameConfig();
            string ExistingPortalShowProfileLink = conf.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalShowProfileLink);
            lnkAccount.NavigateUrl = GetProfileLink();
            if (ExistingPortalShowProfileLink == "1")
            {
                lnkAccount.Visible = true;
            }
            else
            {
                lnkAccount.Visible = false;
            }
            SageFrame.Version.SageFrameVersion app = new SageFrame.Version.SageFrameVersion();
            lblVersion.Text = string.Format("V {0}", app.FormatShortVersion(app.Version, true));
        }
        hypLogo.NavigateUrl = GetDashBoardPage();
        hypLogo.ImageUrl = appPath + "/Administrator/Templates/Default/images/restroorder.png";
        RoleController _role = new RoleController();
        bool isDashboardAccessible = _role.IsDashboardAccesible(GetUsername, GetPortalID);
        if (isDashboardAccessible)
        {
            hlnkDashboard.Visible = true;
            hlnkDashboard.NavigateUrl = GetPortalAdminPage();
            cpanel.Visible = true;
        }
        else
        {
            cpanel.Visible = false;
        }
        GetAllMenuSettings();
    }

    public void BindValues()
    {
        PresetInfo preset = GetPresetDetails;
        if (preset.ActiveTheme == string.Empty)
        {
            preset.ActiveTheme = "default";
        }
        ddlThemes.Items.FindByText(preset.ActiveTheme.ToLower()).Selected = true;
        if (preset.ActiveWidth == string.Empty)
        {
            preset.ActiveWidth = "Wide";
        }
        ddlScreen.Items.FindByText(preset.ActiveWidth.ToLower()).Selected = true;
        string activeLayout = string.Empty;
        string pageName = Request.Url.ToString();
        SageFrameConfig sfConfig = new SageFrameConfig();
        pageName = Path.GetFileNameWithoutExtension(pageName);
        pageName = pageName.ToLower().Equals("default") ? sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage) : pageName;
        string tempActiveLayout = string.Empty;
        foreach (KeyValue kvp in preset.lstLayouts)
        {
            string[] arrLayouts = kvp.Value.Split(',');
            if (arrLayouts.Contains(pageName))
            {
                activeLayout = kvp.Key;
            }
            if (kvp.Value.ToLower() == "all")
            {
                tempActiveLayout = kvp.Key;
            }
        }
        if (activeLayout != null && activeLayout != string.Empty)
        {
            if (ddlLayout.Items.FindByText(string.Format("{0}.ascx", activeLayout)) != null)
            {
                ddlLayout.Items.FindByText(string.Format("{0}.ascx", activeLayout)).Selected = true;
            }
        }
        else
        {
            activeLayout = tempActiveLayout;
            if (ddlLayout.Items.FindByText(string.Format("{0}.ascx", activeLayout)) != null)
            {
                ddlLayout.Items.FindByText(string.Format("{0}.ascx", activeLayout)).Selected = true;
            }
        }
    }

    protected void btnApply_Click(object sender, EventArgs e)
    {
        HttpRuntime.Cache.Remove(CacheKeys.SageFrameJs);
        HttpRuntime.Cache.Remove(CacheKeys.SageFrameCss);
        string optimized_path = Server.MapPath(SageFrameConstants.OptimizedResourcePath);
        IOHelper.DeleteDirectoryFiles(optimized_path, ".js,.css");
        if (File.Exists(Server.MapPath(SageFrameConstants.OptimizedCssMap)))
        {
            XmlHelper.DeleteNodes(Server.MapPath(SageFrameConstants.OptimizedCssMap), "resourcemaps/resourcemap");
        }
        if (File.Exists(Server.MapPath(SageFrameConstants.OptimizedJsMap)))
        {
            XmlHelper.DeleteNodes(Server.MapPath(SageFrameConstants.OptimizedJsMap), "resourcemap/resourcemap");
        }
        PresetInfo preset = new PresetInfo();
        preset = PresetHelper.LoadActivePagePreset(TemplateName, GetPageSEOName(Request.Url.ToString()));
        if (ddlScreen.SelectedItem.ToString() != string.Empty)
        {
            preset.ActiveWidth = ddlScreen.SelectedItem.ToString();
        }
        if (ddlThemes.SelectedItem != null && ddlThemes.SelectedItem.ToString() != string.Empty)
        {
            preset.ActiveTheme = ddlThemes.SelectedItem.ToString();
        }
        if (ddlLayout.SelectedItem != null && ddlLayout.SelectedItem.ToString() != string.Empty)
        {
            preset.ActiveLayout = Path.GetFileNameWithoutExtension(ddlLayout.SelectedItem.ToString());
        }
        List<KeyValue> lstLayouts = preset.lstLayouts;
        string pageName = Request.Url.ToString();
        SageFrameConfig sfConfig = new SageFrameConfig();
        pageName = Path.GetFileNameWithoutExtension(pageName);
        pageName = pageName.ToLower().Equals("default") ? sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage) : pageName;
        bool isNewLayout = false;
        int oldPageCount = 0;
        bool isNewPage = false;
        bool deleteRepeat = false;
        bool duplicateLayout = false;
        List<string> pageList = new List<string>();
        foreach (KeyValue kvp in lstLayouts)
        {
            if (kvp.Key == preset.ActiveLayout)
            {
                duplicateLayout = true;
            }
            string[] pages = kvp.Value.Split(',');
            pageList.Add(string.Join(",", pages));
            if (pages.Count() == 1 && pages.Contains(pageName)) // for single pagename and if page = currentpageName
            {
                kvp.Key = preset.ActiveLayout;
            }
            else if (pages.Count() > 1 && pages.Contains(pageName))// for multiple pagename and if page = currentpageName
            {
                isNewLayout = true;                             //its because we have to insert another layout
                List<string> lstnewpage = new List<string>();
                foreach (string page in pages)
                {
                    if (page.ToLower() != pageName.ToLower())
                    {
                        lstnewpage.Add(page);
                    }
                }
                kvp.Value = string.Join(",", lstnewpage.ToArray());
                pageList.Add(kvp.Value);
            }
            else
            {
                oldPageCount++;
            }
            if (kvp.Value == "All" && kvp.Key == preset.ActiveLayout)
            {
                deleteRepeat = true;
            }
        }
        if (lstLayouts.Count == oldPageCount)
        {
            isNewPage = true;
        }
        List<KeyValue> lstNewLayouts = new List<KeyValue>();
        if (isNewPage)
        {
            bool isAppended = false;
            foreach (KeyValue kvp in lstLayouts)
            {
                if (kvp.Key == preset.ActiveLayout)
                {
                    if (kvp.Value.ToLower() != "all")
                    {
                        kvp.Value += "," + pageName;
                    }
                    isAppended = true;
                }
                lstNewLayouts.Add(new KeyValue(kvp.Key, kvp.Value));
            }
            if (!isAppended)
            {
                lstNewLayouts.Add(new KeyValue(preset.ActiveLayout, pageName));
            }
            lstLayouts = lstNewLayouts;
        }
        else if (isNewLayout)
        {
            bool isAppended = false;
            bool isAll = false;
            foreach (KeyValue kvp in lstLayouts)
            {
                if (kvp.Key == preset.ActiveLayout)
                {
                    if (kvp.Value.ToLower() != "all")
                    {
                        kvp.Value += "," + pageName;
                        isAll = true;
                    }
                    isAppended = true;
                }
                lstNewLayouts.Add(new KeyValue(kvp.Key, kvp.Value));
            }
            if (!isAppended && !isAll)
            {
                lstNewLayouts.Add(new KeyValue(preset.ActiveLayout, pageName));
            }
            lstLayouts = lstNewLayouts;
        }
        else if (deleteRepeat)
        {
            foreach (KeyValue kvp in lstLayouts)
            {
                if (kvp.Value.ToLower() != pageName.ToLower())
                {
                    lstNewLayouts.Add(new KeyValue(kvp.Key, kvp.Value));
                }
            }
            lstLayouts = lstNewLayouts;
        }
        else if (duplicateLayout)
        {
            string key = preset.ActiveLayout;
            List<string> pages = new List<string>();
            foreach (KeyValue kvp in lstLayouts)
            {
                if (kvp.Key.ToLower() != preset.ActiveLayout.ToLower())
                {
                    lstNewLayouts.Add(new KeyValue(kvp.Key, kvp.Value));
                }
                else
                {
                    pages.Add(kvp.Value);
                }
            }
            lstNewLayouts.Add(new KeyValue(key, string.Join(",", pages.ToArray())));
            lstLayouts = lstNewLayouts;
        }
        preset.lstLayouts = lstLayouts;
        string presetPath = Decide.IsTemplateDefault(TemplateName.Trim()) ? Utils.GetPresetPath_DefaultTemplate(TemplateName) : Utils.GetPresetPath(TemplateName);
        string pagepreset = presetPath + "/" + TemplateConstants.PagePresetFile;
        presetPath += "/" + "pagepreset.xml";
        AppErazer.ClearSysHash(ApplicationKeys.ActivePagePreset + "_" + GetPortalID);
        PresetHelper.WritePreset(presetPath, preset);
        SageFrame.Common.CacheHelper.Clear("PresetList");
        Response.Redirect(Request.Url.OriginalString);
    }

    public string GetPortalAdminPage()
    {
        string sageNavigateUrl = string.Empty;
        SageFrameConfig sfConfig = new SageFrameConfig();
        if (!IsParent)
        {
            sageNavigateUrl = string.Format("{0}/portal/{1}/Admin/Admin" + Extension, GetParentURL, GetPortalSEOName);
            //sageNavigateUrl = GetParentURL + "/portal/" + GetPortalSEOName + "/" + sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage).Replace(" ", "-") + SageFrameSettingKeys.PageExtension;
        }
        else
        {
            sageNavigateUrl = GetParentURL + "/Admin/Admin" + Extension;
            //sageNavigateUrl = GetParentURL + "/" + sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage).Replace(" ", "-") + SageFrameSettingKeys.PageExtension;
        }
        return sageNavigateUrl;
    }
    public string GetDashBoardPage()
    {
        string sageNavigateUrl = string.Empty;
        SageFrameConfig sfConfig = new SageFrameConfig();
        if (!IsParent)
        {
            //sageNavigateUrl = string.Format("{0}/portal/{1}/Admin/Admin" + Extension, GetParentURL, GetPortalSEOName);
            sageNavigateUrl = GetParentURL + "/portal/" + GetPortalSEOName + "/" + sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage).Replace(" ", "-") + SageFrameSettingKeys.PageExtension;
        }
        else
        {
            //sageNavigateUrl = GetParentURL + "/Admin/Admin" + Extension;
            sageNavigateUrl = GetParentURL + "/" + sfConfig.GetSettingsByKey(SageFrameSettingKeys.PortalDefaultPage).Replace(" ", "-") + SageFrameSettingKeys.PageExtension;
        }
        return sageNavigateUrl;
    }
    private string GetProfileLink()
    {
        string profileURL = string.Empty;
        SageFrameConfig sfConfig = new SageFrameConfig();
        string profilepage = sfConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalUserProfilePage);
        profilepage = profilepage.ToLower().Equals("user-profile") ? string.Format("/sf/{0}", profilepage) : string.Format("/{0}", profilepage);
        profileURL = !IsParent ? string.Format("{0}/portal/{1}/{2}" + Extension, GetParentURL, GetPortalSEOName, profilepage) : string.Format("{0}/{1}" + Extension, GetParentURL, profilepage);
        return profileURL;
    }

    public void BindThemes()
    {
        string themePath = Decide.IsTemplateDefault(TemplateName) ? Utils.GetThemePath_Default(TemplateName) : Utils.GetThemePath(TemplateName);
        List<KeyValue> lstThemes = new List<KeyValue>();
        if (Directory.Exists(themePath))
        {
            DirectoryInfo dir = new DirectoryInfo(themePath);
            foreach (DirectoryInfo theme in dir.GetDirectories())
            {
                lstThemes.Add(new KeyValue(theme.Name, theme.Name));
            }
        }
        lstThemes.Insert(0, new KeyValue("default", "default"));
        ddlThemes.DataSource = lstThemes;
        ddlThemes.DataTextField = "Key";
        ddlThemes.DataTextField = "Value";
        ddlThemes.DataBind();
    }

    public void BindLayouts()
    {
        string templatePath = Decide.IsTemplateDefault(TemplateName) ? Utils.GetTemplatePath_Default(TemplateName) : Utils.GetTemplatePath(TemplateName);
        List<KeyValue> lstLayouts = new List<KeyValue>();
        int count = 0;
        if (Directory.Exists(templatePath))
        {
            DirectoryInfo dir = new DirectoryInfo(templatePath);
            foreach (FileInfo layout in dir.GetFiles())
            {
                if (layout.Extension.Contains("ascx"))
                {
                    lstLayouts.Add(new KeyValue(count.ToString(), layout.Name));
                    count++;
                }
            }
        }
        ddlLayout.DataSource = lstLayouts;
        ddlLayout.DataValueField = "Key";
        ddlLayout.DataTextField = "Value";
        ddlLayout.DataBind();
    }

    #region sagemenu
    public void CreateDynamicNav()
    {
        ContainerClientID = "divNav_" + 537;
        ltrNav.Text = "<div id='" + ContainerClientID + "'></div>";
    }

    #endregion
    public void GetAllMenuSettings()
    {
        SageMenuSettingInfo objMenuSetting = new SageMenuSettingInfo();
        objMenuSetting = MenuController.GetMenuSetting(PortalID, UserModuleID);
        BuildMenu(objMenuSetting);
    }

    public void BuildMenu(SageMenuSettingInfo objMenuSetting)
    {
        menuType = objMenuSetting.MenuType;
        switch (int.Parse(objMenuSetting.MenuType))
        {
            case 0:
                //LoadTopAdminMenu();
                break;
            case 1:
                GetPages(objMenuSetting);
                break;
           
        }
    }

    #region "GetPages"

    public void GetPages(SageMenuSettingInfo objMenuSetting)
    {
        List<MenuManagerInfo> objMenuInfoList = GetMenuFront(PortalID, UserName, CultureCode, UserModuleID);
        BindPages(objMenuInfoList, objMenuSetting);
    }

    public void BindPages(List<MenuManagerInfo> objMenuInfoList, SageMenuSettingInfo objMenuSetting)
    {
        int pageID = 0;
        int parentID = 0;
        string itemPath = string.Empty; ;
        StringBuilder html = new StringBuilder();
        int rootItemCount = 0;
        foreach (MenuManagerInfo objMenuInfo in objMenuInfoList)
        {
            if (int.Parse(objMenuInfo.MenuLevel) == 0)
            {
                rootItemCount = objMenuInfoList.IndexOf(objMenuInfo);
            }
        }
        html.Append(BuildMenuClassContainer(int.Parse(objMenuSetting.TopMenuSubType)));
        int countMenuInfo = 0;
        foreach (MenuManagerInfo objMenuInfo in objMenuInfoList)
        {
            pageID = objMenuInfo.MenuItemID;
            parentID = objMenuInfo.ParentID;
            if (objMenuInfo.MenuLevel == "0")
            {
                string PageURL = objMenuInfo.URL.Split('/').Last();
                string pageLink = objMenuInfo.LinkType == "0" ? pagePath + PageURL + Extension : objMenuInfo.LinkURL;
                if (objMenuInfo.LinkURL == string.Empty)
                {
                    pageLink = pageLink.IndexOf(Extension) > 0 ? pageLink : pageLink + Extension;
                }
                string firstclass = string.Empty;
                string activeClass = PageURL == PageName ? "sfActive" : "";
                if (objMenuInfo.ChildCount > 0)
                {
                    firstclass = countMenuInfo == 0 ? "class='sfFirst sfParent " + activeClass + "'" : countMenuInfo == rootItemCount ? "class='sfParent sfLast " + activeClass + "'" : "class='sfParent " + activeClass + "'";
                }
                else
                {
                    firstclass = countMenuInfo == 0 ? "class='sfFirst " + activeClass + "'" : countMenuInfo == rootItemCount ? "class='sfLast " + activeClass + "'" : "class='" + activeClass + "'";
                }

                html.Append("<li ");
                html.Append(firstclass);
                html.Append(">");
                string menuItem = BuildMenuItem(int.Parse(objMenuSetting.DisplayMode), objMenuInfo, pageLink, objMenuSetting.Caption);
                html.Append(menuItem);
                if (objMenuInfo.LinkType == "1")
                {
                    html.Append("<ul class='megamenu'><li style=''><div class='megawrapper'>");
                    html.Append(objMenuInfo.HtmlContent);
                    html.Append("</div></li></ul>");
                }
                else
                {
                    if (objMenuInfo.ChildCount > 0)
                    {
                        html.Append("<ul style='display: none; visibility: hidden;'>");
                        itemPath = objMenuInfo.Title;
                        string childCategory = BindChildCategory(objMenuInfoList, pageID, int.Parse(objMenuSetting.DisplayMode), objMenuSetting.Caption);
                        html.Append(childCategory);
                        html.Append("</ul>");
                    }
                }
                html.Append("</li>");
            }
            itemPath = string.Empty;
            countMenuInfo++;
        }
        html.Append("</ul></div>");
        ltrNav.Text = html.ToString();
    }

    #endregion

   

    #region

    private List<MenuManagerInfo> GetMenuFront(int PortalID, string UserName, string CultureCode, int UserModuleID)
    {
        try
        {
            List<MenuManagerInfo> lstMenuItems = new List<MenuManagerInfo>();
            if (SageFrameSettingKeys.FrontMenu && UserName == "anonymoususer")
            {
                if (!SageFrame.Common.CacheHelper.Get(CultureCode + ".FrontMenu" + PortalID.ToString(), out lstMenuItems))
                {
                    lstMenuItems = MenuManagerDataController.GetSageMenu_Localized(UserModuleID, PortalID, UserName, CultureCode);
                    SageFrame.Common.CacheHelper.Add(lstMenuItems, CultureCode + ".FrontMenu" + PortalID.ToString());
                }
            }
            else
            {
                lstMenuItems = MenuManagerDataController.GetSageMenu_Localized(UserModuleID, PortalID, UserName, CultureCode);
            }
            IEnumerable<MenuManagerInfo> lstParent = new List<MenuManagerInfo>();
            List<MenuManagerInfo> lstHierarchy = new List<MenuManagerInfo>();
            lstParent = from pg in lstMenuItems
                        where pg.MenuLevel == "0"
                        select pg;

            foreach (MenuManagerInfo parent in lstParent)
            {
                lstHierarchy.Add(parent);
                GetChildPages(ref lstHierarchy, parent, lstMenuItems);
            }
            return (lstHierarchy);
        }
        catch (Exception)
        {
            throw;
        }
    }
    private string BuildMenuClassContainer(int MenuMode)
    {
        string html = "<div id='" + ContainerClientID + "' class='menu clearfix'>";
        switch (MenuMode)
        {
            case 1:
                html += "<ul class='sf-menu sf-vertical'>";
                break;
            case 2:
                html += "<ul class='sf-menu sf-navbar '>";
                break;
            case 3:
                html += "<span id='sfResponsiveNavBtn' class='inactive'><span></span></span><ul class='sf-menu sfDropdown clearfix'>";
                break;
            case 4:
                html += "<ul class='sf-menu sfCssmenu'>";
                break;
        }
        return html;
    }

    private string BuildMenuItem(int displayMode, MenuManagerInfo objMenuInfo, string pageLink, string caption)
    {
        StringBuilder html = new StringBuilder();
        if (!objMenuInfo.IsActive)
        {
            pageLink = "#";
        }

        string title = objMenuInfo.PageName;
        pageLink = pageLink.Replace("&", "-and-");
        if (objMenuInfo.LinkType != null)
        {
            title = objMenuInfo.LinkType == "0" ? objMenuInfo.PageName : objMenuInfo.Title;
        }
        string image = appPath + "/PageImages/" + objMenuInfo.ImageIcon;
        string imageTag = objMenuInfo.ImageIcon != string.Empty ? "<img src=" + image + ">" : "";
        string arrowStyle = objMenuInfo.ChildCount > 0 ? "<span class='sf-sub-indicator'></span>" : "";
        switch (displayMode)
        {
            case 0://image only
                if (caption == "1")
                {
                    html.Append("<a  href='");
                    html.Append(pageLink);
                    html.Append("'><span class='sfPageicon'>");
                    html.Append(imageTag);
                    html.Append("<em>");
                    html.Append(objMenuInfo.Caption);
                    html.Append("</em>");
                    html.Append("</span>");
                    html.Append(arrowStyle);
                    html.Append("</a>");
                }
                else
                {
                    html.Append("<a  href='");
                    html.Append(pageLink);
                    html.Append("'><span class='sfPageicon'>");
                    html.Append(imageTag);
                    html.Append("</span>");
                    html.Append(arrowStyle);
                    html.Append("</a>");
                }
                break;
            case 1://text only
                if (caption == "1")
                {
                    html.Append("<a  href='");
                    html.Append(pageLink);
                    html.Append("'><span class='sfPagename'>");
                    html.Append(title);
                    html.Append("<em>");
                    html.Append(objMenuInfo.Caption);
                    html.Append("</em>");
                    html.Append("</span>");
                    html.Append(arrowStyle);
                    html.Append("</a>");
                }
                else
                {
                    html.Append("<a  href='");
                    html.Append(pageLink);
                    html.Append("'><span class='sfPagename'>");
                    html.Append(title);
                    html.Append("</span>");
                    html.Append(arrowStyle);
                    html.Append("</a>");
                }
                break;
            case 2: //text and image both
                if (caption == "1")
                {
                    html.Append("<a  href='");
                    html.Append(pageLink);
                    html.Append("'><span class='sfPageicon'>");
                    html.Append(imageTag);
                    html.Append("</span></a><span class='sfPagename'>");
                    html.Append(title);
                    html.Append("<em>");
                    html.Append(objMenuInfo.Caption);
                    html.Append("</em>");
                    html.Append("</span>");
                    html.Append(arrowStyle);
                  
                }
                else
                {
                    html.Append("<a  href='");
                    html.Append(pageLink);
                    html.Append("'><span class='sfPageicon'>");
                    html.Append(imageTag);
                    html.Append("</span></a>");
                    html.Append("<span class='sfPagename'>");
                    html.Append(title);
                    html.Append("</span>");
                    html.Append(arrowStyle);
                   
                }
                break;
        }
        return html.ToString();
    }
    private string BindChildCategory(List<MenuManagerInfo> objMenuInfoList, int pageID, int menuDisplayMode, string ShowCaption)
    {
        string strListmaker = string.Empty;
        string childNodes = string.Empty;
        string path = string.Empty;
        string itemPath = string.Empty;
        StringBuilder html = new StringBuilder();
        foreach (MenuManagerInfo objMenuInfo in objMenuInfoList)
        {
            if (int.Parse(objMenuInfo.MenuLevel) > 0)
            {
                if (objMenuInfo.ParentID == pageID)
                {
                    itemPath = objMenuInfo.Title;
                    string PageURL = objMenuInfo.URL.Split('/').Last();
                    string pageLink = string.Empty;
                    if (PageURL == string.Empty && objMenuInfo.LinkType == "2")
                    {
                        pageLink = objMenuInfo.LinkURL;
                    }
                    else
                    {
                        pageLink = objMenuInfo.LinkType == "0" ? pagePath + PageURL + Extension : "/" + PageURL;
                    }
                    if (objMenuInfo.LinkURL == "0")
                    {
                        pageLink = pageLink.IndexOf(Extension) > 0 ? pageLink : pageLink + Extension;
                    }
                    string styleClass = objMenuInfo.ChildCount > 0 ? "class='sfParent'" : "";
                    html.Append("<li ");
                    html.Append(styleClass);
                    html.Append(">");
                    string buildMenu = BuildMenuItem(menuDisplayMode, objMenuInfo, pageLink, ShowCaption);
                    html.Append(buildMenu);
                    childNodes = BindChildCategory(objMenuInfoList, objMenuInfo.MenuItemID, menuDisplayMode, ShowCaption);
                    if (childNodes != string.Empty)
                    {
                        html.Append("<ul>");
                        html.Append(childNodes);
                        html.Append("</ul>");
                    }
                    if (objMenuInfo.HtmlContent != string.Empty)
                    {
                        html.Append("<ul class='megamenu'><li><div class='megawrapper'>");
                        html.Append(objMenuInfo.HtmlContent);
                        html.Append("</div></li></ul>");
                    }
                    html.Append("</li>");
                }
            }
        }
        return html.ToString();
    }
    private void GetChildPages(ref List<MenuManagerInfo> lstHierarchy, MenuManagerInfo parent, List<MenuManagerInfo> lstPages)
    {
        foreach (MenuManagerInfo obj in lstPages)
        {
            if (obj.ParentID == parent.MenuItemID)
            {
                lstHierarchy.Add(obj);
                GetChildPages(ref lstHierarchy, obj, lstPages);
            }
        }
    }
    #endregion
}
