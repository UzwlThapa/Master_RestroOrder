SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED DATE: 2010-06-28
CREATE PROCEDURE [dbo].[sp_TemplateAdd]
 @TemplateTitle NVARCHAR(256),
 @Author NVARCHAR(256),
 @Description NVARCHAR(500),
 @AuthorURL NVARCHAR(256),
 @PortalID INT,
 @UserName NVARCHAR(256)
AS
INSERT INTO 
  [dbo].[Template]
   (
    [TemplateTitle],
    [Author],
    [Description],
    [AuthorURL],
    [PortalID],
    [AddedOn],
    [AddedBy]
   ) 
  VALUES 
   (
    @TemplateTitle,
    @Author,
    @Description,
    @AuthorURL,
    @PortalID,
    GETDATE(),
    @UserName
   )





GO
