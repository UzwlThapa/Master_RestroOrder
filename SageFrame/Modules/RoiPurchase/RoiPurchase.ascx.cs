using System;
using System.Collections.Generic;
using SageFrame.Web;
using SageFrame.RestroOrder;
public partial class Modules_RoiPurchase_RoiPurchase : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROUnit", "/Modules/RoiPurchase/script/PurchaseScript.js","/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("Report", "/js/convertnumbers.js");
        IncludeJs("ROAdjustment", "/Modules/ROAdjustment/nepali.datepicker.v2.1.min.js");
        IncludeCss("ROAdjustment", "/Modules/ROAdjustment/nepali.datepicker.v2.1.min.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        // IncludeCss("ROUnit", "/Modules/ROUnit/js/jquery-ui.css");
        IncludeCss("", "/Modules/RestoItem/Script/dataTables.jqueryui.css");
        

        ReceiptNo();
    }
    private void ReceiptNo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<purchaseMain> data = roc.getAutoNumber();

        foreach (purchaseMain item in data)
        {
            txtPuno.Text = item.PuNo;
        }

    }
}