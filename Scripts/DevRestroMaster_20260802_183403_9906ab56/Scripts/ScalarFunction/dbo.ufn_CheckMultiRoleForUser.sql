SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  <bhuvan>
-- Create date: <2012-03-22>
-- Description: <Description, ,>
-- =============================================
--select [dbo].[ufn_CheckMultiRoleForUser]('027361E9-9DED-41CE-BA12-411F237D7277')
CREATE FUNCTION [dbo].[ufn_CheckMultiRoleForUser]
(
@UserID uniqueidentifier
)
RETURNS int
AS
BEGIN
 -- Declare the return variable here
 DECLARE @IsMultiRole int
 select @IsMultiRole=count(roleID) from  aspnet_usersinroles where UserID=@UserID
 IF @IsMultiRole>1
  SET @IsMultiRole=1
 ELSE
  SET @IsMultiRole=0

 RETURN @IsMultiRole 

END





GO
