SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalDelete]
 @PortalID INT,
 @UserName NVARCHAR(256)
AS
BEGIN
 DELETE FROM [dbo].PagePermission WHERE PageID IN (SELECT PageID FROM dbo.Pages 
 WHERE PortalID=@PortalID)
 DELETE FROM [dbo].PageModules WHERE PortalID=@PortalID
 DELETE FROM [dbo].[UserModulePermission] 
 WHERE UserModuleID in (SELECT UserModuleID FROM [dbo].UserModules WHERE PortalID=@PortalID)

 DELETE FROM [dbo].HtmlComment WHERE HTMLTextID IN (SELECT HTMLTextID FROM [dbo].HtmlText  
 WHERE UserModuleID in (SELECT UserModuleID FROM [dbo].UserModules WHERE PortalID=@PortalID))
 DELETE FROM [dbo].HtmlText  WHERE UserModuleID in (SELECT UserModuleID FROM [dbo].UserModules 
 WHERE PortalID=@PortalID)
 DELETE FROM [dbo].[Image] WHERE PortalID=@PortalID 

 DELETE FROM dbo.MessageTemplateTypeToken 
 WHERE MessageTemplateTypeID IN (SELECT MessageTemplateTypeID 
 FROM dbo.MessageTemplateType  WHERE PortalID=@PortalID)
 
 DELETE FROM dbo.MessageTemplate  WHERE PortalID=@PortalID
 DELETE FROM dbo.MessageTemplateType  WHERE PortalID=@PortalID
    DELETE FROM dbo.MessageTemplateTypeMap WHERE PortalID=@PortalID

 DELETE FROM [dbo].PageModules WHERE PageID IN (SELECT PageID FROM [dbo].Pages 
 WHERE PortalID=@PortalID)
 -- SELECT * FROM dbo.Permission
 DELETE FROM [dbo].PortalRole WHERE PortalID=@PortalID
 DELETE FROM [dbo].PortalUser  WHERE PortalID=@PortalID
 DELETE FROM [dbo].ProfileValue WHERE ProfileID IN (SELECT ProfileID FROM dbo.[Profile] 
 WHERE PortalID=@PortalID)
 DELETE FROM [dbo].[Profile] WHERE PortalID=@PortalID
 DELETE FROM [dbo].UserModulePermission WHERE UserModuleID in (SELECT UserModuleID 
 
 FROM [dbo].UserModules WHERE PortalID=@PortalID)
 DELETE FROM [dbo].UserModuleSettings WHERE UserModuleID in (SELECT UserModuleID 
 FROM [dbo].UserModules WHERE PortalID=@PortalID)
 DELETE FROM [dbo].Users  WHERE PortalID=@PortalID
 DELETE FROM [dbo].UserModules WHERE PortalID=@PortalID
 DELETE FROM [dbo].[PagePermission] WHERE PageID IN (SELECT PageID FROM [dbo].Pages 
 WHERE PortalID=@PortalID)
 DELETE FROM [dbo].Pages WHERE PortalID=@PortalID
 DELETE FROM [dbo].[PortalModulePermission] WHERE PortalModuleID IN (SELECT PortalModuleID 
 FROM [dbo].PortalMOdules WHERE PortalID=@PortalID)
 DELETE FROM [dbo].PortalModules WHERE PortalID=@PortalID
 DELETE FROM [dbo].SettingValue WHERE SettingTypeID=@PortalID
 DELETE FROM [dbo].[Profile] WHERE PortalID=@PortalID
 DELETE FROM [dbo].PortalUser WHERE PortalID=@PortalID
 DELETE FROM [dbo].Portal WHERE PortalID=@PortalID
 DELETE FROM [dbo].PageMenu WHERE PortalID=@PortalID
 DELETE FROM [dbo].sftemplate WHERE PortalID=@PortalID
 DELETE FROM [dbo].UserAgent WHERE PortalID =@PortalID
END





GO
