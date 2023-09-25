using SageFrame.Web;
using System;

public partial class Modules_ItemBalance_ItemBalanceView : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);

        IncludeJs("ItemBalance", "/Modules/ItemBalance/Script/ScriptForItemBalance.js");

        IncludeJs("RestoItem", "/Modules/RestoItem/Script/Validation.js", "/js/jquery.alerts.js");
        // IncludeCss("RestoItem", "/Modules/RestoItem/Script/jquery-ui.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
    }
}