SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetLoginUserCreditLimit]
	-- Add the parameters for the stored procedure here
@role NVARCHAR(100)
	
AS
BEGIN
	SELECT ISNULL(CreditLimit,0) AS  CreditLimit FROM [dbo].[aspnet_Roles] WHERE LoweredRoleName = @role
END

GO
