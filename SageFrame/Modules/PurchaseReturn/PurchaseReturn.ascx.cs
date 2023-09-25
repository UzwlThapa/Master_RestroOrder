using System;
using SageFrame.Web;
public partial class Modules_PurchaseReturn_PurchaseReturn : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("PurchaseReturn", "/Modules/PurchaseReturn/Purchasereturn.js");
        IncludeJs("ROIGoodsReceive", "/js/convertnumbers.js");
    }
}