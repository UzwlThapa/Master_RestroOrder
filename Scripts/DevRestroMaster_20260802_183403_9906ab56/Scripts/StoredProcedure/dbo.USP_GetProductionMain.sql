SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetProductionMain]

@FromDate date =  NULL,
@ToDate date =  NULL,
@StoreId int = 0
as begin
SELECT  pm.ProductionMainId, rim.ITName, pm.Quantity, u1.UnitDescription, u1.Symbol, st.StName, CAST(pm.AddedOn as date) AddedOn, pm.AddedBy
FROM   RO_ProductionMain AS pm LEFT OUTER JOIN
                         ROI_ITEMMain AS rim ON rim.ITId = pm.ItemId LEFT OUTER JOIN
                         ROI_Unit1 AS u1 ON u1.Unit1Id = pm.UnitId LEFT OUTER JOIN
                         ROI_Store AS st ON st.STId = pm.StoreId 
						 where (pm.StoreId=@StoreId or @StoreId=0)
						AND (CAST(pm.AddedOn as date)>=@FromDate OR @FromDate IS NULL)
						AND (CAST(pm.AddedOn as date)<=@ToDate OR @ToDate IS NULL) 

						end

GO
