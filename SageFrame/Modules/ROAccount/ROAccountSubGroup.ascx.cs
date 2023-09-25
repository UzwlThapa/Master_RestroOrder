using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
public partial class Modules_ROAccount_ROAccountSubGroup : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.validate.js");
        IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        tbl1.Visible = false;
        if (!IsPostBack)
        {
            BindDropdownList();
        }
        BindGrid();
    }

    public void BindDropdownList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<modalAccountGroup> AccountGroupList = roc.GetAccountGroupfromDatabase();
        ddlAccountGroup.DataSource = AccountGroupList;
        ddlAccountGroup.DataTextField = "AccountName";
        ddlAccountGroup.DataValueField = "AccountGroupID";
        ddlAccountGroup.DataBind();
        ddlAccountGroup.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));
    }

    private void BindGrid()
    {
        List<modalAccountSubGroup> info1 = new List<modalAccountSubGroup>();
        RestrOrderController con = new RestrOrderController();

        info1 = con.GetAccountSubGroupfromDatabase();
        gvSubAccountGroup.DataSource = info1;
        gvSubAccountGroup.DataBind();
    }

    protected void gvSubAccountGroup_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditUser")
        {
            tbl1.Visible = true;
            modalAccountSubGroup info1 = new modalAccountSubGroup();
            RestrOrderController con = new RestrOrderController();
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gvSubAccountGroup.DataKeys[grdrow.RowIndex].Values["AccountSubGroupId"].ToString());
           
            info1 = con.GetAccountSubGroupfromDatabaseById(index);

            txtName.Text = info1.Name;
            txtCode.Text = info1.Code;
            ddlAccountGroup.SelectedItem.Value = Convert.ToString(info1.AccountGroupId);
            //ddlCurrency.SelectedIndex = info1[0].CurrencyID;
            btncancel.Visible = true;
            btnadd.Visible = false;
            
        }
        else if (e.CommandName == "DeleteUser")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gvSubAccountGroup.DataKeys[grdrow.RowIndex].Values["AccountSubGroupId"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.AccountSubGroupDelete(empid);


            Response.Write("<script>jAlert('Record deleted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            gvSubAccountGroup.DataBind();


        }
    }

    protected void btnsave_Click1(object sender, EventArgs e)
    {
        modalAccountSubGroup info = new modalAccountSubGroup();
        RestrOrderController con = new RestrOrderController();
        info.Name = txtName.Text;
        info.Code = txtCode.Text;
        
        info.AccountGroupId = Convert.ToInt32(ddlAccountGroup.SelectedItem.Value);

        con.AccountSubGroupSaveTodatabase(info);
        BindGrid();
        Response.Write("<script>jAlert('Record saved successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");

    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        tbl1.Visible = true;
        btnadd.Visible = false;
        btncancel.Visible = true;
        Response.Write("<script></script>");
        //ImgPrvs.Attributes.Add("style", "display:none");

    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        tbl1.Visible = false;
        btncancel.Visible = false;
        btnadd.Visible = true;
        ddlAccountGroup.SelectedIndex = 0;
        txtCode.Text = "";
        txtName.Text = "";
        

    }
}