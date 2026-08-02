SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <8-Jan-2021>  
-- Description: <Save cake discount details>  
-- EXECUTE: [dbo].[usp_ro_Cake_DiscountDetails] 0  
-- ============================================= 
CREATE PROCEDURE [dbo].[usp_ro_Cake_DiscountDetails] 
	@salesMasterId INT	
	,@DiscountValue decimal(12,2)
	,@IsFlatDis bit
	,@TotalDiscount decimal(12,2)
	,@BasicAmount decimal(12,2)				
	,@SalesType nvarchar(30) = null
AS
BEGIN
	INSERT INTO RO_Discount (
		SalesMasterId	
		,DiscountValue	
		,IsFlatDis	
		,TotalDiscount	
		,BasicAmount	
		,SalesType
		)
	VALUES (
		@salesMasterId
		,@DiscountValue
		,@IsFlatDis
		,@TotalDiscount
		,@BasicAmount
		,@SalesType		
		)

END



GO
