SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ScheduleMonthAdd]
@ScheduleID INT,
@Months NVARCHAR(50)
AS
BEGIN
 INSERT INTO dbo.ScheduleMonth(ScheduleID, MonthID)     
 SELECT @ScheduleID, items FROM dbo.split(@Months ,',')
END





GO
