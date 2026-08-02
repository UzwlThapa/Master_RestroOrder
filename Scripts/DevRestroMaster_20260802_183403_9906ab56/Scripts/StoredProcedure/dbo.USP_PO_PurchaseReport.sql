SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop procedure USP_PO_PurchaseReport 134
	CREATE PROCEDURE [dbo].[USP_PO_PurchaseReport]
	@PurchaseMainID INT
	AS
SELECT
PM.PurchaseMainID,
PM.IvNo,
PM.PbDate,
PD.ItemID,
  IM.ITName,  
  ISNULL(PD.Quentity, 0) as Quentity
  ,u1.Symbol
 --,NULLIF(GD.Rate, 0) AS Rate
 ,ISNULL(PD.UnitRate, 0) AS Rate
  ,convert(numeric(10,2), (ISNULL(PD.Total, 0))) AS Total
  ,rl.Fname
  ,rl.Address+ ', ' + rl.City + ', ' + rl.Country as Address
   ,rl.TelWork
 FROM DBO.ROI_PurchaseDetails PD  
 INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID  
 left JOIN DBO.ROI_ITEMMain IM ON IM.ITId = PD.ItemID  
 left join ROI_Unit1 u1 on u1.Unit1Id=pd.UsedUnitID
 left join RO_LoyaltyMembership rl on rl.MembershipID = PD.VendorPurchaseId
  where PM.PurchaseMainID = @PurchaseMainID
 
 --GROUP BY PM.PurchaseMainID,PM.IvNo,PM.PbDate, PD.ItemID,IM.ITName,PD.Quentity,u1.Symbol,PD.Total,PD.UnitRate,rl.Address, rl.City, rl.Country, rl.Fname, rl.TelWork, rl.IsVat



GO
