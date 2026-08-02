SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-06-28

CREATE PROCEDURE [dbo].[sp_TemplateGetList]
 @PortalID INT,
 @UserName NVARCHAR(256)
AS
DECLARE @HasHostRole BIT
SET @HasHostRole=0
IF(EXISTS(
  SELECT * 
  FROM aspnet_usersinroles AS uir 
  INNER JOIN aspnet_Roles as r ON r.RoleId = uir.RoleId 
  WHERE r.RoleName='Super User' 
  AND userid IN (
      SELECT userid 
      FROM dbo.vw_SageFrameUser 
      WHERE 
       Username=@UserName 
      AND IsActive=1 
      AND (IsDeleted=0 OR IsDeleted IS NULL)
     )
  ))
 BEGIN
  SET @HasHostRole=1
 END
IF @HasHostRole=1
 BEGIN
  SELECT 
    [TemplateID]
   ,[TemplateTitle]
   ,[PortalID]
   ,[Author]
   ,[Description]
   ,[AuthorURL]   
   ,[AddedOn]
   ,[AddedBy]
    FROM 
   [dbo].[Template]
 END
ELSE
 BEGIN
  SELECT 
    [TemplateID]
   ,[TemplateTitle]
   ,[PortalID]
   ,[Author]
   ,[Description] 
   ,[AuthorURL]
   ,[AddedOn]
   ,[AddedBy]
  FROM 
   [dbo].[Template] 
  WHERE 
    PortalID=@PortalID 
   OR (LOWER([TemplateTitle])='default')
 END





GO
