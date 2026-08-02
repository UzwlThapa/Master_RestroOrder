SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_TemplateGetPortalTemplate] 
AS
BEGIN
 SELECT
  TemplateName,
  PortalID
 FROM
  sftemplate
 END





GO
