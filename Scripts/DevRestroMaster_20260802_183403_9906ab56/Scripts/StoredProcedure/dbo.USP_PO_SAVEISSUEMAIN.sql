SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_PO_SAVEISSUEMAIN] @IssuedToSTId INT
	,@IssuedFrSTId INT
	,@IssuedOn DATETIME
	,@IssuedBy VARCHAR(255)
	,@ReceivedBy NVARCHAR(255)
AS
BEGIN
	DECLARE @ISNo INT
		,@ISNos NVARCHAR(50)

	SELECT TOP 1 @ISNos = ISNo
	FROM dbo.ROI_IssueMain
	ORDER BY IMID DESC

	SELECT TOP 1 @ISNo = items
	FROM DBO.Split(@ISNos, '_')
	ORDER BY items

	SET @ISNos = 'IS_' + cast(isnull(@ISNo, 0) + 1 AS VARCHAR(20))

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
		,@IssuedOn
		,@IssuedBy
		,@ReceivedBy
		,0
		)

	SELECT *
	FROM ROI_IssueMain
	WHERE IMId = @@IDENTITY
END



GO
