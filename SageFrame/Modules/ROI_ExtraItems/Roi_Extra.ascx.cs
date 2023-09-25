using System;
using SageFrame.Web;

public partial class Modules_ROI_ExtraItems_Roi_Extra : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        IncludeJs("ROI_ExtraItems", "/Modules/ROI_ExtraItems/script/ExtraItemScript.js");
        IncludeJs("ROI_Item", "/Modules/ROUnit/js/jquery.validate.js");
    }
}