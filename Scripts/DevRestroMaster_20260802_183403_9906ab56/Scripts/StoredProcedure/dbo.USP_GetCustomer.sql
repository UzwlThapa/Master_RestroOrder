SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

	CREATE PROCEDURE [dbo].[USP_GetCustomer]
	as
	SELECT Distinct BillCustomer as Customer FROM RO_Sales_View Where BillCustomer != '';

GO
