using System;
using System.Collections.Generic;
using SageFrame.Web;
using SageFrame.RestroOrder;
public partial class Modules_ROIGoodsReceive_GoodsReceived : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROIGoodsReceive", "/Modules/ROIGoodsReceive/script/GoodsReceive.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("ROIGoodsReceive", "/js/convertnumbers.js");
        // IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");

        ReceiptNo();
    }
    private void ReceiptNo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<goodsReceiveMain> data = roc.GoodReceiveAutoNumber();

        foreach (goodsReceiveMain item in data)
        {
            txtGmNo.Text = item.GMNo;
        }

    }
}