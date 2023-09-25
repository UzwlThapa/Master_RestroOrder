using SageFrame.Web;
using System;

public partial class Modules_LandingSummaries_Events : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
    	 IncludeCss("ROMenu", "/Modules/ROMenu/css/colorbox.css");
    	 IncludeJs("ROMenu", "/Modules/ROMenu/js/jquery.colorbox.js");
    }
}