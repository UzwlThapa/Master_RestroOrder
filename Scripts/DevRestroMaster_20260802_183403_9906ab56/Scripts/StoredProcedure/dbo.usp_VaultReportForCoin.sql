SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_VaultReport] 1,'2016-09-13' 
--[dbo].[usp_VaultReportForCoin] 1, '2016-09-13'
--[dbo].[usp_VaultReportForCoin] 2, '2016-09-13'
CREATE PROCEDURE [dbo].[usp_VaultReportForCoin]
@option int,
@dates nvarchar(200)
as
--declare @datee nvarchar(500)
--set @datee=CONVERT(VARCHAR(10),CONVERT(date,@dates),111)
if(@option=1)
begin
select  Note
,(select Number from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and CONVERT(date,[Date])=@dates and NoteID=dbn.NoteID ) as [open]
,(select Number from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where IsClosing=1 and CONVERT(date,[Date])=@dates and NoteID=dbn.NoteID ) as [close],
 CONVERT(date,@dates) as datee
 from tbl_ROVaultNote dbn
where dbn.IsCoin=1
 order by Note desc, dbn.IsCoin asc
end

if(@option=2)
begin
select  Note
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)) and NoteID=dbn.NoteID ) as [open]
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)) and IsClosing=1 and NoteID=dbn.NoteID ) as [close],
 CONVERT(date,@dates) as datee
 from tbl_ROVaultNote dbn
where dbn.IsCoin=1
 order by Note desc, dbn.IsCoin asc
end


--select (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), Month([Date]))) from tbl_ROVaultTotal
--select  Note
--,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
-- where IsClosing=0 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), Month([Date])))=('2016-9')
-- ) as [open] 
--,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
-- where  (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), Month([Date])))=('2016-9')
-- and IsClosing=1 and NoteID=dbn.NoteID ) as [close]
-- --,CONVERT(date,'2016-9') as datee
-- from tbl_ROVaultNote dbn
--where dbn.IsCoin=1
-- order by Note desc, dbn.IsCoin asc
--[dbo].[usp_VaultReportForCoin] 3, '2016-09'
if(@option=3)
begin
select  Note
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates) and NoteID=dbn.NoteID
 ) as [open] 
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where  (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates)
 and IsClosing=1 and NoteID=dbn.NoteID ) as [close]
 ,@dates as datee
 from tbl_ROVaultNote dbn
where dbn.IsCoin=1
 order by Note desc, dbn.IsCoin asc
end

--[dbo].[usp_VaultReportForCoin] 4, '2016'
if(@option=4)
begin
select  Note
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and Year([Date])=Year(@dates) 
 and NoteID=dbn.NoteID) as [open] 
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where Year([Date])=Year(@dates) 
 and IsClosing=1 and NoteID=dbn.NoteID ) as [close],
 CONVERT(date,@dates) as datee
 from tbl_ROVaultNote dbn
where dbn.IsCoin=1
 order by Note desc, dbn.IsCoin asc
end

 --select * from tbl_ROVaultTotal where CONVERT(date,[Date])>=CONVERT(date,'2016-09-13') and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,'2016-09-13'))
--select * from tbl_ROVaultNote order by Note desc
--select * from tbl_Roi_Data
--select * from tbl_ROVaultTotal
--select * from tbl_ROVaultNote
-- select DATEADD(DAY,7,'2016-09-13')








GO
