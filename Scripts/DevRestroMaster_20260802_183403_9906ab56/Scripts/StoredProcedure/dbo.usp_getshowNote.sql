SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_getshowNote] 58
CREATE PROCEDURE [dbo].[usp_getshowNote] 
@ID int
as
--declare @bug_id int
--SELECT @bug_id = MAX(CTID) FROM tbl_CounterTotal where convert(date,[Date])=@date and IsClosing=0 and CCID=@counter and CID=@cid;

--SELECT @bug_id = MAX(CTID) FROM tbl_CounterTotal where convert(date,[Date])='2016-10-18' and IsClosing=0 and CCID=@counter and CID=@cid;
--select @bug_id
select rvn.Note,rda.Number,IsCoin, Balance, convert(date,[Date]) as [date], DifAmount,rus.Username as ApprovedBy, IsClosing , rda.TID,cc.CostCenterName,rct.CID
from tbl_CounterTotal rct
left join
tbl_Roi_Data rda on rct.CTID=rda.CTID
left join 
tbl_ROVaultNote rvn on rda.NoteID=rvn.NoteID
left join 
Users rus on rus.UserID=rct.ApprovedBy
  left join CostCenterInfo cc on cc.CostCenterId=rct.CCID
where rda.CTID=@ID
--and rct.CTID=@bug_id
--ID = (SELECT MAX(ID) FROM bugs) 

--where convert(date,rct.[Date])='2016-10-05' and rct.CID=1
-- and max(rda.Id)

--select * from tbl_Roi_Data rda




GO
