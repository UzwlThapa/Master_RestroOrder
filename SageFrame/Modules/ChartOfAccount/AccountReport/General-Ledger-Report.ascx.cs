using SageFrame.ChartOfAccount;
using SageFrame.Web;
using System;
using System.Collections.Generic;

public partial class Modules_ChartOfAccount_AccountReport_VoucherReport : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
    public int userModuleID = 0;
    public string FinancialID = string.Empty;
    public string Fromdate = string.Empty;
    public string Todate = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        FinancialID = Request.QueryString["ID"];
        Fromdate = Request.QueryString["Fromdate"];
        Todate = Request.QueryString["Todate"];
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("", "/js/jsPDF.js");
        IncludeJs("AccountReport", "/Modules/ChartOfAccount/AccountReport/js/General-Ledger-Report.js");
        IncludeJs("jsCounterPerson", "/Modules/Roi_CounterPerson/jquery.dataTables.min.js");
        IncludeCss("CssCounterPerson", "/Modules/Roi_CounterPerson/dataTables.jqueryui.css");
        // BindVoucherSelectList();
        CompanyName = GetApplicationName;

    }

    //private void BindVoucherSelectList()
    //{

    //    AccountController controller = new AccountController();
    //    List<VoucherType> voucherlist = controller.getVoucherTypeList();
    //    voucherDropDownList.DataTextField = "VoucherName";
    //    voucherDropDownList.DataValueField = "VoucherTypeID";
    //    voucherDropDownList.DataSource = voucherlist;
    //    voucherDropDownList.DataBind();


    //}

    public string CompanyName { get; set; }
}