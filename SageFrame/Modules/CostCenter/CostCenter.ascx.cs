using SageFrame.Web;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.CostCenter;
using SageFrame.RestroOrder;
using System.Reflection;
using System.Linq;

public partial class Modules_CostCenter_CostCenter : BaseUserControl
{

    public string ModuleId = string.Empty;
    public string ModulePath = string.Empty;

    public string UserName = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROItem", "/js/uploadfile/form.js", "/js/uploadfile/jquery.uploadfile.js");
        IncludeJs("CostCenterJs", "/Modules/CostCenter/js/CostCenter.js");
        IncludeCss("RestroDashBoard", "/js/jquery-ui-1.8.14.custom/css/redmond/jquery-ui-1.8.16.custom.css");

        UserName = GetUsername;
        BindGrid();
        if (!Page.IsPostBack)
        {
            BindDefaultPrinter();
            AddCostCenter.Visible = false;
            clearText();
            ddlstores();
            BindCostCenterGroup();
        }

    }

    private void ddlstores() {
        RestrOrderController roc = new RestrOrderController();
        ddlstore.DataSource = roc.getIssueToDDl();
        ddlstore.DataBind();
        ddlstore.Items.Insert(0, " --Select-- ");
    }
    private void BindDefaultPrinter()
    {
        List<string> printerList = new List<string>();
        foreach (string printer in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
        {
            printerList.Add(printer);
        }
        ddlDefaultPrinter.DataSource = printerList;
        ddlDefaultPrinter.DataBind();


    }

    private void BindCostCenterGroup()
    {
        RestrOrderController roc = new RestrOrderController();
        ddlGroup.DataSource = roc.GetCostCenterGroup() ;
        ddlGroup.DataBind();
        ddlGroup.Items.Insert(0, " --Select-- ");
    }

    #region Event Control
    protected void btnadd_Click(object sender, EventArgs e)
    {
        AddCostCenter.Visible = true;
        CostCenterName.ReadOnly = false;
    }

    protected void CostCenterSave_Click(object sender, EventArgs e)
    {
        CostCenterInfo dataObj = new CostCenterInfo();
        dataObj.CostCenterId = (String.IsNullOrEmpty(hdfcostcenterid.Value) == true) ? 0 : Convert.ToInt32(hdfcostcenterid.Value);
        dataObj.CostCenterName = CostCenterName.Text;
        dataObj.NumberOfCounter = Convert.ToInt32(NumberOfCounter.Text);
        dataObj.Username = UserName;
        dataObj.DefaultPrinter = ddlDefaultPrinter.SelectedValue;
        dataObj.coDiscount = txtCoDiscount.Text == "" ? 0 : Convert.ToDecimal(txtCoDiscount.Text);
        if (ddlstore.SelectedIndex == 0)
            dataObj.store = 0;
        else
            dataObj.store = Convert.ToInt32(ddlstore.Text);
        if (ddlGroup.SelectedIndex == 0)
            dataObj.GroupId = 0;
        else
            dataObj.GroupId = Convert.ToInt32(ddlGroup.Text);
        CostCenterController controller = new CostCenterController();
        controller.SaveCostCenter(dataObj);
        if (dataObj.CostCenterId == 0)
        {
            //ScriptManager.RegisterClientScriptBlock(this.GetType(),)
            Response.Write("<script>alert('Record saved successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            
        }
        else
        {

            Response.Write("<script>alert('Record updated successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        BindGrid();
        AddCostCenter.Visible = false;
        gdvCostCenter.Visible = true;
        btnCostCenterAdd.Visible = true;
        clearText();
    }


    protected void gdvCostCenter_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "EditCostCenter")
        {
            //CostCenterName.ReadOnly = true;
            CostCenterInfo costCenterInfo = new CostCenterInfo();
            CostCenterController roc = new CostCenterController();
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gdvCostCenter.DataKeys[grdrow.RowIndex].Values["CostCenterId"].ToString());

            costCenterInfo = roc.GetCostCenterById(index);
            hdfcostcenterid.Value = costCenterInfo.CostCenterId.ToString();
            CostCenterName.Text = costCenterInfo.CostCenterName;
            if (costCenterInfo.store != 0)
            {
                ddlstore.SelectedValue = costCenterInfo.store.ToString();

            }
            if(costCenterInfo.GroupId != 0)
            {
                ddlGroup.SelectedValue = costCenterInfo.GroupId.ToString();
            }

            //ddlstore.Text = costCenterInfo.store;
            //ddlDefaultPrinter.SelectedValue = costCenterInfo.DefaultPrinter;

            txtCoDiscount.Text = costCenterInfo.coDiscount.ToString();
            AddCostCenter.Visible = true;
            gdvCostCenter.Visible = false;
            btnCostCenterAdd.Visible = false;
        }
        else
            if (e.CommandName == "DeleteCostCenter")
            {

                LinkButton btn = (LinkButton)e.CommandSource;
                GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
                int empid = Convert.ToInt32(gdvCostCenter.DataKeys[grdrow.RowIndex].Values["CostCenterId"].ToString());

                

                CostCenterController con = new CostCenterController();
                int exist = con.CheckCostCenter(empid);
                if(exist == 1)
            {
                con.deleteCostCenter(empid);
                Response.Write("<script>alert('Record deleted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");

            }
            else
            {
                Response.Write("<script>alert('Cost Center has already been used', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");

            }

            BindGrid();
            }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        AddCostCenter.Visible = false;
        gdvCostCenter.Visible = true;
        btnCostCenterAdd.Visible = true;
        clearText();

    }

    protected void gdvCostCenter_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gdvCostCenter.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    #endregion

    #region User Function
    private void BindGrid()
    {
        CostCenterController coc = new CostCenterController();
        List<CostCenterInfo> costCenter = coc.GetCostCenter();
        gdvCostCenter.DataSource = costCenter;
        gdvCostCenter.DataBind();
    }

    private void clearText()
    {
        hdfcostcenterid.Value = null;
        CostCenterName.Text = string.Empty;
        ddlDefaultPrinter.SelectedIndex = 0;
        txtCoDiscount.Text = string.Empty;
    }
    #endregion

}