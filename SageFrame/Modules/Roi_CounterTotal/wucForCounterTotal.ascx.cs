using System;
using SageFrame.Web;

public partial class Modules_Roi_CounterTotal_wucForCounterTotal : BaseUserControl
{
    public string userName = String.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("Roi_CounterTotal", "/Modules/Roi_CounterTotal/jsCounterTotal.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        userName = GetUsername;
    }
}