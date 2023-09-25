using System;
using SageFrame.Web;

public partial class Modules_FAQ_FAQView : BaseAdministrationUserControl
{
    public int PortalID;
    public int UserModuleID;
    public string baseURL;
    public bool PostQuestion;
    public string CultureName;
    protected void Page_Load(object sender, EventArgs e)
    {
        PortalID = GetPortalID;
        CultureName = GetCurrentCulture();
        UserModuleID = int.Parse(SageUserModuleID);
        baseURL = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        IncludeJs("FAQ", "/Modules/FAQ/js/FAQ.js", "/js/jquery.validate.js", "/Modules/FAQ/js/jquery.pagination.js");
        IncludeCss("FAQ", "/Modules/FAQ/css/module.css");
    }
}
