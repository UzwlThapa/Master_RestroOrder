SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: 
--CREATED DATE: 2010-04-09
--Modified DATE: 2011-04-25
--[dbo].[sp_MessageTemplateByMessageTemplateTypeID]10,48
CREATE PROCEDURE [dbo].[sp_MessageTemplateByMessageTemplateTypeID]
 @MessageTemplateTypeID INT,
 @PortalID INT
AS
SELECT TOP 1 mt.[MessageTemplateID], 
       mt.[MessageTemplateTypeID], 
       mt.[Subject], 
       mt.[Body], 
       mt.[MailFrom], 
       mt.[IsActive], 
       mt.[IsDeleted], 
       mt.[IsModified], 
       mt.[AddedOn], 
       mt.[UpdatedOn], 
       mt.[DeletedOn], 
       mt.[PortalID], 
       mt.[AddedBy], 
       mt.[UpdatedBy], 
       mt.[DeletedBy] 
FROM   MessageTemplateTypeMap mttm 
       INNER JOIN MessageTemplateType mtt 
         ON mttm.PortalSpecID = mtt.MessageTemplateTypeID 
       INNER JOIN MessageTemplate mt 
         ON mt.MessageTemplateTypeID = mtt.MessageTemplateTypeID 
WHERE  mttm.PortalID =@PortalID
       AND mttm.MessageTemplateTypeID = @MessageTemplateTypeID
    AND mt.IsActive=1 AND (mt.IsDeleted=0 OR mt.IsDeleted IS NULL)





GO
