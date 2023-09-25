using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
using System.IO;

public partial class Modules_ROCompanyInfo_companyInfoView : BaseAdministrationUserControl
{

    protected void Page_Load(object sender, EventArgs e)
    {
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.validate.js");
        IncludeJs("ROMenu", "/Modules/ROItem/Js/itemscript.js");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/dataTables.jqueryui.css");
        IncludeCss("ROUnit", "/Modules/ROUnit/Js/jquery-ui.css");
        IncludeJs("ROUnit", "/Modules/ROUnit/Js/jquery.dataTables.min.js");
        tbl1.Visible = false;

      
        //if(!IsPostBack)
       

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


    
    //private void ImagePreview()
    //{
    //    string jScript;
    //    jScript = "<script>(function ($) {$('#ImgPrv').show();}(jQuery));</script>";
    //    Page.RegisterClientScriptBlock("keyClientBlock", jScript);
    //    //System.Text.StringBuilder message = new System.Text.StringBuilder();
    //    //message.Append("<script type = 'text/javascript'>");

    //    //message.Append("$('#ImgPrv').show();");
    //    //message.Append("</script>");
    //    ////Response.Write("<script>$('#ImgPrv').show();</script>");
    //    //Page.ClientScript.RegisterClientScriptBlock(this.GetType(),"script", message.ToString());
    //}

    protected void gvcompany_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        //imgEdit.Attributes.Add("onClick", "return false;");

        if (e.CommandName == "EditUser")
        {
            tbl1.Visible = true;
            List<companyInfo> info1 = new List<companyInfo>();
            RestrOrderController con = new RestrOrderController();
            info1 = con.getcompanyInfo();
            RestrOrderInfo.comId = info1[0].companyId;
            //List<companyInfo> info1 = new List<companyInfo>();
            txtcompanyName.Text = info1[0].Name;
            txtadddress.Text = info1[0].Address;
            //fupUploader.FileContent = Convert.ToSByte("~/Modules/ROCompanyInfo/logo/" + info1[0].Logo); 
            ImgPrvs.ImageUrl = "~/Modules/ROCompanyInfo/logo/" + info1[0].Logo;
            //fupUploader. = info1[0].Logo;
            //txtlogo.Text = info1[0].Logo;
            imageName.Value = info1[0].Logo;
            txtcountry.Text = info1[0].Country;
            txtpanNo.Text = info1[0].PAN;
            txtphoneNo.Text = info1[0].PhoneNo;
            txtregNo.Text = info1[0].RegistrationNo;
            //ddlCurrency.SelectedIndex = info1[0].CurrencyID;
            btncancel.Visible = true;
            //btnadd.Visible = false;
            ddlCurrency.SelectedValue = Convert.ToString(info1[0].CurrencyID);
            //ImgPrvs.Attributes.Add("style", "display:block");
            
            //ImagePreview();
            //Response.Write("<script>(function ($) {$('#ImgPrv').show();}(jQuery));</script>");

            //table2.Visible = true;
            //btnadd.Visible = false;
        }
        else if (e.CommandName == "DeleteUser")
        {

            LinkButton btn = (LinkButton)e.CommandSource;
            GridViewRow grdrow = ((GridViewRow)btn.NamingContainer);
            int empid = Convert.ToInt32(gvcompany.DataKeys[grdrow.RowIndex].Values["companyId"].ToString());
            RestrOrderController con = new RestrOrderController();
            con.deleteCompanyinfo(empid);

                        
            Response.Write("<script>jAlert('Record deleted secussfully!', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");
            gvcompany.DataBind();


        }
    }
    protected void btnsave_Click1(object sender, EventArgs e)
    {
        companyInfo info = new companyInfo();
        RestrOrderController con = new RestrOrderController();
        info.Name = txtcompanyName.Text;
        info.Address = txtadddress.Text;
        //if(fupUploader.HasFile==true)
        //info.Logo = fupUploader.FileName;
        info.Country = txtcountry.Text;
        info.PAN = txtpanNo.Text;
        info.PhoneNo = txtphoneNo.Text;
        info.RegistrationNo = txtregNo.Text;
        info.CurrencyID = Convert.ToInt32(ddlCurrency.SelectedItem.Value);

        if (fupUploader.HasFile)
        {
            try
            {
                string filename = Path.GetFileName(fupUploader.FileName);
                fupUploader.SaveAs(Server.MapPath("~/Modules/ROCompanyInfo/logo/") + filename);
                info.Logo = (filename == null) ? imageName.Value : filename;
                //StatusLabel.Text = "Upload status: File uploaded!";
            }
            catch (Exception ex)
            {

                Response.Write("Upload status: The file could not be uploaded. The following error occured: " + ex.Message);
                //StatusLabel.Text = "Upload status: The file could not be uploaded. The following error occured: " + ex.Message;
            }
        }
        else info.Logo = imageName.Value;
        con.saveCompany(info);
        BindGrid();

        Response.Write("<script>jAlert('Record Saved successfully', 'Information!!', function () { $.alerts.dialogClass = null; });</script>");

    }
    //protected void btnadd_Click(object sender, EventArgs e)
    //{
    //    tbl1.Visible = true;
    //    btnadd.Visible = false;
    //    btncancel.Visible = true;
    //    Response.Write("<script></script>");
    //    //ImgPrvs.Attributes.Add("style", "display:none");
       
    //}
    protected void btncancel_Click(object sender, EventArgs e)
    {
        tbl1.Visible = false;
        btncancel.Visible = false;
        //btnadd.Visible = true;
        ddlCurrency.SelectedIndex = 0;
        txtcompanyName.Text = "";
        txtadddress.Text = "";
        txtcountry.Text = "";
        //txtlogo.Text = "";
        txtpanNo.Text = "";
        txtphoneNo.Text = "";
        txtregNo.Text = "";
       
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


    //protected void Upload(object sender, EventArgs e)
    //{
    //    Session["Image"] = fupUploader.PostedFile;
    //    Stream fs = fupUploader.PostedFile.InputStream;
    //    BinaryReader br = new BinaryReader(fs);
    //    byte[] bytes = br.ReadBytes((Int32)fs.Length);
    //    string base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
    //    Image1.ImageUrl = "data:image/png;base64," + base64String;
    //    Panel1.Visible = true;
    //}
    //protected void Save(object sender, EventArgs e)
    //{
    //    HttpPostedFile postedFile = (HttpPostedFile)Session["Image"];
    //    postedFile.SaveAs(Server.MapPath("~/Uploads/") + Path.GetFileName(postedFile.FileName));
    //    Response.Redirect(Request.Url.AbsoluteUri);
    //}
    //protected void Cancel(object sender, EventArgs e)
    //{
    //    Response.Redirect(Request.Url.AbsoluteUri);
    //}
    //protected void btnUpload_Click(object sender, EventArgs e)
    //{
    //    Session["Image"] = fupUploader.PostedFile;
    //    Stream fs = fupUploader.PostedFile.InputStream;
    //    BinaryReader br = new BinaryReader(fs);
    //    byte[] bytes = br.ReadBytes((Int32)fs.Length);
    //    string base64String = Convert.ToBase64String(bytes, 0, bytes.Length);
    //    Image1.ImageUrl = "data:image/png;base64," + base64String;
    //    //Panel1.Visible = true;
    //}
}