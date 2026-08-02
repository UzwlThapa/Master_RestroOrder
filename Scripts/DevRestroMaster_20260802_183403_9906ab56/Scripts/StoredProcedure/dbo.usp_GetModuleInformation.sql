SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetModuleInformation]
@FriendlyName NVARCHAR(128) 
AS
BEGIN
SELECT ModuleName,[Description],[Version],* FROM Modules WHERE FriendlyName = @FriendlyName 
END





GO
