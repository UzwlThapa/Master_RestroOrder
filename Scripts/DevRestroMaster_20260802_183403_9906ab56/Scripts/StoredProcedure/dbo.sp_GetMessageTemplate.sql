SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: DINESH HONA
--CREATED DATE: 2010-04-09
--Modified DATE: 2010-04-25
CREATE PROCEDURE [dbo].[sp_GetMessageTemplate]
 @MessageTemplateID int,
 @PortalID int
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
FROM
 [dbo].[MessageTemplate]
WHERE PortalID = @PortalID AND
 [MessageTemplateID] = @MessageTemplateID





GO
