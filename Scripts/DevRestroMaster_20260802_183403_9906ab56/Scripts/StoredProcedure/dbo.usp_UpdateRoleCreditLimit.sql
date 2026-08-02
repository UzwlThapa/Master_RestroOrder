SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_UpdateRoleCreditLimit]
	-- Add the parameters for the stored procedure here
	@creditLimit int,
	@roleName NVARCHAR(100)
AS
BEGIN
UPDATE [dbo].[aspnet_Roles] SET [CreditLimit] = @creditLimit WHERE [LoweredRoleName] = @roleName
END

GO
