SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [dbo].[USP_GETMEMBERSHIPVENDORNAME]
CREATE PROCEDURE [dbo].[USP_GETMEMBERSHIPVENDORNAME]
AS
BEGIN
select Fname + ' ' + Lname as Name, Address + ' ' + City + ' ' + Country as Addresss , * from dbo.RO_LoyaltyMembership 
where IsCustomer = '0' Order BY Fname 
END










GO
