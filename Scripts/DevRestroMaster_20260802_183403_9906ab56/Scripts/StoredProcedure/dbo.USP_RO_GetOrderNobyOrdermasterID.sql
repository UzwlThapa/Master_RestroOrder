SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[USP_RO_GetOrderNobyOrdermasterID] 
 @CostCenterId int
 ,@OrderMasterId int
 as 
 BEGIN
		SELECT isnull(max(OrderNo),0) AS OrderNo
		FROM RO_Order_Detail where OrderMasterId = @OrderMasterId and CostCenterId=@CostCenterId 
	
			
	END

GO
