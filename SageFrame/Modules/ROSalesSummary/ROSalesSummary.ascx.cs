using SageFrame.RestroOrder;
using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Modules_ROSalesSummary_ROSalesSummary : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (Page.IsValid)
        BindDropdownList();
    }
    public void BindDropdownList()
    {

        for (int i = DateTime.Now.Year; i > DateTime.Now.Year - 50; i--)
            ddlYear.Items.Add(Convert.ToString(i));
    }
    protected void btnGenerate_Click(object sender, EventArgs e)
    {

        BindGrid();
     
    }

    public void BindGrid()
    {
        DateTime dailyDate = txtDailyDate.Text == "" ? new DateTime(1753, 1, 1) : Convert.ToDateTime(txtDailyDate.Text);
        DateTime weeklyDate = txtWeeklyDate.Text == "" ? new DateTime(1753, 1, 1) : Convert.ToDateTime(txtWeeklyDate.Text);
        int value = Convert.ToInt32(ddlDate.SelectedValue);
        int month = ddlMonth.SelectedValue == "" ? 0 : Convert.ToInt32(ddlMonth.SelectedValue);
        int year = ddlYear.SelectedValue == "" ? 0 : Convert.ToInt32(ddlYear.SelectedValue);
        DateTime fromDate = txtFromDate.Text == "" ? new DateTime(1753, 1, 1) : Convert.ToDateTime(txtFromDate.Text);
        DateTime toDate = txtToDate.Text ==  "" ? new DateTime(1753, 1, 1) : Convert.ToDateTime(txtToDate.Text);

        List<salesSummary> info1 = new List<salesSummary>();
        RestrOrderController con = new RestrOrderController();
        info1 = con.GetSalesSummary(dailyDate,weeklyDate, value, month, year, fromDate, toDate);

        List<salesSummary> forComparison = new List<salesSummary>();
        List<salesSummary> ItemList = new List<salesSummary>();

        foreach (var sale in info1)
        {
            salesSummary s = new salesSummary();
            s = sale;
            forComparison.Add(s);
        }
         int count = 1;
        foreach (var s in info1)
        {
            salesSummary soldItem = new salesSummary();
            float quantity = s.Quantity;
            foreach (var temp in forComparison)
            {

                if (s.OrderDetailsID != temp.OrderDetailsID)
                {
                    if (s.ROI_ItemId == temp.ROI_ItemId)
                    {
                        quantity = quantity + temp.Quantity;
                    }
                }

            }
            var item = s.ITName;
            soldItem.ROI_ItemId = s.ROI_ItemId;
            soldItem.ITName = s.ITName;
            soldItem.Quantity = quantity;
            soldItem.ITUnit = s.ITUnit;

            var checkhDuplicateItem = ItemList.Where(i => i.ITName.Contains(item)).FirstOrDefault();

            if (checkhDuplicateItem == null)
            {
                soldItem.Count = count;
                ItemList.Add(soldItem);
                count++;
            }
           
        }

        gdvSalesSummary.DataSource = ItemList;
        gdvSalesSummary.DataBind();
        //txtDate.Text = "";
        //txtFromDate.Text = "";
        //txtToDate.Text = "";
       
       
    }

    protected void gdvSalesSummary_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gdvSalesSummary.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    //protected void gdvSalesSummary_PageIndexChanging(object sender, GridViewPageEventArgs e)
    //{
          //    BindGrid();
    //}
    protected void ddlDate_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlDate.SelectedValue == "1" )
        {
            DailydateInput.Visible = true;
            WeeklydateInput.Visible = false;
            YearlydateInput.Visible = false;
            MonthlydateInput.Visible = false;
            RangedateInput.Visible = false;
            btnGenerate.Visible = true;
            txtDailyDate.Text = "";
         
        }
            else if(ddlDate.SelectedValue == "2")
        {
            WeeklydateInput.Visible = true;
            DailydateInput.Visible = false;
            YearlydateInput.Visible = false;
            MonthlydateInput.Visible = false;
            RangedateInput.Visible = false;
            btnGenerate.Visible = true;
            txtWeeklyDate.Text = "";
            }
        else if (ddlDate.SelectedValue == "3")
        {
          MonthlydateInput.Visible = true;
          YearlydateInput.Visible = true;
          DailydateInput.Visible = false;
          WeeklydateInput.Visible = false;
          RangedateInput.Visible = false;
          btnGenerate.Visible = true;
          ddlMonth.SelectedIndex = 0;
          ddlYear.SelectedIndex = 0;
        }
        else if (ddlDate.SelectedValue == "4")
        {
           YearlydateInput.Visible = true;
           MonthlydateInput.Visible = false;
           DailydateInput.Visible = false;
           WeeklydateInput.Visible = false;
           RangedateInput.Visible = false;
           btnGenerate.Visible = true;
           ddlYear.SelectedIndex = 0;
        }
        else 
        {
           RangedateInput.Visible = true;
           YearlydateInput.Visible = false;
           MonthlydateInput.Visible = false;
           DailydateInput.Visible = false;
           WeeklydateInput.Visible = false;
           btnGenerate.Visible = true;
           txtFromDate.Text = "";
           txtToDate.Text = "";
           //txtToDate.Text = "";
        }
    }
}