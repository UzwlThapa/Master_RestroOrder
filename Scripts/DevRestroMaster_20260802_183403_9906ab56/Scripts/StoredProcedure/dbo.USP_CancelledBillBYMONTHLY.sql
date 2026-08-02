SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[USP_CancelledBillBYMONTHLY] '2016', '12'
CREATE PROCEDURE [dbo].[USP_CancelledBillBYMONTHLY]
@year varchar(10),
@month varchar(10)
AS
BEGIN
select 
om.BillDate,
om.NetAmount,
om.Waiter,
rt.restrotableTitle,
rr.restroRoom
,om.billNo
,om.TableId
,salesMasterId
,om.OrderMasterId
--,om.PrintCount
,om.Reasons
,om.ArchivedBy
,om.IsArchived
 from dbo.RO_SalesMaster om
 left join dbo.RO_restroTable rt on rt.restrotableId = om.TableId
 left join RO_RestroRoom rr on rr.restroRoomId=om.RoomId
 --where EXTRACT(Year FROM om.Date), EXTRACT(Month FROM om.Date)  = '2015-11'
 where Year(om.ArchivedOn)=@year and Month(om.ArchivedOn)=@month and om.IsArchived=1

END










GO
