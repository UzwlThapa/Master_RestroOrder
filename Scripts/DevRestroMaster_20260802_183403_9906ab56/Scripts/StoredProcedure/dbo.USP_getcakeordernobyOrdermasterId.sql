SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE [USP_getcakeordernobyOrdermasterId]  
CREATE PROCEDURE [dbo].[USP_getcakeordernobyOrdermasterId]  
@OrderMasterID int  
as  
select isnull(com.OrderNo,0) OrderNo, isnull(cot.TokenNo,0) TokenNo, com.CustomerName, com.Phone from RO_CakeOrderMaster com   
left join RO_CakeOrderToken cot on com.OrderMasterID = cot.OrderMasterID  
where com.OrderMasterID = @OrderMasterID   


GO
