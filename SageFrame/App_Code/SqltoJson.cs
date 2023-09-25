using System.Collections.Generic;
using System.Web.Script.Serialization;
using SageFrame.RestroOrder;

/// <summary>
/// Summary description for SqltoJson
/// </summary>
public class SqltoJson
{

    //public static string SqltoJsonConverter()
    //{
    //    string jsonString = "";

    //    RestrOrderController rocobj = new RestrOrderController();
    //    List<ROGETITEMResult> ItemForJson = rocobj.GetItemJsonFromDatabase();
    //    //  Employee employee = new Employee();
    //    //JavaScriptS
    //    JavaScriptSerializer jss = new JavaScriptSerializer();
    //    jsonString = jss.Serialize(ItemForJson);
    //    return jsonString;
    //}
    public static string SqltoJsonConverter(List<ROGETITEMResulttest> ItemForJson)
    {
        
        string jsonString = "";
        JavaScriptSerializer jss = new JavaScriptSerializer();
     //jsonString=   JsonConvert.DeserializeObject<RootObject>(data); 
       jsonString = jss.Serialize(ItemForJson);
        return jsonString;
    }
    public static void JsontoSqlConverter( string json) 
    {
         json = "[{'EmployeeId':1,'EmployeeName':'Ram','EmployeeAddress':'Pokhara','EmployeeCategory':'Developer'},{'EmployeeId':2,'EmployeeName':'Shyam','EmployeeAddress':'Dharan','EmployeeCategory':'Programmer'},{'EmployeeId':3,'EmployeeName':'Hari','EmployeeAddress':'Lahan','EmployeeCategory':'Designer'},{'EmployeeId':4,'EmployeeName':'Ryan','EmployeeAddress':'Kathmandu','EmployeeCategory':'DatabaseAdministrator'},{'EmployeeId':5,'EmployeeName':'Sudarshan','EmployeeAddress':'Siligudi','EmployeeCategory':'Project Manager'},{'EmployeeId':6,'EmployeeName':'Sudarshan','EmployeeAddress':'Siligudi','EmployeeCategory':'Project Manager'},{'EmployeeId':7,'EmployeeName':'Sudarshan','EmployeeAddress':'Siligudi','EmployeeCategory':'Project Manager'},{'EmployeeId':8,'EmployeeName':'Sudarshan','EmployeeAddress':'Siligudi','EmployeeCategory':'Project Manager'},{'EmployeeId':9,'EmployeeName':'Sudarshan','EmployeeAddress':'Siligudi','EmployeeCategory':'Project Manager'},{'EmployeeId':10,'EmployeeName':'Sudarshan','EmployeeAddress':'Siligudi','EmployeeCategory':'Project Manager'}]";
        JavaScriptSerializer jss = new JavaScriptSerializer();


        List<ROGETITEMResult> lstEmployee = jss.Deserialize<List<ROGETITEMResult>>(json);
        ROGETITEMResult newEmployee = new ROGETITEMResult();
        //foreach (ROGETITEMResult employee in lstEmployee)
        //{
        //    //newEmployee.EmployeeName = employee.EmployeeName;
        //    //newEmployee.EmployeeAddress = employee.EmployeeAddress;
        //    //newEmployee.EmployeeCategory = employee.EmployeeCategory;

        //    //.Insert(newEmployee);
        //    //lblJson.Text += employee.EmployeeName + "<br/>" + employee.EmployeeAddress + "<br/>" + employee.EmployeeCategory + "<br/>";

        //    // newEmployee = null;
        //}
    }

}