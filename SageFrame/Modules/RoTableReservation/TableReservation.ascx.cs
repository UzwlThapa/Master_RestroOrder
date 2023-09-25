using System;
using SageFrame.Web;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using System.Text;

public partial class Modules_RoTableReservation_TableReservation : BaseUserControl
{
    RestrOrderController roc = new RestrOrderController();
    public string HostUrl = string.Empty;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        IncludeJs("RoTableReservation", "/Modules/RoTableReservation/Reservation.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        HostUrl = GetHostURL();
        BindRoomsDatasForReservation();
    }
    private void BindRoomsDatasForReservation()
    {
        //room types list bind
        List<RoomType> Roomtypes = new List<RoomType>();
        Roomtypes = roc.getRoomType();
        StringBuilder str = new StringBuilder();
        str.Append("<label>Room Type : </label> <select class='imgroomtypeformerge sfInputbox' style='width:150px;'>");
        foreach (RoomType type in Roomtypes)
        {
            str.Append("<option value='" + type.RoomTypeID + "'>");
            str.Append(type.Title);
            str.Append("</option>");

        }
        str.Append("</select></td>");
        ltrMerge.Text = str.ToString();

        //rooms select dropdown bind
        StringBuilder roomsStr = new StringBuilder();
        roomsStr.Append("<div class='form-group RoomsForMerge'></div>");
        ltrRoomForMerge.Text = roomsStr.ToString();
    }
}