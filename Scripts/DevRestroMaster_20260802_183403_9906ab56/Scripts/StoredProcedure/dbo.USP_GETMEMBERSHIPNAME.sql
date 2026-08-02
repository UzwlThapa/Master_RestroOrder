SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GETMEMBERSHIPNAME]

AS
BEGIN

select Fname + ' ' + Lname as Name, Address + ' ' + City + ' ' + Country as Addresss , * from dbo.RO_LoyaltyMembership where IsCustomer = '1' 
END











GO
