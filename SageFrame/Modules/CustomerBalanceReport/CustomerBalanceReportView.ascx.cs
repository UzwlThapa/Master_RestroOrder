using SageFrame.Web;
using System;
using System.Configuration;

public partial class Modules_CustomerBalanceReport_CustomerBalanceReportView : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public string Username = string.Empty;
    public int userModuleID = 0;
    public string numpin = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("Report", "/js/convertnumbers.js");
        IncludeJs("CustomerBalanceReport", "/Modules/CustomerBalanceReport/Script/CusReport.js", "/Modules/RestoItem/Script/Validation.js");

        IncludeJs("RoReport", "/Modules/RoReport/jspdf.min.js");
          IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        hdIsCustomer.Value = "1";
    }
}