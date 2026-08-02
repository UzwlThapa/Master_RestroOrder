SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[usp_GetPortalStartUpList]0 
CREATE PROCEDURE [dbo].[usp_GetPortalStartUpList]
@IsAdmin BIT
AS
BEGIN
SET NOCOUNT ON;
 SELECT 
  [PortalStartUpID],
  [PortalID],
  [EventLocationName],      
  [ControlUrl] 
      FROM 
  dbo.PortalStartUp 
      WHERE IsActive=1 AND IsAdmin=@IsAdmin AND (IsDeleted=0 OR IsDeleted=NULL)
END





GO
