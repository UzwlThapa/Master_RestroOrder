using System;
using SageFrame.RestroOrder;
using System.Configuration;
using SageFrame.Web;

public partial class Modules_RestroComplementary_RestroComplementary :  BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;
     public string ordermenulisttype = ConfigurationManager.AppSettings["OrderMenuListType"].ToString();
     public string OrdermenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"].ToString();
    public int userModuleID = 0; public int RowTotal = 0;
    RestrOrderController roc = new RestrOrderController();
    public string userName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("", "/js/BillBind.js");
        if(ordermenulisttype == "true"){
            IncludeCss("Order","/Modules/Order/css/orderlistview.css");
        }
        IncludeJs("", "/Modules/RestroComplementary/js/Complementary.js");

        IncludeJs("RestroComplementary" , "/Modules/OrderFoodCode/js/owl.carousel.js");
        IncludeJs("Order", "/Modules/Order/js/jquery.scrollTo.min.js");
        IncludeJs("Order", "/js/jquery.alerts.js");
        IncludeCss("Order", "/css/jquery.alerts.css", "/Modules/Order/css/owl.carousel.css", "/Modules/Order/css/orderitem.css", "/Modules/Order/css/owl.theme.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("", "/js/pincode.js");

        if (OrdermenuImageshow == "false"){

              IncludeCss("Order","/Modules/Order/css/orderimg.css");
              IncludeJs("Order", "/Modules/Order/js/orderimg.js");

         }

        HostUrl = GetHostURL();
        userName = GetUsername;
    }
  
}