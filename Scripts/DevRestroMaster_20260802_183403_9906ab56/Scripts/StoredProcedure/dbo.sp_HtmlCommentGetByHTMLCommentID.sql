SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Create date: 2010-03-31
-- Description: HTML/Text Module -- Comment section
-- ============================================= 
CREATE PROCEDURE [dbo].[sp_HtmlCommentGetByHTMLCommentID] 
 @PortalID INT,
 @HTMLCommentID INT
AS
BEGIN
 SELECT
 [HTMLCommentID],
 [HTMLTextID],
 [Comment],
 [IsApproved],
 [IsActive],
 [IsDeleted],
 [IsModified],
 [AddedOn],
 [UpdatedOn],
 [DeletedOn],
 [ApprovedOn],
 [PortalID],
 [AddedBy],
 [UpdatedBy],
 [DeletedBy],
 [ApprovedBy]
FROM dbo.[HtmlComment]
WHERE
 [PortalID]=@PortalID AND [HTMLCommentID]=@HTMLCommentID
END





GO
