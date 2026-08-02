SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_CReport_CounterViewClose] 1, '2016-10-18',1
CREATE PROCEDURE [dbo].[usp_CReport_CounterViewClose] 
@counter int,
@date nvarchar(256)
,@cid int
as
--declare @bug_id int
--SELECT @bug_id = MAX(CTID) FROM tbl_CounterTotal where convert(date,[Date])=@date and IsClosing=1 and CCID=@counter and CID=@cid;
select rvn.Note,rda.Number,IsCoin, Balance, convert(date,[Date]) as [date], DifAmount,rus.Username as ApprovedBy, IsClosing , rda.TID
from tbl_CounterTotal rct
left join
tbl_Roi_Data rda on rct.CTID=rda.CTID
left join 
tbl_ROVaultNote rvn on rda.NoteID=rvn.NoteID
left join 
Users rus on rus.UserID=rct.ApprovedBy
where convert(date,rct.[Date])=@date and rct.CCID=@counter and rct.IsClosing=1
--and rct.CTID=@bug_id
and rct.CID=@cid
--where convert(date,rct.[Date])='2016-10-05' and rct.CID=1
-- and max(rda.Id)

--select * from tbl_Roi_Data rda




GO
