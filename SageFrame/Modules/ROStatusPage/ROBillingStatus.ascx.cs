using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Text;
using SageFrame.RestroOrder;


public partial class Modules_ROBilling_ViewBilling : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;



    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        //
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);

        IncludeCss("ROUnit", "/Modules/ROUnit/js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.dataTables.min.js");

        BindToGrid();

        //LoadOrderedItem();
    }

    private void BindToGrid()
    {
        RestrOrderController roc = new RestrOrderController();
        //string tableId = ddlBillingOrder.SelectedValue.ToString();
        List<OrderMasterClass> orderMasterList = roc.GetAllOrder().Where(p => p.Date.Date == DateTime.Now.Date).ToList();


        gdvOrderItem.DataSource = orderMasterList;
        gdvOrderItem.DataBind();
    }




    protected void LoadOrderedItem()
    {
        RestrOrderController roc = new RestrOrderController();
        //string tableId = ddlBillingOrder.SelectedValue.ToString();
        List<OrderMasterClass> orderMasterList = roc.GetAllOrder().Where(p => p.Date.Date == DateTime.Now.Date).ToList();

        //List<OrderMasterClass> orderMasterQuery = orderMasterList.Where(p => p.Date.Day.ToString() == DateTime.Now.Day.ToString()).ToList();
        StringBuilder sb = new StringBuilder();
        int i = 0;
        //List<OrderDetailClass> orderDetailList = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID); // orderMaster.OrderDetailsList;
        sb.Append("<table id='Ro-billing-tem-list'>");
        sb.Append("<tr>");
        sb.Append("<th>S.N.s</th><th>Order No</th><th>Table No</th><th>Date</th><th>Status</th><tr/>");
        foreach (OrderMasterClass orderMaster in orderMasterList)
        {
            i++;
            sb.Append("<tr><td><item type='text'>" + i + "</item></td>");
            string status = (orderMaster.BillPaid == 1) ? "Paid" : "UnPaid";
            sb.Append("<td><item type='text'>" + orderMaster.BillNo + "</item></td>");
            sb.Append("<td><item type='text'>" + orderMaster.TableId + "</item></td>");
            sb.Append("<td><item type='text'>" + orderMaster.Date.ToString(CultureInfo.InvariantCulture) + "</item></td>");
            sb.Append("<td><item type='text'>" + status + "</item></td></tr>");
        }

        sb.Append("</table>");
        //ltrBilling.Text = sb.ToString();

    }
    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        LoadOrderedItem();
    }
    protected void gdvOrderItem_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ViewOrder")
        {

            //int i = Convert.ToInt32(e.CommandArgument);
            ////GridViewRow row = gdvOrderItem.Rows[index];

            ////string value = row.Cells[1].Text;
            //string index = gdvOrderItem.Rows[i].Cells[1].Text;



                LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gdvOrderItem.DataKeys[grdrow.RowIndex].Values["OrderMasterID"].ToString());
            RestrOrderController roc = new RestrOrderController();
            List<OrderMasterClass> orderMaster = roc.GetAllOrder();
            string TableId = null;
            foreach(OrderMasterClass order in orderMaster)
            {
                if (order.OrderMasterID == index)
                {
                    TableId = order.TableId;
                    break;
                }
            }


            Response.Redirect("~/CURRENT-ORDER.aspx?order=" + TableId);

            //Response.Redirect("~/Sales-Bill.aspx?order=" + TableId);
///Sales-Bill.aspx?ID=33
            //table2.Visible = true;
            //btnadd.Visible = false;
        }
    }
}
