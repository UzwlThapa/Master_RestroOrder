using iTextSharp.text;
using iTextSharp.text.pdf;
using Microsoft.Reporting.WebForms;
using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class Modules_ROBilling_KitchenReportViewer : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRoom();
            BindDropDown();
            ReportViewer2.Visible = false;
            LoadReport();
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
        ddlRoom.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }
    public void BindDropDown()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestrOrderInfo> tableList = new List<RestrOrderInfo>();
        tableList = roc.GetTableName();
        ddlBillingOrder.DataSource = tableList;
        ddlBillingOrder.DataTextField = "TableId";
        ddlBillingOrder.DataValueField = "TableId";
        ddlBillingOrder.DataBind();
        ddlBillingOrder.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }


    protected void ddlRoom_SelectedIndexChanged(object sender, EventArgs e)
    {
        ReportViewer2.Visible = false;
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> tableList = new List<restroTable>();

        int roomId = Convert.ToInt32(ddlRoom.SelectedItem.Value);
        tableList = roc.GetTableByRoomId(roomId);

        ddlBillingOrder.DataSource = tableList;
        ddlBillingOrder.DataTextField = "restrotableTitle";
        ddlBillingOrder.DataValueField = "restrotableId";
        ddlBillingOrder.DataBind();
        ddlBillingOrder.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));
    }
    protected void ddlBillingOrder_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        ReportViewer2.Visible = true;
        OrderMasterClass orderMaster = new OrderMasterClass();
        RestrOrderController rocobj = new RestrOrderController();
        orderMaster = rocobj.GetOrderDetailsFromDatabase(ddlBillingOrder.SelectedItem.Value);
        if (orderMaster == null)
        {
            //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "NO Order Avilable From This Table");
            Response.Write("<script>jAlert('Order for Select Table is empty', 'Alert!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        else if (orderMaster.IsSplit == false)
        {
            LoadReport();
        }
        
        //RestrOrderController roc = new RestrOrderController();
        //string tableId = ddlBillingOrder.SelectedValue.ToString();
        //OrderMasterClass orderMaster = roc.GetOrderDetailsFromDatabase(tableId);
        ////List<OrderMasterClass> orderMasterQuery = orderMasterList.Where(p => p.Date.Day.ToString() == DateTime.Now.Day.ToString()).ToList();
        //StringBuilder sb = new StringBuilder();
        //List<OrderDetailClass> orderDetailList = roc.GetOrderDetailsByMaster(orderMaster.OrderMasterID);
        //    // orderMaster.OrderDetailsList;
    }
    private void LoadReport()
    {
        try
        {
            ReportParameter p7 = new ReportParameter("Date", DateTime.Now.ToString("dd/MM/yyyy"));
            ReportParameter p8 = new ReportParameter("Time", DateTime.Now.ToString("hh:mm"));

            this.ReportViewer2.LocalReport.SetParameters(new ReportParameter[] { p7, p8 });

            string restroOrderID = (String.IsNullOrEmpty(ddlBillingOrder.SelectedValue)) ? "3A" : ddlBillingOrder.SelectedValue.ToString();

            RestroDataSet.USP_RO_GETORDERMASTERDataTable dt = new RestroDataSet.USP_RO_GETORDERMASTERDataTable();
            RestroDataSetTableAdapters.USP_RO_GETORDERMASTERTableAdapter ta = new RestroDataSetTableAdapters.USP_RO_GETORDERMASTERTableAdapter();

            ta.Fill(dt, restroOrderID);

            //for kitchen
            ReportDataSource rd = new ReportDataSource();
            rd.Name = "KitchenDataSet";
            rd.Value = dt;

            //kitchen
            ReportViewer2.LocalReport.DataSources.Clear();
            ReportViewer2.LocalReport.DataSources.Add(rd);
            ReportViewer2.LocalReport.Refresh();

        }
        catch (Exception es)
        {
            throw es;
        }
    }


    //Kitchen Print

    protected void btnKitchenPrint_Click(object sender, ImageClickEventArgs e)
    {

        Warning[] warnings;
        string[] streamids;
        string mimeType;
        string encoding;
        string extension;



        byte[] bytes = ReportViewer2.LocalReport.Render("PDF", null, out mimeType,
                       out encoding, out extension, out streamids, out warnings);

        FileStream fs = new FileStream(HttpContext.Current.Server.MapPath("Modules/ROBilling/KitchenReport/output_" + ddlBillingOrder.SelectedItem.Text + ".pdf"), FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();

        //Open existing PDF
        Document document = new Document(PageSize.LETTER);

        PdfReader reader = new PdfReader(HttpContext.Current.Server.MapPath("Modules/ROBilling/KitchenReport/output_" + ddlBillingOrder.SelectedItem.Text + ".pdf"));

        //Getting a instance of new PDF writer
        //PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(
        //   HttpContext.Current.Server.MapPath("Modules/ROBilling/FilesReport/Print_" + ddlBillingOrder.SelectedItem.Text + ".pdf"), FileMode.Create));

        PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(
               HttpContext.Current.Server.MapPath("Modules/ROBilling/KitchenReport/Print_" + ddlBillingOrder.SelectedItem.Text + ".pdf"), FileMode.Create));
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
        frmPrint.Attributes["src"] = "KitchenReport/Print_" + ddlBillingOrder.SelectedItem.Text  + ".pdf";

    }
}