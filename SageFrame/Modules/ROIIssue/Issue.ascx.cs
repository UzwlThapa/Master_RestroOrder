using System;
using System.Collections.Generic;
using SageFrame.Web;
using SageFrame.RestroOrder;

public partial class Modules_ROIIssue_Issue :  BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {

        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROIIssue", "/Modules/ROIIssue/script/RoiIssue.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeCss("ROItem", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeJs("ROItem", "/Modules/ROUnit/Js/jquery.dataTables.min.js");

        IssueBindTo();
        IssueBindFr();
        //BindItem();
        //BindUnit();
      //  ReceiptNo();
    }
    public void IssueBindTo()
    {
        RestrOrderController roc = new RestrOrderController();
        List<roistore> currencyList = roc.getIssueToDDl();
        ddlIssuedToStore.DataSource = currencyList;
        ddlIssuedToStore.DataTextField = "StName";
        ddlIssuedToStore.DataValueField = "STId";
        ddlIssuedToStore.DataBind();
        ddlIssuedToStore.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }
     public void IssueBindFr()
    {
        RestrOrderController roc = new RestrOrderController();
        List<roistore> currencyList = roc.getIssueToDDl();
        ddlIssuedFrST.DataSource = currencyList;
        ddlIssuedFrST.DataTextField = "StName";
        ddlIssuedFrST.DataValueField = "STId";
        ddlIssuedFrST.DataBind();
        ddlIssuedFrST.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select",  string.Empty));

    }
   
     public void BindUnit()
     {
         RestrOrderController roc = new RestrOrderController();
         List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
       
     }

  
}