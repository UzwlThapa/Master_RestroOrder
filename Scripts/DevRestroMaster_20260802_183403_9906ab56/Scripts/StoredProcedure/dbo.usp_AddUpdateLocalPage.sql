SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_AddUpdateLocalPage]
@PageID INT,
@LocalPageName NVARCHAR(250),
@CultureCode NVARCHAR(50) ,
@LocalPageCaption NVARCHAR(256)
AS
BEGIN
DECLARE @PageName NVARCHAR(250)
SET @PageName=(SELECT PageName FROM Pages WHERE PageID=@PageID)
 IF(EXISTS(SELECT PageID FROM [dbo].[LocalPage] WHERE PageID=@PageID AND CultureCode=@CultureCode))
BEGIN
  UPDATE LocalPage
  SET LocalPageName=@LocalPageName,LocalPageCaption=@LocalPageCaption,PageName=@PageName
  WHERE PageID=@PageID
  AND CultureCode=@CultureCode
 END
ELSE
  BEGIN
   INSERT INTO LocalPage(PageID,LocalPageName,CultureCode,LocalPageCaption,PageName)
   VALUES(@PageID,@LocalPageName,@CultureCode,@LocalPageCaption,@PageName)
  END
END





GO
