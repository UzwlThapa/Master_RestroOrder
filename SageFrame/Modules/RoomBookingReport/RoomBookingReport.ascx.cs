using System;
using SageFrame.Web;

public partial class Modules_RoomBookingReport_RoomBookingReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("RoomBookingReport", "/Modules/RoomBookingReport/Booking.js");
    }
}