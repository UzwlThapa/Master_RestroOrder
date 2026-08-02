SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_GetExtraSalesBySalesMaster] @SalesMasterID INT
AS
BEGIN
	SELECT [ItemId] AS ItemID
		,[ExtraItemId] AS ExtraItemII
		,[ExtraItem]
		,[Quantity]
		,[Rate] AS ExtraPrice
	FROM [dbo].[RO_SalesDetailExtra]
	WHERE SalesMasterId = @SalesMasterID
END

GO
