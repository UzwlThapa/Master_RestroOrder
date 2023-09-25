using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using SageFrame.Security;

public partial class Modules_GenerateBills_GenerateBills : BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;
    public string notification = ConfigurationManager.AppSettings["Notification"];
    public int userModuleID = 0; public int RowTotal = 0;
    RestrOrderController roc = new RestrOrderController();
    public int TypeId;
    public string numpin = string.Empty;
    RoleController objRole = new RoleController();
    public int creditLimit;
    protected void Page_Load(object sender, EventArgs e)
    {


        string role = objRole.GetRoleNames(GetUsername, GetPortalID);
        var topRole = role.Split(',')[0].ToLower();
        creditLimit = objRole.getLoginUserCreditLimit(topRole);

        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        //string v = Request.QueryString["action"];
        List<companyInfo> info1 = new List<companyInfo>();
        RestrOrderController con = new RestrOrderController();

        info1 = con.getcompanyInfo();
        //string imgPath = "~/Modules/ROCompanyInfo/Logo/" + info1[0].Logo;
        //ImgPrvs.ImageUrl = "/Modules/ROCompanyInfo/logo/" + info1[0].Logo;
        TypeId = Convert.ToInt32(Request.QueryString["id"]);
        if (GetUsername == "anonymoususer")
        {
            SageFrameConfig sageConfig = new SageFrameConfig();
            Response.Redirect(sageConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalLoginpage) + ".aspx");
        }

        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);

        //IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        // IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("GenerateBills", "/Modules/GenerateBills/GenerateBillsJS.js");
        //IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/date.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-sliderAccess.js");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");
        //IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");

        HostUrl = GetHostURL();
        BindRoomsDatas();
        BindRoomsDatasForShift();
        //BindRoomsDatasForMerge();
        //BindRoomType();
        BindRoomTypeForShift();
        //BindRoomTypeForMerge();
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
        str.Append("<td>Rooms : </td><td><div class='RoomsForShift'><select class='imgRoomForShift sfInputbox' style='width:150px;'><option value='' disabled selected>-- select --</option></select> </div></td>");
        ltrRoomForShift.Text = str.ToString();
    }

    private void BindRoomTypeForShift()
    {
        List<RoomType> Roomtypes = new List<RoomType>();
        Roomtypes = roc.getRoomType();
        StringBuilder str = new StringBuilder();
        str.Append("<td>Room Type : </td><td><select class='imgroomtypeforshift sfInputbox' style='width:150px;'><option value='' disabled selected>-- select --</option>");
        foreach (RoomType type in Roomtypes)
        {
            str.Append("<option value='" + type.RoomTypeID + "'>");
            //str.Append("<a id ='" + type.RoomTypeID + "_img' class = 'imgroomtype' ><img src='" + GetHostURL() + "/Modules/RODashBoard/image/Room.png' alt=" + type.Title + " height='60px' width = '60px'></a> ");
            str.Append(type.Title);
            str.Append("</option>");

        }
        str.Append("</select></td>");
        ltrShift.Text = str.ToString();

    }
    //private void BindRoomTypeForMerge()
    //{
    //    List<RoomType> Roomtypes = new List<RoomType>();
    //    Roomtypes = roc.getRoomType();
    //    StringBuilder str = new StringBuilder();
    //    str.Append("<td>Room Type : </td><td><select class='imgroomtypeformerge sfInputbox' style='width:200px;'><option value='' disabled selected>-- select --</option>");
    //    foreach (RoomType type in Roomtypes)
    //    {
    //        str.Append("<option value='" + type.RoomTypeID + "'>");
    //        //str.Append("<a id ='" + type.RoomTypeID + "_img' class = 'imgroomtype' ><img src='" + GetHostURL() + "/Modules/RODashBoard/image/Room.png' alt=" + type.Title + " height='60px' width = '60px'></a> ");
    //        str.Append(type.Title);
    //        str.Append("</option>");

    //    }
    //    str.Append("</select></td>");

    //    ltrMerge.Text = str.ToString();

    //}



}