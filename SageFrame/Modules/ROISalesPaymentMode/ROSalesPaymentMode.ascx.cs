using System;
using SageFrame.Web;

public partial class Modules_ROISalesPaymentMode_js_ROSalesPaymentMode : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;

    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("PaymentMode", "/Modules/ROISalesPaymentMode/js/SPMscript.js"
            , "/Modules/Order/js/owl.carousel.js");


        //IncludeJs("ROUnit", "/Modules/ROUnit/js/script.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");

        IncludeCss("ROUnit", "/Modules/ROUnit/js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/js/jquery-ui.css");

        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");
        IncludeCss("Order", "/Modules/Order/css/owl.carousel.css", "/Modules/Order/css/orderitem.css", "/Modules/Order/css/owl.theme.css");
    }
}