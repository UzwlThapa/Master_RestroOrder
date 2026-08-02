SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetSuspendedIP]
AS
BEGIN
SELECT IPAddressID,IpAddress,SuspendedTime,IsSuspended FROM dbo.SuspendedIP WHERE IsSuspended=1
END




GO
