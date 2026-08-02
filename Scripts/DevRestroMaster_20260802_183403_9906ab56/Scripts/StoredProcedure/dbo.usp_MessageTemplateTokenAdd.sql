SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MessageTemplateTokenAdd]
 @MessageTokenID [int]  OUTPUT,
 @MessageTemplateTypeID [int],
 @Name [nvarchar](200),
 @IsActive [bit],
 @AddedOn [datetime],
 @PortalID [int],
 @AddedBy nvarchar(256)
WITH EXECUTE AS CALLER
AS
IF(Not Exists(SELECT MessageTokenID from [dbo].[MessageToken] where MessageTokenKey=@Name))
BEGIN
 INSERT INTO [dbo].[MessageToken] (
  [MessageTokenKey],
  [MessageTokenName],
  [IsActive],
  [AddedOn],
  [PortalID],
  [AddedBy]
 ) VALUES (
  @Name,
  @Name,
  @IsActive,
  @AddedOn,
  @PortalID,
  @AddedBy
 )
 SET @MessageTokenID = @@IDENTITY
END
ELSE
 BEGIN
  SET @MessageTokenID=(SELECT MessageTokenID from [dbo].[MessageToken] where MessageTokenKey=@Name)
 END 
INSERT INTO [dbo].[MessageTemplateTypeToken]
(
 MessageTemplateTypeID,MessageTokenID,IsActive,AddedOn,PortalID,AddedBy
)
VALUES
(
 @MessageTemplateTypeID,@MessageTokenID,@IsActive,@AddedOn,@PortalID,@AddedBy
)





GO
