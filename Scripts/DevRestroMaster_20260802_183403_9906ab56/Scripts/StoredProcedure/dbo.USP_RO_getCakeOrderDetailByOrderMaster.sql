SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_getCakeOrderDetailByOrderMaster] 

@orderMasterId INT,
@SalesType varchar(30) = NULL

AS
SELECT com.OrderMasterID, 
		com.BillNo,
		com.Date,
		com.Remarks,
		com.CustomerId,
		com.CustomerName,
		com.Phone,
		com.Address,
		com.PAN,
		com.StatusId,
		com.AdvanceAmount,
		com.DeliveryTime,
		com.DeliveryService,
		com.CancelReason,
		com.AddedBy,
		com.AddedOn,
		com.UpdatedBy,
		com.UpdatedOn,
		com.SalesType,
		cod.OrderDetailsID,
		cod.ItemId,
		cod.CostCenterId,
		cod.ItemName,
		cod.Quantity,
		cod.Rate,
		cod.Amount,
		cod.IsUpdated,
		cod.IsArchived,
		cod.ArchivedBy,
		cod.ArchivedOn		
		
		FROM RO_CakeOrderMaster com

		inner join RO_CakeOrder_Detail cod on com.OrderMasterID = cod.OrderMasterID

		where com.OrderMasterId = @orderMasterId and com.SalesType = @SalesType

GO
