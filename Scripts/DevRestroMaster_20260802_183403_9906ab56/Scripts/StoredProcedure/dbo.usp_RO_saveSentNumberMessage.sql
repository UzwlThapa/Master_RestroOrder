SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_RO_saveSentNumberMessage]
@contactNumber varchar(max)
,@message varchar(max)

AS
BEGIN
	INSERT INTO [dbo].[RO_SMS_Message]
	(mobileNum
	,message
	,sentDate)
	VALUES
	(@contactNumber
	,@message
	,CAST(GETDATE() AS DATETIME))
END


GO
