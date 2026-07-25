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
    public string GetRoomByRoomTypeId(string RoomTypeID)
    {
        try
        {
            int roomTypeId;
            if (!int.TryParse(RoomTypeID, out roomTypeId) || roomTypeId <= 0)
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(new { success = false, message = "Invalid RoomTypeID: " + RoomTypeID, data = new List<RestroRoom>() });
            }
            
            RestrOrderController controller = new RestrOrderController();
            var rooms = controller.GetRoomByRoomTypeId(roomTypeId);
            if (rooms == null)
            {
                rooms = new List<RestroRoom>();
            }
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { success = true, message = "", data = rooms });
        }
        catch (Exception ex)
        {
            // Log the error for debugging
            string logPath = HttpContext.Current.Server.MapPath("~/App_Data/OrderLogs");
            if (!System.IO.Directory.Exists(logPath))
            {
                System.IO.Directory.CreateDirectory(logPath);
            }
            string logFile = System.IO.Path.Combine(logPath, "RODashboardError_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".txt");
            string logContent = "RODashBoard GetRoomByRoomTypeId Error\n" +
                               "Time: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "\n" +
                               "RoomTypeID: " + RoomTypeID + "\n" +
                               "Exception: " + ex.ToString() + "\n" +
                               "StackTrace: " + ex.StackTrace + "\n\n";
            System.IO.File.AppendAllText(logFile, logContent);
            
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { success = false, message = "Error loading rooms: " + ex.Message, data = new List<RestroRoom>() });
        }
    }
    
    
    
    
}
