using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;

public partial class Modules_RestroTable_restroTable : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        if (!IsPostBack)
        {
            
            BindDropdownList();
            BindGrid();
            System.Text.StringBuilder message = new System.Text.StringBuilder();           
        }
        
        
        tbl1.Visible = false;

    }

    public void BindDropdownList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestroRoom> roomList = roc.getRestroRoom();
        ddlRoom.DataSource = roomList;
        RestroRoom ro = new RestroRoom();
        
        ddlRoom.DataTextField = "restroRoom";
        ddlRoom.DataValueField = "restroRoomId";
        ddlRoom.DataBind();
        ddlRoom.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        
        RestrOrderController con = new RestrOrderController();
        restroTable tbl = new restroTable();       
        tbl.restrotableId = (String.IsNullOrEmpty(hdfrestrotableid.Value)) ? 0 : int.Parse(hdfrestrotableid.Value);
        tbl.restroRoomId = (String.IsNullOrEmpty(ddlRoom.SelectedItem.Value)) ? 1 : int.Parse(ddlRoom.SelectedItem.Value);
        tbl.IsTable = chkTblRoom.Checked;
        tbl.restrotableTitle = txtTableName.Text;
        tbl.Rate = (String.IsNullOrEmpty(txtRate.Text)) ? 0 : Convert.ToDecimal(txtRate.Text);
        tbl.Seatcap = (String.IsNullOrEmpty(txtSeatNo.Text)) ? 0 : Convert.ToInt16(txtSeatNo.Text);
        con.saveTable(tbl);
        if (tbl.restrotableId == 0)
        {           
            
            Response.Write("<script>alert('Table added successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        
        }
        else
        {
           
           Response.Write("<script>alert('Table updated successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }
     
        BindGrid();
        tbl1.Visible = false;
        ddlRoom.SelectedIndex = 0;
        chkTblRoom.Checked = true;
        txtRate.Text = "";
        txtTableName.Text = "";
        hdfrestrotableid.Value = null;
        txtSeatNo.Text = "";
        btnadd.Visible = true;
         gdvRestroTable.Visible = true;
 
    }
    public void BindGrid()
    {
        List<restroTable> info1 = new List<restroTable>();
        RestrOrderController con = new RestrOrderController();
        info1 = con.getRestroTable();
        foreach (restroTable table in info1)
        {
            if (table.restroRoomId > 0)
            {
                RestrOrderController roc = new RestrOrderController();
                RestroRoom room = roc.getRestroRoomById(table.restroRoomId);
                table.restroRoom = room.restroRoom;
            }
            else 
            {
                table.restroRoom = "Open";
            }
        }
        //txtTableName.Text = null;
        gdvRestroTable.DataSource = info1;
        gdvRestroTable.DataBind();
    }


    protected void gdvRestroTable_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditUser")
        {
            restroTable tableinfo = new restroTable();
            RestrOrderController roc = new RestrOrderController();     
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gdvRestroTable.DataKeys[grdrow.RowIndex].Values["restrotableId"].ToString());
            tableinfo = roc.GetTableNoBYId(index);
          
            hdfrestrotableid.Value = tableinfo.restrotableId.ToString();
            if(tableinfo.restroRoomId > 0){
         
            ddlRoom.SelectedValue = Convert.ToString(tableinfo.restroRoomId); 
            }
            
            txtTableName.Text = tableinfo.restrotableTitle;
            chkTblRoom.Checked = tableinfo.IsTable;
            txtRate.Text = Convert.ToString(tableinfo.Rate);
            txtSeatNo.Text = Convert.ToString(tableinfo.Seatcap);
            tbl1.Visible = true;
            btnadd.Visible = false;
            gdvRestroTable.Visible = false;
         
        }
        else if (e.CommandName == "DeleteUser")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gdvRestroTable.DataKeys[grdrow.RowIndex].Values["restrotableId"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.deleteTable(empid);

            Response.Write("<script>alert('Record deleted successfully.', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            BindGrid();

       
            Response.Redirect(Request.RawUrl);
        }
      
    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        tbl1.Visible = true;
        btnadd.Visible = false;
         gdvRestroTable.Visible = false;
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        tbl1.Visible = false;
        txtTableName.Text = "";
        txtSeatNo.Text = "";
        hdfrestrotableid.Value = null;
        ddlRoom.SelectedIndex = 0;
     
        btnadd.Visible = true;
         gdvRestroTable.Visible = true;
    }
    protected void gdvRestroTable_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gdvRestroTable.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void ddlRoom_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
   


    protected void gdvRestroTable_RowCreated(object sender, GridViewRowEventArgs e)
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