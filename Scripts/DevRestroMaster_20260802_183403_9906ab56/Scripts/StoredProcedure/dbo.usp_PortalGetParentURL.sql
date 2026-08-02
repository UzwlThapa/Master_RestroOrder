SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_PortalGetParentURL] @PortalID INT
AS
  BEGIN
      DECLARE @IsParent BIT =(SELECT isparent
        FROM   Portal
        WHERE  PortalID = @PortalID)

      IF ( @IsParent = 1 )
        BEGIN
            SELECT seoname
            FROM   Portal
            WHERE  PortalID = @PortalID
        END
      ELSE
        BEGIN
            SELECT SEOName
            FROM   Portal
            WHERE  PortalID = (SELECT ParentID
                               FROM   Portal
                               WHERE  PortalID = @PortalID)
        END
  END





GO
