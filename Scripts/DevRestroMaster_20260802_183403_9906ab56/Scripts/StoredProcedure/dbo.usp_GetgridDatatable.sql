SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_GetgridDatatable]
as
select usr.Username,usr.AssignedCostCentre, ar.RoleName from users usr
inner join aspnet_Users aspuser on aspuser.UserName = usr.Username
inner join aspnet_UsersInRoles uir on uir.UserId = aspuser.UserId
inner join aspnet_Roles ar on ar.RoleId = uir.RoleId





GO
