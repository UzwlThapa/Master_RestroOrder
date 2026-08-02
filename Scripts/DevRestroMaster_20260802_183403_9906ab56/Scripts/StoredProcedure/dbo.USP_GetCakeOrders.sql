SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCakeOrders]
@lookupName varchar(20)
AS
BEGIN
SELECT  
com.OrderMasterID
,com.CustomerName
,com.Address
,com.Phone
,com.DeliveryTime
,com.AdvanceAmount
, sum(cod.Amount) as 'TotalAmount' 
FROM RO_CakeOrderMaster com 
INNER JOIN RO_CakeOrder_Detail cod ON com.OrderMasterID=cod.OrderMasterId 
WHERE com.SalesType=@lookupName AND cod.SalesType=@lookupName AND com.StatusId=1
GROUP BY cod.OrderMasterId,com.OrderMasterID,com.CustomerName,com.Address,com.Phone,com.AdvanceAmount,com.DeliveryTime
END

GO
