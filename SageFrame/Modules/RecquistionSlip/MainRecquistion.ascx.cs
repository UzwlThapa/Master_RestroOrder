using SageFrame.Web;
using System;


public partial class Modules_RecquistionSlip_MainRecquistion : BaseAdministrationUserControl
{
    public int UserModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        UserModuleID = int.Parse(SageUserModuleID);
        IncludeJs("RecquistionSlip", "/Modules/RecquistionSlip/js/MainRecquistion.js");
         IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/Validation.js");
    }
}