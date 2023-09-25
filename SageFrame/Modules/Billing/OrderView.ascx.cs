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
            IncludeCss("Order", "/Modules/Billing/css/orderlistview.css");
        }
        IncludeJs("", "/Modules/Billing/js/orders.js");
         
        IncludeJs("Order", "/Modules/Billing/js/Orderitem.js"
            ,"/Modules/Billing/js/owl.carousel.js","/Modules/Billing/js/owl.carousel.js");
        IncludeJs("Order", "/Modules/Billing/js/jquery.scrollTo.min.js");
        IncludeJs("Order", "/js/jquery.alerts.js");
        IncludeCss("Order","/css/jquery.alerts.css", "/Modules/Billing/css/owl.carousel.css","/Modules/Billing/css/orderitem.css","/Modules/Billing/css/owl.theme.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("", "/css/FontAwesome.css");

        if (OrdermenuImageshow == "false"){

              IncludeCss("Order","/Modules/Billing/css/orderimg.css");
              IncludeJs("Order", "/Modules/Billing/js/orderimg.js");

         }

        HostUrl = GetHostURL();
        userName = GetUsername;
    }

}