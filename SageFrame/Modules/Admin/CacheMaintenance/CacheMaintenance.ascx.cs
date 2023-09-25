using System;
using SageFrame.Web;


public partial class Modules_Admin_CacheMaintenance_CacheMaintenance : BaseAdministrationUserControl
{
    public int PortalID;
    public int ModuleID;
    public string UserName;
    protected void Page_Load(object sender, EventArgs e)
    {
        PortalID = GetPortalID;
        ModuleID = int.Parse(SageUserModuleID);
        UserName = GetUsername;
        IncludeJs("CacheMaintenance", "/Modules/Admin/CacheMaintenance/JS/CacheMaintenance.js");
    }
   
}
