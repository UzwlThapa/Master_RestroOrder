using System;
using SageFrame.Web;

public partial class Modules_LiscenseExpired_LiscenseExpired : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        updateLiscence();
    }

    protected void updateLiscence()
    {

        System.Configuration.Configuration webConfigApp = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
        webConfigApp.AppSettings.Settings["LiscenceExpire"].Value = DateTime.Now.Date.AddYears(1).Date.ToShortDateString();
        webConfigApp.Save();
    }
}