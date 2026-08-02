SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_RO_SAVEBILLINGTERMDetails]
@BilingID int
,@FromDate nvarchar(max)
,@ToDate nvarchar(max)
,@FromTime nvarchar(max)
,@ToTime nvarchar(max)
,@Sunday bit
,@Monday bit
,@Tuesday bit
,@Wednesday bit
,@Thursday bit
,@Friday bit
,@Saturday bit
as
begin
declare @billdetid int
set @billdetid = (select BillTermDetailsID from RO_BillTermDetails where BilingID=@BilingID)

if (@billdetid>0)
begin
update RO_BillTermDetails set
BilingID = @BilingID,
FromDate=@FromDate,
ToDate=@ToDate,
FromTime=@FromTime,
ToTime=@ToTime,
Sunday=@Sunday,
Monday=@Monday,
Tuesday=@Tuesday,
Wednesday=@Wednesday,
Thursday=@Thursday,
Friday=@Friday,
Saturday=@Saturday
where BillTermDetailsID=@billdetid

end
else
begin
insert into RO_BillTermDetails(
BilingID,
FromDate,
ToDate,
FromTime,
ToTime,
Sunday,
Monday,
Tuesday,
Wednesday,
Thursday,
Friday,
Saturday
)
values(
@BilingID 
,@FromDate 
,@ToDate 
,@FromTime 
,@ToTime 
,@Sunday 
,@Monday 
,@Tuesday 
,@Wednesday 
,@Thursday 
,@Friday 
,@Saturday
)
end
end



GO
