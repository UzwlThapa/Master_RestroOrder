SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Rajkumar Gupta
-- Create date: 11/5/2012
-- Description: To get Event List
-- =============================================
--[dbo].[sp_GetEventTypeList] 
CREATE PROCEDURE [dbo].[usp_GetEventLocationList] 
AS
BEGIN
 SET NOCOUNT ON;  
SELECT EventLocationName FROM dbo.SystemEventLocation WHERE IsActive=1
END





GO
