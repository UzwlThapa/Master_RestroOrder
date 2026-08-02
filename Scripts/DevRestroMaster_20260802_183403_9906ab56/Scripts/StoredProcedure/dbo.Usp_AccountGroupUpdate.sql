SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountGroupUpdate] 
(
	@Id Int = 0, 
	@Code nvarchar(16),
	@Name nvarchar(128),
	@Type smallint,
	@Schedule int,
	@UserName nvarchar(64),
	@OutMessage varchar(256) output 
)

As
SET NOCOUNT ON		
----***************************************** Validation Begin ********************************************************
	set @OutMessage=''
	
	If Exists (select 0 from AccountGroup where  Code =@Code  and  Id <> @Id)
	Begin
		set @OutMessage ='Code'
		RAISERROR ('Duplicate Code Found',11,1)
		return;
	End 
	If Exists (select 0 from AccountGroup where  Name =@Name and  Id <> @Id)
	Begin
		set @OutMessage ='Name'
		RAISERROR ('Duplicate Name Found',11,1)
		return;
	End 
	If Exists (select 0 from AccountGroup where  Schedule =@Schedule  and  Id <> @Id)
	Begin
		set @OutMessage ='Schedule'
		RAISERROR ('Duplicate Schedule Found',11,1)
		return;
	End 
----***************************************** Validation End ********************************************************

Update AccountGroup Set 
		[Code] = @Code,
		[Name] = @Name,
		[Type] = @Type,
		[Schedule] = @Schedule,
		[LastUpdateBy] = @UserName,
		[LastUpdateDate] = GETDATE()
Where [Id] = @Id
Set @OutMessage = 'Account Group [ ' + @Name + ' ]  Has been Updated Sucessfully'






GO
