using SageFrame.Web;
using System;


public partial class Modules_AddCustomer_AddCustomer : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {

        //int masterid = Convert.ToInt32(Request.QueryString["ID"].ToString());

        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("RestoLoyalty", "/Modules/AddCustomer/CustomerJS.js");

        IncludeJs("RestoItem", "/Modules/RestoItem/Script/Validation.js", "/js/jquery.alerts.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
    }
}