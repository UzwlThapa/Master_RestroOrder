using SageFrame.Security;
using SageFrame.Security.Entities;
using SageFrame.Web;
using System;
using System.Collections.Generic;

public partial class Modules_Admin_ActivityLog_ActivityLogReportView : BaseUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Includes();
        BindUser();
    }

    private void BindUser()
    {

        MembershipController m = new MembershipController();
        SageFrameUserCollection lstUser = m.GetAllUsers();
        List<UserInfo> userlist = lstUser.UserList;

        userddlist.DataTextField = "UserName";
        userddlist.DataValueField = "UserName";
        userddlist.DataSource = userlist;
        userddlist.DataBind();
    }

    private void Includes()
    {
        IncludeJs("", "/js/jsPDF.js");
        IncludeCss("MaterializedView", "/Modules/Admin/MaterializedReport/css/style.css");
        IncludeJs("MaterializedView", "/Modules/Admin/ActivityLog/JavaScript.js");

        IncludeJs("MaterializedView", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
          IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
    }
}