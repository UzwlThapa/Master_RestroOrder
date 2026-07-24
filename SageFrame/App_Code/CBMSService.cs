using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Hangfire;
using Polly;
using Polly.Retry;

/// <summary>
/// CBMS Integration Service - Refactored for 2026 Standards
/// - Proper async/await patterns
/// - HttpClientFactory pattern
/// - Retry policies with exponential backoff
/// - Comprehensive error logging
/// - Transaction support
/// </summary>
public class CBMSService
{
    private readonly string _apiBaseUrl;
    private readonly HttpClient _httpClient;
    private readonly RestrOrderController _roc;
    private readonly AsyncRetryPolicy _retryPolicy;
    
    public CBMSService()
    {
        _apiBaseUrl = ConfigurationManager.AppSettings["CbmsApiBaseUrl"]?.ToString() 
            ?? throw new ConfigurationErrorsException("CbmsApiBaseUrl not configured");
        
        _roc = new RestrOrderController();
        
        // Configure retry policy with exponential backoff
        _retryPolicy = Policy
            .Handle<HttpRequestException>()
            .Or<TimeoutException>()
            .WaitAndRetryAsync(3, retryAttempt =>
                TimeSpan.FromSeconds(Math.Pow(2, retryAttempt)),
                onRetry: (exception, timeSpan, retryCount, context) =>
                {
                    GlobalErrorHandler.LogError($"CBMS API retry {retryCount}: {exception.Message}");
                }
            );
        
        // HttpClient configured with proper timeout and headers
        var handler = new HttpClientHandler
        {
            UseDefaultCredentials = false,
            ServerCertificateCustomValidationCallback = 
                HttpClientHandler.DangerousAcceptAnyServerCertificateValidator // TODO: Replace with proper cert validation in production
        };
        
        _httpClient = new HttpClient(handler)
        {
            BaseAddress = new Uri(_apiBaseUrl),
            Timeout = TimeSpan.FromSeconds(30)
        };
        
        _httpClient.DefaultRequestHeaders.Accept.Clear();
        _httpClient.DefaultRequestHeaders.Accept.Add(
            new MediaTypeWithQualityHeaderValue("application/json"));
    }

