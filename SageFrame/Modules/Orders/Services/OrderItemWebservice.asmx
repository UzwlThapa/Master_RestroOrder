<%@ WebService Language="C#" Class="OrderItemWebservice" %>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using SageFrame.RestroOrder;
using SageFrame.CostCenter;
using System.Drawing.Printing;
using System.Text;
using System.Drawing;
using System.IO;
/// <summary>
/// Summary description for OrderItemWebserviceSaveOrderIntoDataBase
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class OrderItemWebservice : System.Web.Services.WebService
{
    string newFileName;
    string BarnewFileName;
    string dateString;
    public OrderItemWebservice()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    [WebMethod]
    public List<MenuClass> GetMenuforOrder()
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetMenuFromDatabase();

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public List<ClassforMenuItem> GetMenuforOrder1(int pitId, int level)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetMenuFromDatabase1(pitId, level);

        }
        catch (Exception)
        {

            throw;
        }

    }
    [WebMethod]
    public List<CategoriesClass> GetCategoriesBymenuID(int MenuId, int languageid)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetCategoriesBymenuID(MenuId, 0);

        }
        catch (Exception)
        {

            throw;
        }

    }


    [WebMethod]
    public List<ItemsClass> GetItemByCategoryID(int CategoriesID, int LanguageID)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            return rocobj.GetItemByCategoryID(CategoriesID, 0);

        }
        catch (Exception)
        {

            throw;
        }

    }

    //[WebMethod]
    //public void SaveOrderIntoDataBase(List<OrderDetailClass> orderDetailsList)
    //{
    //    try
    //    {
    //        RestrOrderController rocobj = new RestrOrderController();
    //        //rocobj.SaveOrderIntoDataBase(OrderMasterInf);

    //    }
    //    catch (Exception)
    //    {

    //        throw;
    //    }

    //}

    [WebMethod]
    public List<ItemsClass> GetPreviousItemByID(int Id, int RId)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            List<ItemsClass> itemList = new List<ItemsClass>();

            restroTable table = new restroTable();
            RestroRoom room = new RestroRoom();
            if (Id != 0)
            {
                itemList = rocobj.GetPreviousItemByID(Id);
                table = rocobj.GetTableNoBYId(Id);
            }
            else if (RId != 0)
            {
                itemList = rocobj.GetPreviousItemByRoomID(RId);
                room = rocobj.GetRoomNoBYId(RId);
            }
            if (itemList.Count > 0)
            {
                foreach (ItemsClass item in itemList)
                {
                    item.restrotableTitle = table.restrotableTitle;

                    if (String.IsNullOrEmpty(room.restroRoom))
                    {
                        room = rocobj.GetRoomByTable(item.TableId);
                    }
                    item.room = room.restroRoom;
                }
            }
            else
            {
                ItemsClass item = new ItemsClass();
                item.restrotableTitle = table.restrotableTitle;
                item.TableId = Id;

                if (String.IsNullOrEmpty(room.restroRoom))
                {
                    room = rocobj.GetRoomByTable(Id);
                }
                item.room = room.restroRoom;
                item.RoomId = RId;
                itemList.Add(item);
            }
            return itemList;
        }
        catch (Exception)
        {
            throw;
        }

    }

    //[WebMethod]
    //public List<ItemsClass> GetRoomAndTable(int Id, int RId)
    //{
    //    try
    //    {
    //        restroTable table = new restroTable();
    //        RestroRoom room = new RestroRoom();
    //        table = rocobj.GetTableNoBYId(Id);

    //    }
    //    catch (Exception)
    //    {
    //        throw;
    //    }
    //}

    [WebMethod]
    public void SaveOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();


            //added for rate and amount
            List<OrderDetailClass> orderDetailList = new List<OrderDetailClass>();
            orderDetailList = orderMasterInfo.OrderDetailsList;
            if (orderMasterInfo.TableId == "0" && orderMasterInfo.RoomId == 0 && orderMasterInfo.OID == 0) return;
            orderMasterInfo.Date = DateTime.Now;
            List<ItemsClass> itemList = rocobj.GetItemFromDatabase();
            decimal BasicAmount = 0;
            string status = string.Empty;
            foreach (OrderDetailClass orderDetail in orderDetailList)
            {
                foreach (ItemsClass item in itemList)
                {
                    if (item.ItemID != orderDetail.ItemId) continue;
                    orderDetail.Rate = item.Price;
                    orderDetail.Amount = item.Price * Convert.ToDecimal(orderDetail.Quantity);
                    BasicAmount += orderDetail.Amount;
                    status += orderDetail.Status;
                    //orderDetail.Note = "";
                    //orderDetail.ExtraCharge = Convert.ToDecimal(0);
                    break;
                }
                //if (json1.IsCancelled == true)
                //{
                //        rocobj.DeleteOrderDetail(json1);
                //}
            }
            RestroRoom room = new RestroRoom();
            if (orderMasterInfo.RoomId == 0)
            {
                if (orderMasterInfo.OID == null)
                {
                    if (orderMasterInfo.TableId != "0")
                    {
                        room = rocobj.GetRoomByTable(Convert.ToInt32(orderMasterInfo.TableId));

                    }
                    else
                    {
                        room = rocobj.getRestroRoomById(Convert.ToInt32(orderMasterInfo.RoomId));
                    }
                    orderMasterInfo.RoomId = room.restroRoomId;
                    orderMasterInfo.restroRoom = room.restroRoom;
                }
            }

            //  var json1 = JsonConvert.DeserializeObject<OrderMasterClass>(json);
            orderMasterInfo.BillNo = "RO" + orderMasterInfo.Date.ToString().Replace("/", "").Replace("PM", "").Replace("AM", "").Replace(":", "").Replace(" ", "");
            orderMasterInfo.BasicAmount = BasicAmount;
            //orderMasterInfo.TermAmount = BasicAmount;
            if (orderMasterInfo.BillPaid == null)
            {
                orderMasterInfo.BillPaid = 0;
            }
            orderMasterInfo.Status = status;
            if (String.IsNullOrEmpty(orderMasterInfo.Remarks))
                orderMasterInfo.Remarks = "Fine";

            var repeateditem = new List<OrderDetailClass>();
            List<OrderDetailClass> lst = new List<OrderDetailClass>();
            lst = rocobj.GetOrderDetailsByMaster(orderMasterInfo.OrderMasterID);
            foreach (OrderDetailClass item in lst)
            {
                repeateditem.Add(new OrderDetailClass { ItemId = item.ItemId, Quantity = item.Quantity, IsRunningOrder = item.IsRunningOrder });
            }
            ////rocobj.DeleteOrderDetailByMaster(orderMasterInfo.OrderMasterID);
            ////rocobj.OrderMasterSaveTodatabase(orderMasterInfo, repeateditem);
            ////rocobj.SaveOrderIntoDataBase(orderMasterInfo);


            List<OrderDetailClass> orderList = rocobj.OrderMasterSaveTodatabase(orderMasterInfo, repeateditem);

            restroTable table = rocobj.GetTableNoBYId(Convert.ToInt32(orderMasterInfo.TableId));
            //GetDataForPrint(orderDetailList, table.restrotableTitle, json1.Date, json1.UserName, json1.OrderStatus);

            if (orderMasterInfo.OrderMasterID == 0)
            {

                status = "Added";
                GetDataForPrint(orderDetailList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, orderMasterInfo.OrderMasterID);
            }
            else
            {
                //status = "Updated";
                GetDataForPrint(orderList, table.restrotableTitle, orderMasterInfo.Date, orderMasterInfo.UserName, orderMasterInfo.OrderMasterID);

            }

        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    [WebMethod]
    public void CancelOrderIntoDataBase(OrderMasterClass orderMasterInfo)
    {
        try
        {
            RestrOrderController rocobj = new RestrOrderController();
            rocobj.CancelOrder(orderMasterInfo);

        }
        catch (Exception)
        {
            throw;
        }

    }

    public void GetDataForPrint(List<OrderDetailClass> orderDetailList, string tableId, DateTime time, string userName, int OrderStatus)
    {
        RestrOrderController rocobj = new RestrOrderController();
        CostCenterController coc = new CostCenterController();
        List<ItemsClass> itemList = rocobj.GetItemFromDatabase();
        //List<CostCenterInfo> costCenter = coc.GetCostCenter();
        List<OrderDetailClass> orderForKitchen = new List<OrderDetailClass>();
        List<OrderDetailClass> OrderForBar = new List<OrderDetailClass>();
        foreach (OrderDetailClass orderDetail in orderDetailList)
        {
            ItemsClass item = itemList.Where(p => p.ItemID == orderDetail.ItemId).FirstOrDefault() as ItemsClass;
            //List<ItemsClass> itemforKitchen = rocobj.GetItemFromDatabase().Where(p=>p.ItemID==orderDetail).Where(p => p.CostCenterId == 1);    

            orderDetail.ItemName = item.ItemName;
            orderDetail.CostCenterId = item.CostCenterId;
            if (orderDetail.CostCenterId == 1)
            {
                orderForKitchen.Add(orderDetail);
            }
            else
            {
                OrderForBar.Add(orderDetail);
            }

        }
        string KitchenPrintHtml = BindHtmlForPrint(orderForKitchen, "KITCHEN ORDER", tableId, time.ToShortTimeString(), userName, OrderStatus);
        string BarPrintHtml = BindHtmlForPrint(OrderForBar, "BAR ORDER", tableId, time.ToShortTimeString(), userName, OrderStatus);
        //testbyte = Encoding.ASCII.GetBytes(KitchenPrintHtml);
        try
        {
            if (orderForKitchen.Count > 0)
            {
                CostCenterInfo ccInfo = coc.GetCostCenterById(1);
                string KitchenPrinterName = ccInfo.DefaultPrinter;
                //kitchen

                newFileName = "KitchenPdf" + DateTime.Now.ToLongTimeString().Replace(":", "").Replace(" ", "") + ".pdf";

                PrintFunction(KitchenPrintHtml, newFileName, "KitchenReport");
                //ConvertHtmlToImage(KitchenPrintHtml, KitchenPrinterName, "KOT");
                //string newFileName = "KitchenPdf" + DateTime.Now.ToShortTimeString().Replace(":", "").Replace(" ", "");
                //string oldfilepath = @"E:\DanfeSolution\Restro\RestroOrder\SageFrame\Modules\ROPurchaseOrder\KOTREPORT.pdf";

                //string oldfilepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\ROPurchaseOrder\KOTREPORT.pdf";
                string oldfilepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\Order\Services\KitchenReport\" + dateString + @"\" + newFileName;
                //string oldfilepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\ROPurchaseOrder\KitchenReport\132016\" + newFileName;
                string newpath = @"F:\SharedFolder\Kitchen\";
                SendToPrinter(newFileName, oldfilepath, newpath, KitchenPrinterName);


            }
            if (OrderForBar.Count > 0)
            {
                CostCenterInfo ccInfo1 = coc.GetCostCenterById(2);
                string BarPrinterName = ccInfo1.DefaultPrinter;
                BarnewFileName = "BarPdf" + DateTime.Now.ToLongTimeString().Replace(":", "").Replace(" ", "") + ".pdf";

                //ConvertHtmlToImage(BarPrintHtml, BarPrinterName,"BOT");

                //Bar
                ////PrintFunction(BarPrintHtml, "BARREPORT.pdf");
                PrintFunction(BarPrintHtml, BarnewFileName, "BarReport");

                ////string BarnewFileName = "BarPdf" + DateTime.Now.ToShortTimeString().Replace(":", "").Replace(" ", "");
                ////string Baroldfilepath = @"E:\DanfeSolution\Restro\RestroOrder\SageFrame\Mo dules\ROPurchaseOrder\BARREPORT.pdf";
                ////string Baroldfilepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\ROPurchaseOrder\BARREPORT.pdf";
                string Baroldfilepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\Order\Services\BarReport\" + dateString + @"\" + BarnewFileName;
                string Barnewpath = @"F:\SharedFolder\Bar";

                ////document.Close();
                SendToPrinter(BarnewFileName, Baroldfilepath, Barnewpath, BarPrinterName);
            }
        }
        catch (Exception ex)
        {
            throw ex;

            //string status = "{\"Status\": \"Success\"}";
            //Context.Response.Clear();
            //Context.Response.ContentType = "application/json";
            //Context.Response.Write(status);
        }
    }

    public string BindHtmlForPrint(List<OrderDetailClass> orderDetailList, string CostCenterName, string tableId, string time, string userName, int OrderStatusID)
    {
        string status = "";
        if (OrderStatusID == 0)
        {
            status = "Added";
        }
        else
        {
            status = "Running";
        }
        StringBuilder sb1 = new StringBuilder();
        sb1.Append("<html>");

        sb1.Append("<div id='customer-bill' style='text-align:center; font-family:Arial; font-weight:lighter; width:40%''>");
        sb1.Append("<h3 style='text-align:center'>" + CostCenterName + "</h3>");
        sb1.Append("<div><div style='margin:0 auto;'>");
        sb1.Append("<span style='padding-right:30px'>Table ID:" + tableId + "</span><span>Time:" + time + "</span></div>");
        sb1.Append("<span style='padding-right:30px'>Waiter:" + userName + "</span><span>Status:" + status + "</span></div>");

        //sb1.Append("<div style='margin:0 auto;'><span>Waiter:" + userName + "</span></div></div>");
        sb1.Append("<table style='padding-top:10px;margin:0 auto;'>");

        sb1.Append("<tr><th>Item</th><th>Quantity</th><th>Home Packing</th><th> Note</th></tr>");
        //sb1.Append("<tr><td>---------------------------</td></tr>");
        foreach (OrderDetailClass orderDetail in orderDetailList)
        {
            sb1.Append("<tr>");
            sb1.Append("<td style='font-size:12px;'>" + orderDetail.ItemName + "</td>");

            sb1.Append("<td style='font-size:12px'>" + (orderDetail.Quantity - orderDetail.HomePackQty) + "</td>");

            sb1.Append("<td style='font-size:11px'>" + orderDetail.HomePackQty + "</td>");
            sb1.Append("<td style='font-size:11px'>" + orderDetail.Note + "</td>");
            sb1.Append("</tr>");
        }
        //sb1.Append("<tr><td>---------------------------</td></tr>");
        sb1.Append("</table>");
        sb1.Append("</div>");
        sb1.Append("<html>");
        string Html = sb1.ToString();
        //htmltoprint = Html;
        return Html;
    }

    public void PrintFunction(string html, string filenameforpdf, string filepath)
    {
        //Byte[] bytes = PdfSharpConvert("<h1>Testkdjlkfdjskl kjsjdlk </h1>");
        Byte[] bytes = PdfSharpConvert(html);

        //testbyte = bytes;

        // Saving Byte to pdf
        //Create direcotry if not exist
        bool exists = System.IO.Directory.Exists(Server.MapPath(filepath + "/" + DateTime.Now.ToShortDateString().Replace("/", "")));

        if (!exists)
            System.IO.Directory.CreateDirectory(Server.MapPath(filepath + "/" + DateTime.Now.ToShortDateString().Replace("/", "")));
        dateString = DateTime.Now.ToShortDateString().Replace("/", "");

        //System.IO.Directory.CreateDirectory(DateTime.Now.ToShortDateString().Replace("/", ""));
        FileStream fs = new FileStream(HttpContext.Current.Server.MapPath(filepath + "/" + DateTime.Now.ToShortDateString().Replace("/", "") + "/" + filenameforpdf), FileMode.Create);
        fs.Write(bytes, 0, bytes.Length);
        fs.Close();
    }

    public static Byte[] PdfSharpConvert(String html)
    {
        Byte[] res = null;
        using (MemoryStream ms = new MemoryStream())
        {
            var pdf = TheArtOfDev.HtmlRenderer.PdfSharp.PdfGenerator.GeneratePdf(html, PdfSharp.PageSize.A4);
            pdf.Save(ms);

            //res =  Encoding.ASCII.GetBytes(ms.ToArray());
            res = ms.ToArray();

        }
        //testbyte = res;
        return res;
    }
    public void ConvertHtmlToImage(string html, string PrinterName, string imageName)
    {
        try
        {
            //System.Drawing.Image image = TheArtOfDev.HtmlRenderer.WinForms.HtmlRender.RenderToImageGdiPlus(html);

            Bitmap m_Bitmap = new Bitmap(800, 1000);
            //m_Bitmap.SetResolution(75, 75);
            //System.Drawing.Color color = Color.FromArgb(255, 255, 0); 
            //m_Bitmap.SetPixel(10, 10, color);          
            PointF point = new PointF(0, 0);
            SizeF maxSize = new System.Drawing.SizeF(500, 500);



            TheArtOfDev.HtmlRenderer.WinForms.HtmlRender.RenderGdiPlus(Graphics.FromImage(m_Bitmap),
                                                  html,
                                                     point, maxSize);

            System.Threading.Thread.Sleep(3000);
            //m_Bitmap.SetResolution(1000, 1000);
            //dateString = DateTime.Now.ToShortTimeString().Replace("/", "");
            string filepath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\ROPurchaseOrder\KitchenReport\";
            //m_Bitmap.Save(filepath + "Test5.png", System.Drawing.Imaging.ImageFormat.Png);
            m_Bitmap.Save(filepath + imageName + ".png", System.Drawing.Imaging.ImageFormat.Png);
            //m_Bitmap.Save(filepath, System.Drawing.Imaging.ImageFormat.Png);
            PrintDocument pd = new PrintDocument();
            //pd.PrinterSettings.PrinterName = "Send To OneNote 2010";
            //pd.PrinterSettings.PrinterName = "Brother MFC-L2700DW series Printer";
            //printFont = new System.Drawing.Font("Arial", 10);
            pd.PrinterSettings.PrinterName = PrinterName;
            pd.PrintPage += (sender, args) =>
            {
                //System.Drawing.Image i = System.Drawing.Image.FromFile(@"F:\SharedFolder\Bar\Test5.icon");
                System.Drawing.Image i = System.Drawing.Image.FromFile(filepath + imageName + ".png");
                Point p = new Point(100, 100);
                args.Graphics.DrawImage(i, 10, 10, i.Width, i.Height);
            };
            if (pd.PrinterSettings.IsValid)
            {
                pd.Print();
                //string status = "{\"Status\": \"Success\"}";
                //Context.Response.Clear();
                //Context.Response.ContentType = "application/json";
                //Context.Response.Write(status);
            }
            else
            {

                //streamToPrint.Close();
                //string status = "{\"Status\": \"INVALIDPRINTERNAME\"}";
                //Context.Response.Clear();
                //Context.Response.ContentType = "application/json";
                //Context.Response.Write(status);
            }
        }
        catch (Exception ex)
        {
            throw ex;

        }
        //SendToPrinter("Kitchen", @"F:\SharedFolder\Bar\Test2.png", "GoTOHell");
    }





    private void SendToPrinter(string newFileName, string file, string newpath, string printerName)
    {
        List<string> printerList = new List<string>();

        try
        {

            //foreach (string printer in System.Drawing.Printing.PrinterSettings.InstalledPrinters)
            //{
            //    Console.Write(printer);
            //    printerList.Add(printer);
            //}
            var path = Server.MapPath("~");
            string sumatraPdfPath = AppDomain.CurrentDomain.BaseDirectory + @"Modules\ROPurchaseOrder\sumatrapdf\SumatraPdf.exe";
            //var sumatraPdfPath = $"{path}\\sumatrapdf\\SumatraPdf.exe";
            string pdfPath = file;
            //var pdfPath = $"{path}\\pdf\\1.pdf";
            //var printerName = "Send To OneNote 2010";


            var process = new System.Diagnostics.Process
            {
                StartInfo =
                {
                    FileName = sumatraPdfPath,
                    Arguments = string.Format("-print-to \"{0}\" \"{1}\" -exit-on-print", printerName, pdfPath),
                    //Arguments = "-print-to " + printerName + " " + pdfPath + " -exit-on-print",
                    WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden
                }
            };

            process.Start();
            process.WaitForExit();

        }
        catch (Exception ex)
        {
            throw ex;
        }


    }








}
