SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: <Create Date,,>
-- Description: <Description,,>
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_GetPermissionByCodeAndKey] 
 -- Add the parameters for the stored procedure here
 @PermissionCode VARCHAR(50),
 @PermissionKey VARCHAR(50)
AS
BEGIN
 SELECT *
  FROM dbo.Permission
  WHERE
   (PermissionCode = @PermissionCode OR @PermissionCode IS NULL)
   AND
   (PermissionKey = @PermissionKey OR @PermissionKey IS NULL)
END
/****** Object:  StoredProcedure [dbo].[sp_GetRoleIDByRoleName]    Script Date: 12/02/2012 13:01:34 ******/
SET ANSI_NULLS ON





GO
