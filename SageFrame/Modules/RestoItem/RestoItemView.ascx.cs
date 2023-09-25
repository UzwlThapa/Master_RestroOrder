using SageFrame.Web;
using System;

public partial class Modules_RestoItem_RestoItemView : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
          userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/JavaScriptForRestoItem.js");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/Validation.js", "/js/jquery.alerts.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/jquery-ui.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
    }
}