using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using System.Data;
//using SageFrame.CostCenter;
using System.Configuration;


public partial class Modules_Order_OrderedItemNew : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string numpin = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        numpin = ConfigurationManager.AppSettings["NumPinPad"].ToString();
        IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui.css");
        IncludeJs("js", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("Css", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
          IncludeCss("RestroDashBoard", "/Modules/RestroDashboard/js/jquery-ui.css");
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        BindToGrid();
        MakeGridViewPrinterFriendly(gdvOrderItem);
    }

    public void BindToGrid()
    {

        //List<OrderMasterClass> orderMasterList = roc.GetAllOrder().Where(p => p.Date.Date == DateTime.Now.Date).ToList();
        RestrOrderController roc = new RestrOrderController();
        List<OrderMasterClass> orderMasterList = roc.GetAllOrder().Where(p=>p.Date.Date == DateTime.Today.Date).ToList();
        //orderMasterList.Parameters.AddWithValue("restroRoom", txtSearch.Text.Trim());
        gdvOrderItem.DataSource = orderMasterList;
        gdvOrderItem.DataBind();
    }

    
    protected void gdvOrderItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "PayBill")
        {
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gdvOrderItem.DataKeys[grdrow.RowIndex].Values["OrderMasterID"].ToString());
            RestrOrderController roc = new RestrOrderController();
            List<OrderMasterClass> orderMaster = roc.GetAllOrder();
            string TableId = null;
            foreach (OrderMasterClass order in orderMaster)
            {
                if (order.OrderMasterID == index)
                {
                    TableId = order.TableId;
                    break;
                }
            }

            Response.Redirect("~/Sales-Bill.aspx?ID=" + TableId);

            //Response.Redirect("~/CURRENT-ORDER.aspx?order=" + TableId);


        }
    }

    protected void gdvOrderItem_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gdvOrderItem.PageIndex = e.NewPageIndex;
        BindToGrid();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindToGrid();
    }


    //protected void OnDataBound(object sender, EventArgs e)
    //{
    //    GridViewRow row = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Normal);
    //    for (int i = 1; i < gdvOrderItem.Columns.Count-1; i++)
    //    {
    //        TableHeaderCell cell = new TableHeaderCell();
    //        TextBox txtSearch = new TextBox();
    //        txtSearch.Attributes["placeholder"] = gdvOrderItem.Columns[i].HeaderText;
    //        txtSearch.CssClass = "search_textbox";
    //        cell.Controls.Add(txtSearch);
    //        row.Controls.Add(cell);
    //    }
    //    gdvOrderItem.HeaderRow.Parent.Controls.AddAt(1, row);
    //}
    private void MakeGridViewPrinterFriendly(GridView gridView)
    {
        if (gridView.Rows.Count > 0)
        {
            gridView.UseAccessibleHeader = true;
            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
}