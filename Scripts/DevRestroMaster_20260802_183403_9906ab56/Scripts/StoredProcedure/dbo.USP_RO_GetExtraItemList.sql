SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_GetExtraItemList]
AS
SELECT ei.ExtraItemID
	,ei.ExtraItem
	,ei.ExtraPrice
	,ei.IsActive
	,ei.IsDeleted
FROM RO_ExtraItem ei
order by ei.ExtraItem

GO
