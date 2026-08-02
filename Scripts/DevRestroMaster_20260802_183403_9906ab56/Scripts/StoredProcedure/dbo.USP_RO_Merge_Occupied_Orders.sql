SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[USP_RO_Merge_Occupied_Orders] '131,132','132'

CREATE PROCEDURE [dbo].[USP_RO_Merge_Occupied_Orders] 
	@OccupiedTableIds VARCHAR(128)
	,@MergeTableList VARCHAR(128)
AS
BEGIN

DECLARE @tmpTableIds as table(TableId varchar(10))
insert into @tmpTableIds
SELECT * FROM split_string(@OccupiedTableIds, ',')

--select * from @tmpTableIds

--update RO_Order_Detail set OrderMasterId = @MergeTableList
-- where 

declare @OrderMasterIdToUpdate int;
set @OrderMasterIdToUpdate = (select top 1 om.OrderMasterID from RO_OrderMasters om  
	INNER JOIN @tmpTableIds tmp ON tmp.TableId = om.TableId AND om.IsCancelled = 0 AND om.BillPaid = 0
	WHERE
	om.TableId = CAST(@MergeTableList AS INT)
	)



UPDATE od SET od.OrderMasterId = @OrderMasterIdToUpdate 
FROM RO_Order_Detail od
	INNER JOIN RO_OrderMasters om  ON od.OrderMasterId = om.OrderMasterID AND om.IsCancelled = 0 AND om.BillPaid = 0
	INNER JOIN @tmpTableIds tmp ON tmp.TableId = om.TableId and CAST(tmp.TableId as INT) <> CAST(@MergeTableList AS INT)
	WHERE
	om.TableId <> CAST(@MergeTableList AS INT)


	--DECLARE @orderMasterIdToDelete INT;

	delete om from RO_OrderMasters om  
	INNER JOIN @tmpTableIds tmp ON tmp.TableId = om.TableId AND om.IsCancelled = 0 AND om.BillPaid = 0
	WHERE
	CAST(tmp.TableId as INT) <> CAST(@MergeTableList AS INT)


	update  rt set rt.restrotablesStatusID=6 from RO_restroTable rt inner join @tmpTableIds tmp on tmp.TableId = rt.restrotableId 
	where tmp.TableId <> cast(@MergeTableList as int)


END

GO
