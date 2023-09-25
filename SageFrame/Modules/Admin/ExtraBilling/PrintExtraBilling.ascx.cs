using System;
using System.Collections.Generic;
using SageFrame.RestoLoyalty;
using System.Text;
using System.Web.UI.HtmlControls;
using SageFrame.Web;
public partial class Modules_ExtraBilling_PrintExtraBilling : BaseUserControl
{


    protected void Page_Load(object sender, EventArgs e)
    {
        
        RestoLoyaltyController sExpCon = new RestoLoyaltyController();
        List<ExtraBilling> expInfo = new List<ExtraBilling>();
        string eid = Request.QueryString["eID"];
        expInfo = sExpCon.GetExtraBillingList(eid);


            StringBuilder sb = new StringBuilder();
            // var val = "";
            HtmlMeta metatitle = new HtmlMeta();
            metatitle.Attributes.Add("property", "og:title");
            sb.Append("<div id='print'; style='text-align:center;width:100%;'>");
            sb.Append("<table style='width:100%;padding-bottom:5px;text-align:center;border-bottom:1px dotted;'>");

            sb.Append("<tr>");
            sb.Append("<td style='font-size:22px;text-align:left;'>Customer Name: " + expInfo[0].CustomerName + "</td>");
            sb.Append("<td style='font-size:22px;text-align:right;'>Issue Date: " + expInfo[0].IssueDate + "</td>");
            sb.Append("</tr>");
            //sb.Append("<tr>");
            //sb.Append("<td style='font-size:18px;text-align:center;'>Issue Date: " + expInfo[0].IssueDate + "</td>");
            //sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:18px;text-align:left;'>Pan: " + expInfo[0].Pan + "</td>");
            sb.Append("</tr>");

            sb.Append("<tr>");
            sb.Append("<td style='font-size:25px;text-align:left;'>Item </td>");
            sb.Append("<td style='font-size:25px;text-align:centre;'>Rate </td>");
            sb.Append("<td style='font-size:25px;text-align:right;'>Quantity </td>");

            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("</tr>");

            foreach (var item in expInfo)
            {
           
            sb.Append("<tr>");
            sb.Append("<td style='font-size:18px;text-align:left;'> " + item.Item + "</td>");
            sb.Append("<td style='font-size:18px;text-align:centre;'> " + item.Rate + "</td>");
            sb.Append("<td style='font-size:18px;text-align:right;'> " + item.Quantity + "</td>");
                
            sb.Append("</tr>");
            }
            sb.Append("<tr>");
            sb.Append("<td style='font-size:18px;text-align:right;'>Net Total: " + expInfo[0].NetTotal + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:18px;text-align:right;'>Discount (%): " + expInfo[0].Discount + "</td>");
            sb.Append("</tr>");
            sb.Append("<td style='font-size:18px;text-align:right;'>Vat (%): " + expInfo[0].Vat + "</td>");
            sb.Append("</tr>");
            sb.Append("<tr>");
            sb.Append("<td style='font-size:18px;text-align:right;'>Grand Total: " + expInfo[0].GrandTotal + "</td>");
            sb.Append("</tr>");

            //sb.Append("<td style='font-size:15px;text-align:left;'>" + expInfo.Description + "</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("</div>");
            PrintHtml.Text = sb.ToString();
           // printablehtml = sb.ToString();       
     //   }


    }
}