SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Req_SaveRecquistion] @RecqId INT
	,@RecqNo NVARCHAR(max)
	,@StoreId INT
	,@ParentStore INT
	,@RequestedBy NVARCHAR(max)
AS
BEGIN
	IF (@RecqId = 0)
	BEGIN
		INSERT INTO Req_Recquistion (
			RecqNo
			,StoreId
			,ParentStore
			,RequestedBy
			,RequestedOn
			,StatusId
			,IsDeleted
			)
		VALUES (
			@RecqNo
			,@StoreId
			,@ParentStore
			,@RequestedBy
			,GETDATE()
			,8
			,0
			)

		SELECT @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE Req_Recquistion
		SET StoreId = @StoreId
			,ParentStore = @ParentStore
			,RequestedBy = @RequestedBy
		WHERE RecqId = @RecqId

		SELECT @RecqId
	END
END


-----------------------------------------------------------------------------------------------------

GO
