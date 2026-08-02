SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_MenuMgrAddNewMenu] 
@MenuName VARCHAR(100),
@MenuType VARCHAR(50),
@IsDefault BIT,
@PortalID INT,
@MenuID INT OUTPUT
AS
BEGIN
 IF(@IsDefault = 1)
   BEGIN
    UPDATE  
     [dbo].[MENU] 
    SET 
     IsDefault = 0 
    WHERE 
     IsDefault= 1 
    AND 
     PortalID=@PortalID
    INSERT INTO [dbo].[MENU]
          (
           MenuName,
           MenuType,
           IsDefault,
           PortalID
          ) 
         VALUES 
          (
           @MenuName,
           @MenuType,
           @IsDefault,
           @PortalID
          )
   END
 ELSE
   BEGIN
    DECLARE @PortalDefault BIT
     IF EXISTS(SELECT MenuID FROM Menu WHERE IsDefault=1 AND PortalID=@PortalID)
      BEGIN
       SET @PortalDefault=0
      END
     ELSE
      BEGIN
       SET @PortalDefault=1
      END
    INSERT INTO [dbo].[MENU]
          (
           MenuName,
           MenuType,
           IsDefault,
           PortalID
          ) 
         VALUES 
          (
           @MenuName,
           @MenuType,
           @PortalDefault,
           @PortalID
          )
   END
 SET @MenuID = CAST(SCOPE_IDENTITY() AS INT)
END
 SET ANSI_NULLS ON





GO
