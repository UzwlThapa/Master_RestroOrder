SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPreviousCakeOrderById]
@orderMasterId int
AS
BEGIN
SELECT com.CustomerName
,com.Address
,com.AdvanceAmount
,com.DeliveryService
,com.DeliveryTime
,com.OrderMasterID
,com.Phone
,cod.OrderDetailsID
,cod.Quantity
,cod.ItemId
,cod.ItemName
,cod.Rate
,cod.Amount
FROM RO_CakeOrderMaster com INNER JOIN RO_CakeOrder_Detail cod ON com.OrderMasterID=cod.OrderMasterId
WHERE com.SalesType='cake' AND com.OrderMasterID=@orderMasterId AND com.StatusId=1
END

GO
