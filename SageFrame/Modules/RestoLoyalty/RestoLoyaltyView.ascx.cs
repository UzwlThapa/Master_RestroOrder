using SageFrame.Web;
using System;

public partial class Modules_RestoLoyalty_RestoLoyaltyView : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        //BindGrid();

        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("RestoLoyalty", "/Modules/RestoLoyalty/Script/RestoLoyalty.js");

        
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/Validation.js", "/js/jquery.alerts.js");
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        // IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        
    }

    //public void BindGrid()
    //{
    //    List<MemberInfo> memberInfoList = new List<MemberInfo>();
    //    RestoLoyaltyController con = new RestoLoyaltyController();
    //    memberInfoList = con.getmembershiplist();

    //    //gdvMembership.DataSource = memberInfoList;
    //    //gdvMembership.DataBind();
    //}

   
}