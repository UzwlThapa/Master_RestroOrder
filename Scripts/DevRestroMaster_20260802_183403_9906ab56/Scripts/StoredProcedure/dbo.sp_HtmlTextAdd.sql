SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  DINESH HONA
-- Create date: 2010-03-30
-- Description: HTML/Text Module truncate table cachesearch
-- =============================================

CREATE PROCEDURE [dbo].[sp_HtmlTextAdd]
 @HTMLTextID int output,
 @UserModuleID int, 
 @Content ntext, 
 @CultureName nvarchar(256),
 @IsAllowedToComment bit,
 @IsModified bit,
 @IsActive bit, 
 @AddedOn datetime, 
 @PortalID int, 
 @AddedBy nvarchar(256)
 
AS
BEGIN
  IF(Not Exists(Select * From dbo.HtmlText Where UserModuleID = @UserModuleID And PortalID = @PortalID And [CultureName] = @CultureName))
  Begin
   INSERT INTO dbo.HtmlText([UserModuleID],[Content],[CultureName],[IsAllowedToComment],[IsModified],[IsActive],[AddedOn],[PortalID],AddedBy)
    VALUES (@UserModuleID, @Content,@CultureName,@IsAllowedToComment,@IsModified,@IsActive,@AddedOn,@PortalID,@AddedBy)
   select @HTMLTextID=SCOPE_IDENTITY()
  End

END

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON





GO
