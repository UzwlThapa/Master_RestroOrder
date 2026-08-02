SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: 
--CREATED DATE: 2010-04-09
--Modified DATE: 2010-04-25
CREATE PROCEDURE [dbo].[sp_MessageTemplateUpdate]
 @MessageTemplateID INT,
 @MessageTemplateTypeID INT,
 @Subject NVARCHAR(200),
 @Body ntext,
 @MailFrom nvarchar(100),
 @IsActive BIT,
 @UpdatedOn DATETIME,
 @PortalID INT,
 @UpdatedBy NVARCHAR(256),
 @CurrentCulture NVARCHAR(256)
AS
UPDATE [dbo].[MessageTemplate] SET
 [MessageTemplateTypeID] = @MessageTemplateTypeID,
 [Subject] = @Subject,
 [Body] = @Body,
 [MailFrom] = @MailFrom,
 [IsActive] = @IsActive,
 [IsModified] = 1,
 [UpdatedOn] = @UpdatedOn,
 [UpdatedBy] = @UpdatedBy
WHERE PortalID=@PortalID AND [MessageTemplateID] = @MessageTemplateID AND Culture=@CurrentCulture





GO
