SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--drop PROCEDURE USP_GETROOMREPORT '2018-09-25', '2018-09-30', '', ''
CREATE PROCEDURE [dbo].[USP_GETROOMREPORT] 
@StartDate datetime,
@EndDate datetime,
@CustomerName nvarchar(250),
@TableName nvarchar(250)
as
select 
rb.BookedFrom
,rb.BookedTo
,rb.BookedDays
,rb.Rate
,rb.TotalAmount
,rb.AdvancePayment
,rb.CustomerName
,rb.PhoneNo
,rb.Remarks
,rt.restrotableTitle
 from Ro_RoomBookings rb
left join RO_restroTable rt on rt.restrotableId = rb.TableId
where  (cast(rb.BookedFrom AS DATE) >= @StartDate OR @StartDate=0 OR @StartDate IS NULL OR @StartDate='')
and (cast(rb.BookedTo AS DATE) <= @EndDate OR @EndDate=0 OR @EndDate IS NULL OR @EndDate='')
and (rb.CustomerName like '%' + @CustomerName + '%' or  @CustomerName= '' OR @CustomerName is null)
and (rt.restrotableTitle = @TableName or  @TableName = '' OR @TableName is null )
and rb.IsCancelled = 0
ORDER BY BookedFrom

GO
