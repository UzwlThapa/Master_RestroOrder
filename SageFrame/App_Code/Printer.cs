using SageFrame.RestroOrder;
using System.Drawing;
using System.Drawing.Printing;
using System.Configuration;
using System;
using SageFrame.CakeOrder;
using System.Collections.Generic;

/// <summary>
/// Summary description for Printer
/// </summary>
public class Printer
{
    private KOT kot { get; set; }
    private List<OrderDetailClass> ord { get; set; }
    private SalesBill billdetails { get; set; }
    private string FromTable { get; set; }
    private string ToTable { get; set; }

    public void PrintKOT(string printerName, KOT KOT)
    {
        if (!string.IsNullOrEmpty(printerName))
        {
            kot = KOT;
            PrintDocument printDocument = new PrintDocument();
            printDocument.PrinterSettings.PrinterName = printerName == "" ? "POS-80C" : printerName;
            printDocument.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(CreateKOT); //add an event handler that will do the printing
            printDocument.Print();
        }
    }

    public void PrintShiftBill(string printerName, KOT KOT, string fromTable, string toTable)
    {
        if (!string.IsNullOrEmpty(printerName))
        {
            kot = KOT;
            FromTable = fromTable;
            ToTable = toTable;
            PrintDocument printDocument = new PrintDocument();
            printDocument.PrinterSettings.PrinterName = printerName == "" ? "POS-80C" : printerName;
            printDocument.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(CreateShiftBill); //add an event handler that will do the printing
            printDocument.Print();
        }
    }

