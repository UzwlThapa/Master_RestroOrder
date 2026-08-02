SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ModuleWebInfoGetAll] 
AS
BEGIN
 SELECT 
  *,
  ROW_NUMBER() OVER
      (
       ORDER BY AddedOn DESC
      ) AS rowNum
 FROM 
  (
   SELECT 
     * 
   FROM 
    [dbo].[ModuleWebInfo]
  ) DataTable
END





GO
