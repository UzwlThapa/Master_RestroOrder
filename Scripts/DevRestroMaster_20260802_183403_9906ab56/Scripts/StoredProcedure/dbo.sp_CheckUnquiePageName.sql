SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:  Milson Munakami
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- Modified By: Dinesh Hona
-- Modified Date: 2010-08-04
-- =============================================

CREATE PROCEDURE [dbo].[sp_CheckUnquiePageName] 
 @PageID int,
 @PortalID int,
 @PageName nvarchar(50), 
 @isEdit bit,
 @pageCount int output
AS
Begin
 --Initilization of output parameter
 Set @pageCount = 0

 --Conditional check
 IF @isEdit = 1
  Begin
   Select @pageCount = IsNull(Count(PageID),0) From dbo.Pages Where PageName = @PageName and PageID <> @PageID AND PortalID = @PortalID AND (IsDeleted=0 OR IsDeleted IS NULL)
  End
 Else
  Begin
   Select @pageCount = IsNull(Count(PageID),0) From dbo.Pages where PageName = @PageName AND PortalID = @PortalID AND (IsDeleted=0 OR IsDeleted IS NULL)
  End
End





GO
