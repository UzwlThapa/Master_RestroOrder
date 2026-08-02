SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETLatestCashDenomination]
AS
SELECT TOP 1 [DenominationId],[Date],[thousand],[fivehundred] ,[hundred],[fifty] ,[twenty],[ten],[five] ,[two],[one] 
FROM [dbo].[CashDenomination] 
ORDER BY DenominationId DESC

GO
