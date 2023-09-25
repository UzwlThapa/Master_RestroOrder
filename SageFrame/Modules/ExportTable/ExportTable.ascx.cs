using SageFrame.Web;
using System;
using System.Data;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using System.IO;
using ClosedXML.Excel;
using System.Threading;
//using ExPortGridviewToXML;
using System.Text;

public partial class Modules_ExportTable_ExportTable : BaseAdministrationUserControl
{
    RestrOrderController controller = new RestrOrderController();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            GetAllTableName();
        }

    }


    private void GetAllTableName()
    {
        DataSet myDataSet = controller.GetAllTableName(); // replace with your dataset
        DropDownList1.DataSource = myDataSet;
        DropDownList1.DataTextField = "table_name";
        DropDownList1.DataValueField = "table_name";
        DropDownList1.DataBind();
    }



    protected void OnPaging(object sender, GridViewPageEventArgs e)
    {
        GridViewTables.PageIndex = e.NewPageIndex;
        GridViewTables.DataBind();
    }

    protected void btn_GetTable_Click(object sender, EventArgs e)
    {

        DataTable GridSource = controller.GetAllTableDataByTableName(DropDownList1.SelectedValue);
        GridViewTables.DataSource = GridSource;
        GridViewTables.DataBind();
        ViewState["Data"] = GridSource;
    }
    protected void btn_Excel_Click(object sender, EventArgs e)
    {
        ExportToExcel();
    }

    private void ExportToExcel()
    {
        DataTable dt = new DataTable("GridView_Data");
        foreach (TableCell cell in GridViewTables.HeaderRow.Cells)
        {
            dt.Columns.Add(cell.Text);
        }
        foreach (GridViewRow row in GridViewTables.Rows)
        {
            dt.Rows.Add();
            for (int i = 0; i < row.Cells.Count; i++)
            {
                dt.Rows[dt.Rows.Count - 1][i] = row.Cells[i].Text;
            }
        }
        using (XLWorkbook wb = new XLWorkbook())
        {
            wb.Worksheets.Add(dt);

            Response.Clear();
            Response.Buffer = true;
            Response.Charset = "";
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=GridView.xlsx");
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                wb.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
            }
        }
    }

    protected void btn_txt_Click(object sender, EventArgs e)
    {
        ExportToTxt();
    }

    private void ExportToTxt()
    {
        string txtFile = string.Empty;

        //Adding Column Name In Text File.  
        foreach (TableCell cell in GridViewTables.HeaderRow.Cells)
        {
            txtFile += cell.Text + "\t\t";
        }

        txtFile += "\r\n";

        //Adding Data Column Values in Text File  
        foreach (GridViewRow row in GridViewTables.Rows)
        {
            foreach (TableCell cell in row.Cells)
            {
                txtFile += cell.Text + "\t\t";
            }
            txtFile += "\r\n";
        }

        Response.Clear();
        Response.Buffer = true;
        Response.AddHeader("content-disposition", "attachment;filename=EmployeeData.txt");
        Response.Charset = "";
        Response.ContentType = "application/text";
        Response.Output.Write(txtFile);
        Response.Flush();
        Response.End();
    }



    protected void btn_xml_Click(object sender, EventArgs e)
    {

        ExportGridToXML();

    }


    private void ExportGridToXML()
    {
        DataTable dt = (DataTable)ViewState["Data"];

        StringBuilder xmlDoc = new StringBuilder("<?xml version=\"1.1\" encoding='UTF-8' ?>\n");
        xmlDoc.AppendLine("<Datas>");

        foreach (DataRow dr in dt.Rows)
        {
            xmlDoc.AppendLine("\t<Data>");

            foreach (DataColumn col in dr.Table.Columns)
            {
                xmlDoc.AppendLine("\t\t<" + col.ColumnName + ">" + dr[col].ToString() + "</" + col.ColumnName + ">");
            }

            xmlDoc.AppendLine("\t</Data>");
        }

        xmlDoc.AppendLine("</Datas>");

        Response.AddHeader("content-disposition", "attachment;filename=GridViewExport.xml");
        Response.Charset = "";
        Response.ContentType = "application/xml";
        Response.Write(xmlDoc);
        Response.Flush();
        Response.End();

    }
}