using System;
using System.Collections.Generic;
using SageFrame.Web;
using System.Data;
using System.Text;
using SageFrame.RestroOrder;
public partial class Modules_RestroReport_restroReport : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("Js", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        DataTable dt = new DataTable();
        dt.Columns.Add("mId", typeof(Int32));
        dt.Columns.Add("Name", typeof(string));

        object[] a = { 0, "--Select--" };
        dt.Rows.Add(a);
        object[] b = { 1, "January" };
        dt.Rows.Add(b);
        object[] c = { 2, "February" };
        dt.Rows.Add(c);
        object[] d = { 3, "March" };
        dt.Rows.Add(d);
        object[] f = { 4, "April" };
        dt.Rows.Add(f);
        object[] g = { 5, "May" };
        dt.Rows.Add(g);
        object[] h = { 6, "June" };
        dt.Rows.Add(h);
        object[] i = { 7, "July" };
        dt.Rows.Add(i);
        object[] j = { 8, "August" };
        dt.Rows.Add(j);
        object[] k = { 9, "September" };
        dt.Rows.Add(k);
        object[] l = { 10, "October" };
        dt.Rows.Add(l);
        object[] m = { 11, "November" };
        dt.Rows.Add(m);
        object[] n = { 12, "December" };
        dt.Rows.Add(n);


        ddlmonth.DataSource = dt;
        ddlmonth.DataTextField = "Name";
        ddlmonth.DataValueField = "mId";
        ddlmonth.DataBind();


    }
    public SageFrame.RestroOrder.RestrOrderController roc = new RestrOrderController();
    public List<SalesMaster> sm;
    public List<customerBilling> termkot;
    public List<customerBilling> termbev;
    public List<customerBilling> termkotbev;
    decimal sum;
    protected void btnView_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(rtId.Value)) return;
        StringBuilder sb = new StringBuilder();
        if (rtId.Value == "1")
        {
            sum = 0;
            if (txtfromdate.Text == "") return;
            sm = roc.getdailysalesReport(Convert.ToDateTime(txtfromdate.Text));
            if (sm[0].sumKot == null)
                sm[0].sumKot = 0;
            if (sm[0].sumBev == null)
                sm[0].sumBev = 0;
            //if (sm[0].NetAmount == 0)
            //{
            //    lireport.Text = "<h3><i>No Data</i></h3>";

            //    return;
            //}
            termkot = roc.getbillingTerm(Convert.ToDecimal(sm[0].sumKot));
            termbev = roc.getbillingTerm(Convert.ToDecimal(sm[0].sumBev));
            termkotbev = roc.getbillingTerm(Convert.ToDecimal(sm[0].sumKotBev));
            sb.Append("<table class='pretable' style='background:#FFFFFF;'>");
            sb.Append("<tr>");
            sb.Append("<td colspan='2' style='text-align:right;font-weight:bold;padding-right:20px;'>Date :" + txtfromdate.Text + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<th style='width:50%;'>Kot</th><th>Bar</th><th>Total</th>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td>" + termkot[termkot.Count - 1].Amount + "</td>");
            sb.Append("<td>" + termbev[termbev.Count - 1].Amount + "</td>");
            sb.Append("<td>" + termkotbev[termkotbev.Count - 1].Amount + "</td>");
            sb.Append("</tr>");
            sum = (termkot[termkot.Count - 1].Amount) + (termbev[termbev.Count - 1].Amount);
            sb.Append("<tr>");
            sb.Append("<td colspan='2' style='text-align:right;font-weight:bold;padding-right:19%;'>");
            sb.Append("Total :" + sum + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");

            lireport.Text = sb.ToString();
        }
        else if (rtId.Value == "2")
        {
            sum = 0;
            if (txtfromdate.Text == "") return;
            sm = roc.getweeklysalesReport(Convert.ToDateTime(txtfromdate.Text));
            sb.Append("<table class='pretable' style='text-align:center ;background:#FFFFFF;'>");
            sb.Append("<tr>");
            sb.Append("<th style='width:33.3%'>Date</th><th style='width:33.3%'>Kot</th><th>Bar</th><th>Total</th>");
            sb.Append("</tr>");

            foreach (SalesMaster obj in sm)
            {
                if (obj.sumBev < 0 || obj.sumBev == null)
                {
                    obj.sumBev = 0;
                }
                if (obj.sumKot < 0 || obj.sumKot == null)
                {
                    obj.sumKot = 0;
                }
                termkot = roc.getbillingTerm(Convert.ToDecimal(obj.sumKot));
                termbev = roc.getbillingTerm(Convert.ToDecimal(obj.sumBev));
                termkotbev = roc.getbillingTerm(Convert.ToDecimal(obj.sumKotBev));
                sb.Append("<tr>");
                sb.Append("<td>" + obj.BillDate.ToShortDateString() + "</td>");
                sb.Append("<td>" + termkot[termkot.Count - 1].Amount + "</td>");
                sb.Append("<td>" + termbev[termbev.Count - 1].Amount + "</td>");
                sb.Append("<td>" + termkotbev[termkotbev.Count - 1].Amount + "</td>");
                sb.Append("</tr>");
                sum += (termkot[termkot.Count - 1].Amount) + (termbev[termbev.Count - 1].Amount);
            }
            //decimal sum = (termkot[termkot.Count - 1].Amount) + (termbev[termbev.Count - 1].Amount);
            sb.Append("<tr>");
            sb.Append("<td colspan='3' style='text-align:right;font-weight:bold;padding-right:10%;'>");
            sb.Append("Total :" + sum + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");

            lireport.Text = sb.ToString();
        }
        else if (rtId.Value == "3")
        {
            if (yearvalue.Value == "" || monthvalue.Value == "") return;
            sm = roc.getmonthlysalesReport(yearvalue.Value, monthvalue.Value);
            sb.Append("<table class='pretable' style='text-align:center;background:#FFFFFF;'>");
            sb.Append("<tr>");
            sb.Append("<th style='width:33.3%'>Date</th><th style='width:33.3%'>Kot</th><th>Bar</th><th>Total</th>");
            sb.Append("</tr>");

            foreach (SalesMaster obj in sm)
            {
                if (obj.sumBev < 0 || obj.sumBev == null)
                {
                    obj.sumBev = 0;
                }
                if (obj.sumKot < 0 || obj.sumKot == null)
                {
                    obj.sumKot = 0;
                }
                termkot = roc.getbillingTerm(Convert.ToDecimal(obj.sumKot));
                termbev = roc.getbillingTerm(Convert.ToDecimal(obj.sumBev));
                termkotbev = roc.getbillingTerm(Convert.ToDecimal(obj.sumKotBev));
                sb.Append("<tr>");
                sb.Append("<td>" + obj.BillDate.ToShortDateString() + "</td>");
                sb.Append("<td>" + termkot[termkot.Count - 1].Amount + "</td>");
                sb.Append("<td>" + termbev[termbev.Count - 1].Amount + "</td>");
                sb.Append("<td>" + termkotbev[termkotbev.Count - 1].Amount + "</td>");
                sb.Append("</tr>");
                sum += (termkot[termkot.Count - 1].Amount) + (termbev[termbev.Count - 1].Amount);
            }

            sb.Append("<tr>");
            sb.Append("<td colspan='3' style='text-align:right;font-weight:bold;padding-right:10%;'>");
            sb.Append("Total :" + sum + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");

            lireport.Text = sb.ToString();
        }
        else if(rtId.Value=="4")
        {
            if (yearvalue.Value == "" ) return;
            sm = roc.getyearlysalesReport(yearvalue.Value);
            sb.Append("<table class='pretable' style='text-align:center;background:#FFFFFF;'>");
            sb.Append("<tr>");
            sb.Append("<th style='width:33.3%'>Date</th><th style='width:33.3%'>Kot</th><th>Bar</th><th>Total</th>");
            sb.Append("</tr>");

            foreach (SalesMaster obj in sm)
            {
                if (obj.sumBev < 0 || obj.sumBev == null)
                {
                    obj.sumBev = 0;
                }
                if (obj.sumKot < 0 || obj.sumKot == null)
                {
                    obj.sumKot = 0;
                }
                termkot = roc.getbillingTerm(Convert.ToDecimal(obj.sumKot));
                termbev = roc.getbillingTerm(Convert.ToDecimal(obj.sumBev));
                termkotbev = roc.getbillingTerm(Convert.ToDecimal(obj.sumKotBev));
                sb.Append("<tr>");
                sb.Append("<td>" + obj.BillDate.ToShortDateString() + "</td>");
                sb.Append("<td>" + termkot[termkot.Count - 1].Amount + "</td>");
                sb.Append("<td>" + termbev[termbev.Count - 1].Amount + "</td>");
                sb.Append("<td>" + termkotbev[termkotbev.Count - 1].Amount + "</td>");
                sb.Append("</tr>");
                sum += (termkot[termkot.Count - 1].Amount) + (termbev[termbev.Count - 1].Amount);
            }

            sb.Append("<tr>");
            sb.Append("<td colspan='3' style='text-align:right;font-weight:bold;padding-right:10%;'>");
            sb.Append("Total :" + sum + "");
            sb.Append("</td>");
            sb.Append("</tr>");
            sb.Append("</table>");

            lireport.Text = sb.ToString();
        }
        ddlreporting.SelectedIndex = 0;
    }

    //protected void GridView1_RowCreated(object sender, GridViewRowEventArgs e)
    //{
    //    if (e.Row.RowType == DataControlRowType.Header)
    //    {
    //        e.Row.TableSection = TableRowSection.TableHeader;
    //    }

    //    if (e.Row.RowType == DataControlRowType.DataRow)
    //    {
    //        e.Row.TableSection = TableRowSection.TableBody;
    //    }

    //    if (e.Row.RowType == DataControlRowType.Footer)
    //    {
    //        e.Row.TableSection = TableRowSection.TableFooter;
    //    }
    //}
}