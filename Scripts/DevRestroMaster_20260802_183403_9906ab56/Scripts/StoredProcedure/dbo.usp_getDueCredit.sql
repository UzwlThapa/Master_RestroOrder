SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_getDueCredit]
AS
SELECT ([Fname] + ' ' + [Lname]) AS NAME
	,cast(RemainingBalance AS DECIMAL(18, 2)) AS RemainingBalance
FROM [dbo].[RO_LoyaltyMembership]
WHERE IsCustomer = 1
	AND RemainingBalance > 0
ORDER BY [RemainingBalance] DESC


GO
