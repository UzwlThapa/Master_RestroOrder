using System;
using SageFrame.Web;

public partial class Modules_Roi_OpenDrawer_openDrawer : BaseUserControl
{
    //public int master=0;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("openDrawer", "/Modules/Roi_OpenDrawer/jsOpenDrawer.js");
    }
}