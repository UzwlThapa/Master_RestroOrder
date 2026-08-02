SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageMenuDelete]
@PageID INT,
@DeletedBy nvarchar(256)
AS
BEGIN
SET NOCOUNT ON;
 IF(EXISTS(SELECT PageID FROM [dbo].[PageMenu] WHERE PageID=@PageID))
 BEGIN
  
   
  INSERT INTO [PageMenu_History]
  SELECT  Getdate(),'D', @DeletedBy,* FROM [PageMenu]  WHERE PageID=@PageID;
  
  DELETE FROM [dbo].[PageMenu]
  WHERE PageID=@PageID
 



 END
END





GO
