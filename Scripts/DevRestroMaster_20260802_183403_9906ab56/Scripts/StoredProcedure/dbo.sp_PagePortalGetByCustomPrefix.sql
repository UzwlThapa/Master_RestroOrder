SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATED BY: Dinesh Hona
--CREATED DATE: 2010-07-29
CREATE PROCEDURE [dbo].[sp_PagePortalGetByCustomPrefix] --'---',true,false,1,'superuser',null,null
 @prefix [nvarchar](10),
 @IsActive [bit],
 @IsDeleted [bit],
 @PortalID [int],
 @UserName [nvarchar](256),
 @IsVisible [bit],
 @IsRequiredPage bit
WITH EXECUTE AS CALLER
AS
BEGIN
select * from pages where portalid=@PortalID or portalid=-1
END





GO
