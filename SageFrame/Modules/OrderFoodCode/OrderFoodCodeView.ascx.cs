using SageFrame.RestroOrder;
using SageFrame.Web;
using System.Configuration;
using System;
using SageFrame.Security;

public partial class Modules_OrderFoodCode_OrderFoodCodeView : BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;
    public string ordermenulisttype = ConfigurationManager.AppSettings["OrderMenuListType"].ToString();
     public string OrdermenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"].ToString();
    public int userModuleID = 0; public int RowTotal = 0;
    public string numpin = string.Empty;
    RestrOrderController roc = new RestrOrderController();
    public string userName = string.Empty;
    public int TypeId;
    RoleController objRole = new RoleController();
    public int creditLimit;
    protected void Page_Load(object sender, EventArgs e)
    {

        string role = objRole.GetRoleNames(GetUsername, GetPortalID);
        var topRole = role.Split(',')[0].ToLower();
        creditLimit = objRole.getLoginUserCreditLimit(topRole);

        TypeId = Convert.ToInt32(Request.QueryString["id"]);
        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        //IncludeJs("GenerateBills", "/Modules/GenerateBills/GenerateBillsJS.js");
        IncludeJs("", "/js/BillBind.js");

        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");

        if (ordermenulisttype == "true"){
            IncludeCss("Order","/Modules/Order/css/orderlistview.css");
        }

        IncludeJs("OrderFoodCode", "/Modules/OrderFoodCode/js/OrderFoodCode.js"
            , "/Modules/OrderFoodCode/js/owl.carousel.js");
         IncludeJs("OrderFoodCode", "/Modules/OrderFoodCode/js/jquery.scrollTo.min.js");
         IncludeJs("OrderFoodCode", "/js/jquery.alerts.js");
          IncludeCss("Order","/css/jquery.alerts.css", "/Modules/Order/css/owl.carousel.css","/Modules/Order/css/orderitem.css","/Modules/Order/css/owl.theme.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("", "/js/pincode.js");

        if (OrdermenuImageshow == "false"){

              IncludeCss("Order","/Modules/Order/css/orderimg.css");
              IncludeJs("Order", "/Modules/Order/js/orderimg.js");

         }
        IncludeJs("", "/js/orders.js");

        HostUrl = GetHostURL();
        userName = GetUsername;
    }

}