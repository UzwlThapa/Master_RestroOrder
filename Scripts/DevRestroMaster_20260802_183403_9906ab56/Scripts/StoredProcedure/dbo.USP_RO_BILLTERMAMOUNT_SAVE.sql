SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_RO_BILLTERMAMOUNT_SAVE]
(
@SalesMasterID int,
@BillTermID nvarchar(200),
@Amount decimal(18,2),
@IsVoid bit
)
AS


BEGIN
DECLARE @VAL INT
SELECT @VAL = MAX(RO_BillTerm.BilingID) FROM RO_BillTerm
INSERT INTO RO_BillingAmount(
		SalesMasterID,
		BilingID,
		Amount,
		IsVoid
		) 
	values
		(
		@SalesMasterID,
		@BillTermID,
		@Amount,
		@IsVoid
)

END





GO
