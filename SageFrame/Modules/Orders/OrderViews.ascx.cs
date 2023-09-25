using SageFrame.RestroOrder;
using SageFrame.Web;
using System;

public partial class Modules_Order_OrderView : BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;

    public int userModuleID = 0; public int RowTotal = 0;
    RestrOrderController roc = new RestrOrderController();
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
         IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui.css");
        IncludeJs("Order", "/Modules/Orders/js/Orderitem.js"
            , "/Modules/Orders/js/owl.carousel.js");
        IncludeCss("Order", "/Modules/Order/css/owl.carousel.css", "/Modules/Orders/css/orderitem.css", "/Modules/Orders/css/owl.theme.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        HostUrl = GetHostURL();
        

    }

}