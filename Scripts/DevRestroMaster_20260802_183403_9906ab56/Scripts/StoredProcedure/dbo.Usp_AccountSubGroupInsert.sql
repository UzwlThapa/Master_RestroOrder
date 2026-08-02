SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountSubGroupInsert]
(
	@Id Int = 0, 
	@Code nvarchar(16),
	@Name nvarchar(128),
	@AccountGroupId int,
	@UserName nvarchar(64),
	@VoucherNumberingId int,
	@OutMessage varchar(125) output 
)
As
SET @OutMessage =''
----***************************************** Validation Begin ********************************************************
if (@VoucherNumberingId <>-1)
	Begin
	
		If Exists (select 0 from VoucherNumbering Where Style =14 And Id =@VoucherNumberingId )
		Begin
		x:
			Select  @Code =  isnull(Prefix,'') + REPLICATE('0',( BodyLength - LEN(CurrentNO)))  + Convert(nvarchar(64),CurrentNO) + isnull(Suffix,'')  from VoucherNumbering Where Id = @VoucherNumberingId
			if EXISTS  (SELECT 0 from AccountSubGroup Where Code = @Code )
			Begin
				Update VoucherNumbering Set CurrentNO = CurrentNO + 1 Where Id =@VoucherNumberingId
				Goto X
			End 
		End
		Else
		Begin
			if EXISTS  (SELECT 0 from AccountSubGroup Where Code = @Code )
			Begin
				set @OutMessage ='Code'
				RAISERROR ('Duplicate ShortName Found',11,1)
				return;
			End
		End  
	End 
	Else
	Begin
		
		If Exists (select 0 from AccountSubGroup where  Code =@Code  and  Id <> @Id)
		Begin
			set @OutMessage ='Code'
			RAISERROR ('Duplicate ShortName Number Found',11,1)
			return;
		End 
		If Exists (select 0 from AccountSubGroup where  Name =@Name and  Id <> @Id)
		Begin
			SET @OutMessage ='Name'
			RAISERROR ('Duplicate AccountSubGroup Found',11,1)
			return;
		End 
		 
	End 
 
	 

----***************************************** Validation End ********************************************************
	Insert Into dbo.AccountSubGroup  
	(
		Code, 
		Name, 
		AccountGroupId, 
		CreatedBy, 
		CreateDate, 
		LastUpdateBy, 
		LastUpdateDate
	)
	Values 
	(	
		@Code,
		@Name,
		@AccountGroupId,
		@UserName,
		GETDATE(),
		NULL,
		NULL
	)  
	Set @OutMessage = 'AccountSub Group [ ' + @Name + ' ]  Has been Inserted Sucessfully'





GO
