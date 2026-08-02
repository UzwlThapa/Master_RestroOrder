SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[getUserbyLaundryRole]
as
select au.UserId, au.UserName from vw_aspnet_Users au 
join aspnet_UsersInRoles aur on au.UserId=aur.UserId
join aspnet_Roles ar on ar.RoleId=aur.RoleId where LoweredRoleName='laundry'


GO
