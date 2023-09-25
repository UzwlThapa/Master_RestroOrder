using SageFrame.Web;
using System;

public partial class Modules_CBMS_Dashboard_Cbms_SalesBook : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jspdf.min.js");
        IncludeJs("CBMS_Dashboard", "/Modules/CBMS_Dashboard/SalesBookJs.js");
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeCss("CBMS_Dashboard", "/Modules/CBMS_Dashboard/cbms-style.css");
        //IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        //IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-sliderAccess.js");
    }
}