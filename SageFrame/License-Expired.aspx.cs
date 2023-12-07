using System;
//using System.Configuration;
//using System.Web;
//using RestroOrder.Licensing;

public partial class License_Expired : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //int daysLeft = 0;
        //string companyCode = ConfigurationManager.AppSettings["CompanyCode"].ToString();
        //string licenseFilePath = HttpContext.Current.Server.MapPath("~/") + @"License.lic";
        //try
        //{
        //    daysLeft = License.DaysLeft(licenseFilePath, companyCode);
        //}
        //catch (Exception ex)
        //{
        //    throw ex;
        //}
        //if (daysLeft > 0)
        //{
        //    divDaysLeft.Visible = true;
        //    divLicenseExpire.Visible = false;
        //    lblDaysLeft.Text = daysLeft.ToString();
        //}
        //else
        //{
        //    divDaysLeft.Visible = false;
        //    divLicenseExpire.Visible = true;
        //}
    }

    //protected void btnSaveLincense_Click(object sender, EventArgs e)
    //{
    //    if (License.IsLicenseValid(txtLicenseKey.Text, "1001"))
    //    { 
    //        string companyCode = ConfigurationManager.AppSettings["CompanyCode"].ToString();
    //        string licenseFilePath = HttpContext.Current.Server.MapPath("~/") + @"License.lic";
    //        License.WriteLicenseKey(txtLicenseKey.Text, licenseFilePath);
    //        lblKey.Text = "";
    //        Response.Redirect("~/");
    //    }
    //    else
    //    {
    //        lblKey.Text = "Provided key is not valid!";
    //    }
    //}
}