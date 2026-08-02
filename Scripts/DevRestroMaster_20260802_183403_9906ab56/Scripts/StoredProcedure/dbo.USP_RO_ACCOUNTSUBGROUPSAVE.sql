SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ACCOUNTSUBGROUPSAVE]
(
@AccountSubGroupId int,
@Code nvarchar(200),
@Name nvarchar(200),
@AccountGroupId int,
@CreateDate datetime,
@LastUpdateDate datetime
)
AS

if(@AccountSubGroupId = 0)
BEGIN

INSERT INTO RO_AccountSubGroup(
		Code,
		Name,
		AccountGroupId,
		CreateDate,
		LastUpdateDate
		) 
	values
		(
		@Code,
		@Name,
		@AccountGroupId,
		@CreateDate,
		@LastUpdateDate

)
END
else
begin
Update dbo.RO_AccountSubGroup Set

Name = @Name,
Code = @Code,
AccountGroupId = @AccountGroupId,
LastUpdateDate=@LastUpdateDate

WHERE AccountSubGroupId=@AccountSubGroupId

 end









GO
