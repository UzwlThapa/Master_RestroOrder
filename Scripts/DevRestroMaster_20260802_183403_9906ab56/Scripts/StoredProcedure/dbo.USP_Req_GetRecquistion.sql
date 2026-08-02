SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Req_GetRecquistion] @IsMainStore BIT
AS
IF (@IsMainStore = 0)
	SELECT rq.RecqId
		,rq.RecqNo
		,rq.StoreId
		,st.StName AS StoreName
		,rq.ParentStore
		,pst.StName AS ParentStoreName
		,rq.RequestedBy
		,rq.RequestedOn
		,iss.ItemStatus AS [Status]
	FROM Req_Recquistion rq
	LEFT JOIN RO_ItemStatus iss ON iss.StatusID = rq.StatusId
	LEFT JOIN ROI_Store st ON st.STId = rq.StoreId
	LEFT JOIN ROI_Store pst ON pst.STId = rq.ParentStore
	WHERE isnull(rq.IsDeleted, 0) = 0
		AND rq.ParentStore > 0
ELSE
	SELECT rq.RecqId
		,rq.RecqNo
		,rq.StoreId
		,st.StName AS StoreName
		,rq.ParentStore
		,pst.StName AS ParentStoreName
		,rq.RequestedBy
		,rq.RequestedOn
		,iss.ItemStatus AS [Status]
	FROM Req_Recquistion rq
	LEFT JOIN RO_ItemStatus iss ON iss.StatusID = rq.StatusId
	LEFT JOIN ROI_Store st ON st.STId = rq.StoreId
	LEFT JOIN ROI_Store pst ON pst.STId = rq.ParentStore
	WHERE isnull(rq.IsDeleted, 0) = 0
		AND rq.ParentStore = 0

-----------------------------------------------------------------------------------------------------

GO
