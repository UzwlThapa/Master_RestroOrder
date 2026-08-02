SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountSubGroupUpdate]
(
	@Id Int = 0, 
	@Code nvarchar(16),
	@Name nvarchar(128),
	@AccountGroupId int,
	@UserName nvarchar(64),
	@OutMessage varchar(256) output 
)
As
set @OutMessage=''
----***************************************** Validation Begin ********************************************************
	IF EXISTS (SELECT 0 FROM AccountSubGroup WHERE CODE = @CODE AND ID <>@ID)
	BEGIN
		RAISERROR ('Duplicate Code Found',11,1)
		Set @OutMessage =-1
		return;
	END 
	IF EXISTS (SELECT 0 FROM AccountSubGroup WHERE Name = @Name AND ID <>@ID)
	BEGIN
		RAISERROR ('Duplicate Name Found',11,1)
		Set @OutMessage =-2
		return;
	END 

----***************************************** Validation End ********************************************************
	Update dbo.AccountSubGroup  Set 
		[Code] = @Code,
		[Name] = @Name,
		[AccountGroupId] = @AccountGroupId,
		[LastUpdateBy] = @UserName,
		[LastUpdateDate] = GETDATE()
	 Where [Id] = @Id
	Set @OutMessage = 'AccountSub Group [ ' + @Name + ' ]  Has been Updated Sucessfully'






GO
