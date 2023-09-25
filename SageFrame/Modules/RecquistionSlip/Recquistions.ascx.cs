using SageFrame.Web;
using System;

public partial class Modules_RecquistionSlip_Recquistions : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

        IncludeJs("RecquistionSlip", "/Modules/RecquistionSlip/js/Recquistions.js");

        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css");
          IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
    }
}