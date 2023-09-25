using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using SageFrame.Web;
using SageFrame.RestroOrder;
using System.IO;
using System.Text;

public partial class Modules_RODashBoard_RODashBoard : BaseAdministrationUserControl
{
    public string modulePath = string.Empty;
   
    public int userModuleID = 0; public int RowTotal = 0;
    private int counter = 0;
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
        //BindRoomType();
        if (!IsPostBack)
        {
            BindImage();
        }

        BindRoom();


    }

    //private void BindRoomType()
    //{
    //    RestrOrderController roc = new RestrOrderController();
    //    List<RoomType> Roomtypes = new List<RoomType>();
    //    Roomtypes = roc.getRoomType();
    //    StringBuilder str = new StringBuilder();
    //    str.Append("<ul>");
    //    foreach (RoomType type in Roomtypes)
    //    {
    //        str.Append("<li>");
    //        str.Append("<a id ='" + type.RoomTypeID + "_img' class = 'imgroomtype' ><img src='"+ GetHostURL() +"/Modules/RODashBoard/image/Room.png' alt=" + type.Title + " height='60px' width = '60px'></a> ");
    //        str.Append("<h3>" + type.Title + "</h3>");
    //        str.Append("</li>");



    //        //create a image button
    //        ImageButton imgBtn1 = new ImageButton();
    //        FileInfo fileInfo = new FileInfo(type.Title);
    //        imgBtn1.ImageUrl = "~/Modules/RODashBoard/image/Room.png";

    //        //set image button dimensions
    //        imgBtn1.Height = Unit.Pixel(100);
    //        imgBtn1.Width = Unit.Pixel(100);
    //        imgBtn1.Style.Add("padding", "5px");
    //        //imgBtn1.ID = "btn" + counter;
    //        imgBtn1.ID = Convert.ToString(type.RoomTypeID);
    //        counter++;
    //        //set click url

    //        //hook event handler
    //        imgBtn1.Click += new ImageClickEventHandler(imgroomtypeBtn_Click);
    //        Literal litRoomName = new Literal();
    //        litRoomName.Text = "<ul><li>" + type.Title + "</ul></li>";
    //        //add the control to the panel
    //        pnlGallery.Controls.Add(imgBtn1);
    //        pnlGallery.Controls.Add(litRoomName);

    //        //create ul li markup
    //        sb.Append("<li><ul><li>" + room.restroRoom + "</li></ul><img src=" + Page.ResolveUrl(imgBtn1.ImageUrl) + " height='100px' width='100px'/></li>");
    //    }
    //    str.Append("</ul>");

    //    ltrRoomType.Text = str.ToString();
    //}

    private void imgroomtypeBtn_Click(object sender, ImageClickEventArgs e)
    {
        throw new NotImplementedException();
    }

    private void BindRoom()
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestroRoom> roomList = roc.getRestroRoom();
        StringBuilder sb = new StringBuilder();
        sb.Append("<ul>");
        foreach (RestroRoom room in roomList)
        {
            //create a image button
            ImageButton imgBtn1 = new ImageButton();
            FileInfo fileInfo = new FileInfo(room.restroRoom);
            imgBtn1.ImageUrl = "~/Modules/RODashBoard/image/Room.png";

            //set image button dimensions
            imgBtn1.Height = System.Web.UI.WebControls.Unit.Pixel(100);
            imgBtn1.Width = System.Web.UI.WebControls.Unit.Pixel(100);
            imgBtn1.Style.Add("padding", "5px");
            //imgBtn1.ID = "btn" + counter;
            imgBtn1.ID = Convert.ToString(room.restroRoomId);
            counter++;
            //set click url

            //hook event handler
            imgBtn1.Click += new ImageClickEventHandler(imgBtn_Click);
            Literal litRoomName = new Literal();
            litRoomName.Text = "<ul><li>" + room.restroRoom + "</ul></li>";
            //add the control to the panel
            pnlGallery.Controls.Add(imgBtn1);
            pnlGallery.Controls.Add(litRoomName);

            //create ul li markup
            sb.Append("<li><ul><li>" + room.restroRoom + "</li></ul><img src=" + Page.ResolveUrl(imgBtn1.ImageUrl) + " height='100px' width='100px'/></li>");

        }
        sb.Append("</ul><div class='clearfix'></div>");
        //litRoom.Text = sb.ToString(); 
    }

    private void imgBtn_Click(object sender, ImageClickEventArgs e)
    {
        RestrOrderController roc = new RestrOrderController();
        List<RestroRoom> roomList = roc.getRestroRoom();
        ImageButton btn = (ImageButton)sender;
        foreach(RestroRoom room in roomList)
        {
            if (btn.ID == Convert.ToString(room.restroRoomId)) 
            {
                BindImage(room.restroRoomId);
                txtSearch.Text = "<h3><b>Room Number:" + room.restroRoom + "</b></h3>";
                break;
            }
        }
        
    }

    private void BindImage(int p)
    {
        string[] arrFiles = Directory.GetFiles(Server.MapPath("~/Modules/ROItem/images/"));
        StringBuilder sb = new StringBuilder("<ul id='ulGallery'>");
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> tableList = roc.GetTableByRoomId(p);

        string itemName = txtSearch.Text;
        List<ItemsClass> tablequery = new List<ItemsClass>();
        
        sb.Append("<div id='RoImageGallery'><table class='search-table'>");


        sb.Append("<tbody><tr>");
        var count = 1;
        foreach (restroTable table in tableList)
        {
            if (!String.IsNullOrWhiteSpace(table.restrotableTitle))
            {
                ImageButton imgBtn = new ImageButton();
                FileInfo fileInfo = new FileInfo(table.restrotableTitle);
                imgBtn.ImageUrl = "/Modules/RODashBoard/image/trestle-restaurant-dining-table-wood.png";
                imgBtn.Height = System.Web.UI.WebControls.Unit.Pixel(50);
                imgBtn.Width = System.Web.UI.WebControls.Unit.Pixel(50);
                imgBtn.Style.Add("padding", "5px");
                
                sb.Append("<td class='item-display-table'><a href='#'><ul><li>" + table.restrotableTitle + "</li></ul><img src=" + Page.ResolveUrl(imgBtn.ImageUrl) + " height='55px' width='55px'/><br/>"
                    + "</a>");
                if (count == 5)
                {
                    sb.Append("</tr><tr>");
                    count = 0;
                }
                count++;
            }
        }
        sb.Append("</tr></tbody></table></div><div id='Pagination' class='sfPagination'></div>");
        ltrGallery.Text = sb.ToString();
    }

    private void BindImage()
    {
        string[] arrFiles = Directory.GetFiles(Server.MapPath("~/Modules/ROItem/images/"));
        StringBuilder sb = new StringBuilder("<ul id='ulGallery'>");
        RestrOrderController roc = new RestrOrderController();
        List<restroTable> tableList = roc.getRestroTable();
        
        string itemName = txtSearch.Text;
        List<ItemsClass> tablequery = new List<ItemsClass>();
        //if (!String.IsNullOrEmpty(itemName) && Page.IsPostBack) 
        //{
        //    foreach(ItemsClass item in itemList)
        //    {
        //        if(item.ItemName.ToLower().Contains(itemName.ToLower()))
        //        {
        //            itemQuery.Add(item);
        //        }
        //    }
        //    itemList = itemQuery;

        //}
         //itemList = itemList.Where(p=>p.ItemName == itemName).ToList();
        sb.Append("<div id='RoImageGallery'><table class='search-table'>");
       
				
        sb.Append("<tbody><tr>");
        var count = 1;
        foreach (restroTable table in tableList)
        {
            //RowTotal = item.RowTotal;
            if (!String.IsNullOrWhiteSpace(table.restrotableTitle))
            {
                ImageButton imgBtn = new ImageButton();
                FileInfo fileInfo = new FileInfo(table.restrotableTitle);
                imgBtn.ImageUrl = "/Modules/RODashBoard/image/trestle-restaurant-dining-table-wood.png";
                imgBtn.Height = System.Web.UI.WebControls.Unit.Pixel(50);
                imgBtn.Width = System.Web.UI.WebControls.Unit.Pixel(50);
                imgBtn.Style.Add("padding", "5px");
                //pnlGallery.Controls.Add(imgBtn);
                sb.Append("<td class='item-display-table'><a href='#'><ul><li>" + table.restrotableTitle + "</li></ul><img src=" + Page.ResolveUrl(imgBtn.ImageUrl) + " height='55px' width='55px'/><br/>"
                    + "</a>");
                //sb.Append("<li><a href=" + Page.ResolveUrl(imgBtn.ImageUrl) + "><img src=" + Page.ResolveUrl(imgBtn.ImageUrl) + " height='100px' width='100px'/></a></li>");
                if (count == 5)
                {
                    sb.Append("</tr><tr>");
                    count = 0;
                }
                count++;
            }
        }
        sb.Append("</tr></tbody></table></div><div id='Pagination' class='sfPagination'></div>");
        ltrGallery.Text = sb.ToString();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        BindImage();
    }
}
