SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--usp_ro_getbasicsumamountByReportNumber '2016-10-21',1
CREATE PROCEDURE [dbo].[usp_ro_getbasicsumamountByReportNumber]
@Todaydate DATETIME,
@ReportNum int
as
--begin
-- select sum(om.BasicAmount) as sumAmount from RO_OrderMasters om
-- where cast(om.Date as Date)=@Todaydate
--END

BEGIN

IF @ReportNum = 1 --Void Bill
BEGIN

SELECT
SUM(rom.BasicAmount)as sumAmount
 FROM dbo.RO_OrderMasters rom 
  LEFT JOIN dbo.RO_restroTable rt ON rt.restrotableId = rom.TableId
 left join RO_RestroRoom rr on rr.restroRoomId=rom.RoomId
 --LEFT JOIN RO_BillingAmount RBA ON RBA.SalesMasterID = rom.salesMasterId
 --LEFT JOIN dbo.RO_BillTerm rbt ON rbt.BilingID = RBA.BilingID
 WHERE cast(rom.Date as Date)=@Todaydate AND rom.IsCancelled = 1 

 -- where CONVERT(date,om.BillDate)=CONVERT(DATE,getdate())
 END
 --select *  from dbo.RO_SalesMaster om left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
 --SELECT * FROM dbo.RO_OrderMasters

ELSE IF @ReportNum = 2 --Vat Bill
BEGIN

 select sum(om.BasicAmount) as sumAmount from RO_OrderMasters om
 where cast(om.Date as Date)=@Todaydate

END
ELSE IF @ReportNum = 3 --Service Bill
BEGIN

 select sum(om.BasicAmount) as sumAmount from RO_OrderMasters om
 where cast(om.Date as Date)=@Todaydate

END
END





GO
