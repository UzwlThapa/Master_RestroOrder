SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-06-03
-- Description:  ContactUs Module
-- =============================================    
CREATE PROCEDURE [dbo].[sp_ContactUsDeletebyID] @ContactUsID INT,
                                               @PortalID    INT,
                                               @DeletedBy   NVARCHAR(256)
AS
  BEGIN
      UPDATE [dbo].contactus
      SET    [isdeleted] = 1,
             [deletedon] = GETDATE(),
             [deletedby] = @DeletedBy
      WHERE  [contactusid] = @ContactUsID
             AND portalid = @PortalID
  END





GO
