create procedure [dbo].[usp_L_LaundryMaster_LoadRoom]

as

select * from dbo.RO_restroTable where dbo.RO_restroTable.IsTable=1
