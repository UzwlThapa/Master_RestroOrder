SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Usp_AccountGroupInsert] 
(
	@Id Int = 0, 
	@Code nvarchar(16),
	@Name nvarchar(128),
	@Type smallint,
	@Schedule int,
	@UserName nvarchar(64),
	@VoucherNumberingId int,
	@OutMessage varchar(125) output 
)

As
SET @OutMessage =''
if (@VoucherNumberingId <>-1)
	Begin
	
		If Exists (select 0 from VoucherNumbering Where Style =14 And Id =@VoucherNumberingId )
		Begin
		x:
			Select  @Code =  isnull(Prefix,'') + REPLICATE('0',( BodyLength - LEN(CurrentNO)))  + Convert(nvarchar(64),CurrentNO) + isnull(Suffix,'')  from VoucherNumbering Where Id = @VoucherNumberingId
			if EXISTS  (SELECT 0 from AccountGroup Where Code = @Code )
			Begin
				Update VoucherNumbering Set CurrentNO = CurrentNO + 1 Where Id =@VoucherNumberingId
				Goto X
			End 
		End
		Else
		Begin
			if EXISTS  (SELECT 0 from AccountGroup Where Code = @Code )
			Begin
				set @OutMessage ='Code'
				RAISERROR ('Duplicate ShortName Found',11,1)
				return;
			End
		End  
	End 
	Else
	Begin
		
		If Exists (select 0 from AccountGroup where  Code =@Code  and  Id <> @Id)
		Begin
			set @OutMessage ='Code'
			RAISERROR ('Duplicate ShortName Number Found',11,1)
			return;
		End 
		If Exists (select 0 from AccountGroup where  Name =@Name and  Id <> @Id)
		Begin
			SET @OutMessage ='Name'
			RAISERROR ('Duplicate Account Group Found',11,1)
			return;
		End 
		If Exists (select 0 from AccountGroup where  Schedule =@Schedule  and  Id <> @Id)
		Begin
			SET @OutMessage ='Schedule'
			RAISERROR ('Duplicate Schedule Found',11,1)
			return;
		End 
	End 

--SET NOCOUNT ON		
----***************************************** Validation Begin ********************************************************
	set @OutMessage=0
	
	
----***************************************** Validation End ********************************************************
	Insert Into AccountGroup 
	(
		 Code, 
		 Name, 
		 [Type], 
		 Schedule, 
		 CreatedBy, 
		 CreateDate, 
		 LastUpdateBy, 
		 LastUpdateDate
	)
	Values 
	(	
		@Code,
		@Name,
		@Type,
		@Schedule,
		@UserName,
		GETDATE(),
		null,
		null
	)  
	Set @OutMessage = 'Account Group [ ' + @Name + ' ]  Has been Inserted Sucessfully'






GO
