using SageFrame.Web;
using System;

public partial class FrontPageSetting : BaseUserControl
{
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        userModuleID = int.Parse(SageUserModuleID);
		IncludeCss("FrontPageSettingcss", "/Modules/FrontPage/css/module.css");
    }
}