using System;
using System.Collections.Generic;
using System.Linq;
using SageFrame.RestroOrder;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Configuration;
using Hangfire;
/// <summary>
/// Summary description for CBMS
/// </summary>
public class CBMS
{
    public string apiBaseUrl;
    public string timeToSyncBills;
    public companyInfo company;
    RestrOrderController roc = new RestrOrderController();
    public CBMS()
	{
        apiBaseUrl = ConfigurationManager.AppSettings["CbmsApiBaseUrl"].ToString();
    }
    public void sendSales(int SalesMasterId)
    {
        bool alreadySent = roc.CheckIfCBMSAlreadySent(SalesMasterId);
        if (!alreadySent)
        {
            company = roc.getcompanyInfo().FirstOrDefault();
            List<OrderDetailClass> ord = roc.GetdataforViewBill(SalesMasterId);
            flatorperdiscount discount = roc.getflatorperdiscount(SalesMasterId).FirstOrDefault();

            List<customerBilling> bTerm = roc.getbillingTermbySalesMasterID(SalesMasterId.ToString());
            decimal NetAmount = bTerm.Where(p => p.BillTerm == "NetAmount").FirstOrDefault().Amount;
            decimal TaxAmnt = (company.IsPan ? 0 : bTerm.Where(p => p.BillTerm == "VAT").FirstOrDefault().Amount);
            decimal taxableAmnt = NetAmount - TaxAmnt;

            BillViewModel bill = new BillViewModel();
            bill.seller_pan = company.PAN;
            bill.buyer_pan = ord[0].PAN;
            bill.fiscal_year = ord[0].fiscalYear;
            bill.buyer_name = ord[0].CusName;
            bill.invoice_number = ord[0].BillNo;
            bill.invoice_date = ord[0].NepaliInvoiceDate;
            bill.total_sales = Convert.ToDouble(taxableAmnt);
            bill.taxable_sales_vat = Convert.ToDouble(taxableAmnt);
            bill.vat = Convert.ToDouble(TaxAmnt);
            bill.excisable_amount = 0;
            bill.excise = 0;
            bill.taxable_sales_hst = 0;
            bill.hst = 0;
            bill.amount_for_esf = 0;
            bill.esf = 0;
            bill.export_sales = 0;
            bill.tax_exempted_sales = 0;
            bill.isrealtime = true;
            bill.datetimeClient = DateTime.Now;

            int logId = roc.savePostedBill(bill, "410", "Bill Not Posted", DateTime.Now, SalesMasterId, ord[0].Date);

            BackgroundJob.Enqueue(() => PostBill(bill, SalesMasterId, logId));
        }
    }

