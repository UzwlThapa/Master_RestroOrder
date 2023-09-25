using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;

public partial class Modules_Reports_ItemShiftReport : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("Report", "/Modules/Reports/js/ShiftItemReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
    }
}