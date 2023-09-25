
create procedure [dbo].[usp_L_LaundryMaster_ViewAddedLaundry]

as

select top 1 * from dbo.L_LaundryMaster order by dbo.L_LaundryMaster.ID desc

