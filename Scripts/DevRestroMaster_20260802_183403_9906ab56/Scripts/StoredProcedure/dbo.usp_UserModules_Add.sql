SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UserModules_Add] 
(@ModuleDefID            INT, 
                                 @UserModuleTitle        NVARCHAR(256), 
                                 @AllPages               BIT, 
                                 @ShowInPages            NVARCHAR(256), 
                                 @InheritViewPermissions BIT, 
                                 @Header                 NTEXT, 
                                 @Footer                 NTEXT, 
                                 @StartDate              DATETIME, 
                                 @EndDate                DATETIME, 
                                 @SEOName                NVARCHAR(100), 
                                 @UserModulePermissionID INT OUTPUT, 
                                 @AllowAccess            BIT, 
                                 @RoleID                 UNIQUEIDENTIFIER, 
                                 @UserName               NVARCHAR(256), 
                                 @PageID                 INT, 
                                 @PaneName               NVARCHAR(50), 
                                 @ModuleOrder            INT, 
                                 @CacheTime              INT, 
                                 @Alignment              NVARCHAR(50), 
                                 @Color                  NVARCHAR(20), 
                                 @Border                 NVARCHAR(1), 
                                 @IconFile               NVARCHAR(100), 
                                 @Visibility             INT, 
                                 @DisplayTitle           BIT, 
                                 @DisplayPrint           BIT, 
                                 @IsActive               BIT, 
                                 @AddedOn                DATETIME, 
                                 @PortalID               INT, 
                                 @AddedBy                NVARCHAR(256), 
                                 @ErrorCode              INT OUTPUT) 
AS 
  BEGIN 
      DECLARE @TranStarted BIT 

      SET @TranStarted = 0 

      DECLARE @UserModuleID INT 

      --Begin Transaction 
      IF( @@TRANCOUNT = 0 ) 
        BEGIN 
            BEGIN TRANSACTION 

            SET @TranStarted = 1 
        END 
      ELSE 
        SET @TranStarted = 0 

      --Add User Modules First 
      EXEC [dbo].[usp_UserModulesAdd] 

      IF( @@ERROR <> 0 ) 
        BEGIN 
            SET @ErrorCode = 1 

            GOTO CLEANUP 
        END 

      SET @UserModuleID=SCOPE_IDENTITY() 

      --Add Module Permissions 
      EXEC [dbo].[usp_UserModulesPermissionAdd] 

      IF( @@ERROR <> 0 ) 
        BEGIN 
            SET @ErrorCode = 2 

            GOTO CLEANUP 
        END 

      --Add Page Modules 
      EXEC [dbo].[usp_PageModulesAdd] 

      IF( @@ERROR <> 0 ) 
        BEGIN 
            SET @ErrorCode = 3 

            GOTO CLEANUP 
        END 

      --Cleanup errors encountered 
      CLEANUP: 

      IF( @TranStarted = 1 ) 
        BEGIN 
            SET @TranStarted = 0 

            ROLLBACK TRANSACTION 
        END 

      RETURN @ErrorCode 
  END





GO
