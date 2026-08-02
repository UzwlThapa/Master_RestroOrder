SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GoodReceivedDetails]
@PONO nvarchar(250)  
as  
begin  
SELECT
PM.PuNo,  
PD.ItemID,  
IM.ITName,  
u1.Symbol,
GD.Qnty,
GD.Rate,
GD.Total
FROM RO_GoodsReceivedDetls GD
 LEFT JOIN DBO.ROI_PurchaseDetails PD ON GD.PDId = PD.PurchaseDetailsID   
 INNER JOIN DBO.ROI_PurchaseMain PM ON PM.PurchaseMainID = PD.PurchaseMainID  
 INNER JOIN DBO.ROI_ITEMMain IM ON IM.ITId = PD.ItemID  
 left join ROI_Unit1 u1 on u1.Unit1Id=pd.UsedUnitID 
  where pm.PuNo = @PONO  
  GROUP BY  PD.ItemID,IM.ITName,u1.Symbol, PM.PuNo, GD.Qnty, GD.Rate, GD.Total
end  



GO
