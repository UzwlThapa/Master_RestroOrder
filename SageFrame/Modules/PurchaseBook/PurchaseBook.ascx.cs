using System;
using SageFrame.Web;

public partial class Modules_PurchaseBook_PurchaseBook : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("PurchaseBook", "/Modules/PurchaseBook/JsPurchaseBook.js");
        IncludeJs("RecquistionSlip", "/Modules/RecquistionSlip/js/date.format.js");
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.css");
        IncludeJs("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui-timepicker-addon.js");
        IncludeCss("CBMS_Dashboard", "/Modules/CBMS_Dashboard/cbms-style.css");
    }
}