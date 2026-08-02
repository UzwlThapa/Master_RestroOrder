SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PortalUpdate]
 @PortalID INT,
 @PortalName NVARCHAR(200),
 @IsParent BIT,
 @UserName NVARCHAR(256),
 @PortalURL NVARCHAR(256),
 @ParentID INT
AS
BEGIN
 DECLARE @PortalSEOName NVARCHAR(100)
 --SET @PortalSEOName=LOWER(LTRIM(RTRIM(REPLACE(@PortalName,' ','-'))))
 SET @PortalSEOName=@PortalURL
 IF(NOT(EXISTS(SELECT * FROM dbo.Portal WHERE PortalID=@PortalID)))
 BEGIN
  RAISERROR('Portal does not Exist!', 16, 1)
 END
 ELSE
 BEGIN
  UPDATE [dbo].[Portal] SET  [Name]=@PortalName,[SEOName]=@PortalSEOName,ParentID=@ParentID,IsParent =@IsParent 
  WHERE PortalID=@PortalID
 END
END





GO
