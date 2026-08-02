SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [dbo].[usp_ro_GetPaymentModes]
CREATE PROCEDURE [dbo].[usp_ro_GetPaymentModes]
AS
SELECT * FROM RO_PaymentModes

GO
