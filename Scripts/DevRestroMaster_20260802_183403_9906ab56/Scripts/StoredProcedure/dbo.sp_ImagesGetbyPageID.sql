SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Indira Sapkota>
-- Create date: <16 May 2010>
-- Description: <DashBoardModule>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ImagesGetbyPageID] 
  @PageID int
 
AS

SELECT

 [IconFile]
 
FROM dbo.Pages
WHERE
 [PageID] = @PageID





GO
