SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_GETMEMBERSHIPFORM]  
CREATE PROCEDURE [dbo].[USP_GETAGENTLIST]  
@IsAgent int  
AS  
BEGIN  
  
select Fname + ' ' + Lname as Name, Address + ' ' + City + ' ' + Country as Addresss , [MembershipID]
      ,[Fname]
      ,[Lname]
      ,[Address]
      ,[City]
      ,[Country]
      --,[TelHome]
      ,[TelWork]
      ,[TelMobile]
      ,[Email]
      --,[Occupation]
      ,[Company]
      --,[Birthday]
      --,[Anniversary]
      --,[CardNumber]
      ,[DateOfIssue]
      ,[DateOfExpire]
      ,[Commission]
      ,[PAN]
      ,[IsAgent]
      ,[RemainingBalance]
      ,[UptoNowPaid]
	  ,[IsVat]
	   from dbo.RO_Agent
	   where [IsAgent]=@IsAgent and isnull(IsArchived,0) <> 1
	   ORDER BY Fname
  
END




GO
