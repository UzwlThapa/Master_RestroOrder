using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using Microsoft.Reporting.WebForms;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using SageFrame.Web;
public partial class Modules_ROBilling_ROReportViewer : BaseAdministrationUserControl
{
    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRoom();
            BindDropDown();
            ReportViewer1.Visible = false;
            LoadReport();
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //ReportViewer1.Visibility = false;
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
        ddlRoom.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }

    public void BindDropDown()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestrOrderInfo> tableList = new List<RestrOrderInfo>();
        tableList = roc.GetTableName();
        //tableList.Insert(0, new RestrOrderInfo { TableId = "-Select-", TableId = 0 });
        ddlBillingOrder.DataSource = tableList;
        ddlBillingOrder.DataTextField = "TableId";
        ddlBillingOrder.DataValueField = "TableId";
        ddlBillingOrder.DataBind();
        ddlBillingOrder.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }


    protected void ddlRoom_SelectedIndexChanged(object sender, EventArgs e)
    {
        ReportViewer1.Visible = false;
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> tableList = new List<restroTable>();

        int roomId = Convert.ToInt32(ddlRoom.SelectedItem.Value);
        tableList = roc.GetTableByRoomId(roomId);

        ddlBillingOrder.DataSource = tableList;
        ddlBillingOrder.DataTextField = "restrotableTitle";
        ddlBillingOrder.DataValueField = "restrotableTitle";
        ddlBillingOrder.DataBind();
        ddlBillingOrder.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));
    }
    protected void ddlBillingOrder_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        ReportViewer1.Visible = true;
        OrderMasterClass orderMaster = new OrderMasterClass();
        RestrOrderController rocobj = new RestrOrderController();
        orderMaster = rocobj.GetOrderDetailsFromDatabase(ddlBillingOrder.SelectedItem.Value);
        if(orderMaster == null)
        {
            //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "NO Order Avilable From This Table");
            Response.Write("<script>jAlert('Order for Select Table is empty', 'Alert!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        else if (orderMaster.IsSplit == false)
        {
            LoadReport();
            pnlSeatNumber.Visible = false;
        }
          
        else
        {
            List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMaster.OrderMasterID);
            pnlSeatNumber.Visible = true;
            List<int> arr1 = new List<int>();
            foreach(OrderDetailClass order in orderList)
            {
                arr1.Add(order.SeatNo);
                
            }
            arr1 =   arr1.Distinct().ToList();
            arr1.Sort();
            ddlSeatNumber.DataSource = arr1;
            //ddlSeatNumber.DataTextField = "TableId";
            //ddlSeatNumber.DataValueField = "TableId";
            ddlSeatNumber.DataBind();
            ddlSeatNumber.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

        }

    }
    private void LoadReport()
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            companyInfo company = roc.getcompany();
            decimal amount = 0;
            //decimal termamount = 0;
            string inWord;
            //exernal data

            int seatNo = (String.IsNullOrEmpty(ddlSeatNumber.SelectedValue)) ? 0 : Convert.ToInt32(ddlSeatNumber.SelectedItem.Value);
            string restroOrderID = (String.IsNullOrEmpty(ddlBillingOrder.SelectedValue)) ? "1" : ddlBillingOrder.SelectedValue.ToString();

            OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(restroOrderID);
            if (orderMaster.IsSplit == true)
            {
                List<OrderDetailClass> orderDetail = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID);

                foreach (OrderDetailClass order in orderDetail)
                {
                    if (order.SeatNo == seatNo)
                    {
                        amount += order.Amount;
                    }
                }
            }
            else
            {
                amount = orderMaster.BasicAmount;
            }
            CurrencyClass curencyinfo = roc.GetCurrencyBYId(company.CurrencyID);
            decimal netamount = roc.GetnetAmount(amount);
            inWord = roc.GetInWord(netamount, curencyinfo.CurrencyName, curencyinfo.SubCurrencyName);

            string priceIcon = curencyinfo.CurrencyIcon;

            ReportParameter p1 = new ReportParameter("param1", company.Name);
            ReportParameter p2 = new ReportParameter("param2", company.Address);
            ReportParameter p3 = new ReportParameter("param3", company.PhoneNo);
            ReportParameter p4 = new ReportParameter("param4", company.PAN);
            ReportParameter p5 = new ReportParameter("inword", inWord);
            ReportParameter p6 = new ReportParameter("amount", Convert.ToString(amount));
            ReportParameter p7 = new ReportParameter("Date", DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter p8 = new ReportParameter("Time", DateTime.Now.ToString("hh:mm"));
            ReportParameter p9 = new ReportParameter("PriceIcon", priceIcon);
            this.ReportViewer1.LocalReport.SetParameters(new ReportParameter[] { p1, p2, p3, p4, p5, p6, p7, p8, p9 });

            //restro
            RestroSplitDataSet.USP_RO_GETORDERMASTERFORSPLITDataTable dt = new RestroSplitDataSet.USP_RO_GETORDERMASTERFORSPLITDataTable();
            RestroSplitDataSetTableAdapters.USP_RO_GETORDERMASTERFORSPLITTableAdapter ta = new RestroSplitDataSetTableAdapters.USP_RO_GETORDERMASTERFORSPLITTableAdapter();
            ta.Fill(dt, restroOrderID, seatNo);

            //Bill Term
            RestroSplitDataSet.USP_RO_BILLTERMDataTable dt1 = new RestroSplitDataSet.USP_RO_BILLTERMDataTable();
            RestroSplitDataSetTableAdapters.USP_RO_BILLTERMTableAdapter ta1 = new RestroSplitDataSetTableAdapters.USP_RO_BILLTERMTableAdapter();
            
            ta1.Fill(dt1, amount);




            ReportDataSource rd1 = new ReportDataSource();
            rd1.Name = "RestrSplitDataSet";
            rd1.Value = dt;

            ReportDataSource rd2 = new ReportDataSource();
            rd2.Name = "BillTermDataSet";
            rd2.Value = dt1; 

            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.DataSources.Add(rd1);
                ReportViewer1.LocalReport.DataSources.Add(rd2);
            ReportViewer1.LocalReport.Refresh();

        }
        catch (Exception es)
        {
            throw es;
        }
    }


    protected void btnPrint_Click(object sender, ImageClickEventArgs e)
    {
       
        Warning[] warnings;
        string[] streamids;
        string mimeType;
        string encoding;
        string extension;
        decimal amount =0;
     

        //exernal data
        int seatNo = (String.IsNullOrEmpty(ddlSeatNumber.SelectedValue)) ? 0 : Convert.ToInt32(ddlSeatNumber.SelectedItem.Value);
        RestrOrderController roc = new RestrOrderController();

        String tableId = (String.IsNullOrEmpty(ddlBillingOrder.SelectedValue)) ? "1" : ddlBillingOrder.SelectedValue.ToString();
        OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(tableId);
        List<OrderDetailClass> orderDetail = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID);
        if (orderMaster.IsSplit==true)
        {
            foreach (OrderDetailClass order in orderDetail)
            {
                if (order.SeatNo == seatNo)
                {
                    amount = order.Amount + order.ExtraCharge;
                    order.BillPaid = 1;
                    //order.NetAmount = roc.GetnetAmount(amount);
                }
            }
            
        }
        else
        {
            amount = orderMaster.BasicAmount;
            decimal extracharge =0;
            foreach(OrderDetailClass orderclass in orderDetail)
            {
                extracharge = extracharge + orderclass.ExtraCharge;
            }
            amount = orderMaster.BasicAmount + extracharge;
          
        }
            orderMaster.BillPaid = 1;
            orderMaster.NetAmount = roc.GetnetAmount(amount);
            orderMaster.OrderDetailsList = orderDetail;
            roc.OrderMasterSaveTodatabase(orderMaster);


      //  inWord = roc.GetInWord(amount);
         

        byte[] bytes = ReportViewer1.LocalReport.Render("PDF", null, out mimeType,
                       out encoding, out extension, out streamids, out warnings);

        FileStream fs = new FileStream(HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/output_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf"), FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();

        //Open existing PDF
        Document document = new Document(PageSize.LETTER);

        PdfReader reader = new PdfReader(HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/output_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf"));

        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(
               HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/Print_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf"), FileMode.Create));
        document.Open();

        PdfContentByte cb = writer.DirectContent;

        int i = 0;
        int p = 0;
        int n = reader.NumberOfPages;
        Rectangle psize = reader.GetPageSize(1);

        float width = psize.Width;
        float height = psize.Height;

        //Add Page to new document
        while (i < n)
        {
            document.NewPage();
            p++;
            i++;

            PdfImportedPage page1 = writer.GetImportedPage(reader, i);
            cb.AddTemplate(page1, 0, 0);
        }


        //Attach javascript to the document
        PdfAction jAction = PdfAction.JavaScript("this.print(true);\r", writer);
        writer.AddJavaScript(jAction);

        document.Close();

        //Attach pdf to the iframe
        frmPrint.Attributes["src"] = "FilesReport/Print_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf";

    }


    protected void ddlSeatNumber_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            ReportViewer1.Visible = true;
            LoadReport();
        }
        catch (Exception es)
        {
            throw es;
        }
    }
    protected void btnAllReport_Click(object sender, EventArgs e)
    {
        RestrOrderController rocobj = new RestrOrderController();

        string restroOrderID = (String.IsNullOrEmpty(ddlBillingOrder.SelectedValue)) ? "1" : ddlBillingOrder.SelectedValue.ToString();

        OrderMasterClass orderMaster = rocobj.GetOrderDetailsFromDatabase(restroOrderID);
        List<OrderDetailClass> orderList = rocobj.GetOrderDetailsByMaster(orderMaster.OrderMasterID);
        List<int> arr1 = new List<int>();
        foreach (OrderDetailClass order in orderList)
        {
            arr1.Add(order.SeatNo);
            PrintALlReport(order.SeatNo);
        }
        arr1 = arr1.Distinct().ToList();
        arr1.Sort();

        
    }



    private void PrintALlReport(int seatNo)
    {
        try
        {
            RestrOrderController roc = new RestrOrderController();
            companyInfo company = roc.getcompany();
            decimal amount = 0;
            //decimal termamount = 0;
            string inWord;
            //exernal data

            //int seatNo = (String.IsNullOrEmpty(ddlSeatNumber.SelectedValue)) ? 0 : Convert.ToInt32(ddlSeatNumber.SelectedItem.Value);
            string restroOrderID = (String.IsNullOrEmpty(ddlBillingOrder.SelectedValue)) ? "1" : ddlBillingOrder.SelectedValue.ToString();

            OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(restroOrderID);
            if (orderMaster.IsSplit == true)
            {
                List<OrderDetailClass> orderDetail = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID);

                foreach (OrderDetailClass order in orderDetail)
                {
                    if (order.SeatNo == seatNo)
                    {
                        amount += order.Amount;
                    }
                }
            }
            else
            {
                amount = orderMaster.BasicAmount;
            }
            CurrencyClass curencyinfo = roc.GetCurrencyBYId(company.CurrencyID);
            decimal netamount = roc.GetnetAmount(amount);
            inWord = roc.GetInWord(netamount, curencyinfo.CurrencyName, curencyinfo.SubCurrencyName);


            ReportParameter p1 = new ReportParameter("param1", company.Name);
            ReportParameter p2 = new ReportParameter("param2", company.Address);
            ReportParameter p3 = new ReportParameter("param3", company.PhoneNo);
            ReportParameter p4 = new ReportParameter("param4", company.PAN);
            ReportParameter p5 = new ReportParameter("inword", inWord);
            ReportParameter p6 = new ReportParameter("amount", Convert.ToString(amount));
            ReportParameter p7 = new ReportParameter("Date", DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter p8 = new ReportParameter("Time", DateTime.Now.ToString("hh:mm"));

            this.ReportViewer1.LocalReport.SetParameters(new ReportParameter[] { p1, p2, p3, p4, p5, p6, p7, p8 });

            //restro
            RestroSplitDataSet.USP_RO_GETORDERMASTERFORSPLITDataTable dt = new RestroSplitDataSet.USP_RO_GETORDERMASTERFORSPLITDataTable();
            RestroSplitDataSetTableAdapters.USP_RO_GETORDERMASTERFORSPLITTableAdapter ta = new RestroSplitDataSetTableAdapters.USP_RO_GETORDERMASTERFORSPLITTableAdapter();
            ta.Fill(dt, restroOrderID, seatNo);

            //Bill Term
            RestroSplitDataSet.USP_RO_BILLTERMDataTable dt1 = new RestroSplitDataSet.USP_RO_BILLTERMDataTable();
            RestroSplitDataSetTableAdapters.USP_RO_BILLTERMTableAdapter ta1 = new RestroSplitDataSetTableAdapters.USP_RO_BILLTERMTableAdapter();
            
            ta1.Fill(dt1, amount);




            ReportDataSource rd1 = new ReportDataSource();
            rd1.Name = "RestrSplitDataSet";
            rd1.Value = dt;

            ReportDataSource rd2 = new ReportDataSource();
            rd2.Name = "BillTermDataSet";
            rd2.Value = dt1;

            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.DataSources.Add(rd1);
                ReportViewer1.LocalReport.DataSources.Add(rd2);
            ReportViewer1.LocalReport.Refresh();
            Print(seatNo);

         
            

        }
        catch (Exception es)
        {
            throw es;
        }
    }

    private void Print(int seatNo)
    {
        Warning[] warnings;
        string[] streamids;
        string mimeType;
        string encoding;
        string extension;
        decimal amount = 0;


        //exernal data
        //int seatNo = (String.IsNullOrEmpty(ddlSeatNumber.SelectedValue)) ? 0 : Convert.ToInt32(ddlSeatNumber.SelectedItem.Value);
        RestrOrderController roc = new RestrOrderController();

        String tableId = (String.IsNullOrEmpty(ddlBillingOrder.SelectedValue)) ? "1" : ddlBillingOrder.SelectedValue.ToString();
        OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(tableId);
        List<OrderDetailClass> orderDetail = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID);
        if (orderMaster.IsSplit == true)
        {
            foreach (OrderDetailClass order in orderDetail)
            {
                if (order.SeatNo == seatNo)
                {
                    amount = order.Amount + order.ExtraCharge;
                    order.BillPaid = 1;
                    //order.NetAmount = roc.GetnetAmount(amount);
                }
            }

        }
        else
        {
            amount = orderMaster.BasicAmount;
            decimal extracharge = 0;
            foreach (OrderDetailClass orderclass in orderDetail)
            {
                extracharge = extracharge + orderclass.ExtraCharge;
            }
            amount = orderMaster.BasicAmount + extracharge;
            //orderMaster.BillPaid = 1;
            //orderMaster.NetAmount = roc.GetnetAmount(amount);
            //roc.OrderMasterSaveTodatabase(orderMaster);
        }
        orderMaster.BillPaid = 1;
        orderMaster.NetAmount = roc.GetnetAmount(amount);
        orderMaster.OrderDetailsList = orderDetail;
        roc.OrderMasterSaveTodatabase(orderMaster);


        //  inWord = roc.GetInWord(amount);


        byte[] bytes = ReportViewer1.LocalReport.Render("PDF", null, out mimeType,
                       out encoding, out extension, out streamids, out warnings);

        FileStream fs = new FileStream(HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/output_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf"), FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();

        //Open existing PDF
        Document document = new Document(PageSize.LETTER);

        PdfReader reader = new PdfReader(HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/output_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf"));

        //Getting a instance of new PDF writer
        //PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(
        //   HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/Print_" + ddlBillingOrder.SelectedItem.Text + ".pdf"), FileMode.Create));

        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(
               HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/Print_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf"), FileMode.Create));
        document.Open();

        PdfContentByte cb = writer.DirectContent;

        int i = 0;
        int p = 0;
        int n = reader.NumberOfPages;
        Rectangle psize = reader.GetPageSize(1);

        float width = psize.Width;
        float height = psize.Height;

        //Add Page to new document
        while (i < n)
        {
            document.NewPage();
            p++;
            i++;

            PdfImportedPage page1 = writer.GetImportedPage(reader, i);
            cb.AddTemplate(page1, 0, 0);
        }



        //Attach javascript to the document
        PdfAction jAction = PdfAction.JavaScript("this.print(true);\r", writer);
        writer.AddJavaScript(jAction);




        //  Print
        //PdfAction action = new PdfAction(PdfAction.PRINTDIALOG);
        //writer.SetOpenAction(action);



        document.Close();

        //Attach pdf to the iframe
        frmPrint.Attributes["src"] = "FilesReport/Print_" + ddlBillingOrder.SelectedItem.Text + seatNo + DateTime.Now.ToString("yyyyMMddhhmm").Replace(":", "").Replace("/", "").Replace(" ", "-").Trim() + ".pdf";

        //if (orderMaster.IsSplit == false)
        //{
        //    orderMaster.BillPaid = 1;
        //    orderMaster.NetAmount = roc.GetnetAmount(orderMaster.BasicAmount);
        //    roc.OrderMasterSaveTodatabase(orderMaster);
        //}
        //else 
        //{
        //}
    }



   
}