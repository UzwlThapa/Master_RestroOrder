SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageGettingBySEOName]
@PortalID INT,
@SEOName NVARCHAR(256)
AS

BEGIN
 SELECT 
  PageName,
  IconFile 
 FROM 
  [dbo].[Pages] 
 WHERE  
   PortalID=@PortalID  
  AND SEOName=@SEOName 
  AND 
   (
     IsDeleted = 0 
     OR IsDeleted IS NULL
   ) 
  AND IsActive = 1
END





GO
