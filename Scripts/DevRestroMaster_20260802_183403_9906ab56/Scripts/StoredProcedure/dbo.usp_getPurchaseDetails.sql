SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP procedure usp_getPurchaseDetails
CREATE PROCEDURE [dbo].[usp_getPurchaseDetails]
    @PurchaseMainID INT
AS
    SELECT PD.PurchaseDetailsID ,
           PD.PurchaseMainID ,
           PD.ItemID ,
           PD.UsedUnitID AS UnitId ,
           PD.Quentity ,
           PD.UnitRate AS Rate ,
           PD.Total ,
           PD.Conversion ,
           IM.ITName ,
           u1.Symbol AS UnitName ,
           ISNULL (PD.IsVat, 0) AS IsVat ,
           ISNULL (PD.Discount, 0) AS Discount
    FROM   ROI_PurchaseDetails AS PD
           INNER JOIN ROI_ITEMMain AS IM ON IM.ITId = PD.ItemID
           LEFT JOIN ROI_Unit1 AS u1 ON u1.Unit1Id = PD.UsedUnitID
    WHERE  PD.PurchaseMainID = @PurchaseMainID;

GO
