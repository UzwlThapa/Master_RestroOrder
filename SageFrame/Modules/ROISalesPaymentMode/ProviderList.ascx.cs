using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using SageFrame.Web;
public partial class Modules_ROISalesPaymentMode_ProviderList : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);

      //  IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");
     
        if (!Page.IsPostBack)
        {
            BindGrid();
            tblProviderList.Visible = false;
            ResetAll();
        }
    }

    private void ResetAll()
    {
        txtProvider.Text = "";
        txtDescription.Text = "";
        editablevalue.Value =null;
    }

    private void BindGrid()
    {
        List<CardProvider> cpinfo = new List<CardProvider>();
        RestrOrderController con = new RestrOrderController();
        cpinfo = con.getCardProvider();
        gdvProvider.DataSource = cpinfo;
        gdvProvider.DataBind();
    }
    protected void btnProviderSave_Click(object sender, EventArgs e)
    {
        
        RestrOrderController con = new RestrOrderController();
        CardProvider cp = new CardProvider();
        cp.ProviderID = (String.IsNullOrEmpty(editablevalue.Value)) ? 0 : Int32.Parse(editablevalue.Value);
        cp.ProviderName = txtProvider.Text;
        cp.Description = txtDescription.Text;
       
        con.saveCardProvider(cp);
        if (cp.ProviderID == 0)
        {
            Response.Write("<script>alert('Successfully Inserted', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        else
        {
            Response.Write("<script>alert('Successfully Updated', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }

        ResetAll();
        //gvRoomType.DataBind();
        BindGrid();
        tblProviderList.Visible = false;
        btnProviderAdd.Visible = true;
        gdvProvider.Visible = true;
        
    }
    protected void btnProviderSaveCancel_Click(object sender, EventArgs e)
    {
        tblProviderList.Visible = false;
        ResetAll();
        //lblFortxtTitle.Visible = false;
        btnProviderAdd.Visible = true;
        gdvProvider.Visible = true;
    }
    protected void gdvProvider_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "editProvider")
        {
            LinkButton lnkBtn = (LinkButton)e.CommandSource;    // the button
            GridViewRow myRow = (GridViewRow)lnkBtn.Parent.Parent;  // the row
            GridView myGrid = (GridView)sender; // the gridview
            string ID = myGrid.DataKeys[myRow.RowIndex].Value.ToString();
            editablevalue.Value = ID;
            CardProvider cpinfo = new CardProvider();
            RestrOrderController con = new RestrOrderController();
            cpinfo = con.getCardProviderById(int.Parse(ID));
            txtProvider.Text = cpinfo.ProviderName;
            txtDescription.Text = cpinfo.Description;
            tblProviderList.Visible = true;
            btnProviderAdd.Visible = false;
            gdvProvider.Visible = false;
            ////prevent Re-Post action caused by pressing browser's Refresh button
            //Response.Redirect(Request.RawUrl);
        }
        else if (e.CommandName == "DeleteProvider")
        {

            LinkButton lnkBtn = (LinkButton)e.CommandSource;    // the button
            GridViewRow myRow = (GridViewRow)lnkBtn.Parent.Parent;  // the row
            GridView myGrid = (GridView)sender; // the gridview
            string ID = myGrid.DataKeys[myRow.RowIndex].Value.ToString();
            RestrOrderController con = new RestrOrderController();
            con.deleteCardProvider(Convert.ToInt32(ID));

            Response.Write("<script> alert('Successfully Deleted', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            BindGrid();
            tblProviderList.Visible = false;

            ////prevent Re-Post action caused by pressing browser's Refresh button
            //Response.Redirect(Request.RawUrl);

        }
    }
    protected void btnProviderAdd_Click(object sender, EventArgs e)
    {
        tblProviderList.Visible = true;
        //pnlAdd.Visible = false;
        btnProviderAdd.Visible = false;
        gdvProvider.Visible = false;
    }
}