using System;
using SageFrame.Web;

public partial class Modules_RO_Cogs_ItemDailyProfit : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("RO_Cogs", "/Modules/RO_Cogs/js/itemDailyProfit.js");      
    }
}