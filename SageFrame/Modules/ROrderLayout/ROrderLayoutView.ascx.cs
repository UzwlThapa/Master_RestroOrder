using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using System.Text;
using SageFrame.RestroOrder;
public partial class Modules_ROrderLayout_ROrderLayoutView : BaseUserControl
{
    RestrOrderController roc = new RestrOrderController();
    public string HostUrl = string.Empty;
    public string UserModuleID = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("", "/js/pincode.js");
        IncludeCss("RO_layout", "/Modules/ROrderLayout/css/layout.css");
        IncludeJs("RO_Layout", "/Modules/ROrderLayout/js/layout.js");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery.timepicker.min.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-sliderAccess.js");
        HostUrl = GetHostURL();
        UserModuleID = SageUserModuleID;
    }

}