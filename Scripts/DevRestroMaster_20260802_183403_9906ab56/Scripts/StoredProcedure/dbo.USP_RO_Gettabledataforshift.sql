SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_Gettabledataforshift]
as

select * from dbo.RO_restroTable where restrotableId not in (
		SELECT   
restrotableId
FROM dbo.RO_restroTable rr  
Inner JOIN dbo.RO_OrderMasters om ON om.TableId = rr.restrotableId   
left join dbo.RO_MergeTable mt on mt.TableID = rr.restrotableId  
WHERE  
om.BillPaid = 0   
AND   
rr.restrotableId != 0   
AND om.IsCancelled = 0 and om.OrderMasterID = dbo.fn_getMaxMasterId(rr.restrotableId)  
  
	)



GO
