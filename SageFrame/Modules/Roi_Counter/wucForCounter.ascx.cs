using System;
using SageFrame.Web;

public partial class Modules_Roi_Counter_wucForCounter : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("Roi_Counter", "/Modules/Roi_Counter/jsCounter.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
    }
}