SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_HtmlTextUpdate]
@UserModuleID INT,
@Content NTEXT,
@CultureName NVARCHAR(256),
@IsAllowedToComment BIT,
@IsActive BIT,
@IsModified BIT,
@UpdatedOn DATETIME,
@PortalID INT,
@UpdatedBy NVARCHAR(256)

AS
BEGIN
IF(EXISTS (SELECT * FROM HtmlText WHERE UserModuleID=@UserModuleID AND CultureName=@CultureName))
BEGIN
UPDATE dbo.HtmlText SET
[Content] = @Content,
[CultureName] = @CultureName,
[IsAllowedToComment]=@IsAllowedToComment,
[IsActive] = @IsActive,
[IsModified] = @IsModified,
[UpdatedOn] = @UpdatedOn,
[PortalID] = @PortalID,
[UpdatedBy] = @UpdatedBy
WHERE
[UserModuleID] = @UserModuleID AND CultureName = @CultureName
END
ELSE
BEGIN
INSERT INTO dbo.HtmlText([UserModuleID],[Content],[CultureName],[IsAllowedToComment],[IsModified],[IsActive],[AddedOn],[PortalID],AddedBy)
VALUES (@UserModuleID, @Content,@CultureName,@IsAllowedToComment,@IsModified,@IsActive,GETDATE(),@PortalID,@UpdatedBy)

END
END





GO
