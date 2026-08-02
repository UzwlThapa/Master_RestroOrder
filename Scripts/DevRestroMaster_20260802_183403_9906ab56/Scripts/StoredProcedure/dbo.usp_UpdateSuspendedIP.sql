SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_UpdateSuspendedIP]
@SuspendedIPID NVARCHAR(50),
@IsSuspended NVARCHAR(50)
AS
BEGIN
	UPDATE dbo.SuspendedIP  SET IsSuspended=@IsSuspended WHERE IpAddressID=@SuspendedIPID
END




GO
