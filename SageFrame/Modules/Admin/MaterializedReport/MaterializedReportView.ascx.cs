using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;

public partial class Modules_Admin_MaterializedReport_MaterializedReportView : BaseUserControl
{
    public string CompanyName = string.Empty;
    public string  PanNo;
    public string Address = string.Empty;
    public string PhoneNo = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        Includes();
        IncludeJs("", "/js/QRCode/jquery.qrcode.js");
        IncludeJs("", "/js/QRCode/qrcode.js");
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("", "/js/jsPDF.js");  
        IncludeJs("MaterializedReport", "/Modules/Admin/MaterializedReport/js/jsMaterializedReportView.js");
        SetCompanyInfo();
        //BindUser();
    }

    private void SetCompanyInfo()
    {
        List<companyInfo> info1 = new List<companyInfo>();
        RestrOrderController con = new RestrOrderController();

        info1 = con.getcompanyInfo();
        foreach (var item in info1)
        {
            CompanyName = item.Name;
            Address = item.Address;
            PhoneNo = item.PhoneNo;
            PanNo = item.PAN;
        }
    }

    //private void BindUser()
    //{

    //    MembershipController m = new MembershipController();
    //    SageFrameUserCollection lstUser = m.GetAllUsers();
    //    List<UserInfo> userlist = lstUser.UserList;

    //    userddlist.DataTextField = "UserName";
    //    userddlist.DataValueField = "UserID";
    //    userddlist.DataSource = userlist;
    //    userddlist.DataBind();
    //}
    //private void BindData()
    //{
    //    DateTime StartDate=Convert.ToDateTime(txtStartDate.Value.ToString());
    //    DateTime EndDate = Convert.ToDateTime(txtEndDate.Value.ToString());
    //    RestrOrderController rc = new RestrOrderController();
    //    List<MaterializedReport> list = rc.MaterializedReportView(StartDate, EndDate);
    //    //userddlist.DataTextField = "UserName";
    //    //userddlist.DataValueField = "UserID";
    //    GridView1.DataSource = list;
    //    GridView1.DataBind();
    //}

    private void Includes()
    {
        IncludeCss("MaterializedView", "/Modules/Admin/MaterializedReport/css/style.css");
    }
}