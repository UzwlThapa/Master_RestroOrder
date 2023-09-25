using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;

public partial class Modules_CloseDay_CloseDayReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("CloseDay", "/Modules/CloseDay/CloseDay.js");
        IncludeJs("", "/js/pincode.js");
        IncludeJs("", "/js/jsPDF.js");
    }
}