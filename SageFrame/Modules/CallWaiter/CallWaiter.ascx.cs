using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Configuration;

public partial class Modules_CallWaiter_CallWaiter : BaseUserControl
{
    public string modulePath = string.Empty;
    public string HostUrl = string.Empty;
    public string notification = ConfigurationManager.AppSettings["Notification"];
    public int userModuleID = 0;
    public int RowTotal = 0;
    //RestrOrderController roc = new RestrOrderController();
    public int TypeId;
    protected void Page_Load(object sender, EventArgs e)
    {
        List<companyInfo> info1 = new List<companyInfo>();
        RestrOrderController con = new RestrOrderController();

        info1 = con.getcompanyInfo();
        //string imgPath = "~/Modules/ROCompanyInfo/Logo/" + info1[0].Logo;
        TypeId = Convert.ToInt32(Request.QueryString["id"]);
        if (GetUsername == "anonymoususer")
        {
            SageFrameConfig sageConfig = new SageFrameConfig();
            Response.Redirect(sageConfig.GetSettingValueByIndividualKey(SageFrameSettingKeys.PortalLoginpage) + ".aspx"+"?ReturnURL="+this.Request.AppRelativeCurrentExecutionFilePath);
        }

        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        
        IncludeJs("RestroDashBoard", "/Modules/CallWaiter/CallWaiter.js");
        IncludeCss("Css", "/Modules/CallWaiter/css/Style.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");

        HostUrl = GetHostURL();
    }
}