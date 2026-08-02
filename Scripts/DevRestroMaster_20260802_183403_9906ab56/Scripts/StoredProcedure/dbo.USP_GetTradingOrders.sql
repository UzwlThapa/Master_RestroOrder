SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
CREATE PROCEDURE [dbo].[USP_GetTradingOrders]
@lookupName varchar(20)
AS
BEGIN
SELECT  
com.OrderMasterID
,com.OrderNo
,com.AddedOn
,com.OrderNo
,com.CustomerName
,com.Address
,com.Phone
, sum(cod.Amount) as 'TotalAmount' 
FROM RO_CakeOrderMaster com 
INNER JOIN RO_CakeOrder_Detail cod ON com.OrderMasterID=cod.OrderMasterId 
WHERE com.SalesType=@lookupName AND cod.SalesType=@lookupName AND (com.StatusId=1 OR com.StatusId=5)
GROUP BY cod.OrderMasterId,com.AddedOn,com.OrderNo,com.OrderMasterID,com.CustomerName,com.Address,com.Phone
END

GO
