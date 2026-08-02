SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageManagerMenuPageUpdate]
(
 @MenuIDs NVARCHAR(250),
 @PageID INT
)
AS
BEGIN
SET NOCOUNT ON;
 DELETE FROM 
  MenuItem
 WHERE 
   PageID=@PageID
  AND MenuID IN
      (
       SELECT 
        RTRIM(LTRIM(items)) 
       FROM 
        Split(@MenuIDs, ',')
      )
END





GO
