SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetPreviousProductionDetailsById]
 @Id INT
 AS
 BEGIN
	SELECT PD.ProductionMainID as ProductionMainId,IM.ITName,IM.ITId as ItemId,PD.Quantity as Quantity,U.Symbol, U.Unit1Id as SmallUnit FROM RO_ProductionDetails PD
	INNER JOIN ROI_ITEMMain IM ON PD.ItemId=IM.ITId
	INNER JOIN ROI_Unit1 U ON PD.ItemUnitId = U.Unit1Id
	
	WHERE ProductionMainID=@Id


 END

GO
