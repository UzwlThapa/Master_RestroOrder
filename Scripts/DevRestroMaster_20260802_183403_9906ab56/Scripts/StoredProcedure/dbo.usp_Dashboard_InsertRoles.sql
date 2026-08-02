SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--usp_Dashboard_InsertRoles 'cd3ca2e2-7120-44ad-a520-394e76aac552,c38e52e4-cb14-4fdb-a91a-53303991f9ce,910f0c31-e1dd-42d2-988b-545fe8621544' , 1, 'superuser'
CREATE PROCEDURE [dbo].[usp_Dashboard_InsertRoles] @RoleID NVARCHAR(max)
	,@PortalID INT
	,@UserName NVARCHAR(256)
AS
BEGIN
	DELETE
	FROM Dashboard_Roles
	WHERE PortalID = @PortalID

	DECLARE @varSplitXML AS XML
	SET @varSplitXML = cast(('<node>' + replace(@RoleID, ',', '</node><node>') + '</node>') AS XML)
	INSERT INTO Dashboard_Roles (
		RoleID
		,PortalID
		,UpdatedOn
		,UpdatedBy
		)
	SELECT CAST(Node.value('.', 'nvarchar(256)') AS UNIQUEIDENTIFIER)
		,@PortalID
		,GetDate()
		,@UserName
		
	FROM @varSplitXML.nodes('node') AS T(Node)

	EXEC sp_PagePermissionDeleteByPageID 2
		,@PortalID
		,1

	INSERT INTO dbo.pagepermission (
		pageid
		,permissionid
		,allowaccess
		,roleid
		,username
		,isactive
		,addedon
		,portalid
		,addedby
		)
	SELECT 2
		,1
		,1
		,CAST(Node.value('.', 'nvarchar(256)')AS UNIQUEIDENTIFIER)
		,''
		,1
		,GetDate()
		,@PortalID
		,@UserName
	FROM @varSplitXML.nodes('node') AS T(Node)
	
	DECLARE @tmpPageModules table
	(
	UserModuleID INT,
	PortalID INT,
	RowNum INT IDENTITY(1,1)
	)
	DECLARE @Counter INT=1,@RowTotal INT,@UserModuleID INT,@UserPortalID INT
	INSERT INTO  @tmpPageModules
	SELECT UserModuleID,PortalID from PageModules where PageID = 2 and IsActive = 1
	SELECT @RowTotal=@@ROWCOUNT
	
	DECLARE @tmpDashboard_Roles table
	(
		RoleID uniqueidentifier,	
		RowNum INT IDENTITY(1,1)
	)	
	INSERT INTO @tmpDashboard_Roles
	SELECT RoleID FROM Dashboard_Roles
		
	declare @DashboardRoleTotal int
	set @DashboardRoleTotal = (select Count(1) from @tmpDashboard_Roles)
	
	WHILE (@Counter <= @RowTotal)
	BEGIN
		SELECT @UserModuleID=UserModuleID,@UserPortalID=PortalID FROM @tmpPageModules WHERE RowNum=@Counter
		EXEC [dbo].[usp_UserModulePermissionDelete]  @UserModuleID, @UserPortalID		
		Declare @DashboardRoleCount INT = 1;
		While(@DashboardRoleCount <= @DashboardRoleTotal)
		BEGIN		
			 DECLARE @ModuleDefID INT,
					 @AllowAccess BIT,
					 @ModuleRoleID NVARCHAR (100) = NULL,
					 @ModuleUserName NVARCHAR (256) = NULL,
					 @IsActive BIT,
					 @AddedOn DATETIME,
					 @ModulePortalID INT,
					 @AddedBy NVARCHAR (256),
					 @PermissionID INT	
			SELECT @RoleID=RoleID from @tmpDashboard_Roles WHERE RowNum=@DashboardRoleCount
			SELECT @ModuleDefID=mdp.ModuleDefPermissionID,
					@AllowAccess=AllowAccess,
					@ModuleRoleID=RoleID,
					@ModuleUserName=UserName,
					@IsActive=mdp.IsActive,
					@AddedOn=mdp.AddedOn,
					@ModulePortalID=mdp.PortalID,
					@AddedBy=mdp.AddedBy,
					@PermissionID=mdp.PermissionID
				    FROM UserModulePermission ump INNER JOIN   ModuleDefPermission mdp ON ump.ModuleDefPermissionID=mdp.ModuleDefPermissionID  WHERE UserModuleID=2			
			 EXEC [usp_UserModulesPermissionAdd]				 
					@ModuleDefID ,
					@UserModuleID ,
					@AllowAccess ,
					@RoleID,
					@ModuleUserName,
					@IsActive ,
					@AddedOn ,
					@ModulePortalID ,
					@AddedBy,
					@PermissionID
			SET @DashboardRoleCount = @DashboardRoleCount + 1
		END	
		
        SET @Counter=@Counter+1
    END    
END




GO
