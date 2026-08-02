SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetSystemEventStartUpDetails]
@PortalStartUpID INT
AS
BEGIN
 SET NOCOUNT ON;
   SELECT ControlUrl,EventLocationName,IsAdmin,IsControlUrl,IsActive FROM dbo.PortalStartUp WHERE PortalStartUpID=@PortalStartUpID
END





GO
