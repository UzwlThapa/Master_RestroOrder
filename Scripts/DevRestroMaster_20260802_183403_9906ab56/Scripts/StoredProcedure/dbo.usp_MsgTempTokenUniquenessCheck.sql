SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_MsgTempTokenUniquenessCheck]
 @MsgTemplateTokenName nvarchar(256),
 @MsgTemplateTypeID nvarchar(256),
 @PortalID int,
 @IsUnique bit output
 
AS
BEGIN
DECLARE @MessageTokenID int
SELECT @MessageTokenID=(SELECT MessageTokenID FROM [dbo].[MessageToken] where MessageTokenKey=@MsgTemplateTokenName)
IF(EXISTS(SELECT * FROM [dbo].[MessageTemplateTypeToken] WHERE (IsDeleted=0 OR IsDeleted IS NULL) AND 
 PortalID = @PortalID AND MessageTemplateTypeID = @MsgTemplateTypeID AND MessageTokenID= @MessageTokenID ))
  BEGIN
   SET @IsUnique = CAST(0 as bit) 
  END
  ELSE
  BEGIN
   SET @IsUnique = CAST(1 as bit)
  END

END





GO
