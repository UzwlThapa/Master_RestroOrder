using System;
using System.Collections.Generic;
using SageFrame.Web;
using SageFrame.RestroOrder;
public partial class Modules_ROLogo_ROLogo : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.validate.js");
        //IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");
        //IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        //IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        //IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        //tbl1.Visible = false;

        List<companyInfo> info1 = new List<companyInfo>();
        RestrOrderController con = new RestrOrderController();

        info1 = con.getcompanyInfo();
        //string imgPath = "~/Modules/ROCompanyInfo/Logo/" + info1[0].Logo;
        ImgPrvs.ImageUrl = "/Modules/ROCompanyInfo/logo/" + info1[0].Logo;
        
    }
}