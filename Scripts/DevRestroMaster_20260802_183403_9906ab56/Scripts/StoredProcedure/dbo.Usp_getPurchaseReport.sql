SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_getPurchaseReport] -- NULL, NULL, 0, ''

    @StartDate DATETIME = NULL,
    @EndDate DATETIME = NULL,
    @VendorID INT = 0,
    @puNo VARCHAR(250) = NULL
AS


if(isnull(@StartDate,''))='' set @StartDate = '2000-01-01' 
if(isnull(@EndDate,''))='' set @EndDate = GETDATE() 

SELECT pm.PurchaseMainID,
       fy.fyName,
       pm.PuNo,
       lm.Fname AS VenderName,
       lm.[Address],
       FORMAT(pm.PbDate, 'yyyy-MM-dd') AS BillDate,
       pm.PostedOn AS PostedOn,
       pm.PostedBy,
       SUM(pd.Total) AS Amount,
       ISNULL(lm.IsVat, 0) IsVat
FROM ROI_PurchaseMain pm
    INNER JOIN ROI_PurchaseDetails pd
        ON pm.PurchaseMainID = pd.PurchaseMainID
    --LEFT JOIN ROI_PurchaseLotNo pln ON pln.PurchaseDetailsID = pd.PurchaseDetailsID
    LEFT JOIN ROI_ITEMMain im
        ON im.ITId = pd.ItemID
    LEFT JOIN ROI_Unit1 u1
        ON u1.Unit1Id = pd.UsedUnitID
    LEFT JOIN RO_LoyaltyMembership lm
        ON lm.MembershipID = pm.Vid
    LEFT JOIN RO_fiscalYear fy
        ON fy.fyId = pm.FyId
WHERE cast(pm.PbDate as date) between cast(@startdate as date) and cast(@enddate as date)
      --(
      --    CAST(pm.PostedOn AS DATE) >= @StartDate
      --    OR @StartDate = 0
      --    OR @StartDate IS NULL
      --    OR @StartDate = ''
      --)
      --AND
      --(
      --    CAST(pm.PostedOn AS DATE) <= @EndDate
      --    OR @EndDate = 0
      --    OR @EndDate IS NULL
      --    OR @EndDate = ''
      --)
      AND
      (
          pm.Vid = @VendorID
          OR @VendorID = 0
      )
      AND
      (
          pm.PuNo = @puNo
          OR @puNo = ''
          OR @puNo IS NULL
      )
GROUP BY pm.PurchaseMainID,
         fy.fyName,
         pm.PuNo,
         lm.Fname,
         lm.[Address],
         pm.PbDate,
         pm.PostedBy,
         pm.PostedOn,
         lm.IsVat
ORDER BY pm.PurchaseMainID DESC;


GO
