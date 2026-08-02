SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleHistoryGetMax]
(
 @ScheduleID INT
)
AS
BEGIN
SELECT MAX(ScheduleHistoryID) AS  ScheduleHistoryID FROM dbo.ScheduleHistory
END;





GO
