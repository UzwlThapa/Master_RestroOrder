using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;

public partial class Modules_Dinning_Dinning : BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;
    public string notification = ConfigurationManager.AppSettings["Notification"];
    public int userModuleID = 0;
    public int RowTotal = 0;
    RestrOrderController roc = new RestrOrderController();
    public int TypeId;
    public string numpin = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        List<companyInfo> info1 = new List<companyInfo>();

        info1 = roc.getcompanyInfo();
        ImgPrvs.ImageUrl = "/Modules/ROCompanyInfo/logo/" + info1[0].Logo;
        TypeId = Convert.ToInt32(Request.QueryString["id"]);
        if (GetUsername == "anonymoususer")
        {
            SageFrameConfig sageConfig = new SageFrameConfig();
            Response.Redirect(sageConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalLoginpage) + ".aspx");
        }

        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("RestroDashBoard", "/Modules/Dinning/DinningJS.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-sliderAccess.js");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");
        IncludeJs("", "/js/pincode.js");

        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");

        HostUrl = GetHostURL();
        BindRoomsDatas();
        BindRoomsDatasForShift();
        BindRoomType();
        BindRoomTypeForShift();
    }

    private void BindRoomsDatas()
    {
        StringBuilder str = new StringBuilder();
        str.Append("<div class='Rooms'> </div>");
        ltrRoom.Text = str.ToString();

        StringBuilder str1 = new StringBuilder();
        str1.Append("<div class='TablesInRooms Tables'> </div>");
        ltrtable.Text = str1.ToString();
    }

    private void BindRoomsDatasForShift()
    {
        StringBuilder str = new StringBuilder();
        str.Append("<td>Rooms : </td><td><div class='RoomsForShift'><select class='imgRoomForShift sfInputbox' style='width:200px;'><option value='' disabled selected>-- select --</option></select> </div></td>");
        ltrRoomForShift.Text = str.ToString();
    }
    private void BindRoomTypeForShift()
    {
        List<RoomType> Roomtypes = new List<RoomType>();
        Roomtypes = roc.getRoomType();
        StringBuilder str = new StringBuilder();
        str.Append("<td>Room Type : </td><td><select class='imgroomtypeforshift sfInputbox' style='width:200px;'><option value='' disabled selected>-- select --</option>");
        foreach (RoomType type in Roomtypes)
        {
            str.Append("<option value='" + type.RoomTypeID + "'>");
           str.Append(type.Title);
            str.Append("</option>");
        }
        str.Append("</select></td>");
        ltrShift.Text = str.ToString();

    }
    private void BindRoomType()
    {
        List<RoomType> Roomtypes = new List<RoomType>();
        Roomtypes = roc.getRoomType();
        StringBuilder str = new StringBuilder();
        str.Append("<div class='Roomtype'><ul id='restroSpace'>");
        foreach (RoomType type in Roomtypes)
        {
            str.Append("<li id ='" + type.RoomTypeID + "'><a id ='" + type.RoomTypeID + "_img' class = 'imgroomtype' >");
            str.Append("<h5>" + type.Title + "</h5></a>");
            str.Append("</li>");

        }
        str.Append("</ul></div>");

        ltrRoomType.Text = str.ToString();

    }
}