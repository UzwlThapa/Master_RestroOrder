using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using SageFrame.Web;

public partial class Modules_ROPrice_ROPrice : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");
        //IncludeJs("ROMenu", "/Modules/ROItem/Js/NewJs.js");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.validate.js");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        if (!IsPostBack)
        {
            BindGrid();
            //System.Text.StringBuilder message = new System.Text.StringBuilder();
            //message.Append("<script type = 'text/javascript'>");

            //message.Append("$(document).ready(function () { var tabs = $('#tabs').tabs();$('#tbl1').hide(); $('#btnadd').on('click', function () { $('#tbl1').show(); }); $('#btncancel').on('click', function () { $('#tbl1').hide();}); $('#btnsave').on('click', function () {$('#tbl1').show();}); $('#imgEdit').on('click', function () { $('#tbl1').show();});});");
            //message.Append("</script>");

            //Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", message.ToString());
        }
        List<CurrencyClass> info = new List<CurrencyClass>();
        RestrOrderController con = new RestrOrderController();
        info = con.GetCurrencyFromDatabase();
       
        //gdvPrice.DataSource = info;
        //gdvPrice.DataBind();
        tbl1.Visible = false;
    }
    #region Control function
    protected void btnsave_Click(object sender, EventArgs e)
    {
        RestrOrderController con = new RestrOrderController();
        CurrencyClass currency = new CurrencyClass();

        currency.CurrencyName = txtprice.Text;
        currency.SubCurrencyName = txtSubPrice.Text;
        currency.CurrencyID = (String.IsNullOrEmpty(hdfpriceid.Value)) ? 0 : int.Parse(hdfpriceid.Value);
        currency.CurrencyIcon = txtCurrencyIcon.Text;
        con.CurrencySaveTodatabase(currency);
        if (currency.CurrencyID == 0)
        {
                                    
            Response.Write("<script>jAlert('Record Inserted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        else
        {
            Response.Write("<script>jAlert('Record updated Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }
      
        BindGrid();
        tbl1.Visible = false;
        btnadd.Visible = true;
        ////prevent Re-Post action caused by pressing browser's Refresh button
        //Response.Redirect(Request.RawUrl);
    }

 
    protected void gdvPrice_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditUser")
        {
            CurrencyClass currencyinfo = new CurrencyClass();
            RestrOrderController roc = new RestrOrderController();
            //RestrOrderInfo t = roc.GetTableName();
            //int index = Convert.ToInt32(e.CommandArgument);
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gdvPrice.DataKeys[grdrow.RowIndex].Values["CurrencyID"].ToString());
            currencyinfo  = roc.GetCurrencyBYId(index);
            hdfpriceid.Value = Convert.ToString(currencyinfo.CurrencyID);
            txtprice.Text = currencyinfo.CurrencyName;
            txtSubPrice.Text = currencyinfo.SubCurrencyName;
            txtCurrencyIcon.Text = currencyinfo.CurrencyIcon;
            tbl1.Visible = true;


            ////prevent Re-Post action caused by pressing browser's Refresh button
            //Response.Redirect(Request.RawUrl);
        }
        else if (e.CommandName == "DeleteUser")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gdvPrice.DataKeys[grdrow.RowIndex].Values["CurrencyID"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.CurrencyDelete(empid);

            Response.Write("<script>jAlert('Record deleted Successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            BindGrid();

            ////prevent Re-Post action caused by pressing browser's Refresh button
            //Response.Redirect(Request.RawUrl);

        }
    }
    #endregion

    #region user function
    private void BindGrid()
    {
        List<CurrencyClass> info1 = new List<CurrencyClass>();
        RestrOrderController con = new RestrOrderController();
        info1 = con.GetCurrencyFromDatabase();
        //txtprice.Text = null;
        //txtSubPrice.Text = null;
        gdvPrice.DataSource = info1;
        gdvPrice.DataBind();

        ResetAll();
    }

    protected void btnadd_Click(object sender, EventArgs e)
    {
        tbl1.Visible = true;
        btnadd.Visible = false;
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        ResetAll();
        btnadd.Visible = true;
    }
    
    protected void ResetAll()
    {
        tbl1.Visible = false;
        txtprice.Text = null;
        txtSubPrice.Text = null;
        txtCurrencyIcon.Text = null;
        hdfpriceid.Value = null;
       
    }
    #endregion

}