SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_MessageTemplateTypeAdd]
 @MessageTemplateTypeID [int] OUTPUT,
 @Name [nvarchar](200),
 @IsActive [bit],
 @AddedOn [datetime],
 @PortalID [int],
 @AddedBy nvarchar(256)
WITH EXECUTE AS CALLER
AS
INSERT INTO [dbo].[MessageTemplateType] (
 [Name],
 [IsActive],
 [AddedOn],
 [PortalID],
 [AddedBy]
) VALUES (
 @Name,
 @IsActive,
 @AddedOn,
 @PortalID,
 @AddedBy
)

SET @MessageTemplateTypeID = @@IDENTITY





GO