    public void PostBill(BillViewModel bill, int salesMasterId, int logId)
    {
        company = roc.getcompanyInfo().FirstOrDefault();
        using (var client = new HttpClient())
        {
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new
            MediaTypeWithQualityHeaderValue("application/json"));
            BillViewModel p = new BillViewModel
            {
                username = company.CBMSUserName,
                password = company.CBMSPassword,
                seller_pan = bill.seller_pan,
                buyer_pan = bill.buyer_pan,
                buyer_name = bill.buyer_name,
                fiscal_year = bill.fiscal_year,
                invoice_number = bill.invoice_number,
                invoice_date = bill.invoice_date,
                total_sales = bill.total_sales,
                taxable_sales_vat = bill.taxable_sales_vat,
                vat = bill.vat,
                excisable_amount = bill.excisable_amount,
                excise = bill.excise,
                taxable_sales_hst = bill.taxable_sales_hst,
                hst = bill.hst,
                amount_for_esf = bill.amount_for_esf,
                esf = bill.esf,
                export_sales = bill.export_sales,
                tax_exempted_sales = bill.tax_exempted_sales,
                isrealtime = bill.isrealtime,
                datetimeClient = bill.datetimeClient
            };
            client.BaseAddress = new Uri(apiBaseUrl);
            
            try
            {
                var response = client.PostAsJsonAsync("api/bill", p).Result;
                if (response.IsSuccessStatusCode)
                {
                    var responseCode = response.Content.ReadAsStringAsync();
                    if (responseCode.Result == "200")
                    {
                        roc.updatePostedBill(logId, responseCode.Result, response.ReasonPhrase.ToString(), DateTime.Now, salesMasterId, true);
                    }
                    else
                    {
                        roc.updatePostedBill(logId, responseCode.Result, "Error Code " + responseCode.Result, DateTime.Now, salesMasterId, true);
                    }
                }
                else
                {
                    var responseCode = response.Content.ReadAsStringAsync();
                    roc.updatePostedBill(logId, "420", "Error In API", DateTime.Now, salesMasterId, true);
                }

            }
            catch (Exception)
            {
                roc.updatePostedBill(logId, "420", "Error In Api", DateTime.Now, salesMasterId, true);
            }
        }
    }


    [AutomaticRetry(Attempts = 0)]
    public static void syncSales()
    {
        RestrOrderController roc = new RestrOrderController();
        companyInfo company = roc.getcompanyInfo().FirstOrDefault();
        string apiBaseUrl = ConfigurationManager.AppSettings["CbmsApiBaseUrl"].ToString();
        List<BillPostLog> errorPosts = roc.getErrorBillPostLog();
        foreach (BillPostLog bill in errorPosts)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new
                MediaTypeWithQualityHeaderValue("application/json"));
                BillViewModel p = new BillViewModel
                {
                    username = company.CBMSUserName,
                    password = company.CBMSPassword,
                    seller_pan = bill.seller_pan,
                    buyer_pan = bill.buyer_pan,
                    buyer_name = bill.buyer_name,
                    fiscal_year = bill.fiscal_year,
                    invoice_number = bill.invoice_number,
                    invoice_date = bill.invoice_date,
                    total_sales = bill.total_sales,
                    taxable_sales_vat = bill.taxable_sales_vat,
                    vat = bill.vat,
                    excisable_amount = bill.excisable_amount,
                    excise = bill.excise,
                    taxable_sales_hst = bill.taxable_sales_hst,
                    hst = bill.hst,
                    amount_for_esf = bill.amount_for_esf,
                    esf = bill.esf,
                    export_sales = bill.export_sales,
                    tax_exempted_sales = bill.tax_exempted_sales,
                    isrealtime = false,
                    datetimeClient = DateTime.Now
                };
                client.BaseAddress = new Uri(apiBaseUrl);
                try
                {
                    var response = client.PostAsJsonAsync("api/bill", p).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        var responseCode = response.Content.ReadAsStringAsync();
                        if (responseCode.Result == "200")
                        {
                            roc.updatePostedBill(bill.LogID, responseCode.Result, response.ReasonPhrase.ToString(), DateTime.Now, bill.SalesMasterId, false);
                        }
                        else
                        {
                            roc.updatePostedBill(bill.LogID, responseCode.Result, "Error Code " + responseCode.Result, DateTime.Now, bill.SalesMasterId, false);
                        }
                    }
                    else
                    {
                        var responseCode = response.Content.ReadAsStringAsync();
                        roc.updatePostedBill(bill.LogID, "420", "Error In API", DateTime.Now, bill.SalesMasterId, false);
                        break;
                    }
                }
                catch (Exception)
                {
                    roc.updatePostedBill(bill.LogID, "420", "Error In API", DateTime.Now, bill.SalesMasterId, false);
                    break;
                }
            }
        }
    }


    [AutomaticRetry(Attempts = 0)]
    public void returnSales(int salesMasterId, string nepalidate, string returnReason)
    {
        BillPostLog postedbill = new BillPostLog();
        postedbill = roc.GetPostedBillBySalesMasterId(salesMasterId);
        if (postedbill != null)
        {
            BillReturnViewModel billreturn = new BillReturnViewModel();
            billreturn.seller_pan = postedbill.seller_pan;
            billreturn.buyer_pan = postedbill.buyer_pan;
            billreturn.fiscal_year = postedbill.fiscal_year;
            billreturn.buyer_name = postedbill.buyer_name;
            billreturn.ref_invoice_number = postedbill.invoice_number;
            //billreturn.credit_note_number = "1";
            billreturn.credit_note_date = nepalidate;
            billreturn.reason_for_return = returnReason;
            billreturn.total_sales = postedbill.total_sales;
            billreturn.taxable_sales_vat = postedbill.taxable_sales_vat;
            billreturn.vat = postedbill.vat;
            billreturn.excisable_amount = postedbill.excisable_amount;
            billreturn.excise = postedbill.excise;
            billreturn.taxable_sales_hst = postedbill.taxable_sales_hst;
            billreturn.hst = postedbill.hst;
            billreturn.amount_for_esf = postedbill.amount_for_esf;
            billreturn.esf = postedbill.esf;
            billreturn.export_sales = postedbill.export_sales;
            billreturn.tax_exempted_sales = postedbill.tax_exempted_sales;
            billreturn.isrealtime = true;
            billreturn.datetimeClient = DateTime.Now;

            ReturnBillPostLog returnLog = roc.saveReturnedBill(billreturn, "410", "Bill Not Posted", DateTime.Now, salesMasterId);

            BackgroundJob.Enqueue(() => ReturnBill(billreturn, returnLog.ReturnLogID, returnLog.credit_note_number, salesMasterId));
        }
    }

    [AutomaticRetry(Attempts = 0)]
    public void CancelSales(int salesMasterId, string nepalidate, string returnReason)
    {
        roc.CancelSalesBook(salesMasterId);
    }

    public void ReturnBill(BillReturnViewModel billreturn, int returnLogId, string credit_note_number, int salesMasterId)
    {
        company = roc.getcompanyInfo().FirstOrDefault();
        using (var client = new HttpClient())
        {
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new
            MediaTypeWithQualityHeaderValue("application/json"));
            BillReturnViewModel p = new BillReturnViewModel
            {
                username = company.CBMSUserName,
                password = company.CBMSPassword,
                seller_pan = billreturn.seller_pan,
                buyer_pan = billreturn.buyer_pan,
                buyer_name = billreturn.buyer_name,
                fiscal_year = billreturn.fiscal_year,
                ref_invoice_number = billreturn.ref_invoice_number,
                credit_note_number = credit_note_number,
                credit_note_date = billreturn.credit_note_date,
                reason_for_return = billreturn.reason_for_return,
                total_sales = billreturn.total_sales,
                taxable_sales_vat = billreturn.taxable_sales_vat,
                vat = billreturn.vat,
                excisable_amount = billreturn.excisable_amount,
                excise = billreturn.excise,
                taxable_sales_hst = billreturn.taxable_sales_hst,
                hst = billreturn.hst,
                amount_for_esf = billreturn.amount_for_esf,
                esf = billreturn.esf,
                export_sales = billreturn.export_sales,
                tax_exempted_sales = billreturn.tax_exempted_sales,
                isrealtime = billreturn.isrealtime,
                datetimeClient = billreturn.datetimeClient
            };
            client.BaseAddress = new Uri(apiBaseUrl);

            try
            {
                var response = client.PostAsJsonAsync("api/billreturn", p).Result;
                if (response.IsSuccessStatusCode)
                {
                    var responseCode = response.Content.ReadAsStringAsync();
                    if (responseCode.Result == "200")
                    {
                        roc.updateReturnedBill(returnLogId, responseCode.Result, response.ReasonPhrase.ToString(), DateTime.Now, salesMasterId, true);
                    }
                    else
                    {
                        roc.updateReturnedBill(returnLogId, responseCode.Result, "Error Code " + responseCode.Result, DateTime.Now, salesMasterId, true);
                    }
                }
                else
                {
                    var responseCode = response.Content.ReadAsStringAsync();
                    roc.updateReturnedBill(returnLogId, response.StatusCode.ToString(), response.ReasonPhrase.ToString(), DateTime.Now, salesMasterId, true);
                }

            }
            catch (Exception)
            {
                roc.updateReturnedBill(returnLogId, "420", "Error In Api", DateTime.Now, salesMasterId, true);
            }
        }
    }
    public static void syncReturnedSales()
    {
        //string posted = "";
        RestrOrderController roc = new RestrOrderController();
        companyInfo company = roc.getcompanyInfo().FirstOrDefault();
        string apiBaseUrl = ConfigurationManager.AppSettings["CbmsApiBaseUrl"].ToString();
        List<ReturnBillPostLog> errorPosts = roc.getErrorReturnBillPostLog();
        foreach (ReturnBillPostLog bill in errorPosts)
        {
            using (var client = new HttpClient())
            {
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(new
                MediaTypeWithQualityHeaderValue("application/json"));
                BillReturnViewModel p = new BillReturnViewModel
                {
                    username = company.CBMSUserName,
                    password = company.CBMSPassword,
                    seller_pan = bill.seller_pan,
                    buyer_pan = bill.buyer_pan,
                    buyer_name = bill.buyer_name,
                    fiscal_year = bill.fiscal_year,
                    ref_invoice_number = bill.ref_invoice_number,
                    credit_note_number = bill.credit_note_number,
                    credit_note_date = bill.credit_note_date,
                    reason_for_return = bill.reason_for_return,
                    total_sales = bill.total_sales,
                    taxable_sales_vat = bill.taxable_sales_vat,
                    vat = bill.vat,
                    excisable_amount = bill.excisable_amount,
                    excise = bill.excise,
                    taxable_sales_hst = bill.taxable_sales_hst,
                    hst = bill.hst,
                    amount_for_esf = bill.amount_for_esf,
                    esf = bill.esf,
                    export_sales = bill.export_sales,
                    tax_exempted_sales = bill.tax_exempted_sales,
                    isrealtime = false,
                    datetimeClient = DateTime.Now
                };
                client.BaseAddress = new Uri(apiBaseUrl);
                try
                {
                    var response = client.PostAsJsonAsync("api/billreturn", p).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        var responseCode = response.Content.ReadAsStringAsync();
                        if (responseCode.Result == "200")
                        {
                            roc.updateReturnedBill(bill.ReturnLogID, responseCode.Result, response.ReasonPhrase.ToString(), DateTime.Now, bill.SalesMasterId, false);
                        }
                        else
                        {
                            roc.updateReturnedBill(bill.ReturnLogID, responseCode.Result, "Error Code " + responseCode.Result, DateTime.Now, bill.SalesMasterId, false);
                        }
                    }
                    else
                    {
                        var responseCode = response.Content.ReadAsStringAsync();
                        roc.updateReturnedBill(bill.ReturnLogID, "420", "Error In API", DateTime.Now, bill.SalesMasterId, false);
                        break;
                    }
                }
                catch (Exception)
                {
                    roc.updateReturnedBill(bill.ReturnLogID, "420", "Error In API", DateTime.Now, bill.SalesMasterId, false);
                    break;
                }
            }
        }
    }
}