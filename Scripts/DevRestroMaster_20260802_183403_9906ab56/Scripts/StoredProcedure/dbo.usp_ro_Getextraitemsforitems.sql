SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_Getextraitemsforitems]
AS
BEGIN
	SELECT eii.ItemID
		,eii.ExtraItemID
		,ei.ExtraItem
		,ei.ExtraPrice
		,ei.IsActive
		,ei.IsDeleted
	FROM Roi_ExtraItemForItem eii
	INNER JOIN RO_ExtraItem ei ON eii.ExtraItemID = ei.ExtraItemID
END

GO
