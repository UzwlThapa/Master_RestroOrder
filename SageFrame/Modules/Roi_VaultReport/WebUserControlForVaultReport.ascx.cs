using System;
using System.Web;
using SageFrame.Web;
using Microsoft.Reporting.WebForms;
using System.IO;

public partial class Modules_Roi_VaultReport_WebUserControlForVaultReport : BaseUserControl
{
    public string date;
    public int option;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["date"] != null)
            {
                date = Request.QueryString["date"].ToString();
                option = int.Parse(Request.QueryString["option"]);
                print();
            }
                
        }
    }
    protected void btnPdfReport_Click(object sender, EventArgs e)
    {
        if (int.Parse(selOption.Value) == 1 || int.Parse(selOption.Value) == 2)
        Response.Redirect("VaultReport.aspx?option="+selOption.Value+"&date=" + txtSelectDate.Value);
        if (int.Parse(selOption.Value) == 3)
            Response.Redirect("VaultReport.aspx?option=" + selOption.Value + "&date=" + txtYear.Value);
        if (int.Parse(selOption.Value) == 4)
            Response.Redirect("VaultReport.aspx?option=" + selOption.Value + "&date=" + txtYears.Value);
    }

    public void loadReport()
    {
        DataSetForVault.usp_VaultReportDataTable dt = new DataSetForVault.usp_VaultReportDataTable();
        DataSetForVaultTableAdapters.usp_VaultReportTableAdapter adp = new DataSetForVaultTableAdapters.usp_VaultReportTableAdapter();
        adp.Fill(dt, option, date);
        ReportDataSource src = new ReportDataSource();
        src.Name = "DataSet1";
        src.Value = dt;
        ReportViewer1.LocalReport.DataSources.Add(src);
        ReportViewer1.LocalReport.Refresh();

        DataSetForVault.usp_vaultReportTotalDataTable dt1 = new DataSetForVault.usp_vaultReportTotalDataTable();
        DataSetForVaultTableAdapters.usp_vaultReportTotalTableAdapter adp1 = new DataSetForVaultTableAdapters.usp_vaultReportTotalTableAdapter();
        adp1.Fill(dt1,option, date);
        ReportDataSource src1 = new ReportDataSource();
        src1.Name = "DataSet2";
        src1.Value = dt1;
        ReportViewer1.LocalReport.DataSources.Add(src1);
        ReportViewer1.LocalReport.Refresh();

        DataSetForVault.usp_VaultReportForCoinDataTable dt2 = new DataSetForVault.usp_VaultReportForCoinDataTable();
        DataSetForVaultTableAdapters.usp_VaultReportForCoinTableAdapter adp2 = new DataSetForVaultTableAdapters.usp_VaultReportForCoinTableAdapter();
        adp2.Fill(dt2,option, date);
        ReportDataSource src2 = new ReportDataSource();
        src2.Name = "DataSet3";
        src2.Value = dt2;
        ReportViewer1.LocalReport.DataSources.Add(src2);
        ReportViewer1.LocalReport.Refresh();

    }

    public void print()
    {
        loadReport();
        Warning[] warnings;
        string[] streamids;
        string mimeType;
        string encoding;
        string extension;
        byte[] bytes = ReportViewer1.LocalReport.Render("PDF", null, out mimeType,
                       out encoding, out extension, out streamids, out warnings);

        string filepaths = "/Modules/Roi_VaultReport/pdfs/VaultReport_" + date.Replace(@"/", "") +".pdf";
        string fullfilepath = HttpContext.Current.Server.MapPath(filepaths);
        bool exists = System.IO.File.Exists(fullfilepath);
        if (exists)
        {
            string filepath = fullfilepath;
            File.Delete(filepath);
        }
        FileStream fs = new FileStream(fullfilepath, FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();
        vaultReportPdf.Attributes["src"] = filepaths;
    }
}