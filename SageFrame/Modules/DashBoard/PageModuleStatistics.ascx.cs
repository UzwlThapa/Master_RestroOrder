#region "Copyright"
/*
FOR FURTHER DETAILS ABOUT LICENSING, PLEASE VISIT "LICENSE.txt" INSIDE THE SAGEFRAME FOLDER
*/
#endregion

#region "References"
using System;
using System.Web.UI;
using SageFrame.Web;
#endregion 

public partial class Modules_DashBoard_PageModuleStatistics : BaseAdministrationUserControl
{
    public int PortalID = 0;
    public string UserName = "";
    public string appPath = "";
    public string PortalName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        RegScript();
        GetVariable();
    }

    public void RegScript()
    {
        Page.ClientScript.RegisterClientScriptInclude("tblPaging", ResolveUrl("~/Modules/DashBoard/js/quickpager.jquery.js"));
    }

    public void GetVariable()
    {
        PortalID = GetPortalID;
        PortalName = GetPortalSEOName;
        UserName = GetUsername;
        appPath = GetApplicationName;
    }
}
