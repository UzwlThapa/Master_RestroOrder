using SageFrame.Web;
using System;

public partial class Modules_RORoom_RestroRoom : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("RORoom", "/Modules/RORoom/roomscript.js");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
    }
}