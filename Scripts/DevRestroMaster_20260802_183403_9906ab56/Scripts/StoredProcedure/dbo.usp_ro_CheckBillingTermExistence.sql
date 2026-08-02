SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_ro_CheckBillingTermExistence] @term NVARCHAR(256)
AS
DECLARE @status NVARCHAR(50)

SET @status = CASE 
		WHEN EXISTS (
				SELECT *
				FROM RO_BillTerm
				WHERE NAME = @term
				)
			THEN 'EXIST'
		ELSE 'NOT EXIST'
		END

SELECT cast(@status AS NVARCHAR(50))




GO
