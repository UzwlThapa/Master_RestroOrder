SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Req_SaveIssueForRecquistion] @RecqId INT
	,@IssuedBy NVARCHAR(256)
	,@ReceivedBy NVARCHAR(256)	
AS
BEGIN
	DECLARE @ISNo INT
		,@ISNos NVARCHAR(50)
		,@IssuedToSTId INT
		,@IssuedFrSTId INT

	SELECT TOP 1 @ISNos = ISNo
	FROM dbo.ROI_IssueMain
	ORDER BY IMID DESC

	SELECT TOP 1 @ISNo = items
	FROM DBO.Split(@ISNos, '_')
	ORDER BY items

	SET @ISNos = 'IS_' + cast(isnull(@ISNo, 0) + 1 AS VARCHAR(20))

	SELECT @IssuedFrSTId = ParentStore
		,@IssuedToSTId = StoreId
	FROM Req_Recquistion
	WHERE RecqId = @RecqId

	INSERT INTO dbo.ROI_IssueMain (
		ISNo
		,IssuedToSTId
		,IssuedFrSTId
		,IssuedOn
		,IssuedBy
		,ReceivedBy
		,IsVerified
		)
	VALUES (
		@ISNos
		,@IssuedToSTId
		,@IssuedFrSTId
		,GETDATE()
		,@IssuedBy
		,@ReceivedBy
		,0
		)

	SELECT @@IDENTITY
END

-----------------------------------------------------------------------------------------------------

GO
