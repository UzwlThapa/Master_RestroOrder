SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----Drop PROCEDURE [dbo].[Usp_getGoodsReceiveReport] '2018-01-23', '2019-08-23', '', '', ''
CREATE PROCEDURE [dbo].[Usp_getGoodsReceiveReport]
    @StartDate DATETIME,
    @EndDate DATETIME,
    @puNo VARCHAR(250),
    @GmNo VARCHAR(250),
    @itemname VARCHAR(250),
    @paymentID INT = 0
AS
IF @itemname <> ''
    SET @itemname = '%' + @itemname + '%';

SELECT PM.PuNo,
       FORMAT(PM.PbDate, 'yyyy-MM-dd') AS PurchaseDate,
       GM.GMNo,
       PD.ItemID,
       PD.PurchaseDetailsID,
       IM.ITName,
       GD.Qnty AS Quentity,
       ISNULL(GD.Total, GD.Qnty * PD.UnitRate) AS Total,
       u1.Symbol,
       ISNULL(PD.Conversion, 1) AS conversion,
       PD.RecqDetailId,
       rq.RecqId,
       --,PD.UnitRate
       GM.GMId,
       ISNULL(GD.Rate, PD.UnitRate) AS UnitRate,
       PM.IvNo AS InvoiceNo,
       PM.Vid AS vendorId,
       ISNULL(GD.IsVat, 0) AS vat,
	   ISNULL(GD.IsVat, 0) AS IsVat,
       GM.InvoiceDate AS PostedOn,
       u1.UnitDescription,
       rpm.PaymentMode AS PaymentModeName,
       GD.Discount,
       CAST(CASE
           WHEN ISNULL(GD.IsVat, 0) = 0 THEN
               0
           ELSE
       (ISNULL(GD.Total, GD.Qnty * PD.UnitRate) - GD.Discount) * 0.13
       END AS DECIMAL(16,2)) AS VatTotal
FROM RO_GoodsReceivedMain GM
    INNER JOIN RO_GoodsReceivedDetls GD
        ON GM.GMId = GD.GMId
    INNER JOIN RO_PurchasePaymentMode ppm
        ON GM.GMId = ppm.GMId
    INNER JOIN RO_PaymentModes rpm
        ON rpm.PaymentModeID = ppm.paymentModeID
    LEFT JOIN ROI_PurchaseDetails PD
        ON PD.PurchaseDetailsID = GD.PDId
    INNER JOIN dbo.ROI_PurchaseMain PM
        ON PM.PurchaseMainID = PD.PurchaseMainID
    LEFT JOIN dbo.ROI_ITEMMain IM
        ON IM.ITId = PD.ItemID
    LEFT JOIN ROI_Unit1 u1
        ON u1.Unit1Id = PD.UsedUnitID
    LEFT JOIN Req_RecquistionDetails rqd
        ON rqd.RecqDetailId = PD.RecqDetailId
    LEFT JOIN Req_Recquistion rq
        ON rq.RecqId = rqd.RecqId
    LEFT JOIN RO_LoyaltyMembership lm
        ON lm.MembershipID = PM.Vid
WHERE (
          CAST(GM.PostedOn AS DATE) >= @StartDate
          OR @StartDate = 0
          OR @StartDate IS NULL
          OR @StartDate = ''
      )
      AND
      (
          CAST(GM.PostedOn AS DATE) <= @EndDate
          OR @EndDate = 0
          OR @EndDate IS NULL
          OR @EndDate = ''
      )
      AND
      (
          PM.PuNo = @puNo
          OR @puNo = ''
          OR @puNo IS NULL
      )
      AND
      (
          GM.GMNo = @GmNo
          OR @GmNo = ''
          OR @GmNo IS NULL
      )
      AND
      (
          IM.ITName LIKE @itemname
          OR @itemname = ''
          OR @itemname IS NULL
      )
      AND GD.Qnty <> 0
      AND
      (
          @paymentID = 0
          OR ppm.paymentModeID = @paymentID
      )
--pm.PuNo = @PONO

ORDER BY GM.GMId DESC;

GO
