SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP PROCEDURE USP_getordernobyOrdermasterId
CREATE PROCEDURE [dbo].[USP_getordernobyOrdermasterId]
@OrderMasterID int
as
select isnull(om.OrderNo,0) OrderNo, isnull(ot.TokenNo,0) TokenNo, CustomerName, Phone from RO_OrderMasters om 
left join RO_OrderToken ot on om.OrderMasterID = ot.OrderMasterID
where om.OrderMasterID = @OrderMasterID 

GO
