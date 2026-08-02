SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ActivityLogAdd] --'Page Delete', 'superuser', 641, '12/12/2012', 1, 0
 @Action NVARCHAR(MAX),
 @ActivityUserName NVARCHAR(150),
 @ID INT,
 @LogDateTime DATETIME,
 @PortalID INT,
 @UserModuleID INT
AS
BEGIN
 INSERT INTO [dbo].[LogActivity]([Action],ActivityUserName,ID,LogDateTime,PortalID,UserModuleID)
 VALUES(@Action,@ActivityUserName,@ID,@LogDateTime,@PortalID,@UserModuleID ) 
 
 
END





GO
