SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--USP_RO_GetUsersDetail '04F7D673-12B2-4011-8F16-681E22BF3FC0',''
--USP_RO_GetUsersDetail '195F9255-4436-4893-8D22-51CDF42DF329'
CREATE PROCEDURE [dbo].[USP_RO_GetUsersDetail]
@UserId nvarchar(max),
@Username nvarchar(max)
as
select us.UserName,ro.RoleName as RoleNames FROM aspnet_Users us
inner join aspnet_UsersInRoles ur on us.UserId=ur.UserId
inner join aspnet_roles ro on ro.RoleId=ur.RoleId
where us.UserId = @UserId
--and 
--select * from aspnet_Users us
--select * from aspnet_roles ro 
--select * from aspnet_UsersInRoles ur




GO
