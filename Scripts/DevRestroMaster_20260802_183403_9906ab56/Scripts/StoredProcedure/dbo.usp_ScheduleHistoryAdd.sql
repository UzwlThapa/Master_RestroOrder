SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ScheduleHistoryAdd]
(
 @ScheduleID INT,
 @StartDate DATETIME,
 @EndDate DATETIME=NULL,
 @Status bit,
 @ReturnText NTEXT=NULL,
 @NextStart DATETIME=NULL,
 @Server NVARCHAR(150)=NULL,
    @id INT OUTPUT
)
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO ScheduleHistory
(
 ScheduleID,StartDate,EndDate,Status,ReturnText,NextStart,[Server]
)
VALUES
(
 @ScheduleID,@StartDate,@EndDate,@Status,@ReturnText,@NextStart,@Server
);

SET @id=@@identity
END;





GO
