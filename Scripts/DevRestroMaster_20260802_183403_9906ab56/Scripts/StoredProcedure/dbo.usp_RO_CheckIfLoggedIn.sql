SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_RO_CheckIfLoggedIn]"nish"
CREATE PROCEDURE [dbo].[usp_RO_CheckIfLoggedIn]
@username nvarchar(50)
AS
SELECT IsLoggedIn from dbo.Users where Username=@username




GO
