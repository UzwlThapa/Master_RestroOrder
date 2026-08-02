SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetAdminPages]
 @prefix NVARCHAR(10), 
  @IsDeleted BIT,
  @PortalID INT,
  @UserName NVARCHAR(256),
     @CultureCode NVARCHAR(20)
AS
BEGIN
SELECT * FROM PageMenu pm INNER JOIN Pages p
ON pm.PageID=p.PageID WHERE pm.IsAdmin=1 AND pm.PortalID=1
END





GO
