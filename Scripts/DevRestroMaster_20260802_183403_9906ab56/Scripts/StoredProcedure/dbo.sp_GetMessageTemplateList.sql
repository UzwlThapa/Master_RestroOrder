SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-04-09
--Modified DATE: 2010-04-25
CREATE PROCEDURE [dbo].[sp_GetMessageTemplateList]
 @IsActive [BIT],
 @IsDeleted [BIT],
 @PortalID [INT],
 @UserName NVARCHAR(256),
 @CurrentCulture NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
SELECT
 [MessageTemplateID],
 [MessageTemplateTypeID],
 [Subject],
 [Body],
 [MailFrom],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy]
FROM [dbo].[MessageTemplate]
WHERE (IsDeleted=0 OR IsDeleted IS NULL) AND PortalID=@PortalID





GO
