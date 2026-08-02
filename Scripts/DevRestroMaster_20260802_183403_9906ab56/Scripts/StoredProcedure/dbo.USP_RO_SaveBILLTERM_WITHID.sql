SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--     [dbo].[USP_RO_SaveBILLTERM_WITHID] 
CREATE PROCEDURE [dbo].[USP_RO_SaveBILLTERM_WITHID] @amount DECIMAL(18, 2)
	,@SaleMasterID INT
	,@BillingID INT
	,@IsVoid BIT
	,@rate DECIMAL(18, 2)
AS
BEGIN
	INSERT INTO RO_BillingAmount (
		BilingID
		,SalesMasterID
		,Amount
		,IsVoid
		,rate
		)
	VALUES (
		@BillingID
		,@SaleMasterID
		,@amount
		,case when @IsVoid = 1 then 0 else 1 end
		,@rate
		)
END




GO
