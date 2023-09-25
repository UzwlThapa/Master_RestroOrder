using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;

public partial class Modules_ROI_temRate_ROItemRate :BaseUserControl
{

    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public static int items = 0;
    public string username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("ROUnit", "/Modules/ROI_Item/Scripts/ItemScript.js");
        IncludeJs("ROUnit", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("ROUnit", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");

        username = GetUsername;
        BindGrid();
        BindDropdownList1();
        BindItem();
        //MakeGridViewPrinterFriendly(gvItemRate);
    }
    protected void saveItem_Click(object sender, EventArgs e)
    {
        itemRate info = new itemRate();
        RestrOrderController con = new RestrOrderController();
        info.ItemRateID = items;
        info.ItemID = Convert.ToInt32(HiddenParentItem.Value);
        info.UnitID = Convert.ToInt32(MunitHideen.Value);
        info.PRate = Convert.ToDecimal(pritemrate.Text);
        info.SRate = Convert.ToDecimal(sritemrate.Text);
        info.ValidFrom = Convert.ToDateTime(Vitemrate.Text);
        info.PostedBy = GetUsername;
        con.SaveItemRate(info);
        items = 0;
        BindGrid();
        resetall();

    }
    public void resetall()
    {
        dditemrate1.Text = "";
        dditemrate2.Text = "";
        pritemrate.Text = "";
        sritemrate.Text = "";
        Vitemrate.Text = "";

    }
    protected void reset_Click(object sender, EventArgs e)
    {
       resetall();
    }
   
    public void BindDropdownList1()
    {
        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetAllUnitforItem();
        dditemrate2.DataSource = currencyList;
        dditemrate2.DataTextField = "Particulars";
        dditemrate2.DataValueField = "UnitId";
        dditemrate2.DataBind();
        dditemrate2.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }

    public void BindItem()
    {

        RestrOrderController roc = new RestrOrderController();
        List<unitclassforitem> currencyList = roc.GetPareintItem();

        dditemrate1.DataSource = currencyList;
        dditemrate1.DataTextField = "ITName";
        dditemrate1.DataValueField = "ITId";
        dditemrate1.DataBind();
        dditemrate1.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }

    private void BindGrid()
    {
        List<itemRate> info1 = new List<itemRate>();
        RestrOrderController con = new RestrOrderController();
        info1 = con.GetItemRateList();
        gvItemRate.DataSource = info1;
        gvItemRate.DataBind();
    }

    protected void gvItemRate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditItem")
        {
            
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            items = Convert.ToInt32(gvItemRate.DataKeys[grdrow.RowIndex].Values["ItemRateID"].ToString());
            itemRate info1 = new itemRate();
            //List<itemRate> info1 = new List<itemRate>();
            RestrOrderController con = new RestrOrderController();
            info1 = con.GetItemRateList().Where(p => p.ItemRateID == items).FirstOrDefault();  
            dditemrate1.SelectedValue = Convert.ToString(info1.ItemID);
            dditemrate2.SelectedValue = Convert.ToString(info1.UnitID);
            sritemrate.Text=Convert.ToString(info1.SRate);
            pritemrate.Text = Convert.ToString(info1.PRate);
            Vitemrate.Text = Convert.ToString(info1.Validfroms);
            HiddenParentItem.Value = Convert.ToString(info1.ItemRateID);
            MunitHideen.Value = Convert.ToString(info1.UnitID);
        }
        else if (e.CommandName == "DeleteItem")
        {
        
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int Itemid = Convert.ToInt32(gvItemRate.DataKeys[grdrow.RowIndex].Values["ItemRateID"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.DeleteItemRate(Itemid);
            Response.Write("<script>jAlert('Deleted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            BindGrid();
        
        }
    }
    private void MakeGridViewPrinterFriendly(GridView gridView)
    {
        if (gridView.Rows.Count > 0)
        {
            gridView.UseAccessibleHeader = true;
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }

   
    protected void gvItemRate_RowCreated(object sender, GridViewRowEventArgs e)
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







