using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using System.Text;
using SageFrame.RestroOrder;

public partial class Modules_ROrderLayout_ROrderLayoutEdit : BaseUserControl
{
    RestrOrderController roc = new RestrOrderController();
    public string HostUrl = string.Empty;
    public string UserModuleID = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        UserModuleID = SageUserModuleID;
        IncludeCss("RO_layout", "/Modules/ROrderLayout/css/layout.css");
        IncludeJs("RO_Layout", "/Modules/ROrderLayout/js/layout.js");
        IncludeJs("", "/js/jquery.alerts.js");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("", "/js/pincode.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");
        BindRoomsDatasForReservation();
        HostUrl = GetHostURL();
        
    }

    private void BindRoomsDatasForReservation()
    {
        //room types list bind
        List<RoomType> Roomtypes = new List<RoomType>();
        Roomtypes = roc.getRoomType();
        StringBuilder str = new StringBuilder();
        str.Append("<label>Room Type</label> <select class='imgroomtypeformerge sfInputbox''>");
        foreach (RoomType type in Roomtypes)
        {
            str.Append("<option value='" + type.RoomTypeID + "'>");
            str.Append(type.Title);
            str.Append("</option>");

        }
        str.Append("</select></td>");
        ltrLayout.Text = str.ToString();

        //rooms select dropdown bind
        StringBuilder roomsStr = new StringBuilder();
        roomsStr.Append("<div class='form-group RoomsForLayout'></div>");
        ltrRoomForLayout.Text = roomsStr.ToString();
    }
}