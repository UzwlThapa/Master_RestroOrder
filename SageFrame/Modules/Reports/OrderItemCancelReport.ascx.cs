using SageFrame.Web;
using System;

public partial class Modules_Reports_OrderItemCancelReport : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("Report", "/Modules/Reports/jsOrderItemCancel.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
    }
}