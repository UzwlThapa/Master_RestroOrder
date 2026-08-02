SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <29-Dec-2020>  
-- Description: <Save Cake billing terms>  
-- EXECUTE: [dbo].[USP_RO_CAKE_SaveBILLTERM] 0  
-- ============================================= 
CREATE PROCEDURE [dbo].[USP_RO_CAKE_SaveBILLTERM] @amount DECIMAL(18, 2)
	,@SaleMasterID INT
	,@BillingID INT
	,@IsVoid BIT
	,@rate DECIMAL(18, 2)
	,@SalesType nvarchar(30)
AS
BEGIN
	INSERT INTO RO_CAKE_BillingAmount (
		BilingID
		,SalesMasterID
		,Amount
		,IsVoid
		,rate
		,SalesType
		)
	VALUES (
		@BillingID
		,@SaleMasterID
		,@amount
		,case when @IsVoid = 1 then 0 else 1 end
		,@rate
		,@SalesType
		)
END




GO
