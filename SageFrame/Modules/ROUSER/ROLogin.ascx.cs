using Newtonsoft.Json;
using SageFrame.RestroOrder;
using SageFrame.Security;
using SageFrame.Security.Entities;
using SageFrame.Security.Helpers;
using System;
using System.IO;
using System.Web.Script.Serialization;
using System.Web.Services;
using SageFrame.Web;
public partial class Modules_ROUSER_ROLogin : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnCheckUser_Click(object sender, EventArgs e)
    {
        try
        {
            //SecurityPolicy objSecurity = new SecurityPolicy();
            string statusUser = LoginUser(txtUser.Text, txtPass.Text);

            dynamic parsedJson = JsonConvert.DeserializeObject(statusUser);
            string jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
            string path = "/Modules/ROGenerateJson/RestrOrder.Json";
            string fullPath = Server.MapPath(path);
            using (var file = new StreamWriter(fullPath, false))
            {
                file.Flush();
                file.Write(jsonFormatted);
                file.Close();
                file.Dispose();
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    [WebMethod]
    public void CheckLogin(string user, string password)
    {
       
    }
    private string LoginUser(string userName, string password)
    {
        string jsonString = null;
        string json = "{'username':'bob@bob.com','password':'Password1'}";
        UserClass userClass = new UserClass();

        MembershipController member = new MembershipController();
        RoleController role = new RoleController();
        UserInfo user = member.GetUserDetails(0, userName);
        //HttpContext.Current.Session[SessionKeys.IsLoginClick] = false;

        JavaScriptSerializer jss = new JavaScriptSerializer();
        userClass = jss.Deserialize<UserClass>(json);
        if (user.UserExists && user.IsApproved)
        {
            if (PasswordHelper.ValidateUser(user.PasswordFormat, password, user.Password, user.PasswordSalt))
            {
                //login is successfull SucessFullLogin(user);
                userClass.Status = "Success";
            }
            else
            {
                userClass.Status = "Failed";
            }
        }
        else
        {
            userClass.Status = "Failed";
        }

        jsonString = jss.Serialize(userClass);
        return jsonString;
    }

}