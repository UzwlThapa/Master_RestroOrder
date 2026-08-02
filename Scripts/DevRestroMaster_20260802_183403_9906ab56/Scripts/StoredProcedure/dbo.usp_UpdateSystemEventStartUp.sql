SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_UpdateSystemEventStartUp]
 @PortalStartUpID INT,
 @PortalID INT,
 @ControlUrl NVARCHAR(500), 
 @EventLocation NVARCHAR(50),
 @IsAdmin BIT,
 @IsControlUrl BIT,
 @IsActive BIT,
 @UserName NVARCHAR(256)
AS

BEGIN 
 SET NOCOUNT ON;
IF(@PortalStartUpID>0)
BEGIN
UPDATE dbo.PortalStartUp SET PortalID=@PortalID,
       ControlUrl=@ControlUrl,       
       EventLocationName=@EventLocation,
       IsAdmin=@IsAdmin,
       IsControlUrl=@IsControlUrl,
       IsActive=@IsActive,
       IsModified=1,
       UpdatedOn=GETDATE(),
       UpdatedBy=@UserName
       WHERE PortalStartUpID=@PortalStartUpID
       
END
ELSE
BEGIN
INSERT INTO dbo.PortalStartUp(PortalID,ControlUrl,EventLocationName,IsAdmin,IsControlUrl,IsActive,AddedOn,AddedBy)
VALUES(@PortalID,@ControlUrl,@EventLocation,@IsAdmin,@IsControlUrl,@IsActive,GETDATE(),@UserName)
END   
END





GO
