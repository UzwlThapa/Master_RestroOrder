SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetScheduleDates]
 @ScheduleID INT
AS
BEGIN

SET NOCOUNT ON;
  SELECT * FROM dbo.ScheduleDate WHERE ScheduleID=@ScheduleID
END





GO
