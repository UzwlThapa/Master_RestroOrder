SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ModulesGetByUserModuleID]
 -- Add the parameters for the stored procedure here
 
AS
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;

    -- Insert statements for procedure here
 SELECT * 
 FROM dbo.UserModules
 Inner Join PageModules 
 ON 
 UserModules.UserModuleID=PageModules.UserModuleID
END





GO
