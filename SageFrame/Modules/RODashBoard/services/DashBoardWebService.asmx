<%@ WebService Language="C#"  Class="DashBoardWebService" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;

/// <summary>
/// Summary description for DashBoardWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class DashBoardWebService : System.Web.Services.WebService {

    public DashBoardWebService () {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    
      [WebMethod]
    public List<RestroRoom> GetRoomByRoomTypeId(string RoomTypeID)
    {
        RestrOrderController controller = new RestrOrderController();
        return controller.GetRoomByRoomTypeId(int.Parse(RoomTypeID));
          
    }
    
    
    
    
}
