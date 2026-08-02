SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SaveCakeOrderToken]  
@OrderMasterID int  
,@CustomerID int  
,@CustomerName nvarchar(150) = null  
,@Phone nvarchar(50) = null  
,@TokenNo int  
,@Address nvarchar(150) = null  
as   
BEGIN  
IF EXISTS(select OrderMasterID from [RO_CakeOrderToken] where OrderMasterID = @OrderMasterID)  
BEGIN  
Delete from [RO_CakeOrderToken] where OrderMasterID = @OrderMasterID  
END  
Insert into [RO_CakeOrderToken]  
(  
OrderMasterID  
,CustomerID  
,CustomerName  
,Phone  
,TokenNo  
,AddedBy  
,Address  
)  
values  
(  
@OrderMasterID  
,@CustomerID  
,@CustomerName  
,@Phone  
,@TokenNo  
,getdate()  
,@Address   
)  
END  
  

GO
