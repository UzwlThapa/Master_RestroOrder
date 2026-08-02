SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_SEOGetRobots] 
@PortalID INT
AS
BEGIN   
SELECT PageName,TabPath,SEOName,Description FROM [dbo].[Pages] WHERE PortalID =  @PortalID and Isdeleted =0
END





GO