    private void CreateShiftBill(object sender, System.Drawing.Printing.PrintPageEventArgs e)
    {
        int characterLength = Convert.ToInt32(ConfigurationManager.AppSettings["KOTCharacterLength"].ToString());
        Graphics graphic = e.Graphics;
        Font fontHeader = new Font("Arial Rounded MT", 12, FontStyle.Bold);
        Font font = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold); //must use a mono spaced font as the spaces need to line up
        Font fontStrike = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold | FontStyle.Strikeout);

        float fontHeight = font.GetHeight();
        int itemLength = characterLength - 9;
        int startX = 2;
        int startY = 5;
        int offset = 40;
        string dashes = "--------------------------------";
        string item = "                                         ";
        string quantity = "   ";
        string line = string.Empty;
        graphic.DrawString("      " + kot.CostCenterTitle, new Font("Courier New", 14, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY);

        offset = offset + (int)fontHeight + 6; //make the spacing consistent
        line = "From Table:" + FromTable;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight + 6; //make the spacing consistent
        line = "To Table:" + ToTable;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight + 6; //make the spacing consistent
        line = "Date:" + kot.Date + "  " + kot.Time;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Order By:" + kot.Waiter;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        if (kot.Customer.Length > 2)
        {
            string customer = "Cust: " + kot.Customer + (kot.Contact == null ? "" : " (" + kot.Contact + ")");
            if (customer.Length > characterLength)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            else
            {
                offset = offset + (int)fontHeight;
                line = customer;
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (customer.Length > characterLength * 2)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 2, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (customer.Length > characterLength * 3)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 3, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (customer.Length > characterLength * 4)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 4, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);

        line = ("Item                                                                ").Substring(0, itemLength) + "Qty";
        offset = offset + (int)fontHeight;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight - 5;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        foreach (OrderDetailClass itm in kot.KOTItems)
        {
            itm.ItemName = itm.ItemName.Trim();
            offset = offset + (int)fontHeight + 10;
            line = (itm.ItemName.Trim() + item).Substring(0, itemLength) + (kot.Status == "Cancelled" ? (quantity + "(" + itm.Quantity).Substring(itm.Quantity.ToString().Length, 4) + ")" : (quantity + itm.Quantity).Substring(itm.Quantity.ToString().Length, 3));
            graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
            if (itm.ItemName.Length > itemLength)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.ItemName.Length > itemLength * 2)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 2, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.ItemName.Length > itemLength * 3)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 3, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.ItemName.Length > itemLength * 4)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 4, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > 1)
            {
                offset = offset + (int)fontHeight;
                line = (" --" + itm.Note + item).Substring(0, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > characterLength - 3)
            {
                offset = offset + (int)fontHeight;
                line = (" --" + itm.Note + item).Substring(characterLength - 3, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > (characterLength - 3) * 2)
            {
                offset = offset + (int)fontHeight;
                line = ("  --" + itm.Note + item).Substring((characterLength - 3) * 2, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > (characterLength - 3) * 3)
            {
                offset = offset + (int)fontHeight;
                line = ("  --" + itm.Note + item).Substring((characterLength - 3) * 3, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }
        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
    }

    public void PrintBill(string printerName, KOT KOT, List<OrderDetailClass> orderDetailList)
    {
        kot = KOT;
        ord = orderDetailList;
        PrintDocument printDocument = new PrintDocument();
        printDocument.PrinterSettings.PrinterName = printerName == "" ? "POS-80C" : printerName;
        printDocument.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(CreateBill);
        printDocument.Print();

    }

    public void PrintViewBill(string printerName, SalesBill bill)
    {
        billdetails = bill;
        PrintDocument printDocument = new PrintDocument();
        printDocument.PrinterSettings.PrinterName = printerName == "" ? "POS-80C" : printerName;
        printDocument.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(CreateViewBill);
        printDocument.Print();
    }

    public void CreateViewBill(object sender, System.Drawing.Printing.PrintPageEventArgs e)
    {
        int characterLength = Convert.ToInt32(ConfigurationManager.AppSettings["KOTCharacterLength"].ToString());
        Graphics graphic = e.Graphics;
        Font font = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold); //must use a mono spaced font as the spaces need to line up

        float fontHeight = font.GetHeight();
        int itemLength = characterLength - 6;
        int startX = 2;
        int startY = 5;
        int offset = 40;
        string dashes = "--------------------------------";
        string item = "                                            ";
        string space = " ";

        string line = string.Empty;
        graphic.DrawString("    ESTIMATE ORDERS", new Font("Courier New", 14, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY + 10);
        offset = offset + (int)fontHeight;

        line = ("Table:" + billdetails.RoomBooking.restrotableTitle + item).Substring(0, characterLength / 2);
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Date:" + billdetails.RoomBooking.Date;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Customer:" + billdetails.RoomBooking.CustomerName;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Contact:" + billdetails.RoomBooking.PhoneNo;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);

        line = ("Item              " + "Qty " + "Rate " + "Amt");
        offset = offset + (int)fontHeight;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight - 5;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        var TotalAmount = 0.00;

        foreach (OrderDetailClass itm in billdetails.orderDetail)
        {
            string format = "";
            var serviceRate = 100 + billdetails.billingTerm[0].Rate;
            decimal abbRate = 0;
            if (billdetails.VATforBill)
            {
                if (billdetails.billingTerm[0].IsAdd && billdetails.billingTerm[0].BillTerm == "Service Charge")
                {
                    var sRate = itm.Rate * (serviceRate / 100);
                    abbRate = sRate * (decimal)1.13;
                }
                else
                {
                    abbRate = (itm.Rate) * (decimal)1.13;
                }
            }
            else
            {
                if (billdetails.billingTerm[0].IsAdd && billdetails.billingTerm[0].BillTerm == "Service Charge")
                {
                    abbRate = (itm.Rate * (serviceRate / 100));
                }
                else
                {
                    abbRate = itm.Rate;
                }
            }

            var Amt = itm.Quantity * (float)abbRate;
            TotalAmount += Amt;
            var ItemLength = 0;
            ItemLength = itm.ITName.Trim().Length;
            var IName = "";
            // Improved wrapping logic
            string fullItemName = itm.ITName.Trim();
            int maxNameLen = 17;
            string firstLine = fullItemName.Length > maxNameLen ? fullItemName.Substring(0, maxNameLen) : fullItemName;
            string remainder = fullItemName.Length > maxNameLen ? fullItemName.Substring(maxNameLen) : "";
            //string remainder = fullItemName.Length > maxNameLen ? fullItemName.Substring(maxNameLen) : \"\";
            IName = firstLine;

            if (ItemLength < 17)
            {
                for (var i = ItemLength; i != 18; i++)
                {
                    format += space;
                }
            }
            else
            {
                format = "   ";
            }

            var newit = (IName + format).Length;
            offset = offset + (int)fontHeight + 10;
            line = IName.PadRight(18) + itm.Quantity.ToString().PadRight(4) + decimal.Round(abbRate, 1).ToString().PadRight(6) + decimal.Round((decimal)Amt, 1).ToString();
            graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            if (!string.IsNullOrEmpty(remainder)) {
                offset += (int)fontHeight;
                graphic.DrawString("  " + remainder, font, new SolidBrush(Color.Black), startX, startY + offset);
                //graphic.DrawString(\"  \" + remainder, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "Total Amount: Rs." + (decimal.Round((decimal)TotalAmount, 2, MidpointRounding.AwayFromZero));
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight + 10;
        line = "Note: This is just an Estimate";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "Orders.";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "     **** ThankYou ****";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight + 15;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
    }

    private void CreateKOT(object sender, System.Drawing.Printing.PrintPageEventArgs e)
    {
        int characterLength = Convert.ToInt32(ConfigurationManager.AppSettings["KOTCharacterLength"].ToString());
        Graphics graphic = e.Graphics;
        Font fontHeader = new Font("Arial Rounded MT", 12, FontStyle.Bold);
        Font font = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold); //must use a mono spaced font as the spaces need to line up
        Font fontStrike = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold | FontStyle.Strikeout);

        float fontHeight = font.GetHeight();
        int itemLength = characterLength - 9;
        int startX = 2;
        int startY = 5;
        int offset = 40;
        string dashes = "--------------------------------";
        string item = "                                         ";
        string quantity = "   ";
        string line = string.Empty;
        if (kot.Status == "Cancelled")
        {
            graphic.DrawString("      " + kot.CostCenterTitle, new Font("Courier New", 14, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY);
            graphic.DrawString("\n      " + "(" + kot.Status + ")", new Font("Courier New", 12, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY);
            offset = offset + (int)fontHeight;
        }
        else
        {
            graphic.DrawString("    " + kot.CostCenterTitle + " '" + kot.TableId + "'", new Font("Courier New", 14, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY + 10);
        }

        offset = offset + (int)fontHeight;
        if (kot.TokenNo > 0)
        {
            line = ("     Token:" + kot.TokenNo + item);
            graphic.DrawString(line, new Font("Courier New", 16, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY + offset);
        }
        else
        {
            line = "Order No:" + (kot.OrderNo == 0 ? Convert.ToInt32(kot.OrderMasterId) : kot.OrderNo);
            graphic.DrawString(line, new Font("Courier New", 12, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY + offset);
            offset = offset + (int)fontHeight;
            line = ("Table:" + kot.TableId + item);
            graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        }

        if (kot.CompMasterID > 0)
        {
            line = ("Table:" + kot.TableId + item).Substring(0, characterLength / 2) + "Order No:" + kot.CompMasterID;
            graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        }

        offset = offset + (int)fontHeight + 6; //make the spacing consistent
        line = "Date:" + kot.Date + "  " + kot.Time;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Order By:" + kot.Waiter;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        if (kot.Customer.Length > 2)
        {
            string customer = "Cust: " + kot.Customer + (kot.Contact == null ? "" : " (" + kot.Contact + ")");
            if (customer.Length > characterLength)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            else
            {
                offset = offset + (int)fontHeight;
                line = customer;
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (customer.Length > characterLength * 2)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 2, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (customer.Length > characterLength * 3)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 3, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (customer.Length > characterLength * 4)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 4, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);

        line = ("Item                                                                ").Substring(0, itemLength) + "Qty";
        offset = offset + (int)fontHeight;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight - 5;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        foreach (OrderDetailClass itm in kot.KOTItems)
        {
            itm.ItemName = itm.ItemName.Trim();
            offset = offset + (int)fontHeight + 10;
            line = (itm.ItemName.Trim() + item).Substring(0, itemLength) + (kot.Status == "Cancelled" ? (quantity + "(" + itm.Quantity).Substring(itm.Quantity.ToString().Length, 4) + ")" : (quantity + itm.Quantity).Substring(itm.Quantity.ToString().Length, 3));
            graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
            //graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            if (itm.ItemName.Length > itemLength)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
                //graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.ItemName.Length > itemLength * 2)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 2, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
                //graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.ItemName.Length > itemLength * 3)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 3, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
                //graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.ItemName.Length > itemLength * 4)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 4, itemLength);
                graphic.DrawString(line, kot.Status == "Cancelled" ? fontStrike : font, new SolidBrush(Color.Black), startX, startY + offset);
                //graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > 1)
            {
                offset = offset + (int)fontHeight;
                line = (" --" + itm.Note + item).Substring(0, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > characterLength - 3)
            {
                offset = offset + (int)fontHeight;
                line = (" --" + itm.Note + item).Substring(characterLength - 3, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > (characterLength - 3) * 2)
            {
                offset = offset + (int)fontHeight;
                line = ("  --" + itm.Note + item).Substring((characterLength - 3) * 2, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }

            if (itm.Note.Trim().Length > (characterLength - 3) * 3)
            {
                offset = offset + (int)fontHeight;
                line = ("  --" + itm.Note + item).Substring((characterLength - 3) * 3, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }
        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
    }

    private void CreateBill(object sender, System.Drawing.Printing.PrintPageEventArgs e)
    {
        int characterLength = Convert.ToInt32(ConfigurationManager.AppSettings["KOTCharacterLength"].ToString());
        Graphics graphic = e.Graphics;
        Font font = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold); //must use a mono spaced font as the spaces need to line up

        float fontHeight = font.GetHeight();
        int itemLength = characterLength - 6;
        int startX = 2;
        int startY = 5;
        int offset = 40;
        string dashes = "--------------------------------";
        string item = "                                            ";
        string space = " ";

        string line = string.Empty;
        graphic.DrawString("    ESTIMATE ORDERS", new Font("Courier New", 14, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY + 10);
        offset = offset + (int)fontHeight;
        if (kot.TokenNo > 0)
        {
            line = ("Token:" + kot.TokenNo + item).Substring(0, characterLength / 2) + " Order No:" + kot.OrderNo;
        }
        else
        {
            line = ("Table:" + kot.TableId + item).Substring(0, characterLength / 2) + " Order No:" + (kot.OrderNo == 0 ? Convert.ToInt32(kot.OrderMasterId) : kot.OrderNo);
        }

        if (kot.CompMasterID > 0)
        {
            line = ("Table:" + kot.TableId + item).Substring(0, characterLength / 2) + "Order No:" + kot.CompMasterID;
        }

        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "Date:" + kot.Date + "  " + kot.Time;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Order By:" + kot.Waiter;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        if (kot.Customer.Length > 2)
        {
            offset = offset + (int)fontHeight;
            line = "Customer:" + kot.Customer;
            graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

            offset = offset + (int)fontHeight;
            line = "Contact:" + kot.Contact;
            graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        }

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);

        line = ("Item              " + "Qty " + "Rate " + "Amt");
        offset = offset + (int)fontHeight;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight - 5;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        var TotalAmount = 0.00;

        foreach (OrderDetailClass itm in ord)
        {
            string format = "";
            var Amt = itm.Quantity * (float)itm.Rate;
            TotalAmount += Amt;
            var ItemLength = 0;
            ItemLength = itm.ItemName.Trim().Length;
            var IName = "";
            IName = ItemLength > 19 ? itm.ItemName.Trim().Substring(0, 15) + ".." : itm.ItemName.Trim();

            if (ItemLength < 19)
            {
                for (var i = ItemLength; i != 20; i++)
                {
                    format += space;
                }
            }
            else
            {
                format = "   ";
            }

            var newit = (IName + format).Length;

            offset = offset + (int)fontHeight + 10;
            line = IName + format + (kot.Status == "Cancelled" ? ("(" + itm.Quantity) + ")" : (itm.Quantity) + " " + (itm.Rate) + " " + (Amt));

        }

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "Total Amount: Rs." + TotalAmount;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight + 10;
        line = "Note: This is not a valid bill.";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "Please contact cashier for";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "actual bill.";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
        line = "     **** ThankYou ****";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight + 15;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight;
    }

    public void PrintKOTforCake(string printerName, KOT KOT)
    {
        kot = KOT;
        PrintDocument printDocument = new PrintDocument();
        printDocument.PrinterSettings.PrinterName = printerName == "" ? "POS-80C" : printerName;
        printDocument.PrintPage += new System.Drawing.Printing.PrintPageEventHandler(CreateKOTforcake); //add an event handler that will do the printing
        printDocument.Print();
    }

    private void CreateKOTforcake(object sender, System.Drawing.Printing.PrintPageEventArgs e)
    {
        int characterLength = Convert.ToInt32(ConfigurationManager.AppSettings["KOTCharacterLength"].ToString());
        Graphics graphic = e.Graphics;
        Font font = new Font("Courier New", Convert.ToInt32(ConfigurationManager.AppSettings["KOTFontSize"].ToString()), FontStyle.Bold); //must use a mono spaced font as the spaces need to line up

        float fontHeight = font.GetHeight();
        int itemLength = characterLength - 6;
        int startX = 2;
        int startY = 5;
        int offset = 40;
        string dashes = "--------------------------------";
        string item = "                                            ";
        string quantity = "   ";
        string line = string.Empty;
        graphic.DrawString("    " + kot.CostCenterTitle, new Font("Courier New", 14, FontStyle.Bold), new SolidBrush(Color.Black), startX, startY + 10);
        offset = offset + (int)fontHeight;
        if (kot.TokenNo > 0)
        {
            line = ("Token:" + kot.TokenNo + item).Substring(0, characterLength / 2) + " Order No:" + kot.OrderNo;
        }
        else
        {
            line = ("Order:" + kot.TableId + item).Substring(0, characterLength / 2) + " Order No:" + (kot.OrderNo == 0 ? Convert.ToInt32(kot.OrderMasterId) : kot.OrderNo);
        }

        if (kot.CompMasterID > 0)
        {
            line = ("Table:" + kot.TableId + item).Substring(0, characterLength / 2) + "Order No:" + kot.CompMasterID;
        }
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight; //make the spacing consistent
        line = "Date:" + kot.Date + "  " + kot.Time;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        offset = offset + (int)fontHeight;
        line = "Order By:" + kot.Waiter + " (" + kot.Status + ")";
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);

        if (kot.Customer.Length > 2)
        {
            string customer = "Cust: " + kot.Customer + (kot.Contact == null ? "" : " (" + kot.Contact + ")");
            if (customer.Length > characterLength)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            else
            {
                offset = offset + (int)fontHeight;
                line = customer;
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (customer.Length > characterLength * 2)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 2, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (customer.Length > characterLength * 3)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 3, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (customer.Length > characterLength * 4)
            {
                offset = offset + (int)fontHeight;
                line = customer.Substring(characterLength * 4, characterLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }

        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);

        line = ("Item                                                                ").Substring(0, itemLength) + "Qty";
        offset = offset + (int)fontHeight;
        graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
        offset = offset + (int)fontHeight - 5;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
        foreach (CakeOrderList itm in kot.KOTItem)
        {
            offset = offset + (int)fontHeight + 10;
            line = (itm.ItemName + item).Substring(0, itemLength) + (kot.Status == "Cancelled" ? (quantity + "(" + itm.Quantity).Substring(itm.Quantity.ToString().Length, 4) + ")" : (quantity + itm.Quantity).Substring(itm.Quantity.ToString().Length, 3));
            graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            if (itm.ItemName.Length > itemLength)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength, itemLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.ItemName.Length > itemLength * 2)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 2, itemLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.ItemName.Length > itemLength * 3)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 3, itemLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.ItemName.Length > itemLength * 4)
            {
                offset = offset + (int)fontHeight;
                line = (itm.ItemName + item).Substring(itemLength * 4, itemLength);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.Note.Trim().Length > 1)
            {
                offset = offset + (int)fontHeight;
                line = (" --" + itm.Note + item).Substring(0, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.Note.Trim().Length > characterLength - 3)
            {
                offset = offset + (int)fontHeight;
                line = (" --" + itm.Note + item).Substring(characterLength - 3, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.Note.Trim().Length > (characterLength - 3) * 2)
            {
                offset = offset + (int)fontHeight;
                line = ("  --" + itm.Note + item).Substring((characterLength - 3) * 2, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
            if (itm.Note.Trim().Length > (characterLength - 3) * 3)
            {
                offset = offset + (int)fontHeight;
                line = ("  --" + itm.Note + item).Substring((characterLength - 3) * 3, characterLength - 3);
                graphic.DrawString(line, font, new SolidBrush(Color.Black), startX, startY + offset);
            }
        }
        offset = offset + (int)fontHeight;
        graphic.DrawString(dashes, font, new SolidBrush(Color.Black), startX, startY + offset);
    }
}
