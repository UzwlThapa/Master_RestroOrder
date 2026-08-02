SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- BACKUP FIRST
-- BACKUP DATABASE [YourDbName] TO DISK = 'C:\Backup\pre_purchasereturn_fix.bak'

-- =============================================
-- FIX 1: vendorId returning -1
-- =============================================
CREATE PROCEDURE [dbo].[Usp_GetGoodReceiveDetailsbyGmNo] @GMNo NVARCHAR(250)
AS
SELECT GM.GMId,
       GM.GMNo,
       GD.GDId,
       PD.ItemID,
       IM.ITName AS ItemName,
       GD.Qnty,
       GD.Qnty - SUM(ISNULL(prd.Qnty, 0)) AS RemainingQnty,
       u1.Symbol,
       ISNULL(PD.Conversion, 1) AS conversion,
       GD.Rate,
       GM.vendorId,
       GM.InvoiceNo,
       ISNULL(GD.STId, GM.STId) AS STId,
       rst.StName,
       rs.StName AS StoreName,
       lm.Fname,
       PD.UsedUnitID
FROM RO_GoodsReceivedDetls GD
    INNER JOIN RO_GoodsReceivedMain GM
        ON GM.GMId = GD.GMId
    INNER JOIN ROI_PurchaseDetails PD
        ON PD.PurchaseDetailsID = GD.PDId
    INNER JOIN ROI_ITEMMain IM
        ON IM.ITId = PD.ItemID
    LEFT JOIN ROI_Unit1 u1
        ON u1.Unit1Id = PD.UsedUnitID
    LEFT JOIN RO_LoyaltyMembership lm
        ON lm.MembershipID = GM.vendorId
    LEFT JOIN ROI_Store rs
        ON rs.STId = GM.STId
    LEFT JOIN ROI_Store rst
        ON rst.STId = GD.STId
    LEFT JOIN RO_PurchaseReturnDetails prd
        ON prd.GDId = GD.GDId
WHERE GM.GMNo = @GMNo
GROUP BY GM.GMId,
         GM.GMNo,
         GD.GDId,
         PD.ItemID,
         IM.ITName,
         GD.Qnty,
         u1.Symbol,
         PD.Conversion,
         GD.Rate,
         GM.vendorId,
         GM.InvoiceNo,
         GD.STId,
         GM.STId,
         rst.StName,
         rs.StName,
         lm.Fname,
         PD.UsedUnitID;

GO
