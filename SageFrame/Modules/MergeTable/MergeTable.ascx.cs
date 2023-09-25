using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;

public partial class Modules_MergeTable_MergeTable : BaseUserControl
{
    RestrOrderController roc = new RestrOrderController();
    public string HostUrl = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (GetUsername == "anonymoususer")
        {
            SageFrameConfig sageConfig = new SageFrameConfig();
            Response.Redirect(sageConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalLoginpage) + ".aspx");
        }

        IncludeJs("RestroDashBoard", "/Modules/MergeTable/MergeTable.js");
        IncludeJs("", "/js/pincode.js");

        HostUrl = GetHostURL();
        BindRoomsDatasForMerge();
    }

    private void BindRoomsDatasForMerge()
    {
        //room types list bind
        List<RoomType> Roomtypes = new List<RoomType>();
        Roomtypes = roc.getRoomType();
        StringBuilder str = new StringBuilder();
        str.Append("<td>Room Type : </td><td><select class='imgroomtypeformerge sfInputbox' style='width:150px;'>");
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
        roomsStr.Append("<td>Rooms : </td><td><div class='RoomsForMerge'><select class='imgRoomMerge sfInputbox' style='width:150px;'></select> </div></td>");
        ltrRoomForMerge.Text = roomsStr.ToString();
    }
}