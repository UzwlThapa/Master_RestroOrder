SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Created By:   
-- Date Created: 2010-04-25

CREATE PROCEDURE [dbo].[sp_MessageTemplateTypeTokenListByMessageTemplateType]
@MessageTemplateTypeID INT,
@PortalID INT
AS
SELECT
 MTTT.[MessageTemplateTypeTokenID],
 MTTT.[MessageTemplateTypeID],
 MTTT.[MessageTokenID],
 MT.[MessageTokenKey],
 MT.[MessageTokenName],
 MTTT.[IsActive],
 MTTT.[IsDeleted],
 MTTT.[IsModified],
 MTTT.[AddedOn],
 MTTT.[UpdatedOn],
 MTTT.[DeletedOn],
 MTTT.[PortalID],
 MTTT.[AddedBy],
 MTTT.[UpdatedBy],
 MTTT.[DeletedBy]
FROM
 [dbo].[MessageTemplateTypeToken] AS MTTT
 INNER JOIN [dbo].[MessageToken] AS MT ON MTTT.MessageTokenID=MT.MessageTokenID
WHERE MTTT.IsActive=1 AND (MTTT.IsDeleted IS NULL OR MTTT.IsDeleted=0) 
   AND [MessageTemplateTypeID]=@MessageTemplateTypeID





GO
