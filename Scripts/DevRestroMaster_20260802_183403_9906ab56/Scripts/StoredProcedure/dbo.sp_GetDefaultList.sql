SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetDefaultList] @PortalID INT,
                                          @Culture  NVARCHAR(256)
AS
  BEGIN
      SELECT DISTINCT TOP 1 listname,
                            parentkey
      FROM   dbo.vw_lists
      WHERE  portalid = @PortalID
             AND parentkey = ''
             AND culture = @Culture
  END





GO
