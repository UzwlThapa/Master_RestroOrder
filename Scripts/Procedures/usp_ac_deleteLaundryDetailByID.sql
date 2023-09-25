create procedure [dbo].[usp_ac_deleteLaundryDetailByID]
@lmasterid int
as
delete dbo.L_LaundryDetails where LaundryMasterID=@lmasterid