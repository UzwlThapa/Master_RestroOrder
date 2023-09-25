<%@ WebService Language="C#" Class="wsVoucherType" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Collections.Generic;
using SageFrame.ChartOfAccount;
using Newtonsoft.Json;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class wsVoucherType : System.Web.Services.WebService
{
    [WebMethod]
    public string getVoucherTypeList()
    {
        AccountController con = new AccountController();
        List<VoucherType>  vlist = con.getVoucherTypeList();
            return JsonConvert.SerializeObject(vlist);
    }
    [WebMethod]
    public void saveVoucherType(VoucherType voucher)
    {
        AccountController con = new AccountController();
        con.saveVoucherType(voucher);
    }

    [WebMethod]
    public void deleteVoucherTypeByID(int VoucherTypeID, string username)
    {
        AccountController con = new AccountController();
        con.deleteVoucherTypeByID(VoucherTypeID, username);
    }

}