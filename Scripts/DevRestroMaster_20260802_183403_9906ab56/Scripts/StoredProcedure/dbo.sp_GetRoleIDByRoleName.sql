SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetRoleIDByRoleName]   
 -- Add the parameters for the stored procedure here  
 @RoleName VARCHAR(256)  
AS  
BEGIN  
 SET NOCOUNT ON; 
 

  SELECT  [ApplicationId], [RoleId] , [RoleName],[LoweredRoleName] ,[Description]
  FROM  [dbo].[aspnet_Roles]   WITH (NOLOCK)  
  WHERE     (LoweredRoleName = @RoleName OR RoleName = @RoleName)  
END  
/****** Object:  StoredProcedure [dbo].[sp_GetUserActivationCode]    Script Date: 12/02/2012 13:10:50 ******/  
SET ANSI_NULLS ON





GO
