SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [USP_RO_GetdataforViewBill] 6511
CREATE PROCEDURE [dbo].[USP_RO_GetdataforViewBill]
    @OrderMasterID INT
AS
    BEGIN
        DECLARE @code VARCHAR (10);

        SET @code = ( SELECT TOP ( 1 ) Code
                      FROM   RO_CompanyInfo );
        SELECT   *
        FROM     ( SELECT SD.ItemId ,
                          SD.IsCombo ,
                          ISNULL (SD.qty, 0) AS Quantity ,
                          ISNULL (SD.rate, 0) AS Rate ,
                          ISNULL (( SD.qty * SD.rate ), 0) AS Amount ,
                          0 AS Bevrage ,
                          0 AS Bakery ,
                          0 AS Pizza ,
                          SM.OrderMasterId ,
                          '' AS Note ,
                          0 AS ExtraCharge ,
                          it.ITName ,
                          SM.BillDate AS DATE ,
                          SM.NepaliInvoiceDate ,
                          SM.BasicAmount ,
                          rt.restrotableTitle ,
                          SM.totaldiscount ,
                          ISNULL (SM.PrintCount, 0) AS PrintCount ,
                          @code + fy.fyName + '-' + CAST(( SM.InvoiceNo - fy.FirstSalesMasterID ) AS VARCHAR) AS BillNo ,
                          ( fy.fyName ) AS fiscalYear ,
                          ISNULL (SM.CusID, 0) AS CusID ,
                          SM.CusName AS CusName ,
                          SM.PAN ,
                          ISNULL (SM.[Address], '') AS Address ,
                          SM.salesMasterId ,
                          SM.AddedBy AS Cashier ,
                          ISNULL (SM.RoomRate, 0) AS RoomRate ,
                          ISNULL (SM.RoomCharge, 0) AS RoomCharge ,
                          ISNULL (SM.BookedDays, 0) AS BookedDays ,
                          ISNULL (SM.AdvancePayment, 0) AS AdvancePayment ,
                          rt.IsTable ,
                          SM.DeliveredBy ,
                          ISNULL (SM.PhoneNumber, '') AS PhoneNumber ,
                          CCG.GroupId ,
                          SD.HsCode
                   FROM   dbo.RO_SalesMaster SM
                          LEFT JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                          LEFT JOIN dbo.RO_fiscalYear fy ON fy.fyId = SM.FiscalYearID
                          LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = SM.TableId
                          LEFT JOIN dbo.ROI_ITEMMain it ON it.ITId = SD.ItemId
                          LEFT JOIN dbo.RO_SalesPaymentMode sp ON sp.salesMasterId = SM.salesMasterId
                          LEFT JOIN dbo.CostCenterInfo CC ON CC.CostCenterId = SD.CostCenterId
                          LEFT JOIN dbo.RO_CostCenterGroup CCG ON CCG.GroupId = CC.GroupId
                   WHERE  SM.salesMasterId = @OrderMasterID
                   AND    ( SD.IsCombo = 0
                         OR SD.IsCombo IS NULL )
                   UNION
                   SELECT SD.ItemId ,
                          SD.IsCombo ,
                          ISNULL (SD.qty, 0) AS Quantity ,
                          ISNULL (SD.rate, 0) AS Rate ,
                          ISNULL (( SD.qty * SD.rate ), 0) AS Amount ,
                          0 AS Bevrage ,
                          0 AS Bakery ,
                          0 AS Pizza ,
                          SM.OrderMasterId ,
                          '' AS Note ,
                          0 AS ExtraCharge ,
                          it.Name AS ITName ,
                          SM.BillDate AS DATE ,
                          SM.NepaliInvoiceDate ,
                          SM.BasicAmount ,
                          rt.restrotableTitle ,
                          SM.totaldiscount ,
                          ISNULL (SM.PrintCount, 0) AS PrintCount ,
                          @code + fy.fyName + '-' + CAST(( SM.InvoiceNo - fy.FirstSalesMasterID ) AS VARCHAR) AS BillNo ,
                          ( fy.fyName ) AS fiscalYear ,
                          ISNULL (SM.CusID, 0) AS CusID ,
                          SM.CusName AS CusName ,
                          SM.PAN ,
                          ISNULL (SM.[Address], '') AS Address ,
                          SM.salesMasterId ,
                          SM.AddedBy AS Cashier ,
                          ISNULL (SM.RoomRate, 0) AS RoomRate ,
                          ISNULL (SM.RoomCharge, 0) AS RoomCharge ,
                          ISNULL (SM.BookedDays, 0) AS BookedDays ,
                          ISNULL (SM.AdvancePayment, 0) AS AdvancePayment ,
                          rt.IsTable ,
                          SM.DeliveredBy ,
                          ISNULL (SM.PhoneNumber, '') AS PhoneNumber ,
                          CCG.GroupId ,
                          SD.HsCode
                   FROM   dbo.RO_SalesMaster SM
                          LEFT JOIN dbo.RO_SalesDetail SD ON SM.salesMasterId = SD.salesMasterId
                          LEFT JOIN dbo.RO_fiscalYear fy ON fy.fyId = SM.FiscalYearID
                          LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = SM.TableId
                          LEFT JOIN dbo.RO_Combo it ON it.ComboID = SD.ItemId
                          LEFT JOIN dbo.RO_SalesPaymentMode sp ON sp.salesMasterId = SM.salesMasterId
                          LEFT JOIN dbo.CostCenterInfo CC ON CC.CostCenterId = SD.CostCenterId
                          LEFT JOIN dbo.RO_CostCenterGroup CCG ON CCG.GroupId = CC.GroupId
                   WHERE  SM.salesMasterId = @OrderMasterID
                   AND    ( SD.IsCombo = 1
                         OR SD.IsCombo IS NULL )) AS x
        ORDER BY ITName;
    END;

GO
