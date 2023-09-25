using SageFrame.Web;
using System;

public partial class Modules_CreditPayReport_CreditPayReport : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("CreditPayReport", "/Modules/CreditPayReport/js/jsCreditReportView.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("Report", "/js/convertnumbers.js");
    }
}