SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- drop proc USP_PO_GoodsRecieve 1
CREATE PROCEDURE [dbo].[USP_PO_GoodsRecieve]
    @GMId INT
AS
    BEGIN

        SELECT   GM.InvoiceNo ,
                 CONVERT (VARCHAR (10), GM.InvoiceDate, 120) AS InvoiceDate ,
                 IM.ITName ,
                 GD.Qnty AS Quentity ,
                 u1.Symbol ,
                 ISNULL (GD.Rate, PD.UnitRate) AS UnitRate ,
                 CONVERT (NUMERIC (10, 2), ( ISNULL (GD.Total, GD.Qnty * PD.UnitRate))) AS Total ,
                 rl.Fname ,
                 rl.Address + ', ' + rl.City + ', ' + rl.Country AS Address ,
                 rl.TelWork ,
                 ISNULL (GD.IsVat, 0) AS IsVat ,
                 ISNULL (GD.Discount, 0) AS Discount ,
                 ISNULL (GM.ExtraDiscount, 0) AS ExtraDiscount ,
                 --,py.PaymentMode as PayMode
                 ( SELECT ISNULL (STUFF (( SELECT ' & ' + pms.PaymentMode
                                           FROM   dbo.RO_PurchasePaymentMode spm
                                                  INNER JOIN dbo.RO_PaymentModes pms ON spm.paymentModeID = pms.PaymentModeID
                                           WHERE  spm.GMId = GM.GMId --and spm.PaymentModeID = 4
                                         FOR XML PATH (''), TYPE ).value ('.', 'NVARCHAR(MAX)') ,
                                         1 ,
                                         3 ,
                                         '') ,
                                  '')) AS PayMode ,
                 PM.PuNo
        FROM     dbo.RO_GoodsReceivedDetls GD
                 INNER JOIN dbo.RO_GoodsReceivedMain GM ON GM.GMId = GD.GMId
                 INNER JOIN dbo.ROI_PurchaseDetails PD ON GD.PDId = PD.PurchaseDetailsID
                 INNER JOIN dbo.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID
                 INNER JOIN dbo.ROI_ITEMMain IM ON IM.ITId = PD.ItemID
                 INNER JOIN dbo.ROI_Unit1 u1 ON u1.Unit1Id = PD.UsedUnitID
                 LEFT JOIN dbo.RO_LoyaltyMembership rl ON rl.MembershipID = PD.VendorPurchaseId
                 LEFT JOIN dbo.RO_PurchasePaymentMode ppm ON ppm.GMId = GM.GMId
        --left join RO_PaymentModes py on py.PaymentModeID = ppm.paymentModeID 
        WHERE    GM.GMId = @GMId
        AND      GD.Qnty <> 0
        GROUP BY IM.ITName ,
                 GD.Qnty ,
                 u1.Symbol ,
                 GD.Total ,
                 GD.Rate ,
                 GM.InvoiceDate ,
                 GM.InvoiceNo ,
                 rl.Address ,
                 rl.City ,
                 rl.Country ,
                 rl.Fname ,
                 rl.TelWork ,
                 rl.IsVat ,
                 GD.Discount ,
                 GD.IsVat ,
                 GM.ExtraDiscount ,
                 --,py.PaymentMode
                 PD.UnitRate ,
                 GM.GMId ,
                 PM.PuNo;

    END;




GO
