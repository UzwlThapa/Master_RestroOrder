SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PageMenuAdd]
 @PageID INT,
 @PortalID INT,
 @IsAdmin BIT,
 @IsFooter BIT
AS
BEGIN
SET NOCOUNT ON;
 IF(NOT EXISTS
   (
    SELECT 
     PageID 
    FROM 
     [dbo].[PageMenu] 
    WHERE 
     PageID=@PageID
   )
  )
  BEGIN
   INSERT INTO 
    [dbo].[PageMenu]
       (
        [PageID],
        [PortalID],
        [IsAdmin],
        [IsFooter]
       )
      VALUES
       (
        @PageID,
        @PortalID,
        @IsAdmin,
        @IsFooter
       )
  END
END





GO
