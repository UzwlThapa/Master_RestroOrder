SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_ACCOUNTGROUPSAVE]
(
@AccountId int,
@AccountCode nvarchar(200),
@AccountName nvarchar(200),
@Schedule int,
@Type int,
@LastUpdateDate datetime,
@CreateDate datetime
)
AS

if(@AccountId = 0)
BEGIN

INSERT INTO RO_AccountGroup(
		AccountCode,
		AccountName,
		Schedule,
		[Type],
		LastUpdateDate,
		CreateDate
		) 
	values
		(
		@AccountCode,
		@AccountName,
		@Schedule,
		@Type,
		@LastUpdateDate,
		@CreateDate

)
END
else
begin
Update dbo.RO_AccountGroup Set

AccountCode = @AccountCode,
AccountName = @AccountName,
Schedule = @Schedule,
[Type] = @Type,
LastUpdateDate=@LastUpdateDate,
CreateDate = @CreateDate
WHERE AccountGroupId=@AccountId

 end









GO
