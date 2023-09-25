using SageFrame.Web;
using System;
using System.Configuration;
public partial class Modules_UnPaid_Bills_UnpaidBills : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string HostUrl = string.Empty;
    public int TypeId;
    public string numpin = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("UnPaid-Bills", "/Modules/UnPaid-Bills/UnpaidBill.js");
     
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");

        HostUrl = GetHostURL();
    }
}