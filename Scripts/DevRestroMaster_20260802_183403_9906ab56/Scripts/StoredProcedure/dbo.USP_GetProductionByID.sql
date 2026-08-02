SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetProductionByID] 

@ProductionMainID int
as begin
SELECT pd.ProductionMainID, rim.ITName, pd.Quantity, u1.UnitDescription, u1.Symbol, st.StName
FROM   RO_ProductionDetails AS pd LEFT OUTER JOIN
RO_ProductionMain AS pm on pd.ProductionMainID = pm.ProductionMainId LEFT OUTER JOIN
                         ROI_ITEMMain AS rim ON rim.ITId = pd.ItemId LEFT OUTER JOIN
                         ROI_Unit1 AS u1 ON u1.Unit1Id = pd.ItemUnitId LEFT OUTER JOIN
                         ROI_Store AS st ON st.STId = pd.StoreId 
						 where pd.ProductionMainID = @ProductionMainID

						end

GO
