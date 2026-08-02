SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2011-1-17
-- Description:  Check Unique ControlType -- only one type of control can EXISTS for one module
-- =============================================
CREATE PROCEDURE [dbo].[sp_CheckUnquieModuleControlsControlType] 
  @ModuleControlID INT,
        @ModuleDefID INT,                                  
  @ControlType INT,
  @PortalID     INT,                                                         
    @isEdit BIT,   
    @COUNT INT output
AS
  BEGIN
      SET @COUNT = 0

      IF @isEdit = 1
        BEGIN
            SELECT @ModuleDefID = moduledefid
            FROM   dbo.modulecontrols
            WHERE  modulecontrolid = @ModuleControlID
                   AND portalid = @PortalID
                   AND ( isdeleted = 0
                          OR isdeleted IS NULL )

            SELECT @COUNT = ISNULL(COUNT(modulecontrolid), 0)
            FROM   dbo.modulecontrols
            WHERE  controltype = @ControlType
                   AND modulecontrolid <> @ModuleControlID
                   AND moduledefid = @ModuleDefID
                   AND portalid = @PortalID
                   AND ( isdeleted = 0
                          OR isdeleted IS NULL )
        END
      ELSE
        BEGIN
            SELECT @COUNT = ISNULL(COUNT(modulecontrolid), 0)
            FROM   dbo.modulecontrols
            WHERE  controltype = @ControlType
                   AND moduledefid = @ModuleDefID
                   AND portalid = @PortalID
                   AND ( isdeleted = 0
                          OR isdeleted IS NULL )
        END

      PRINT @COUNT
  END





GO
