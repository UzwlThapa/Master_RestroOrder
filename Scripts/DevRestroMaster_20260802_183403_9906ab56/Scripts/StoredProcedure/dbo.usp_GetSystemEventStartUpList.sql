SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Rajkumar Gupta
-- Create date: 11/5/2012
-- Description: To get PortalStartUpList
-- =============================================
--[dbo].[usp_GetSystemEventStartUpList]1
CREATE PROCEDURE [dbo].[usp_GetSystemEventStartUpList]
 @PortalID INT
AS
BEGIN 
 SET NOCOUNT ON;   
 SELECT * FROM dbo.PortalStartUp WHERE PortalID=@PortalID AND (IsDeleted=0 OR IsDeleted=NULL)
END





GO