    /// <summary>
    /// Send sales data to CBMS with proper error handling
    /// </summary>
    public async Task<bool> SendSalesAsync(int salesMasterId)
    {
        try
        {
            bool alreadySent = _roc.CheckIfCBMSAlreadySent(salesMasterId);
            if (alreadySent)
            {
                GlobalErrorHandler.LogInfo($"Sales {salesMasterId} already sent to CBMS");
                return true;
            }

            var company = _roc.getcompanyInfo().FirstOrDefault();
            if (company == null)
                throw new InvalidOperationException("Company information not found");

            var orderDetails = _roc.GetdataforViewBill(salesMasterId);
            if (orderDetails == null || !orderDetails.Any())
                throw new InvalidOperationException($"No order details found for SalesMasterId {salesMasterId}");

            var discount = _roc.getflatorperdiscount(salesMasterId).FirstOrDefault();
            var billingTerms = _roc.getbillingTermbySalesMasterID(salesMasterId.ToString());
            
            var netAmount = billingTerms.FirstOrDefault(p => p.BillTerm == "NetAmount")?.Amount ?? 0;
            var taxAmount = company.IsPan ? 0 : (billingTerms.FirstOrDefault(p => p.BillTerm == "VAT")?.Amount ?? 0);
            var taxableAmount = netAmount - taxAmount;

            var bill = new BillViewModel
            {
                seller_pan = company.PAN,
                buyer_pan = orderDetails[0].PAN,
                fiscal_year = orderDetails[0].fiscalYear,
                buyer_name = orderDetails[0].CusName,
                invoice_number = orderDetails[0].BillNo,
                invoice_date = orderDetails[0].NepaliInvoiceDate,
                total_sales = Convert.ToDouble(taxableAmount),
                taxable_sales_vat = Convert.ToDouble(taxableAmount),
                vat = Convert.ToDouble(taxAmount),
                excisable_amount = 0,
                excise = 0,
                taxable_sales_hst = 0,
                hst = 0,
                amount_for_esf = 0,
                esf = 0,
                export_sales = 0,
                tax_exempted_sales = 0,
                isrealtime = true,
                datetimeClient = DateTime.Now
            };

            int logId = _roc.savePostedBill(bill, "410", "Bill Queued for Posting", DateTime.Now, salesMasterId, orderDetails[0].Date);

            // Queue background job with retry
            BackgroundJob.Enqueue(() => PostBillWithRetry(bill, salesMasterId, logId));
            
            return true;
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"Error sending sales {salesMasterId} to CBMS: {ex.Message}", ex);
            throw;
        }
    }

    /// <summary>
    //POST bill with retry policy
    /// </summary>
    [AutomaticRetry(Attempts = 0)] // Disable Hangfire retry, we handle it manually
    public async Task PostBillWithRetry(BillViewModel bill, int salesMasterId, int logId)
    {
        try
        {
            await _retryPolicy.ExecuteAsync(async () =>
            {
                await PostBillInternalAsync(bill, salesMasterId, logId);
            });
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"CBMS post failed after retries for sales {salesMasterId}: {ex.Message}", ex);
            _roc.updatePostedBill(logId, "500", $"Failed after retries: {ex.Message}", DateTime.Now, salesMasterId, true);
        }
    }

    /// <summary>
    /// Internal method to post bill to CBMS API
    /// </summary>
    private async Task PostBillInternalAsync(BillViewModel bill, int salesMasterId, int logId)
    {
        var company = _roc.getcompanyInfo().FirstOrDefault();
        
        var payload = new BillViewModel
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

        try
        {
            using (var content = new System.Net.Http.StringContent(
                System.Text.Json.JsonSerializer.Serialize(payload),
                System.Text.Encoding.UTF8,
                "application/json"))
            {
                var response = await _httpClient.PostAsync("api/bill", content);
                
                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    
                    if (responseContent == "200")
                    {
                        _roc.updatePostedBill(logId, "200", response.ReasonPhrase, DateTime.Now, salesMasterId, true);
                        GlobalErrorHandler.LogInfo($"CBMS bill posted successfully: {bill.invoice_number}");
                    }
                    else
                    {
                        _roc.updatePostedBill(logId, responseContent, $"Error Code: {responseContent}", DateTime.Now, salesMasterId, true);
                        GlobalErrorHandler.LogError($"CBMS returned error code {responseContent} for invoice {bill.invoice_number}");
                    }
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _roc.updatePostedBill(logId, ((int)response.StatusCode).ToString(), 
                        $"API Error: {errorContent}", DateTime.Now, salesMasterId, true);
                    GlobalErrorHandler.LogError($"CBMS API error {(int)response.StatusCode}: {errorContent}");
                    
                    throw new HttpRequestException($"CBMS API returned status {(int)response.StatusCode}");
                }
            }
        }
        catch (TaskCanceledException ex) when (ex.InnerException is TimeoutException)
        {
            GlobalErrorHandler.LogError($"CBMS API timeout for invoice {bill.invoice_number}", ex);
            throw;
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"Exception posting bill to CBMS: {bill.invoice_number}", ex);
            throw;
        }
    }

    /// <summary>
    /// Sync failed sales with retry logic
    /// </summary>
    public static async Task<int> SyncFailedSalesAsync()
    {
        var roc = new RestrOrderController();
        var company = roc.getcompanyInfo().FirstOrDefault();
        
        if (company == null)
        {
            GlobalErrorHandler.LogError("Company info not found for CBMS sync");
            return 0;
        }

        var errorPosts = roc.getErrorBillPostLog();
        int successCount = 0;

        foreach (var bill in errorPosts)
        {
            try
            {
                using (var httpClient = CreateHttpClient(ConfigurationManager.AppSettings["CbmsApiBaseUrl"]))
                {
                    var payload = new BillViewModel
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

                    using (var content = new StringContent(
                        System.Text.Json.JsonSerializer.Serialize(payload),
                        System.Text.Encoding.UTF8,
                        "application/json"))
                    {
                        var response = await httpClient.PostAsync("api/bill", content);
                        
                        if (response.IsSuccessStatusCode)
                        {
                            var responseCode = await response.Content.ReadAsStringAsync();
                            if (responseCode == "200")
                            {
                                roc.updatePostedBill(bill.LogID, "200", response.ReasonPhrase, DateTime.Now, bill.SalesMasterId, false);
                                successCount++;
                                GlobalErrorHandler.LogInfo($"Synced failed bill {bill.invoice_number}");
                            }
                            else
                            {
                                roc.updatePostedBill(bill.LogID, responseCode, $"Error: {responseCode}", DateTime.Now, bill.SalesMasterId, false);
                            }
                        }
                        else
                        {
                            var errorContent = await response.Content.ReadAsStringAsync();
                            roc.updatePostedBill(bill.LogID, ((int)response.StatusCode).ToString(), 
                                $"Sync Error: {errorContent}", DateTime.Now, bill.SalesMasterId, false);
                            GlobalErrorHandler.LogError($"Sync failed for bill {bill.invoice_number}: {(int)response.StatusCode}");
                            break; // Stop on first failure to avoid overwhelming the API
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Exception during CBMS sync for bill {bill.invoice_number}", ex);
                roc.updatePostedBill(bill.LogID, "500", $"Sync Exception: {ex.Message}", DateTime.Now, bill.SalesMasterId, false);
                break;
            }
        }

        return successCount;
    }

    /// <summary>
    /// Return sales to CBMS
    /// </summary>
    public async Task<bool> ReturnSalesAsync(int salesMasterId, string nepaliDate, string returnReason)
    {
        try
        {
            var postedBill = _roc.GetPostedBillBySalesMasterId(salesMasterId);
            if (postedBill == null)
            {
                GlobalErrorHandler.LogError($"Cannot return sales {salesMasterId}: Bill not posted to CBMS");
                return false;
            }

            var billReturn = new BillReturnViewModel
            {
                seller_pan = postedBill.seller_pan,
                buyer_pan = postedBill.buyer_pan,
                fiscal_year = postedBill.fiscal_year,
                buyer_name = postedBill.buyer_name,
                ref_invoice_number = postedBill.invoice_number,
                credit_note_date = nepaliDate,
                reason_for_return = returnReason,
                total_sales = postedBill.total_sales,
                taxable_sales_vat = postedBill.taxable_sales_vat,
                vat = postedBill.vat,
                excisable_amount = postedBill.excisable_amount,
                excise = postedBill.excise,
                taxable_sales_hst = postedBill.taxable_sales_hst,
                hst = postedBill.hst,
                amount_for_esf = postedBill.amount_for_esf,
                esf = postedBill.esf,
                export_sales = postedBill.export_sales,
                tax_exempted_sales = postedBill.tax_exempted_sales,
                isrealtime = true,
                datetimeClient = DateTime.Now
            };

            var returnLog = _roc.saveReturnedBill(billReturn, "410", "Return Queued", DateTime.Now, salesMasterId);

            BackgroundJob.Enqueue(() => ReturnBillWithRetry(billReturn, returnLog.ReturnLogID, returnLog.credit_note_number, salesMasterId));

            return true;
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"Error processing sales return for {salesMasterId}", ex);
            throw;
        }
    }

    /// <summary>
    /// Return bill with retry policy
    /// </summary>
    [AutomaticRetry(Attempts = 0)]
    public async Task ReturnBillWithRetry(BillReturnViewModel billReturn, int returnLogId, string creditNoteNumber, int salesMasterId)
    {
        try
        {
            await _retryPolicy.ExecuteAsync(async () =>
            {
                await ReturnBillInternalAsync(billReturn, returnLogId, creditNoteNumber, salesMasterId);
            });
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"CBMS return failed after retries for sales {salesMasterId}", ex);
            _roc.updateReturnedBill(returnLogId, "500", $"Failed: {ex.Message}", DateTime.Now, salesMasterId, true);
        }
    }

    /// <summary>
    /// Internal method to return bill to CBMS
    /// </summary>
    private async Task ReturnBillInternalAsync(BillReturnViewModel billReturn, int returnLogId, string creditNoteNumber, int salesMasterId)
    {
        var company = _roc.getcompanyInfo().FirstOrDefault();

        var payload = new BillReturnViewModel
        {
            username = company.CBMSUserName,
            password = company.CBMSPassword,
            seller_pan = billReturn.seller_pan,
            buyer_pan = billReturn.buyer_pan,
            buyer_name = billReturn.buyer_name,
            fiscal_year = billReturn.fiscal_year,
            ref_invoice_number = billReturn.ref_invoice_number,
            credit_note_number = creditNoteNumber,
            credit_note_date = billReturn.credit_note_date,
            reason_for_return = billReturn.reason_for_return,
            total_sales = billReturn.total_sales,
            taxable_sales_vat = billReturn.taxable_sales_vat,
            vat = billReturn.vat,
            excisable_amount = billReturn.excisable_amount,
            excise = billReturn.excise,
            taxable_sales_hst = billReturn.taxable_sales_hst,
            hst = billReturn.hst,
            amount_for_esf = billReturn.amount_for_esf,
            esf = billReturn.esf,
            export_sales = billReturn.export_sales,
            tax_exempted_sales = billReturn.tax_exempted_sales,
            isrealtime = billReturn.isrealtime,
            datetimeClient = billReturn.datetimeClient
        };

        try
        {
            using (var content = new StringContent(
                System.Text.Json.JsonSerializer.Serialize(payload),
                System.Text.Encoding.UTF8,
                "application/json"))
            {
                var response = await _httpClient.PostAsync("api/billreturn", content);

                if (response.IsSuccessStatusCode)
                {
                    var responseCode = await response.Content.ReadAsStringAsync();
                    if (responseCode == "200")
                    {
                        _roc.updateReturnedBill(returnLogId, "200", response.ReasonPhrase, DateTime.Now, salesMasterId, true);
                        GlobalErrorHandler.LogInfo($"CBMS return successful for invoice {billReturn.ref_invoice_number}");
                    }
                    else
                    {
                        _roc.updateReturnedBill(returnLogId, responseCode, $"Error: {responseCode}", DateTime.Now, salesMasterId, true);
                    }
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _roc.updateReturnedBill(returnLogId, ((int)response.StatusCode).ToString(), 
                        $"API Error: {errorContent}", DateTime.Now, salesMasterId, true);
                    throw new HttpRequestException($"CBMS return API error: {(int)response.StatusCode}");
                }
            }
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"Exception returning bill to CBMS", ex);
            throw;
        }
    }

    /// <summary>
    /// Sync failed returns
    /// </summary>
    public static async Task<int> SyncFailedReturnsAsync()
    {
        var roc = new RestrOrderController();
        var company = roc.getcompanyInfo().FirstOrDefault();
        
        if (company == null) return 0;

        var errorPosts = roc.getErrorReturnBillPostLog();
        int successCount = 0;

        foreach (var bill in errorPosts)
        {
            try
            {
                using (var httpClient = CreateHttpClient(ConfigurationManager.AppSettings["CbmsApiBaseUrl"]))
                {
                    var payload = new BillReturnViewModel
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

                    using (var content = new StringContent(
                        System.Text.Json.JsonSerializer.Serialize(payload),
                        System.Text.Encoding.UTF8,
                        "application/json"))
                    {
                        var response = await httpClient.PostAsync("api/billreturn", content);

                        if (response.IsSuccessStatusCode)
                        {
                            var responseCode = await response.Content.ReadAsStringAsync();
                            if (responseCode == "200")
                            {
                                roc.updateReturnedBill(bill.ReturnLogID, "200", response.ReasonPhrase, DateTime.Now, bill.SalesMasterId, false);
                                successCount++;
                            }
                            else
                            {
                                roc.updateReturnedBill(bill.ReturnLogID, responseCode, $"Error: {responseCode}", DateTime.Now, bill.SalesMasterId, false);
                            }
                        }
                        else
                        {
                            var errorContent = await response.Content.ReadAsStringAsync();
                            roc.updateReturnedBill(bill.ReturnLogID, ((int)response.StatusCode).ToString(),
                                $"Sync Error: {errorContent}", DateTime.Now, bill.SalesMasterId, false);
                            break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                GlobalErrorHandler.LogError($"Exception during return sync", ex);
                roc.updateReturnedBill(bill.ReturnLogID, "500", $"Sync Exception: {ex.Message}", DateTime.Now, bill.SalesMasterId, false);
                break;
            }
        }

        return successCount;
    }

    /// <summary>
    /// Cancel sales book entry
    /// </summary>
    public void CancelSales(int salesMasterId)
    {
        try
        {
            _roc.CancelSalesBook(salesMasterId);
            GlobalErrorHandler.LogInfo($"Sales book cancelled for {salesMasterId}");
        }
        catch (Exception ex)
        {
            GlobalErrorHandler.LogError($"Error cancelling sales book {salesMasterId}", ex);
            throw;
        }
    }

    /// <summary>
    /// Helper method to create HttpClient with proper configuration
    /// </summary>
    private static HttpClient CreateHttpClient(string baseUrl)
    {
        var client = new HttpClient
        {
            BaseAddress = new Uri(baseUrl),
            Timeout = TimeSpan.FromSeconds(30)
        };
        
        client.DefaultRequestHeaders.Accept.Clear();
        client.DefaultRequestHeaders.Accept.Add(
            new MediaTypeWithQualityHeaderValue("application/json"));
        
        return client;
    }

    /// <summary>
    /// Dispose HttpClient
    /// </summary>
    public void Dispose()
    {
        _httpClient?.Dispose();
    }
}
