SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_PO_GoodsRecieveFromPurchaseID 165
-- drop proc USP_PO_GoodsRecieveFromPurchaseID
CREATE PROCEDURE [dbo].[USP_PO_GoodsRecieveFromPurchaseID] @PurchaseMainID INT
AS
BEGIN

    SELECT GM.InvoiceNo,
           CONVERT(VARCHAR(10), GM.InvoiceDate, 120) AS InvoiceDate,
           IM.ITName,
           GD.Qnty AS Quentity,
           u1.Symbol,
           --,NULLIF(GD.Rate, 0) AS Rate
           ISNULL(GD.Rate, 0) AS UnitRate,
           CONVERT(NUMERIC(10, 2), (ISNULL(GD.Total, 0))) AS Total,
           rl.Fname,
           rl.Address + ', ' + rl.City + ', ' + rl.Country AS Address,
           rl.TelWork,
           ISNULL(PD.IsVat, 0) AS IsVat,
           ISNULL(PD.Discount, 0) AS Discount,
           ISNULL(GM.ExtraDiscount, 0) AS ExtraDiscount,
           (
               SELECT ISNULL(STUFF(
                                      (
                                          SELECT ' & ' + pms.PaymentMode
                                          FROM RO_PurchasePaymentMode spm
                                              INNER JOIN RO_PaymentModes pms
                                                  ON spm.paymentModeID = pms.PaymentModeID
                                          WHERE spm.GMId = GM.GMId --and spm.PaymentModeID = 4
                                          FOR XML PATH(''), TYPE
                                      ).value('.', 'NVARCHAR(MAX)'),
                                      1,
                                      3,
                                      ''
                                  ),
                             ''
                            )
           ) AS PayMode,
           PM.PuNo
    FROM RO_GoodsReceivedDetls GD
        INNER JOIN RO_GoodsReceivedMain GM
            ON GM.GMId = GD.GMId
        INNER JOIN ROI_PurchaseDetails PD
            ON GD.PDId = PD.PurchaseDetailsID
        INNER JOIN dbo.ROI_PurchaseMain PM
            ON PM.PurchaseMainID = PD.PurchaseMainID
        INNER JOIN dbo.ROI_ITEMMain IM
            ON IM.ITId = PD.ItemID
        LEFT JOIN ROI_Unit1 u1
            ON u1.Unit1Id = PD.UsedUnitID
        LEFT JOIN RO_LoyaltyMembership rl
            ON rl.MembershipID = PD.VendorPurchaseId
        --inner join RO_PaymentModes py on py.PaymentModeID = GM.paymentMode
        LEFT JOIN RO_PurchasePaymentMode ppm
            ON ppm.GMId = GM.GMId
    WHERE PM.PurchaseMainID = @PurchaseMainID
    GROUP BY IM.ITName,
             GD.Qnty,
             u1.Symbol,
             GD.Total,
             GD.Rate,
             GM.InvoiceDate,
             GM.InvoiceNo,
             rl.Address,
             rl.City,
             rl.Country,
             rl.Fname,
             rl.TelWork,
             rl.IsVat,
             PD.Discount,
             PD.IsVat,
             GM.ExtraDiscount,
             GM.GMId,
             PM.PuNo;

END;



GO
