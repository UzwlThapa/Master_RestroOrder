using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using System.IO;
using System.Text;
using SageFrame.RestroOrder;


public partial class Modules_ROItemDisplay_ROItemDisplay : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
   
    public int userModuleID = 0; public int RowTotal = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        //include css and js
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        IncludeJs("ROItem", "/Modules/ROItemDisplay/bootstrap/js/bootstrap.js"
        ,"/js/jquery.pagination.js"
        , "/Modules/ROItemDisplay/Js/itemscript.js", "/Js/html-table-search.js");

        IncludeCss("ROItem", "/Modules/ROItemDisplay/bootstrap/css/bootstrap.css"
            ,"/Modules/ROItemDisplay/bootstrap/css/module.css");
        modulePath = ResolveUrl(this.AppRelativeTemplateSourceDirectory);
        userModuleID = int.Parse(SageUserModuleID);
        BindImage();
    }

    private void BindImage()
    {
        string[] arrFiles = Directory.GetFiles(Server.MapPath("~/Modules/ROItem/images/"));
        StringBuilder sb = new StringBuilder("<ul id='ulGallery'>");
        RestrOrderController roc = new RestrOrderController();
        List<ItemsClass> itemList = roc.GetItemFromDatabaseByPagination(0,10);
        string itemName = txtSearch.Text;
        List<ItemsClass> itemQuery = new List<ItemsClass>();
        if (!String.IsNullOrEmpty(itemName) && Page.IsPostBack) 
        {
            foreach(ItemsClass item in itemList)
            {
                if(item.ItemName.ToLower().Contains(itemName.ToLower()))
                {
                    itemQuery.Add(item);
                }
            }
            itemList = itemQuery;

        }
         //itemList = itemList.Where(p=>p.ItemName == itemName).ToList();
        sb.Append("<div id='RoImageGallery'><table class='search-table'>");
       
				
        sb.Append("<tbody><tr>");
        var count = 1;
        foreach (ItemsClass item in itemList)
        {
            RowTotal = Convert.ToInt32( item.RowTotal);
            if (!String.IsNullOrWhiteSpace(item.PhotoPath))
            {
                
                ImageButton imgBtn = new ImageButton();
                FileInfo fileInfo = new FileInfo(item.PhotoPath);
                imgBtn.ImageUrl = "~/Modules/ROItem/images/" + fileInfo.Name;
                imgBtn.Height = System.Web.UI.WebControls.Unit.Pixel(100);
                imgBtn.Width = System.Web.UI.WebControls.Unit.Pixel(100);
                imgBtn.Style.Add("padding", "5px");
                //pnlGallery.Controls.Add(imgBtn);
                sb.Append("<td class='item-display-table'><a href='#'><img src=" + Page.ResolveUrl(imgBtn.ImageUrl) + " height='200px' width='300px'/><br/>"
                    + "<ul class='item-display-description'><li class='item-name-dispaly'>" + item.ItemName + "</li><li class='item-price-dollar'>" + " $" + item.Price + "</span></li></ul></a>");
                //sb.Append("<li><a href=" + Page.ResolveUrl(imgBtn.ImageUrl) + "><img src=" + Page.ResolveUrl(imgBtn.ImageUrl) + " height='100px' width='100px'/></a></li>");
                if (count == 3)
                {
                    sb.Append("</tr><tr>");
                    count = 0;
                }
                count++;

            }
        }
        sb.Append("</tr></tbody></table></div><div id='Pagination' class='sfPagination'></div>");
        ltrGallery.Text = sb.ToString();

        //foreach (string _file in arrFiles)
        //{
        //    //create a image button
        //    ImageButton imgBtn = new ImageButton();
        //    FileInfo fileInfo = new FileInfo(_file);
        //    imgBtn.ImageUrl = "~/Modules/ROItem/images/" + fileInfo.Name;

        //    //set image button dimensions
        //    imgBtn.Height = Unit.Pixel(100);
        //    imgBtn.Width = Unit.Pixel(100);
        //    imgBtn.Style.Add("padding", "5px");

        //    //set click url

        //    //hook event handler
        //    //imgBtn.Click += new ImageClickEventHandler(imgBtn_Click);

        //    //add the control to the panel
        //    pnlGallery.Controls.Add(imgBtn);

        //    //create ul li markup
        //    sb.Append("<li><a href=" + Page.ResolveUrl(imgBtn.ImageUrl) + "><img src=" + Page.ResolveUrl(imgBtn.ImageUrl) + " height='100px' width='100px'/></a></li>");

        //}
        //sb.Append("</ul><div class='clearfix'></div>");
        //ltrGallery.Text = sb.ToString(); 
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindImage();
    }
}