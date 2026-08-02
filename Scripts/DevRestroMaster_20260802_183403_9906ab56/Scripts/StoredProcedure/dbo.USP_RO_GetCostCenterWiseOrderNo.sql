SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[USP_RO_GetCostCenterWiseOrderNo] 
 @CostCenterId int
 ,@OrderMasterId int
 ,@seatNo int = 0
 ,@CompMasterID int = 0
 as 
 BEGIN
 DECLARE @OrderNo INT 
-- DECLARE @CostCenterId int = 1

SELECT @OrderNo=OrderNo FROM RO_CostCenterWiseOrderNo WHERE cast([Date] as date) = cast(getdate() as date)
			and CostCenterId = @CostCenterId
if (@OrderNo is null)
begin

	INSERT INTO RO_CostCenterWiseOrderNo
		values (getdate(), @CostCenterId, 1)		
end
else
begin 
 UPDATE RO_CostCenterWiseOrderNo set OrderNo= @OrderNo+1
			where cast([Date] as date) = cast(getdate() as date) and CostCenterId = @CostCenterId
end
		
		if(@CompMasterID > 0)
		BEGIN
		update RO_ComplementaryItems set OrderNo = isnull(@OrderNo,0)+1
		where CompMasterID=@CompMasterID  and CostCenterId = @CostCenterId and isnull(IsCancelled,0) = 0
		END
		ELSE
		BEGIN

		update RO_Order_Detail set OrderNo = isnull(@OrderNo,0)+1
		where OrderMasterId=@OrderMasterId  and CostCenterId = @CostCenterId and SeatNo=@seatNo and isnull(IsCancelled,0) = 0
		END
--select * from dbo.Split(@OrderDetailIDs,',')

SELECT isnull(@OrderNo,0)+1 as OrderNo
	
			
	END

GO
