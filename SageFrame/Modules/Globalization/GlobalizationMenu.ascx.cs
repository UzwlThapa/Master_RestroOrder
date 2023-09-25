using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
public partial class Modules_Globalization_GlobalizationMenu : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("Globalization", "/Modules/Globalization/GlobalizationJS.js");
    }
}