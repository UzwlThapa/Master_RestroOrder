using System;
using System.Collections.Generic;
using SageFrame.RestroOrder;
using SageFrame.Web;

public partial class Modules_RoOrderItemProcessing_OrderItem : BaseUserControl
{
    public int costcenter = 0;
    public string costcenterRefreshInterval = System.Configuration.ConfigurationManager.AppSettings["costcenterRefreshInterval"];
    protected void Page_Load(object sender, EventArgs e)
    {
        litTitle.Text = this.Parent.Page.Title + " Order";
        IncludeCss("RestoItem", "/Modules/RestoItem/Script/dataTables.jqueryui.css", "/css/jquery.alerts.css");
        IncludeCss("Css", "/Modules/RoOrderItemProcessing/css/ItemProcessingStyle.css");
        IncludeJs("RestoItem", "/Modules/RestoItem/Script/jquery.dataTables.min.js");
        IncludeJs("Js", "/Modules/RoOrderItemProcessing/js/ItemProcessingScript.js");
        
      
      
        RestrOrderController roc = new RestrOrderController();
        List<costCenter> costcenterlist = roc.getcostcenter();
        string sPagePath = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
        System.IO.FileInfo oFileInfo = new System.IO.FileInfo(sPagePath);
        string sPageName = oFileInfo.Name;
        string[] data = sPageName.Split('.');
        foreach (costCenter item in costcenterlist)
           {
            if(item.CostCenterName.ToLower() == data[0].ToLower())
            {
                costcenter = item.CostCenterID;
            }
            
        }


        //BindGrid();
        
    }

  
//    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
//    {
//        if (e.CommandName == "inprocess")
//        {
//            int StatusID = 2;
//            LinkButton lnkBtn = (LinkButton)e.CommandSource;    // the button
//            GridViewRow myRow = (GridViewRow)lnkBtn.Parent.Parent;  // the row
//            GridView myGrid = (GridView)sender; // the gridview
//            string ItemID = myGrid.DataKeys[myRow.RowIndex].Value.ToString();
//            List<OrderDetailClass> list = new List<OrderDetailClass>();
//            RestrOrderController con = new RestrOrderController();
//            list = con.inprocess(int.Parse(ItemID), StatusID);

//            List<OrderDetailClass> rtinfo = new List<OrderDetailClass>();
//            RestrOrderController rec = new RestrOrderController();
//            rtinfo = rec.getitemprocessing(costcenter);
//            GridView1.DataSource = rtinfo;
//            GridView1.DataBind();
            
//        }
//        else if (e.CommandName == "complete")
//        {
//            int StatusID = 3;
//            LinkButton lnkBtn = (LinkButton)e.CommandSource;    // the button
//            GridViewRow myRow = (GridViewRow)lnkBtn.Parent.Parent;  // the row
//            GridView myGrid = (GridView)sender; // the gridview
//            string ItemID = myGrid.DataKeys[myRow.RowIndex].Value.ToString();
//            List<OrderDetailClass> list = new List<OrderDetailClass>();
//            RestrOrderController con = new RestrOrderController();
//            list = con.inprocess(int.Parse(ItemID), StatusID);

//            List<OrderDetailClass> rtinfo = new List<OrderDetailClass>();
//            RestrOrderController rec = new RestrOrderController();
//            rtinfo = rec.getitemprocessing(costcenter);
//            GridView1.DataSource = rtinfo;
//            GridView1.DataBind();
//        }
        
//    }

//    private void BindGrid()
//    {
//        List<OrderDetailClass> rtinfo = new List<OrderDetailClass>();
//        RestrOrderController rec = new RestrOrderController();
//        rtinfo = rec.getitemprocessing(costcenter);
//        GridView1.DataSource = rtinfo;
//        GridView1.DataBind();
//    }
//    private void MakeGridViewPrinterFriendly(GridView gridView)
//    {
//        if (gridView.Rows.Count > 0)
//        {
//            gridView.UseAccessibleHeader = true;
//            gridView.HeaderRow.TableSection = TableRowSection.TableHeader;
//        }
//    }
//    protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
//    {
//        if (e.Row.RowType == DataControlRowType.Header)
//        {
//            e.Row.TableSection = TableRowSection.TableHeader;
//        }

//        if (e.Row.RowType == DataControlRowType.DataRow)
//        {
//            e.Row.TableSection = TableRowSection.TableBody;
//        }

//        if (e.Row.RowType == DataControlRowType.Footer)
//        {
//            e.Row.TableSection = TableRowSection.TableFooter;
//        }
//    }
}