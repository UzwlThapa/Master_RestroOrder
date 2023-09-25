using SageFrame.Web;
using System;

public partial class Modules_CustomerCredit_ViewCustomerCredit : BaseAdministrationUserControl
{

    public string modulePath = string.Empty;
    public string Username = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        Username = GetUsername;
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);

        IncludeJs("CustomerCredit", "/Modules/CustomerCredit/Script/CustomerScript.js");

       
    }
}