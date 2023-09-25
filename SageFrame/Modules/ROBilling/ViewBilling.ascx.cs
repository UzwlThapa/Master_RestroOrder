using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Web.UI.WebControls;
using System.Text;
using SageFrame.RestroOrder;


public partial class Modules_ROBilling_ViewBilling : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;

    //protected void Page_Init(object sender, EventArgs e)
    //{
    //    if (!IsPostBack)
    //    {
    //        BindDropDown();
    //    }
    //}
    protected void Page_Init(object sender, EventArgs e)
    {
       
        if (!IsPostBack)
        {
            //ddlBillingOrder.Items.Insert(0,new ListItem("Please Select One","0"));
            //ddlBillingOrder.Items.Add("Select");
            BindDropDown();
            BindRoom();
        }
    }

   
    public string TableId=null;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        BindTable();
        //if(!IsControlPostBack)
        //ltrBilling.Text = "<div> <h3> Select Table Number to Generate Billing Information </h3></div>";
        if (!IsPostBack)
        {
            string v = Request.QueryString["order"];
            if (v != null)
            {
                TableId = v;
                ddlBillingOrder.SelectedItem.Value = v;
                CheckBilling();
            }
        }
    }

    private void BindRoom()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestroRoom> rooomList = new List<RestroRoom>();
        rooomList = roc.getRestroRoom();
        ddlRoom.DataSource = rooomList;
        ddlRoom.DataTextField = "restroRoom";
        ddlRoom.DataValueField = "restroRoomId";
        ddlRoom.DataBind();
        ddlRoom.Items.Insert(0, new ListItem("Select", string.Empty));
      
    }

    public void BindDropDown()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestrOrderInfo> tableList= new List<RestrOrderInfo>();
        tableList= roc.GetTableName();
        ddlBillingOrder.DataSource = tableList;
        ddlBillingOrder.DataTextField = "TableId";
        ddlBillingOrder.DataValueField = "TableId";
        ddlBillingOrder.DataBind();
        ddlBillingOrder.Items.Insert(0, new ListItem("Select", string.Empty));
    }


    protected void ddlRoom_SelectedIndexChanged(object sender, EventArgs e)
    {
        trTable.Visible = true;
        ltrBilling.Visible = false;
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> tableList = new List<restroTable>();
        
       
        int roomId = Convert.ToInt32(ddlRoom.SelectedItem.Value);
        tableList = roc.GetTableByRoomId(roomId);
       
        ddlBillingOrder.DataSource = tableList;
        ddlBillingOrder.DataTextField = "restrotableTitle";
        ddlBillingOrder.DataValueField = "restrotableTitle";
        ddlBillingOrder.DataBind();
        ddlBillingOrder.Items.Insert(0, new ListItem("Select", string.Empty));
    }

    protected void ddlBillingOrder_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        ltrBilling.Visible = true;
        CheckBilling();

    }

    private void CheckBilling()
    {
        RestrOrderController roc = new RestrOrderController();
        string tableId = (TableId==null)? ddlBillingOrder.SelectedValue.ToString(): TableId;

        OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(tableId);

        if (orderMaster != null)
        {
            //List<OrderMasterClass> orderMasterQuery = orderMasterList.Where(p => p.Date.Day.ToString() == DateTime.Now.Day.ToString()).ToList();
            StringBuilder sb = new StringBuilder();
            List<OrderDetailClass> orderDetailList = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID); // orderMaster.OrderDetailsList;

            sb.Append("<table id='Ro-billing'><tr><td>");
            sb.Append("<label>Bill No:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.BillNo + "</item></td></tr><tr><td>");
            sb.Append("<label>Table No:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.TableId + "</item></td></tr><tr><td>");
            sb.Append("<label>Date and Time:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.Date.ToString(CultureInfo.InvariantCulture) + "</item></td></tr><tr><td>");
            sb.Append("<label>Basic Amount:</label></td><td>");
            sb.AppendFormat("<item type='text'>{0}</item></td></tr><tr><td>", orderMaster.BasicAmount.ToString());
            //sb.Append("<label>Term Amount:</label></td><td>");
            //sb.Append("<item type='text'>" +orderMaster.TermAmount + "</item></td></tr><tr><td>");
            //sb.Append("<label>Net Amount:</label></td><td>");
            //sb.Append("<item type='text'>" + orderMaster.NetAmount + "</item></td></tr><tr><td>");
            //sb.Append("<label>Remarks:</label></td><td>");
            //sb.Append("<item type='text'>" + orderMaster.Remarks + "</item></td></tr><tr><td>");
            sb.Append("<label>Split Bill:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.IsSplit + "</item></td></tr><tr><table>");
            sb.Append("");
            sb.Append("<tr><td colspan = \"4\" >");
            sb.Append("<table id='Ro-billing-tem-list'>");
            sb.Append("<tr>");
            sb.Append("<th>Item</th><th>Quantity</th><th>Rate</th><th>Amount</th><th>Seat No</th><tr/>");
            foreach (OrderDetailClass orderDetail in orderDetailList)
            {
                var detail = orderDetail;
                string itemname = "not mention";
                List<ItemsClass> itemsClassList = roc.GetItemFromDatabase();
                foreach (ItemsClass item in itemsClassList)
                {
                    if (item.ItemID == detail.ItemId)
                    {
                        itemname = item.ItemName;
                        break;
                    }
                }
                String seatno = (orderMaster.IsSplit == false) ? "Null" : Convert.ToString(orderDetail.SeatNo);
                sb.Append("<tr class='tableItem' id=" + orderDetail.OrderDetailsID + ">");
                sb.Append("<td>" + itemname + "</td>");
                sb.Append("<td>" + orderDetail.Quantity + "</td>");
                sb.Append("<td>" + orderDetail.Rate + "</td>");
                sb.Append("<td>" + orderDetail.Amount + "</td>");

                sb.Append("<td>" + seatno + "</td>");
                sb.Append("</tr>");
            }
            //sb.Append("<tr class='tableItem' id=" + orderDetail.OrderDetailID + ">");
            //sb.Append("<td> Total Price </td>");
            //sb.Append("</td>" +  + " </tr>");
            sb.Append("</table>");
            sb.Append("</td></tr>");
            sb.Append("</table>");

            ltrBilling.Text = sb.ToString();
        }
        else 
        {
            Response.Write("<script>alert('Order for Select Table is empty', 'Alert!!', function () { $.alerts.dialogClass = null; });</script>");
            ltrBilling.Text = "<i>Order for Select Table is empty</i>";
        }
    }

    public void BindTable()
    {
        RestrOrderController roc = new RestrOrderController();
        string tableId = ddlBillingOrder.SelectedValue.ToString();
        OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(tableId);
            //List<OrderMasterClass> orderMasterQuery = orderMasterList.Where(p => p.Date.Day.ToString() == DateTime.Now.Day.ToString()).ToList();
        StringBuilder sb = new StringBuilder();
        if (orderMaster != null)
        {
            List<OrderDetailClass> orderDetailList = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID); // orderMaster.OrderDetailsList;

            sb.Append("<table id='Ro-billing'><tr><td>");
            sb.Append("<label>Bill No:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.BillNo + "</item></td></tr><tr><td>");
            sb.Append("<label>Table No:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.TableId + "</item></td></tr><tr><td>");
            sb.Append("<label>Date and Time:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.Date.ToString(CultureInfo.InvariantCulture) + "</item></td></tr><tr><td>");
            sb.Append("<label>Basic Amount:</label></td><td>");
            sb.AppendFormat("<item type='text'>{0}</item></td></tr><tr><td>", orderMaster.BasicAmount.ToString());
            sb.Append("<label>Term Amount:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.TermAmount + "</item></td></tr><tr><td>");
            sb.Append("<label>Net Amount:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.NetAmount + "</item></td></tr><tr><td>");
            sb.Append("<label>Remarks:</label></td><td>");
            sb.Append("<item type='text'>" + orderMaster.Remarks + "</item></td></tr><tr><table>");
            sb.Append("");
            sb.Append("<tr><td colspan = \"4\" >");
            sb.Append("<table id='Ro-billing-tem-list'>");
            sb.Append("<tr>");
            sb.Append("<th>Item</th><th>Quantity</th><th>Rate</th><th>Amount</th><tr/>");
            foreach (OrderDetailClass orderDetail in orderDetailList)
            {
                var detail = orderDetail;
                string itemname = "not mention";
                List<ItemsClass> itemsClassList = roc.GetItemFromDatabase();
                foreach (ItemsClass item in itemsClassList)
                {
                    if (item.ItemID == detail.ItemId)
                    {
                        itemname = item.ItemName;
                        break;
                    }
                }
                sb.Append("<tr class='tableItem' id=" + orderDetail.OrderDetailsID + ">");
                sb.Append("<td>" + itemname + "</td>");
                sb.Append("<td>" + orderDetail.Quantity + "</td>");
                sb.Append("<td>" + orderDetail.Rate + "</td>");
                sb.Append("<td>" + orderDetail.Amount + "</td>");
                sb.Append("</tr>");
            }
            //sb.Append("<tr class='tableItem' id=" + orderDetail.OrderDetailID + ">");
            //sb.Append("<td> Total Price </td>");
            //sb.Append("</td>" +  + " </tr>");
            sb.Append("</table>");
            sb.Append("</td></tr>");
            sb.Append("</table>");

            ltrBilling.Text = sb.ToString();
        }
    }
   
}
