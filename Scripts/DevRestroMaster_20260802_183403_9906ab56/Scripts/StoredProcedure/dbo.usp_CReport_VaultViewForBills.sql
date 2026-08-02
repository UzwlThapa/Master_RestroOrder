SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_CReport_VaultViewForBills] '2016-10-21'
CREATE PROCEDURE [dbo].[usp_CReport_VaultViewForBills] 
@date nvarchar(256)
as
select rvn.Note,rda.Number,IsCoin, rvt.Balance, convert(date,rvt.[Date]) as [date], rvt.DiffAmount, rvt.IsClosing , rda.TID, rda.TID,rvn.NoteID,rvt.ApprovedBy
from tbl_ROVaultTotal rvt
left join
tbl_Roi_Data rda on rvt.TotalID=rda.TID
left join 
tbl_ROVaultNote rvn on rda.NoteID=rvn.NoteID
left join Users rus on rus.UserID=rvt.ApprovedBy
--,dbo.RO_Currency dbc 
where convert(date,rvt.[Date])=@date and rvt.IsClosing=0 and rvn.IsCoin=0
--where convert(date,rvt.[Date])='2016-10-05'
-- and max(rda.Id)

--select * from tbl_Roi_Data rda
--select * from tbl_ROVaultTotal rda
--select * from tbl_ROVaultTotal where convert(date,[Date])='2016/10/23'




GO
