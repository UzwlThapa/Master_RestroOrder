SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetMemberDetailsbyinfo]
 @info varchar(250)
 as
 begin
select Fname + ' ' + Lname as Name, Address + ' ' + City + ' ' + Country as Addresss , [MembershipID]
      ,[Fname]
      ,[Lname]
      ,[Address]
      ,[City]
      ,[Country]
      ,[TelHome]
      ,[TelWork]
      ,[TelMobile]
      ,[Email]
      ,[Occupation]
      ,[Company]
      ,[Birthday]
      ,[Anniversary]
      ,[CardNumber]
      ,[DateOfIssue]
      ,[DateOfExpire]
      ,[discount]
      ,[PAN]
      ,[IsCustomer]
      ,[RemainingBalance]
      ,[UptoNowPaid]
	  ,[IsVat]
	   from dbo.RO_LoyaltyMembership
	   where (CardNumber =  @info or TelMobile=  @info)
  end





GO
