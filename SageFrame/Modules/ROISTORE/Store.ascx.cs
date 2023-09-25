using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
//using System.Data;
//using System.Data.SqlClient;

public partial class Modules_ROISTORE_Store : BaseAdministrationUserControl
{
    public static int empid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {

        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        //IncludeJs("ROUnit", "/Modules/ROI_Item/Scripts/ItemScript.js");
        IncludeJs("ROUnit", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        if (!IsPostBack)
        {
            BindGrid();
            BindDropdownList();
        }
        tablestore.Visible = false;
        btnadd.Visible = true;
        gvStore.Visible = true;
        //MakeGridViewPrinterFriendly(gvStore);
    }
    protected void saveStore_Click(object sender, EventArgs e)
    {
        RestrOrderController con = new RestrOrderController();
        roistore rc = new roistore();
        rc.STId = empid;
        rc.StName = txtStore.Text;
        if (hiddenStore.Value == "")
        {
            rc.PSTId = 0;
        }
        else
        {
            rc.PSTId = Convert.ToInt32(hiddenStore.Value);
        }
        if (rc.STId != rc.PSTId || rc.PSTId == 0)
        {
            con.savestore(rc, GetUsername);
            empid = 0;
            txtStore.Text = "";
            //ddlpst.Items.Clear();
            Response.Write("<script> alert('Successfully Inserted', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");

            //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "alert('Record saved successfully.'); document.location = 'http://192.168.1.239:8080//Admin/Roi-Store.aspx';", true);
            BindGrid();
            tablestore.Visible = false;
        }
        else {
            Response.Write("<script> alert('Store name and Parent Store Name can not be same', 'Alert!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "popup", "alert('Record saved successfully.'); window.location = 'Admin/Roi-Store.aspx';", true);
    }
    private void BindGrid()
    {
        List<roistore> info1 = new List<roistore>();
        RestrOrderController con = new RestrOrderController();
        info1 = con.getIssueToDDlHirerchy();
        gvStore.DataSource = info1;
        gvStore.DataBind();
        BindDropdownList();
    }
    public void BindDropdownList()
    {
        //int WithdrawalTotal = 0;
        //int counter;


        //// Iterate through all the rows and sum up the appropriate columns.
        //for (counter = 0; counter < (gvStore.Rows.Count);
        //    counter++)
        //{
        //    if (gvStore.Rows[counter].Cells[int.Parse("STId")].Value != null)
        //    {
        //        if (gvStore.Rows[counter].
        //            Cells[int.Parse("STId")].Value.ToString().Length != 0)
        //        {
        //            WithdrawalTotal += int.Parse(gvStore.Rows[counter].
        //                Cells["STId"].Value.ToString());
        //        }
        //    }
        //}
        //// Set the labels to reflect the current state of the DataGridView.
        //lblDes.Text = "Total: " + WithdrawalTotal.ToString();

        RestrOrderController roc = new RestrOrderController();
        List<roistore> currencyList = roc.getIssueToDDlHirerchy();
        ddlpst.DataSource = currencyList;
        ddlpst.DataTextField = "PName";
        ddlpst.DataValueField = "STId";
        ddlpst.DataBind();
        ddlpst.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Root", string.Empty));
    }
    protected void gvStore_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "editStore")
        {
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            empid = Convert.ToInt32(gvStore.DataKeys[grdrow.RowIndex].Values["STId"].ToString());


            List<roistore> info1 = new List<roistore>();
            RestrOrderController con = new RestrOrderController();
            //info1 = con.getIssueToDDl();
             tablestore.Visible = true;
             btnadd.Visible = false;
             gvStore.Visible = false;
            info1 = con.getIssueToDDl().Where(p => p.STId == empid).ToList();
            txtStore.Text = info1[0].StName;
            if (info1[0].PSTId == 0)
            {

            }
            else
            {
                ddlpst.SelectedValue = Convert.ToString(info1[0].PSTId);
            }

        }

        else if (e.CommandName == "storeDelete")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gvStore.DataKeys[grdrow.RowIndex].Values["STId"].ToString());
            RestrOrderController con = new RestrOrderController();
            string message = con.deleteStore(empid, GetUsername);
            Response.Write("<script> alert('" + message + "', 'Alert!!', function () { $.alerts.dialogClass = null; });</script>");
            BindGrid();
        }
    }

     public void btnadd_Click(object sender, EventArgs e)
    {
        tablestore.Visible = true;
        btnadd.Visible = false;
         gvStore.Visible = false;
    }

     protected void btncancel_Click(object sender, EventArgs e)
    {
        tablestore.Visible = false;
        btnadd.Visible = true;
         gvStore.Visible = true;
    }

    private void MakeGridViewPrinterFriendly(GridView gridView)
    {
        if (gridView.Rows.Count > 0)
        {
            gridView.UseAccessibleHeader = true;
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    //protected void gvStore_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{
    //    gvStore.PageIndex = e.NewPageIndex;
    //    BindGrid();
    //}
    //protected void TextBox1_TextChanged(object sender, EventArgs e)
    //{
    //    GridView gv = new GridView();
    //    List<roistore> info1 = new List<roistore>();
    //    RestrOrderController con = new RestrOrderController();
    //    info1 = con.getIssueToDDl();


    //}

    protected void gvStore_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.TableSection = TableRowSection.TableHeader;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.TableSection = TableRowSection.TableBody;
        }

        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.TableSection = TableRowSection.TableFooter;
        }
    }
}