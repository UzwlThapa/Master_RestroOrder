using Microsoft.SqlServer.Server;
using Newtonsoft.Json;
using OfficeOpenXml.FormulaParsing.Excel.Functions.Numeric;
using SageFrame.RestroOrder;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;

/// <summary>
/// Summary description for SMS
/// </summary>
public class SMS
{
    public string apiURL;
    public SMS()
    {
        apiURL = ConfigurationManager.AppSettings["SMS_APIUrl"].ToString(); // "http://aakashsms.com/admin/public/sms/v1/";
    }

    public string PostSMS(string number, string message)
    {

        string authentication_token = ConfigurationManager.AppSettings["Authentication_Token"].ToString();//           ";
        using (var client = new HttpClient())
        {
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            SMSSend s = new SMSSend();
            {
                s.auth_token = authentication_token;
                s.to = number;
                s.text = message;

            };
            client.BaseAddress = new Uri(apiURL);
            string resultMessage = "";
            try
            {
                HttpResponseMessage response = client.PostAsJsonAsync(apiURL, s).Result;
                if (response.IsSuccessStatusCode)
                {
                    resultMessage = "SMS Sent Sucessfully.";
                    RestrOrderController roc = new RestrOrderController();
                    int smsID = roc.savePostedSMS(number, message);
                    return resultMessage;
                }
                else
                {
                    var resultString = response.Content.ReadAsStringAsync().Result;
                    var result = JsonConvert.DeserializeObject<SMSResponse>(resultString);
                    resultMessage = result.response;
                    return resultMessage;
                }
            }
            catch (Exception)
            {
                resultMessage = "Error While sending message. Try Again.";
                return resultMessage;
            }
        }
    }
}