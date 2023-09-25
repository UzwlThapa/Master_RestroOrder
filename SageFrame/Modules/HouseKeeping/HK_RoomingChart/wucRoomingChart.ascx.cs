using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;

public partial class Modules_HouseKeeping_HK_RoomingChart_wucRoomingChart : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("RoomingChart", "/Modules/HouseKeeping/HK_RoomingChart/jsRoomingChart.js");
    }
}