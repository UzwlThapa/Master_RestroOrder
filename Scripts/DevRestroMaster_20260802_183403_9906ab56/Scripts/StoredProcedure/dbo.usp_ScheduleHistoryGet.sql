SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleHistoryGet]
(
 @ScheduleID INT,
    @offset INT,
    @limit INT 
)
AS
BEGIN
DECLARE @RowTotal INT
SELECT @RowTotal=COUNT(*) FROM [dbo].[ScheduleHistory]
WHERE ScheduleID=@ScheduleID ;

WITH scheduleHistoryTmp AS
(
   SELECT @RowTotal AS RowTotal ,*, row_number() OVER(ORDER BY ScheduleHistoryID DESC) AS rowNum
  FROM
  (
   SELECT
      [ScheduleHistoryID]
   ,[ScheduleID]      
   ,[StartDate]
      ,[EndDate]
      ,[Status]
      ,[ReturnText]
      ,[NextStart]
      ,[Server]
         
     FROM [dbo].[ScheduleHistory]
   WHERE ScheduleID=@ScheduleID
   ) DataTable
)
SELECT * FROM  scheduleHistoryTmp WHERE
rowNum>= @offset
AND rowNum<= (@offset + @limit - 1)
END;





GO
