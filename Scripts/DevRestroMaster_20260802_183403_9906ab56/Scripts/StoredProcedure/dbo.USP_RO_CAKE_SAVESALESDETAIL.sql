SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <7-Jan-2021>  
-- Description: <Save Cake sales details>  
-- EXECUTE: [dbo].[USP_RO_CAKE_SAVESALESDETAIL] 0  
-- ============================================= 
CREATE PROCEDURE [dbo].[USP_RO_CAKE_SAVESALESDETAIL] @SalesMasterId INT
	,@ItemId INT
	,@ItemName varchar(300)
	,@Quantity FLOAT
	,@Rate DECIMAL(18, 2)
	,@Amount DECIMAL(18, 2)
	,@NetAmount DECIMAL(18, 2)
	,@CostCenterId INT=null
	,@SalesType nvarchar(30) = null
AS
BEGIN
	INSERT INTO dbo.RO_CakeSalesDetail (
		SalesMasterId
		,ItemId
		,ItemName
		,Quantity
		,Rate
		,Amount
		,NetAmount
		,CostCenterId
		,SalesType		
		)
	VALUES (
		@salesMasterId
		,@ItemId
		,@ItemName
		,@Quantity
		,@Rate
		,@Amount
		,@NetAmount
		,@CostCenterId
		,@SalesType
		)


DECLARE @sDetailID int 

select @sDetailID =@@IDENTITY 	
END
	



GO
