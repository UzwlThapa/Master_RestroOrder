using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
using System.Data;

public partial class Modules_ROISalesPaymentMode_PaymentModeReport : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    RestrOrderController roc = new RestrOrderController();

    public List<SalesMaster> sm;
    public List<customerBilling> termkot;
    public List<customerBilling> termbev;
    public List<decimal> CashSales;
    public List<decimal> CheckSales;
    public List<decimal> SwapSales;
    protected void Page_Load(object sender, EventArgs e)
    {
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        BindMonth();
        BindYear();
        IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");
        gdvReport.Visible = false;
        gvdReportForSwap.Visible = false;
        gvdreportProviderList.Visible = false;


    }
    public void BindGrid()
    {
        DateTime dailyDate = txtToday.Text == "" ? new DateTime(1753, 1, 1) : Convert.ToDateTime(txtToday.Text);
        DateTime weeklyDate = txtweeklydate.Text == "" ? new DateTime(1753, 1, 1) : Convert.ToDateTime(txtweeklydate.Text);
        int id = Convert.ToInt32(ddlDate.SelectedValue);
        int month = ddlmonth.SelectedValue == "" ? 0 : Convert.ToInt32(ddlmonth.SelectedValue);
        int year = ddlyear.SelectedValue == "" ? 0 : Convert.ToInt32(ddlyear.SelectedValue);
        int mode = Convert.ToInt32(rbModeList.SelectedValue);
        int providerId = ddlProviderList.SelectedValue == "" ? 0 : Convert.ToInt32(ddlProviderList.SelectedValue);
        List<salesSummaryByProviderMode> info = new List<salesSummaryByProviderMode>();
        RestrOrderController con = new RestrOrderController();

        if (mode == 3)
        {
            if (ddlProviderList.SelectedIndex <= 0)
            {
                info = con.GetSalesSummaryByProviderMode(mode, id, dailyDate, weeklyDate, month, year);
                gvdReportForSwap.DataSource = info;
                gvdReportForSwap.DataBind();
                gvdReportForSwap.Visible = true;
                gdvReport.Visible = false;
                gvdreportProviderList.Visible = false;
            }
            else
            {

                info = con.GetSalesSummaryByProviderList(id, providerId, dailyDate, weeklyDate, month, year);
                gvdreportProviderList.DataSource = info;
                gvdreportProviderList.DataBind();
                gvdreportProviderList.Visible = true;
                gdvReport.Visible = false;
                gvdReportForSwap.Visible = false;
                providerId = 0;
            }


        }

        else
        {

            info = con.GetSalesSummaryByProviderMode(mode, id, dailyDate, weeklyDate, month, year);
            gdvReport.DataSource = info;
            gdvReport.DataBind();
            gdvReport.Visible = true;
            gvdreportProviderList.Visible = false;
            gvdReportForSwap.Visible = false;
        }
      
    }

    protected void btnView_Click(object sender, EventArgs e)
       
    {
        BindGrid();

    }
    private void BindProviderList()
    {
        List<CardProvider> cardProviderList = roc.getCardProvider();
        CardProvider card = new CardProvider();
        //card.ProviderID = Convert.ToInt32(card.ProviderName);
        ddlProviderList.DataSource = cardProviderList;

        ddlProviderList.DataTextField = "ProviderName";
        ddlProviderList.DataValueField = "ProviderID";
        ddlProviderList.DataBind();
        ddlProviderList.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }
    public void BindYear()
    {

        for (int i = DateTime.Now.Year; i > DateTime.Now.Year - 50; i--)
            ddlyear.Items.Add(Convert.ToString(i));
    }
    private void BindMonth()
    {
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
    protected void rbModeList_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbModeList.SelectedItem.Value == "3")
        {
            BindProviderList();
            ProviderList.Visible = true;
        }
        else
        {
            ProviderList.Visible = false;
        }
    }
    protected void ddlreportingtime_SelectedIndexChanged(object sender, EventArgs e)
    {
       if (ddlDate.SelectedValue == "1")
        {
            DailydateInput.Visible = true;
            WeeklydateInput.Visible = false;
            YearlydateInput.Visible = false;
            MonthlydateInput.Visible = false;
            txtToday.Text = "";

        }
        else if (ddlDate.SelectedValue == "2")
        {
            WeeklydateInput.Visible = true;
            DailydateInput.Visible = false;
            YearlydateInput.Visible = false;
            MonthlydateInput.Visible = false;
          
            txtweeklydate.Text = "";
        }
        else if (ddlDate.SelectedValue == "3")
        {
            MonthlydateInput.Visible = true;
            YearlydateInput.Visible = true;
            DailydateInput.Visible = false;
            WeeklydateInput.Visible = false;

            ddlmonth.SelectedIndex = 0;
            ddlyear.SelectedIndex = 0;
        }
        else 
        {
            YearlydateInput.Visible = true;
            MonthlydateInput.Visible = false;
            DailydateInput.Visible = false;
            WeeklydateInput.Visible = false;
         
            ddlyear.SelectedIndex = 0;
        }
       
    }
    protected void gdvReport_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gdvReport.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void gvdReportForSwap_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvdReportForSwap.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    protected void gvdreportProviderList_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvdreportProviderList.PageIndex = e.NewPageIndex;
        BindGrid();
    }
}