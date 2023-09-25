using System;
using SageFrame.Web;

public partial class Modules_RecquistionSlip_RecquistionSlip : BaseAdministrationUserControl
{
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        IncludeJs("RecquistionSlip", "/Modules/RecquistionSlip/js/RecquistionmSLip.js");

        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css");
         IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
    }
}