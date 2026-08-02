SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC usp_GetPreviousProduction
CREATE PROCEDURE [dbo].[usp_GetPreviousProduction]


AS
BEGIN
	SET NOCOUNT ON;

	SELECT PM.ProductionMainId,IM.ITId as ITemId,IM.ITName,PM.Quantity,PM.StoreId,UN.Unit1Id as SmallUnit,UN.Symbol,PM.AddedOn  FROM dbo.RO_ProductionMain PM
	INNER JOIN dbo.ROI_ITEMMain IM
	ON PM.ItemId = IM.ITId
	INNER JOIN dbo.ROI_Unit1 UN
	ON PM.UnitId = UN.Unit1Id
	ORDER BY PM.AddedOn DESC;
END

GO
