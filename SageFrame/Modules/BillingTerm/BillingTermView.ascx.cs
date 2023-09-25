using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
public partial class Modules_BillingTerm_BillingTermView : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

        IncludeCss("ROItem", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("BillingTerm", "/Modules/BillingTerm/jquery.timepicker.min.css");
        IncludeJs("ROItem", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        IncludeJs("BillingTerm", "/Modules/BillingTerm/jquery.timepicker.min.js");


        if (!IsPostBack)
        {
            tbl1.Visible = false;
            BindSequence();
        
            LoadGrid();
        }




    }

    private void BindSequence()
    {
        List<billingTerm> billinginfo = new List<billingTerm>();
        RestrOrderController con = new RestrOrderController();
        billinginfo = con.getbillInfo();
        List<int> arr1 = new List<int>();
        //int i = 0;
        foreach (billingTerm bill in billinginfo)
        {
            if (bill.Name != "VAT" )
            {
              arr1.Add(bill.SequenceOrder);
            }
           
            //i = bill.SequenceOrder;
        }
        arr1.Sort();
        List<int> arr2 = new List<int>();
        for (int p = 1; p <= arr1.Count; p++)
        {
            bool alreadyExist = arr1.Contains(p);
            if (alreadyExist != true)
            {
                arr2.Add(p);
            }
        }

      
        var lastItem = arr1[arr1.Count - 1];
        arr2.Add(lastItem + 1);

        foreach (var item2 in arr2)
        {
            ddlSequence.Items.Add(item2.ToString());
        }

        ddlSequence.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));
    }

    private void LoadGrid()
    {
        List<billingTerm> billinginfo = new List<billingTerm>();
        RestrOrderController con = new RestrOrderController();
        billinginfo = con.getbillInfo();
        gdvBillingTerm.DataSource = billinginfo;
        gdvBillingTerm.DataBind();
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        List<billingTerm> billinginfo = new List<billingTerm>();
        billingTerm bt = new billingTerm();
        RestrOrderController con = new RestrOrderController();
        billinginfo = con.getbillInfo();

        bt.Name = txtname.Text;
        bt.Description = txtdesc.Text;
        bt.Rate = txtrate.Text;
        bt.BilingID = (String.IsNullOrEmpty(hfBillTermId.Value)) ? 0 : int.Parse(hfBillTermId.Value);
        bt.SequenceOrder = (String.IsNullOrEmpty(ddlSequence.SelectedItem.Value)) ? 0 : int.Parse(ddlSequence.SelectedItem.Value);
        if (chkisAdd.Checked)
            bt.IsAdd = true;
        else
            bt.IsAdd = false;
       
        {
          
            if (billinginfo.Any(s => s.Name.Equals(bt.Name, StringComparison.OrdinalIgnoreCase)) && bt.BilingID <= 0)
            {

                Response.Write("<script>alert('Billing Term Already Exists', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
                ResetAll();
                gdvBillingTerm.DataBind();
                tbl1.Visible = false;
                LoadGrid();
                BindSequence();
                btnadd.Visible = true;
                return;
            }
            else{
                int billid = con.saveBillingTerm(bt);
            }
            
        }
        if (bt.BilingID == 0)
        {
            Response.Write("<script>alert('Record saved successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }
        else
        {
            Response.Write("<script>alert('Record updated successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
        }

        ResetAll();
    
        gdvBillingTerm.DataBind();
        tbl1.Visible = false;
        LoadGrid();
        BindSequence();
        btnadd.Visible = true;
         gdvBillingTerm.Visible = true;
  
    }

  
    protected void gdvBillingTerm_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "EditUser")
        {
            btnadd.Visible = false;
            gdvBillingTerm.Visible = false;
            billingTerm billinginfo = new billingTerm();
            RestrOrderController roc = new RestrOrderController();
       
            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int index = Convert.ToInt32(gdvBillingTerm.DataKeys[grdrow.RowIndex].Values["BilingID"].ToString());
            billinginfo = roc.getbillInfoById(index);
            txtname.Text = billinginfo.Name;
            txtrate.Text = billinginfo.Rate;
            txtdesc.Text = billinginfo.Description;
            hfBillTermId.Value = billinginfo.BilingID.ToString();
            tbl1.Visible = true;
            ResetSequence();
            BindSequence();
            ddlSequence.Items.Add(billinginfo.SequenceOrder.ToString());
            if (billinginfo.SequenceOrder > 0)
            {
           
                ddlSequence.SelectedValue = billinginfo.SequenceOrder.ToString(); 
            }
            if (billinginfo.IsAdd == true)
                chkisAdd.Checked = true;
            else
                chkisAdd.Checked = false;

   
        }
        else if (e.CommandName == "DeleteUser")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gdvBillingTerm.DataKeys[grdrow.RowIndex].Values["BilingID"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.deleteBillTerm(empid);
            con.deleteBillingTermDetails(empid);
            tbl1.Visible = false;
            Response.Write("<script>alert('Record deleted successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            //ScriptHide();
            LoadGrid();
            btnadd.Visible = true;
        }
    }
    protected void btnadd_Click(object sender, EventArgs e)
    {
        tbl1.Visible = true;
        btnadd.Visible = false;
         gdvBillingTerm.Visible = false;
    }
    protected void ResetAll()
    {
        txtname.Text = null;
        hfBillTermId.Value = null;
        txtrate.Text = null;
        txtdesc.Text = null;
        ddlSequence.Items.Clear();
        chkisAdd.Checked = false;
     
    }
    protected void ResetSequence()
    {
        ddlSequence.Items.Clear();
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        tbl1.Visible = false;
         gdvBillingTerm.Visible = true;
        btnadd.Visible = true;
        ResetAll();
        BindSequence();
    }
}