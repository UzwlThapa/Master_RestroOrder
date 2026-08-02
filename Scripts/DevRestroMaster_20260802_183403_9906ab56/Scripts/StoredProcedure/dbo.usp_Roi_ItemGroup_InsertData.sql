SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_Roi_ItemGroup_InsertData] @GroupID INT
	,@GroupName NVARCHAR(256)
	,@GroupCode NVARCHAR(100)
	,@userName nvarchar(256)
AS
IF (@GroupID = 0)
BEGIN
	INSERT INTO Roi_ItemGroup (
		GroupName
		,GroupCode
		,AddedOn
		,IsArchived
		,AddedBy
		)
	VALUES (
		@GroupName
		,@GroupCode
		,GETDATE()
		,0
		,@userName
		)

	SELECT cast(@@identity AS INT)
END
ELSE
BEGIN
	UPDATE Roi_ItemGroup
	SET GroupName = @GroupName
		,GroupCode = @GroupCode
		,UpdatedOn=GETDATE()
	    ,UpdatedBy=@userName
		where GroupID=@GroupID
	--INSERT INTO Roi_ItemGroup (
	--	GroupName
	--	,GroupCode
	--	,UpdatedOn
	--	,UpdatedBy
	--	)
	--VALUES (
	--	@GroupName
	--	,@GroupCode
	--	,GETDATE()
	--	,@userName
	--	)

	SELECT cast(@GroupID AS INT)
END




GO
