using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;

public partial class Modules_RoiGoodsReceiveReport_RoiGoodsReceiveReport : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("RoiGoodsReceiveReport", "/Modules/RoiGoodsReceiveReport/GoodsReceiveReport.js");
        IncludeJs("ROIGoodsReceive", "/js/convertnumbers.js");
    }
}