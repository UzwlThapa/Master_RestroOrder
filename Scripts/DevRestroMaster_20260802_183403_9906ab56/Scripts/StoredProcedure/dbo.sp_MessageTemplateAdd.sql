SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Created By: 
--Modified DATE: 2010-04-25,2010-08-01
CREATE PROCEDURE [dbo].[sp_MessageTemplateAdd]
 @MessageTemplateID [int] OUTPUT,
 @MessageTemplateTypeID [int],
 @Subject [nvarchar](200),
 @Body [ntext],
 @MailFrom NVARCHAR(100),
 @IsActive [bit],
 @AddedOn [datetime],
 @PortalID [int],
 @AddedBy [nvarchar](256),
 @CurrentCulture NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
INSERT INTO [dbo].[MessageTemplate] (
 [MessageTemplateTypeID],
 [Subject],
 [Body],
 [MailFrom], Culture,
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @MessageTemplateTypeID,
 @Subject,
 @Body,
 @MailFrom,@CurrentCulture,
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)

SET @MessageTemplateID = @@IDENTITY

INSERT INTO [dbo].[MessageTemplateTypeMap]
(
 MessageTemplateTypeID,PortalSpecID,PortalID
)
VALUES
(
 @MessageTemplateTypeID,@MessageTemplateID,@PortalID
)





GO
