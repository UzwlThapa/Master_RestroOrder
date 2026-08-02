SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_RO_SAVEMEMBERSHIP]
CREATE PROCEDURE [dbo].[USP_RO_SAVEAGENT]
(
	@MembershipID INT,
	@Fname     nvarchar  (256)   ,
	@Lname     nvarchar  (256)   ,
	@Address     nvarchar  (256)   ,
	@City     nvarchar  (256)   ,
	@Country     nvarchar  (256)   ,
	--@TelHome     nvarchar  (256)   ,
	@TelWork     nvarchar  (256)   ,
	@TelMobile     nvarchar  (256)   ,
	@Email     nvarchar  (256)   ,
	--@Occupation     nvarchar  (256)   ,
	@Company     nvarchar  (256)=null   ,
	--@Birthday     nvarchar  (256)=null   ,
	--@Anniversary     nvarchar  (256)=null  ,
	--@CardNumber nvarchar  (256)=null  ,
	@DateOfIssue nvarchar(256)=null,
	@DateOfExpire nvarchar(256)=null,
	@Commission decimal(18, 0)=null,
	@PAN nvarchar(500),
	@IsAgent bit,
	@isvat bit,
	@Addedby nvarchar  (256)
)
AS
	IF(@MembershipID = 0)
			BEGIN
			declare @financialAcId int

			insert into Ac_FinancialAc (Name, PFinancialAcID, FinancialSysID, AddedBy, AddedOn, IsArchived, OpeningBalance)
			values (@Fname+' '+@Lname
					--,case when @IsCustomer=1 then 15 else 41 end
					,41
					,2
					,'system'
					,GETDATE()
					,0
					,0)

			set @financialAcId = CAST(@@IDENTITY as int)

			INSERT INTO RO_Agent (
				Fname        ,
				Lname        ,
				Address        ,
				City        ,
				Country        ,
				--TelHome        ,
				TelWork        ,
				TelMobile        ,
				Email        ,
				--Occupation        ,
				Company        ,
				--Birthday        ,
				--Anniversary    ,
				--CardNumber ,
				DateOfIssue   ,
				DateOfExpire,
				Commission,
				PAN,
				IsAgent,
				RemainingBalance
				,isvat
				,Addedby
				,AddedOn
				,FinancialAcId )

			values
					(@Fname        ,
						@Lname      ,
						@Address      ,
						@City      ,
						@Country      ,
						--@TelHome      ,
						@TelWork      ,
						@TelMobile        ,
						@Email        ,
						--@Occupation        ,
						@Company        ,
						--@Birthday        ,
						--@Anniversary   ,  
						--@CardNumber ,
						@DateOfIssue   ,
						@DateOfExpire,
						@Commission ,
						@PAN,
						@IsAgent,
						'0',
						@isvat,
						@Addedby,
						getdate(),
						@financialAcId )
			set @MembershipID =  CAST(@@IDENTITY as int)
		END 
		ELSE
		BEGIN
					UPDATE RO_Agent SET 
					Fname = @Fname,
					Lname = @Lname,
					Address = @Address,
					City= @City      ,
					Country		 =	@Country      ,
					--TelHome		 =	@TelHome      ,
					TelWork		=	@TelWork      ,
					TelMobile	=	@TelMobile        ,
					Email		=	@Email        ,
					--Occupation	=	@Occupation        ,
					Company		=	@Company        ,
					--Birthday	=	@Birthday        ,
					--Anniversary	=	@Anniversary   ,  
					--CardNumber 	=	@CardNumber ,
					DateOfIssue	=	@DateOfIssue   ,
					DateOfExpire =	@DateOfExpire,
					Commission  	=	@Commission,
					PAN=@PAN,
					IsAgent=@IsAgent,
					IsVat = @isvat,
					UpdatedBy = @Addedby,
					UpdatedOn = getdate()
					where MembershipID= @MembershipID

		END

	

GO
