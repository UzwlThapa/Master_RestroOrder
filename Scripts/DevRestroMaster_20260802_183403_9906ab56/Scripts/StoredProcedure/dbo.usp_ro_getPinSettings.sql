SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_ro_getPinSettings]
as
select r.LoweredRoleName AS Roles
,ISNULL(p.DisablePin,0) AS DisablePin
 from aspnet_Roles r
left join RO_PinSetting p on r.RoleId = p.RoleId


GO
