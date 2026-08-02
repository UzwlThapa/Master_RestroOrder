SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-04-09
--Modified By: Dinesh Hona
--Modified Date: 2010-08-01
CREATE PROCEDURE [dbo].[sp_GetMessageTemplateTypeList]
 @IsActive [BIT],
 @IsDeleted [BIT],
 @PortalID [INT],
 @UserName NVARCHAR(256),
 @CurrentCulture NVARCHAR(256)
WITH EXECUTE AS CALLER
AS
SELECT
 MTT.[MessageTemplateTypeID],
 MTT.[Name],
 COALESCE(LMTT.[Name],MTT.[Name]) AS CultureName 
FROM [dbo].[MessageTemplateType] AS MTT
LEFT JOIN [dbo].[LanguageMessageTemplateType] AS LMTT ON LMTT.[MessageTemplateTypeID]=MTT.[MessageTemplateTypeID]
WHERE MTT.IsActive=@IsActive AND MTT.IsDeleted=@IsDeleted AND (MTT.PortalID=@PortalID OR MTT.PortalID IS NULL) AND (LMTT.PortalID=@PortalID OR LMTT.PortalID IS NULL) AND (LMTT.Culture=@CurrentCulture OR LMTT.Culture IS NULL)
ORDER BY MTT.[Name]





GO
