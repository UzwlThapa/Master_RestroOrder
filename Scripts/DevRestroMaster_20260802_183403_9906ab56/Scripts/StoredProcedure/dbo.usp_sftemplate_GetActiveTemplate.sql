SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_sftemplate_GetActiveTemplate] (@PortalID INT) AS
 BEGIN
   SELECT TemplateName
   FROM sftemplate       
   WHERE PortalID =@PortalID 
 END





GO
