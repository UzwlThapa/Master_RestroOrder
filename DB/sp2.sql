SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[USP_RO_CAKE_GetdataforViewBill]
    @SalesMasterId INT,
    @SalesType     VARCHAR(30)
AS
BEGIN
    DECLARE @code VARCHAR(10)

    SET @code = (SELECT TOP (1) Code FROM RO_CompanyInfo)

    SELECT * FROM
    (
        SELECT SD.ItemId
            ,ISNULL(SD.Quantity, 0) Quantity
            ,ISNULL(SD.Rate, 0) Rate
            ,ISNULL(SD.Amount, ISNULL(SD.Quantity,0) * ISNULL(SD.Rate,0)) Amount
            ,it.HsCode
            ,SM.OrderMasterId OrderMasterId
            ,'' Note
            ,0 ExtraCharge
            ,it.ITName
            ,SM.BillDate DATE
            ,SM.NepaliInvoiceDate
            ,SM.BasicAmount
            ,SM.NetAmount
            ,SM.TenderAmount
            ,SM.ReturnAmount
            ,ISNULL(sm.PrintCount, 0) AS PrintCount
            ,@code + fy.fyName + '-' + CAST((sm.InvoiceNo - fy.FirstSalesMasterID) AS VARCHAR) AS BillNo
            ,(fy.fyName) AS fiscalYear
            ,SM.CustomerId CusID
            ,CASE WHEN sp.Customer = '' THEN SM.CustomerName
                  ELSE ISNULL(sp.Customer, SM.CustomerName) END CusName
            ,SM.ContactNo
            ,SM.PAN
            ,SM.Address
            ,SM.salesMasterId
            ,SM.AddedBy AS Cashier
            ,ISNULL(SM.AdvancePayment, 0) AS AdvancePayment
            ,ISNULL(OM.DeliveryService,'') DeliveryService
            ,ISNULL(OM.DeliveryTime,'')    DeliveryTime
        FROM RO_CakeSalesMaster SM
        LEFT JOIN RO_CakeSalesDetail SD
               ON SM.salesMasterId = SD.salesMasterId
              AND LOWER(SM.SalesType) = LOWER(SD.SalesType)
        LEFT JOIN RO_fiscalYear fy
               ON fy.fyId = sm.FiscalYearID
        LEFT JOIN ROI_ITEMMain it
               ON it.ITId = sd.ItemId
        LEFT JOIN RO_Cake_SalesPaymentMode sp
               ON sp.salesMasterId = SM.salesMasterId
              AND LOWER(sp.SalesType) = LOWER(SM.SalesType)
        LEFT JOIN RO_CakeOrderMaster OM
               ON OM.OrderMasterId = SM.OrderMasterId
        WHERE SM.salesMasterId = @SalesMasterId
          AND LOWER(ISNULL(SM.SalesType,'')) = LOWER(ISNULL(@SalesType,''))
    ) AS x
    ORDER BY ITName

    UPDATE RO_CakeOrderMaster
       SET StatusId = (SELECT Id FROM RO_StatusMaster
                       WHERE LookUpName = 'paid'
                         AND LOWER(UseFor) = LOWER(@SalesMasterId))
     WHERE OrderMasterID = (SELECT OrderMasterID FROM RO_CakeSalesMaster
                            WHERE SalesMasterId = @SalesMasterId
                              AND LOWER(ISNULL(SalesType,'')) = LOWER(ISNULL(@SalesType,'')))
END
GO