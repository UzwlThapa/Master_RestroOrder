using System;
using SageFrame.Web;

public partial class Modules_ROUnit_RoUnit1 : BaseAdministrationUserControl
{

    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROUnit", "/Modules/ROUnit/js/script.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");

        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");

    }
}