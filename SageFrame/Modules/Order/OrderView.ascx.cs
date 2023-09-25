using SageFrame.RestroOrder;
using SageFrame.Web;
using System.Configuration;
using System;

public partial class Modules_Order_OrderView : BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;
    public string ordermenulisttype = ConfigurationManager.AppSettings["OrderMenuListType"].ToString();
    public string OrdermenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"].ToString();
    public int userModuleID = 0; public int RowTotal = 0;
    RestrOrderController roc = new RestrOrderController();
    public string userName = string.Empty;
    public string numpin = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {

        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        if (ordermenulisttype == "true")
        {
            IncludeCss("Order", "/Modules/Order/css/orderlistview.css");
        }
        IncludeJs("", "/js/orders.js");
         
        IncludeJs("Order", "/Modules/Order/js/Orderitem.js"
            ,"/Modules/Order/js/owl.carousel.js","/Modules/Order/js/owl.carousel.js");
        IncludeJs("Order", "/Modules/Order/js/jquery.scrollTo.min.js");
        IncludeJs("Order", "/js/jquery.alerts.js");
        IncludeCss("Order","/css/jquery.alerts.css", "/Modules/Order/css/owl.carousel.css","/Modules/Order/css/orderitem.css","/Modules/Order/css/owl.theme.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("", "/css/FontAwesome.css");

        if (OrdermenuImageshow == "false"){

              IncludeCss("Order","/Modules/Order/css/orderimg.css");
              IncludeJs("Order", "/Modules/Order/js/orderimg.js");

         }

        HostUrl = GetHostURL();
        userName = GetUsername;
    }

}