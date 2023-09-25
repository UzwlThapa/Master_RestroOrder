using System;
using SageFrame.Web;
public partial class Modules_RoReport_SalesReport_SalesReport : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("", "/js/BillBind.js");
        IncludeJs("CakeBilling", "/Modules/CakeBilling/js/CakeBillBind.js");
        IncludeJs("RoReport", "/Modules/RoReport/SalseReport.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/js/jquery.validate.js");
        IncludeJs("RoReport", "/Modules/RoReport/jspdf.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jquery.dataTables.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/dataTables.buttons.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.flash.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/jszip.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/pdfmake.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/vfs_fonts.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.html5.min.js");
        IncludeJs("RoReport", "/Modules/DataTable/js/buttons.print.min.js");
        IncludeCss("RoReport", "/Modules/DataTable/css/buttons.dataTables.min.css");
        IncludeCss("RoReport", "/Modules/DataTable/css/dataTables.min.css");
    }

    //public void dailySales()
    //{
    //    var todaydate = fromdate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getdailyReport(Convert.ToDateTime(todaydate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getdailyReportBySum(Convert.ToDateTime(todaydate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();



    //}
    //public void weekly()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    //public void checkvalue1()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td><td>Waiter Name</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("<td>" + item.UserName + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    //public void checkvalue2()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td><td>Room</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("<td>" + item.restroRoom + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    //public void checkvalue3()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td><td>Table</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("<td>" + item.restrotableTitle + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}

    //public void CheckWaiter_Room()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td><td>Waiter</td> <td>Room</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("<td>" + item.UserName + "</td>");
    //        sb.Append("<td>" + item.restroRoom + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    //public void CheckWaiter_Table()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td><td>Waiter</td> <td>Table</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("<td>" + item.UserName + "</td>");
    //        sb.Append("<td>" + item.restrotableTitle + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    //public void CheckRooom_Table()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Room</td><td>Table</td> <td>Amount</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.restroRoom + "</td>");
    //        sb.Append("<td>" + item.restrotableTitle + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    

    //public void CheckWaiter_Room_Table()
    //{
    //    var todaydate = fromdate.Text;
    //    var tdate = todate.Text;
    //    StringBuilder sb = new StringBuilder();
    //    RestrOrderController con = new RestrOrderController();
    //    List<dailyreport> list = con.getweeklybyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb.Append("<table class='sfNotfound' >");
    //    sb.Append("<tr>");
    //    sb.Append("<td>SN</td><td>Date</td><td>Amount</td><td>Waiter</td> <td>Room</td><td>Table</td>");
    //    sb.Append("</tr>");
    //    int count = 1;
    //    foreach (dailyreport item in list)
    //    {
    //        sb.Append("<tr>");
    //        sb.Append("<td>" + count + "</td>");
    //        sb.Append("<td>" + item.Date + "</td>");
    //        sb.Append("<td>" + item.BasicAmount + "</td>");
    //        sb.Append("<td>" + item.UserName + "</td>");
    //        sb.Append("<td>" + item.restroRoom + "</td>");
    //        sb.Append("<td>" + item.restrotableTitle + "</td>");
    //        sb.Append("</tr>");
    //        count = count + 1;
    //    }
    //    sb.Append("</table>");
    //    dailysalse.Text = sb.ToString();
    //    //fromdate.Text = "";

    //    StringBuilder sb1 = new StringBuilder();
    //    RestrOrderController con1 = new RestrOrderController();
    //    List<dailyreport> list1 = con.getweeklysumbyDate(Convert.ToDateTime(todaydate), Convert.ToDateTime(tdate));
    //    sb1.Append("<p>" + list1[0].sumAmount + "</p>");
    //    sum.Text = sb1.ToString();
    //}
    //protected void btnLoadReport_Click(object sender, EventArgs e)
    //{


    //    if (Convert.ToInt32(reportingday.Value) == 1)
    //    {
    //        dailySales();
    //    }
    //    else if (Convert.ToInt32(reportingday.Value) == 2)
    //    {
    //        weekly();

    //    }

    //    if (waiter.Checked == true  && Room.Checked == false && table.Checked == false)
    //    {

    //        checkvalue1();
    //    }
    //    else if (Room.Checked == true && waiter.Checked == false && table.Checked == false)
    //    {
    //        checkvalue2();

    //    }
    //    else if (table.Checked == true && Room.Checked == false && waiter.Checked == false)
    //    {
    //        checkvalue3();
    //    }
    //    else if (Room.Checked && waiter.Checked == true && table.Checked == false)
    //    {
    //        CheckWaiter_Room();

    //    }
    //    else if (table.Checked && waiter.Checked == true && Room.Checked == false)
    //    {
    //        CheckWaiter_Table();

    //    }
    //    else if (Room.Checked && table.Checked == true && waiter.Checked == false)
    //    {
    //        CheckRooom_Table();

    //    }
    //    else if (Room.Checked && waiter.Checked && table.Checked == true)
    //    {
    //        CheckWaiter_Room_Table();
    //    }
       
    //}


   
}