using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using SageFrame.RestroOrder;
using SageFrame.Web;
using System.IO;
using Newtonsoft.Json;

public partial class Modules_ROGenerateJson_ROGenerateJson : BaseAdministrationUserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnJson_Click(object sender, EventArgs e)
    {
        RestrOrderController rocobj = new RestrOrderController();
        List<ROGETITEMResulttest> ItemList = rocobj.GetItemJsonFromDatabase();
        Literal lbl = new Literal();
        SqltoJson stj = new SqltoJson();
        string testJson = SqltoJson.SqltoJsonConverter(ItemList);

        dynamic parsedJson = JsonConvert.DeserializeObject(testJson);
        string jsonFormatted = JsonConvert.SerializeObject(parsedJson, Formatting.Indented);
        jsonFormatted = jsonFormatted.Trim().Substring(1,jsonFormatted.Length-2);

      //  File txt = File.WriteAllText(testJson);
      //  lbl.Text = testJson;
        lbl.Text = "Menu Item has been Updated" + "<br>";
        lbl.Text += jsonFormatted.ToString();
        
        pnlJson.Controls.Add(lbl);
        

        //E:/Microsoft/DanfeSolution/RestroOrder/RestroOrder
        string path = "/Modules/ROGenerateJson/RestrOrder.Json";
        string fullPath = Server.MapPath(path);
        using (var file = new StreamWriter(fullPath, false))
        {
            file.Flush();
            file.Write(jsonFormatted);
            file.Close();
            file.Dispose();
        }
        
        //Response.Redirect(path);
      //  return true;
    }
}