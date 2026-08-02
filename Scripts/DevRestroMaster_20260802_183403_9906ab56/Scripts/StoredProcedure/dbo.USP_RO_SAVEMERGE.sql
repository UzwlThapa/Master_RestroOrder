SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_SAVEMERGE] 
	@TableID INT
	,@MergeTableList VARCHAR(128)
AS
BEGIN
	--UPDATE RO_restroTable
	--SET restrotablesStatusID = 7
	--WHERE restrotableId = @MergeTableList
	declare @MergeID INT;
	set @MergeID = isnull((select MergeID from RO_MergeTable where TableID=@TableID),0);
	IF (@MergeID <= 0)
	BEGIN
		INSERT INTO RO_MergeTable (
			TableID
			,MergeTableList
			)
		VALUES (
			@TableID
			,@MergeTableList
			)
	END
	ELSE
	BEGIN
		UPDATE RO_MergeTable
		SET MergeTableList = @MergeTableList
		WHERE MergeID = @MergeID
	END
END

GO
