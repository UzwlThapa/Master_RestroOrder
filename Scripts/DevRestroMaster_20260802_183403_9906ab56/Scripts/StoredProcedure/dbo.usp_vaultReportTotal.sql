SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[dbo].[usp_vaultReportTotal] 1, '2016-09-13'
CREATE PROCEDURE [dbo].[usp_vaultReportTotal]
@option int,
@dates nvarchar(200)
as
if(@option=1)
begin
select distinct (select Balance from tbl_ROVaultTotal where IsClosing=0 and convert(date,[Date])=@dates)as openingBlc,
(select Balance from tbl_ROVaultTotal where IsClosing=1 and convert(date,[Date])=@dates)as closingBlc,
(select DiffAmount from tbl_ROVaultTotal where IsClosing=1 and convert(date,[Date])=@dates) as DiffAmount  from tbl_ROVaultTotal dbt 
where convert(date,dbt.[Date])=@dates
end

--[dbo].[usp_vaultReportTotal] 2, '2016-09-13'
if(@option=2)
begin
select  distinct (select sum(Balance) from tbl_ROVaultTotal where IsClosing=0 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)))as openingBlc,
(select sum(Balance) from tbl_ROVaultTotal where IsClosing=1 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)))as closingBlc,
(select sum(DiffAmount) from tbl_ROVaultTotal where IsClosing=1 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates))) as DiffAmount
  from tbl_ROVaultTotal dbt 
--where convert(date,dbt.[Date])=@dates
end

--[dbo].[usp_vaultReportTotal] 3, '2016-9'
if(@option=3)
begin
select distinct (select SUM(Balance) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10),RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates))as openingBlc,
(select SUM(Balance) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates))as closingBlc,
(select sum(DiffAmount) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date]))+'-'+CONVERT(varchar(10), RIGHT('0' + RTRIM(MONTH([Date])), 2)))=CONVERT(varchar(10), @dates)) as DiffAmount
 from tbl_ROVaultTotal dbt 
 --where convert(date,dbt.[Date])=CONVERT(varchar(10), '2016')
 end

--[dbo].[usp_vaultReportTotal] 4,'2016'
 if(@option=4)
begin
 select
  DISTINCT (select SUM(Balance) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date])))=CONVERT(varchar(10), @dates))as openingBlc,
(select SUM(Balance) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date])))=CONVERT(varchar(10), @dates))as closingBlc
,(select SUM(DiffAmount) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date])))=CONVERT(varchar(10), @dates)) as DiffAmount
 from tbl_ROVaultTotal dbt 
--where convert(date,dbt.[Date])=CONVERT(varchar(10), '2016')
end

-- select
--  DISTINCT (select SUM(Balance) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date])))=CONVERT(varchar(10), '2016'))as openingBlc,
--(select SUM(Balance) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date])))=CONVERT(varchar(10), '2016'))as closingBlc
--,(select SUM(DiffAmount) from tbl_ROVaultTotal where IsClosing=1 and (CONVERT(varchar(10), Year([Date])))=CONVERT(varchar(10), '2016')) as DiffAmount
-- from tbl_ROVaultTotal dbt 


--select  Note
--,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID
-- where IsClosing=0 and CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)) and NoteID=dbn.NoteID ) as [open]
--,(select SUM(Number) from tbl_Roi_Data dbd left join tbl_ROVaultTotal dbt on dbd.TID=dbt.TotalID 
-- where CONVERT(date,[Date])>=CONVERT(date,@dates) and CONVERT(date,[Date])<=CONVERT(date,DATEADD(DAY,7,@dates)) and IsClosing=1 and NoteID=dbn.NoteID ) as [close],
-- CONVERT(date,@dates) as datee
-- from tbl_ROVaultNote dbn
--where dbn.IsCoin=1
-- order by Note desc, dbn.IsCoin asc



--select * from tbl_ROVaultTotal




GO
