using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
using System.IO;


public partial class Modules_ROCompanyInfo_companyInfoView : BaseAdministrationUserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.validate.js");
        //IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");            
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        tbl1.Visible = false;

        if (!IsPostBack)
        {
            BindDropdownList();

        }
        BindGrid();
    }

    private void BindGrid()
    {
        List<companyInfo> info1 = new List<companyInfo>();
        RestrOrderController con = new RestrOrderController();

        info1 = con.getcompanyInfo();
        gvcompany.DataSource = info1;
        gvcompany.DataBind();
    }



    protected void gvcompany_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "EditUser")
        {
            tbl1.Visible = true;
            gvcompany.Visible = false;
            List<companyInfo> info1 = new List<companyInfo>();
            RestrOrderController con = new RestrOrderController();
            info1 = con.getcompanyInfo();
            RestrOrderInfo.comId = info1[0].companyId;
            txtcompanyName.Text = info1[0].Name;
            txtadddress.Text = info1[0].Address;
            ImgPrvs.ImageUrl = "~/Modules/ROCompanyInfo/logo/" + info1[0].Logo;
            imageName.Value = info1[0].Logo;
            txtcountry.Text = info1[0].Country;
            txtpanNo.Text = info1[0].PAN;
            txtphoneNo.Text = info1[0].PhoneNo;
            txtregNo.Text = info1[0].RegistrationNo;
            rbVatPan.SelectedValue = (info1[0].IsPan ? "PAN" : "VAT");
            txtCBMSUserName.Text = info1[0].CBMSUserName;
            txtCBMSPassword.Text = info1[0].CBMSPassword;
            txtCode.Text = info1[0].Code;
            bool isAbr = info1[0].IsAbbreviated;
            if (isAbr)
                isAbbreviated.Checked = true;
            else
                isAbbreviated.Checked = false;


            btncancel.Visible = true;
            ddlCurrency.SelectedValue = Convert.ToString(info1[0].CurrencyID);
        }
        else if (e.CommandName == "DeleteUser")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gvcompany.DataKeys[grdrow.RowIndex].Values["companyId"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.deleteCompanyinfo(empid);

            Response.Write("<script>alert('Record deleted secussfully!');</script>");
            gvcompany.DataBind();


        }
    }
    protected void btnsave_Click1(object sender, EventArgs e)
    {



        companyInfo info = new companyInfo();
        RestrOrderController con = new RestrOrderController();
        info.Name = txtcompanyName.Text;
        info.Address = txtadddress.Text;
        gvcompany.Visible = true;
        info.Country = txtcountry.Text;
        info.PAN = txtpanNo.Text;
        info.PhoneNo = txtphoneNo.Text;
        info.RegistrationNo = txtregNo.Text;
        info.IsPan = (rbVatPan.SelectedValue == "PAN" ? true : false);
        info.CurrencyID = Convert.ToInt32(ddlCurrency.SelectedItem.Value);
        info.CBMSUserName = txtCBMSUserName.Text;
        info.CBMSPassword = txtCBMSPassword.Text;
        info.Code = txtCode.Text;
        info.IsAbbreviated = isAbbreviated.Checked ? true : false;

        if (fupUploader.HasFile)
        {
            try
            {
                string filename = Path.GetFileName(fupUploader.FileName);
                fupUploader.SaveAs(Server.MapPath("~/Modules/ROCompanyInfo/logo/") + filename);
                info.Logo = (filename == null) ? imageName.Value : filename;
            }
            catch (Exception ex)
            {

                Response.Write("Upload status: The file could not be uploaded. The following error occured: " + ex.Message);
            }
        }
        else info.Logo = imageName.Value;
        con.saveCompany(info);

        Response.Write("<script>alert('Record saved sucessfully!');</script>");
        BindGrid();
        Reset();
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        Reset();
    }
    private void Reset()
    {
        tbl1.Visible = false;
        btncancel.Visible = false;
        ddlCurrency.SelectedIndex = 0;
        txtcompanyName.Text = "";
        txtadddress.Text = "";
        txtcountry.Text = "";
        txtpanNo.Text = "";
        txtphoneNo.Text = "";
        txtregNo.Text = "";
        gvcompany.Visible = true;
    }
    public void BindDropdownList()
    {
        RestrOrderController roc = new RestrOrderController();
        List<CurrencyClass> currencyList = roc.GetCurrencyFromDatabase();
        ddlCurrency.DataSource = currencyList;
        ddlCurrency.DataTextField = "CurrencyName";
        ddlCurrency.DataValueField = "CurrencyID";
        ddlCurrency.DataBind();
        ddlCurrency.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", string.Empty));

    }


    //protected void rbVatPan_SelectedIndexChanged(object sender, EventArgs e)
    //{
    //    if (rbVatPan.SelectedValue == "PAN")
    //        isAbbreviated.Checked = false;

    //}
}