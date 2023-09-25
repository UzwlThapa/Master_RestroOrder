using System;
using System.Web;
using Microsoft.Reporting.WebForms;
using System.IO;

public partial class Modules_ROIGoodsReceive_GoodsReceivedRe : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IframeTermscondtion.Attributes["src"] = "about:blank";

        BothReportView();
        PurchaseMainPrint();
    }

    public void PurchaseMainPrint()
    {
        Warning[] warnings;
        string[] streamids;
        string mimeType;
        string encoding;
        string extension;
        string fullfilepath = string.Empty;
        string filepaths = string.Empty;
        int masterid = Convert.ToInt32(Request.QueryString["ID"].ToString());

        Byte[] bytes = ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamids, out warnings);
        filepaths = "/Modules/ROIGoodsReceive/GoodsReceiveReports/GoodsRecieve_" + DateTime.Now.ToString("yyyyMMddhhss") + "_" + masterid.ToString() + ".pdf";
        fullfilepath = HttpContext.Current.Server.MapPath(filepaths);
        bool exists = System.IO.File.Exists(fullfilepath);



        if (exists)
        {
            string filepath = fullfilepath;
            File.Delete(filepath);

        }


        FileStream fs = new FileStream(fullfilepath, FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();

        IframeTermscondtion.Attributes["src"] = filepaths;

    }




    public void BothReportView()
    {
        this.ReportViewer1.LocalReport.EnableExternalImages = true;
        this.ReportViewer1.LocalReport.EnableHyperlinks = true;

        int masterid = Convert.ToInt32(Request.QueryString["ID"].ToString());
        try
        {

            ReportDataSet.USP_PO_GoodsRecieveDataTable dta = new ReportDataSet.USP_PO_GoodsRecieveDataTable();
            ReportDataSetTableAdapters.USP_PO_GoodsRecieveTableAdapter tad = new ReportDataSetTableAdapters.USP_PO_GoodsRecieveTableAdapter();

            tad.Fill(dta, masterid);
            ReportDataSource reportdata = new ReportDataSource();
            reportdata.Name = "DataSet1";
            reportdata.Value = dta;



            CompanyInfoDataSet.usp_getcompanyInfoDataTable dta2 = new CompanyInfoDataSet.usp_getcompanyInfoDataTable();
            CompanyInfoDataSetTableAdapters.usp_getcompanyInfoTableAdapter tad2 = new CompanyInfoDataSetTableAdapters.usp_getcompanyInfoTableAdapter();

            tad2.Fill(dta2);
            ReportDataSource report = new ReportDataSource();
            report.Name = "DataSet2";
            report.Value = dta2;


            ReportViewer1.LocalReport.DataSources.Clear();
            //POReportViewers.LocalReport.DataSources.Add(rd);
            ReportViewer1.LocalReport.DataSources.Add(reportdata);
            ReportViewer1.LocalReport.DataSources.Add(report);
            ReportViewer1.LocalReport.Refresh();

        }
        catch (Exception)
        {

            throw;
        }
    }
}