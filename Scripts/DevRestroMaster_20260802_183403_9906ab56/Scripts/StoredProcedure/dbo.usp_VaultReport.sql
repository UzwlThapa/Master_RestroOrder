SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_VaultReport] 1,'2016-09-13' 
--[dbo].[usp_VaultReport] '2016-09-13'
CREATE PROCEDURE[dbo].[usp_VaultReport]
@option int,
@dates nvarchar(200)
as
if(@option=1)
begin
select  Note
,(select Number from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and CONVERT(date,[Date])=@dates and NoteID=dbn.NoteID ) as [open]
,(select Number from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where IsClosing=1 and CONVERT(date,[Date])=@dates and NoteID=dbn.NoteID ) as [close],
           --CAST(CASE 
           --       WHEN dbn.IsCoin = 1 
           --          THEN 'Yes' 
           --       ELSE 'No'
           --  END AS nvarchar) as IsCoin,
			 CONVERT(date,@dates) as [date]
 from tbl_ROVaultNote dbn
where dbn.IsCoin=0 
 order by Note desc, dbn.IsCoin asc
 end
 --[dbo].[usp_VaultReport] 2,'2016-09-13' 
 if(@option=2)
begin
select  Note
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)) and NoteID=dbn.NoteID ) as [open]
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where IsClosing=1 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)) and NoteID=dbn.NoteID ) as [close],
			 CONVERT(date,@dates) as [date]
 from tbl_ROVaultNote dbn
where dbn.IsCoin=0 
 order by Note desc, dbn.IsCoin asc
 end

  --[dbo].[usp_VaultReport] 3,'2016-9' 
 if(@option=3)
begin
select  Note
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates) and NoteID=dbn.NoteID ) as [open]
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where IsClosing=1 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10),RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates) and NoteID=dbn.NoteID ) as [close]
			  ,@dates as datee
 from tbl_ROVaultNote dbn
where dbn.IsCoin=0 
 order by Note desc, dbn.IsCoin asc
 end

  --[dbo].[usp_VaultReport] 4,'2016' 
 if(@option=4)
begin
select  Note
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
 where IsClosing=0 and Year([Date])=Year(@dates) 
 and NoteID=dbn.NoteID ) as [open]
,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
 where IsClosing=1 and Year([Date])=Year(@dates) 
 and NoteID=dbn.NoteID ) as [close],
			 CONVERT(date,@dates) as [date]
 from tbl_ROVaultNote dbn
where dbn.IsCoin=0 
 order by Note desc, dbn.IsCoin asc
 end


-- select  Note
--,(select Number from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
-- where IsClosing=1 and CONVERT(date,[Date])='2016-09-13' and NoteID=tbl_ROVaultNote.NoteID) as [open]
--,(select Number from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
-- where IsClosing=0 and CONVERT(date,[Date])='2016-09-13' and NoteID=tbl_ROVaultNote.NoteID ) as [close]
-- from tbl_ROVaultNote where tbl_ROVaultNote.IsCoin=1 order by Note desc

--select distinct Note,CASE WHEN dbt.IsClosing = 1
--               THEN dbd.Number
--          END AS [open],CASE WHEN dbt.IsClosing = 0
--               THEN dbd.Number
--          END AS [close] from tbl_ROVaultNote  dbn 
--left join tbl_Roi_Data dbd on dbn.NoteID=dbd.NoteID
--left join dbo.tbl_ROVaultTotal dbt  on dbt.TotalID=dbd.TID 
--where CONVERT(date, dbt.[Date])=CONVERT(date,@dates)

-- --group by dbn.Note
--order by dbn.Note desc 

--select distinct * from tbl_Roi_Data dbd 
--left join dbo.tbl_ROVaultTotal dbt  on dbt.TotalID=dbd.TID where CONVERT(date, dbt.Date)=CONVERT(date,'2016-09-13') and dbt.IsClosing=1
--select * from tbl_ROVaultNote order by Note desc
--select * from tbl_Roi_Data
--select * from tbl_ROVaultTotal
--select * from tbl_ROVaultNote








GO
