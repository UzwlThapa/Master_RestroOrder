SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetCustomerBalance]
as
SELECT TOP 1000 [MembershipID]
      ,[Fname]
      ,[Lname]
      ,[Address]
      ,[City]
      ,[Country]
      ,[TelHome]
      ,[TelWork]
      ,[TelMobile]
      ,[CardNumber]
      ,[DateOfIssue]
      ,[DateOfExpire]
      ,[PAN]
      ,[RemainingBalance]
  FROM [dbo].[RO_LoyaltyMembership] where IsCustomer=1




GO
