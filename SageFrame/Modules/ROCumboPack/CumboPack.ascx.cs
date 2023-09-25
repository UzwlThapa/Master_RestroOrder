using SageFrame.RestroOrder;
using System;
using SageFrame.Web;
using System.Configuration;

public partial class Modules_ROCumboPack_CumboPack : BaseUserControl
{
    public string Username = string.Empty;
     public string ordermenulisttype = ConfigurationManager.AppSettings["OrderMenuListType"].ToString();
    public string OrdermenuImageshow = ConfigurationManager.AppSettings["OrderMenuImageshow"].ToString();
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
       
        IncludeJs("ROCumboPack", "/Modules/ROCumboPack/script/cumboScript.js");
         if (ordermenulisttype == "true")
        {
            IncludeCss("Order", "/Modules/Order/css/orderlistview.css");
        }
        //IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.validate.js");
        IncludeJs("Roi_items", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
        IncludeCss("ROI_Item", "/Modules/ROI_Item/Scripts/jquery.fileupload-ui.css");
       // IncludeCss("RoItem", "/js/uploadfile/uploadfile.css");
       // IncludeJs("ROItem", "/js/uploadfile/form.js", "/js/uploadfile/jquery.uploadfile.js", "/Modules/ROI_Item/Scripts/jquery.uploadfile.min.js");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/Validation.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
         if (OrdermenuImageshow == "false"){

              IncludeCss("Order","/Modules/Order/css/orderimg.css");

         }
        //IncludeJs("ROI_Item", "/js/jquery.validate.js");
    }
}