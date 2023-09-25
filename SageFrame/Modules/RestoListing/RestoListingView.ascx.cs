using SageFrame.Web;
using System;

public partial class Modules_RestoListing_RestoListingView : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public string Username = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("RestoListing", "/Modules/RestoListing/Script/JavaScriptOfRestoListing.js");
        IncludeCss("RestoListing", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");
        IncludeJs("js", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("Css", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        

    }
}