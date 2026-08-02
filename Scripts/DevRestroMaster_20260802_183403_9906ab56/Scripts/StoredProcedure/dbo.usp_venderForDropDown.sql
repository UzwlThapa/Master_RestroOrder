SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_venderForDropDown]
as
select * from dbo.RO_LoyaltyMembership where IsCustomer=0




GO
