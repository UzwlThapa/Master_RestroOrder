using SageFrame.RestroOrder;
using SageFrame.Web;
using System.Configuration;
using System;

public partial class Modules_OrderDelivery_OrderDeliveryStatus : BaseUserControl
{
    public string HostUrl = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        HostUrl = GetHostURL();
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("GenerateBills", "/Modules/GenerateBills/GenerateBillsJS.js");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");
        IncludeJs("OrderDelivery", "/Modules/OrderDelivery/Js/OrderStatus.js");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("Order", "/Modules/Order/js/jquery.scrollTo.min.js");
        IncludeJs("Order", "/js/jquery.alerts.js");
        IncludeCss("Order", "/css/jquery.alerts.css", "/Modules/Order/css/owl.carousel.css", "/Modules/Order/css/orderitem.css", "/Modules/Order/css/owl.theme.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
    }
}