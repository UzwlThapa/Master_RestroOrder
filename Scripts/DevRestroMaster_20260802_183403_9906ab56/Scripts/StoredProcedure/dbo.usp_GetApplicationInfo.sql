SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetApplicationInfo]
@ApplicationName nvarchar(256)
AS
BEGIN
SELECT [ApplicationName]
      ,[ApplicationId]
      ,[Description]
  FROM [dbo].[aspnet_Applications] where [LoweredApplicationName] =  @ApplicationName
END





GO
