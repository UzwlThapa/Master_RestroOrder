using System;
using SageFrame.Web;

public partial class Modules_Roi_Note_Note : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("jsNote", "/Modules/Roi_Note/jsNote.js");
    }
}