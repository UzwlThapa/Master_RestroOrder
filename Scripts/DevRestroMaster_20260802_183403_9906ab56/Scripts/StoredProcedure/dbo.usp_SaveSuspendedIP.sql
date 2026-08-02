SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_SaveSuspendedIP]
@IpAddress NVARCHAR(50)
AS
BEGIN
	DECLARE @IsSuspended BIT =1	
	DECLARE @SuspendedTime DATETIME	
	SET @SuspendedTime=DATEADD(hour,3,GETDATE());
	IF(EXISTS(SELECT IPAddressID,IpAddress,SuspendedTime,IsSuspended FROM dbo.SuspendedIP WHERE IpAddress=@IpAddress)) 
		UPDATE dbo.SuspendedIP  SET IsSuspended=1 WHERE IpAddress=@IpAddress
	ELSE
		INSERT INTO dbo.SuspendedIP (IpAddress,SuspendedTime,IsSuspended)VALUES(@IpAddress,@SuspendedTime,@IsSuspended)	
END




GO
