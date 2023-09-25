using System;
using SageFrame.Web;
using System.Configuration;

public partial class Modules_CustomerBalanceReport_VenderBalanceReport : BaseUserControl
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
        // IncludeJs("CustomerBalanceReport", "/Modules/CustomerBalanceReport/Script/CusBalanceReportScript.js");
        IncludeJs("CustomerBalanceReport", "/Modules/CustomerBalanceReport/Script/CusReport.js", "/Modules/RestoItem/Script/Validation.js");
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("Report", "/js/convertnumbers.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        hdIsCustomer.Value = "0";
    }
}