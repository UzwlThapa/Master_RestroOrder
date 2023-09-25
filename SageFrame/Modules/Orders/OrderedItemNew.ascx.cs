using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
//using SageFrame.CostCenter;




public partial class Modules_Order_OrderedItemNew : BaseUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;



    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        BindToGrid();

      
    }

    public void BindToGrid()
    {

        RestrOrderController roc = new RestrOrderController();
        //List<OrderMasterClass> orderMasterList = roc.GetAllOrder().Where(p => p.Date.Date == DateTime.Now.Date).ToList();
        List<OrderMasterClass> orderMasterList = roc.GetAllOrder().ToList();
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
}