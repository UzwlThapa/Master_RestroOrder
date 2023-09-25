using SageFrame.Web;
using System;

public partial class FrontPageEdit : BaseUserControl
{
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        userModuleID = int.Parse(SageUserModuleID);
		IncludeCss("FrontPageEditcss", "/Modules/FrontPage/css/module.css");
		IncludeJs("FrontPageEditjs", "/Modules/FrontPage/js/FrontPageEdit.js");
    }
}