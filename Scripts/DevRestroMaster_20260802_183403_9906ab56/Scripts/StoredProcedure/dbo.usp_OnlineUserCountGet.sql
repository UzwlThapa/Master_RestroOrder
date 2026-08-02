SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_OnlineUserCountGet]
AS
BEGIN
 DECLARE @TblTemp TABLE ( 
  [Users] NVARCHAR(256), 
  Cnt INT 
    ) 
 INSERT INTO @TblTemp 
  SELECT 
   'AnonymousUser',
   COUNT(*)
  FROM 
   SessionTracker 
  WHERE 
    Username = 'anonymoususer' 
   AND [End] IS NULL 
  UNION ALL 
  SELECT 
    'LoginUser', 
     COUNT(*) 
  FROM 
   SessionTracker 
  WHERE  
    Username NOT IN ( 'anonymoususer' ) 
   AND [End] IS NULL
  SELECT 
   * 
  FROM 
   (
    SELECT 
     Cnt,
     [Users] 
    FROM @TblTemp
   )p 
   PIVOT 
    ( 
     MAX(Cnt) 
     FOR [Users] IN 
         (
          [AnonymousUser],
          [LoginUser]) 
         ) 
     AS PivotTable 
END





GO
