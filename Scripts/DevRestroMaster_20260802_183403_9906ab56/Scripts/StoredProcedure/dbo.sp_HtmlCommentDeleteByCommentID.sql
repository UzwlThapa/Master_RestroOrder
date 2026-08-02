SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: 2010-03-31
-- Description: HTML/Text Module -- Comment section
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_HtmlCommentDeleteByCommentID] 
 -- Add the parameters for the stored procedure here
 @HTMLCommentID INT,
 @PortalID INT,
 @DeletedBy NVARCHAR(256)
AS
BEGIN
UPDATE [dbo].[HtmlComment] SET 
 [IsDeleted] = 1, 
 [DeletedOn] = GETDATE(), 
 [DeletedBy] = @DeletedBy
WHERE
 [HTMLCommentID] = @HTMLCommentID AND [PortalID] = @PortalID
END
/****** Object:  StoredProcedure [dbo].[sp_HtmlCommentGetAllByHTMLTextID]    Script Date: 12/02/2012 13:48:19 ******/
SET ANSI_NULLS ON





GO
