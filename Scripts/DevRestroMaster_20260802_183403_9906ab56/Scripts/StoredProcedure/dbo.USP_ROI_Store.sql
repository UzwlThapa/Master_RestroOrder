SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_ROI_Store]
AS
BEGIN
		;

	WITH StoreTree -- (STId,StName , PSTId, Level,Id)
	AS (
		-- Anchor member definition
		SELECT STId
			,StName
			,PSTId
			,0 AS LEVEL
		FROM ROI_Store(NOLOCK)
		WHERE PSTId = 0 and IsDeleted!=1
		
		UNION ALL
		
		-- Recursive member definition
		SELECT c.STId
			,c.StName
			,c.PSTId
			,LEVEL + 1
		FROM ROI_Store c --
		INNER JOIN StoreTree ct ON c.PSTId = ct.STId
			where c.IsDeleted != 1
		)
	SELECT REPLICATE('-', LEVEL) + ' ' + StName AS s
		,*
	FROM StoreTree

	ORDER BY STId
		--SELECT Child.STId as StoreId,Child.StName, Parent.StName as PName,*
		--    FROM dbo.ROI_Store AS Child
		--    LEFT JOIN dbo.ROI_Store AS Parent ON Child.PSTId = Parent.STId;
		--select STId as StoreId ,  PSTId, STId, StName from dbo.ROI_Store
END



GO
