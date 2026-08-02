SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- ALTER date: 2010-06-03
-- Description:  ContactUs Module
-- =============================================  
CREATE PROCEDURE [dbo].[sp_ContactUsGetAll] @PortalID INT
AS
  BEGIN
      SELECT [contactusid],
             [name],
             [email],
             [message],
             [isactive],
             [isdeleted],
             [ismodified],
             [addedon],
             [updatedon],
             [deletedon],
             [portalid],
             [addedby],
             [updatedby],
             [deletedby]
      FROM   dbo.[contactus]
      WHERE  [portalid] = @PortalID
             AND ( [isdeleted] = 0
                    OR [isdeleted] IS NULL )
             AND [isactive] = 1
  END





GO
