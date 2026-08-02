SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Saroj Kumar Chaudhary>  
-- Create date: <10-Jan-2021>  
-- Description: <Get discount details>  
-- EXECUTE: USP_RO_GETDISCOUNT_DETAIL 1,'wholesale' 
-- ============================================= 
CREATE PROCEDURE [dbo].[USP_RO_GETDISCOUNT_DETAIL] 
 @salesMasterID INT
,@SalesType varchar(30) = null
AS
BEGIN
	SELECT 
		SalesMasterId	
		,DiscountValue	
		,IsFlatDis	
		,TotalDiscount	
		,BasicAmount	
		,SalesType 
	FROM 
		RO_Discount 
	WHERE 
		SalesMasterId = @salesMasterID AND LOWER(SalesType) = LOWER(ISNULL(@SalesType,''))
END




GO
