SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_IsSuspendedIP]
@IpAddress NVARCHAR(50)
AS
BEGIN
	DECLARE @IsSuspended BIT =0
	DECLARE @SuspendedTime DATETIME
	SET @SuspendedTime=(SELECT SuspendedTime FROM dbo.SuspendedIP WHERE IpAddress=@IpAddress)	
	DECLARE @CurrentTime DATETIME
	SET @CurrentTime=GETDATE();	
	DECLARE @IsChecked BIT=0
	SET @IsChecked = (SELECT IsSuspended FROM dbo.SuspendedIP WHERE IpAddress=@IpAddress)
	IF(@IsChecked=0)
		BEGIN
		SET @IsSuspended=0
		END
	ELSE	
		BEGIN
			IF(@CurrentTime<@SuspendedTime)
				BEGIN
					SET @IsSuspended = 1
				END
			ELSE
				BEGIN
					SET @IsSuspended = 0
					IF(EXISTS(SELECT * FROM dbo.SuspendedIP WHERE IpAddress=@IpAddress)) 
					UPDATE dbo.SuspendedIP  SET IsSuspended=0 WHERE IpAddress=@IpAddress
				END	
		END			
	SELECT @IsSuspended AS Suspended		
END




GO
