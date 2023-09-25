using System;
using SageFrame.Web;
public partial class Modules_RoTableReservation_TableReservationReport : BaseUserControl
{
    public string HostUrl = string.Empty;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        HostUrl = GetHostURL();
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("RoTableReservation", "/Modules/RoTableReservation/Reservation.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeJs("", "/js/pincode.js");
    }
}